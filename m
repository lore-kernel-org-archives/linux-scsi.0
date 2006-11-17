From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Atto UL5D: negotiates only up to FAST-40 SCSI
Date: Fri, 17 Nov 2006 12:26:36 -0600
Message-ID: <1163787996.8594.36.camel@mulgrave.il.steeleye.com>
References: <xfku00y8gjn.fsf@uxrs53.drewag.de>
	 <1163777478.8594.18.camel@mulgrave.il.steeleye.com>
	 <xfk8xia82tn.fsf@uxrs53.drewag.de>  <xfkhcwy6la8.fsf@uxrs53.drewag.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:16335 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1755729AbWKQS0n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Nov 2006 13:26:43 -0500
In-Reply-To: <xfkhcwy6la8.fsf@uxrs53.drewag.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sven Rudolph <Sven_Rudolph@drewag.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 2006-11-17 at 18:22 +0100, Sven Rudolph wrote:
> Something I forgot to mention: I became aware of the problem when I
> tried to read from (or write to (?)) three disks in parallel and the
> sum of the transfer speeds was a bit below 40 MBytes/second when I ran
> two disks and it was the nearly the same with three disks. The first
> disk was the fastest in the three-disk test run, and the third was the
> slowest. I suppose this is due to SCSI priority by SCSI ID. So I'm
> quite sure that the bus really only runs in FAST-40 mode.

OK ... I think there's something unusual about your actual card.  I
checked the specs and FAST-40 should be LVD.  The DV information
indicates that the device is also Narrow not wide, which implies either
it refused wide negotiation, or that the card wasn't able to set the
correct parameters.  You can try to set it manually with 

echo 1 > /sys/class/spi_transport/target1:0:3/width

then you have to do I/O to force the renegotiation (fdisk is good for
this) and then try and cat back the parameter.

You can also try to force it up to FAST-160 with

echo 6.25 > /sys/class/spi_transport/target1:0:3/period

and again force I/O with fdisk then cat the parameter back to see if it
took.

James


