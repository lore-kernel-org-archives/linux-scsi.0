From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/4] libosd: write/read_sg_kern API
Date: Tue, 19 Oct 2010 16:13:01 +0200
Message-ID: <4CBDA76D.2030708@panasas.com>
References: <4CBD8CAB.2030207@panasas.com> <1287490962-24013-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:52151 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751219Ab0JSONG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2010 10:13:06 -0400
In-Reply-To: <1287490962-24013-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, John Chandy <john.chandy@uconn.edu>, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 10/19/2010 02:22 PM, Boaz Harrosh wrote:
> From: John A. Chandy <john.chandy@uconn.edu>
> 
> This is a trivial addition to the SG API that can receive kernel
> pointers. It is only used by the out-of-tree test module. So
> it's immediate need is questionable. For maintenance ease it might
> just get in, as it's very small.
> 
> John.
> do you need this in the Kernel, or is it only for osd_ktest.ko?
> 
> Signed-off-by: John A. Chandy <john.chandy@uconn.edu>
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/osd/osd_initiator.c |   71 ++++++++++++++++++++++++++++++++++++++

I forgot the header declarations, Resending version 2

Boaz


>  1 files changed, 71 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index f5b5735..0433ea6 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -1015,6 +1015,77 @@ int osd_req_read_sg(struct osd_request *or,
>  }
>  EXPORT_SYMBOL(osd_req_read_sg);
>  
> +/* SG-list write/read Kern API
> + *
> + * osd_req_{write,read}_sg_kern takes an array of @buff pointers and an array
> + * of sg_entries. @numentries indicates how many pointers and sg_entries there
> + * are.  By requiring an array of buff pointers. This allows a caller to do a
> + * single write/read and scatter into multiple buffers.
> + * NOTE: Each buffer + len should not cross a page boundary.
> + */
> +static struct bio *_create_sg_bios(struct osd_request *or,
> +	void **buff, const struct osd_sg_entry *sglist, unsigned numentries)
> +{
> +	struct request_queue *q = osd_request_queue(or->osd_dev);
> +	struct bio *bio;
> +	unsigned i;
> +
> +	bio = bio_kmalloc(GFP_KERNEL, numentries);
> +	if (unlikely(!bio)) {
> +		OSD_DEBUG("Faild to allocate BIO size=%u\n", numentries);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	for (i = 0; i < numentries; i++) {
> +		unsigned offset = offset_in_page(buff[i]);
> +		struct page *page = virt_to_page(buff[i]);
> +		unsigned len = sglist[i].len;
> +		unsigned added_len;
> +
> +		BUG_ON(offset + len > PAGE_SIZE);
> +		added_len = bio_add_pc_page(q, bio, page, len, offset);
> +		if (unlikely(len != added_len)) {
> +			OSD_DEBUG("bio_add_pc_page len(%d) != added_len(%d)\n",
> +				  len, added_len);
> +			bio_put(bio);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +	}
> +
> +	return bio;
> +}
> +
> +int osd_req_write_sg_kern(struct osd_request *or,
> +	const struct osd_obj_id *obj, void **buff,
> +	const struct osd_sg_entry *sglist, unsigned numentries)
> +{
> +	struct bio *bio = _create_sg_bios(or, buff, sglist, numentries);
> +	if (IS_ERR(bio))
> +		return PTR_ERR(bio);
> +
> +	bio->bi_rw |= REQ_WRITE;
> +	osd_req_write_sg(or, obj, bio, sglist, numentries);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(osd_req_write_sg_kern);
> +
> +int osd_req_read_sg_kern(struct osd_request *or,
> +	const struct osd_obj_id *obj, void **buff,
> +	const struct osd_sg_entry *sglist, unsigned numentries)
> +{
> +	struct bio *bio = _create_sg_bios(or, buff, sglist, numentries);
> +	if (IS_ERR(bio))
> +		return PTR_ERR(bio);
> +
> +	osd_req_read_sg(or, obj, bio, sglist, numentries);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(osd_req_read_sg_kern);
> +
> +
> +
>  void osd_req_get_attributes(struct osd_request *or,
>  	const struct osd_obj_id *obj)
>  {

