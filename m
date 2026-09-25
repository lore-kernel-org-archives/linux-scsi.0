Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7097C4D5984
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361179; cv=none; b=WF8R2Ae6oyTsjxGegcPXkwpXXJrVKxNRxqNwvCXrTOBonUUBeHR4CEzI0CuMt/e3LG9A+3jEbX33MIUVuJ/O1bN9Oqv4EKjgu+uwR7dHUyWfti/l2esmHjvXvvG0g8uQKVQs22mYwXkvcdKFj0WJN8Q33xITbxNggxEPapuaqHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361179; c=relaxed/simple;
	bh=K0TD7AHJsjv8IF4ivetnljblS+EsWd49hejeMgGb1r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pf0WkvdkxUkK91Dq1L1BfDQdgFXEL6IP9Tx0DcGBoLAWLk3Y+KOXQe0wDeAbAQEGHkxu4+WkYjLpkwQ4ZP8G95lTwQ38gQRpHgHm6+533+qzFYZ+Ryzl9viiDci3We+6WaMjaEVufpzUU1ZE1YCWoQ7SuZPMmw9pVlfMiBPUpwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iQf/+HGs; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iQf/+HGs"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzpd6NVtz1XM30g;
	Fri, 25 Sep 2026 18:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361173; x=1792953174; bh=5eEAX
	Ca3uJcWQw4Ks7l0tBTD/780hrRt4j648MhBfEg=; b=iQf/+HGsLWhSl5CQw6Dan
	v9fSH0NqyAnuVapHbH9Vj9LMrwhwaAC52VXhm63dlXiIX2R6xaEVMhYpz0VvqBXg
	B0Z4GLN6Ykh/OPlHy3og8MPZ2bQ6l/0OnsPvLjbPntqyGl7FuEctN07N6bJdNKWw
	OQD3Hy+TdatDpXGCHKIp3uCuWzb+C8reVwd8eUebN5hireZ6RmbD5UnzNh35LfHW
	m6UeC9u2iX9rkGDWxLD4ryiHL0ewpBQ0qi1oIHAFELs8KsibKbDHxaecxs5iety6
	L94wTqikRjJbkZ4i/FnBiAJsXVT/EZqr+JEsCl7hMAQ2VyEncwk+2HFM2uct0Nb7
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RtdWlQCy2MXA; Fri, 25 Sep 2026 18:32:53 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzpW2hFbz1XM5kW;
	Fri, 25 Sep 2026 18:32:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 47/54] scsi: qla1280: Prepare for enabling lock context analysis
Date: Fri, 25 Sep 2026 11:26:25 -0700
Message-ID: <ddbb3ac055d757d5113096ebda77dfa122606239.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document locking requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla1280.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 863b89ac6ba2..f71e668d011c 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -737,6 +737,7 @@ static void qla1280_mailbox_timeout(struct timer_list=
 *t)
 static int
 _qla1280_wait_for_single_command(struct Scsi_Host *host, struct srb *sp,
 				 struct completion *wait)
+	__must_hold(&host->host_lock)
 {
 	int	status =3D FAILED;
 	struct scsi_cmnd *cmd =3D sp->cmd;
@@ -754,6 +755,7 @@ _qla1280_wait_for_single_command(struct Scsi_Host *ho=
st, struct srb *sp,
=20
 static int
 qla1280_wait_for_single_command(struct Scsi_Host *host, struct srb *sp)
+	__must_hold(&host->host_lock)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
=20
@@ -764,6 +766,7 @@ qla1280_wait_for_single_command(struct Scsi_Host *hos=
t, struct srb *sp)
 static int
 qla1280_wait_for_pending_commands(struct scsi_qla_host *ha, struct Scsi_=
Host *host,
 				  int bus, int target)
+	__must_hold(&host->host_lock)
 {
 	int		cnt;
 	int		status;
@@ -811,6 +814,7 @@ qla1280_wait_for_pending_commands(struct scsi_qla_hos=
t *ha, struct Scsi_Host *ho
 static int
 qla1280_error_action(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 		     enum action action)
+	__must_hold(&host->host_lock)
 {
 	struct scsi_qla_host *ha;
 	int bus, target, lun;
@@ -1495,6 +1499,7 @@ qla1280_initialize_adapter(struct scsi_qla_host *ha=
)
  */
 static const struct firmware *
 qla1280_request_firmware(struct scsi_qla_host *ha)
+	__must_hold(&ha->host->host_lock)
 {
 	const struct firmware *fw;
 	int err;
@@ -1660,6 +1665,7 @@ qla1280_chip_diag(struct scsi_qla_host *ha)
=20
 static int
 qla1280_load_firmware_pio(struct scsi_qla_host *ha)
+	__must_hold(&ha->host->host_lock)
 {
 	/* enter with host_lock acquired */
=20
@@ -1710,6 +1716,7 @@ qla1280_load_firmware_pio(struct scsi_qla_host *ha)
 #define DUMP_IT_BACK 0		/* for debug of RISC loading */
 static int
 qla1280_load_firmware_dma(struct scsi_qla_host *ha)
+	__must_hold(&ha->host->host_lock)
 {
 	/* enter with host_lock acquired */
 	const struct firmware *fw;
@@ -1849,6 +1856,7 @@ qla1280_start_firmware(struct scsi_qla_host *ha)
=20
 static int
 qla1280_load_firmware(struct scsi_qla_host *ha)
+	__must_hold(&ha->host->host_lock)
 {
 	/* enter with host_lock taken */
 	int err;
@@ -2418,6 +2426,7 @@ qla1280_nv_write(struct scsi_qla_host *ha, uint16_t=
 data)
  */
 static int
 qla1280_mailbox_command(struct scsi_qla_host *ha, uint8_t mr, uint16_t *=
mb)
+	__must_hold(&ha->host->host_lock)
 {
 	struct device_reg __iomem *reg =3D ha->iobase;
 	int status =3D 0;
@@ -2543,6 +2552,7 @@ qla1280_poll(struct scsi_qla_host *ha)
  */
 static int
 qla1280_bus_reset(struct scsi_qla_host *ha, int bus)
+	__must_hold(&ha->host->host_lock)
 {
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	uint16_t reset_delay;
@@ -2603,6 +2613,7 @@ qla1280_bus_reset(struct scsi_qla_host *ha, int bus=
)
  */
 static int
 qla1280_device_reset(struct scsi_qla_host *ha, int bus, int target)
+	__must_hold(&ha->host->host_lock)
 {
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	int status;
@@ -2637,6 +2648,7 @@ qla1280_device_reset(struct scsi_qla_host *ha, int =
bus, int target)
  */
 static int
 qla1280_abort_command(struct scsi_qla_host *ha, struct srb * sp, int han=
dle)
+	__must_hold(&ha->host->host_lock)
 {
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	unsigned int bus, target, lun;
@@ -3754,6 +3766,7 @@ qla1280_error_entry(struct scsi_qla_host *ha, struc=
t response *pkt,
  */
 static int
 qla1280_abort_isp(struct scsi_qla_host *ha)
+	__must_hold(&ha->host->host_lock)
 {
 	struct device_reg __iomem *reg =3D ha->iobase;
 	struct srb *sp;
@@ -3886,6 +3899,7 @@ qla1280_check_for_dead_scsi_bus(struct scsi_qla_hos=
t *ha, unsigned int bus)
 static void
 qla1280_get_target_parameters(struct scsi_qla_host *ha,
 			      struct scsi_device *device)
+	__must_hold(&ha->host->host_lock)
 {
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	int bus, target, lun;
