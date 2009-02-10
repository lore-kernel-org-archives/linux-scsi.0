From: "Karen Xie" <kxie@chelsio.com>
Subject: RE: [PATCH 3/5 2.6.29-rc] cxgb3i -- tx pdu need to observe skb's MAX_SKB_FRAGS
Date: Tue, 10 Feb 2009 10:19:26 -0800
Message-ID: <8A71B368A89016469F72CD08050AD3340465809D@maui.asicdesigners.com>
References: <200902100210.n1A2ALEc019820@localhost.localdomain> <49910F84.7090707@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:23118 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbZBJSTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Feb 2009 13:19:00 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Hi, Mike,

My comments in-line below.

Thanks,
Karen

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Monday, February 09, 2009 9:24 PM
To: Karen Xie
Cc: open-iscsi@googlegroups.com; linux-scsi@vger.kernel.org;
James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH 3/5 2.6.29-rc] cxgb3i -- tx pdu need to observe
skb's MAX_SKB_FRAGS

Karen Xie wrote:
> [PATCH 3/5 2.6.29-rc] cxgb3i -- tx pdu need to observe skb's
MAX_SKB_FRAGS
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> While fitting the whole pdu into a skb, need to observe the max. # of
fragments in skb (MAX_SKB_FRAGS).  Allow max. payload size and check for
# of scatter-gather entries it may use when allocating the pdus for
transmit. If the data can not fit into the skb's frag list, copy the
data.
> 
> Signed-off-by: Karen Xie <kxie@chelsio.com>
> ---
> 
>  drivers/scsi/cxgb3i/cxgb3i_pdu.c |  410
++++++++++++++++++++++++++++++--------
>  drivers/scsi/cxgb3i/cxgb3i_pdu.h |   15 +
>  2 files changed, 337 insertions(+), 88 deletions(-)
> 
> 
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
> index ce7ce8c..165fb75 100644
> --- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
> +++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
> @@ -32,6 +32,10 @@
>  #define cxgb3i_tx_debug(fmt...)
>  #endif
>  
> +#define SKB_TX_HEADROOM		SKB_MAX_HEAD(TX_HEADER_LEN)
> +/* always allocate rooms for AHS */
> +#define SKB_TX_PDU_HEADER_LEN	\
> +	(sizeof(struct iscsi_hdr) + ISCSI_MAX_AHS_SIZE)
>  static struct page *pad_page;
>  
>  /*
> @@ -146,12 +150,18 @@ static inline void tx_skb_setmode(struct sk_buff
*skb, int hcrc, int dcrc)
>  
>  void cxgb3i_conn_cleanup_task(struct iscsi_task *task)
>  {
> -	struct iscsi_tcp_task *tcp_task = task->dd_data;
> +	struct cxgb3i_task_data *tdata = task->dd_data +
> +					sizeof(struct iscsi_tcp_task);
> +	int i;
>  
>  	/* never reached the xmit task callout */
> -	if (tcp_task->dd_data)
> -		kfree_skb(tcp_task->dd_data);
> -	tcp_task->dd_data = NULL;
> +	for (i = 0; i < MAX_PDU_FULL_PAGES; i++)
> +		if (tdata->pages[i])
> +			__free_page(tdata->pages[i]);
> +
> +	if (tdata->skb)
> +		__kfree_skb(tdata->skb);
> +	memset(tdata, 0, sizeof(struct cxgb3i_task_data));
>  
>  	/* MNC - Do we need a check in case this is called but
>  	 * cxgb3i_conn_alloc_pdu has never been called on the task */
> @@ -159,27 +169,162 @@ void cxgb3i_conn_cleanup_task(struct iscsi_task
*task)
>  	iscsi_tcp_cleanup_task(task);
>  }
>  
> -/*
> - * We do not support ahs yet
> - */
> +static int sgl_seek_offset(struct scatterlist *sgl, unsigned int
sgcnt,
> +				unsigned int offset, unsigned int *off,
> +				struct scatterlist **sgp)
> +{
> +	int i;
> +	struct scatterlist *sg;
> +
> +	for_each_sg(sgl, sg, sgcnt, i) {
> +		if (offset < sg->length) {
> +			*off = offset;
> +			*sgp = sg;
> +			return 0;
> +		}
> +		offset -= sg->length;
> +	}
> +	return -EFAULT;
> +}
> +
> +static int sgl_read_to_frags(struct scatterlist *sg, unsigned int
sgoffset,
> +				unsigned int dlen, skb_frag_t *frags,
> +				int frag_max)
> +{
> +	unsigned int datalen = dlen;
> +	unsigned int sglen = sg->length - sgoffset;
> +	struct page *page = sg_page(sg);
> +	int i;
> +
> +	i = 0;
> +	do {
> +		unsigned int copy;
> +
> +		if (!sglen) {
> +			sg = sg_next(sg);
> +			if (!sg) {
> +				cxgb3i_log_error("%s, sg NULL, len
%u/%u.\n",
> +						 __func__, datalen,
dlen);
> +				return -EINVAL;
> +			}
> +			sgoffset = 0;
> +			sglen = sg->length;
> +			page = sg_page(sg);
> +
> +		}
> +		copy = min(datalen, sglen);
> +		if (i && page == frags[i - 1].page &&



I always forget this. I just want to make sure. It is only the same frag

if it is the same page? If the pages were contiguous it still has to be 
different frags?

[Karen] It is the same page. This is really for backward compatibility
since the frag->size used to be 16 bit integer.


> +		    sgoffset + sg->offset ==
> +			frags[i - 1].page_offset + frags[i - 1].size) {
> +			frags[i - 1].size += copy;
> +		} else {
> +			if (i >= frag_max) {
> +				cxgb3i_log_error("%s, too many pages %u,
"
> +						 "dlen %u.\n", __func__,
> +						 frag_max, dlen);
> +				return -EINVAL;
> +			}
> +
> +			frags[i].page = page;
> +			frags[i].page_offset = sg->offset + sgoffset;
> +			frags[i].size = copy;
> +			i++;
> +		}
> +		datalen -= copy;
> +		sgoffset += copy;
> +		sglen -= copy;
> +	} while (datalen);
> +
> +	return i;
> +}
> +		
> +static inline int task_data_fill_pages(struct cxgb3i_task_data
*tdata)
> +{
> +	int i;
> +	for (i = 0; i < tdata->nr_pages; i++)
> +		if (!tdata->pages[i]) {
> +			tdata->pages[i] = alloc_page(GFP_ATOMIC);
> +			if (!tdata->pages[i])
> +				return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
>  int cxgb3i_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
>  {
> +	struct iscsi_conn *conn = task->conn;
>  	struct iscsi_tcp_task *tcp_task = task->dd_data;
> -	struct sk_buff *skb;
> +	struct cxgb3i_task_data *tdata = task->dd_data +
sizeof(*tcp_task);
> +	struct scsi_cmnd *sc = task->sc;
> +	int headroom = SKB_TX_PDU_HEADER_LEN;
> +	int skb_flag = 0;
> +	int err;
>  
> +	tcp_task->dd_data = tdata;
>  	task->hdr = NULL;
> -	/* always allocate rooms for AHS */
> -	skb = alloc_skb(sizeof(struct iscsi_hdr) + ISCSI_MAX_AHS_SIZE +
> -			TX_HEADER_LEN,  GFP_ATOMIC);
> -	if (!skb)
> +
> +	/* write command, need to send data pdus */
> +	if (sc &&
> +	    (scsi_bidi_cmnd(sc) || sc->sc_data_direction ==
DMA_TO_DEVICE)) {
> +		struct scsi_data_buffer *sdb = scsi_out(task->sc);
> +		struct scatterlist *sg = NULL;
> +
> +		/*
> +		 * calculate the pdu payload data.
> +		 * Since only MaxOutstandingR2T=1,
DataSequenceInOrder=Yes,
> +		 * and DataPDUInOrder=Yes are supported, we can safely
assume
> +		 * the data will be sent sequentially and each pdu will
carry
> +		 * no more than conn->max_xmit_dlength bytes of payload.
> +		 */
> +		err = sgl_seek_offset(sdb->table.sgl, sdb->table.nents,
> +					tdata->offset, &tdata->sgoffset,
&sg);
> +		if (err < 0) {
> +			cxgb3i_log_warn("tpdu, sgl %u, bad offset
%u/%u.\n",
> +					sdb->table.nents, tdata->offset,
> +					sdb->length);
> +			return err;
> +		}
> +		tdata->count = min(sdb->length - tdata->offset,
> +					conn->max_xmit_dlength);

I don't think this is right. Either that or libiscsi is not. If you had 
immediate data enabled and had a first burst that was less than 
max_xmit_dlength count would be first burst. Or if you do not have imm 
data enabled then you are going to send data when the target cannot 
handle it.

You really got to do this in the pdu init because at pdu alloc time we 
do not know how much data there is to be sent yet.

If we need that info at this time (I think it would make it nicer) then 
we need to rearrange iscsi_prep_scsi_cmd_pdu and iscsi_tcp_task_xmit so 
they figure out the len then alloc the pdu.

[Karen] The max. payload is calculated so the memory needed is allocated
but the actual payload sent is in alloc_pdu() where offset and count is
checked again exactly for this reason. I thought of changing libiscsi.c,
it is definitely easier and clearner.

> +		err = sgl_read_to_frags(sg, tdata->sgoffset,
tdata->count,
> +					tdata->frags, MAX_PDU_FRAGS);
> +		if (err < 0) {


I do not think this is safe. If I am in the middle of writing out my mp3

collection and then we get a bad command, then we lost data and there 
will be a screeching in my ear next time I try to listen.

In the worst case can you we set the max xmit seg len to the safest 
value and  that would still allow around 16 K pdus? (32 frags (32 == 
about MAX_PDU_FRAGS) *  512 bytes (each frag with a different page and 
each frag only containing 512 bytes of data)).

Did you say that 8K was around the optimal size? Could we just set it to

that or is 8 K only nice on the recv path?

What is cconn->hba->snic->tx_max_size normally? 

[Karen] Normally tx_max_size is around 16K. 

> +			cxgb3i_log_warn("tpdu, sgl %u, bad offset %u +
%u.\n",
> +					sdb->table.nents, tdata->offset,
> +					tdata->count);
> +			return err;
> +		}
> +		tdata->nr_frags = err;
> +		/*
> +		 * make sure the payload can fit into one skb, if not we
will
> +		 * copy the data either into skb headroom or into full
pages.
> +		 */
> +		if (tdata->nr_frags >= MAX_SKB_FRAGS) {


I guess archs like ppc64 are the problem here, right (MAX_SKB_FRAGS is 
small due to large page size)?

[Karen] Yes, I only encounter this issue on PPC64 where the host page
size is 64K so the MAX_SKB_FRAGS is only 3. I will add code to adjust
the cconn->hba->snic->tx_max_size accordingly.

> +			if (SKB_TX_HEADROOM <
> +				(headroom + tdata->count)) {
> +				tdata->nr_pages = (tdata->count +
> +						PAGE_SIZE - 1) >>
PAGE_SHIFT;
> +				err = task_data_fill_pages(tdata);

You really do not want to be allocating memory in this path. I know we 
used to allocate the entire skb in here and we still allocate the skb 
below, but that was just due to there not being many alternatives.

Can we set some value so that we can remove a memory allocation and so 
we do not hit this? Can we set max xmit seg len so we do not have to 
allocate memory here?

[Karen] yes, I will adjust the max xmit se glen according to the skb
max. size and assume each frag holds 512 bytes only.

> +				if (err < 0)
> +					return err;
> +				skb_flag = PDU_SKB_FLAG_COPY_PAGE;
> +			} else {
> +				headroom += tdata->count;
> +				skb_flag = PDU_SKB_FLAG_COPY_HEAD;
> +			}
> +		}
> +	}
> +
> +	tdata->skb = alloc_skb(TX_HEADER_LEN + headroom, GFP_ATOMIC);
> +	if (!tdata->skb)
>  		return -ENOMEM;
> +	skb_reserve(tdata->skb, TX_HEADER_LEN);
> +	PDU_SKB_CB(tdata->skb)->flags = skb_flag;
>  
>  	cxgb3i_tx_debug("task 0x%p, opcode 0x%x, skb 0x%p.\n",
> -			task, opcode, skb);
> +			task, opcode, tdata->skb);
>  
> -	tcp_task->dd_data = skb;
> -	skb_reserve(skb, TX_HEADER_LEN);
> -	task->hdr = (struct iscsi_hdr *)skb->data;
> +	task->hdr = (struct iscsi_hdr *)tdata->skb->data;
>  	task->hdr_max = sizeof(struct iscsi_hdr);
>  
>  	/* data_out uses scsi_cmd's itt */
> @@ -189,110 +334,193 @@ int cxgb3i_conn_alloc_pdu(struct iscsi_task
*task, u8 opcode)
>  	return 0;
>  }
>  
> +static int skb_copy_frags_to_pages(struct cxgb3i_task_data *tdata)
> +{
> +	struct sk_buff *skb = tdata->skb;
> +	unsigned char *dst = page_address(tdata->pages[0]);
> +	skb_frag_t *frag = tdata->frags;
> +	unsigned char *src;
> +	unsigned int pg_left = PAGE_SIZE;
> +	unsigned int copy_total = 0;
> +	int i, j;
> +
> +	for (i = 0, j = 0; i < tdata->nr_frags; i++, frag++) {
> +		unsigned int len = frag->size;
> +
> +		src = page_address(frag->page) + frag->page_offset;


I think you need kmap_atomic instead of page_address.

[Karen] Thanks, will change it.

> +		while (len) {
> +			unsigned int copy;
> +
> +			if (pg_left == PAGE_SIZE) {
> +				tdata->pages[j] = NULL;
> +				dst = page_address(tdata->pages[j]);
> +				skb_fill_page_desc(skb, j,
tdata->pages[j],
> +							0, 0);
> +			}
> +
> +			copy = min(pg_left, frag->size);
> +			memcpy(dst, src, copy);
> +
> +			skb_shinfo(skb)->frags[j].size += copy;
> +			len -= copy;
> +			src += copy;
> +			dst += copy;
> +			pg_left -= copy;
> +			copy_total += copy;
> +
> +			if (!pg_left) {
> +				j++;
> +				pg_left = PAGE_SIZE;
> +			}
> +		}
> +	}
> +	skb->len += copy_total;
> +	skb->data_len += copy_total;
> +	skb->truesize += copy_total;
> +
> +	return copy_total;
> +}
> +
> +
>  int cxgb3i_conn_init_pdu(struct iscsi_task *task, unsigned int
offset,
>  			      unsigned int count)
>  {
> -	struct iscsi_tcp_task *tcp_task = task->dd_data;
> -	struct sk_buff *skb = tcp_task->dd_data;
>  	struct iscsi_conn *conn = task->conn;
> -	struct page *pg;
> +	struct iscsi_tcp_task *tcp_task = task->dd_data;
> +	struct cxgb3i_task_data *tdata = tcp_task->dd_data;
> +	struct sk_buff *skb = tdata->skb;
>  	unsigned int datalen = count;
> +	u8 skb_flag = PDU_SKB_CB(skb)->flags;
>  	int i, padlen = iscsi_padding(count);
> -	skb_frag_t *frag;
> +	int err;
> +	struct page *pg;
>  
>  	cxgb3i_tx_debug("task 0x%p,0x%p, offset %u, count %u, skb
0x%p.\n",
>  			task, task->sc, offset, count, skb);
>  
> +	memset(PDU_SKB_CB(skb), 0, sizeof(struct pdu_skb_cb));
>  	skb_put(skb, task->hdr_len);
>  	tx_skb_setmode(skb, conn->hdrdgst_en, datalen ?
conn->datadgst_en : 0);
>  	if (!count)
>  		return 0;
>  
>  	if (task->sc) {
> -		struct scatterlist *sg;
> -		struct scsi_data_buffer *sdb;
> -		unsigned int sgoffset = offset;
> -		struct page *sgpg;
> -		unsigned int sglen;
> -
> -		sdb = scsi_out(task->sc);
> -		sg = sdb->table.sgl;
> -
> -		for_each_sg(sdb->table.sgl, sg, sdb->table.nents, i) {
> -			cxgb3i_tx_debug("sg %d, page 0x%p, len %u offset
%u\n",
> -					i, sg_page(sg), sg->length,
sg->offset);
> -
> -			if (sgoffset < sg->length)
> -				break;
> -			sgoffset -= sg->length;
> +		struct scsi_data_buffer *sdb = scsi_out(task->sc);
> +
> +		if (offset != tdata->offset) {


Do you hit this for writes?

After pdu alloc is called tdata->offset is 0. Then here when 
iscsi_tcp_task_init is called for the first iscsi scsi cmd pdu offset 
will be 0, so we will not hit it.

Then iscsi_tcp_task_xmit will call pdu alloc to send pdus in response to

r2ts. It will then also call init pdu with some data offset, but for 
this tdata->offset and offset will be equal because data is in order and

because below you update the tdata->offset to the new offset 
(tdata->offset = offset + count). So we will not hit it.

Also in pdu alloc you always run this and we always call pdu alloc and 
then call pdu init right after, so there should be no reason to do this 
prep work again.

I think you can make this chunk where you call sgl_read_to_frags and 
slg_seek_offset more generica and always call in the pdu init instead of

both in pdu init and pdu alloc.

Or if we are going to change pdu alloc so it has the length, we can just

kill the pdu init call and merge it with the pdu init and pdu alloc 
callout. The only reason they are separate is because at pdu alloc time 
we did not know the len and we did at pdu init time.

[Karen] Yes, there is no need in checking for matching offset. I will go
ahead and try to merge the pdu_alloc() and pdu_init(), will send the
patch out later today for you to review.


> +			struct scatterlist *sg = NULL;
> +
> +			tdata->offset = offset;
> +			err = sgl_seek_offset(sdb->table.sgl,
sdb->table.nents,
> +						offset,
&tdata->sgoffset, &sg);
> +			if (err < 0)
> +				return err;
> +			err = sgl_read_to_frags(sg, tdata->sgoffset,
> +						count, tdata->frags,
> +						MAX_PDU_FRAGS);
> +			if (err < 0)
> +				return err;
> +			tdata->nr_frags = err;
> +			tdata->count = count;
>  		}
> -		sgpg = sg_page(sg);
> -		sglen = sg->length - sgoffset;
>  
> -		do {
> -			int j = skb_shinfo(skb)->nr_frags;
> -			unsigned int copy;
> +		if (count < tdata->count) {
> +			unsigned int dlen = count;
> +			skb_frag_t *frag = tdata->frags;
>  
> -			if (!sglen) {
> -				sg = sg_next(sg);
> -				sgpg = sg_page(sg);
> -				sgoffset = 0;
> -				sglen = sg->length;
> -				++i;
> +			for (i = 0; i < tdata->nr_frags; i++, frag++) {
> +				if (dlen < frag->size)
> +					break;
> +				dlen -= frag->size;
>  			}
> -			copy = min(sglen, datalen);
> -			if (j && skb_can_coalesce(skb, j, sgpg,
> -						  sg->offset +
sgoffset)) {
> -				skb_shinfo(skb)->frags[j - 1].size +=
copy;
> +			tdata->nr_frags = i;
> +			frag->size = dlen;
> +		}
> +
> +		if (tdata->nr_frags > MAX_SKB_FRAGS ||
> +			(padlen && (tdata->nr_frags + 1) >
MAX_SKB_FRAGS)) {
> +			if (!skb_flag) {
> +				cxgb3i_log_warn("frag %u, skb not set up
%u.\n",
> +						tdata->nr_frags,
padlen);
> +				return -EINVAL;
> +			}
> +
> +			if (skb_flag == PDU_SKB_FLAG_COPY_HEAD) {
> +				char *dst = skb->data + task->hdr_len;
> +				skb_frag_t *frag = tdata->frags;
> +
> +				/* data fits in the skb's headroom */
> +				for (i = 0; i < tdata->nr_frags; i++,
frag++) {
> +					memcpy(dst,
> +						page_address(frag->page)
+
> +						frag->page_offset,
frag->size);
> +					dst += frag->size;
> +				}
> +				if (padlen) {
> +					memset(dst, 0, padlen);
> +					padlen = 0;
> +				}
> +				skb_put(skb, count + padlen);
>  			} else {
> -				get_page(sgpg);
> -				skb_fill_page_desc(skb, j, sgpg,
> -						   sg->offset +
sgoffset, copy);
> +				err = skb_copy_frags_to_pages(tdata);
> +				if (err != count) {
> +					cxgb3i_log_warn("skb copy %u !=
%d.\n",
> +							count, err);
> +					return -EINVAL;
> +				}
>  			}
> -			sgoffset += copy;
> -			sglen -= copy;
> -			datalen -= copy;
> -		} while (datalen);
> +		} else {
> +			/* data fit into frag_list */
> +			for (i = 0; i < tdata->nr_frags; i++)
> +				get_page(tdata->frags[i].page);
> +
> +			memcpy(skb_shinfo(skb)->frags, tdata->frags,
> +				sizeof(skb_frag_t) * tdata->nr_frags);
> +			skb_shinfo(skb)->nr_frags = tdata->nr_frags;
> +
> +			skb->len += count;
> +			skb->data_len += count;
> +			skb->truesize += count;
> +		}
> +
> +		/*
> +		 * update the offset so we know where to start for the
next
> +		 * alloc_pdu()
> +		 */
> +		tdata->offset = offset + count;
> +		tdata->count = 0;
>  	} else {
>  		pg = virt_to_page(task->data);
>  
> -		while (datalen) {
> -			i = skb_shinfo(skb)->nr_frags;
> -			frag = &skb_shinfo(skb)->frags[i];
> -
> -			get_page(pg);
> -			frag->page = pg;
> -			frag->page_offset = 0;
> -			frag->size = min((unsigned int)PAGE_SIZE,
datalen);
> -
> -			skb_shinfo(skb)->nr_frags++;
> -			datalen -= frag->size;
> -			pg++;
> -		}
> +		get_page(pg);
> +		skb_fill_page_desc(skb, 0, pg,
offset_in_page(task->data),
> +					count);
> +		skb->len += count;
> +		skb->data_len += count;
> +		skb->truesize += count;
>  	}
>  
>  	if (padlen) {
>  		i = skb_shinfo(skb)->nr_frags;
> -		frag = &skb_shinfo(skb)->frags[i];
> -		frag->page = pad_page;
> -		frag->page_offset = 0;
> -		frag->size = padlen;
> -		skb_shinfo(skb)->nr_frags++;
> +		get_page(pad_page);
> +		skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags,
pad_page, 0,
> +				 padlen);
> +
> +		skb->data_len += padlen;
> +		skb->truesize += padlen;
> +		skb->len += padlen;
>  	}
>  
> -	datalen = count + padlen;
> -	skb->data_len += datalen;
> -	skb->truesize += datalen;
> -	skb->len += datalen;
>  	return 0;
>  }
>  
>  int cxgb3i_conn_xmit_pdu(struct iscsi_task *task)
>  {
> -	struct iscsi_tcp_task *tcp_task = task->dd_data;
> -	struct sk_buff *skb = tcp_task->dd_data;
>  	struct iscsi_tcp_conn *tcp_conn = task->conn->dd_data;
>  	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
> +	struct iscsi_tcp_task *tcp_task = task->dd_data;
> +	struct cxgb3i_task_data *tdata = tcp_task->dd_data;
> +	struct sk_buff *skb = tdata->skb;
>  	unsigned int datalen;
>  	int err;
>  
> @@ -300,13 +528,14 @@ int cxgb3i_conn_xmit_pdu(struct iscsi_task
*task)
>  		return 0;
>  
>  	datalen = skb->data_len;
> -	tcp_task->dd_data = NULL;
> +	tdata->skb = NULL;
>  	err = cxgb3i_c3cn_send_pdus(cconn->cep->c3cn, skb);
> -	cxgb3i_tx_debug("task 0x%p, skb 0x%p, len %u/%u, rv %d.\n",
> -			task, skb, skb->len, skb->data_len, err);
>  	if (err > 0) {
>  		int pdulen = err;
>  
> +	cxgb3i_tx_debug("task 0x%p, skb 0x%p, len %u/%u, rv %d.\n",
> +			task, skb, skb->len, skb->data_len, err);
> +
>  		if (task->conn->hdrdgst_en)
>  			pdulen += ISCSI_DIGEST_SIZE;
>  		if (datalen && task->conn->datadgst_en)
> @@ -325,7 +554,7 @@ int cxgb3i_conn_xmit_pdu(struct iscsi_task *task)
>  		return err;
>  	}
>  	/* reset skb to send when we are called again */
> -	tcp_task->dd_data = skb;
> +	tdata->skb = skb;
>  	return -EAGAIN;
>  }
>  
> @@ -366,7 +595,9 @@ void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn)
>  	skb = skb_peek(&c3cn->receive_queue);
>  	while (!err && skb) {
>  		__skb_unlink(skb, &c3cn->receive_queue);
> -		read += skb_ulp_pdulen(skb);
> +		read += skb_rx_pdulen(skb);
> +		cxgb3i_rx_debug("conn 0x%p, cn 0x%p, rx skb 0x%p, pdulen
%u.\n",
> +				conn, c3cn, skb, skb_rx_pdulen(skb));
>  		err = cxgb3i_conn_read_pdu_skb(conn, skb);
>  		__kfree_skb(skb);
>  		skb = skb_peek(&c3cn->receive_queue);
> @@ -377,6 +608,11 @@ void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn)
>  		cxgb3i_c3cn_rx_credits(c3cn, read);
>  	}
>  	conn->rxdata_octets += read;
> +
> +	if (err) {
> +		cxgb3i_log_info("conn 0x%p rx failed err %d.\n", conn,
err);
> +		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
> +	}
>  }
>  
>  void cxgb3i_conn_tx_open(struct s3_conn *c3cn)
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.h
b/drivers/scsi/cxgb3i/cxgb3i_pdu.h
> index a3f685c..0d12892 100644
> --- a/drivers/scsi/cxgb3i/cxgb3i_pdu.h
> +++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.h
> @@ -33,6 +33,19 @@ struct cpl_rx_data_ddp_norss {
>  	u32 ddp_status;
>  };
>  
> +/**
> + * pdu_skb_cb - control block for transmit pdu skb information.
> + *
> + * @flag:	see PDU_SKB_FLAG_xxx below
> + */
> +#define PDU_SKB_FLAG_COPY_HEAD	0x1
> +#define PDU_SKB_FLAG_COPY_PAGE	0x2
> +struct pdu_skb_cb {
> +	__u8 flags;
> +};
> +#define PDU_SKB_CB(skb)       ((struct pdu_skb_cb *)&((skb)->cb[0]))
> +
> +
>  #define RX_DDP_STATUS_IPP_SHIFT		27	/* invalid
pagepod */
>  #define RX_DDP_STATUS_TID_SHIFT		26	/* tid mismatch
*/
>  #define RX_DDP_STATUS_COLOR_SHIFT	25	/* color mismatch */
> @@ -53,7 +66,7 @@ struct cpl_rx_data_ddp_norss {
>  #define ULP2_FLAG_DCRC_ERROR		0x20
>  #define ULP2_FLAG_PAD_ERROR		0x40
>  
> -void cxgb3i_conn_closing(struct s3_conn *);
> +void cxgb3i_conn_closing(struct s3_conn *c3cn);
>  void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn);
>  void cxgb3i_conn_tx_open(struct s3_conn *c3cn);
>  #endif

