From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] message: fusion: mptscsih.c:  Fix for possible null pointer dereference
Date: Sun, 18 May 2014 17:59:43 +0200
Message-ID: <1400428783-10162-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/message/fusion/mptscsih.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 727819c..b323b23 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1279,9 +1279,11 @@ mptscsih_info(struct Scsi_Host *SChost)
 
 		mpt_print_ioc_summary(h->ioc, h->info_kbuf, &size, 0, 0);
 		h->info_kbuf[size-1] = '\0';
+
+		return h->info_kbuf;
 	}
 
-	return h->info_kbuf;
+	return NULL;
 }
 
 int mptscsih_show_info(struct seq_file *m, struct Scsi_Host *host)
-- 
1.7.10.4
