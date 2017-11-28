From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: wd719x: make card_types static const, shrinks object size
Date: Tue, 28 Nov 2017 18:12:34 +0000
Message-ID: <20171128181234.24330-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the read-only array card_types on the stack but instead
make it static and constify it. Makes the object code smaller by over
110 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  25625	   5752	      0	  31377	   7a91	drivers/scsi/wd719x.o

After:
   text	   data	    bss	    dec	    hex	filename
  25447	   5816	      0	  31263	   7a1f	drivers/scsi/wd719x.o

(gcc version 7.2.0 x86_64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/wd719x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 2a9da2e0ea6b..2ba2b7b47f41 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -803,7 +803,9 @@ static enum wd719x_card_type wd719x_detect_type(struct wd719x *wd)
 static int wd719x_board_found(struct Scsi_Host *sh)
 {
 	struct wd719x *wd = shost_priv(sh);
-	char *card_types[] = { "Unknown card", "WD7193", "WD7197", "WD7296" };
+	static const char * const card_types[] = {
+		"Unknown card", "WD7193", "WD7197", "WD7296"
+	};
 	int ret;
 
 	INIT_LIST_HEAD(&wd->active_scbs);
-- 
2.14.1
