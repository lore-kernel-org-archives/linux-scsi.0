Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82A018C356
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 21:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718658555; cv=none; b=YKTgK7Y+wFNUztzqnjfCJ/ss7SK79kC6EC7IKlacj10IeM/rTZ1tHLWP5L71Wb10K2NtVHBDIGOAnKOhiW5aNKFOYBJ3rORjHxKhEQbgm3H5yXFafzfBTjK9N3D6MWfEp7mzgqFxkwze+IC2JWWeCMEvUiKp202d7VyzGsiZd/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718658555; c=relaxed/simple;
	bh=Pk3GJOJuxOgURl4t/SO0NgSE96MeDjhPEiDrcL+vO10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9c+lwwQnJEApyAjfD9ksZPluZdDnUEFS0popTf5FEYQ+So+9jTTMtB5x2YO5VcMcfSTTgJmbrIEczyvM65Y2AKYh9llQunQpCmG1I2aAIXgoEPPLv009G6syzS+uAmTubr/lZYY1JVqVJURl+ZaRXDpg6D6Gmf7Bg4LATw3Tgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uB47GrGw; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uB47GrGw"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W32Z10Vk8z6Cnk97;
	Mon, 17 Jun 2024 21:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1718658543; x=1721250544; bh=OX6TY
	b0TjAZL0FNYAuGZMbCIBiopSlAzEZPpkNHBnMs=; b=uB47GrGwzoLbn0X39Gk10
	wF9XjN0aWYF2JclFB/7CXyHXn/ahZT8io1mOWgjytHqgn70xskuKqM4dtEk27s1/
	2qZMZq7/1iZAJz8TJP/6tN+9CNWPMdIz70seLyVzEPwLybG2Y4hBapPgN5owXw1J
	6vcsLvMlX7vV+5LPxsCLbsqzYhdWgzLxBqIp3MclLwnGh/+G57gBxwGLtXCW7o5A
	vCL6aDaSgKgHrrwp3P574wViIx2U8m+F2qadtLG9EBs5x/8t7i9SI4hi/6ETO4eG
	1IkezhXIJYApzsoZPQEmXJyTywke6k4EIvf6Q/1wiiUkmypjRBNInMm+Lu+dJndn
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wRCJ87rr4-aN; Mon, 17 Jun 2024 21:09:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W32Yp5qdKz6Cnk95;
	Mon, 17 Jun 2024 21:09:02 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/8] scsi: ufs: Initialize struct uic_command once
