From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Status of patch as168 (sysfs readonly max_sectors attribute)
Date: 15 Jan 2004 14:42:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074195756.1868.222.camel@mulgrave>
References: <Pine.LNX.4.44L0.0401151425590.1316-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:3519 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261595AbUAOTmm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2004 14:42:42 -0500
In-Reply-To: <Pine.LNX.4.44L0.0401151425590.1316-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2004-01-15 at 14:30, Alan Stern wrote:
> If I understand this, you would like to see the low-level drivers manage
> these things for themselves by talking directly to the block layer,
> without having to go through the intermediate SCSI layers.  This would
> imply that any sysfs interface to max_sectors would then be the
> responsibility of the driver, since the block layer itself is much too
> generic to permit users to fiddle with the settings.
> 
> Correct?

Well, no, not exactly.  At issue are some of the SCSI template
parameters which are copied to the host structure and then simply passed
straight through to the block queue.

If you look in scsi_alloc_queue, it simply passes through these queue
parameters.  It's pretty pointless to have SCSI do anything about them
at all, so Jeff was saying we could just strip this out of the template
and the drivers and have them call the relevant blk_queue_ parameter
functions directly.

James


I personally think this would have to be done *before* any queue
activity, so probably in slave_alloc rather than slave_configure
(although there's no reason not to readjust in slave_configure).

James


