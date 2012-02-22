From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] Fix NULL pointer dereference in sd_revalidate_disk
Date: Wed, 22 Feb 2012 12:58:08 +0800
Message-ID: <95E22EAF20104309BF3938E7820F36D6@usish.com.cn>
References: <4F443E81.2060402@ce.jp.nec.com> <20120222010435.GI12236@google.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:45591 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2BVFA4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 00:00:56 -0500
In-Reply-To: <20120222010435.GI12236@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Tejun Heo' <tj@kernel.org>, 'Jun'ichi Nomura' <j-nomura@ce.jp.nec.com>
Cc: 'Jens Axboe' <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 'linux-scsi' <linux-scsi@vger.kernel.org>, 'Naveen Goswamy' <naveen.goswamy@polymtl.ca>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'Stefan Richter' <stefanr@s5r6.in-berlin.de>, 'Dave Jones' <davej@redhat.com>, sgruszka@redhat.com, 'Huajun Li' <huajun.li.lee@gmail.com>

Should this need pick up into stable too?

Jack
Re: [PATCH] Fix NULL pointer dereference in sd_revalidate_disk
> 
> On Wed, Feb 22, 2012 at 10:01:53AM +0900, Jun'ichi Nomura wrote:
> > Since 2.6.39 (1196f8b), when a driver returns -ENOMEDIUM for open(),
> > __blkdev_get() calls rescan_partitions() to remove
> > in-kernel partition structures and raise KOBJ_CHANGE uevent.
> >
> > However it ends up calling driver's revalidate_disk without open
> > and could cause oops.
> >
> > In the case of SCSI:
> >
> >   process A                  process B
> >   ----------------------------------------------
> >   sys_open
> >     __blkdev_get
> >       sd_open
> >         returns -ENOMEDIUM
> >                              scsi_remove_device
> >                                <scsi_device torn down>
> >       rescan_partitions
> >         sd_revalidate_disk
> >           <oops>
> >
> > Oopses are reported here:
> > http://marc.info/?l=linux-scsi&m=132388619710052
> >
> > This patch separates the partition invalidation from rescan_partitions()
> > and use it for -ENOMEDIUM case.
> >
> > Reported-by: Huajun Li <huajun.li.lee@gmail.com>
> > Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Thank you!
> 
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

