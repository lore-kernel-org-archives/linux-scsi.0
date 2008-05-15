From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 4/7] scsi_dh: Update EMC handler
Date: Wed, 14 May 2008 19:47:09 -0700
Message-ID: <1210819629.21974.255.camel@chandra-ubuntu>
References: <20080514144324.3000410B5DF@craiglockhart-ipmi.suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47117 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbYEOCp2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2008 22:45:28 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4F2lc9K012167
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2008 22:47:38 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4F2jRQK146930
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2008 22:45:27 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4F2jR1r030225
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2008 22:45:27 -0400
In-Reply-To: <20080514144324.3000410B5DF@craiglockhart-ipmi.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, dm-devel <dm-devel@redhat.com>


On Wed, 2008-05-14 at 16:43 +0200, Hannes Reinecke wrote:
<snip>

> 
> @@ -438,10 +604,32 @@ static int clariion_bus_attach(struct scsi_device *sdev)
>  	sdev->scsi_dh_data = scsi_dh_data;
>  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> 
Can move the block above to be just before try_module_get() and avoid
undoing it in the failed path.

> -	sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", CLARIION_NAME);
> +	err = clariion_std_inquiry(sdev);
> +	if (err != SCSI_DH_OK)
> +		goto failed;
> +
> +	err = clariion_send_inquiry(sdev);
> +	if (err != SCSI_DH_OK)
> +		goto failed;
> +


