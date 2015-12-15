From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] bnx2fc:Add proper locking protection in
 bnx2fc_ctrlr_enabled
Date: Tue, 15 Dec 2015 11:42:40 -0500
Message-ID: <alpine.OSX.2.00.1512151139140.1614@administrators-macbook-pro.local>
References: <1449949166-3977-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:16234 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965215AbbLOQnB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2015 11:43:01 -0500
In-Reply-To: <1449949166-3977-1-git-send-email-xerofoify@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>
Cc: QLogic-Storage-Upstream@qlogic.com, JBottomley@odin.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Sat, 12 Dec 2015, Nicholas Krause wrote:

> This adds proper locking protection in bnx2fc_ctrl_enabled around
> the calls to the functions, _bnx2fc_enable and _bnx2fc_disable in
> order to avoid concurrent access on these functions accessing global
> referenced data structures in their internal intended work.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index 67405c6..e43648f 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -2177,13 +2177,21 @@ static int bnx2fc_ctlr_enabled(struct fcoe_ctlr_device *cdev)
> {
> 	struct fcoe_ctlr *ctlr = fcoe_ctlr_device_priv(cdev);
>
> +	rtnl_lock();
> +	mutex_lock(&bnx2fc_dev_lock);
> 	switch (cdev->enabled) {
> 	case FCOE_CTLR_ENABLED:
> +		rtnl_unlock();
> +		mutex_unlock(&bnx2fc_dev_lock);
> 		return __bnx2fc_enable(ctlr);
> 	case FCOE_CTLR_DISABLED:
> +		rtnl_unlock();
> +		mutex_unlock(&bnx2fc_dev_lock);
> 		return __bnx2fc_disable(ctlr);
> 	case FCOE_CTLR_UNUSED:
> 	default:
> +		rtnl_unlock();
> +		mutex_unlock(&bnx2fc_dev_lock);
> 		return -ENOTSUPP;
> 	};
> }
>

Nack.  All we end up protecting is the check of cdev->enabled and I do not 
believe taking two mutexes is required for that.
