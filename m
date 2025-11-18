Received: from mail.crpt.ru (mail.crpt.ru [91.236.205.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43362C3745;
	Tue, 18 Nov 2025 08:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.236.205.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763455367; cv=none; b=ZDXKvI5GCcsG5/BwVElB5qEfMP+6FDV4RAvLrLzIVvEkVLPQaECmo6orZacu7v4GVfyOk1HJmgsQc87HiDyKIQPHen/5WPgXaXECHskUwm7zJYF5Ecj6nmEcGw393aRvYmoFlkJDbTC/+UP7oi9Wj2CoXBkaS7D/GLt2ysQB02o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763455367; c=relaxed/simple;
	bh=3XpadBi7RcjB+sw6CmZ/gXMgSZUBo7YY22/GRGiFNJY=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=fxA1DxmXDDduiMU6iiG4xqTwgSJOmzKtSt001CJ/HF4X2TxmaXYpRDv+0MKxJbLj638buBWdlo4RhxBwmJb10ZRuPOwEBo500PzpVtlq7UAb0vAJgUdhmWaOevF4EFB2QVlcv9u9WR/6V87X9QrUd7fTOONF2lLwXsALNjzBUBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=crpt.ru; spf=pass smtp.mailfrom=crpt.ru; dkim=pass (2048-bit key) header.d=crpt.ru header.i=@crpt.ru header.b=laofH8xX; arc=none smtp.client-ip=91.236.205.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=crpt.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=crpt.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=crpt.ru header.i=@crpt.ru header.b="laofH8xX"
Received: from mail.crpt.ru ([192.168.60.4])
	by mail.crpt.ru  with ESMTPS id 5AI8gWBN017210-5AI8gWBP017210
	(version=TLSv1.2 cipher=AES256-SHA256 bits=256 verify=OK);
	Tue, 18 Nov 2025 11:42:32 +0300
Received: from EX2.crpt.local (192.168.60.4) by ex2.crpt.local (192.168.60.4)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.44; Tue, 18 Nov
 2025 11:42:32 +0300
Received: from EX2.crpt.local ([192.168.60.4]) by EX2.crpt.local
 ([192.168.60.4]) with mapi id 15.01.2507.044; Tue, 18 Nov 2025 11:42:32 +0300
From: =?koi8-r?B?98HUz9LP0MnOIOHOxNLFyg==?= <a.vatoropin@crpt.ru>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: =?koi8-r?B?98HUz9LP0MnOIOHOxNLFyg==?= <a.vatoropin@crpt.ru>, "Sudhakar
 Panneerselvam" <sudhakar.panneerselvam@oracle.com>, Mike Christie
	<michael.christie@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org"
	<target-devel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "lvc-project@linuxtesting.org"
	<lvc-project@linuxtesting.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: [PATCH] scsi: target: reset t_task_cdb pointer in error case
Thread-Topic: [PATCH] scsi: target: reset t_task_cdb pointer in error case
Thread-Index: AQHcWGdHrKaxm3cec0iMJkx4NLwWBA==
Date: Tue, 18 Nov 2025 08:42:31 +0000
Message-ID: <20251118084014.324940-1-a.vatoropin@crpt.ru>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-kse-serverinfo: EX2.crpt.local, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean, bases: 11/17/2025 10:38:00 PM
x-kse-attachment-filter-triggered-rules: Clean
x-kse-attachment-filter-triggered-filters: Clean
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-BEC-Info: WlpIGw0aAQkEARIJHAEHBlJSCRoLAAEeDUhZUEhYSFhIWUhZXkguLVxYWC48UVlRWFhYWVxaSFlRSAlGHgkcBxoHGAEGKAsaGBxGGh1IWUhaXkgFCRocAQZGGA0cDRobDQYoBxoJCwQNRgsHBUhYSFpIWVpIWVFaRlleUEZeWEZcSFBIWEhYSFtIWEhYSFhIWlBIBAEGHRBFAw0aBg0EKB4PDRpGAw0aBg0ERgcaD0hYSFpQSAQeC0UYGgcCDQscKAQBBh0QHA0bHAEGD0YHGg9IWEhaXkgFCRocAQZGGA0cDRobDQYoBxoJCwQNRgsHBUhY
X-FEAS-Client-IP: 192.168.60.4
X-FE-Policy-ID: 2:4:0:SYSTEM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; d=crpt.ru; s=crpt.ru; c=relaxed/relaxed;
 h=from:to:cc:subject:date:message-id:content-type:mime-version;
 bh=Ga2KAT/PUK66gvzRVKhE/lxJ4rvQrM3uO5+Aoxd9MrY=;
 b=laofH8xX4h5InP9u0oe7cqLP5uZed9F2oXBZuEJvmTflSW/rHX9C+NV6nvNJhliwcY6UmwV0/lKg
	nGvj+n43uTPBlMVTIMIUqQfQmJcVyzvcZKl6CSHZli5oQhlOLJ7uLjHmoalkbje303+o3jl/YshF
	QMReCftkEgX8wdxVAkfqXLioDfK5B+DpIoOeIWCijsfY3kAACxIeL1PK6elY999+sMxYHHFrUg4O
	hTcMapcjt+gcEWzv3DkCqHp109ESdLKEXDr1bgwI5nSKOTAsTHT99+R5DwN62WUAKZuU4YJSExlt
	V+oS6CCx4YIJz61wrlht28lc3SmBj8rJk8bzzg==

From: Andrey Vatoropin <a.vatoropin@crpt.ru>

If allocation of cmd->t_task_cdb fails, it remains NULL but is later
dereferenced at the 'err' path.

In case of error reset NULL t_task_cdb value to point at the default
fixed-size buffer.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 9e95fb805dc0 ("scsi: target: Fix NULL pointer dereference")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
---
 drivers/target/target_core_transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target=
_core_transport.c
index 0a76bdfe5528..88544c911949 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1524,6 +1524,7 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char=
 *cdb, gfp_t gfp)
 	if (scsi_command_size(cdb) > sizeof(cmd->__t_task_cdb)) {
 		cmd->t_task_cdb =3D kzalloc(scsi_command_size(cdb), gfp);
 		if (!cmd->t_task_cdb) {
+			cmd->t_task_cdb =3D &cmd->__t_task_cdb[0];
 			pr_err("Unable to allocate cmd->t_task_cdb"
 				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
 				scsi_command_size(cdb),
--=20
2.43.0
