From: akpm@osdl.org
Subject: [patch 1/1] megaraid build fix
Date: Wed, 18 Aug 2004 20:57:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408190359.i7J3xG106754@mail.osdl.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:27524 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S268038AbUHSD7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2004 23:59:20 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org



drivers/scsi/megaraid/megaraid_mm.c: In function `mraid_mm_init':
drivers/scsi/megaraid/megaraid_mm.c:1069: `mraid_mm_compat_ioctl' undeclared (first use in this function)
drivers/scsi/megaraid/megaraid_mm.c:1069: (Each undeclared identifier is reported only once
drivers/scsi/megaraid/megaraid_mm.c:1069: for each function it appears in.)


btw, it's completely pointless to put static function definitions into header
files.  I'd suggest that all this stuff:

+// Entry points for char node driver
+static int mraid_mm_open(struct inode *, struct file *);
+static int mraid_mm_ioctl(struct inode *, struct file *, uint, unsigned long);
+
+
+// routines to convert to and from the old the format
+static int mimd_to_kioc(mimd_t *, mraid_mmadp_t *, uioc_t *);
+static int kioc_to_mimd(uioc_t *, mimd_t *);
+
+
+// Helper functions
+static int handle_drvrcmd(unsigned long, uint8_t, int *);
+static int lld_ioctl(mraid_mmadp_t *, uioc_t *);
+static void ioctl_done(uioc_t *);
+static void lld_timedout(unsigned long);
+static void hinfo_to_cinfo(mraid_hba_info_t *, mcontroller_t *);
+static int mraid_mm_get_adpindex(mimd_t *, int *);
+static uioc_t *mraid_mm_alloc_kioc(mraid_mmadp_t *);
+static void mraid_mm_dealloc_kioc(mraid_mmadp_t *, uioc_t *);
+static int mraid_mm_attach_buf(mraid_mmadp_t *, uioc_t *, int);
+static int mraid_mm_setup_dma_pools(mraid_mmadp_t *);
+static void mraid_mm_free_adp_resources(mraid_mmadp_t *);
+static void mraid_mm_teardown_dma_pools(mraid_mmadp_t *);
+
+#ifdef CONFIG_COMPAT
+static int mraid_mm_compat_ioctl(unsigned int, unsigned int, unsigned long,
+		struct file *);
+#endif

me moved into drivers/scsi/megaraid/megaraid_mm.c



Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 25-akpm/drivers/scsi/megaraid/megaraid_mm.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/megaraid/megaraid_mm.c~megaraid-build-fix drivers/scsi/megaraid/megaraid_mm.c
--- 25/drivers/scsi/megaraid/megaraid_mm.c~megaraid-build-fix	2004-08-18 20:52:58.422534184 -0700
+++ 25-akpm/drivers/scsi/megaraid/megaraid_mm.c	2004-08-18 20:57:11.134116184 -0700
@@ -1066,7 +1066,9 @@ mraid_mm_init(void)
 
 	slots_inuse = 0;
 
+#ifdef CONFIG_COMPAT
 	register_ioctl32_conversion(MEGAIOCCMD, mraid_mm_compat_ioctl);
+#endif
 
 	return 0;
 }
_
