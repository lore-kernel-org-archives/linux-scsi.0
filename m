From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 5/7] scsi_dh: Update hp_sw hardware handler
Date: Wed, 14 May 2008 19:47:54 -0700
Message-ID: <1210819674.21974.258.camel@chandra-ubuntu>
References: <20080514144328.55FD010B5DF@craiglockhart-ipmi.suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33126 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbYEOCqN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2008 22:46:13 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4F2kC2A001154
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2008 22:46:12 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4F2kCYI146762
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2008 22:46:12 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4F2kCPT031253
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2008 22:46:12 -0400
In-Reply-To: <20080514144328.55FD010B5DF@craiglockhart-ipmi.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org


No need for blk_put_request() as noted in an earlier patch.

On Wed, 2008-05-14 at 16:43 +0200, Hannes Reinecke wrote:

<snip>
>  	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>  	sdev->scsi_dh_data = scsi_dh_data;
>  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);

we can move this below the initializations.
> +
> +	ret = hp_sw_tur(sdev);
> +	if (ret != SCSI_DH_OK || h->path_state == HP_SW_PATH_UNINITIALIZED)
> +		goto failed;
> +
> +	sdev_printk(KERN_INFO, sdev, "%s: %s path\n",
> +		    HP_SW_NAME, h->path_state == HP_SW_PATH_ACTIVE?
> +		    "active":"passive");
> +

