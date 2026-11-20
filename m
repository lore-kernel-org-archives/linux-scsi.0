Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795135766;
	b=T4iqzRWZsw8fqKUy0YTpsP6iHuepvnmsIRaoxmQhwepWO+n9NSDD3LiKI36l6GOT05Oq
	 vejpcYBHqui88UoW9vnjeXLuRWnB7LYAwh2BwyUF0mP2DhdNKTogXA09D+wxFQWAL71Sk
	 N/CpYiaq/RYx+HwuLD9mP/Hcmd3TZUbDDF5fL2+W5atxgR78CL6P0akTbBgynuUSjjuGT
	 Uodya+vEK70gigg1+rPyCOJiNYBVEOkbDV+F7jYh8LaYlaZy1F+5bsbzHO2seQSqD0b94
	 3TaOSLTcI/K3JOo/T/7ndAPo8GIMesYHeC4AIvHGqReLr/DDcuqveon31nAUxwq+FCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795135766;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fIkwRS7bNzJ0acg9nRG+ZM7NIGE3HdrTyXU9vhoFPmU=;
	b=24S8su+bZfCwMkToFx9x+7QUXRUKAEoqWf/k8sVwSZHjPejrKA4yzFEzEzUH1sOSjcom
	 orR42O6yY0TQ8HTdNo/iKUrl5701xHReFYrQfNtExy0TH+MVzLiJgp80qo2tlfHPma0UI
	 9sCc1OAACTiArRR963HH5UafCO8S98tnTFKZruCcAS3xwMWJXVh/cFMR7jum9RgteArSr
	 eAoVE99RHOwqovCXMeCnslJZ/ubVN18faXu6b9u1UDFFtUB2gPGby5fRfSg3iahRmHpMk
	 A04Bgv0NAIETjl2GCSoyUzGEfD/ZUaocloQgH+6Ci3jeiAqtPXGBCiloW7XRTORdN+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=HyG6Y3vW;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEAD606A320
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 00:49:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACEAD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=HyG6Y3vW
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jVxYd0wvpz1XM6J6;
	Fri, 20 Nov 2026 00:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1795135760; x=1797727761; bh=fIkwRS7bNzJ0acg9nRG+ZM7NIGE3HdrTyXU
	9vhoFPmU=; b=HyG6Y3vWpmhR91PPG7troH/VrjSBFMy27u1MXMLytlvg5jsa17q
	VzE7IrtuFABYgzYLEOhCFJqvrNNePGpZqApPzrJfjmFrbKJswpLYz4mQRgjZ5bzP
	LHjGsUIknVJF+mDTfusvoTEA/wOZaisjXMzIxw/gzg8l/zRzzn/Kmi0ufY/bagPI
	acApN6owmg3v6XpgUGbbridEVmdKTUxOkv5A8Z51u6MVCa280So4cDdGaTepia2m
	sb3e0+/QRrW+I/E1U003I4GoUWSHswFidDJvaHE3i4+xcAwJNxiqiFzMzq5N53ci
	9DhoyFHx8ZIUTmZJTQ8LmmWtDo7owxruZKQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id O4D7UU4yZOVT; Fri, 20 Nov 2026 00:49:20 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (57.237.82.34.bc.googleusercontent.com [34.82.237.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jVxYX2JN2z1XM30h;
	Fri, 20 Nov 2026 00:49:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	kernel test robot <lkp@intel.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Chaotian Jing <chaotian.jing@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH] ufs: mediatek: Use ARRAY_SIZE() instead of open-coding it
Date: Thu, 19 Nov 2026 16:49:11 -0800
Message-ID: <547675c30e66d7664c0adec81f025986ab6ddfce.1795135740.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The kernel test robot reported the following Coccinelle warning:

drivers/ufs/host/ufs-mediatek.c:1351:32-33: WARNING: Use ARRAY_SIZE

Derive array bounds from the arrays themselves such that these bounds
remain correct if array elements are added or removed.

In ufs_mtk_adjust_sync_length(), replace the open-coded
sizeof(pa_min_sync_length) / sizeof(struct attr_min) computation with
ARRAY_SIZE(pa_min_sync_length) and remove the local variable 'cnt' since
it is no longer needed. This fixes the reported warning.

Additionally, in ufs_mtk_setup_clk_gating(), replace the hard-coded
upper bound in the range check on the scale_us[] index by
ARRAY_SIZE(scale_us). This has not been reported by the kernel test
robot. Since scale_us[] has six elements, 'ah_scale <=3D 5' is equivalent
to 'ah_scale < ARRAY_SIZE(scale_us)'.

No functionality has been changed.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202611170300.dsQhfOB9-lkp@i=
ntel.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/ufs-mediatek.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
index 5b6bff2cf9a2..14d1fcbd3661 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1132,7 +1132,7 @@ static void ufs_mtk_setup_clk_gating(struct ufs_hba=
 *hba)
 					  hba->ahit);
 			ah_timer =3D FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK,
 					  hba->ahit);
-			if (ah_scale <=3D 5)
+			if (ah_scale < ARRAY_SIZE(scale_us))
 				ah_ms =3D ah_timer * scale_us[ah_scale] / 1000;
 		}
=20
@@ -1376,7 +1376,7 @@ static void ufs_mtk_adjust_sync_length(struct ufs_h=
ba *hba)
 {
 	int i;
 	u32 value;
-	u32 cnt, att, min;
+	u32 att, min;
 	struct attr_min {
 		u32 attr;
 		u32 min_value;
@@ -1388,8 +1388,7 @@ static void ufs_mtk_adjust_sync_length(struct ufs_h=
ba *hba)
 		{PA_TXHSG5SYNCLENGTH, 0x48}
 	};
=20
-	cnt =3D sizeof(pa_min_sync_length) / sizeof(struct attr_min);
-	for (i =3D 0; i < cnt; i++) {
+	for (i =3D 0; i < ARRAY_SIZE(pa_min_sync_length); i++) {
 		att =3D pa_min_sync_length[i].attr;
 		min =3D pa_min_sync_length[i].min_value;
 		ufshcd_dme_get(hba, UIC_ARG_MIB(att), &value);
