From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] [Update #2] suspending I/Os to a device
Date: 30 Sep 2004 17:40:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096580453.1764.128.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C086618@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42920 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269558AbUI3Vk5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2004 17:40:57 -0400
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C086618@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@infradead.org, Mike Anderson <andmike@us.ibm.com>, Martin Hicks <mort@wildopensource.com>, andrew.vasquez@qlogic.com

On Thu, 2004-09-30 at 16:57, James.Smart@Emulex.Com wrote:
> Folks,
> 
> Here is the suspend i/o patch, updated to run with host and target attributes for obtaining the timeout values. As a matter of course - this adds host and target attribute use to the FC transport.
> 
> This patch depends on the bitkeeper scsi-target-2.6 tree.

Well, it's getting better, but I'm slightly confused by the attribute
levels.

Surely node_name, port_name and port_id are target attributes only?

Also, since disconnection by cable pull can only happen at the host or
target level, there's surely no need for a device dev_loss_tmo
parameter?

>  struct scsi_target {
>  	struct scsi_device	*starget_sdev_user;
> +	struct Scsi_Host	*shost;
>  	struct device		dev;
>  	unsigned int		channel;
>  	unsigned int		id; /* target id ... replace

This is unnecessary.  You can deduce the scsi host from the device's
parent.  If you look at the sym2 updates, you see things like:

struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);

 +fc_target_unblock(struct scsi_target *starget)
> +{
> +	struct scsi_device *sdev;
> +
> +	/* 
> +	 * Stop the target timer first. Take no action on the del_timer
> +	 * failure as the state machine state change will validate the
> +	 * transaction. 
> +	 */
> +	del_timer_sync(&fc_starget_dev_loss_timer(starget));
> +
> +	shost_for_each_device(sdev, starget->shost) {
> +		if (sdev->id == starget->id)
> +			scsi_internal_device_unblock(sdev);
> +	}

This is wrong, See how iteration over host is done in
scsi_lib.c:scsi_target_resume

James


