From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/7] scsi: csiostor: no need to check return value of debugfs_create functions
Date: Tue, 22 Jan 2019 16:09:01 +0100
Message-ID: <20190122150906.12470-3-gregkh@linuxfoundation.org>
References: <20190122150906.12470-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122150906.12470-1-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Varun Prakash <varun@chelsio.com>, Bjorn Helgaas <bhelgaas@google.com>, Johannes Thumshirn <jthumshirn@suse.de>, Oza Pawandeep <poza@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Varun Prakash <varun@chelsio.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Oza Pawandeep <poza@codeaurora.org>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/csiostor/csio_init.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index cf629380a981..460e4ee1c8fe 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -167,14 +167,10 @@ csio_dfs_destroy(struct csio_hw *hw)
  * csio_dfs_init - Debug filesystem initialization for the module.
  *
  */
-static int
+static void
 csio_dfs_init(void)
 {
 	csio_debugfs_root = debugfs_create_dir(KBUILD_MODNAME, NULL);
-	if (!csio_debugfs_root)
-		pr_warn("Could not create debugfs entry, continuing\n");
-
-	return 0;
 }
 
 /*
-- 
2.20.1
