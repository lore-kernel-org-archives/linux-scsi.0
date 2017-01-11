From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 02/11] qla2xxx: Cleanup TMF code translation from
 qla_target.
Date: Wed, 11 Jan 2017 12:05:17 -0800
Message-ID: <c4a6fb9b-5523-5070-50ed-b869a4686262@sandisk.com>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
 <1482553419-4117-3-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482553419-4117-3-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, target-devel@vger.kernel.org, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/23/2016 08:23 PM, Himanshu Madhani wrote:
>  static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
> -	uint8_t tmr_func, uint32_t tag)
> +	uint16_t tmr_func, uint32_t tag)
>  {
>  	struct qla_tgt_sess *sess = mcmd->sess;
>  	struct se_cmd *se_cmd = &mcmd->se_cmd;
> +	int transl_tmr_func;
> +
> +	switch (tmr_func) {
> +	case QLA_TGT_ABTS:
> +		pr_debug("%ld: ABTS received\n", sess->vha->host_no);
> +		transl_tmr_func = TMR_ABORT_TASK;
> +		break;
> +	case QLA_TGT_2G_ABORT_TASK:
> +		pr_debug("%ld: 2G Abort Task received\n", sess->vha->host_no);
> +		transl_tmr_func = TMR_ABORT_TASK;
> +		break;
> +	case QLA_TGT_CLEAR_ACA:
> +		pr_debug("%ld: CLEAR_ACA received\n", sess->vha->host_no);
> +		transl_tmr_func = TMR_CLEAR_ACA;
> +		break;
> +	case QLA_TGT_TARGET_RESET:
> +		pr_debug("%ld: TARGET_RESET received\n", sess->vha->host_no);
> +		transl_tmr_func = TMR_TARGET_WARM_RESET;
> +		break;
> +	case QLA_TGT_LUN_RESET:
> +		pr_debug("%ld: LUN_RESET received\n", sess->vha->host_no);
> +		transl_tmr_func = TMR_LUN_RESET;
> +		break;
> +	case QLA_TGT_CLEAR_TS:
> +		pr_debug("%ld: CLEAR_TS received\n", sess->vha->host_no);
> +		transl_tmr_func = TMR_CLEAR_TASK_SET;
> +		break;
> +	case QLA_TGT_ABORT_TS:
> +		pr_debug("%ld: ABORT_TS received\n", sess->vha->host_no);
> +		transl_tmr_func = TMR_ABORT_TASK_SET;
> +		break;
> +	default:
> +		pr_debug("%ld: Unknown task mgmt fn 0x%x\n",
> +		    sess->vha->host_no, tmr_func);
> +		return -ENOSYS;
> +		break;
> +	}
>  
>  	return target_submit_tmr(se_cmd, sess->se_sess, NULL, lun, mcmd,
>  			tmr_func, GFP_ATOMIC, tag, TARGET_SCF_ACK_KREF);

Hello Himanshu and Quinn,

This patch introduces a new compiler warning when building with W=1,
namely that transl_tmr_func is set but not used. Please review the code.

Thanks,

Bart.
