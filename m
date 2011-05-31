From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 37/42] target/iscsi: Do not use t_mem_list anymore
Date: Tue, 31 May 2011 02:00:56 -0700
Message-ID: <1306832456.8193.155.camel@haakon2.linux-iscsi.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
	 <1306523240-15543-38-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42161 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1EaJJU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2011 05:09:20 -0400
In-Reply-To: <1306523240-15543-38-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2011-05-27 at 12:07 -0700, Andy Grover wrote:
> This patchset switches over from using se_cmd->t_mem_list as the base
> for building and mapping iovecs, to using iscsi's internal t_mem_sg,
> which we have since we allocated the memory ourselves. The se_offset_map
> and se_unmap_sg structs are no longer needed, replaced where needed by
> data members in iscsi_cmd itself.
> 

So for the amount of code and complexity this removes I am really very
happy to unify iscsi-target usage to follow iscsit_alloc_buffs() in
patch #31..  Again, very well done with ~300 LOC dropped for the main
iscsi-target I/O codepath.

The only small concern here (aside from more real testing with the whole
series of course) is the PAGE_SIZE direct usage in iscsit_map_iovec(),
as this would apply to the comments in patch #6 wrt to adding contigious
page scatterlist support in the future.  But with your changes that is
straight-forward enough for me to be comfortable with.  Thanks for
making that an easy decision..

> Modify iscsit_fe_sendpage_sg. It appears it used to be possible to have
> multiple pages attached to each se_mem (of which there could also be
> multiple.) Having a single array of pages simplifies the code greatly.
> 
> Modify crypto_hash fn to take sgs instead of an iovec. This works out well
> in that we don't need to rebuild the iovec, and the crypto has functions
> wanted sgs anyways.
> 
> Modify tx thread to not use struct unmap_sg, and put vars on their own
> lines.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---

A big +1 for agrover!!  Committed as 69077551ef

--nab

