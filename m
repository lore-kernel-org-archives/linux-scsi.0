Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A803CA4A4
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350295; cv=none; b=mU1MiZQ8fPtO/NVl9SvOkiuAdy+jv3S/wSta3RiAvAOlD4sQpU/30RV3AKQHhLVmjqsUC7B4/7S8s2ncY+Gj4Tlxjqr5V2d1QZwZKGEEn6qwYMkBgGVYC5QQOzR5ftiRuzhu6/oCv1QM6TbZUsKtshXeJznOlTOG19J0h7XZqxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350295; c=relaxed/simple;
	bh=kHl7sSphHOsgGeWxupepMmhkxZ7SQ2OrcbueWf2HBh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeIQk5Faa6+fP8xsSFXo8Wv+JodAG/lZ43kQBff55WtjYh/7h0lBcRkL8HOXAhyVRFLeajyu7tGPDH5v/4vkXAnsH0T9QW6o2fGvmO58oCypNXV+mfdjPk4Qc6zPaNJrORjF08mdxeY8FzzuzEFwtypbg/3wiVKLyVlQ0ycv1ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YqzvXuVR; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YqzvXuVR"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0pF45c5zlfl5h;
	Thu, 12 Mar 2026 21:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350290; x=1775942291; bh=bxReP
	mrO/OVhFixH69RjVFKrRh48DU0oMjwoangRZyE=; b=YqzvXuVRsztkZJn4VIcQ7
	7h5fLVhplpGVCGbMRYZz5Hu3HevAUIfAZBJ9bpdRZCmGAzRZ6e/YsNYbHKOSbo2c
	yZ+rJSlJIa+kQkbzb8LspwlYV1RPKZfxAmLxm3+T0lbI374CuuTPZ7GuaTGvDjP5
	bV6X5EHyKXjP8PIWvzgUTh0nLqtDS0FLOxkb2ytS7Fpdlfg5OxuTq3lyA+pL6Sdl
	MF5XkFt1wIkfJ0u8W9UMBBo0gmj/plcEJEUdgoW3nNN/YX2afixrbTh5jX0bmEhe
	cTUCnev/eOELmoYJ89zSpN3mS4hObUN6/JJpcIUdP8gsfb/X3CicbmlfJjHZCyyH
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id eeE5GsaJeLsg; Thu, 12 Mar 2026 21:18:10 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0p93zvjzlfl5l;
	Thu, 12 Mar 2026 21:18:09 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 29/36] scsi: qla1280: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:40 -0700
Message-ID: <20260312211636.3245119-30-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260312211636.3245119-1-bvanassche@acm.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
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
 drivers/scsi/qla1280.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index cdd6fe002c32..ebc878068684 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -737,6 +737,7 @@ static void qla1280_mailbox_timeout(struct timer_list=
 *t)
 static int
 _qla1280_wait_for_single_command(struct scsi_qla_host *ha, struct srb *s=
p,
 				 struct completion *wait)
