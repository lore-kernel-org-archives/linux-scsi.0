Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF5235AC00
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361177; cv=none; b=V7suBgWiXF/sAUM6NlxIeqR2Na/GuZiXwv1S+Xr0cO4J6aQ2ONUZNTK/tX6McLu+wsjwBro/lpPELNXZTFJw9HZPFwEKRRetzen9uGD0ChU+Dps58ru4g4P33dqAO5oOu3eJzvJvZoQnpY2RDAaFdQpA0XS+GC+9EwJuKm3dNW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361177; c=relaxed/simple;
	bh=ob7Y2qI/jlmCWkvlAwQG3vHyPR3lns4tCtu4InaaR8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BL6mezinSNTz2wxBFcv26JGuAnlPaiwukq2cdTj7GeVpV1thJ0NPImXPnHSTGo9p8E08e8VQLcECTT28ZXUfic3wrWoUc5N5hb8tnCmzRc3PmjcuivEzgJhq1QWpkg7cn/uXxNPMhi/IuHQKcGuFGR7K6UygjAPOtiZeoA8hdjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2Bw/pFYS; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2Bw/pFYS"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzpb68Z2z1XM30h;
	Fri, 25 Sep 2026 18:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361170; x=1792953171; bh=X3ylN
	MP9Na0qtzR8W1fZNBJLOL6eySSxua0yGuS4rVI=; b=2Bw/pFYS+nD4JRUV3iQfe
	4oDfio9ykE+fFkXcohpGCGQf+2WUnvmxE2Htp+CuRSMbVgQm8p4JcCJ6D2tPn7gm
	ZjTNZnE/NW86ojCWOY5dVSD8dkci2TYDRE9tCzvBINNYhuI95iKcvfgkNfw+fkCy
	rUr6s2Imaf6HzVI4y68Ilh5MCEK3nPGOmG+sd0weQPsM1xgWzjElk58ctzhm+D+Q
	049HO3h4rcyZtdGDKzbEmhDKqxlcgXeuH8oaI2Gge6fmWrxAwPq6FpLi6dnd3AsV
	EYUnLRjDvi37hZaZhZhRXZpdAve4XhhhFtZDR21/DIgnizGlIH4UBwVAoUnOegV7
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uL0btAhAw9Yi; Fri, 25 Sep 2026 18:32:50 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzpT0fn1z1XM30g;
	Fri, 25 Sep 2026 18:32:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 46/54] scsi: qla1280: Pass the host pointer directly to several functions
Date: Fri, 25 Sep 2026 11:26:24 -0700
Message-ID: <4c2a8952fd8d3c8742af5685d0bb3a1677ba92b5.1790360262.git.bvanassche@acm.org>
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

Pass the struct Scsi_Host pointer directly to
_qla1280_wait_for_single_command(), qla1280_wait_for_single_command(),
qla1280_wait_for_pending_commands(), and qla1280_error_action().
Introduce the local variable 'host' in error handling functions to avoid
repetitive dereferencing of cmd->device->host. This patch prepares for
enabling lock context analysis. No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla1280.c | 43 +++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 348c59a99cc5..863b89ac6ba2 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -735,15 +735,15 @@ static void qla1280_mailbox_timeout(struct timer_li=
st *t)
 }
=20
 static int
