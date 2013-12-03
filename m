From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: [PATCH/RESEND v2 0/2] Hard disk resume time optimization
Date: Tue, 3 Dec 2013 08:25:37 -0800
Message-ID: <20131203162537.GA12554@linux.intel.com>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi James, can you give me some feedback on this patch set? It includes
changes based on your feedback to v1.  

The essential issue behind hard disks' lengthy resume time is the ata port
driver blocking until the ATA port hardware is finished coming online. So
the kernel isn't really doing anything during all those seconds that the
disks are resuming, it's just blocking until the hardware says it's ready
to accept commands. Applying this patch set allows SATA disks to resume
asynchronously without holding up system resume, thus allowing the UI to
come online much more quickly. There may be a short period after resume
where the disks are still spinning up in the background, but the user
shouldn't notice since the OS can function with the data left in RAM.

The patch set has two parts which apply to ata_port_resume and sd_resume
respectively. Both are required to achieve any real performance benefit,
but they will still function independantly without a performance hit.

ata_port_resume patch (1/2):

On resume, the ATA port driver currently waits until the AHCI controller
finishes executing the port wakeup command. This patch changes the
ata_port_resume callback to issue the wakeup and then return immediately,
thus allowing the next device in the pm queue to resume. Any commands
issued to the AHCI hardware during the wakeup will be queued up and
executed once the port is physically online. Thus no information is lost.

sd_resume patch (2/2):

On resume, the SD driver currently waits until the block driver finishes
executing a disk start command with blk_execute_rq. This patch changes
the sd_resume callback to use blk_execute_rq_nowait instead, which allows
it to return immediately, thus allowing the next device in the pm queue
to resume. The return value of blk_execute_rq_nowait is handled in the
background by sd_resume_complete. Any commands issued to the scsi disk
during the startup will be queued up and executed once the disk is online.
Thus no information is lost.

