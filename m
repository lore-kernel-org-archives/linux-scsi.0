From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: Buffer overflow
Date: Thu, 30 Jul 2009 10:58:51 -0500
Message-ID: <4A71C33B.5050908@linux.vnet.ibm.com>
References: <4A6EFC65.2060905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40273 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbZG3P6x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2009 11:58:53 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n6UFrKtx012166
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2009 11:53:20 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n6UFwr54251726
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2009 11:58:53 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6UFwr9f030029
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2009 11:58:53 -0400
In-Reply-To: <4A6EFC65.2060905@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: brking@us.ibm.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

I see no value in shortening the lengths of the other fields. The compiler is
going to pad the data structure anyway, so I would just as soon do it manually.
I would propose the one line patch below to fix the buffer overflow.

Thanks,

Brian


Roel Kluin wrote:
> ioa_cfg->ipr_cmd_label is 8 bytes, IPR_CMD_LABEL is the string "ipr_cmnd",
> ie 9 bytes including terminating null.
> 
> This patch also corrects the sizes of the other strings.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Found with Parfait, http://research.sun.com/projects/parfait/
> 
> diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
> index 4b63dd6..44cb128 100644
> --- a/drivers/scsi/ipr.h
> +++ b/drivers/scsi/ipr.h
> @@ -1081,7 +1081,7 @@ enum ipr_cache_state {
> 
>  /* Per-controller data */
>  struct ipr_ioa_cfg {
> -	char eye_catcher[8];
> +	char eye_catcher[7];
>  #define IPR_EYECATCHER			"iprcfg"
> 
>  	struct list_head queue;
> @@ -1111,7 +1111,7 @@ struct ipr_ioa_cfg {
>  #define IPR_NUM_TRACE_INDEX_BITS	8
>  #define IPR_NUM_TRACE_ENTRIES		(1 << IPR_NUM_TRACE_INDEX_BITS)
>  #define IPR_TRACE_SIZE	(sizeof(struct ipr_trace_entry) * IPR_NUM_TRACE_ENTRIES)
> -	char trace_start[8];
> +	char trace_start[6];
>  #define IPR_TRACE_START_LABEL			"trace"
>  	struct ipr_trace_entry *trace;
>  	u32 trace_index:IPR_NUM_TRACE_INDEX_BITS;
> @@ -1119,18 +1119,18 @@ struct ipr_ioa_cfg {
>  	/*
>  	 * Queue for free command blocks
>  	 */
> -	char ipr_free_label[8];
> +	char ipr_free_label[7];
>  #define IPR_FREEQ_LABEL			"free-q"
>  	struct list_head free_q;
> 
>  	/*
>  	 * Queue for command blocks outstanding to the adapter
>  	 */
> -	char ipr_pending_label[8];
> +	char ipr_pending_label[7];
>  #define IPR_PENDQ_LABEL			"pend-q"
>  	struct list_head pending_q;
> 
> -	char cfg_table_start[8];
> +	char cfg_table_start[4];
>  #define IPR_CFG_TBL_START		"cfg"
>  	struct ipr_config_table *cfg_table;
>  	dma_addr_t cfg_table_dma;
> @@ -1141,7 +1141,7 @@ struct ipr_ioa_cfg {
>  	struct list_head free_res_q;
>  	struct list_head used_res_q;
> 
> -	char ipr_hcam_label[8];
> +	char ipr_hcam_label[6];
>  #define IPR_HCAM_LABEL			"hcams"
>  	struct ipr_hostrcb *hostrcb[IPR_NUM_HCAMS];
>  	dma_addr_t hostrcb_dma[IPR_NUM_HCAMS];
> @@ -1198,7 +1198,7 @@ struct ipr_ioa_cfg {
>  	int (*reset) (struct ipr_cmnd *);
> 
>  	struct ata_host ata_host;
> -	char ipr_cmd_label[8];
> +	char ipr_cmd_label[9];
>  #define IPR_CMD_LABEL		"ipr_cmnd"
>  	struct ipr_cmnd *ipr_cmnd_list[IPR_NUM_CMD_BLKS];
>  	u32 ipr_cmnd_list_dma[IPR_NUM_CMD_BLKS];
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center




Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.h~ipr_ipr_cmnd_bo drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_ipr_cmnd_bo	2009-07-30 09:57:47.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2009-07-30 09:57:47.000000000 -0500
@@ -1199,7 +1199,7 @@ struct ipr_ioa_cfg {
 
 	struct ata_host ata_host;
 	char ipr_cmd_label[8];
-#define IPR_CMD_LABEL		"ipr_cmnd"
+#define IPR_CMD_LABEL		"ipr_cmd"
 	struct ipr_cmnd *ipr_cmnd_list[IPR_NUM_CMD_BLKS];
 	u32 ipr_cmnd_list_dma[IPR_NUM_CMD_BLKS];
 };
_
