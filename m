From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: Concurrent SG_SCSI_RESET ioctls
Date: Fri, 10 Oct 2014 23:32:26 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CE9B54@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:34626 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaJJXfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Oct 2014 19:35:32 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Don Brace (PMC)" <Don.Brace@pmcs.com>, "Scales, Webb" <webb.scales@hp.com>

The sg3_utils command
	sg_reset --device /dev/sda

invokes an ioctl with SG_SCSI_RESET, an argument of
SG_SCSI_RESET_DEVICE, on a device opened with O_NDELAY.

The call chain is like this:

sd_ioctl					[sd.c]
	scsi_nonblockable_ioctl		[scsi_ioctl.c]
		if (ndelay) {			[this is true]
			if (scsi_host_in_recovery(sdev->host))
				return -ENODEV;
			}
		scsi_reset_provider		[scsi_error.c]
			shost->tmf_in_progress = 1;
			scsi_try_bus_device_reset [scsi_error.c]
				hostt->eh_device_reset_handler [LLD]
			shost->tmf_in_progress = 1;
	if that returns 0, return; otherwise try:
	scsi_cmd_blk_ioctl
	scsi_ioctl
		sdev->host->hostt->ioctl	[LLD]

where scsi_host_in_recovery is:

static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
{
        return shost->shost_state == SHOST_RECOVERY ||
                shost->shost_state == SHOST_CANCEL_RECOVERY ||
                shost->shost_state == SHOST_DEL_RECOVERY ||
                shost->tmf_in_progress;
}

Problem
=======
If you run sg_reset --device concurrently to multiple
devices on the same host, then some of them will run
into tmf_in_progress and have scsi_nonblockable_ioctl
return -ENODEV.  This causes sd_ioctl to send the ioctl
request to the LLD's ioctl function, where it gets
rejected as unsupported with -ENOTTY.  sg_reset ends
up displaying:
	sg_reset: SG_SCSI_RESET failed: Inappropriate ioctl for device

Any suggestions for how to fix this?  

Is the check of scsi_host_in_recovery, which includes
tmf_in_progress, too strong?  Most LLDs are not parallel
SCSI where you can just have one TMF on the bus at a
time anymore.

Is returning -ENODEV if the host is in recovery the
wrong code?  There might be a device there...it's
just that access is temporarily blocked.

Should sd_ioctl not proceed to scsi_ioctl in so many
cases? Perhaps it should:
  * proceed if it gets back -EINVAL (and maybe -ENOTTY)
    indicating the ioctl specified was bad
  * return if it gets back any other error (e.g., -ENODEV,
    -EACCESS, or -EIO) 
That would at least result in a more meaningful error.

Also, should scsi_nonblockable_ioctl return -ENOTTY rather
than -ENODEV if cmd is unsupported?  There's not really
a no-device problem.

---
Rob Elliott    HP Server Storage

