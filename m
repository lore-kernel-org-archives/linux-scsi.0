From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH] driver model for scsi upper drivers, take 2
Date: Wed, 18 Jun 2003 05:04:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030618090425.GU998@linnie.riede.org>
References: <20030527073218.GA11467@lst.de> <20030527094310.GA12853@lst.de>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.comcast.net ([24.153.64.109]:1145 "EHLO
	smtp-out.comcast.net") by vger.kernel.org with ESMTP
	id S265115AbTFRIuP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2003 04:50:15 -0400
Received: from linnie.riede.org
 (pcp04239971pcs.eatntn01.nj.comcast.net [68.39.173.54])
 by mtaout05.icomcast.net
 (iPlanet Messaging Server 5.2 HotFix 1.16 (built May 14 2003))
 with ESMTP id <0HGO00B6I6E9HT@mtaout05.icomcast.net> for
 linux-scsi@vger.kernel.org; Wed, 18 Jun 2003 05:01:21 -0400 (EDT)
In-reply-to: <"from hch"@lst.de>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2003.05.27 05:43, Christoph Hellwig wrote:
> On Tue, May 27, 2003 at 09:32:18AM +0200, Christoph Hellwig wrote:
> >  - removed the tape sysfs pseudodevice crap that caused hangs
> >  - switched sg to a class_interface.  This means sg can be used
> >    on devices already claimed be an upper driver again.  This
> >    also means I had to remove the sg sysfs attributes temporarily
> >    because the old mechanism is gone, but I'll restore them
> >    differently in a followon patch.
> 
> Yikes, this was the old patch again.  Here's the right one:
> 

> --- 1.24/drivers/scsi/ide-scsi.c	Thu May 15 04:55:52 2003
> +++ edited/drivers/scsi/ide-scsi.c	Mon May 26 10:12:22 2003
> @@ -771,6 +771,10 @@
>  static inline int should_transform(ide_drive_t *drive, Scsi_Cmnd *cmd)
>  {
>  	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
> +
> +	/* this was a layering violation and we can't support it
> +	   anymore, sorry. */
> +#if 0
>  	struct gendisk *disk = cmd->request->rq_disk;
>  
>  	if (disk) {
> @@ -778,6 +782,7 @@
>  		if (strcmp((*p)->scsi_driverfs_driver.name, "sg") == 0)
>  			return test_bit(IDESCSI_SG_TRANSFORM, &scsi->transform);
>  	}
> +#endif

You removed whatever capability was provided by IDESCSI_SG_TRANSFORM.
Just curious, what did that do? And, does that capability need to be
replaced, and if so, any suggestions how to do so?

Thanks, Willem Riede.
