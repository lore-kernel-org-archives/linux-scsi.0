From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 0/2] scsi: Fix endless loop of ATA hard resets due to VPD
 reads
Date: Tue, 2 Feb 2016 12:18:30 +0200
Message-ID: <20160202101830.GA3786@node.shutemov.name>
References: <20160121063039.3803.66.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160121063039.3803.66.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Duyck <aduyck@mirantis.com>
Cc: jbottomley@odin.com, hare@suse.de, linux-scsi@vger.kernel.org, alexander.duyck@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, jthumshirn@suse.de
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 20, 2016 at 10:35:15PM -0800, Alexander Duyck wrote:
> Ultimately neither of these bugs were my root cause.  It turns out the
> Marvel Console SCSI device in my system needed to have a flag set to
> disable VPD access in order to keep things from looping through the error
> repeatedly.  In order to resolve it I had to add the kernel parameter
> "scsi_mod.dev_flags=Marvell:Console:0x4000000".  This allowed my system to
> boot without any errors, however the first two issues described above are
> still relevent so I thought I would provide the patches since I had already
> written them up.

I have the same problem.

Shouldn't we put quirk for that?

>From d5ad5e1ee4128c454f39d7f3ccaa0b202e0e8534 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Tue, 2 Feb 2016 12:44:04 +0300
Subject: [PATCH] scsi: add Marvell Console to the ignore VPD pages blacklist

With current upstream, I see these messages in loop.

	ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
	ata14.00: configured for UDMA/66
	ata14: EH complete
	ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
	ata14.00: irq_stat 0x40000001
	ata14.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 22 dma 16640 in
	Inquiry 12 01 00 00 ff 00res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)
	ata14: hard resetting link

Looks like we should blacklist the device to stop it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 47b9d13f97b8..da2e068ee47d 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -205,6 +205,7 @@ static struct {
 	{"Intel", "Multi-Flex", NULL, BLIST_NO_RSOC},
 	{"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
 	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
+	{"Marvell", "Console", NULL, BLIST_SKIP_VPD_PAGES},
 	{"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"MATSHITA", "DMC-LC5", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
 	{"MATSHITA", "DMC-LC40", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
-- 
 Kirill A. Shutemov
