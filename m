From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: 26 Apr 2003 23:32:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051418077.4089.175.camel@mulgrave>
References: <UTC200304270229.h3R2TAg06941.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:64007 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263354AbTD0EWg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 00:22:36 -0400
In-Reply-To: <UTC200304270229.h3R2TAg06941.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net

On Sat, 2003-04-26 at 21:29, Andries.Brouwer@cwi.nl wrote:
> All docs say that this routine should call scsi_adjust_queue_depth.
> Is that really true? When reading the docs one gets the impression
> that our code is
> 	if (slave_configure)
> 		slave_configure();
> 	else
> 		scsi_adjust_queue_depth(default);
> But I read in scsi_scan.c:
>         if(sdev->host->hostt->slave_configure)
>                 sdev->host->hostt->slave_configure(sdev);
> 


Well, its design purpose was for queue depth adjustment, but it's
ideally placed to modify any parameters about the device we choose,
hence it could set the appropriate mode sense flag for USB storage.

The rework of the SCSI code means that you don't get tag command
queueing without calling adjust_queue_depth from the slave_configure
routine.  The default is not to do it. However, the slab allocation of
commands rather took the teeth out of it for queue depth adjustment.

James


