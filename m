From: Kulikov Vasiliy <segooon@gmail.com>
Subject: [PATCH] scsi: mac_scsi: check scsi_register() result
Date: Thu, 29 Jul 2010 19:56:25 +0400
Message-ID: <1280418986-6024-1-git-send-email-segooon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kernel-janitors@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

scsi_register() may fail, if so return from detect() with negative
result.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/scsi/mac_scsi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index bf2a1c5..3ab601f 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -268,6 +268,9 @@ int macscsi_detect(struct scsi_host_template * tpnt)
     /* Once we support multiple 5380s (e.g. DuoDock) we'll do
        something different here */
     instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
+    if (instance == NULL)
+	return 0;
+
 #if NDEBUG
     default_instance = instance;
 #endif
-- 
1.7.0.4
