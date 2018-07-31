From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 9/9] scsi: Check sense buffer size at build time
Date: Tue, 31 Jul 2018 12:51:54 -0700
Message-ID: <20180731195155.46664-10-keescook@chromium.org>
References: <20180731195155.46664-1-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731195155.46664-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Stephen Boyd <sboyd@codeaurora.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>, Juergen Gross <jgross@suse.com>, Viresh Kumar <viresh.kumar@linaro.org>, =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pen>
List-Id: linux-scsi@vger.kernel.org

To avoid introducing problems like those fixed in commit f7068114d45e
("sr: pass down correctly sized SCSI sense buffer"), this creates a macro
wrapper for scsi_execute() that verifies the size of the sense buffer
similar to what was done for command string sizes in commit 3756f6401c30
("exec: avoid gcc-8 warning for get_task_comm").

Another solution could be to add a length argument to scsi_execute(),
but this function already takes a lot of arguments and Jens was not fond
of that approach.

Additionally, this moves the SCSI_SENSE_BUFFERSIZE definition into
scsi_device.h, and removes a redundant include for scsi_device.h from
scsi_cmnd.h.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/scsi_lib.c    |  6 +++---
 include/scsi/scsi_cmnd.h   |  6 ++----
 include/scsi/scsi_device.h | 14 +++++++++++++-
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9b4f279d29c..718c2bec4516 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -238,7 +238,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 
 
 /**
- * scsi_execute - insert request and wait for the result
+ * __scsi_execute - insert request and wait for the result
  * @sdev:	scsi device
  * @cmd:	scsi command
  * @data_direction: data direction
@@ -255,7 +255,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
  * Returns the scsi_cmnd result field if a command was executed, or a negative
  * Linux error code if we didn't get that far.
  */
-int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		 int data_direction, void *buffer, unsigned bufflen,
 		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
 		 int timeout, int retries, u64 flags, req_flags_t rq_flags,
@@ -309,7 +309,7 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 
 	return ret;
 }
-EXPORT_SYMBOL(scsi_execute);
+EXPORT_SYMBOL(__scsi_execute);
 
 /*
  * Function:    scsi_init_cmd_errh()
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index aaf1e971c6a3..7bf043a66e10 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -14,8 +14,6 @@
 struct Scsi_Host;
 struct scsi_driver;
 
-#include <scsi/scsi_device.h>
-
 /*
  * MAX_COMMAND_SIZE is:
  * The longest fixed-length SCSI CDB as per the SCSI standard.
@@ -120,11 +118,11 @@ struct scsi_cmnd {
 	struct request *request;	/* The command we are
 				   	   working on */
 
-#define SCSI_SENSE_BUFFERSIZE 	96
 	unsigned char *sense_buffer;
 				/* obtained by REQUEST SENSE when
 				 * CHECK CONDITION is received on original
-				 * command (auto-sense) */
+				 * command (auto-sense). Length must be
+				 * SCSI_SENSE_BUFFERSIZE bytes. */
 
 	/* Low-level done function - can be used by low-level driver to point
 	 *        to completion function.  Not used by mid/upper level code. */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7ae177c8e399..96b626ad5fb1 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -17,6 +17,8 @@ struct scsi_sense_hdr;
 
 typedef unsigned int __bitwise blist_flags_t;
 
+#define SCSI_SENSE_BUFFERSIZE	96
+
 struct scsi_mode_data {
 	__u32	length;
 	__u16	block_descriptor_length;
@@ -426,11 +428,21 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
-extern int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, struct scsi_sense_hdr *sshdr,
 			int timeout, int retries, u64 flags,
 			req_flags_t rq_flags, int *resid);
+/* Make sure any sense buffer is the correct size. */
+#define scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,	\
+		     sshdr, timeout, retries, flags, rq_flags, resid)	\
+({									\
+	BUILD_BUG_ON((sense) != NULL &&					\
+		     sizeof(sense) != SCSI_SENSE_BUFFERSIZE);		\
+	__scsi_execute(sdev, cmd, data_direction, buffer, bufflen,	\
+		       sense, sshdr, timeout, retries, flags, rq_flags,	\
+		       resid);						\
+})
 static inline int scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-- 
2.17.1
