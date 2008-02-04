From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/24][RFC] scsi_eh: Define  new API for sense handling
Date: Mon,  4 Feb 2008 17:30:34 +0200
Message-ID: <1202139034-4508-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:49887 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbYBDPg5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 10:36:57 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  This patch defines a new API for sense handling. All drivers will
  be converted to this API, before the sense handling implementation will
  change. API is as follows:

    void scsi_eh_cpy_sense(struct scsi_cmnd *cmd, void* sense,
        						 unsigned sense_bytes);
        To be used by drivers, when they have sense-bits
        and wants to send them to upper layer. Max size
        need not be a concern, If upper layer does not have
        enough space it will be automatically truncated.

    u8 *scsi_make_sense(struct scsi_cmnd *cmd);
        To be used by drivers, and scsi-midlayer. Returns a DMA-able
        sense buffer. Must be returned by scsi_return_sense(). It should
        never fail if .pre_allocate_sense && .sense_buffsize in host
        template where properly set.
        the buffer is of shost->sense_buffsize long.

    void *scsi_return_sense(struct scsi_cmnd *cmd, u8 *sb);
        Frees and returns the sense to the upper layer,
        copying only what's necessary.

    void scsi_eh_reset_sense(struct scsi_cmnd *cmd)
        Should not be used or necessary.

    const u8 *scsi_sense(struct scsi_cmnd *cmd)
        Used by ULDs and for inspecting the returned sense, can not
        be modified. It is only valid after a call to
        scsi_eh_cpy_sense() or a call to scsi_return_sense(). Before
        that it will/should return an empty buffer.

    New members at scsi host template:
        .sense_buffsize - if a driver calls scsi_make_sense() or
                  scsi_eh_prep_cmnd(), This value should be none
                  zero indicating the max sense size, the driver
                  supports. In most cases it should be
                  SCSI_SENSE_BUFFERSIZE.
                  If this value is zero the driver will only call
                  scsi_eh_cpy_sense().

        .pre_allocate_sense - if a Driver calls scsi_make_sense()
                      in .queuecommand for every cmnd, this
                      should be set to true. In which case
                      scsi_make_sense() will not fail because
                      midlayer will fail the command allocation.
                      If the drivers calls scsi_eh_prep_cmnd()
                      then sense_buffsize is not Zero but this
                      here is set to false.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi.c       |   12 ++++++++++++
 drivers/scsi/scsi_error.c |    7 +++++++
 include/scsi/scsi_eh.h    |   17 +++++++++++++++++
 include/scsi/scsi_host.h  |   15 +++++++++++++++
 4 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 98cba7d..af29ccc 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -290,6 +290,18 @@ void scsi_put_command(struct scsi_cmnd *cmd)
 }
 EXPORT_SYMBOL(scsi_put_command);
 
+u8 *scsi_make_sense(struct scsi_cmnd *cmd)
+{
+	return cmd->sense_buffer;
+}
+EXPORT_SYMBOL(scsi_make_sense);
+
+void scsi_return_sense(struct scsi_cmnd *cmd, u8 *sb)
+{
+	BUG_ON(cmd->sense_buffer != sb);
+}
+EXPORT_SYMBOL(scsi_return_sense);
+
 /**
  * scsi_setup_command_freelist - Setup the command freelist for a scsi host.
  * @shost: host to allocate the freelist for.
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 98696ae..dc8cd2b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -588,6 +588,13 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
 				scsi_try_host_reset(scmd);
 }
 
+void scsi_eh_cpy_sense(struct scsi_cmnd *cmd, void *sense, unsigned sense_bytes)
+{
+	unsigned len = min_t(unsigned, sense_bytes, SCSI_SENSE_BUFFERSIZE);
+	memcpy(cmd->sense_buffer, sense, len);
+}
+EXPORT_SYMBOL(scsi_eh_cpy_sense);
+
 /**
  * scsi_eh_prep_cmnd  - Save a scsi command info as part of error recory
  * @scmd:       SCSI command structure to hijack
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 9438ea1..ce84330 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -87,4 +87,21 @@ extern void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd,
 extern void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd,
 		struct scsi_eh_save *ses);
 
+extern void scsi_eh_cpy_sense(struct scsi_cmnd *cmd, void *sense,
+		unsigned sense_bytes);
+
+extern u8 *scsi_make_sense(struct scsi_cmnd *cmd);
+extern void scsi_return_sense(struct scsi_cmnd *cmd, u8 *sb);
+
+/*FIXME: don't use, it's temporary */
+static inline void scsi_eh_reset_sense(struct scsi_cmnd *cmd)
+{
+	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+}
+
+static inline const u8 *scsi_sense(struct scsi_cmnd *cmd)
+{
+	return cmd->sense_buffer;
+}
+
 #endif /* _SCSI_SCSI_EH_H */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index c2dd31d..f232768 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -443,6 +443,18 @@ struct scsi_host_template {
 	unsigned ordered_tag:1;
 
 	/*
+	 * IF sense_buffsize != 0 then this bit asks to pre-allocate a sense
+	 * buffer for each command.
+	 */
+	unsigned pre_allocate_sense:1;
+
+	/*
+	 * IF sense_buffsize != 0 then a mem_cache_pool is allocated for the
+	 * host with buffers of this size, with 1 pre-allocated buffer.
+	 */
+	unsigned sense_buffsize;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding
 	 */
 	unsigned int max_host_blocked;
@@ -609,6 +621,9 @@ struct Scsi_Host {
 	/* Asynchronous scan in progress */
 	unsigned async_scan:1;
 
+	/* actual allocated sense_buffsize for this host */
+	unsigned sense_buffsize;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
-- 
1.5.3.3

