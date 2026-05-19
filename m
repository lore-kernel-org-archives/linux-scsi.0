Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094C53E7171
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 21:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779225723; cv=none; b=InjzPaVvDZBjExYo9u+GnnyniBUyX9zwJyxB2VPeOO0Y9+mCBuKGe9nd8zi8InnwZfKo72Xjc5bTFqCCaZcu26uHIWB9ACeNF2h/Jsfdz10xDDEfdiHPPo+yQfisvEJvpt6viXdMtjwUBuJA9Y9GXh/224MuDBMlfQ12iqG9gLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779225723; c=relaxed/simple;
	bh=qtHpo6zow6uL5BwxKfR4Vd7xBY9DRrFM5zr5o9b7lUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVxrbJGHzKqE0BUw2d++koSC0Eq1CeV7JJTmhAbZ/xnYJ65a62kIRSlYFEwelFfrtgDt0WEKVroDz3buScJioJsEm0psIWLsffMmzB9nN1iKTWfMdnMJIZQjRMfVn4g7iEt2n9Oc7Dgo5/E1Yf2RcdiQ+ul4BMsS7cacR0qKiy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=O1LCe5+Y; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="O1LCe5+Y"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gKngF4GD6zlgtd3;
	Tue, 19 May 2026 21:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1779225716; x=1781817717; bh=igMEK
	1pUq4UtzqCQRc/4V/RRTNQAk8LmIr0mBe3bff4=; b=O1LCe5+YXKa9XBvoe15vh
	TR18blM3EDNar+bEM8uleBv6lPq4nxHjZbM1tZvq5MFvEt3GomwR07gJpfmgb+U8
	5JXS11kv6KxOLoau+EaqM47UEVrMK35vrkMogdCcmj6ZvouPnjPYVGYfEwnxjCaN
	mp0GBkl/0cQZQ9MAyIg+1NL9uTXR6gEM6oNuJkOF7kwoLnqc6EHMJojNU+4rWLiS
	49utz4kcbhxrwebB8o0taQeiOZqZYMNCAQVFxQ9uj7JeYGGJsre8b+5h/9IUm0RI
	ZM2WrEb4mYp8Joya8lLTIE9QSNsFfS84aAX+uBEoojRT4OSt5p8oWG26ms7RbHF2
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id y1a3h9yliRMR; Tue, 19 May 2026 21:21:56 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gKng567Qlzlgtd1;
	Tue, 19 May 2026 21:21:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 2/3] ufs: core: Complain if UIC argument 2 is invalid
Date: Tue, 19 May 2026 14:21:28 -0700
Message-ID: <20260519212135.3130556-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
In-Reply-To: <20260519212135.3130556-1-bvanassche@acm.org>
References: <20260519212135.3130556-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

According to the UFSHCI standard, the lowest byte of UIC argument 2 is
an output value. Additionally, ufshcd_uic_cmd_compl() is based on the
assumption that the lowest byte of UIC argument 2 is zero. Hence, complai=
n
if the result byte is set when a UIC command is submitted.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f3e226e47c90..cfb362fe9784 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2571,6 +2571,7 @@ ufshcd_dispatch_uic_cmd(struct ufs_hba *hba, struct=
 uic_command *uic_cmd)
 	lockdep_assert_held(&hba->uic_cmd_mutex);
=20
 	WARN_ON(hba->active_uic_cmd);
+	WARN_ON_ONCE(uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT);
=20
 	hba->active_uic_cmd =3D uic_cmd;
=20
