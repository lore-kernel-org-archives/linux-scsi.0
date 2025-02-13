Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2458680034
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 01:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739410837; cv=none; b=g229vRMLaEb18Hy0lI7qA3bq+gO10QCRGiAZ/NAkATEciPx7NiVbL74y7GPcistwpd5njRKyMZJKjfLLHr+9ouDtaHBCG82yNffyLgNHOVKyu7d4W+VG/iS+WKpKseYjH+TiBrr8xmYfMsYNV7eEYVawcdvssTN2lHte/wzoidI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739410837; c=relaxed/simple;
	bh=ev6iTTElWt4AG4XRLDdKcg+sx1feaGFSWjETf2mv0Kw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=S7FUUNOs2KORAupFRjtG9dUMCkExXvjnkpfGLZ01Hq4h3LgF5oHtoSooQ4/scHZMXGOar8nWOVjRXCaJflcW+JSPiKvYsFuqtcQ2KbRlo0iPdM8CPTbOlomd9yKn3v/D6k4kRXlB9lHeAfCR83ot0tTlREb4stEf58bKfAEtvSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=f8Snl7vl; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="f8Snl7vl"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-220d132f16dso4226225ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2025 17:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1739410833; x=1740015633; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kmZRvmcVoXxgd9kWHLaNNBAR51uRBy418tfhdq691tY=;
        b=f8Snl7vluHa/VFH1ByxnMm1MWrIo4GqP7WqJY4VmQXnzh/7CcTGP8qzkOzxqPFr7pK
         3Zie5u397T3LjyaFyxHT874gaHw5uuUS1hMWAk9hENj/Eyr9v7OI6nNwWnmlfJCAChCU
         Rr8jhMIkXNvXrgVRqhS338FCmIspLuoXyGzxc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739410833; x=1740015633;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kmZRvmcVoXxgd9kWHLaNNBAR51uRBy418tfhdq691tY=;
        b=VU4MdTkYhK/LEbqJQ22nPq9WHBZ/yPZgTedpLlaWXk2UoFVROWU0Z7WQGqib0akdnw
         AA38JoqLH0DfSBXrWm1YX8GbOnySl9I7xpOrlC7GRt7ePOK6ZVQBZM4Lq62L8aMu1Ujh
         mliAeTA/r/LUIe/XaYY0w0yI+K0v6XQH/FSS07cB5S9t4IZ6jF0gKTRbdM3RMg4f5iPB
         4rQmCM/2NvmdTn2VZNVIivO0bDZaOmwPwqy7/324bAAvOGBQh80NODeggSUerwdNQypY
         1thBmNBW4oUH7LHVm8lyXn2lX6x34ZYEvFoNMgkMl1W0jwdnftA/VkDhtuvZBj+oiKMe
         fFEw==
X-Gm-Message-State: AOJu0Yy8INBzryRjNv2STuDeepaDH7Rkoby26Az8O8N93dPFX9QArKDt
	RtuSyKWarBA8ZsdshYGSgvuC8bvp7JlQaRBXrbmIZnbIxOOsGIuylOL1MvZxsWSTSaTweDLtGWe
	WWIBj7M5hRJEyHRsFGgLfl6K0LK8qB5wfBIl2lhWbxBuw4GX1VNEyc5ABydFXdcTY0t8Som5cWl
	8/i3z1E9YsYfxRFXLyIZWfYkxAlmYkSHbLvUeqk5ciIQbDE0eQ7mi3SE9lfC9HWoRT
X-Gm-Gg: ASbGncuNs8QrSrkr2bX6OzVDtlKonjUpYU3wsUwabUlZeZostsqZ18hYVPn1VZaEL0T
	FkEaFDwTrciW+VzFS8ws2Ea1pT5rtZ4xF1thWQJLs3ktAt9qtcQcMm6vjv0ZFsISaG8krVsftEc
	A4OBJu1KFm+yE2HvnHX2F6lovgzYsIc09hSgwMMoBd8Reo9Z6Vh9bELrA+DYbfjfT8MApd/pl7a
	dmxOq4ggGeWwq8tAvpLn+hIEwQZkoA0NKcvU5XILgy24d7M829HlmjFvaIuTzyG3GW2dTjUoS5I
	OVVg05LMK17eA4RfQPaVVIkgPN73YulauIaymiegBD2tTegDkXkRTY2kApeg+4wuJS5qV2mTvtw
	jLwxZvaJH0j89E1cxeyt+3QY=
X-Google-Smtp-Source: AGHT+IFVAA2rQItD8NOYU4tnNo0NH0V12SU4z3L3KuythWPOUna9G6Ze3/jzcbVKyRkdsO1UTb+fRw==
X-Received: by 2002:a05:6a00:841:b0:730:7885:d902 with SMTP id d2e1a72fcca58-7322c0a2f86mr8829754b3a.0.1739410832924;
        Wed, 12 Feb 2025 17:40:32 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73242761714sm106145b3a.133.2025.02.12.17.40.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Feb 2025 17:40:32 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	sumit.saxena@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 5/5] mpt3sas: update driver version to 52.100.00.00
Date: Wed, 12 Feb 2025 17:26:56 -0800
Message-Id: <1739410016-27503-6-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
In-Reply-To: <1739410016-27503-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1739410016-27503-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index d8d1a64b4764..4f871a83d04f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -77,8 +77,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"51.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		51
+#define MPT3SAS_DRIVER_VERSION		"52.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		52
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		00
 #define MPT3SAS_RELEASE_VERSION		00
-- 
2.43.0

