From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] fix for BZ 8426 - massive slowdown on SCSI CD/DVDdriveconnected to mptspi driver
Date: Tue, 29 May 2007 16:46:40 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70787ECB@NAMAIL4.ad.lsil.com>
References: <1180476152.3700.91.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:57208 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbXE2Wqt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 May 2007 18:46:49 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1180476152.3700.91.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Doug Chapman <doug.chapman@hp.com>, linux-scsi@vger.kernel.org

On Tuesday, May 29, 2007 4:03 PM,  James Bottomley wrote:

> The device is presumably returning BUSY when you try to send a second
> command when it's already processing the first ... that should be
> propagated back to the mid-layer causing it to throttle the 
> queue ... it
> seems this wasn't happening for some reason to get such a massive
> slowdown.  Is this a more generic problem in the fusion or is it a
> simple issue only affecting the untagged case? 
> 

Right, probably SELECTION_TIMEOUT.  Or command timeout with error
handling threads getting called.   Either way, the customer hasn't
provided a dmesg log or scsi bus trace, so we don't know for sure. But
is this analysis really required?     Dont' you think the driver should
return that it doens't support queued commands when
sdev->tagged_supported (look at scsi_scan.c function scsi_add_lun) is
set to zero?      It appears that is what other drivers in the kernel
tree do.    When I reorganized the code in a patch I provided back in
February,  I moved analyzing the sdev->tagged_supported flag to after I
set the queue depth, not before.

Eric  
