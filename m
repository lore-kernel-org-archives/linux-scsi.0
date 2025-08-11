Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A9E29BDB1
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 15:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754927303; cv=none; b=Up2xhfIGSy6lI/KXD34NvC94dtq91H1eB1o5zxwtDAKAfHBXaKRHreTNQR3S5792bTTFiPszpFqys0UOketXhgr6tbCD9gUKGMprkt3urOINbl/jiGFZZ0FkPIl+NJY77hCab+zazr9kL9nGCWjcXC1DrTU+iXBVU7bsFcMTbXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754927303; c=relaxed/simple;
	bh=ZK/WWuX28AWbYgyXHumYqFHa7aogZk4ykYWRx6LBZjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxEmfhvDHDbxiIRSdL9d3MFPMjf257//L0SvFCbzS4hIeLdDrA/UvpsduaAi3uIpD/Km8CwRyAT4r85x8MKtv4YwiJdfDDNUknU4TjvNltPTCOls4m+BP5PVn/JAkwddTtEnt9OfNmUoxIiRsXoxgeiAZZJa8RIn68CxT5b5CIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=v28rUmHf; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="v28rUmHf"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c0zYx1GWczlgqV2;
	Mon, 11 Aug 2025 15:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754927299; x=1757519300; bh=I4usz
	R0oaEWC6G0dUhjTaBrrexeHqYnPjhxL7S94liM=; b=v28rUmHfl9DmYDvWWyUuM
	xaABYnxKDzM8JRwGc8CXYLwesNXfhnbVzv8EN32i+E/c35ylnfstIwy7p+ljltub
	9cbaw9bqbcQrMQk41h+hZOe6RJoIyV1sTeVwUiotkL82Gc0saObJgwV4PIGE/R/m
	WcM8Qk/2p/zcGI7RpcN33sxj+pG5cbIaH7Tbaubxq6xizYHQ1OhCt+4UA0Gs7vLS
	+pGoTcavPYlcHhiZVUtNLxUdS7Vk9xv0K8uPVRtugVGLqAgXuPhYumlcnX0GA9rb
	z6H6UemR1VvKwn4iM1qFpJwPH0zjYP8QwoNRw5N902qhaM4oSD1di1XQwijDkeT8
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id m3DDd6IwEJcT; Mon, 11 Aug 2025 15:48:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c0zYl4DFCzlsxFC;
	Mon, 11 Aug 2025 15:48:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 4/4] ufs: core: Rename ufshcd_wait_for_doorbell_clr()
Date: Mon, 11 Aug 2025 08:46:58 -0700
Message-ID: <20250811154711.394297-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
In-Reply-To: <20250811154711.394297-1-bvanassche@acm.org>
References: <20250811154711.394297-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The name ufshcd_wait_for_doorbell_clr() refers to legacy mode. Commit
8d077ede48c1 ("scsi: ufs: Optimize the command queueing code") added
support for MCQ mode in this function. Since then the name of this
function is misleading. Hence change the name of this function into
something that is appropriate for both legacy and MCQ mode.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b5057ce27aa9..1b8e2e68c600 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1303,7 +1303,7 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
  *
  * Return: 0 upon success; -EBUSY upon timeout.
  */
-static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
+static int ufshcd_wait_for_pending_cmds(struct ufs_hba *hba,
 					u64 wait_timeout_us)
 {
 	int ret =3D 0;
@@ -1431,7 +1431,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_=
hba *hba, u64 timeout_us)
 	down_write(&hba->clk_scaling_lock);
=20
 	if (!hba->clk_scaling.is_allowed ||
-	    ufshcd_wait_for_doorbell_clr(hba, timeout_us)) {
+	    ufshcd_wait_for_pending_cmds(hba, timeout_us)) {
 		ret =3D -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->wb_mutex);
