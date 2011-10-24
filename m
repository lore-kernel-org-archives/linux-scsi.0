From: Dave Jones <davej@redhat.com>
Subject: pmcraid_chr_ioctl uses incorrect argument order to kmalloc()
Date: Mon, 24 Oct 2011 18:10:26 -0400
Message-ID: <20111024221025.GA22337@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: anil_ravindranath@pmc-sierra.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Size is 1st arg, not second.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index d079f9a..da19bdf 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4103,7 +4103,7 @@ static long pmcraid_chr_ioctl(
 	struct pmcraid_ioctl_header *hdr = NULL;
 	int retval = -ENOTTY;
 
-	hdr = kmalloc(GFP_KERNEL, sizeof(struct pmcraid_ioctl_header));
+	hdr = kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_KERNEL);
 
 	if (!hdr) {
 		pmcraid_err("faile to allocate memory for ioctl header\n");
