Received: from mail.crpt.ru (mail.crpt.ru [91.236.205.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35673803D6;
	Wed,  8 Apr 2026 10:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.236.205.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775643285; cv=none; b=gXbQEHjCgyhTe4V83JBzqbFdohLSeMYE0O0+x0X7HfYKcgR6y4aQU4ixUWRrbhGKCmcVhcmsqS5hgD42thlcPseT4YtuV3hArEtq0qfNkKLSOloF8C005FqBx3Ey44rKPR74KjRETe8CetyDjwTBY+YVUlxcwpR4ZS4SGOsobnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775643285; c=relaxed/simple;
	bh=IoYyZ/SI4yknpZ6vZ7pjbrZPFU9T+KTqEsLZBCK1sDQ=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Wj68q2Q6c0OHDWZ65bUzpqPjqCjtXNbrAGCJ4ybhDi9aflOOWJF3kfT6S7TAAgjt34equQAbPTql3LyWIpJ+KR7Y/eZOZMSavCk/noeKTuOcMPYp0p2Ajc2iOrdtd6jHS83BQLsE8+kCvdRiPpcJ0wV59k8gx+yQEVRbyzxlwWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=crpt.ru; spf=pass smtp.mailfrom=crpt.ru; dkim=pass (2048-bit key) header.d=crpt.ru header.i=@crpt.ru header.b=jhb9a01/; arc=none smtp.client-ip=91.236.205.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=crpt.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=crpt.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=crpt.ru header.i=@crpt.ru header.b="jhb9a01/"
From: =?koi8-r?B?98HUz9LP0MnOIOHOxNLFyg==?= <a.vatoropin@crpt.ru>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: =?koi8-r?B?98HUz9LP0MnOIOHOxNLFyg==?= <a.vatoropin@crpt.ru>, "Roman
 Bolshakov" <r.bolshakov@yadro.com>, David Disseldorp <ddiss@suse.de>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: [PATCH] scsi: target: Add a check to prevent the use of a NULL
 pointer
Thread-Topic: [PATCH] scsi: target: Add a check to prevent the use of a NULL
 pointer
Thread-Index: AQHcx0B3zaxAFxbBMk6qmv5jGMLGsw==
Date: Wed, 8 Apr 2026 10:14:20 +0000
Message-ID: <20260408101400.8373-1-a.vatoropin@crpt.ru>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-kse-serverinfo: EX1.crpt.local, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean, bases: 4/7/2026 9:01:00 PM
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
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; d=crpt.ru; s=crpt.ru; c=relaxed/relaxed;
 h=from:to:cc:subject:date:message-id:content-type:mime-version;
 bh=IqgtREMNwY7ZBwZB4NCZwdKeHpqQmhXD9Z3z/VQGaGs=;
 b=jhb9a01/s3gYcBtd6BYgSbsz0r8hovHRTesym7kupJXXTzXglqkMAUGTQWdGPvdMU9Dl40jmVCkB
	6zS5W+/Stmf06tQ5jEXlkia/GfKd48/4qMbS9HqcoSLvmCRTPrWMGb8D0Z7syEdQgzm/XumTTEW9
	T4+GngbM6UbVBCQlpVkF9aZaV7faBaCwt0u6iv3FykHuna57dDPl66jVyekCx7pS1lk8K7of6qVJ
	gozDZqqpZm6tZRWfeI+GIE+/g0N039JFV0lY86kihOy3VhYW/ZJh6PTHd0co/dU9y8uSOL6L7Vnr
	dh1y2PTR1lTqYpyVXTmWc725BVlfQhB7iajv9g==

From: Andrey Vatoropin <a.vatoropin@crpt.ru>

Some functions accept a string input parameter, which is then passed to
strscpy(). If strscpy() returns zero the (len > 0) branch is not taken and
`stripped` remains NULL. The subsequent check (len < 0 || len >
INQUIRY_VENDOR_LEN) does not catch this case, allowing a NULL `stripped`
pointer to be passed to target_check_inquiry_data().

Therefore, the existing checks are insufficient to prevent the use of a
NULL pointer when an empty string is passed.

Add exclusion of zero-length strings to avoid dereferencing a NULL
`stripped` pointer.

Found by Linux Verification Center (linuxtesting.org) with SVACE.
      =20
Fixes: 54a6f3f6a43c ("scsi: target: add device vendor_id configfs attribute=
")
Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
---
 drivers/target/target_core_configfs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_=
core_configfs.c
index a1c91d4515bc..3aaa2b931009 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1455,6 +1455,10 @@ static ssize_t target_wwn_vendor_id_store(struct con=
fig_item *item,
 			"\n");
 		return -EOVERFLOW;
 	}
+	if (len =3D=3D 0) {
+		pr_err("Emulated T10 Vendor Identification equals zero.\n");
+		return -EINVAL;
+	}
=20
 	ret =3D target_check_inquiry_data(stripped);
=20
@@ -1511,6 +1515,10 @@ static ssize_t target_wwn_product_id_store(struct co=
nfig_item *item,
 			"\n");
 		return -EOVERFLOW;
 	}
+	if (len =3D=3D 0) {
+		pr_err("Emulated T10 Vendor equals zero.\n");
+		return -EINVAL;
+	}
=20
 	ret =3D target_check_inquiry_data(stripped);
=20
@@ -1567,6 +1575,10 @@ static ssize_t target_wwn_revision_store(struct conf=
ig_item *item,
 			"\n");
 		return -EOVERFLOW;
 	}
+	if (len =3D=3D 0) {
+		pr_err("Emulated T10 Revision equals zero.\n");
+		return -EINVAL;
+	}
=20
 	ret =3D target_check_inquiry_data(stripped);
=20
--=20
2.43.0
