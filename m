Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36E27F
	for <linux-scsi@vger.kernel.org>; Wed, 10 Apr 2024 00:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712707691; cv=none; b=XYWkiLoZG9g8j8CDLUXNhNWcAXjYW3ZCvl3F/jNL1unhE3JAirJfWccF5Wx4qEIWqxOTbs6cG1voAucL1PIqWCWVmTmWvuMIhjuZbCSX4eCscHeE0EE60kTXTVh2bw7+CO/CZbEx3mmwRf7RDZSDzQ85oKG4o/8l/YIPQHEKk3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712707691; c=relaxed/simple;
	bh=7Xz5KKaHT1zxtkk/RrV0RsSEHN+gbOnLBhPOZGnN4KM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qEjqiDJMpY6hzh/PzhSJH4BixrisgbEYvAqZ3Gl3s97Ok0mFqydMCMuyGxHn6XsnJAYwERGT6nfnNhWnxUttBPiJBVm5jfUZsObfRWEPNI0S9NEFHPw2GfFbFce99krrFKQ87CTZ4Z4wKnIkfOVmrMo+Ec8SR3Z3lhnDfUfavgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=szX8R/Ha; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="szX8R/Ha"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VDjpJ1zwrz6Cnk8s;
	Wed, 10 Apr 2024 00:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1712707682; x=1715299683; bh=CTHJ1z5TufKah2byQ0ZzloAyxvw6bkwN7/r
	8XYKyMYU=; b=szX8R/HaqXPWly2sWBBOlMZn37LAoSTybcmJ5IG66xkp1Tn8VTo
	zrBzE/8Z1iCHpOIBqCaaY2Wl9fqBw+2GUSb5rHqFVxDAjTCXVtwMlPz9M/YWS8OP
	IQw21gSUhERV9ZYpoE/Rfe/5XHDhAoaktz62Ql3j+6Hutu/T+sV3/zjpOcboucYl
	nbjZtRxjS2cKR7KoDO3JyUTc9/GfasNGejPixczwpGYCmJzG8NSOIxeOK8pvIo1i
	Ci+LCOAlSQ6PxZuHhDvxRVR+PIeAz+x05B7p9O8jhPer+l5ghoopO7rv2SBsy7bc
	Zje89aIvm3/s+X3mvofC4Hz8TnVQTg+1ivw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EsU3YOEUgY94; Wed, 10 Apr 2024 00:08:02 +0000 (UTC)
Received: from bvanassche-glaptop2.roam.corp.google.com (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VDjp71CtHz6Cnk8m;
	Wed, 10 Apr 2024 00:07:58 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
	Stanley Chu <stanley.chu@mediatek.com>,
	Can Guo <quic_cang@quicinc.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Po-Wen Kao <powen.kao@mediatek.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] scsi/ufs: Fix ufshcd_mcq_sqe_search()
Date: Tue,  9 Apr 2024 17:07:45 -0700
Message-ID: <20240410000751.1047758-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Fix the calculation of the utrd pointer. This patch addresses the followi=
ng
Coverity complaint:

CID 1538170: (#1 of 1): Extra sizeof expression (SIZEOF_MISMATCH)
suspicious_pointer_arithmetic: Adding sq_head_slot * 32UL /* sizeof (stru=
ct
utp_transfer_req_desc) */ to pointer hwq->sqe_base_addr of type struct
utp_transfer_req_desc * is suspicious because adding an integral value to
this pointer automatically scales that value by the size, 32 bytes, of th=
e
pointed-to type, struct utp_transfer_req_desc. Most likely, the
multiplication by sizeof (struct utp_transfer_req_desc) in this expressio=
n
is extraneous and should be eliminated.

Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <quic_cang@quicinc.com>
Fixes: 8d7290348992 ("scsi: ufs: mcq: Add supporting functions for MCQ ab=
ort")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 768bf87cd80d..005d63ab1f44 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -601,8 +601,7 @@ static bool ufshcd_mcq_sqe_search(struct ufs_hba *hba=
,
 	addr =3D le64_to_cpu(cmd_desc_base_addr) & CQE_UCD_BA;
=20
 	while (sq_head_slot !=3D hwq->sq_tail_slot) {
-		utrd =3D hwq->sqe_base_addr +
-				sq_head_slot * sizeof(struct utp_transfer_req_desc);
+		utrd =3D hwq->sqe_base_addr + sq_head_slot;
 		match =3D le64_to_cpu(utrd->command_desc_base_addr) & CQE_UCD_BA;
 		if (addr =3D=3D match) {
 			ufshcd_mcq_nullify_sqe(utrd);
