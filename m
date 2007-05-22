From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix for BZ 8426 - massive slowdown on SCSI CD/DVD
	drive connected to mptspi driver
Date: Tue, 22 May 2007 16:27:14 -0500
Message-ID: <1179869235.3738.55.camel@mulgrave.il.steeleye.com>
References: <1178567987.27671.20.camel@deimos.americas.hpqcorp.net>
	 <1179865510.5479.17.camel@phobos>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:41906 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757829AbXEVV1R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 17:27:17 -0400
In-Reply-To: <1179865510.5479.17.camel@phobos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Chapman <doug.chapman@hp.com>
Cc: eric.moore@lsi.com, linux-scsi@vger.kernel.org

On Tue, 2007-05-22 at 14:25 -0600, Doug Chapman wrote:
> Eric,
> 
> Sorry to bother you on this again, I realize you are very busy.
> 
> >From our off-list email and from your comments to Chip Coldwell in
> redhat BZ 225177 it sounded like you were prepared to ACK this.  Any
> chance you could send your official ACK so this can be committed?
> 
> much appreciated,

Actually I'd like a little analysis of why first, please Eric.

It seems to me, with the current wrong ordering in the initialisation
results in a large queue depth being given to the DVD (which are
habitually very low queue depth ... or even untagged beasts).  So does
the slowdown result from the fusion accepting N commands for the DVD and
then rejecting N-1 of them resulting in ping pong between the mid-layer
and driver?

If so, we probably want to fix the command throttling in the driver.

James


