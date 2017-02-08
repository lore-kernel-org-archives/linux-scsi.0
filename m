From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 10/14] qla2xxx: Fix request queue corruption.
Date: Wed, 8 Feb 2017 19:22:00 +0000
Message-ID: <1486581707.16026.20.camel@sandisk.com>
References: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
         <1486161655-2307-11-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1486161655-2307-11-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <AA90EE6D0508D24BA507E1B613FD8408@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-02-03 at 14:40 -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> When FW notify driver or driver detects low FW resource,
> driver tries to send out Busy SCSI Status to tell Initiator
> side to back off. During the send process, the lock was not held.
> 
> Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index b61cbb8..b5fb9c55 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -5170,16 +5170,22 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
>  
>  static int
>  qlt_chk_qfull_thresh_hold(struct scsi_qla_host *vha,
> -	struct atio_from_isp *atio)
> +	struct atio_from_isp *atio, uint8_t ha_locked)
>  {
>  	struct qla_hw_data *ha = vha->hw;
>  	uint16_t status;
> +	unsigned long flags;
>  
>  	if (ha->tgt.num_pend_cmds < Q_FULL_THRESH_HOLD(ha))
>  		return 0;
>  
> +	if (!ha_locked)
> +		spin_lock_irqsave(&ha->hardware_lock, flags);
>  	status = temp_sam_status;
>  	qlt_send_busy(vha, atio, status);
> +	if (!ha_locked)
> +		spin_unlock_irqrestore(&ha->hardware_lock, flags);
> +
>  	return 1;
>  }
>  
> @@ -5224,7 +5230,7 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
>  
>  
>  		if (likely(atio->u.isp24.fcp_cmnd.task_mgmt_flags == 0)) {
> -			rc = qlt_chk_qfull_thresh_hold(vha, atio);
> +			rc = qlt_chk_qfull_thresh_hold(vha, atio, ha_locked);
>  			if (rc != 0) {
>  				tgt->atio_irq_cmd_count--;
>  				return;
> @@ -5347,7 +5353,7 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
>  			break;
>  		}
>  
> -		rc = qlt_chk_qfull_thresh_hold(vha, atio);
> +		rc = qlt_chk_qfull_thresh_hold(vha, atio, 1);
>  		if (rc != 0) {
>  			tgt->irq_cmd_count--;
>  			return;

Hello Quinn,

Please consider to use bool instead of uint8_t for ha_locked and true /
false instead of 1 / 0.

Bart.