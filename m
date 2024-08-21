Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DD21B5316
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 18:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724264997; cv=none; b=nXrVEa/6M3v8Cxcuf3R6cxk2HL+p6XX1QqAioEKUb3vvNP+kfWnWoe/10VTKsyEHCT29Yur0QzLSVjaIbmHrezjOfLLmOtlLrljS8moCizA1dgo7zWlJXkDvVnHW0AoxcyJVLRp6f0yCjjoxqbimtykO9vycohl/V5OAjqQpEyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724264997; c=relaxed/simple;
	bh=Ly01gvTQefvW0c4Zq9vtvboi2xU89fC7uF3nJS6e/J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3ERRi262kGQRzLo520IsRtaI5AaHvMdAvm0ykEHUMI1vBSbycW5rILmLQXS/iFLg4uSeVCRUItpjgPXwSKbwWAAYCdDZ0XyLpDkUUjRpeuZEvCiw6mMTmvi+KKs4Z/F7V8kDBW1fwiYBJ0xMNUJyqc2GhuBpz6e/e+ydyEKjso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=frtTMOZO; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="frtTMOZO"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WpvyB5ptczlgVnW;
	Wed, 21 Aug 2024 18:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724264988; x=1726856989; bh=VLWel
	JPkXRYAZqH2AuK3gqaITkcqffs7rIkYNzpuJJE=; b=frtTMOZO5gzqMd1Z+5Vtq
	MLRYgiURgmkjqD+zvUQum99YuDy4Eduvuy4dgG4Sw6ZVbjiNwlTbbKyJOfvOsnDf
	oAoDh4YlTVOmxYXrORTi21luERdQoUhkd/6oYfpYbqzqzJoufuodhwVX4v7JVqov
	AE5736evxWKnuGMIP+/RsQAal/xr6xj+2zB13YjLR9S0yLAfAaLkLXviB4lGboN2
	rMVhe8t9c2IJb358XCY3jl9wryn2f88guauiesFWTobbjGuz0NsaVKT/XTMxtFht
	6Wpfioc+wIZ9hpZuJs+4dUGMdZxWM6OGud/zdViiXrBTOe+bo+CCx81r3uYB3wLX
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rsV77cCwhFtL; Wed, 21 Aug 2024 18:29:48 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wpvy31SpLzlgVnF;
	Wed, 21 Aug 2024 18:29:47 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Eric Biggers <ebiggers@google.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH 2/2] scsi: ufs: core: Fix the code for entering hibernation
Date: Wed, 21 Aug 2024 11:29:12 -0700
Message-ID: <20240821182923.145631-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240821182923.145631-1-bvanassche@acm.org>
References: <20240821182923.145631-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Accessing a host controller register after the host controller has
entered the hibernation state may cause the host controller to exit the
hibernation state. Hence rework the hibernation entry code such that it
does not modify the interrupt enabled status. This patch relies on the
following:
* If an UIC command is submitted that should be completed by the UIC
  command completion interrupt, hba->uic_async_done =3D=3D NULL.
* If an UIC command is submitted that should be completed by the power
  mode change interrupt or by a hibernation state change interrupt,
  hba->uic_async_done !=3D NULL.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 22 ++++++----------------
 include/ufs/ufshcd.h      |  7 ++++---
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d0ae6e50becc..e12f30b8a83c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2585,6 +2585,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct=
 uic_command *uic_cmd)
 	ufshcd_hold(hba);
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
+	WARN_ON(hba->uic_async_done);
=20
 	ret =3D __ufshcd_send_uic_cmd(hba, uic_cmd, true);
 	if (!ret)
@@ -4255,7 +4256,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba,=
 struct uic_command *cmd)
 	unsigned long flags;
 	u8 status;
 	int ret;
-	bool reenable_intr =3D false;
=20
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
@@ -4266,15 +4266,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba=
, struct uic_command *cmd)
 		goto out_unlock;
 	}
 	hba->uic_async_done =3D &uic_async_done;
-	if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
-		ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
-		/*
-		 * Make sure UIC command completion interrupt is disabled before
-		 * issuing UIC command.
-		 */
-		ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
-		reenable_intr =3D true;
-	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ret =3D __ufshcd_send_uic_cmd(hba, cmd, false);
 	if (ret) {
@@ -4318,8 +4309,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba,=
 struct uic_command *cmd)
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->active_uic_cmd =3D NULL;
 	hba->uic_async_done =3D NULL;
-	if (reenable_intr)
-		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
 	if (ret) {
 		ufshcd_set_link_broken(hba);
 		ufshcd_schedule_eh_work(hba);
@@ -5472,11 +5461,12 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct uf=
s_hba *hba, u32 intr_status)
 		hba->errors |=3D (UFSHCD_UIC_HIBERN8_MASK & intr_status);
=20
 	if (intr_status & UIC_COMMAND_COMPL && cmd) {
-		cmd->argument2 |=3D ufshcd_get_uic_cmd_result(hba);
-		cmd->argument3 =3D ufshcd_get_dme_attr_val(hba);
-		if (!hba->uic_async_done)
+		if (!hba->uic_async_done) {
+			cmd->argument2 |=3D ufshcd_get_uic_cmd_result(hba);
+			cmd->argument3 =3D ufshcd_get_dme_attr_val(hba);
 			cmd->cmd_active =3D 0;
-		complete(&cmd->done);
+			complete(&cmd->done);
+		}
 		retval =3D IRQ_HANDLED;
 	}
=20
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a43b14276bc3..0577013a4611 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -868,9 +868,10 @@ enum ufshcd_mcq_opr {
  * @tmf_tag_set: TMF tag set.
  * @tmf_queue: Used to allocate TMF tags.
  * @tmf_rqs: array with pointers to TMF requests while these are in prog=
ress.
- * @active_uic_cmd: handle of active UIC command
- * @uic_cmd_mutex: mutex for UIC command
- * @uic_async_done: completion used during UIC processing
+ * @active_uic_cmd: active UIC command pointer.
+ * @uic_cmd_mutex: mutex used to serialize UIC command processing.
+ * @uic_async_done: completion used to wait for power mode or hibernatio=
n state
+ *	changes.
  * @ufshcd_state: UFSHCD state
  * @eh_flags: Error handling flags
  * @intr_mask: Interrupt Mask Bits
