From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH/RESEND v2 0/2] Hard disk resume time optimization
Date: Tue, 03 Dec 2013 18:20:03 +0100
Message-ID: <529E12C3.3070708@interlog.com>
References: <20131203162537.GA12554@linux.intel.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:60164 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329Ab3LCRUj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Dec 2013 12:20:39 -0500
In-Reply-To: <20131203162537.GA12554@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: todd.e.brandt@linux.intel.com, JBottomley@parallels.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org

On 13-12-03 05:25 PM, Todd E Brandt wrote:
> Hi James, can you give me some feedback on this patch set? It includes
> changes based on your feedback to v1.
>
> The essential issue behind hard disks' lengthy resume time is the ata port
> driver blocking until the ATA port hardware is finished coming online. So
> the kernel isn't really doing anything during all those seconds that the
> disks are resuming, it's just blocking until the hardware says it's ready
> to accept commands. Applying this patch set allows SATA disks to resume
> asynchronously without holding up system resume, thus allowing the UI to
> come online much more quickly. There may be a short period after resume
> where the disks are still spinning up in the background, but the user
> shouldn't notice since the OS can function with the data left in RAM.
>
> The patch set has two parts which apply to ata_port_resume and sd_resume
> respectively. Both are required to achieve any real performance benefit,
> but they will still function independantly without a performance hit.
>
> ata_port_resume patch (1/2):
>
> On resume, the ATA port driver currently waits until the AHCI controller
> finishes executing the port wakeup command. This patch changes the
> ata_port_resume callback to issue the wakeup and then return immediately,
> thus allowing the next device in the pm queue to resume. Any commands
> issued to the AHCI hardware during the wakeup will be queued up and
> executed once the port is physically online. Thus no information is lost.
>
> sd_resume patch (2/2):
>
> On resume, the SD driver currently waits until the block driver finishes
> executing a disk start command with blk_execute_rq. This patch changes
> the sd_resume callback to use blk_execute_rq_nowait instead, which allows
> it to return immediately, thus allowing the next device in the pm queue
> to resume. The return value of blk_execute_rq_nowait is handled in the
> background by sd_resume_complete. Any commands issued to the scsi disk
> during the startup will be queued up and executed once the disk is online.
> Thus no information is lost.

There was some fuzziness in the SCSI drafts as to how a disk
would react to medium access commands (e.g. READ) when it
was transitioning from stopped state (plus other lower powered
states) to active. There are two options:
   a) hold the medium access command in the target until
      it becomes active, then act on it, or
   b) send back a NOT READY sense key with LOGICAL UNIT IS IN
      PROCESS OF BECOMING READY immediately.

This has recently been resolved with the CFF STOPPED field in
the Power condition mode page. "Recently" is the operative word
so you should expect to see next to no support for the CFF
STOPPED field now. Thus SCSI disks can take their pick between
the above two options. Does your patch cope with that?


Also the START STOP UNIT SCSI command has an IMMED bit. It
makes more sense to send this command with the IMMED bit set
and wait for it to complete since that should be fast. You
may receive an unexpected UNIT ATTENTION or a transport error.
Those two imply your command has not, or can not do what has
been requested.

Doug Gilbert



