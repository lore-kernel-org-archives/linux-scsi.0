From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/3] qla2xxx: Remove set-but-not-used variables
Date: Thu, 31 Mar 2016 09:37:49 +0200
Message-ID: <082453e484e89dd27b877373bf51ad0e@suse.de>
References: <56FC6049.3090303@sandisk.com> <56FC6076.2030900@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbcCaHhv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 03:37:51 -0400
In-Reply-To: <56FC6076.2030900@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-03-31 01:25, Bart Van Assche wrote:
> Detected these variables by building the qla2xxx driver with W=1.
> Note: removing the code that sets BIT_14 is fine since that bit is
> never tested. The output of git grep -nH -- '->cmd_flags\s*&'
> drivers/scsi/qla2xxx
> is as follows:
> 
> drivers/scsi/qla2xxx/tcm_qla2xxx.c:285:	WARN_ON(cmd->cmd_flags &  
> BIT_16);
> drivers/scsi/qla2xxx/tcm_qla2xxx.c:302:	BUG_ON(cmd->cmd_flags & 
> BIT_20);
> drivers/scsi/qla2xxx/tcm_qla2xxx.c:627:	if (cmd->cmd_flags &  BIT_5) {
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Quinn Tran <quinn.tran@qlogic.com>
> Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c    | 3 +--
>  drivers/scsi/qla2xxx/qla_mbx.c     | 2 --
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 7 -------
>  3 files changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c 
> b/drivers/scsi/qla2xxx/qla_attr.c
> index 4dc06a13..db85c5c 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -839,7 +839,6 @@ qla2x00_issue_logo(struct file *filp, struct 
> kobject *kobj,
>  	struct scsi_qla_host *vha = 
> shost_priv(dev_to_shost(container_of(kobj,
>  	    struct device, kobj)));
>  	int type;
> -	int rval = 0;
>  	port_id_t did;
> 
>  	type = simple_strtol(buf, NULL, 10);
> @@ -853,7 +852,7 @@ qla2x00_issue_logo(struct file *filp, struct 
> kobject *kobj,
> 
>  	ql_log(ql_log_info, vha, 0x70e4, "%s: %d\n", __func__, type);
> 
> -	rval = qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, did);
> +	qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, did);
>  	return count;
>  }
> 

OK, qla24xx_els_dcmd_iocb() is a bit scary. It can return -ENOMEM, but 
no caller checks it (the 2nd caller _only_ checks the return value in a 
debug message). Maybe we should think about that.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c 
> b/drivers/scsi/qla2xxx/qla_mbx.c
> index 968b846..bf2d357 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -607,7 +607,6 @@ qla_set_exlogin_mem_cfg(scsi_qla_host_t *vha,
> dma_addr_t phys_addr)
>  	mbx_cmd_t	mc;
>  	mbx_cmd_t	*mcp = &mc;
>  	struct qla_hw_data *ha = vha->hw;
> -	int configured_count;
> 
>  	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x111a,
>  	    "Entered %s.\n", __func__);
> @@ -630,7 +629,6 @@ qla_set_exlogin_mem_cfg(scsi_qla_host_t *vha,
> dma_addr_t phys_addr)
>  		/*EMPTY*/
>  		ql_dbg(ql_dbg_mbx, vha, 0x111b, "Failed=%x.\n", rval);
>  	} else {
> -		configured_count = mcp->mb[11];
>  		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x118c,
>  		    "Done %s.\n", __func__);
>  	}
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index c1461d2..97fcbf2 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -311,13 +311,6 @@ static void tcm_qla2xxx_free_cmd(struct 
> qla_tgt_cmd *cmd)
>   */
>  static int tcm_qla2xxx_check_stop_free(struct se_cmd *se_cmd)
>  {
> -	struct qla_tgt_cmd *cmd;
> -
> -	if ((se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) == 0) {
> -		cmd = container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
> -		cmd->cmd_flags |= BIT_14;
> -	}
> -
>  	return target_put_sess_cmd(se_cmd);
>  }

Apart from the qla24xx_els_dcmd_iocb() thingy (which has nothing to do 
with your patch)
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

