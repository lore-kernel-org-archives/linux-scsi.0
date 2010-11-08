From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 9/9] target: remove dead call to
	transport_emulate_control_cdb in rd driver
Date: Mon, 08 Nov 2010 14:44:00 -0800
Message-ID: <1289256240.27226.97.camel@haakon2.linux-iscsi.org>
References: <20101108155601.872926000@canuck.infradead.org>
	 <20101108155649.134552948@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43452 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab0KHWtM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 17:49:12 -0500
In-Reply-To: <20101108155649.134552948@canuck.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2010-11-08 at 10:56 -0500, Christoph Hellwig wrote:
> plain text document attachment (lio-mark-target_core_transport-static)
> We'll never reach a non-pscsi backend for non-data CDBs these days.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Woops, missed during the CDB emulation 'push-up'.  Committed as
15ecfc43eb3.

Thanks!

--nab

> Index: lio-core-2.6/drivers/target/target_core_rd.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_rd.c	2010-11-08 16:31:38.968196346 +0100
> +++ lio-core-2.6/drivers/target/target_core_rd.c	2010-11-08 16:31:42.041529681 +0100
> @@ -972,9 +972,6 @@ static int rd_DIRECT_allocate_DMA(struct
>   */
>  static int rd_DIRECT_do_task(struct se_task *task)
>  {
> -	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
> -		return transport_emulate_control_cdb(task);
> -
>  	/*
>  	 * At this point the locally allocated RD tables have been mapped
>  	 * to struct se_mem elements in rd_DIRECT_do_se_mem_map().
> Index: lio-core-2.6/drivers/target/target_core_transport.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_transport.c	2010-11-08 16:31:58.868196346 +0100
> +++ lio-core-2.6/drivers/target/target_core_transport.c	2010-11-08 16:32:42.158196349 +0100
> @@ -209,6 +209,7 @@ static int transport_generic_write_pendi
>  static int transport_processing_thread(void *);
>  static int transport_new_cmd_obj(struct se_cmd *cmd,
>  		struct se_transform_info *ti, int post_execute);
> +static int transport_emulate_control_cdb(struct se_task *task);
>  
>  static char *transport_passthrough_get_fabric_name(void)
>  {
> @@ -5462,7 +5463,7 @@ static int transport_generic_write_same(
>   * Used by TCM subsystem plugins IBLOCK, FILEIO, and RAMDISK as a
>   * generic non SCF_SCSI_DATA_SG_IO_CDB ops.
>   */
> -int transport_emulate_control_cdb(struct se_task *task)
> +static int transport_emulate_control_cdb(struct se_task *task)
>  {
>  	struct se_cmd *cmd = TASK_CMD(task);
>  	struct se_device *dev = SE_DEV(cmd);
> Index: lio-core-2.6/include/target/target_core_transport.h
> ===================================================================
> --- lio-core-2.6.orig/include/target/target_core_transport.h	2010-11-08 16:31:49.168196346 +0100
> +++ lio-core-2.6/include/target/target_core_transport.h	2010-11-08 16:31:51.141529681 +0100
> @@ -232,7 +232,6 @@ extern int transport_generic_emulate_mod
>  extern int transport_generic_emulate_request_sense(struct se_cmd *,
>  						   unsigned char *);
>  extern int transport_get_sense_data(struct se_cmd *);
> -extern int transport_emulate_control_cdb(struct se_task *);
>  extern struct se_cmd *transport_allocate_passthrough(unsigned char *, int, u32,
>  						void *, u32, u32, void *);
>  extern void transport_passthrough_release(struct se_cmd *);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

