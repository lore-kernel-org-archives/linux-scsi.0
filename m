From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Date: Wed, 30 Jul 2008 16:18:42 -0500
Message-ID: <20080730211842.GF1758@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759017AbYG3VTG@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Patch 6 of 6

Bug fix. If SCSI tape support is turned off we get an implicit declaration
of cciss_unregister_scsi error in cciss_remove_one.
Please consider this for inclusion.

Thanks,
mikem

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ae663db..262148b 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3616,7 +3616,9 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 		}
 	}
 
+#ifdef CONFIG_CISS_SCSI_TAPE
 	cciss_unregister_scsi(i);	/* unhook from SCSI subsystem */
+#endif
 
 	cciss_shutdown(pdev);
 
