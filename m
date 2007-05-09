From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 4/7] libata: expose AN to user space
Date: Wed, 9 May 2007 16:38:28 -0700
Message-ID: <20070509163828.2c17128f.kristen.c.accardi@intel.com>
References: <20070510072247.063476979@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070510072247.063476979@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, Kristen Carlson Accardi <kristen.c.accardi@intel.com>
List-Id: linux-scsi@vger.kernel.org

If Asynchronous Notification of media change events is supported,
pass that information up to the SCSI layer.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/drivers/ata/libata-scsi.c
===================================================================
--- 2.6-git.orig/drivers/ata/libata-scsi.c
+++ 2.6-git/drivers/ata/libata-scsi.c
@@ -899,6 +899,9 @@ static void ata_scsi_dev_config(struct s
 		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
 	}
 
+	if (dev->flags & ATA_DFLAG_AN)
+		sdev->media_change_notify = 1;
+
 	if (dev->flags & ATA_DFLAG_NCQ) {
 		int depth;
 

-- 
