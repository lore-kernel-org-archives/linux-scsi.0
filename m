From: Jens Axboe <axboe@suse.de>
Subject: Re: sg driver and Fedora Core 2
Date: Fri, 28 May 2004 16:28:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040528142816.GL20657@suse.de>
References: <40B74725.90403@torque.net> <20040528141854.GJ20657@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:44747 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263138AbUE1O2S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 10:28:18 -0400
Content-Disposition: inline
In-Reply-To: <20040528141854.GJ20657@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, alan@redhat.com

On Fri, May 28 2004, Jens Axboe wrote:
> > There seems to be mixed signals coming from the Fedora camp
> > on this change. A "policy" change was one response and this
> > url ( http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=123876 )
> > has Alan Cox stating that this change is a bug.
> 
> That's not the identical issue, it's due to usb storage setting 120KB as
> the max size causing sg_set_reserved_size() to fail.

>From what I read of the documentation on sgv3, the reserved size is some
old relic that isn't even of interesting to the block layer sg
"implementation" (we don't keep memory reserved for requests, it's
mapped from the user).

Douglas, can I expect applications to break with this patch? They are
allowed to set a reserved size of eg 512KB, even if we'll later reject a
256KB command if it's sent to an ATAPI drive.

===== drivers/block/scsi_ioctl.c 1.42 vs edited =====
--- 1.42/drivers/block/scsi_ioctl.c	2004-04-27 15:20:34 +02:00
+++ edited/drivers/block/scsi_ioctl.c	2004-05-28 16:26:10 +02:00
@@ -89,8 +89,6 @@
 
 	if (size < 0)
 		return -EINVAL;
-	if (size > (q->max_sectors << 9))
-		return -EINVAL;
 
 	q->sg_reserved_size = size;
 	return 0;

-- 
Jens Axboe

