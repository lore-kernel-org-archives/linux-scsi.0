From: Jens Axboe <axboe@suse.de>
Subject: Re: Device flags: use_10_for_rw and use_10_for_ms
Date: Tue, 29 Nov 2005 21:03:34 +0100
Message-ID: <20051129200334.GB15804@suse.de>
References: <Pine.LNX.4.44L0.0511281626460.4796-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:15409 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S932372AbVK2UCX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 15:02:23 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0511281626460.4796-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Nov 28 2005, Alan Stern wrote:
> Patrick and James:
> 
> There are a couple of problems with the implementation of the 
> use_10_for_rw and use_10_for_ms flags.
> 
> The easy problem is that use_10_for_rw is implemented twice: once in 
> sd.c:sd_rw_intr and once in scsi_lib.c:scsi_io_completion.  The obvious 
> fix is to remove of them.  Since scsi_io_completion is more general, it 
> makes sense to leave the code there and remove it from sd.c.
> 
> The hard problem is that sometimes devices return an ILLEGAL_REQUEST sense
> key when they shouldn't.  I posted an example a week or two ago; what
> happened was the use_10_for_rw flag got turned off and from then on only
> 6-byte commands were used (and of course the device failed to recognize
> them).
> 
> Clearly we need a mechanism for going the other way: when a 6-byte command 
> gets ILLEGAL_REQUEST sense, turn the use_10_for_xxx flag back on.  The 
> difficulty is that this will cause an infinite retry loop if the device 
> doesn't like either form of the command.
> 
> Is there a standard way to limit the number of retries for these cases in 
> scsi_io_completion?  The code pathway involves getting rid of the 
> scsi_cmnd and keeping only the struct request, so I don't know where an 
> appropriate place would be to store the retry counter.
> 
> Any ideas?

How about just improving the check for correctly failed 10-byte command,
so we only clear the flag for the right reason? I think your problem is
likely due to the check being too relaxed right now.

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ce9d73a..1f27827 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -884,7 +884,8 @@ void scsi_io_completion(struct scsi_cmnd
 			* system where READ CAPACITY failed, we may have read
 			* past the end of the disk.
 		 	*/
-			if (cmd->device->use_10_for_rw &&
+			if ((cmd->device->use_10_for_rw &&
+			    sshdr.asc == 0x20 && sshdr.ascq == 0x00) &&
 			    (cmd->cmnd[0] == READ_10 ||
 			     cmd->cmnd[0] == WRITE_10)) {
 				cmd->device->use_10_for_rw = 0;

-- 
Jens Axboe

