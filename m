Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045C5258EE9;
	Fri,  4 Sep 2026 00:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481628; cv=none; b=MZ/KQLvmD7E71poB01WvFdmVxVGqoeXHz7hfMUEoixRxWYCKmnpFFcfUg/zcu9JkQg7HYTeSlkdx8nA7EWU2weLvH7C+vtr8QGRJX2B+V98nbSsgqim64czDD90pMWibeaOTagvseR9YwrMxtLf9ZxOBcfK0/XioFyrZ45QLIMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481628; c=relaxed/simple;
	bh=eA6UhE29+aYP8gMGkouzX4VICD0RMq7lW9EsuQHC+2c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nt+N1DKAVQGE/opvdzKHDA2btmtweGM7HufLcy5vZzOZM3PrNVZ8bXNC66uuWOQDnjMO+ktdUzXs+PZYR69y5pG7IJl0j53G3tN3WMVmKn8NtFlSdGe2P12NGI5JrF6N1cqW+XkNbuJKaxVccdqscwIZ6hsSrU+K7j7mTgdps6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8Wq4OnT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8Wq4OnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8CE1F00A3D;
	Fri,  4 Sep 2026 00:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481624;
	bh=YQCvBP32+cPet4dNoCo6G3Fg0J8cgjdBK1KHQP1tYYY=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=j8Wq4OnTubNfak5EhyhgqoaP3o9vhyJqoa7/5pg7vV098EtAJXPe4UhSiQ74q7HgB
	 aYHcXqY0tRoN+OrabPG/+7Rl7miR1jp5BLoFompEvbTfKHKn2XN8ZJHu9HVWxXimoS
	 hfdNpd4LYYHtuxC3rO5aTdzjyN4QE2+k311gwEwH4mx7mDq9pLP/2QBZpGuiN5BL+t
	 1fR+458AJ9JB0PG4bE5pjSMrUzQCYrsSWynWph688bAcjvViHattyrjtv/YpdZcBUN
	 ejHhvp1d14HMJMb1FThQJM3rwRjTL7jdUX6RogQWZzUd4HLWKPLof4RqiAEyFFQOip
	 C+ZQtMIs6psug==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v3 04/40] scsi: rename sense field of struct scsi_failure
Date: Fri,  4 Sep 2026 09:26:08 +0900
Message-ID: <20260904002644.157668-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904002644.157668-1-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename the sense field of struct scsi_failure to sense_key. This makes
it clear that this field stores the sense key, and also unifies this
structure field names with the names used in struct scsi_sense_hdr.

To be consistent with this change, the macro SCMD_FAILURE_SENSE_ANY is
renamed SCMD_FAILURE_SENSE_KEY_ANY.

Of note is that the definition of the array any_sense_failure_defs in
scsi_lib_test_any_sense() is modified to change the initialization of the
result field to use SCMD_FAILURE_RESULT_ANY and add the .sense_key field
initialization to SCMD_FAILURE_SENSE_KEY_ANY to match the test target
case.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/ch.c                           |  2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 10 ++++-----
 drivers/scsi/scsi_lib.c                     |  6 ++---
 drivers/scsi/scsi_lib_test.c                | 25 +++++++++++----------
 drivers/scsi/scsi_scan.c                    |  8 +++----
 drivers/scsi/scsi_transport_spi.c           |  2 +-
 drivers/scsi/sd.c                           | 20 ++++++++---------
 drivers/scsi/ses.c                          |  8 +++----
 include/scsi/scsi_device.h                  | 12 +++++-----
 10 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 4010fdbf813c..b804291a36ff 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -191,7 +191,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = 3,
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 6e8849d7f0a3..3431e1ce95fd 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -84,7 +84,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = SCMD_FAILURE_NO_LIMIT,
@@ -138,7 +138,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 			 *
 			 * Switch-over in progress, retry.
 			 */
