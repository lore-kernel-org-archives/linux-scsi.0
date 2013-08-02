From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH] Hard disk S3 resume time optimization
Date: Fri, 02 Aug 2013 14:42:36 +0200
Message-ID: <1375447356.2138.13.camel@linux-fkkt.site>
References: <11E08D716F0541429B7042699DD5C1A1706803A6@FMSMSX103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab3HBMmi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Aug 2013 08:42:38 -0400
In-Reply-To: <11E08D716F0541429B7042699DD5C1A1706803A6@FMSMSX103.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Brandt, Todd E" <todd.e.brandt@intel.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2013-08-01 at 23:40 +0000, Brandt, Todd E wrote:
> This patch is a potential way to reduce the S3 resume time for SATA drives. Essentially this patch removes the hard disk resume time from the total system resume time, with the disks still taking as long to come back online but in the background.
> 
> The major bottleneck is in the ata port resume which sends out a wakeup command and then waits up to several seconds for the port to resume. This patch changes the ata_port_resume_common function to be non blocking. The other bottleneck is in the scsi disk resume code, which issues a a command to startup the disk with blk_execute_rq, which then waits for the command to finish (which also depends on the ata port being fully resumed). The patch switches the sd_resume function to use blk_execute_rq_nowait instead (the underlying code is identical to sd_resume, but is changed to non-blocking).

But how do we know the command has succeeded?

	Regards
		Oliver


