From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 6/9] ide-cd: Remove redundant sense buffer
Date: Tue, 31 Jul 2018 12:51:51 -0700
Message-ID: <20180731195155.46664-7-keescook@chromium.org>
References: <20180731195155.46664-1-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731195155.46664-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Stephen Boyd <sboyd@codeaurora.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>, Juergen Gross <jgross@suse.com>, Viresh Kumar <viresh.kumar@linaro.org>, =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pen>
List-Id: linux-scsi@vger.kernel.org

This is already able to process the sense buffer, so remove the redundant
parsing during the failure path. This also fixes any possible stale values
since the prior code did not check the sense length.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/ide/ide-cd.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index cb90560acf6e..023a7d94eb08 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -423,6 +423,7 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 		    req_flags_t rq_flags)
 {
 	struct cdrom_info *info = drive->driver_data;
+	struct scsi_sense_hdr local_sshdr;
 	int retries = 10;
 	bool failed;
 
@@ -430,6 +431,9 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 				  "rq_flags: 0x%x",
 				  cmd[0], write, timeout, rq_flags);
 
+	if (!sshdr)
+		sshdr = &local_sshdr;
+
 	/* start of retry loop */
 	do {
 		struct request *rq;
@@ -456,9 +460,8 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 
 		if (buffer)
 			*bufflen = scsi_req(rq)->resid_len;
-		if (sshdr)
-			scsi_normalize_sense(scsi_req(rq)->sense,
-					     scsi_req(rq)->sense_len, sshdr);
+		scsi_normalize_sense(scsi_req(rq)->sense,
+				     scsi_req(rq)->sense_len, sshdr);
 
 		/*
 		 * FIXME: we should probably abort/retry or something in case of
@@ -470,12 +473,10 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 			 * The request failed.  Retry if it was due to a unit
 			 * attention status (usually means media was changed).
 			 */
-			struct request_sense *reqbuf = scsi_req(rq)->sense;
-
-			if (reqbuf->sense_key == UNIT_ATTENTION)
+			if (sshdr->sense_key == UNIT_ATTENTION)
 				cdrom_saw_media_change(drive);
-			else if (reqbuf->sense_key == NOT_READY &&
-				 reqbuf->asc == 4 && reqbuf->ascq != 4) {
+			else if (sshdr->sense_key == NOT_READY &&
+				 sshdr->asc == 4 && sshdr->ascq != 4) {
 				/*
 				 * The drive is in the process of loading
 				 * a disk.  Retry, but wait a little to give
-- 
2.17.1