-			.sense = NOT_READY,
+			.sense_key = NOT_READY,
 			.asc = 0x04,
 			.ascq = 0x03,
 			.allowed = HP_SW_RETRIES,
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 88c8e36b221e..75c9cc291e38 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -514,33 +514,33 @@ static void send_mode_select(struct work_struct *work)
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = NO_SENSE,
+			.sense_key = NO_SENSE,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = ABORTED_COMMAND,
+			.sense_key = ABORTED_COMMAND,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* LUN Not Ready and is in the Process of Becoming Ready */
 		{
-			.sense = NOT_READY,
+			.sense_key = NOT_READY,
 			.asc = 0x04,
 			.ascq = 0x01,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* Command Lock contention */
 		{
-			.sense = ILLEGAL_REQUEST,
+			.sense_key = ILLEGAL_REQUEST,
 			.asc = 0x91,
 			.ascq = 0x36,
 			.allowed = SCMD_FAILURE_NO_LIMIT,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index af27fd3df8d4..4901b2dff653 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -243,13 +243,13 @@ static int scsi_check_passthrough(struct scsi_cmnd *scmd,
 			continue;
 
 		if (status_byte(failure->result) != SAM_STAT_CHECK_CONDITION ||
-		    failure->sense == SCMD_FAILURE_SENSE_ANY)
+		    failure->sense_key == SCMD_FAILURE_SENSE_KEY_ANY)
 			goto maybe_retry;
 
 		if (!scsi_command_normalize_sense(scmd, &sshdr))
 			return 0;
 
-		if (failure->sense != sshdr.sense_key)
+		if (failure->sense_key != sshdr.sense_key)
 			continue;
 
 		if (failure->asc == SCMD_FAILURE_ASC_ANY)
@@ -2372,7 +2372,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 	struct scsi_sense_hdr my_sshdr;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = retries,
diff --git a/drivers/scsi/scsi_lib_test.c b/drivers/scsi/scsi_lib_test.c
index ae8af0e0047a..4558dc853e26 100644
--- a/drivers/scsi/scsi_lib_test.c
+++ b/drivers/scsi/scsi_lib_test.c
@@ -17,40 +17,40 @@ static void scsi_lib_test_multiple_sense(struct kunit *test)
 {
 	struct scsi_failure multiple_sense_failure_defs[] = {
 		{
-			.sense = DATA_PROTECT,
+			.sense_key = DATA_PROTECT,
 			.asc = 0x1,
 			.ascq = 0x1,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x11,
 			.ascq = 0x0,
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = NOT_READY,
+			.sense_key = NOT_READY,
 			.asc = 0x11,
 			.ascq = 0x22,
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = ABORTED_COMMAND,
+			.sense_key = ABORTED_COMMAND,
 			.asc = 0x11,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = HARDWARE_ERROR,
+			.sense_key = HARDWARE_ERROR,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = ILLEGAL_REQUEST,
+			.sense_key = ILLEGAL_REQUEST,
 			.asc = 0x91,
 			.ascq = 0x36,
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
@@ -116,8 +116,9 @@ static void scsi_lib_test_any_sense(struct kunit *test)
 {
 	struct scsi_failure any_sense_failure_defs[] = {
 		{
-			.result = SCMD_FAILURE_SENSE_ANY,
+			.sense_key = SCMD_FAILURE_SENSE_KEY_ANY,
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+			.result = SCMD_FAILURE_RESULT_ANY,
 		},
 		{}
 	};
@@ -129,7 +130,7 @@ static void scsi_lib_test_any_sense(struct kunit *test)
 		.sense_buffer = sense,
 	};
 
-	/* Match using SCMD_FAILURE_SENSE_ANY */
+	/* Match using SCMD_FAILURE_SENSE_KEY_ANY */
 	failures.failure_definitions = any_sense_failure_defs;
 	scsi_build_sense(&sc, 0, MEDIUM_ERROR, 0x11, 0x22);
 	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
@@ -215,14 +216,14 @@ static void scsi_lib_test_total_allowed(struct kunit *test)
 {
 	struct scsi_failure total_allowed_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* Fail all CCs except the UA above */
 		{
-			.sense = SCMD_FAILURE_SENSE_ANY,
+			.sense_key = SCMD_FAILURE_SENSE_KEY_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* Retry any other errors not listed above */
@@ -259,12 +260,12 @@ static void scsi_lib_test_mixed_total(struct kunit *test)
 {
 	struct scsi_failure mixed_total_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x28,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3b82e80e807a..003ab639e76d 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -658,12 +658,12 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		 * so anyway.
 		 */
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x28,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
@@ -1457,14 +1457,14 @@ static int scsi_report_lun_scan(struct Scsi_Host *shost,
 	struct scsi_device *sdev;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* Fail all CCs except the UA above */
 		{
-			.sense = SCMD_FAILURE_SENSE_ANY,
+			.sense_key = SCMD_FAILURE_SENSE_KEY_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* Retry any other errors not listed above */
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 3e3da8c2ff26..ec3884a6657f 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -112,7 +112,7 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 			REQ_FAILFAST_DRIVER;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = DV_RETRIES,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1b21ea14e54..fecb001115ab 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2033,7 +2033,7 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 	u8 cmd[10] = { PERSISTENT_RESERVE_IN, sa };
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = 5,
@@ -2145,7 +2145,7 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = 5,
@@ -2494,13 +2494,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 	struct scsi_failure failure_defs[] = {
 		/* Do not retry Medium Not Present */
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x3A,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = NOT_READY,
+			.sense_key = NOT_READY,
 			.asc = 0x3A,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
@@ -2817,18 +2817,18 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	struct scsi_failure failure_defs[] = {
 		/* Do not retry Medium Not Present */
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x3A,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = NOT_READY,
+			.sense_key = NOT_READY,
 			.asc = 0x3A,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		 /* Device reset might occur several times so retry a lot */
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
 			.result = SAM_STAT_CHECK_CONDITION,
@@ -4159,21 +4159,21 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	struct scsi_failure failure_defs[] = {
 		{
 			/* Power on, reset, or bus device reset occurred */
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.ascq = 0,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			/* Power on occurred */
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.ascq = 1,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			/* SCSI bus reset */
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.ascq = 2,
 			.result = SAM_STAT_CHECK_CONDITION,
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 4c348645b04e..454886c24570 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -88,14 +88,14 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 	unsigned char recv_page_code;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = SES_RETRIES,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = NOT_READY,
+			.sense_key = NOT_READY,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = SES_RETRIES,
@@ -145,14 +145,14 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 	};
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = SES_RETRIES,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = NOT_READY,
+			.sense_key = NOT_READY,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = SES_RETRIES,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8694eeadd753..e321471e8ca2 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -514,18 +514,18 @@ extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
  */
 #define SCMD_FAILURE_STAT_ANY	0xff
 /*
- * The following can be set to the scsi_failure sense, asc and ascq fields to
- * match on any sense, ASC, or ASCQ value.
+ * The following can be set to the scsi_failure sense key, asc and ascq fields
+ * to match any sense key, ASC, and ASCQ value.
  */
-#define SCMD_FAILURE_SENSE_ANY	0xff
-#define SCMD_FAILURE_ASC_ANY	0xff
-#define SCMD_FAILURE_ASCQ_ANY	0xff
+#define SCMD_FAILURE_SENSE_KEY_ANY	0xff
+#define SCMD_FAILURE_ASC_ANY		0xff
+#define SCMD_FAILURE_ASCQ_ANY		0xff
 /* Always retry a matching failure. */
 #define SCMD_FAILURE_NO_LIMIT	-1
 
 struct scsi_failure {
 	int result;
-	u8 sense;
+	u8 sense_key;
 	u8 asc;
 	u8 ascq;
 	/*
-- 
2.55.0

