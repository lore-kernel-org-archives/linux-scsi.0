Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0BF2E7BB5
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 22:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760479425; cv=none; b=AYF5W/tdau0hDQ8QtCb/9Ec4D3FY2RJh1Cr1ujZje9wbEe3xhsUfKva0GLen4tjv+0NJfONyZqMvSGE4a5NJc8CspSpqMdEOaxtOrWqKdwX2Cqb5AZGSMeoUSKLvugYrrCtOJG4Shlo4EFcdA+VOOeqRwGGZQnsfXcYtI0ttBJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760479425; c=relaxed/simple;
	bh=1ko58ibZrqSkCh2PGuV8bBcAxjbYJLPjnkisnweKPIs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VVmbCVr53oyzWZyVENlpCE+E1QNQVkQYGnTmfeg/VJtbizv8Ht63mn0UhcSdYF3faaI6+2jisn0yunYH7TbX7UFuevzmYmhcbxgRQrVBymO9f4+huPYoywIt81DcPPA8OoBbowC4dx906MHo109v+GvbhdoEOsxCX4SFQ1vWzsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iZCptinR; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iZCptinR"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cmSsT6zpQzlgrtN;
	Tue, 14 Oct 2025 22:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1760479420; x=1763071421; bh=+c5UrM1L8UO27WmDKMC8pjFZX7UyCO4TMtc
	jQZ812Zg=; b=iZCptinRQ34gKITT2eHrfKhyGRxT/orK3V5HaGNNPbPyQ56Bq21
	IGnwxO4B/X8dlrVCP78uprVPOHUkq8Ad5GTIDl+fRyF/taq4hrexxe6iDdX2oauM
	dhX4NHkWOPFz9HnyUUr91sLsDJYMo1EnKL0DWY447kmb6CiuiLCmqB0Biz9neGSx
	WwNewid6AAIKufBJ2z+bOhuFCRFaMClmfEj7Q/10xEASt1gaCaFiD2Cj93lImbfy
	Wh4ER0T6+NsFvpStsh3zt170EwcImnIL+vjaUEclANr9eaOrDOW/NNFjrTAQJH9b
	oUcEzeaTymNRQa0EHhSJ2h3HTvyL2Dgufcg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ea-PnPAG49BM; Tue, 14 Oct 2025 22:03:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cmSsG5GbbzlgqW1;
	Tue, 14 Oct 2025 22:03:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Gilbert Wu <gilbert.wu@microchip.com>,
	Sagar Biradar <Sagar.Biradar@microchip.com>,
	John Garry <john.g.garry@oracle.com>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] aacraid: Fail commands that are not submitted
Date: Tue, 14 Oct 2025 15:03:22 -0700
Message-ID: <20251014220323.3689699-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

aac_queuecommand() is a scsi_host_template.queuecommand() implementation
and hence must return one of the following values:
* 0
* SCSI_MLQUEUE_HOST_BUSY
* SCSI_MLQUEUE_DEVICE_BUSY
* SCSI_MLQUEUE_EH_RETRY
* SCSI_MLQUEUE_TARGET_BUSY

Hence, instead of returning FAILED, set cmd->result, call scsi_done()
and return 0.

Cc: Gilbert Wu <gilbert.wu@microchip.com>
Cc: Sagar Biradar <Sagar.Biradar@microchip.com>
Cc: John Garry <john.g.garry@oracle.com>
Fixes: 03f295368bcd ("[PATCH] aacraid driver for 2.5")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aacraid/linit.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index ea66196ef7c7..01156d1a1d06 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -242,7 +242,11 @@ static int aac_queuecommand(struct Scsi_Host *shost,
 {
 	aac_priv(cmd)->owner =3D AAC_OWNER_LOWLEVEL;
=20
-	return aac_scsi_cmd(cmd) ? FAILED : 0;
+	if (WARN_ON_ONCE(aac_scsi_cmd(cmd))) {
+		cmd->result =3D DID_ERROR << 16;
+		scsi_done(cmd);
+	}
+	return 0;
 }
=20
 /**
