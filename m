From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] fix for BZ 8426 - massive slowdown on SCSI CD/DVDdrive connected to mptspi driver
Date: Tue, 29 May 2007 15:40:49 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70787EAA@NAMAIL4.ad.lsil.com>
References: <1179869235.3738.55.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53956 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbXE2Vk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 May 2007 17:40:59 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1179869235.3738.55.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Doug Chapman <doug.chapman@hp.com>
Cc: linux-scsi@vger.kernel.org

On Tuesday, May 22, 2007 3:27 PM, James Bottomley wrote:

> On Tue, 2007-05-22 at 14:25 -0600, Doug Chapman wrote:
> > Eric,
> > 
> > Sorry to bother you on this again, I realize you are very busy.
> > 
> > >From our off-list email and from your comments to Chip Coldwell in
> > redhat BZ 225177 it sounded like you were prepared to ACK this.  Any
> > chance you could send your official ACK so this can be committed?
> > 
> > much appreciated,
> 
> Actually I'd like a little analysis of why first, please Eric.
> 
> It seems to me, with the current wrong ordering in the initialisation
> results in a large queue depth being given to the DVD (which are
> habitually very low queue depth ... or even untagged beasts).  So does
> the slowdown result from the fusion accepting N commands for 
> the DVD and
> then rejecting N-1 of them resulting in ping pong between the 
> mid-layer
> and driver?
> 
> If so, we probably want to fix the command throttling in the driver.
> 

James - Sorry, for delay, somehow I missed this email.

I approve the patch that was submitted by Doug Chapman.      Here is the
reasoning:   The DVD device that Doug is using is either a SCSI_1
device, or it doesn't support Q-tags.  The problem is the driver is
setting the Queue depth to 32, when it should of been 1.   With the
queue depth set larger than one,  this device doesn't work properly.

This bug came about when I reorganized some spi functions by moving them
from mptscsih.c over to mptspi.c.   When I did that, there were some
flags not set correctly in mptscsih_change_queue_depth.  The function
that sets these flags is mptspi_setTargetNegoParms.    Prior to
reorganizing the code, I was calling mptscsi_setTargetNegoParms before I
set the queue depth, the current code does it after.    If you accept
this patch, then it sets the flags properly.   

Eric