Date: Mon, 17 Jun 2024 14:07:40 -0700
Message-ID: <20240617210844.337476-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
In-Reply-To: <20240617210844.337476-1-bvanassche@acm.org>
References: <20240617210844.337476-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Instead of first zero-initializing struct uic_command and next initializi=
ng
it memberwise, initialize all members at once.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 62 ++++++++++++++++++++-------------------
 include/ufs/ufshcd.h      |  4 +--
 2 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 41bf2e249c83..5d784876513e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3993,11 +3993,11 @@ static void ufshcd_host_memory_configure(struct u=
fs_hba *hba)
  */
 static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 {
-	struct uic_command uic_cmd =3D {0};
+	struct uic_command uic_cmd =3D {
+		.command =3D UIC_CMD_DME_LINK_STARTUP,
+	};
 	int ret;
=20
-	uic_cmd.command =3D UIC_CMD_DME_LINK_STARTUP;
-
 	ret =3D ufshcd_send_uic_cmd(hba, &uic_cmd);
 	if (ret)
 		dev_dbg(hba->dev,
@@ -4015,11 +4015,11 @@ static int ufshcd_dme_link_startup(struct ufs_hba=
 *hba)
  */
 static int ufshcd_dme_reset(struct ufs_hba *hba)
 {
-	struct uic_command uic_cmd =3D {0};
+	struct uic_command uic_cmd =3D {
+		.command =3D UIC_CMD_DME_RESET,
+	};
 	int ret;
=20
-	uic_cmd.command =3D UIC_CMD_DME_RESET;
-
 	ret =3D ufshcd_send_uic_cmd(hba, &uic_cmd);
 	if (ret)
 		dev_err(hba->dev,
@@ -4054,11 +4054,11 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_configure_adapt);
  */
 static int ufshcd_dme_enable(struct ufs_hba *hba)
 {
-	struct uic_command uic_cmd =3D {0};
+	struct uic_command uic_cmd =3D {
+		.command =3D UIC_CMD_DME_ENABLE,
+	};
 	int ret;
=20
-	uic_cmd.command =3D UIC_CMD_DME_ENABLE;
-
 	ret =3D ufshcd_send_uic_cmd(hba, &uic_cmd);
 	if (ret)
 		dev_err(hba->dev,
@@ -4111,7 +4111,12 @@ static inline void ufshcd_add_delay_before_dme_cmd=
(struct ufs_hba *hba)
 int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 			u8 attr_set, u32 mib_val, u8 peer)
 {
-	struct uic_command uic_cmd =3D {0};
+	struct uic_command uic_cmd =3D {
+		.command =3D peer ? UIC_CMD_DME_PEER_SET : UIC_CMD_DME_SET,
+		.argument1 =3D attr_sel,
+		.argument2 =3D UIC_ARG_ATTR_TYPE(attr_set),
+		.argument3 =3D mib_val,
+	};
 	static const char *const action[] =3D {
 		"dme-set",
 		"dme-peer-set"
@@ -4120,12 +4125,6 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 a=
ttr_sel,
 	int ret;
 	int retries =3D UFS_UIC_COMMAND_RETRIES;
=20
-	uic_cmd.command =3D peer ?
-		UIC_CMD_DME_PEER_SET : UIC_CMD_DME_SET;
-	uic_cmd.argument1 =3D attr_sel;
-	uic_cmd.argument2 =3D UIC_ARG_ATTR_TYPE(attr_set);
-	uic_cmd.argument3 =3D mib_val;
-
 	do {
 		/* for peer attributes we retry upon failure */
 		ret =3D ufshcd_send_uic_cmd(hba, &uic_cmd);
@@ -4155,7 +4154,11 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_set_attr);
 int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			u32 *mib_val, u8 peer)
 {
-	struct uic_command uic_cmd =3D {0};
+	struct uic_command uic_cmd =3D {
+		.command =3D peer ? UIC_CMD_DME_PEER_GET : UIC_CMD_DME_GET,
+		.argument1 =3D attr_sel,
+
+	};
 	static const char *const action[] =3D {
 		"dme-get",
 		"dme-peer-get"
@@ -4189,10 +4192,6 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 a=
ttr_sel,
 		}
 	}
=20
-	uic_cmd.command =3D peer ?
-		UIC_CMD_DME_PEER_GET : UIC_CMD_DME_GET;
-	uic_cmd.argument1 =3D attr_sel;
-
 	do {
 		/* for peer attributes we retry upon failure */
 		ret =3D ufshcd_send_uic_cmd(hba, &uic_cmd);
@@ -4325,7 +4324,11 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba=
, struct uic_command *cmd)
  */
 int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 {
-	struct uic_command uic_cmd =3D {0};
+	struct uic_command uic_cmd =3D {
+		.command =3D UIC_CMD_DME_SET,
+		.argument1 =3D UIC_ARG_MIB(PA_PWRMODE),
+		.argument3 =3D mode,
+	};
 	int ret;
=20
 	if (hba->quirks & UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP) {
@@ -4338,9 +4341,6 @@ int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba,=
 u8 mode)
 		}
 	}
=20
-	uic_cmd.command =3D UIC_CMD_DME_SET;
-	uic_cmd.argument1 =3D UIC_ARG_MIB(PA_PWRMODE);
-	uic_cmd.argument3 =3D mode;
 	ufshcd_hold(hba);
 	ret =3D ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 	ufshcd_release(hba);
@@ -4381,13 +4381,14 @@ EXPORT_SYMBOL_GPL(ufshcd_link_recovery);
=20
 int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 {
-	int ret;
-	struct uic_command uic_cmd =3D {0};
+	struct uic_command uic_cmd =3D {
+		.command =3D UIC_CMD_DME_HIBER_ENTER,
+	};
 	ktime_t start =3D ktime_get();
+	int ret;
=20
 	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER, PRE_CHANGE);
=20
-	uic_cmd.command =3D UIC_CMD_DME_HIBER_ENTER;
 	ret =3D ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 	trace_ufshcd_profile_hibern8(dev_name(hba->dev), "enter",
 			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);
@@ -4405,13 +4406,14 @@ EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_enter);
=20
 int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 {
-	struct uic_command uic_cmd =3D {0};
+	struct uic_command uic_cmd =3D {
+		.command =3D UIC_CMD_DME_HIBER_EXIT,
+	};
 	int ret;
 	ktime_t start =3D ktime_get();
=20
 	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT, PRE_CHANGE);
=20
-	uic_cmd.command =3D UIC_CMD_DME_HIBER_EXIT;
 	ret =3D ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 	trace_ufshcd_profile_hibern8(dev_name(hba->dev), "exit",
 			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 9e0581115b34..d4d63507d090 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -73,8 +73,8 @@ enum ufs_event_type {
  * @done: UIC command completion
  */
 struct uic_command {
-	u32 command;
-	u32 argument1;
+	const u32 command;
+	const u32 argument1;
 	u32 argument2;
 	u32 argument3;
 	int cmd_active;
