From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 4/9] target: don't depend on SCSI
Date: Tue, 31 Jul 2018 12:51:49 -0700
Message-ID: <20180731195155.46664-5-keescook@chromium.org>
References: <20180731195155.46664-1-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731195155.46664-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Stephen Boyd <sboyd@codeaurora.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>, Juergen Gross <jgross@suse.com>, Viresh Kumar <viresh.kumar@linaro.org>, =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

The core target code only needs code from scsi_common.c, which is now
separately selectable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/target/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 4c44d7bed01a..cb6f32ce7de8 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -1,10 +1,10 @@
 
 menuconfig TARGET_CORE
 	tristate "Generic Target Core Mod (TCM) and ConfigFS Infrastructure"
-	depends on SCSI && BLOCK
+	depends on BLOCK
 	select CONFIGFS_FS
 	select CRC_T10DIF
-	select BLK_SCSI_REQUEST # only for scsi_command_size_tbl..
+	select BLK_SCSI_REQUEST
 	select SGL_ALLOC
 	default n
 	help
@@ -29,6 +29,7 @@ config TCM_FILEIO
 
 config TCM_PSCSI
 	tristate "TCM/pSCSI Subsystem Plugin for Linux/SCSI"
+	depends on SCSI
 	help
 	Say Y here to enable the TCM/pSCSI subsystem plugin for non-buffered
 	passthrough access to Linux/SCSI device
-- 
2.17.1
