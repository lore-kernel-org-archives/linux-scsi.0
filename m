From: roel kluin <roel.kluin@gmail.com>
Subject: [PATCH] U14-34F: fix scsi_dma_map failure case
Date: Tue, 21 Oct 2008 01:08:18 -0400
Message-ID: <48FD63C2.40400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755858AbYJTXIm@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ballabio_dario@emc.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When unsigned, scsi_dma_map may return -ENOMEM without triggering BUG_ON()

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 329eb87..601e951 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1111,7 +1111,8 @@ static int u14_34f_detect(struct scsi_host_template *tpnt) {
 
 static void map_dma(unsigned int i, unsigned int j) {
    unsigned int data_len = 0;
-   unsigned int k, count, pci_dir;
+   unsigned int k, pci_dir;
+   int count;
    struct scatterlist *sg;
    struct mscp *cpp;
    struct scsi_cmnd *SCpnt;
