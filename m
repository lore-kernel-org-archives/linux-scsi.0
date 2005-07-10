From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sun, 10 Jul 2005 10:25:00 -0500
Message-ID: <1121009100.5078.4.camel@mulgrave>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>
	 <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org>
	 <20050710033431.GB13883@havoc.gtf.org>
	 <20050710043645.GF2972@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:29579 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261958AbVGJPZ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 11:25:28 -0400
In-Reply-To: <20050710043645.GF2972@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

On Sun, 2005-07-10 at 00:36 -0400, Ben Collins wrote:
> I would have to say that it isn't working for a lot of people. Why does
> our code work for everything, but the scsi code only work for some ppl?
> Atleast I can say that where things are broken, our code fixes it, and
> where things are working, our code also works. It would seem our code has
> a workaround for the cases where the scsi code doesn't.

Could we have a few bug reports to try to diagnose, please?

> One thing that stands out is that we have a bit of code that changed the
> device type from TYPE_RBC to TYPE_DISK in the command structure. Since I
> didn't write this code, I can't really say why that is.  Any ideas what
> that was trying to accomplish? I've attached the changes here, so you can
> see what our code did and maybe make some sense of it.
> 
> I honestly thing that our code was removed in an attempt to replace it
> with some common code, perhaps without fully understanding what it may
> have done special. I have to say, after looking at the scsi code that
> replaces the sbp2 code, I can't see a hole lot of similarity.

What the code you attached does is

1) Convert READ_6 and WRITE_6 into READ_10 and WRITE_10 (RBC devices
only use 10 byte commands).  The equivalent functionality is achieved by
setting sdev->use_10_for_rw in slave configure.

2) Convert MODE_SENSE into MODE_SENSE_10.  The equivalent functionality
is achieved by setting sdev->use_10_for_ms in slave configure.

3) Massage the value of MODE_SENSE_10 returns slightly.  RBC devices
have a few small differences in the way they present mode sense
information.  The changes in sd.c account for this.

So, for RBC devices, the changes look equivalent.

The only possibility for a problem might be that the code you quote
massages the MODE_SENSE data for every device, whereas the SCSI changes
only do it for RBC devices ... are the devices reporting difficulties
non-RBC?

James


