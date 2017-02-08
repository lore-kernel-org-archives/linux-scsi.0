From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 01/14] qla2xxx: Fix delayed response to command for
 loop mode/direct connect.
Date: Wed, 8 Feb 2017 18:35:54 +0000
Message-ID: <1486578941.16026.7.camel@sandisk.com>
References: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
         <1486161655-2307-2-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:36059 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbdBHSiU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 13:38:20 -0500
In-Reply-To: <1486161655-2307-2-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <5A7E46C3E8BECD4AB6D99E25B6C91FD9@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>

On Fri, 2017-02-03 at 14:40 -0800, Himanshu Madhani wrote:
> +static void qla2x00_iocb_work_fn(struct work_struct *work)
> +{
> +	struct scsi_qla_host *vha = container_of(work,
> +		struct scsi_qla_host, iocb_work);
> +	unsigned long flags;
> +	int cnt = 0;
> +
> +	while (!list_empty(&vha->work_list)) {
> +		qla2x00_do_work(vha);
> +		cnt++;
> +		if (cnt > 10)
> +			break;
> +	}
> +
> +	spin_lock_irqsave(&vha->work_lock, flags);
> +	vha->flags.iocb_work_sheduled = 0;
> +	spin_unlock_irqrestore(&vha->work_lock, flags);
> +}
> +
> +void qla2x00_schedule_work(struct scsi_qla_host *vha)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vha->work_lock, flags);
> +	if (vha->flags.iocb_work_sheduled) {
> +		spin_unlock_irqrestore(&vha->work_lock, flags);
> +		return;
> +	}
> +	vha->flags.iocb_work_sheduled = 1;
> +	spin_unlock_irqrestore(&vha->work_lock, flags);
> +
> +	/*
> +	 * We're in the middle of bringing up the adapter.
> +	 * the scheduled work need to go out now.
> +	 */
> +	INIT_WORK(&vha->iocb_work, qla2x00_iocb_work_fn);
> +	schedule_work(&vha->iocb_work);
> +}

Please move the INIT_WORK() call to an initialization function such that
is executed once instead of during every qla2x00_schedule_work() call. Please
also remove the iocb_work_sheduled variable and all code that tests and sets
it. schedule_work() already checks whether or not a work item has been
scheduled.

> @@ -4564,7 +4568,8 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
>  		}
>  
>  		if (sess != NULL) {
> -			if (sess->fw_login_state == DSC_LS_PLOGI_PEND) {
> +			if ((sess->fw_login_state != DSC_LS_PLOGI_PEND) &&
> +			    (sess->fw_login_state != DSC_LS_PLOGI_COMP)) {

The != operator has a higher precedence than the && operator so the parentheses
around the inequality test are not needed.

Bart.
