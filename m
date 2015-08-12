From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH v4 1/3] cxlflash: Base error recovery support
Date: Wed, 12 Aug 2015 00:15:56 -0400
Message-ID: <20150812001556.Horde.B0DQAWPuWIGynBAYlIejmg1@ltc.linux.ibm.com>
References: <1439226574-7766-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:37735 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbbHLEQB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2015 00:16:01 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Wed, 12 Aug 2015 00:16:00 -0400
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 303FEC90041
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 00:07:03 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7C4Fvvq51118216
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 04:15:57 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7C4FuD4030863
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 00:15:57 -0400
In-Reply-To: <1439226574-7766-1-git-send-email-mrochs@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>


Quoting "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>:

> Introduce support for enhanced I/O error handling.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> ---
> drivers/scsi/cxlflash/Kconfig  |   2 +-
> drivers/scsi/cxlflash/common.h |  11 ++-
> drivers/scsi/cxlflash/main.c   | 166  
> ++++++++++++++++++++++++++++++++++++++---
> drivers/scsi/cxlflash/main.h   |   4 +
> 4 files changed, 170 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 76a7286..18359d4 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -380,6 +380,18 @@ static int cxlflash_queuecommand(struct  
> Scsi_Host *host, struct scsi_cmnd *scp)
> 	}
> 	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
>
> +	switch (cfg->state) {
> +	case STATE_LIMBO:
> +		pr_debug_ratelimited("%s: device in limbo!\n", __func__);
> +		rc = SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;

remove "goto out", return SCSI_MLQUEUE_HOST_BUSY;

> +	case STATE_FAILTERM:
> +		pr_debug_ratelimited("%s: device has failed!\n", __func__);
> +		goto error;
> +	default:
> +		break;
> +	}
> +
> 	cmd = cxlflash_cmd_checkout(afu);
> 	if (unlikely(!cmd)) {
> 		pr_err("%s: could not get a free command\n", __func__);
> @@ -428,6 +440,10 @@ static int cxlflash_queuecommand(struct  
> Scsi_Host *host, struct scsi_cmnd *scp)
>
> out:
> 	return rc;
> +error:
> +	scp->result = (DID_NO_CONNECT << 16);
> +	scp->scsi_done(scp);
> +	return 0;
> }
>
I have reviewed most of part in v2.

Thanks,
Wendy