>  drivers/target/iscsi/iscsi_target.c      |  447 +++++++-----------------------
>  drivers/target/iscsi/iscsi_target_core.h |    9 +-
>  drivers/target/iscsi/iscsi_target_util.c |  102 ++-----
>  drivers/target/iscsi/iscsi_target_util.h |   31 +--
>  4 files changed, 142 insertions(+), 447 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 34749e8..2fe6004 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -684,259 +684,58 @@ int iscsit_add_reject_from_cmd(
>  	return (!fail_conn) ? 0 : -1;
>  }
>  
> -static void iscsit_calculate_map_segment(
> -	u32 data_length,
> -	struct se_offset_map *lm)
> -{
> -	u32 sg_offset = 0;
> -	struct se_mem *se_mem = lm->map_se_mem;
> -	/*
> -	 * Still working on pages in the current struct se_mem.
> -	 */
> -	if (!lm->map_reset) {
> -		lm->iovec_length = (lm->sg_length > PAGE_SIZE) ?
> -					PAGE_SIZE : lm->sg_length;
> -		if (data_length < lm->iovec_length)
> -			lm->iovec_length = data_length;
> -
> -		lm->iovec_base = page_address(lm->sg_page) + sg_offset;
> -		return;
> -	}
> -
> -	/*
> -	 * First run of an iscsi_linux_map_t.
> -	 *
> -	 * OR:
> -	 *
> -	 * Mapped all of the pages in the current scatterlist, move
> -	 * on to the next one.
> -	 */
> -	lm->map_reset = 0;
> -	sg_offset = se_mem->se_off;
> -	lm->sg_page = se_mem->se_page;
> -	lm->sg_length = se_mem->se_len;
> -	/*
> -	 * Get the base and length of the current page for use with the iovec.
> -	 */
> -recalc:
> -	lm->iovec_length = (lm->sg_length > (PAGE_SIZE - sg_offset)) ?
> -			   (PAGE_SIZE - sg_offset) : lm->sg_length;
> -	/*
> -	 * See if there is any iSCSI offset we need to deal with.
> -	 */
> -	if (!lm->current_offset) {
> -		lm->iovec_base = page_address(lm->sg_page) + sg_offset;
> -
> -		if (data_length < lm->iovec_length)
> -			lm->iovec_length = data_length;
> -
> -		return;
> -	}
> -
> -	/*
> -	 * We know the iSCSI offset is in the next page of the current
> -	 * scatterlist.  Increase the lm->sg_page pointer and try again.
> -	 */
> -	if (lm->current_offset >= lm->iovec_length) {
> -		lm->current_offset -= lm->iovec_length;
> -		lm->sg_length -= lm->iovec_length;
> -		lm->sg_page++;
> -		sg_offset = 0;
> -
> -		goto recalc;
> -	}
> -
> -	/*
> -	 * The iSCSI offset is in the current page, increment the iovec
> -	 * base and reduce iovec length.
> -	 */
> -	lm->iovec_base = page_address(lm->sg_page);
> -
> -	lm->iovec_base += sg_offset;
> -	lm->iovec_base += lm->current_offset;
> -
> -	if ((lm->iovec_length - lm->current_offset) < data_length)
> -		lm->iovec_length -= lm->current_offset;
> -	else
> -		lm->iovec_length = data_length;
> -
> -	if ((lm->sg_length - lm->current_offset) < data_length)
> -		lm->sg_length -= lm->current_offset;
> -	else
> -		lm->sg_length = data_length;
> -
> -	lm->current_offset = 0;
> -}
> -
>  /*
> - * Find the first se_mem we should be using, based on the offset used so far.
> - * Update lmap to look at first se_mem with room, and the offset of unused room
> - * in it.
> + * Map some portion of the allocated scatterlist to an iovec, suitable for
> + * kernel sockets to copy data in/out. This handles both pages and slab-allocated
> + * buffers, since we have been tricky and mapped t_mem_sg to the buffer in
> + * either case (see iscsit_alloc_buffs)
>   */
> -static void iscsit_get_offset(struct se_unmap_sg *usg)
> -{
> -	struct se_offset_map *lmap = &usg->lmap;
> -	struct se_mem *se_mem = NULL;
> -
> -	int offset = 0;
> -	int found = 0;
> -	int cur_se_mem_offset;
> -
> -	/* Burn through se_mems until the offset is consumed */
> -	list_for_each_entry(se_mem, &usg->se_cmd->t_mem_list, se_list) {
> -
> -		if ((offset + se_mem->se_len) < lmap->iscsi_offset) {
> -			found = 1;
> -			break;
> -		}
> -
> -		offset += se_mem->se_len;
> -	}
> -
> -	BUG_ON(!found);
> -
> -	lmap->map_orig_se_mem = se_mem;
> -	usg->cur_se_mem = se_mem;
> -
> -	cur_se_mem_offset = (lmap->iscsi_offset - offset);
> -	usg->t_offset = cur_se_mem_offset;
> -	lmap->orig_offset = cur_se_mem_offset;
> -	lmap->current_offset = cur_se_mem_offset;
> -}
> -
> -static int iscsit_set_iovec_ptrs(
> +static int iscsit_map_iovec(
>  	struct iscsi_cmd *cmd,
>  	struct kvec *iov,
>  	u32 data_offset,
> -	u32 data_length,
> -	int sg_kmap_active,
> -	struct se_unmap_sg *unmap_sg)
> +	u32 data_length)
>  {
> -	u32 i = 0; /* For iovecs */
> -	u32 j = 0; /* For scatterlists */
> -	struct se_cmd *se_cmd = &cmd->se_cmd;
> -	struct se_offset_map *lmap = &unmap_sg->lmap;
> +	u32 i;
> +	struct scatterlist *sg;
> +	unsigned int page_off;
>  
>  	/*
> -	 * Used for non scatterlist operations, assume a single iovec.
> +	 * We have a private mapping of the allocated pages in t_mem_sg.
> +	 * At this point, we also know each contains a page.
>  	 */
> -	if (!se_cmd->t_tasks_se_num) {
> -		iov[0].iov_base = se_cmd->t_task_buf + data_offset;
> -		iov[0].iov_len  = data_length;
> -		return 1;
> -	}
> +	sg = &cmd->t_mem_sg[data_offset / PAGE_SIZE];
> +	page_off = (data_offset % PAGE_SIZE) + sg->offset;
>  
> -	/*
> -	 * Set lmap->map_reset = 1 so the first call to
> -	 * iscsit_calculate_map_segment() sets up the initial
> -	 * values for struct se_offset_map.
> -	 */
> -	lmap->map_reset = 1;
> -	/*
> -	 * Get a pointer to the first used scatterlist based on the passed
> -	 * offset. Also set the rest of the needed values in iscsi_linux_map_t.
> -	 */
> -	lmap->iscsi_offset = data_offset;
> -	if (sg_kmap_active) {
> -		unmap_sg->se_cmd = se_cmd;
> -		iscsit_get_offset(unmap_sg);
> -		unmap_sg->data_length = data_length;
> -	} else {
> -		lmap->current_offset = lmap->orig_offset;
> -	}
> -	lmap->map_se_mem = lmap->map_orig_se_mem;
> +	cmd->first_data_sg = sg;
> +	cmd->first_data_sg_off = page_off;
>  
> +	i = 0;
>  	while (data_length) {
> -		/*
> -		 * Time to get the virtual address for use with iovec pointers.
> -		 * This function will return the expected iovec_base address
> -		 * and iovec_length.
> -		 */
> -		iscsit_calculate_map_segment(data_length, lmap);
> +		u32 cur_len = min_t(u32, data_length, (sg[i].length - page_off));
>  
> -		/*
> -		 * Set the iov.iov_base and iov.iov_len from the current values
> -		 * in iscsi_linux_map_t.
> -		 */
> -		iov[i].iov_base = lmap->iovec_base;
> -		iov[i].iov_len = lmap->iovec_length;
> +		iov[i].iov_base = kmap(sg_page(&sg[i]));
> +		iov[i].iov_len = cur_len;
>  
> -		/*
> -		 * Subtract the final iovec length from the total length to be
> -		 * mapped, and the length of the current scatterlist.  Also
> -		 * perform the paranoid check to make sure we are not going to
> -		 * overflow the iovecs allocated for this command in the next
> -		 * pass.
> -		 */
> -		data_length -= iov[i].iov_len;
> -		lmap->sg_length -= iov[i].iov_len;
> -
> -		if ((++i + 1) > cmd->orig_iov_data_count) {
> -			printk(KERN_ERR "Current iovec count %u is greater than"
> -				" struct se_cmd->orig_data_iov_count %u, cannot"
> -				" continue.\n", i+1, cmd->orig_iov_data_count);
> -			return -1;
> -		}
> -
> -		/*
> -		 * All done mapping this scatterlist's pages, move on to
> -		 * the next scatterlist by setting lmap.map_reset = 1;
> -		 */
> -		if (!lmap->sg_length || !data_length) {
> -			list_for_each_entry(lmap->map_se_mem,
> -					&lmap->map_se_mem->se_list, se_list)
> -				break;
> -
> -			if (!lmap->map_se_mem) {
> -				printk(KERN_ERR "Unable to locate next"
> -					" lmap->map_struct se_mem entry\n");
> -				return -1;
> -			}
> -			j++;
> -
> -			lmap->sg_page = NULL;
> -			lmap->map_reset = 1;
> -		} else
> -			lmap->sg_page++;
> +		data_length -= cur_len;
> +		page_off = 0;
> +		i++;
>  	}
>  
> -	unmap_sg->sg_count = j;
> +	cmd->kmapped_nents = i;
>  
>  	return i;
>  }
>  
> -static void iscsit_map_SG_segments(struct se_unmap_sg *unmap_sg)
> +static void iscsit_unmap_iovec(struct iscsi_cmd *cmd)
>  {
> -	u32 i = 0;
> -	struct se_cmd *cmd = unmap_sg->se_cmd;
> -	struct se_mem *se_mem = unmap_sg->cur_se_mem;
> -
> -	if (!cmd->t_tasks_se_num)
> -		return;
> -
> -	list_for_each_entry_continue(se_mem, &cmd->t_mem_list, se_list) {
> -		kmap(se_mem->se_page);
> -
> -		if (++i == unmap_sg->sg_count)
> -			break;
> -	}
> -}
> -
> -static void iscsit_unmap_SG_segments(struct se_unmap_sg *unmap_sg)
> -{
> -	u32 i = 0;
> -	struct se_cmd *cmd = unmap_sg->se_cmd;
> -	struct se_mem *se_mem = unmap_sg->cur_se_mem;
> -
> -	if (!cmd->t_tasks_se_num)
> -		return;
> +	u32 i;
> +	struct scatterlist *sg;
>  
> -	list_for_each_entry_continue(se_mem, &cmd->t_mem_list, se_list) {
> -		kunmap(se_mem->se_page);
> +	sg = cmd->first_data_sg;
>  
> -		if (++i == unmap_sg->sg_count)
> -			break;
> -	}
> +	for (i = 0; i < cmd->kmapped_nents; i++)
> +		kunmap(sg_page(&sg[i]));
>  }
>  
>  static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_statsn)
> @@ -969,19 +768,23 @@ static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
>  	u32 length = cmd->se_cmd.data_length;
>  	struct scatterlist *sgl;
>  	int nents = ceil(length, PAGE_SIZE);
> -	int i = 0;
> +	int i;
>  	void *buf;
>  	void *cur;
>  	struct page *page;
>  
> +	if (!length)
> +		return 0;
> +
>  	sgl = kzalloc(sizeof(*sgl) * nents, GFP_KERNEL);
>  	if (!sgl)
>  		return -ENOMEM;
> +	sg_init_table(sgl, nents);
>  
>  	/*
>  	 * Allocate from slab if nonsg, but sgl should point
>  	 * to the malloced mem.
> -	 * We know we have to kfree it if t_task_buf is set.
> +	 * We know we have to kfree it if t_mem is set.
>  	 * Alloc pages if sg.
>  	 */
>  	if (cmd->se_cmd.se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
> @@ -1004,7 +807,7 @@ static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
>  		cmd->t_mem = buf;
>  
>  	} else {
> -
> +		i = 0;
>  		while (length) {
>  			int buf_size = min_t(int, length, PAGE_SIZE);
>  
> @@ -1258,6 +1061,12 @@ attach_cmd:
>  	 * Active/NonOptimized primary access state..
>  	 */
>  	core_alua_check_nonop_delay(SE_CMD(cmd));
> +
> +	ret = iscsit_alloc_buffs(cmd);
> +	if (ret < 0) {
> +		return ret;
> +	}
> +
>  	/*
>  	 * Check the CmdSN against ExpCmdSN/MaxCmdSN here if
>  	 * the Immediate Bit is not set, and no Immediate
> @@ -1307,11 +1116,6 @@ attach_cmd:
>  		goto after_immediate_data;
>  	}
>  
> -	ret = iscsit_alloc_buffs(cmd);
> -	if (ret < 0) {
> -		return ret;
> -	}
> -
>  	/*
>  	 * Immediate Data is present, send to the transport and block until
>  	 * the underlying transport plugin has allocated the buffer to
> @@ -1376,33 +1180,44 @@ after_immediate_data:
>  	return 0;
>  }
>  
> -static void iscsit_do_crypto_hash_iovec(
> +static u32 iscsit_do_crypto_hash_sg(
>  	struct hash_desc *hash,
> -	struct kvec *iov,
> -	u32 counter,
> +	struct iscsi_cmd *cmd,
> +	u32 data_offset,
> +	u32 data_length,
>  	u32 padding,
> -	u8 *pad_bytes,
> -	u8 *data_crc)
> +	u8 *pad_bytes)
>  {
> -	struct scatterlist sg;
> -	struct kvec *iov_ptr = iov;
> +	u32 data_crc;
> +	u32 i;
> +	struct scatterlist *sg;
> +	unsigned int page_off;
>  
>  	crypto_hash_init(hash);
>  
> -	while (counter > 0) {
> -		sg_init_one(&sg, iov_ptr->iov_base,
> -				iov_ptr->iov_len);
> -		crypto_hash_update(hash, &sg, iov_ptr->iov_len);
> -		
> -		counter -= iov_ptr->iov_len;
> -		iov_ptr++;
> +	sg = cmd->first_data_sg;
> +	page_off = cmd->first_data_sg_off;
> +
> +	i = 0;
> +	while (data_length) {
> +		u32 cur_len = min_t(u32, data_length, (sg[i].length - page_off));
> +
> +		crypto_hash_update(hash, sg, cur_len);
> +
> +		data_length -= cur_len;
> +		page_off = 0;
> +		i++;
>  	}
>  
>  	if (padding) {
> -		sg_init_one(&sg, pad_bytes, padding);
> -		crypto_hash_update(hash, &sg, padding);
> +		struct scatterlist pad_sg;
> +
> +		sg_init_one(&pad_sg, pad_bytes, padding);
> +		crypto_hash_update(hash, &pad_sg, padding);
>  	}
> -	crypto_hash_final(hash, data_crc);
> +	crypto_hash_final(hash, (u8 *) &data_crc);
> +
> +	return data_crc;
>  }
>  
>  static void iscsit_do_crypto_hash_buf(
> @@ -1435,7 +1250,6 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
>  	u32 rx_size = 0, payload_length;
>  	struct iscsi_cmd *cmd = NULL;
>  	struct se_cmd *se_cmd;
> -	struct se_unmap_sg unmap_sg;
>  	struct iscsi_data *hdr;
>  	struct kvec *iov;
>  	unsigned long flags;
> @@ -1606,11 +1420,7 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
>  	rx_size += payload_length;
>  	iov = &cmd->iov_data[0];
>  
> -	memset(&unmap_sg, 0, sizeof(struct se_unmap_sg));
> -	unmap_sg.fabric_cmd = (void *)cmd;
> -	unmap_sg.se_cmd = SE_CMD(cmd);
> -
> -	iov_ret = iscsit_set_iovec_ptrs(cmd, iov, hdr->offset, payload_length, 1, &unmap_sg);
> +	iov_ret = iscsit_map_iovec(cmd, iov, hdr->offset, payload_length);
>  	if (iov_ret < 0)
>  		return -1;
>  
> @@ -1630,30 +1440,19 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
>  		rx_size += ISCSI_CRC_LEN;
>  	}
>  
> -	iscsit_map_SG_segments(&unmap_sg);
> -
>  	rx_got = rx_data(conn, &cmd->iov_data[0], iov_count, rx_size);
>  
> -	iscsit_unmap_SG_segments(&unmap_sg);
> +	iscsit_unmap_iovec(cmd);
>  
>  	if (rx_got != rx_size)
>  		return -1;
>  
>  	if (conn->conn_ops->DataDigest) {
> -		u32 counter = payload_length, data_crc = 0;
> -		struct kvec *iov_ptr = &cmd->iov_data[0];
> +		u32 data_crc;
>  
> -		/*
> -		 * Thanks to the IP stack shitting on passed iovecs,  we have to
> -		 * call set_iovec_data_ptrs() again in order to have a iMD/PSCSI
> -		 * agnostic way of doing datadigests computations.
> -		 */
> -		if (iscsit_set_iovec_ptrs(cmd, iov_ptr, hdr->offset, payload_length, 0, &unmap_sg) < 0)
> -			return -1;
> -
> -		iscsit_do_crypto_hash_iovec(&conn->conn_rx_hash,
> -				iov_ptr, counter, padding,
> -				(u8 *)&pad_bytes, (u8 *)&data_crc);
> +		data_crc = iscsit_do_crypto_hash_sg(&conn->conn_rx_hash, cmd,
> +						    hdr->offset, payload_length, padding,
> +						    (u8 *)&pad_bytes);
>  
>  		if (checksum != data_crc) {
>  			printk(KERN_ERR "ITT: 0x%08x, Offset: %u, Length: %u,"
> @@ -2515,15 +2314,9 @@ static int iscsit_handle_immediate_data(
>  	int iov_ret, rx_got = 0, rx_size = 0;
>  	u32 checksum, iov_count = 0, padding = 0, pad_bytes = 0;
>  	struct iscsi_conn *conn = cmd->conn;
> -	struct se_unmap_sg unmap_sg;
>  	struct kvec *iov;
>  
> -	memset(&unmap_sg, 0, sizeof(struct se_unmap_sg));
> -	unmap_sg.fabric_cmd = (void *)cmd;
> -	unmap_sg.se_cmd = SE_CMD(cmd);
> -
> -	iov_ret = iscsit_set_iovec_ptrs(cmd, cmd->iov_data, cmd->write_data_done,
> -					length, 1, &unmap_sg);
> +	iov_ret = iscsit_map_iovec(cmd, cmd->iov_data, cmd->write_data_done, length);
>  	if (iov_ret < 0)
>  		return IMMEDIATE_DATA_CANNOT_RECOVER;
>  
> @@ -2544,11 +2337,9 @@ static int iscsit_handle_immediate_data(
>  		rx_size += ISCSI_CRC_LEN;
>  	}
>  
> -	iscsit_map_SG_segments(&unmap_sg);
> -
>  	rx_got = rx_data(conn, &cmd->iov_data[0], iov_count, rx_size);
>  
> -	iscsit_unmap_SG_segments(&unmap_sg);
> +	iscsit_unmap_iovec(cmd);
>  
>  	if (rx_got != rx_size) {
>  		iscsit_rx_thread_wait_for_tcp(conn);
> @@ -2556,19 +2347,11 @@ static int iscsit_handle_immediate_data(
>  	}
>  
>  	if (conn->conn_ops->DataDigest) {
> -		u32 counter = length, data_crc;
> -		struct kvec *iov_ptr = &cmd->iov_data[0];
> -		/*
> -		 * Thanks to the IP stack shitting on passed iovecs,  we have to
> -		 * call set_iovec_data_ptrs again in order to have a iMD/PSCSI
> -		 * agnostic way of doing datadigests computations.
> -		 */
> -		if (iscsit_set_iovec_ptrs(cmd, iov_ptr, cmd->write_data_done, length, 0, &unmap_sg) < 0)
> -			return IMMEDIATE_DATA_CANNOT_RECOVER;
> +		u32 data_crc;
>  
> -		iscsit_do_crypto_hash_iovec(&conn->conn_rx_hash, iov_ptr,
> -					counter, padding,
> -					(u8 *)&pad_bytes, (u8 *)&data_crc);
> +		data_crc = iscsit_do_crypto_hash_sg(&conn->conn_rx_hash, cmd,
> +						    cmd->write_data_done, length, padding,
> +						    (u8 *)&pad_bytes);
>  
>  		if (checksum != data_crc) {
>  			printk(KERN_ERR "ImmediateData CRC32C DataDigest 0x%08x"
> @@ -2699,7 +2482,6 @@ static int iscsit_send_conn_drop_async_message(
>  static int iscsit_send_data_in(
>  	struct iscsi_cmd *cmd,
>  	struct iscsi_conn *conn,
> -	struct se_unmap_sg *unmap_sg,
>  	int *eodr)
>  {
>  	int iov_ret = 0, set_statsn = 0;
> @@ -2709,6 +2491,7 @@ static int iscsit_send_data_in(
>  	struct iscsi_datain_req *dr;
>  	struct iscsi_data_rsp *hdr;
>  	struct kvec *iov;
> +	u32 padding;
>  
>  	memset(&datain, 0, sizeof(struct iscsi_datain));
>  	dr = iscsit_get_datain_values(cmd, &datain);
> @@ -2805,37 +2588,26 @@ static int iscsit_send_data_in(
>  			" for DataIN PDU 0x%08x\n", *header_digest);
>  	}
>  
> -	iov_ret = iscsit_set_iovec_ptrs(cmd, &cmd->iov_data[iov_count], datain.offset,
> -					datain.length, 1, unmap_sg);
> +	iov_ret = iscsit_map_iovec(cmd, &cmd->iov_data[1], datain.offset, datain.length);
>  	if (iov_ret < 0)
>  		return -1;
>  
>  	iov_count += iov_ret;
>  	tx_size += datain.length;
>  
> -	unmap_sg->padding = ((-datain.length) & 3);
> -	if (unmap_sg->padding != 0) {
> -		pad_bytes = kzalloc(unmap_sg->padding * sizeof(u8),
> -					GFP_KERNEL);
> -		if (!pad_bytes) {
> -			printk(KERN_ERR "Unable to allocate memory for"
> -					" pad_bytes.\n");
> -			return -1;
> -		}
> -		cmd->buf_ptr = pad_bytes;
> +	padding = ((-datain.length) & 3);
> +	if (padding) {
> +		pad_bytes = cmd->pad_bytes;
>  		iov[iov_count].iov_base		= pad_bytes;
> -		iov[iov_count++].iov_len	= unmap_sg->padding;
> -		tx_size += unmap_sg->padding;
> +		iov[iov_count++].iov_len	= cmd->padding;
> +		tx_size += cmd->padding;
>  
>  		TRACE(TRACE_ISCSI, "Attaching %u padding bytes\n",
> -				unmap_sg->padding);
> +				cmd->padding);
>  	}
>  	if (conn->conn_ops->DataDigest) {
> -		u32 counter = (datain.length + unmap_sg->padding);
> -		struct kvec *iov_ptr = &cmd->iov_data[1];
> -
> -		iscsit_do_crypto_hash_iovec(&conn->conn_tx_hash, iov_ptr,
> -				counter, 0, NULL, (u8 *)&cmd->data_crc);
> +		cmd->data_crc = iscsit_do_crypto_hash_sg(&conn->conn_tx_hash, cmd,
> +			 datain.offset, datain.length, cmd->padding, cmd->pad_bytes);
>  
>  		iov[iov_count].iov_base	= &cmd->data_crc;
>  		iov[iov_count++].iov_len = ISCSI_CRC_LEN;
> @@ -3741,13 +3513,16 @@ static inline void iscsit_thread_check_cpumask(
>  int iscsi_target_tx_thread(void *arg)
>  {
>  	u8 state;
> -	int eodr = 0, map_sg = 0, ret = 0, sent_status = 0, use_misc = 0;
> +	int eodr = 0;
> +	int ret = 0;
> +	int sent_status = 0;
> +	int use_misc = 0;
> +	int map_sg = 0;
>  	struct iscsi_cmd *cmd = NULL;
>  	struct iscsi_conn *conn;
>  	struct iscsi_queue_req *qr = NULL;
>  	struct se_cmd *se_cmd;
>  	struct iscsi_thread_set *ts = (struct iscsi_thread_set *)arg;
> -	struct se_unmap_sg unmap_sg;
>  	/*
>  	 * Allow ourselves to be interrupted by SIGINT so that a
>  	 * connection recovery / failure event can be triggered externally.
> @@ -3878,13 +3653,9 @@ check_rsp_state:
>  			switch (state) {
>  			case ISTATE_SEND_DATAIN:
>  				spin_unlock_bh(&cmd->istate_lock);
> -				memset(&unmap_sg, 0,
> -						sizeof(struct se_unmap_sg));
> -				unmap_sg.fabric_cmd = (void *)cmd;
> -				unmap_sg.se_cmd = SE_CMD(cmd);
> -				map_sg = 1;
>  				ret = iscsit_send_data_in(cmd, conn,
> -						&unmap_sg, &eodr);
> +							  &eodr);
> +				map_sg = 1;
>  				break;
>  			case ISTATE_SEND_STATUS:
>  			case ISTATE_SEND_STATUS_RECOVERY:
> @@ -3943,32 +3714,22 @@ check_rsp_state:
>  
>  			se_cmd = &cmd->se_cmd;
>  
> -			if (map_sg && !conn->conn_ops->IFMarker &&
> -			    se_cmd->t_tasks_se_num) {
> -				iscsit_map_SG_segments(&unmap_sg);
> -				if (iscsit_fe_sendpage_sg(&unmap_sg, conn) < 0) {
> +			if (map_sg && !conn->conn_ops->IFMarker) {
> +				if (iscsit_fe_sendpage_sg(cmd, conn) < 0) {
>  					conn->tx_response_queue = 0;
>  					iscsit_tx_thread_wait_for_tcp(conn);
> -					iscsit_unmap_SG_segments(&unmap_sg);
> +					iscsit_unmap_iovec(cmd);
>  					goto transport_err;
>  				}
> -				iscsit_unmap_SG_segments(&unmap_sg);
> -				map_sg = 0;
>  			} else {
> -				if (map_sg)
> -					iscsit_map_SG_segments(&unmap_sg);
>  				if (iscsit_send_tx_data(cmd, conn, use_misc) < 0) {
>  					conn->tx_response_queue = 0;
>  					iscsit_tx_thread_wait_for_tcp(conn);
> -					if (map_sg)
> -						iscsit_unmap_SG_segments(&unmap_sg);
> +					iscsit_unmap_iovec(cmd);
>  					goto transport_err;
>  				}
> -				if (map_sg) {
> -					iscsit_unmap_SG_segments(&unmap_sg);
> -					map_sg = 0;
> -				}
>  			}
> +			iscsit_unmap_iovec(cmd);
>  
>  			spin_lock_bh(&cmd->istate_lock);
>  			switch (state) {
> diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
> index d64cd30..693f8c8 100644
> --- a/drivers/target/iscsi/iscsi_target_core.h
> +++ b/drivers/target/iscsi/iscsi_target_core.h
> @@ -388,8 +388,6 @@ struct iscsi_cmd {
>  	u32			orig_iov_data_count;
>  	/* Number of miscellaneous iovecs used for IP stack calls */
>  	u32			iov_misc_count;
> -	/* Bytes used for 32-bit word padding */
> -	u32			pad_bytes;
>  	/* Number of struct iscsi_pdu in struct iscsi_cmd->pdu_list */
>  	u32			pdu_count;
>  	/* Next struct iscsi_pdu to send in struct iscsi_cmd->pdu_list */
> @@ -477,6 +475,13 @@ struct iscsi_cmd {
>  	struct scatterlist	*t_mem_sg;
>  	u32			t_mem_sg_nents;
>  
> +	u32			padding;
> +	u8			pad_bytes[4];
> +
> +	struct scatterlist	*first_data_sg;
> +	u32			first_data_sg_off;
> +	u32			kmapped_nents;
> +
>  }  ____cacheline_aligned;
>  
>  #define SE_CMD(cmd)		(&(cmd)->se_cmd)
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 6d770a4..79d3b6e 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -1275,22 +1275,26 @@ send_data:
>  }
>  
>  int iscsit_fe_sendpage_sg(
> -	struct se_unmap_sg *u_sg,
> +	struct iscsi_cmd *cmd,
>  	struct iscsi_conn *conn)
>  {
>  	int tx_sent;
> -	struct iscsi_cmd *cmd = (struct iscsi_cmd *)u_sg->fabric_cmd;
> -	struct se_cmd *se_cmd = SE_CMD(cmd);
> -	u32 len = cmd->tx_size, pg_len, se_len, se_off, tx_size;
> -	struct kvec *iov = &cmd->iov_data[0];
> -	struct page *page;
> -	struct se_mem *se_mem = u_sg->cur_se_mem;
> +	u32 tx_hdr_size;
> +	u32 data_len;
> +	struct kvec iov;
> +	struct scatterlist *sg = cmd->first_data_sg;
> +	u32 offset = cmd->first_data_sg_off;
>  
>  send_hdr:
> -	tx_size = (conn->conn_ops->HeaderDigest) ? ISCSI_HDR_LEN + ISCSI_CRC_LEN :
> -			ISCSI_HDR_LEN;
> -	tx_sent = tx_data(conn, iov, 1, tx_size);
> -	if (tx_size != tx_sent) {
> +	tx_hdr_size = ISCSI_HDR_LEN;
> +	if (conn->conn_ops->HeaderDigest)
> +		tx_hdr_size += ISCSI_CRC_LEN;
> +
> +	iov.iov_base = cmd->pdu;
> +	iov.iov_len = tx_hdr_size;
> +
> +	tx_sent = tx_data(conn, &iov, 1, tx_hdr_size);
> +	if (tx_hdr_size != tx_sent) {
>  		if (tx_sent == -EAGAIN) {
>  			printk(KERN_ERR "tx_data() returned -EAGAIN\n");
>  			goto send_hdr;
> @@ -1298,46 +1302,20 @@ send_hdr:
>  		return -1;
>  	}
>  
> -	len -= tx_size;
> -	len -= u_sg->padding;
> +	data_len = cmd->tx_size - tx_hdr_size - cmd->padding;
>  	if (conn->conn_ops->DataDigest)
> -		len -= ISCSI_CRC_LEN;
> -	/*
> -	 * Start calculating from the first page of current struct se_mem.
> -	 */
> -	page = se_mem->se_page;
> -	pg_len = (PAGE_SIZE - se_mem->se_off);
> -	se_len = se_mem->se_len;
> -	if (se_len < pg_len)
> -		pg_len = se_len;
> -	se_off = se_mem->se_off;
> -	/*
> -	 * Calucate new se_len and se_off based upon u_sg->t_offset into
> -	 * the current struct se_mem and possibily a different page.
> -	 */
> -	while (u_sg->t_offset) {
> -		if (u_sg->t_offset >= pg_len) {
> -			u_sg->t_offset -= pg_len;
> -			se_len -= pg_len;
> -			se_off = 0;
> -			pg_len = PAGE_SIZE;
> -			page++;
> -		} else {
> -			se_off += u_sg->t_offset;
> -			se_len -= u_sg->t_offset;
> -			u_sg->t_offset = 0;
> -		}
> -	}
> +		data_len -= ISCSI_CRC_LEN;
> +
>  	/*
> -	 * Perform sendpage() for each page in the struct se_mem
> +	 * Perform sendpage() for each page in the scatterlist
>  	 */
> -	while (len) {
> -		if (se_len > len)
> -			se_len = len;
> +	while (data_len) {
> +		u32 space = (sg->length - offset);
> +		u32 sub_len = min_t(u32, data_len, space);
>  send_pg:
>  		tx_sent = conn->sock->ops->sendpage(conn->sock,
> -				page, se_off, se_len, 0);
> -		if (tx_sent != se_len) {
> +						    sg_page(sg), offset, sub_len, 0);
> +		if (tx_sent != sub_len) {
>  			if (tx_sent == -EAGAIN) {
>  				printk(KERN_ERR "tcp_sendpage() returned"
>  						" -EAGAIN\n");
> @@ -1349,38 +1327,18 @@ send_pg:
>  			return -1;
>  		}
>  
> -		len -= se_len;
> -		if (!(len))
> -			break;
> -
> -		se_len -= tx_sent;
> -		if (!(se_len)) {
> -			list_for_each_entry_continue(se_mem,
> -					&se_cmd->t_mem_list, se_list)
> -				break;
> -
> -			if (!se_mem) {
> -				printk(KERN_ERR "Unable to locate next struct se_mem\n");
> -				return -1;
> -			}
> -
> -			se_len = se_mem->se_len;
> -			se_off = se_mem->se_off;
> -			page = se_mem->se_page;
> -		} else {
> -			se_len = PAGE_SIZE;
> -			se_off = 0;
> -			page++;
> -		}
> +		data_len -= sub_len;
> +		offset = 0;
> +		sg++;
>  	}
>  
>  send_padding:
> -	if (u_sg->padding) {
> +	if (cmd->padding) {
>  		struct kvec *iov_p =
>  			&cmd->iov_data[cmd->iov_data_count-2];
>  
> -		tx_sent = tx_data(conn, iov_p, 1, u_sg->padding);
> -		if (u_sg->padding != tx_sent) {
> +		tx_sent = tx_data(conn, iov_p, 1, cmd->padding);
> +		if (cmd->padding != tx_sent) {
>  			if (tx_sent == -EAGAIN) {
>  				printk(KERN_ERR "tx_data() returned -EAGAIN\n");
>  				goto send_padding;
> diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
> index 9bd5cc0..2cd49d6 100644
> --- a/drivers/target/iscsi/iscsi_target_util.h
> +++ b/drivers/target/iscsi/iscsi_target_util.h
> @@ -3,35 +3,6 @@
>  
>  #define MARKER_SIZE	8
>  
> -struct se_cmd;
> -
> -struct se_offset_map {
> -	int                     map_reset;
> -	u32                     iovec_length;
> -	u32                     iscsi_offset;
> -	u32                     current_offset;
> -	u32                     orig_offset;
> -	u32                     sg_count;
> -	u32                     sg_current;
> -	u32                     sg_length;
> -	struct page		*sg_page;
> -	struct se_mem		*map_se_mem;
> -	struct se_mem		*map_orig_se_mem;
> -	void			*iovec_base;
> -};
> -
> -struct se_unmap_sg {
> -	u32			data_length;
> -	u32			sg_count;
> -	u32			sg_offset;
> -	u32			padding;
> -	u32			t_offset;
> -	void			*fabric_cmd;
> -	struct se_cmd		*se_cmd;
> -	struct se_offset_map	lmap;
> -	struct se_mem		*cur_se_mem;
> -};
> -
>  extern int iscsit_add_r2t_to_list(struct iscsi_cmd *, u32, u32, int, u32);
>  extern struct iscsi_r2t *iscsit_get_r2t_for_eos(struct iscsi_cmd *, u32, u32);
>  extern struct iscsi_r2t *iscsit_get_r2t_from_list(struct iscsi_cmd *);
> @@ -75,7 +46,7 @@ extern void __iscsit_start_nopin_timer(struct iscsi_conn *);
>  extern void iscsit_start_nopin_timer(struct iscsi_conn *);
>  extern void iscsit_stop_nopin_timer(struct iscsi_conn *);
>  extern int iscsit_send_tx_data(struct iscsi_cmd *, struct iscsi_conn *, int);
> -extern int iscsit_fe_sendpage_sg(struct se_unmap_sg *, struct iscsi_conn *);
> +extern int iscsit_fe_sendpage_sg(struct iscsi_cmd *, struct iscsi_conn *);
>  extern int iscsit_tx_login_rsp(struct iscsi_conn *, u8, u8);
>  extern void iscsit_print_session_params(struct iscsi_session *);
>  extern int iscsit_print_dev_to_proc(char *, char **, off_t, int);
> -- 
> 1.7.1
> 

