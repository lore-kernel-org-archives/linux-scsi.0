From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 2/2] pcmcia: nsp_cs: add __printf attribute to logging functions
Date: Sat, 20 May 2017 13:16:28 +0200
Message-ID: <20170520111628.24787-2-nicolas.iooss_linux@m4x.org>
References: <20170520111628.24787-1-nicolas.iooss_linux@m4x.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170520111628.24787-1-nicolas.iooss_linux@m4x.org>
Sender: linux-kernel-owner@vger.kernel.org
To: GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicolas Iooss <nicolas.iooss_linux@m4x.org>
List-Id: linux-scsi@vger.kernel.org

Adding __printf attributes helps to detect errors in printf format
strings at build time.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/scsi/pcmcia/nsp_cs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 5fb6eefc6541..33b982be9763 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -136,7 +136,8 @@ static inline void nsp_inc_resid(struct scsi_cmnd *SCpnt, int residInc)
 	scsi_set_resid(SCpnt, scsi_get_resid(SCpnt) + residInc);
 }
 
-static void nsp_cs_message(const char *func, int line, char *type, char *fmt, ...)
+static __printf(4, 5)
+void nsp_cs_message(const char *func, int line, char *type, const char *fmt, ...)
 {
 	va_list args;
 	char buf[NSP_DEBUG_BUF_LEN];
@@ -153,7 +154,8 @@ static void nsp_cs_message(const char *func, int line, char *type, char *fmt, ..
 }
 
 #ifdef NSP_DEBUG
-static void nsp_cs_dmessage(const char *func, int line, int mask, char *fmt, ...)
+static __printf(4, 5)
+void nsp_cs_dmessage(const char *func, int line, int mask, const char *fmt, ...)
 {
 	va_list args;
 	char buf[NSP_DEBUG_BUF_LEN];
-- 
2.12.2
