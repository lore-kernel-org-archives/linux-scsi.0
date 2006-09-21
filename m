From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptspi: Bug fix to prevent infinite nesteddomainvalidation
Date: Thu, 21 Sep 2006 16:32:30 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7032D3D2@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:33788 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932081AbWIUWjN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Sep 2006 18:39:13 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Wednesday, September 20, 2006 9:43 AM, Mark Haverkamp wrote:

> 
> On Tue, 2006-09-19 at 18:35 -0600, Eric Moore wrote:
> > From host_reset, this patch will complete domain validation
> > in the same context as the eh threads.  I've added passing
> > the sleepFlag, which is CAN_SLEEP in the context of eh threads.
> > 
> > Mark pls try this with the patch that James posted earlier that
> > prevents re entry to pending dv.
> 
> Something isn't working quite right.  Here is the log.  The modprobe
> gets stuck.
> 

James, this is not going to work. I have to call delayed 
spi_dv_device from host reset, or your getting this hang, 
and/or get asyn narrow on all devices.  There is one other
driver in the kernel tree that does dv from host reset.
It is 53c700. It calls spi_schedule_dv_device.  So its
delaying domain validation outside eh threads.
We would be callign that too, if it wasn't for integrated 
raid support, and we need to quiese IO to hidden disk.  
Regardless, dv needs to be done outside eh threads, and
due to this, domain validation is goign to be nested,
and re-enterant.  The problem is by the time we do dv
on the faulty device, the dv_in_progress flag will off
been cleared.

So the question is how can spi transport layer better handle
issueing domain validation scsi passthrus that timeout, leading
to host_reset?   

Eric Moore
