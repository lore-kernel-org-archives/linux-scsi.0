From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 3/9] scsi: build scsi_common.o for all scsi passthrough request users
Date: Tue, 31 Jul 2018 12:51:48 -0700
Message-ID: <20180731195155.46664-4-keescook@chromium.org>
References: <20180731195155.46664-1-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731195155.46664-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Stephen Boyd <sboyd@codeaurora.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>, Juergen Gross <jgross@suse.com>, Viresh Kumar <viresh.kumar@linaro.org>, =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Split scsi_common.o out of SCSI so that non-SCSI users can pull it in
easily for future sense buffer helper usage.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/Makefile      | 2 +-
 drivers/scsi/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index 24cd47014657..a6abd7a856c6 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -76,7 +76,7 @@ obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf/
 obj-$(CONFIG_NUBUS)		+= nubus/
 obj-y				+= macintosh/
 obj-$(CONFIG_IDE)		+= ide/
-obj-$(CONFIG_SCSI)		+= scsi/
+obj-y				+= scsi/
 obj-y				+= nvme/
 obj-$(CONFIG_ATA)		+= ata/
 obj-$(CONFIG_TARGET_CORE)	+= target/
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index e29f9b8fd66d..1f6218b98430 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -21,6 +21,7 @@ CFLAGS_gdth.o    = # -DDEBUG_GDTH=2 -D__SERIAL__ -D__COM2__ -DGDTH_STATISTICS
 obj-$(CONFIG_PCMCIA)		+= pcmcia/
 
 obj-$(CONFIG_SCSI)		+= scsi_mod.o
+obj-$(CONFIG_BLK_SCSI_REQUEST)	+= scsi_common.o
 
 obj-$(CONFIG_RAID_ATTRS)	+= raid_class.o
 
@@ -155,7 +156,6 @@ obj-$(CONFIG_SCSI_HISI_SAS) += hisi_sas/
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o \
 				   scsicam.o scsi_error.o scsi_lib.o
-scsi_mod-y			+= scsi_common.o
 scsi_mod-$(CONFIG_SCSI_CONSTANTS) += constants.o
 scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
 scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
-- 
2.17.1
