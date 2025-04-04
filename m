Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3EB634EC;
	Fri,  4 Apr 2025 12:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.244.183.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743769918; cv=none; b=pveoTzaeonKvg1Qh3SEB7ym4+eCMNqy2iJ6XidwWHZ8ejBtBccNOovjyDmdOUnvW8hDoNIJfvH8pS6lNO0ltxdToXFW1ami4SOcgAoXGO/tRWGQmyh4l3PshMlWVT0lA1tOmOjf824dkHbN5qN35vlhoBM6k+/WIpsCPVct6MVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743769918; c=relaxed/simple;
	bh=WQxn2eLEbs5s3A5T/wnn/nBs0zDtImBw7CMs0N+XjBc=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=EWerbXMwTJHY8HWNIXS50dLWivBpA5ce39yNzuwD/dogdA+/e1bi1gfM4ey9cgnzf3dcjWmEi4pS3u0rVelcQexdXL2MI7r6moqBoZu05uwzJyj05R3gpXhmKPadpE0JKDXHfxZbP9ZWVZKNuFvdIuNJW3m9atdd6yrDhdIs8oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=infotecs.ru; spf=pass smtp.mailfrom=infotecs.ru; dkim=pass (1024-bit key) header.d=infotecs.ru header.i=@infotecs.ru header.b=w/r9EB2/; arc=none smtp.client-ip=91.244.183.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=infotecs.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infotecs.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infotecs.ru header.i=@infotecs.ru header.b="w/r9EB2/"
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
	by mx0.infotecs.ru (Postfix) with ESMTP id CBD2F10D3C9D;
	Fri,  4 Apr 2025 15:31:48 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru CBD2F10D3C9D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
	t=1743769909; bh=UQGLbcPHl+V/nUSU88lqQkHSOVlY8K4RXsCfBvI8YYk=;
	h=From:To:CC:Subject:Date:From;
	b=w/r9EB2/uK271conol9zRaKvlTQTaT0b7kOfek9cQTx4bVXksz2Qg8idu2mh6NYHK
	 CaE4lQUcpuRuzHU4KLiY6QT/C2Jg7Ol4dEPUEY+zts1lxoRPUbWTRGOGLmx+A6ryh8
	 33fdERUc35WpnxB3+FM3kJWTF9x4rAthPlo8VcFY=
Received: from msk-exch-02.infotecs-nt (msk-exch-02.infotecs-nt [10.0.7.192])
	by mx0.infotecs-nt (Postfix) with ESMTP id C848B305BEA6;
	Fri,  4 Apr 2025 15:31:48 +0300 (MSK)
From: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, "James E.J.
 Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Guixin Liu <kanie@linux.alibaba.com>, "Sasha
 Levin" <sashal@kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "lvc-project@linuxtesting.org"
	<lvc-project@linuxtesting.org>
Subject: [PATCH 5.10/5.15] scsi: ufs: bsg: Set bsg_queue to NULL after removal
Thread-Topic: [PATCH 5.10/5.15] scsi: ufs: bsg: Set bsg_queue to NULL after
 removal
Thread-Index: AQHbpV2Iyo4IswYLq0KSLmeI3GevJw==
Date: Fri, 4 Apr 2025 12:31:48 +0000
Message-ID: <20250404123147.3501797-1-Ilia.Gavrilov@infotecs.ru>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-exclaimer-md-config: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-KLMS-Rule-ID: 5
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2025/04/04 11:46:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2025/04/04 08:43:00 #27854901
X-KLMS-AntiVirus-Status: Clean, skipped

From: "Ilia.Gavrilov" <Ilia.Gavrilov@infotecs.ru>

From: Guixin Liu <kanie@linux.alibaba.com>

commit 1e95c798d8a7f70965f0f88d4657b682ff0ec75f upstream.

Currently, this does not cause any issues, but I believe it is necessary to
set bsg_queue to NULL after removing it to prevent potential use-after-free
(UAF) access.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241218014214.64533-3-kanie@linux.alibaba.=
com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
---
Backport fix for CVE-2024-54458
 drivers/scsi/ufs/ufs_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index 05c7347eda18..a7e1b011202b 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -175,6 +175,7 @@ void ufs_bsg_remove(struct ufs_hba *hba)
 		return;
=20
 	bsg_remove_queue(hba->bsg_queue);
+	hba->bsg_queue =3D NULL;
=20
 	device_del(bsg_dev);
 	put_device(bsg_dev);
--=20
2.39.5
