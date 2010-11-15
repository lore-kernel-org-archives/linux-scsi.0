From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: move iovec handling into the iscsi code
Date: Mon, 15 Nov 2010 14:34:58 -0800
Message-ID: <1289860498.22107.122.camel@haakon2.linux-iscsi.org>
References: <20101115222849.GA21114@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37542 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab0KOWkM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2010 17:40:12 -0500
In-Reply-To: <20101115222849.GA21114@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2010-11-15 at 17:28 -0500, Christoph Hellwig wrote:
> The various helper and structures dealing with iovecs are only used by
> the iscsi target and not of any relevance to the generic target code.
> If we ever happen to get another socket based target it could be moved
> into a shared helper library.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for taking the time to push down the final iSCSI specific bits
here Christoph!  Committed as 4b020ab.

--nab

> 
> Index: lio-core/drivers/target/lio-target/iscsi_target.c
> ===================================================================
> --- lio-core.orig/drivers/target/lio-target/iscsi_target.c	2010-11-15 22:24:10.875007056 +0100
> +++ lio-core/drivers/target/lio-target/iscsi_target.c	2010-11-15 22:27:18.391254995 +0100
> @@ -1371,6 +1371,441 @@ int iscsi_add_reject_from_cmd(
>  	return (!fail_conn) ? 0 : -1;
>  }
>  
> +/* #define iscsi_calculate_map_segment_DEBUG */
> +#ifdef iscsi_calculate_map_segment_DEBUG
> +#define DEBUG_MAP_SEGMENTS(buf...) PYXPRINT(buf)
> +#else
> +#define DEBUG_MAP_SEGMENTS(buf...)
> +#endif
> +
> +/*	iscsi_calculate_map_segment():
> + *
> + *
> + */
> +static inline void iscsi_calculate_map_segment(
> +	u32 *data_length,
> +	struct se_offset_map *lm)
> +{
> +	u32 sg_offset = 0;
> +	struct se_mem *se_mem = lm->map_se_mem;
> +
> +	DEBUG_MAP_SEGMENTS(" START Mapping se_mem: %p, Length: %d"
> +		"  Remaining iSCSI Data: %u\n", se_mem, se_mem->se_len,
> +		*data_length);
> +	/*
> +	 * Still working on pages in the current struct se_mem.
> +	 */
> +	if (!lm->map_reset) {
> +		lm->iovec_length = (lm->sg_length > PAGE_SIZE) ?
> +					PAGE_SIZE : lm->sg_length;
> +		if (*data_length < lm->iovec_length) {
> +			DEBUG_MAP_SEGMENTS("LINUX_MAP: Reset lm->iovec_length"
> +				" to %d\n", *data_length);
> +
> +			lm->iovec_length = *data_length;
> +		}
> +		lm->iovec_base = page_address(lm->sg_page) + sg_offset;
> +
> +		DEBUG_MAP_SEGMENTS("LINUX_MAP: Set lm->iovec_base to %p from"
> +			" lm->sg_page: %p\n", lm->iovec_base, lm->sg_page);
> +		return;
> +	}
> +
> +	/*
> +	 * First run of an iscsi_linux_map_t.
> +	 *
> +	 * OR:
> +	 *
> +	 * Mapped all of the pages in the current scatterlist, move
> +	 * on to the next one.
> +	 */
> +	lm->map_reset = 0;
> +	sg_offset = se_mem->se_off;
> +	lm->sg_page = se_mem->se_page;
> +	lm->sg_length = se_mem->se_len;
> +
> +	DEBUG_MAP_SEGMENTS("LINUX_MAP1[%p]: Starting to se_mem->se_len: %u,"
> +		" se_mem->se_off: %u, se_mem->se_page: %p\n", se_mem,
> +		se_mem->se_len, se_mem->se_off, se_mem->se_page);;
> +	/*
> +	 * Get the base and length of the current page for use with the iovec.
> +	 */
> +recalc:
> +	lm->iovec_length = (lm->sg_length > (PAGE_SIZE - sg_offset)) ?
> +			   (PAGE_SIZE - sg_offset) : lm->sg_length;
> +
> +	DEBUG_MAP_SEGMENTS("LINUX_MAP: lm->iovec_length: %u, lm->sg_length: %u,"
> +		" sg_offset: %u\n", lm->iovec_length, lm->sg_length, sg_offset);
> +	/*
> +	 * See if there is any iSCSI offset we need to deal with.
> +	 */
> +	if (!lm->current_offset) {
> +		lm->iovec_base = page_address(lm->sg_page) + sg_offset;
> +
> +		if (*data_length < lm->iovec_length) {
> +			DEBUG_MAP_SEGMENTS("LINUX_MAP1[%p]: Reset"
> +				" lm->iovec_length to %d\n", se_mem,
> +				*data_length);
> +			lm->iovec_length = *data_length;
> +		}
> +
> +		DEBUG_MAP_SEGMENTS("LINUX_MAP2[%p]: No current_offset,"
> +			" set iovec_base to %p and set Current Page to %p\n",
> +			se_mem, lm->iovec_base, lm->sg_page);
> +
> +		return;
> +	}
> +
> +	/*
> +	 * We know the iSCSI offset is in the next page of the current
> +	 * scatterlist.  Increase the lm->sg_page pointer and try again.
> +	 */
> +	if (lm->current_offset >= lm->iovec_length) {
> +		DEBUG_MAP_SEGMENTS("LINUX_MAP3[%p]: Next Page:"
> +			" lm->current_offset: %u, iovec_length: %u"
> +			" sg_offset: %u\n", se_mem, lm->current_offset,
> +			lm->iovec_length, sg_offset);
> +
> +		lm->current_offset -= lm->iovec_length;
> +		lm->sg_length -= lm->iovec_length;
> +		lm->sg_page++;
> +		sg_offset = 0;
> +
> +		DEBUG_MAP_SEGMENTS("LINUX_MAP3[%p]: ** Skipping to Next Page,"
> +			" updated values: lm->current_offset: %u\n", se_mem,
> +			lm->current_offset);
> +
> +		goto recalc;
> +	}
> +
> +	/*
> +	 * The iSCSI offset is in the current page, increment the iovec
> +	 * base and reduce iovec length.
> +	 */
> +	lm->iovec_base = page_address(lm->sg_page);
> +
> +	DEBUG_MAP_SEGMENTS("LINUX_MAP4[%p]: Set lm->iovec_base to %p\n", se_mem,
> +			lm->iovec_base);
> +
> +	lm->iovec_base += sg_offset;
> +	lm->iovec_base += lm->current_offset;
> +	DEBUG_MAP_SEGMENTS("****** the OLD lm->iovec_length: %u lm->sg_length:"
> +		" %u\n", lm->iovec_length, lm->sg_length);
> +
> +	if ((lm->iovec_length - lm->current_offset) < *data_length)
> +		lm->iovec_length -= lm->current_offset;
> +	else
> +		lm->iovec_length = *data_length;
> +
> +	if ((lm->sg_length - lm->current_offset) < *data_length)
> +		lm->sg_length -= lm->current_offset;
> +	else
> +		lm->sg_length = *data_length;
> +
> +	lm->current_offset = 0;
> +
> +	DEBUG_MAP_SEGMENTS("****** the NEW lm->iovec_length %u lm->sg_length:"
> +		" %u\n", lm->iovec_length, lm->sg_length);
> +}
> +
> +/* #define iscsi_linux_get_iscsi_offset_DEBUG */
> +#ifdef iscsi_linux_get_iscsi_offset_DEBUG
> +#define DEBUG_GET_ISCSI_OFFSET(buf...) PYXPRINT(buf)
> +#else
> +#define DEBUG_GET_ISCSI_OFFSET(buf...)
> +#endif
> +
> +/*	get_iscsi_offset():
> + *
> + *
> + */
> +static int get_iscsi_offset(
> +	struct se_offset_map *lmap,
> +	struct se_unmap_sg *usg)
> +{
> +	u32 current_length = 0, current_iscsi_offset = lmap->iscsi_offset;
> +	u32 total_offset = 0;
> +	struct se_cmd *cmd = usg->se_cmd;
> +	struct se_mem *se_mem;
> +
> +	list_for_each_entry(se_mem, T_TASK(cmd)->t_mem_list, se_list)
> +		break;
> +
> +	if (!se_mem) {
> +		printk(KERN_ERR "Unable to locate se_mem from"
> +				" T_TASK(cmd)->t_mem_list\n");
> +		return -1;
> +	}
> +
> +	/*
> +	 * Locate the current offset from the passed iSCSI Offset.
> +	 */
> +	while (lmap->iscsi_offset != current_length) {
> +		/*
> +		 * The iSCSI Offset is within the current struct se_mem.
> +		 *
> +		 * Or:
> +		 *
> +		 * The iSCSI Offset is outside of the current struct se_mem.
> +		 * Recalculate the values and obtain the next struct se_mem pointer.
> +		 */
> +		total_offset += se_mem->se_len;
> +
> +		DEBUG_GET_ISCSI_OFFSET("ISCSI_OFFSET: current_length: %u,"
> +			" total_offset: %u, sg->length: %u\n",
> +			current_length, total_offset, se_mem->se_len);
> +
> +		if (total_offset > lmap->iscsi_offset) {
> +			current_length += current_iscsi_offset;
> +			lmap->orig_offset = lmap->current_offset =
> +				usg->t_offset = current_iscsi_offset;
> +			DEBUG_GET_ISCSI_OFFSET("ISCSI_OFFSET: Within Current"
> +				" struct se_mem: %p, current_length incremented to"
> +				" %u\n", se_mem, current_length);
> +		} else {
> +			current_length += se_mem->se_len;
> +			current_iscsi_offset -= se_mem->se_len;
> +
> +			DEBUG_GET_ISCSI_OFFSET("ISCSI_OFFSET: Outside of"
> +				" Current se_mem: %p, current_length"
> +				" incremented to %u and current_iscsi_offset"
> +				" decremented to %u\n", se_mem, current_length,
> +				current_iscsi_offset);
> +
> +			list_for_each_entry_continue(se_mem,
> +					T_TASK(cmd)->t_mem_list, se_list)
> +				break;
> +
> +			if (!se_mem) {
> +				printk(KERN_ERR "Unable to locate struct se_mem\n");
> +				return -1;
> +			}
> +		}
> +	}
> +	lmap->map_orig_se_mem = se_mem;
> +	usg->cur_se_mem = se_mem;
> +
> +	return 0;
> +}
> +
> +/* #define iscsi_OS_set_SG_iovec_ptrs_DEBUG */
> +#ifdef iscsi_OS_set_SG_iovec_ptrs_DEBUG
> +#define DEBUG_IOVEC_SCATTERLISTS(buf...) PYXPRINT(buf)
> +
> +static void iscsi_check_iovec_map(
> +	u32 iovec_count,
> +	u32 map_length,
> +	struct se_map_sg *map_sg,
> +	struct se_unmap_sg *unmap_sg)
> +{
> +	u32 i, iovec_map_length = 0;
> +	struct se_cmd *cmd = map_sg->se_cmd;
> +	struct iovec *iov = map_sg->iov;
> +	struct se_mem *se_mem;
> +
> +	for (i = 0; i < iovec_count; i++)
> +		iovec_map_length += iov[i].iov_len;
> +
> +	if (iovec_map_length == map_length)
> +		return;
> +
> +	printk(KERN_INFO "Calculated iovec_map_length: %u does not match passed"
> +		" map_length: %u\n", iovec_map_length, map_length);
> +	printk(KERN_INFO "ITT: 0x%08x data_length: %u data_direction %d\n",
> +		CMD_TFO(cmd)->get_task_tag(cmd), cmd->data_length,
> +		cmd->data_direction);
> +
> +	iovec_map_length = 0;
> +
> +	for (i = 0; i < iovec_count; i++) {
> +		printk(KERN_INFO "iov[%d].iov_[base,len]: %p / %u bytes------"
> +			"-->\n", i, iov[i].iov_base, iov[i].iov_len);
> +
> +		printk(KERN_INFO "iovec_map_length from %u to %u\n",
> +			iovec_map_length, iovec_map_length + iov[i].iov_len);
> +		iovec_map_length += iov[i].iov_len;
> +
> +		printk(KERN_INFO "XXXX_map_length from %u to %u\n", map_length,
> +				(map_length - iov[i].iov_len));
> +		map_length -= iov[i].iov_len;
> +	}
> +
> +	list_for_each_entry(se_mem, T_TASK(cmd)->t_mem_list, se_list) {
> +		printk(KERN_INFO "se_mem[%p]: offset: %u length: %u\n",
> +			se_mem, se_mem->se_off, se_mem->se_len);
> +	}
> +
> +	BUG();
> +}
> +
> +#else
> +#define DEBUG_IOVEC_SCATTERLISTS(buf...)
> +#define iscsi_check_iovec_map(a, b, c, d)
> +#endif
> +
> +static int iscsi_set_iovec_ptrs(
> +	struct se_map_sg *map_sg,
> +	struct se_unmap_sg *unmap_sg)
> +{
> +	u32 i = 0 /* For iovecs */, j = 0 /* For scatterlists */;
> +#ifdef iscsi_OS_set_SG_iovec_ptrs_DEBUG
> +	u32 orig_map_length = map_sg->data_length;
> +#endif
> +	struct se_cmd *cmd = map_sg->se_cmd;
> +	struct se_offset_map *lmap = &unmap_sg->lmap;
> +	struct iovec *iov = map_sg->iov;
> +
> +	/*
> +	 * Used for non scatterlist operations, assume a single iovec.
> +	 */
> +	if (!T_TASK(cmd)->t_tasks_se_num) {
> +		DEBUG_IOVEC_SCATTERLISTS("ITT: 0x%08x No struct se_mem elements"
> +			" present\n", CMD_TFO(cmd)->get_task_tag(cmd));
> +		iov[0].iov_base = (unsigned char *) T_TASK(cmd)->t_task_buf +
> +							map_sg->data_offset;
> +		iov[0].iov_len  = map_sg->data_length;
> +		return 1;
> +	}
> +
> +	/*
> +	 * Set lmap->map_reset = 1 so the first call to
> +	 * iscsi_calculate_map_segment() sets up the initial
> +	 * values for struct se_offset_map.
> +	 */
> +	lmap->map_reset = 1;
> +
> +	DEBUG_IOVEC_SCATTERLISTS("[-------------------] ITT: 0x%08x OS"
> +		" Independent Network POSIX defined iovectors to SE Memory"
> +		" [-------------------]\n\n", CMD_TFO(cmd)->get_task_tag(cmd));
> +
> +	/*
> +	 * Get a pointer to the first used scatterlist based on the passed
> +	 * offset. Also set the rest of the needed values in iscsi_linux_map_t.
> +	 */
> +	lmap->iscsi_offset = map_sg->data_offset;
> +	if (map_sg->sg_kmap_active) {
> +		unmap_sg->se_cmd = map_sg->se_cmd;
> +		get_iscsi_offset(lmap, unmap_sg);
> +		unmap_sg->data_length = map_sg->data_length;
> +	} else {
> +		lmap->current_offset = lmap->orig_offset;
> +	}
> +	lmap->map_se_mem = lmap->map_orig_se_mem;
> +
> +	DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: Total map_sg->data_length: %d,"
> +		" lmap->iscsi_offset: %d, cmd->orig_iov_data_count: %d\n",
> +		map_sg->data_length, lmap->iscsi_offset,
> +		cmd->orig_iov_data_count);
> +
> +	while (map_sg->data_length) {
> +		/*
> +		 * Time to get the virtual address for use with iovec pointers.
> +		 * This function will return the expected iovec_base address
> +		 * and iovec_length.
> +		 */
> +		iscsi_calculate_map_segment(&map_sg->data_length, lmap);
> +
> +		/*
> +		 * Set the iov.iov_base and iov.iov_len from the current values
> +		 * in iscsi_linux_map_t.
> +		 */
> +		iov[i].iov_base = lmap->iovec_base;
> +		iov[i].iov_len = lmap->iovec_length;
> +
> +		/*
> +		 * Subtract the final iovec length from the total length to be
> +		 * mapped, and the length of the current scatterlist.  Also
> +		 * perform the paranoid check to make sure we are not going to
> +		 * overflow the iovecs allocated for this command in the next
> +		 * pass.
> +		 */
> +		map_sg->data_length -= iov[i].iov_len;
> +		lmap->sg_length -= iov[i].iov_len;
> +
> +		DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: iov[%u].iov_len: %u\n",
> +				i, iov[i].iov_len);
> +		DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: lmap->sg_length: from %u"
> +			" to %u\n", lmap->sg_length + iov[i].iov_len,
> +				lmap->sg_length);
> +		DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: Changed total"
> +			" map_sg->data_length from %u to %u\n",
> +			map_sg->data_length + iov[i].iov_len,
> +			map_sg->data_length);
> +
> +		if ((++i + 1) > cmd->orig_iov_data_count) {
> +			printk(KERN_ERR "Current iovec count %u is greater than"
> +				" struct se_cmd->orig_data_iov_count %u, cannot"
> +				" continue.\n", i+1, cmd->orig_iov_data_count);
> +			return -1;
> +		}
> +
> +		/*
> +		 * All done mapping this scatterlist's pages, move on to
> +		 * the next scatterlist by setting lmap.map_reset = 1;
> +		 */
> +		if (!lmap->sg_length || !map_sg->data_length) {
> +			list_for_each_entry(lmap->map_se_mem,
> +					&lmap->map_se_mem->se_list, se_list)
> +				break;
> +
> +			if (!lmap->map_se_mem) {
> +				printk(KERN_ERR "Unable to locate next"
> +					" lmap->map_struct se_mem entry\n");
> +				return -1;
> +			}
> +			j++;
> +
> +			lmap->sg_page = NULL;
> +			lmap->map_reset = 1;
> +
> +			DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: Done with current"
> +				" scatterlist, incremented Generic scatterlist"
> +				" Counter to %d and reset = 1\n", j);
> +		} else
> +			lmap->sg_page++;
> +	}
> +
> +	unmap_sg->sg_count = j;
> +
> +	iscsi_check_iovec_map(i, orig_map_length, map_sg, unmap_sg);
> +
> +	return i;
> +}
> +
> +static void iscsi_map_SG_segments(struct se_unmap_sg *unmap_sg)
> +{
> +	u32 i = 0;
> +	struct se_cmd *cmd = unmap_sg->se_cmd;
> +	struct se_mem *se_mem = unmap_sg->cur_se_mem;
> +
> +	if (!(T_TASK(cmd)->t_tasks_se_num))
> +		return;
> +
> +	list_for_each_entry_continue(se_mem, T_TASK(cmd)->t_mem_list, se_list) {
> +		kmap(se_mem->se_page);
> +
> +		if (++i == unmap_sg->sg_count)
> +			break;
> +	}
> +}
> +
> +static void iscsi_unmap_SG_segments(struct se_unmap_sg *unmap_sg)
> +{
> +	u32 i = 0;
> +	struct se_cmd *cmd = unmap_sg->se_cmd;
> +	struct se_mem *se_mem = unmap_sg->cur_se_mem;
> +
> +	if (!(T_TASK(cmd)->t_tasks_se_num))
> +		return;
> +
> +	list_for_each_entry_continue(se_mem, T_TASK(cmd)->t_mem_list, se_list) {
> +		kunmap(se_mem->se_page);
> +
> +		if (++i == unmap_sg->sg_count)
> +			break;
> +	}
> +}
> +
>  /*	iscsi_handle_scsi_cmd():
>   *
>   *
> @@ -1940,7 +2375,7 @@ static inline int iscsi_handle_data_out(
>  	unmap_sg.fabric_cmd = (void *)cmd;
>  	unmap_sg.se_cmd = SE_CMD(cmd);
>  
> -	iov_ret = transport_generic_set_iovec_ptrs(&map_sg, &unmap_sg);
> +	iov_ret = iscsi_set_iovec_ptrs(&map_sg, &unmap_sg);
>  	if (iov_ret < 0)
>  		return -1;
>  
> @@ -1960,11 +2395,11 @@ static inline int iscsi_handle_data_out(
>  		rx_size += CRC_LEN;
>  	}
>  
> -	SE_CMD(cmd)->transport_map_SG_segments(&unmap_sg);
> +	iscsi_map_SG_segments(&unmap_sg);
>  
>  	rx_got = rx_data(conn, &SE_CMD(cmd)->iov_data[0], iov_count, rx_size);
>  
> -	SE_CMD(cmd)->transport_unmap_SG_segments(&unmap_sg);
> +	iscsi_unmap_SG_segments(&unmap_sg);
>  
>  	if (rx_got != rx_size)
>  		return -1;
> @@ -1985,7 +2420,7 @@ static inline int iscsi_handle_data_out(
>  		map_sg.data_length = hdr->length;
>  		map_sg.data_offset = hdr->offset;
>  
> -		if (transport_generic_set_iovec_ptrs(&map_sg, &unmap_sg) < 0)
> +		if (iscsi_set_iovec_ptrs(&map_sg, &unmap_sg) < 0)
>  			return -1;
>  
>  		crypto_hash_init(&conn->conn_rx_hash);
> @@ -2966,7 +3401,7 @@ static int iscsi_handle_immediate_data(
>  	unmap_sg.fabric_cmd = (void *)cmd;
>  	unmap_sg.se_cmd = SE_CMD(cmd);
>  
> -	iov_ret = transport_generic_set_iovec_ptrs(&map_sg, &unmap_sg);
> +	iov_ret = iscsi_set_iovec_ptrs(&map_sg, &unmap_sg);
>  	if (iov_ret < 0)
>  		return IMMEDIDATE_DATA_CANNOT_RECOVER;
>  
> @@ -2987,11 +3422,11 @@ static int iscsi_handle_immediate_data(
>  		rx_size += CRC_LEN;
>  	}
>  
> -	SE_CMD(cmd)->transport_map_SG_segments(&unmap_sg);
> +	iscsi_map_SG_segments(&unmap_sg);
>  
>  	rx_got = rx_data(conn, &SE_CMD(cmd)->iov_data[0], iov_count, rx_size);
>  
> -	SE_CMD(cmd)->transport_unmap_SG_segments(&unmap_sg);
> +	iscsi_unmap_SG_segments(&unmap_sg);
>  
>  	if (rx_got != rx_size) {
>  		iscsi_rx_thread_wait_for_TCP(conn);
> @@ -3014,7 +3449,7 @@ static int iscsi_handle_immediate_data(
>  		map_sg.data_length = length;
>  		map_sg.data_offset = cmd->write_data_done;
>  
> -		if (transport_generic_set_iovec_ptrs(&map_sg, &unmap_sg) < 0)
> +		if (iscsi_set_iovec_ptrs(&map_sg, &unmap_sg) < 0)
>  			return IMMEDIDATE_DATA_CANNOT_RECOVER;
>  
>  		crypto_hash_init(&conn->conn_rx_hash);
> @@ -3448,7 +3883,7 @@ static inline int iscsi_send_data_in(
>  	map_sg.data_length = datain.length;
>  	map_sg.data_offset = datain.offset;
>  
> -	iov_ret = transport_generic_set_iovec_ptrs(&map_sg, unmap_sg);
> +	iov_ret = iscsi_set_iovec_ptrs(&map_sg, unmap_sg);
>  	if (iov_ret < 0)
>  		return -1;
>  
> @@ -4724,27 +5159,27 @@ check_rsp_state:
>  
>  			if (map_sg && !CONN_OPS(conn)->IFMarker &&
>  			    T_TASK(se_cmd)->t_tasks_se_num) {
> -				SE_CMD(cmd)->transport_map_SG_segments(&unmap_sg);
> +				iscsi_map_SG_segments(&unmap_sg);
>  				if (iscsi_fe_sendpage_sg(&unmap_sg, conn) < 0) {
>  					conn->tx_response_queue = 0;
>  					iscsi_tx_thread_wait_for_TCP(conn);
> -					SE_CMD(cmd)->transport_unmap_SG_segments(&unmap_sg);
> +					iscsi_unmap_SG_segments(&unmap_sg);
>  					goto transport_err;
>  				}
> -				SE_CMD(cmd)->transport_unmap_SG_segments(&unmap_sg);
> +				iscsi_unmap_SG_segments(&unmap_sg);
>  				map_sg = 0;
>  			} else {
>  				if (map_sg)
> -					SE_CMD(cmd)->transport_map_SG_segments(&unmap_sg);
> +					iscsi_map_SG_segments(&unmap_sg);
>  				if (iscsi_send_tx_data(cmd, conn, use_misc) < 0) {
>  					conn->tx_response_queue = 0;
>  					iscsi_tx_thread_wait_for_TCP(conn);
>  					if (map_sg)
> -						SE_CMD(cmd)->transport_unmap_SG_segments(&unmap_sg);
> +						iscsi_unmap_SG_segments(&unmap_sg);
>  					goto transport_err;
>  				}
>  				if (map_sg) {
> -					SE_CMD(cmd)->transport_unmap_SG_segments(&unmap_sg);
> +					iscsi_unmap_SG_segments(&unmap_sg);
>  					map_sg = 0;
>  				}
>  			}
> Index: lio-core/drivers/target/target_core_transport.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_transport.c	2010-11-15 22:24:10.882003914 +0100
> +++ lio-core/drivers/target/target_core_transport.c	2010-11-15 22:24:16.976004054 +0100
> @@ -3080,408 +3080,6 @@ void transport_generic_request_timeout(s
>  	transport_generic_remove(cmd, 0, 0);
>  }
>  
> -/* #define iscsi_linux_calculate_map_segment_DEBUG */
> -#ifdef iscsi_linux_calculate_map_segment_DEBUG
> -#define DEBUG_MAP_SEGMENTS(buf...) PYXPRINT(buf)
> -#else
> -#define DEBUG_MAP_SEGMENTS(buf...)
> -#endif
> -
> -/*	transport_calculate_map_segment():
> - *
> - *
> - */
> -static inline void transport_calculate_map_segment(
> -	u32 *data_length,
> -	struct se_offset_map *lm)
> -{
> -	u32 sg_offset = 0;
> -	struct se_mem *se_mem = lm->map_se_mem;
> -
> -	DEBUG_MAP_SEGMENTS(" START Mapping se_mem: %p, Length: %d"
> -		"  Remaining iSCSI Data: %u\n", se_mem, se_mem->se_len,
> -		*data_length);
> -	/*
> -	 * Still working on pages in the current struct se_mem.
> -	 */
> -	if (!lm->map_reset) {
> -		lm->iovec_length = (lm->sg_length > PAGE_SIZE) ?
> -					PAGE_SIZE : lm->sg_length;
> -		if (*data_length < lm->iovec_length) {
> -			DEBUG_MAP_SEGMENTS("LINUX_MAP: Reset lm->iovec_length"
> -				" to %d\n", *data_length);
> -
> -			lm->iovec_length = *data_length;
> -		}
> -		lm->iovec_base = page_address(lm->sg_page) + sg_offset;
> -
> -		DEBUG_MAP_SEGMENTS("LINUX_MAP: Set lm->iovec_base to %p from"
> -			" lm->sg_page: %p\n", lm->iovec_base, lm->sg_page);
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
> -
> -	DEBUG_MAP_SEGMENTS("LINUX_MAP1[%p]: Starting to se_mem->se_len: %u,"
> -		" se_mem->se_off: %u, se_mem->se_page: %p\n", se_mem,
> -		se_mem->se_len, se_mem->se_off, se_mem->se_page);;
> -	/*
> -	 * Get the base and length of the current page for use with the iovec.
> -	 */
> -recalc:
> -	lm->iovec_length = (lm->sg_length > (PAGE_SIZE - sg_offset)) ?
> -			   (PAGE_SIZE - sg_offset) : lm->sg_length;
> -
> -	DEBUG_MAP_SEGMENTS("LINUX_MAP: lm->iovec_length: %u, lm->sg_length: %u,"
> -		" sg_offset: %u\n", lm->iovec_length, lm->sg_length, sg_offset);
> -	/*
> -	 * See if there is any iSCSI offset we need to deal with.
> -	 */
> -	if (!lm->current_offset) {
> -		lm->iovec_base = page_address(lm->sg_page) + sg_offset;
> -
> -		if (*data_length < lm->iovec_length) {
> -			DEBUG_MAP_SEGMENTS("LINUX_MAP1[%p]: Reset"
> -				" lm->iovec_length to %d\n", se_mem,
> -				*data_length);
> -			lm->iovec_length = *data_length;
> -		}
> -
> -		DEBUG_MAP_SEGMENTS("LINUX_MAP2[%p]: No current_offset,"
> -			" set iovec_base to %p and set Current Page to %p\n",
> -			se_mem, lm->iovec_base, lm->sg_page);
> -
> -		return;
> -	}
> -
> -	/*
> -	 * We know the iSCSI offset is in the next page of the current
> -	 * scatterlist.  Increase the lm->sg_page pointer and try again.
> -	 */
> -	if (lm->current_offset >= lm->iovec_length) {
> -		DEBUG_MAP_SEGMENTS("LINUX_MAP3[%p]: Next Page:"
> -			" lm->current_offset: %u, iovec_length: %u"
> -			" sg_offset: %u\n", se_mem, lm->current_offset,
> -			lm->iovec_length, sg_offset);
> -
> -		lm->current_offset -= lm->iovec_length;
> -		lm->sg_length -= lm->iovec_length;
> -		lm->sg_page++;
> -		sg_offset = 0;
> -
> -		DEBUG_MAP_SEGMENTS("LINUX_MAP3[%p]: ** Skipping to Next Page,"
> -			" updated values: lm->current_offset: %u\n", se_mem,
> -			lm->current_offset);
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
> -	DEBUG_MAP_SEGMENTS("LINUX_MAP4[%p]: Set lm->iovec_base to %p\n", se_mem,
> -			lm->iovec_base);
> -
> -	lm->iovec_base += sg_offset;
> -	lm->iovec_base += lm->current_offset;
> -	DEBUG_MAP_SEGMENTS("****** the OLD lm->iovec_length: %u lm->sg_length:"
> -		" %u\n", lm->iovec_length, lm->sg_length);
> -
> -	if ((lm->iovec_length - lm->current_offset) < *data_length)
> -		lm->iovec_length -= lm->current_offset;
> -	else
> -		lm->iovec_length = *data_length;
> -
> -	if ((lm->sg_length - lm->current_offset) < *data_length)
> -		lm->sg_length -= lm->current_offset;
> -	else
> -		lm->sg_length = *data_length;
> -
> -	lm->current_offset = 0;
> -
> -	DEBUG_MAP_SEGMENTS("****** the NEW lm->iovec_length %u lm->sg_length:"
> -		" %u\n", lm->iovec_length, lm->sg_length);
> -}
> -
> -/* #define iscsi_linux_get_iscsi_offset_DEBUG */
> -#ifdef iscsi_linux_get_iscsi_offset_DEBUG
> -#define DEBUG_GET_ISCSI_OFFSET(buf...) PYXPRINT(buf)
> -#else
> -#define DEBUG_GET_ISCSI_OFFSET(buf...)
> -#endif
> -
> -/*	transport_get_iscsi_offset():
> - *
> - *
> - */
> -static int transport_get_iscsi_offset(
> -	struct se_offset_map *lmap,
> -	struct se_unmap_sg *usg)
> -{
> -	u32 current_length = 0, current_iscsi_offset = lmap->iscsi_offset;
> -	u32 total_offset = 0;
> -	struct se_cmd *cmd = usg->se_cmd;
> -	struct se_mem *se_mem;
> -
> -	list_for_each_entry(se_mem, T_TASK(cmd)->t_mem_list, se_list)
> -		break;
> -
> -	if (!se_mem) {
> -		printk(KERN_ERR "Unable to locate se_mem from"
> -				" T_TASK(cmd)->t_mem_list\n");
> -		return -1;
> -	}
> -
> -	/*
> -	 * Locate the current offset from the passed iSCSI Offset.
> -	 */
> -	while (lmap->iscsi_offset != current_length) {
> -		/*
> -		 * The iSCSI Offset is within the current struct se_mem.
> -		 *
> -		 * Or:
> -		 *
> -		 * The iSCSI Offset is outside of the current struct se_mem.
> -		 * Recalculate the values and obtain the next struct se_mem pointer.
> -		 */
> -		total_offset += se_mem->se_len;
> -
> -		DEBUG_GET_ISCSI_OFFSET("ISCSI_OFFSET: current_length: %u,"
> -			" total_offset: %u, sg->length: %u\n",
> -			current_length, total_offset, se_mem->se_len);
> -
> -		if (total_offset > lmap->iscsi_offset) {
> -			current_length += current_iscsi_offset;
> -			lmap->orig_offset = lmap->current_offset =
> -				usg->t_offset = current_iscsi_offset;
> -			DEBUG_GET_ISCSI_OFFSET("ISCSI_OFFSET: Within Current"
> -				" struct se_mem: %p, current_length incremented to"
> -				" %u\n", se_mem, current_length);
> -		} else {
> -			current_length += se_mem->se_len;
> -			current_iscsi_offset -= se_mem->se_len;
> -
> -			DEBUG_GET_ISCSI_OFFSET("ISCSI_OFFSET: Outside of"
> -				" Current se_mem: %p, current_length"
> -				" incremented to %u and current_iscsi_offset"
> -				" decremented to %u\n", se_mem, current_length,
> -				current_iscsi_offset);
> -
> -			list_for_each_entry_continue(se_mem,
> -					T_TASK(cmd)->t_mem_list, se_list)
> -				break;
> -
> -			if (!se_mem) {
> -				printk(KERN_ERR "Unable to locate struct se_mem\n");
> -				return -1;
> -			}
> -		}
> -	}
> -	lmap->map_orig_se_mem = se_mem;
> -	usg->cur_se_mem = se_mem;
> -
> -	return 0;
> -}
> -
> -/* #define iscsi_OS_set_SG_iovec_ptrs_DEBUG */
> -#ifdef iscsi_OS_set_SG_iovec_ptrs_DEBUG
> -#define DEBUG_IOVEC_SCATTERLISTS(buf...) PYXPRINT(buf)
> -
> -static void iscsi_check_iovec_map(
> -	u32 iovec_count,
> -	u32 map_length,
> -	struct se_map_sg *map_sg,
> -	struct se_unmap_sg *unmap_sg)
> -{
> -	u32 i, iovec_map_length = 0;
> -	struct se_cmd *cmd = map_sg->se_cmd;
> -	struct iovec *iov = map_sg->iov;
> -	struct se_mem *se_mem;
> -
> -	for (i = 0; i < iovec_count; i++)
> -		iovec_map_length += iov[i].iov_len;
> -
> -	if (iovec_map_length == map_length)
> -		return;
> -
> -	printk(KERN_INFO "Calculated iovec_map_length: %u does not match passed"
> -		" map_length: %u\n", iovec_map_length, map_length);
> -	printk(KERN_INFO "ITT: 0x%08x data_length: %u data_direction %d\n",
> -		CMD_TFO(cmd)->get_task_tag(cmd), cmd->data_length,
> -		cmd->data_direction);
> -
> -	iovec_map_length = 0;
> -
> -	for (i = 0; i < iovec_count; i++) {
> -		printk(KERN_INFO "iov[%d].iov_[base,len]: %p / %u bytes------"
> -			"-->\n", i, iov[i].iov_base, iov[i].iov_len);
> -
> -		printk(KERN_INFO "iovec_map_length from %u to %u\n",
> -			iovec_map_length, iovec_map_length + iov[i].iov_len);
> -		iovec_map_length += iov[i].iov_len;
> -
> -		printk(KERN_INFO "XXXX_map_length from %u to %u\n", map_length,
> -				(map_length - iov[i].iov_len));
> -		map_length -= iov[i].iov_len;
> -	}
> -
> -	list_for_each_entry(se_mem, T_TASK(cmd)->t_mem_list, se_list) {
> -		printk(KERN_INFO "se_mem[%p]: offset: %u length: %u\n",
> -			se_mem, se_mem->se_off, se_mem->se_len);
> -	}
> -
> -	BUG();
> -}
> -
> -#else
> -#define DEBUG_IOVEC_SCATTERLISTS(buf...)
> -#define iscsi_check_iovec_map(a, b, c, d)
> -#endif
> -
> -int transport_generic_set_iovec_ptrs(
> -	struct se_map_sg *map_sg,
> -	struct se_unmap_sg *unmap_sg)
> -{
> -	u32 i = 0 /* For iovecs */, j = 0 /* For scatterlists */;
> -#ifdef iscsi_OS_set_SG_iovec_ptrs_DEBUG
> -	u32 orig_map_length = map_sg->data_length;
> -#endif
> -	struct se_cmd *cmd = map_sg->se_cmd;
> -	struct se_offset_map *lmap = &unmap_sg->lmap;
> -	struct iovec *iov = map_sg->iov;
> -
> -	/*
> -	 * Used for non scatterlist operations, assume a single iovec.
> -	 */
> -	if (!T_TASK(cmd)->t_tasks_se_num) {
> -		DEBUG_IOVEC_SCATTERLISTS("ITT: 0x%08x No struct se_mem elements"
> -			" present\n", CMD_TFO(cmd)->get_task_tag(cmd));
> -		iov[0].iov_base = (unsigned char *) T_TASK(cmd)->t_task_buf +
> -							map_sg->data_offset;
> -		iov[0].iov_len  = map_sg->data_length;
> -		return 1;
> -	}
> -
> -	/*
> -	 * Set lmap->map_reset = 1 so the first call to
> -	 * transport_calculate_map_segment() sets up the initial
> -	 * values for struct se_offset_map.
> -	 */
> -	lmap->map_reset = 1;
> -
> -	DEBUG_IOVEC_SCATTERLISTS("[-------------------] ITT: 0x%08x OS"
> -		" Independent Network POSIX defined iovectors to SE Memory"
> -		" [-------------------]\n\n", CMD_TFO(cmd)->get_task_tag(cmd));
> -
> -	/*
> -	 * Get a pointer to the first used scatterlist based on the passed
> -	 * offset. Also set the rest of the needed values in iscsi_linux_map_t.
> -	 */
> -	lmap->iscsi_offset = map_sg->data_offset;
> -	if (map_sg->sg_kmap_active) {
> -		unmap_sg->se_cmd = map_sg->se_cmd;
> -		transport_get_iscsi_offset(lmap, unmap_sg);
> -		unmap_sg->data_length = map_sg->data_length;
> -	} else {
> -		lmap->current_offset = lmap->orig_offset;
> -	}
> -	lmap->map_se_mem = lmap->map_orig_se_mem;
> -
> -	DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: Total map_sg->data_length: %d,"
> -		" lmap->iscsi_offset: %d, cmd->orig_iov_data_count: %d\n",
> -		map_sg->data_length, lmap->iscsi_offset,
> -		cmd->orig_iov_data_count);
> -
> -	while (map_sg->data_length) {
> -		/*
> -		 * Time to get the virtual address for use with iovec pointers.
> -		 * This function will return the expected iovec_base address
> -		 * and iovec_length.
> -		 */
> -		transport_calculate_map_segment(&map_sg->data_length, lmap);
> -
> -		/*
> -		 * Set the iov.iov_base and iov.iov_len from the current values
> -		 * in iscsi_linux_map_t.
> -		 */
> -		iov[i].iov_base = lmap->iovec_base;
> -		iov[i].iov_len = lmap->iovec_length;
> -
> -		/*
> -		 * Subtract the final iovec length from the total length to be
> -		 * mapped, and the length of the current scatterlist.  Also
> -		 * perform the paranoid check to make sure we are not going to
> -		 * overflow the iovecs allocated for this command in the next
> -		 * pass.
> -		 */
> -		map_sg->data_length -= iov[i].iov_len;
> -		lmap->sg_length -= iov[i].iov_len;
> -
> -		DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: iov[%u].iov_len: %u\n",
> -				i, iov[i].iov_len);
> -		DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: lmap->sg_length: from %u"
> -			" to %u\n", lmap->sg_length + iov[i].iov_len,
> -				lmap->sg_length);
> -		DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: Changed total"
> -			" map_sg->data_length from %u to %u\n",
> -			map_sg->data_length + iov[i].iov_len,
> -			map_sg->data_length);
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
> -		if (!lmap->sg_length || !map_sg->data_length) {
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
> -
> -			DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: Done with current"
> -				" scatterlist, incremented Generic scatterlist"
> -				" Counter to %d and reset = 1\n", j);
> -		} else
> -			lmap->sg_page++;
> -	}
> -
> -	unmap_sg->sg_count = j;
> -
> -	iscsi_check_iovec_map(i, orig_map_length, map_sg, unmap_sg);
> -
> -	return i;
> -}
> -EXPORT_SYMBOL(transport_generic_set_iovec_ptrs);
> -
>  /*	transport_generic_allocate_buf():
>   *
>   *	Called from transport_generic_new_cmd() in Transport Processing Thread.
> @@ -3517,50 +3115,6 @@ static int transport_generic_allocate_no
>  	return 0;
>  }
>  
> -/*	transport_generic_map_SG_segments():
> - *
> - *
> - */
> -static void transport_generic_map_SG_segments(struct se_unmap_sg *unmap_sg)
> -{
> -	u32 i = 0;
> -	struct se_cmd *cmd = unmap_sg->se_cmd;
> -	struct se_mem *se_mem = unmap_sg->cur_se_mem;
> -
> -	if (!(T_TASK(cmd)->t_tasks_se_num))
> -		return;
> -
> -	list_for_each_entry_continue(se_mem, T_TASK(cmd)->t_mem_list, se_list) {
> -		kmap(se_mem->se_page);
> -
> -		if (++i == unmap_sg->sg_count)
> -			break;
> -	}
> -}
> -
> -/*	transport_generic_unmap_SG_segments():
> - *
> - *
> - */
> -static void transport_generic_unmap_SG_segments(struct se_unmap_sg *unmap_sg)
> -{
> -	u32 i = 0;
> -	struct se_cmd *cmd = unmap_sg->se_cmd;
> -	struct se_mem *se_mem = unmap_sg->cur_se_mem;
> -
> -	if (!(T_TASK(cmd)->t_tasks_se_num))
> -		return;
> -
> -	list_for_each_entry_continue(se_mem, T_TASK(cmd)->t_mem_list, se_list) {
> -		kunmap(se_mem->se_page);
> -
> -		if (++i == unmap_sg->sg_count)
> -			break;
> -	}
> -
> -	return;
> -}
> -
>  static inline u32 transport_lba_21(unsigned char *cdb)
>  {
>  	return ((cdb[1] & 0x1f) << 16) | (cdb[2] << 8) | cdb[3];
> @@ -4173,12 +3727,6 @@ static inline u32 transport_get_size(
>  	return DEV_ATTRIB(dev)->block_size * sectors;
>  }
>  
> -static inline void transport_get_maps(struct se_cmd *cmd)
> -{
> -	cmd->transport_map_SG_segments = &transport_generic_map_SG_segments;
> -	cmd->transport_unmap_SG_segments = &transport_generic_unmap_SG_segments;
> -}
> -
>  unsigned char transport_asciihex_to_binaryhex(unsigned char val[2])
>  {
>  	unsigned char result = 0;
> @@ -4368,7 +3916,6 @@ static int transport_generic_cmd_sequenc
>  	if (core_scsi3_ua_check(cmd, cdb) < 0) {
>  		cmd->transport_wait_for_tasks =
>  				&transport_nop_wait_for_tasks;
> -		transport_get_maps(cmd);
>  		return TGCS_CHECK_CONDITION_UNIT_ATTENTION;
>  	}
>  	/*
> @@ -4377,7 +3924,6 @@ static int transport_generic_cmd_sequenc
>  	ret = T10_ALUA(su_dev)->alua_state_check(cmd, cdb, &alua_ascq);
>  	if (ret != 0) {
>  		cmd->transport_wait_for_tasks = &transport_nop_wait_for_tasks;
> -		transport_get_maps(cmd);
>  		/*
>  		 * Set SCSI additional sense code (ASC) to 'LUN Not Accessable';
>  		 * The ALUA additional sense code qualifier (ASCQ) is determined
> @@ -4402,7 +3948,6 @@ static int transport_generic_cmd_sequenc
>  					cmd, cdb, pr_reg_type) != 0) {
>  			cmd->transport_wait_for_tasks =
>  					&transport_nop_wait_for_tasks;
> -			transport_get_maps(cmd);
>  			return TGCS_RESERVATION_CONFLICT;
>  		}
>  		/*
> @@ -4419,7 +3964,6 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_6;
>  		cmd->transport_get_lba = &transport_lba_21;
>  		ret = TGCS_DATA_SG_IO_CDB;
> @@ -4430,7 +3974,6 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_10;
>  		cmd->transport_get_lba = &transport_lba_32;
>  		ret = TGCS_DATA_SG_IO_CDB;
> @@ -4441,7 +3984,6 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_12;
>  		cmd->transport_get_lba = &transport_lba_32;
>  		ret = TGCS_DATA_SG_IO_CDB;
> @@ -4452,7 +3994,6 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_16;
>  		cmd->transport_get_long_lba = &transport_lba_64;
>  		ret = TGCS_DATA_SG_IO_CDB;
> @@ -4463,7 +4004,6 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_6;
>  		cmd->transport_get_lba = &transport_lba_21;
>  		ret = TGCS_DATA_SG_IO_CDB;
> @@ -4474,7 +4014,6 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_10;
>  		cmd->transport_get_lba = &transport_lba_32;
>  		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
> @@ -4486,7 +4025,6 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_12;
>  		cmd->transport_get_lba = &transport_lba_32;
>  		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
> @@ -4498,7 +4036,6 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_16;
>  		cmd->transport_get_long_lba = &transport_lba_64;
>  		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
> @@ -4513,7 +4050,6 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_10;
>  		cmd->transport_get_lba = &transport_lba_32;
>  		passthrough = (TRANSPORT(dev)->transport_type ==
> @@ -4546,7 +4082,6 @@ static int transport_generic_cmd_sequenc
>  				return TGCS_UNSUPPORTED_CDB;
>  			size = transport_get_size(sectors, cdb, cmd);
>  			transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -			transport_get_maps(cmd);
>  			/*
>  			 * Use WRITE_32 and READ_32 opcodes for the emulated
>  			 * XDWRITE_READ_32 logic.
> @@ -4574,7 +4109,6 @@ static int transport_generic_cmd_sequenc
>  				return TGCS_UNSUPPORTED_CDB;
>  			size = transport_get_size(sectors, cdb, cmd);
>  			transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -			transport_get_maps(cmd);
>  			T_TASK(cmd)->t_task_lba = get_unaligned_be64(&cdb[12]);
>  			/*
>  			 * Skip the remaining assignments for TCM/PSCSI passthrough
> @@ -4626,25 +4160,21 @@ static int transport_generic_cmd_sequenc
>  			size = (cdb[8] << 8) + cdb[9];
>  		}
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case MODE_SELECT:
>  		size = cdb[4];
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_SG_IO_CDB;
>  		break;
>  	case MODE_SELECT_10:
>  		size = (cdb[7] << 8) + cdb[8];
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_SG_IO_CDB;
>  		break;
>  	case MODE_SENSE:
>  		size = cdb[4];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case MODE_SENSE_10:
> @@ -4654,13 +4184,11 @@ static int transport_generic_cmd_sequenc
>  	case LOG_SENSE:
>  		size = (cdb[7] << 8) + cdb[8];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case READ_BLOCK_LIMITS:
>  		size = READ_BLOCK_LEN;
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case GPCMD_GET_CONFIGURATION:
> @@ -4669,7 +4197,6 @@ static int transport_generic_cmd_sequenc
>  	case GPCMD_READ_TRACK_RZONE_INFO:
>  		size = (cdb[7] << 8) + cdb[8];
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_SG_IO_CDB;
>  		break;
>  	case PERSISTENT_RESERVE_IN:
> @@ -4680,20 +4207,17 @@ static int transport_generic_cmd_sequenc
>  			&core_scsi3_emulate_pr : NULL;
>  		size = (cdb[7] << 8) + cdb[8];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case GPCMD_MECHANISM_STATUS:
>  	case GPCMD_READ_DVD_STRUCTURE:
>  		size = (cdb[8] << 8) + cdb[9];
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_SG_IO_CDB;
>  		break;
>  	case READ_POSITION:
>  		size = READ_POSITION_LEN;
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case 0xa4:
> @@ -4717,13 +4241,11 @@ static int transport_generic_cmd_sequenc
>  			size = (cdb[8] << 8) + cdb[9];
>  		}
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case INQUIRY:
>  		size = (cdb[3] << 8) + cdb[4];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		/*
>  		 * Do implict HEAD_OF_QUEUE processing for INQUIRY.
>  		 * See spc4r17 section 5.3
> @@ -4735,13 +4257,11 @@ static int transport_generic_cmd_sequenc
>  	case READ_BUFFER:
>  		size = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case READ_CAPACITY:
>  		size = READ_CAP_LEN;
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case READ_MEDIA_SERIAL_NUMBER:
> @@ -4749,7 +4269,6 @@ static int transport_generic_cmd_sequenc
>  	case SECURITY_PROTOCOL_OUT:
>  		size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case SERVICE_ACTION_IN:
> @@ -4762,14 +4281,12 @@ static int transport_generic_cmd_sequenc
>  		size = (cdb[10] << 24) | (cdb[11] << 16) |
>  		       (cdb[12] << 8) | cdb[13];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case RECEIVE_DIAGNOSTIC:
>  	case SEND_DIAGNOSTIC:
>  		size = (cdb[3] << 8) | cdb[4];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  /* #warning FIXME: Figure out correct GPCMD_READ_CD blocksize. */
> @@ -4778,32 +4295,27 @@ static int transport_generic_cmd_sequenc
>  		sectors = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
>  		size = (2336 * sectors);
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  #endif
>  	case READ_TOC:
>  		size = cdb[8];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case REQUEST_SENSE:
>  		size = cdb[4];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case READ_ELEMENT_STATUS:
>  		size = 65536 * cdb[7] + 256 * cdb[8] + cdb[9];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case WRITE_BUFFER:
>  		size = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case RESERVE:
> @@ -4819,7 +4331,6 @@ static int transport_generic_cmd_sequenc
>  
>  		cmd->transport_allocate_resources =
>  				&transport_generic_allocate_none;
> -		transport_get_maps(cmd);
>  		/*
>  		 * Setup the legacy emulated handler for SPC-2 and
>  		 * >= SPC-3 compatible reservation handling (CRH=1)
> @@ -4846,7 +4357,6 @@ static int transport_generic_cmd_sequenc
>  
>  		cmd->transport_allocate_resources =
>  				&transport_generic_allocate_none;
> -		transport_get_maps(cmd);
>  		cmd->transport_emulate_cdb =
>  				(T10_RES(su_dev)->res_type !=
>  				 SPC_PASSTHROUGH) ?
> @@ -4857,7 +4367,6 @@ static int transport_generic_cmd_sequenc
>  	case 0x91: /* SYNCHRONIZE_CACHE_16: */
>  		cmd->transport_allocate_resources =
>  				&transport_generic_allocate_none;
> -		transport_get_maps(cmd);
>  		/*
>  		 * Extract LBA and range to be flushed for emulated SYNCHRONIZE_CACHE
>  		 */
> @@ -4895,7 +4404,6 @@ static int transport_generic_cmd_sequenc
>  				&transport_generic_allocate_buf;
>  		size = get_unaligned_be16(&cdb[7]);
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		passthrough = (TRANSPORT(dev)->transport_type ==
>  				TRANSPORT_PLUGIN_PHBA_PDEV);
>  		/*
> @@ -4918,7 +4426,6 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		T_TASK(cmd)->t_task_lba = get_unaligned_be16(&cdb[2]);
>  		passthrough = (TRANSPORT(dev)->transport_type ==
>  				TRANSPORT_PLUGIN_PHBA_PDEV);
> @@ -4964,7 +4471,6 @@ static int transport_generic_cmd_sequenc
>  	case MOVE_MEDIUM:
>  		cmd->transport_allocate_resources =
>  				&transport_generic_allocate_none;
> -		transport_get_maps(cmd);
>  		ret = TGCS_NON_DATA_CDB;
>  		break;
>  	case REPORT_LUNS:
> @@ -4972,7 +4478,6 @@ static int transport_generic_cmd_sequenc
>  				&transport_core_report_lun_response;
>  		size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> -		transport_get_maps(cmd);
>  		/*
>  		 * Do implict HEAD_OF_QUEUE processing for REPORT_LUNS
>  		 * See spc4r17 section 5.3
> @@ -4986,7 +4491,6 @@ static int transport_generic_cmd_sequenc
>  			" 0x%02x, sending CHECK_CONDITION.\n",
>  			CMD_TFO(cmd)->get_fabric_name(), cdb[0]);
>  		cmd->transport_wait_for_tasks = &transport_nop_wait_for_tasks;
> -		transport_get_maps(cmd);
>  		return TGCS_UNSUPPORTED_CDB;
>  	}
>  
> Index: lio-core/include/target/target_core_base.h
> ===================================================================
> --- lio-core.orig/include/target/target_core_base.h	2010-11-15 22:24:10.890004612 +0100
> +++ lio-core/include/target/target_core_base.h	2010-11-15 22:29:49.888255486 +0100
> @@ -518,42 +518,6 @@ struct se_transform_info {
>  	struct se_device *ti_obj_ptr;
>  } ____cacheline_aligned;
>  
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
> -} ____cacheline_aligned;
> -
> -struct se_map_sg {
> -	int			sg_kmap_active:1;
> -	u32			data_length;
> -	u32			data_offset;
> -	void			*fabric_cmd;
> -	struct se_cmd		*se_cmd;
> -	struct iovec		*iov;
> -} ____cacheline_aligned;
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
> -} ____cacheline_aligned;
> -
>  struct se_cmd {
>  	/* SAM response code being sent to initiator */
>  	u8			scsi_status;
> @@ -616,9 +580,7 @@ struct se_cmd {
>  	void (*transport_free_resources)(struct se_cmd *);
>  	u32 (*transport_get_lba)(unsigned char *);
>  	unsigned long long (*transport_get_long_lba)(unsigned char *);
> -	void (*transport_map_SG_segments)(struct se_unmap_sg *);
>  	void (*transport_passthrough_done)(struct se_cmd *);
> -	void (*transport_unmap_SG_segments)(struct se_unmap_sg *);
>  	void (*transport_split_cdb)(unsigned long long, u32 *, unsigned char *);
>  	void (*transport_wait_for_tasks)(struct se_cmd *, int, int);
>  	void (*transport_complete_callback)(struct se_cmd *);
> Index: lio-core/include/target/target_core_transport.h
> ===================================================================
> --- lio-core.orig/include/target/target_core_transport.h	2010-11-15 22:24:10.909004402 +0100
> +++ lio-core/include/target/target_core_transport.h	2010-11-15 22:24:16.985015718 +0100
> @@ -256,8 +256,6 @@ extern u32 transport_generic_get_cdb_cou
>  extern int transport_generic_new_cmd(struct se_cmd *);
>  extern void transport_generic_process_write(struct se_cmd *);
>  extern int transport_generic_do_tmr(struct se_cmd *);
> -extern int transport_generic_set_iovec_ptrs(struct se_map_sg *map_sg,
> -	struct se_unmap_sg *unmap_sg);
>  /* From target_core_alua.c */
>  extern int core_alua_check_nonop_delay(struct se_cmd *);
>  
> @@ -498,10 +496,6 @@ struct se_subsystem_api {
>  	 */
>  	void (*map_task_to_SG)(struct se_task *);
>  	/*
> -	 * set_iovec_ptrs():
> -	 */
> -	int (*set_iovec_ptrs)(struct se_map_sg *, struct se_unmap_sg *);
> -	/*
>  	 * write_pending():
>  	 */
>  	int (*write_pending)(struct se_task *);
> Index: lio-core/drivers/target/lio-target/iscsi_target_util.h
> ===================================================================
> --- lio-core.orig/drivers/target/lio-target/iscsi_target_util.h	2010-11-15 22:28:03.998004332 +0100
> +++ lio-core/drivers/target/lio-target/iscsi_target_util.h	2010-11-15 22:30:01.069170701 +0100
> @@ -4,7 +4,42 @@
>  #define MARKER_SIZE	8
>  
>  struct se_cmd;
> -struct se_unmap_sg;
> +
> +struct se_offset_map {
> +	int                     map_reset;
> +	u32                     iovec_length;
> +	u32                     iscsi_offset;
> +	u32                     current_offset;
> +	u32                     orig_offset;
> +	u32                     sg_count;
> +	u32                     sg_current;
> +	u32                     sg_length;
> +	struct page		*sg_page;
> +	struct se_mem		*map_se_mem;
> +	struct se_mem		*map_orig_se_mem;
> +	void			*iovec_base;
> +} ____cacheline_aligned;
> +
> +struct se_map_sg {
> +	int			sg_kmap_active:1;
> +	u32			data_length;
> +	u32			data_offset;
> +	void			*fabric_cmd;
> +	struct se_cmd		*se_cmd;
> +	struct iovec		*iov;
> +} ____cacheline_aligned;
> +
> +struct se_unmap_sg {
> +	u32			data_length;
> +	u32			sg_count;
> +	u32			sg_offset;
> +	u32			padding;
> +	u32			t_offset;
> +	void			*fabric_cmd;
> +	struct se_cmd		*se_cmd;
> +	struct se_offset_map	lmap;
> +	struct se_mem		*cur_se_mem;
> +} ____cacheline_aligned;
>  
>  extern void iscsi_attach_cmd_to_queue(struct iscsi_conn *, struct iscsi_cmd *);
>  extern void iscsi_remove_cmd_from_conn_list(struct iscsi_cmd *, struct iscsi_conn *);