-_qla1280_wait_for_single_command(struct scsi_qla_host *ha, struct srb *s=
p,
+_qla1280_wait_for_single_command(struct Scsi_Host *host, struct srb *sp,
 				 struct completion *wait)
 {
 	int	status =3D FAILED;
 	struct scsi_cmnd *cmd =3D sp->cmd;
=20
-	spin_unlock_irq(&ha->host->host_lock);
+	spin_unlock_irq(&host->host_lock);
 	wait_for_completion_timeout(wait, 4*HZ);
-	spin_lock_irq(&ha->host->host_lock);
+	spin_lock_irq(&host->host_lock);
 	sp->wait =3D NULL;
 	if(CMD_HANDLE(cmd) =3D=3D COMPLETED_HANDLE) {
 		status =3D SUCCESS;
@@ -753,16 +753,17 @@ _qla1280_wait_for_single_command(struct scsi_qla_ho=
st *ha, struct srb *sp,
 }
=20
 static int
-qla1280_wait_for_single_command(struct scsi_qla_host *ha, struct srb *sp=
)
+qla1280_wait_for_single_command(struct Scsi_Host *host, struct srb *sp)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
=20
 	sp->wait =3D &wait;
-	return _qla1280_wait_for_single_command(ha, sp, &wait);
+	return _qla1280_wait_for_single_command(host, sp, &wait);
 }
=20
 static int
-qla1280_wait_for_pending_commands(struct scsi_qla_host *ha, int bus, int=
 target)
+qla1280_wait_for_pending_commands(struct scsi_qla_host *ha, struct Scsi_=
Host *host,
+				  int bus, int target)
 {
 	int		cnt;
 	int		status;
@@ -785,7 +786,7 @@ qla1280_wait_for_pending_commands(struct scsi_qla_hos=
t *ha, int bus, int target)
 			if (target >=3D 0 && SCSI_TCN_32(cmd) !=3D target)
 				continue;
=20
-			status =3D qla1280_wait_for_single_command(ha, sp);
+			status =3D qla1280_wait_for_single_command(host, sp);
 			if (status =3D=3D FAILED)
 				break;
 		}
@@ -808,7 +809,8 @@ qla1280_wait_for_pending_commands(struct scsi_qla_hos=
t *ha, int bus, int target)
  *
  ***********************************************************************=
***/
 static int
-qla1280_error_action(struct scsi_cmnd *cmd, enum action action)
+qla1280_error_action(struct Scsi_Host *host, struct scsi_cmnd *cmd,
+		     enum action action)
 {
 	struct scsi_qla_host *ha;
 	int bus, target, lun;
@@ -914,7 +916,7 @@ qla1280_error_action(struct scsi_cmnd *cmd, enum acti=
on action)
 	 */
=20
 	if (found >=3D 0)
-		result =3D _qla1280_wait_for_single_command(ha, sp, &wait);
+		result =3D _qla1280_wait_for_single_command(host, sp, &wait);
=20
 	if (action =3D=3D ABORT_COMMAND && result !=3D SUCCESS) {
 		printk(KERN_WARNING
@@ -934,7 +936,7 @@ qla1280_error_action(struct scsi_cmnd *cmd, enum acti=
on action)
 	 * to wait for them.
 	 */
 	if (result =3D=3D SUCCESS && wait_for_bus >=3D 0) {
-		result =3D qla1280_wait_for_pending_commands(ha,
+		result =3D qla1280_wait_for_pending_commands(ha, host,
 					wait_for_bus, wait_for_target);
 	}
=20
@@ -951,11 +953,12 @@ qla1280_error_action(struct scsi_cmnd *cmd, enum ac=
tion action)
 static int
 qla1280_eh_abort(struct scsi_cmnd * cmd)
 {
+	struct Scsi_Host *host =3D cmd->device->host;
 	int rc;
=20
-	spin_lock_irq(&cmd->device->host->host_lock);
-	rc =3D qla1280_error_action(cmd, ABORT_COMMAND);
-	spin_unlock_irq(&cmd->device->host->host_lock);
+	spin_lock_irq(&host->host_lock);
+	rc =3D qla1280_error_action(host, cmd, ABORT_COMMAND);
+	spin_unlock_irq(&host->host_lock);
=20
 	return rc;
 }
@@ -967,11 +970,12 @@ qla1280_eh_abort(struct scsi_cmnd * cmd)
 static int
 qla1280_eh_device_reset(struct scsi_cmnd *cmd)
 {
+	struct Scsi_Host *host =3D cmd->device->host;
 	int rc;
=20
-	spin_lock_irq(&cmd->device->host->host_lock);
-	rc =3D qla1280_error_action(cmd, DEVICE_RESET);
-	spin_unlock_irq(&cmd->device->host->host_lock);
+	spin_lock_irq(&host->host_lock);
+	rc =3D qla1280_error_action(host, cmd, DEVICE_RESET);
+	spin_unlock_irq(&host->host_lock);
=20
 	return rc;
 }
@@ -983,11 +987,12 @@ qla1280_eh_device_reset(struct scsi_cmnd *cmd)
 static int
 qla1280_eh_bus_reset(struct scsi_cmnd *cmd)
 {
+	struct Scsi_Host *host =3D cmd->device->host;
 	int rc;
=20
-	spin_lock_irq(&cmd->device->host->host_lock);
-	rc =3D qla1280_error_action(cmd, BUS_RESET);
-	spin_unlock_irq(&cmd->device->host->host_lock);
+	spin_lock_irq(&host->host_lock);
+	rc =3D qla1280_error_action(host, cmd, BUS_RESET);
+	spin_unlock_irq(&host->host_lock);
=20
 	return rc;
 }
