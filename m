Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702083F9FB
	for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2025 20:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077889; cv=none; b=Y49b6ZBYyf993pWbPy6Jp/DilGezYOFpB37hOFEbt7sIrNGK9avze2su1ZpCLgh0gsJkRguj+AF6XJFehQFOv1LjbIpIcOnElxrP5MSnjhWJama6nUTXLO4pm75TmTFxlz7X+EiR70E3ij3dmA2bn724gJxal/z75aeWgxLfUEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077889; c=relaxed/simple;
	bh=+S+7Xhn4n3V4H4wBAVh2T3HBXfZGzySADlL4386kaJw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hEWw2jFljMIejuxlskpprAtmfMTsb4xalcW/jcectY1qb9lJDqoJu2ioareBtTrbgtS103sE2vEkJjkeYNY6m/BGRgVuAmul8VKLb6x1UT2yTEqsWz498Th/P7m9JuCrhTUuLuFk8xq7JFAOljkK6vhEyGZoS0yfENoV10MiMZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=GmN+HUTK; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="GmN+HUTK"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4crkBJ2QcBzlrxs1;
	Tue, 21 Oct 2025 20:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1761077878; x=1763669879; bh=pOl66CY9sW+kpIvfJ5VIwmzb1Ziz1xo07zj
	Zp5LNJG8=; b=GmN+HUTKr9wkM34flJWtU3QpeGQjUzFM93xr6r7qqdiX+Q6790b
	3e1wzG6ZgUi+JOyKomTaQ+5hXJe+x/z2Uhj53zQJhmONAtFG1pM8GfYW6xcDz6P3
	46KFpg47Z7X1hvfSaPLJITnqAznz8oVkJ14+PNr7c4KKxLazq+IZ8DMLVNEpucHj
	Sv8Yrxts187sWAdH9U6qRqbdi4+BpHzqrAIsLJoUj0Fz+8s8KgZATqoFgbPavzvo
	8asEgExDQRIhC6OPbW7jvSG5A2jqfRvMlm9NzIUyu4Mr1oaCETTuMywySRDjDSCH
	GCiHbrEXKnbxtN7l0/RuArwbSxbTMjCQXLw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NtNnA3OMjgar; Tue, 21 Oct 2025 20:17:58 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4crkB92SVTzlgqVl;
	Tue, 21 Oct 2025 20:17:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Gilbert Wu <gilbert.wu@microchip.com>,
	Sagar Biradar <Sagar.Biradar@microchip.com>,
	John Garry <john.g.garry@oracle.com>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2] scsi: aacraid: Improve code readability
Date: Tue, 21 Oct 2025 13:17:43 -0700
Message-ID: <20251021201743.3539900-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

aac_queuecommand() is a scsi_host_template.queuecommand() implementation.
Any value returned by this function other than one of the following value=
s
is translated into SCSI_MLQUEUE_HOST_BUSY:
* 0
* SCSI_MLQUEUE_HOST_BUSY
* SCSI_MLQUEUE_DEVICE_BUSY
* SCSI_MLQUEUE_EH_RETRY
* SCSI_MLQUEUE_TARGET_BUSY

Improve readability of aac_queuecommand() by returning
SCSI_MLQUEUE_HOST_BUSY instead of FAILED.

Cc: Gilbert Wu <gilbert.wu@microchip.com>
Cc: Sagar Biradar <Sagar.Biradar@microchip.com>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v1: instead of failing a SCSI command if aac_scsi_cmd=
()
  returns a value that is not zero, let the SCSI core retry the command.

 drivers/scsi/aacraid/linit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index ea66196ef7c7..82c6e7c7cdaf 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -242,7 +242,7 @@ static int aac_queuecommand(struct Scsi_Host *shost,
 {
 	aac_priv(cmd)->owner =3D AAC_OWNER_LOWLEVEL;
=20
-	return aac_scsi_cmd(cmd) ? FAILED : 0;
+	return aac_scsi_cmd(cmd) ? SCSI_MLQUEUE_HOST_BUSY : 0;
 }
=20
 /**
