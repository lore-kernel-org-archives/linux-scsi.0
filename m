Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EA8186A
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253378; cv=none; b=D6O6ZYVgitKu3O+5O+S+J4tVVLzfzAUiNnwIyws2thsCgXvkHiMYQAzjoOhxQhQZumFbgzBB+DTErc3tZw3f+aGEa0Ak3liSKOhGAg635/O9OOf1khDmQBldmCrSCRUkmEkQDHN3F+dlBNYPIlvn9JIs0IjP0iLOjnJyk7FOFIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253378; c=relaxed/simple;
	bh=LTdJk8vXhbf9iW5LUmo9VqcMBbD+BsKsEdSmSm5U5s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdaRbvb+0U9aLYXeNIawHHJNWMd99jerP1oh8Gb4ATD0kckdR8rYkFAXFKhVEv8mIcKm7YtExUW2JSAZfsKloCQZ/llj0bEJdg4+K9JvnVXEJDXqR5CM/sG3+UO6Zhs518w+HuNWTRGd4jZkCsFJ/ggqY7VbEkQT/V3snAvjLDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Q0rrfEs8; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Q0rrfEs8"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBPzM1yhGzm174B;
	Wed, 27 Aug 2025 00:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253373; x=1758845374; bh=Lordb
	Aiem8g7t07OhsIABS0Ihm24UmcVn4nnUt4yNMs=; b=Q0rrfEs8qUsrSQy76FWSp
	u7LsVrtzUqd98wKrMHJZnn0518FPanMbqmrb/DiYVE5ORuBdRQD4xAJzM8fxkoBq
	J/7ELdvbYpgCvbARmAQpm5yGjKLaxnxuPrWSqxGTmpcuHbBuGgg2vrIzNiM2wn4n
	U8McUt2dVG5S7lqr/cwmW85ri9VoHTJHicgEKlg5jzkIrL1aHwd60H0FESv/RLDs
	pNI4j0MsikjABlrdLvp/6YK8ZA1vuZOk9d6SGHXUFrwCo07T0mM85CWVnMHT90nV
	1PIA9yhv6X8kuj7/ECjnUzGJEBScmCCEWfX2eBqNexdqWDGowFgtZQ83/ozQbnyd
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id knSLaubXSrUw; Wed, 27 Aug 2025 00:09:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBPzB6680zm0ysy;
	Wed, 27 Aug 2025 00:09:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 08/26] ufs: core: Change the type of one ufshcd_add_cmd_upiu_trace() argument
Date: Tue, 26 Aug 2025 17:06:12 -0700
Message-ID: <20250827000816.2370150-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
In-Reply-To: <20250827000816.2370150-1-bvanassche@acm.org>
References: <20250827000816.2370150-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Change the 'tag' argument into an LRB pointer. This patch prepares for th=
e
removal of the hba->lrb[] array.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ca6a0f8ccbea..0c12165c7644 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -405,10 +405,11 @@ static void ufshcd_configure_wb(struct ufs_hba *hba=
)
 		ufshcd_wb_toggle_buf_flush(hba, true);
 }
=20
-static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int =
tag,
+static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba,
+				      struct ufshcd_lrb *lrb,
 				      enum ufs_trace_str_t str_t)
 {
-	struct utp_upiu_req *rq =3D hba->lrb[tag].ucd_req_ptr;
+	struct utp_upiu_req *rq =3D lrb->ucd_req_ptr;
 	struct utp_upiu_header *header;
=20
 	if (!trace_ufshcd_upiu_enabled())
@@ -417,7 +418,7 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba =
*hba, unsigned int tag,
 	if (str_t =3D=3D UFS_CMD_SEND)
 		header =3D &rq->header;
 	else
-		header =3D &hba->lrb[tag].ucd_rsp_ptr->header;
+		header =3D &lrb->ucd_rsp_ptr->header;
=20
 	trace_ufshcd_upiu(hba, str_t, header, &rq->sc.cdb,
 			  UFS_TSF_CDB);
@@ -491,7 +492,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba, unsigned int tag,
 		return;
=20
 	/* trace UPIU also */
-	ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
+	ufshcd_add_cmd_upiu_trace(hba, lrbp, str_t);
 	if (!trace_ufshcd_command_enabled())
 		return;
=20