+	__must_hold(ha->host->host_lock)
 {
 	int	status =3D FAILED;
 	struct scsi_cmnd *cmd =3D sp->cmd;
@@ -754,6 +755,7 @@ _qla1280_wait_for_single_command(struct scsi_qla_host=
 *ha, struct srb *sp,
=20
 static int
 qla1280_wait_for_single_command(struct scsi_qla_host *ha, struct srb *sp=
)
+	__must_hold(ha->host->host_lock)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
=20
@@ -763,6 +765,7 @@ qla1280_wait_for_single_command(struct scsi_qla_host =
*ha, struct srb *sp)
=20
 static int
 qla1280_wait_for_pending_commands(struct scsi_qla_host *ha, int bus, int=
 target)
+	__must_hold(ha->host->host_lock)
 {
 	int		cnt;
 	int		status;
@@ -809,6 +812,7 @@ qla1280_wait_for_pending_commands(struct scsi_qla_hos=
t *ha, int bus, int target)
  ***********************************************************************=
***/
 static int
 qla1280_error_action(struct scsi_cmnd *cmd, enum action action)
+	__must_hold(cmd->device->host->host_lock)
 {
 	struct scsi_qla_host *ha;
 	int bus, target, lun;
@@ -822,6 +826,10 @@ qla1280_error_action(struct scsi_cmnd *cmd, enum act=
ion action)
 	ENTER("qla1280_error_action");
=20
 	ha =3D (struct scsi_qla_host *)(CMD_HOST(cmd)->hostdata);
+
+	/* Tell the compiler that ha->host =3D=3D cmd->device->host. */
+	__assume_ctx_lock(ha->host->host_lock);
+
 	sp =3D scsi_cmd_priv(cmd);
 	bus =3D SCSI_BUS_32(cmd);
 	target =3D SCSI_TCN_32(cmd);
@@ -1490,6 +1498,7 @@ qla1280_initialize_adapter(struct scsi_qla_host *ha=
)
  */
 static const struct firmware *
 qla1280_request_firmware(struct scsi_qla_host *ha)
+	__must_hold(ha->host->host_lock)
 {
 	const struct firmware *fw;
 	int err;
@@ -1655,6 +1664,7 @@ qla1280_chip_diag(struct scsi_qla_host *ha)
=20
 static int
 qla1280_load_firmware_pio(struct scsi_qla_host *ha)
+	__must_hold(ha->host->host_lock)
 {
 	/* enter with host_lock acquired */
=20
@@ -1705,6 +1715,7 @@ qla1280_load_firmware_pio(struct scsi_qla_host *ha)
 #define DUMP_IT_BACK 0		/* for debug of RISC loading */
 static int
 qla1280_load_firmware_dma(struct scsi_qla_host *ha)
+	__must_hold(ha->host->host_lock)
 {
 	/* enter with host_lock acquired */
 	const struct firmware *fw;
@@ -1844,6 +1855,7 @@ qla1280_start_firmware(struct scsi_qla_host *ha)
=20
 static int
 qla1280_load_firmware(struct scsi_qla_host *ha)
+	__must_hold(ha->host->host_lock)
 {
 	/* enter with host_lock taken */
 	int err;
@@ -2413,6 +2425,7 @@ qla1280_nv_write(struct scsi_qla_host *ha, uint16_t=
 data)
  */
 static int
 qla1280_mailbox_command(struct scsi_qla_host *ha, uint8_t mr, uint16_t *=
mb)
+	__must_hold(ha->host->host_lock)
 {
 	struct device_reg __iomem *reg =3D ha->iobase;
 	int status =3D 0;
@@ -2538,6 +2551,7 @@ qla1280_poll(struct scsi_qla_host *ha)
  */
 static int
 qla1280_bus_reset(struct scsi_qla_host *ha, int bus)
+	__must_hold(ha->host->host_lock)
 {
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	uint16_t reset_delay;
@@ -2598,6 +2612,7 @@ qla1280_bus_reset(struct scsi_qla_host *ha, int bus=
)
  */
 static int
 qla1280_device_reset(struct scsi_qla_host *ha, int bus, int target)
+	__must_hold(ha->host->host_lock)
 {
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	int status;
@@ -2632,6 +2647,7 @@ qla1280_device_reset(struct scsi_qla_host *ha, int =
bus, int target)
  */
 static int
 qla1280_abort_command(struct scsi_qla_host *ha, struct srb * sp, int han=
dle)
+	__must_hold(ha->host->host_lock)
 {
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	unsigned int bus, target, lun;
@@ -3749,6 +3765,7 @@ qla1280_error_entry(struct scsi_qla_host *ha, struc=
t response *pkt,
  */
 static int
 qla1280_abort_isp(struct scsi_qla_host *ha)
+	__must_hold(ha->host->host_lock)
 {
 	struct device_reg __iomem *reg =3D ha->iobase;
 	struct srb *sp;
@@ -3881,6 +3898,7 @@ qla1280_check_for_dead_scsi_bus(struct scsi_qla_hos=
t *ha, unsigned int bus)
 static void
 qla1280_get_target_parameters(struct scsi_qla_host *ha,
 			      struct scsi_device *device)
+	__must_hold(ha->host->host_lock)
 {
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	int bus, target, lun;
