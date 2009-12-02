From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [patch] qla2xxx: use F/W calculated residual length.
Date: Wed, 2 Dec 2009 12:39:42 -0800
Message-ID: <918733AE-DAE0-4B10-B013-5D26895130F0@qlogic.com>
References: <20091201013720.GA15068@joejin-pc.cn.oracle.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:17456 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbZLBUji (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2009 15:39:38 -0500
In-Reply-To: <20091201013720.GA15068@joejin-pc.cn.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Jin <joe.jin@oracle.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "gurudas.pai@oracle.com" <gurudas.pai@oracle.com>, "kate.zhang@oracle.com" <kate.zhang@oracle.com>


On Nov 30, 2009, at 5:37 PM, Joe Jin wrote:

> Hi,
>
> When comp_status is CS_DATA_OVERRUN, residual length calculated by F/ 
> W,
> but when comp_status is CS_COMMPLETE, residual length just set to  
> residual
> count, at here calculated residual length may via F/W?

In case of good scsi completion with residual flag set, then firmware  
does not report the residual information, hence, driver depends upon  
the scsi residual obtained from target. The code does this now.

In case of over-run condition driver reports DID_ERROR to mid layer.

In case of under-run condition, the firmware detects and reports under  
run length which can be different from what obtained from target.  
Hence, driver gives preference to firmware reported residual length.

>
>
> Please review.
>
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> CC: Andrew Vasquez <andrew.vasquez@qlogic.com>
>
> ---
> qla_isr.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/ 
> qla_isr.c
> index b20a716..4d1d410 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1398,7 +1398,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha,  
> struct rsp_que *rsp, void *pkt)
> 			break;
> 		}
> 		if (scsi_status & (SS_RESIDUAL_UNDER | SS_RESIDUAL_OVER)) {
> -			resid = resid_len;
> +			resid = IS_FWI2_CAPABLE(ha) ? fw_resid_len : resid_len;
> 			scsi_set_resid(cp, resid);
>
> 			if (!lscsi_status &&
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

