From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 6/6] scsi_sysfs: call 'device_add' after attaching device
 handler
Date: Tue, 1 Mar 2016 10:51:49 -0800
Message-ID: <56D5E4C5.3050004@sandisk.com>
References: <1456808143-88932-1-git-send-email-hare@suse.de>
 <1456808143-88932-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0092.outbound.protection.outlook.com ([157.56.111.92]:57216
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750940AbcCASvx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 13:51:53 -0500
In-Reply-To: <1456808143-88932-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 02/29/2016 08:55 PM, Hannes Reinecke wrote:
> @@ -1241,6 +1234,13 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>   		sdev_printk(KERN_INFO, sdev,
>   				"failed to add device handler: %d\n", error);
>
> +	error = device_add(&sdev->sdev_gendev);
> +	if (error) {
> +		sdev_printk(KERN_INFO, sdev,
> +				"failed to add device: %d\n", error);
> +		return error;
> +	}
> +
>   	device_enable_async_suspend(&sdev->sdev_dev);
>   	error = device_add(&sdev->sdev_dev);
>   	if (error) {

Hello Hannes,

I think that scsi_dh_remove_device() should be called before returning 
if device_add() fails.

Bart.
