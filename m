Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC6A1C8FAC
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 17:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594386; cv=none; b=PLzeMCeLKP6/YmZxQM+ervpPr6s796f9tiS8wj5h8KF+ovCw3CYyI6FfXsqOtlJQf8NIHiG10x8taTfVByuvto1jmuQygjvoEzDr5pb1xg/46XvzC+dt1As94HwwdOczIye1nnU4yzJqbv0c8GswAWX9tlv50QxT+EXC+iYGi08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594386; c=relaxed/simple;
	bh=YhFQ02PguntijKAjYBZDMeujU1WTda6Syu4I7hEtWgk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U/tVS38FmQnQs/tstGe0y/mY6e2UHACpRL8NXqS5SqarrJMLHIHWq8kQzeb+cUdDx3ATYw2G+uAtzKXZYKxNaeizikmB4Ri5yNGpLBszukNqprvXvkw17l30tLpGvj6dwgFmT5kJLCHkVnxwia3ReCEYDFkQPEXfCKH/epKovp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F1BvtcZJ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1BvtcZJ"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7068ca5a807so52570b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 10:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719594384; x=1720199184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kDBaPNFPEycMhOT2/UI1UtFZIA8Ynj6ILMi+Hz/QMsw=;
        b=F1BvtcZJ/FEemHaNc9VImub48d6IFo/KiJPi++n40ctrA9mINO67x7ko1dp/wVVD+k
         oQnp9nViChr1+Fih2TpPKC76aO1XSBd2BHKHXT0Ut+U6hwO75XPKWVzkZH7sKp/ouAh7
         Ds8NsvHJD/Z0XKGrMgsdXsxLQjGmE0Lf6aefu+0DQUlApX3+PV3uyiScFAvgInTe3RiI
         fz/EyeIsu+65y2W9dwn7NppcNxx3Az79TaRuj4V+ryFdUg3j9PB3VaqxtKfSSAkr/Zf2
         Gow1CGANX8PLJOSlWKJLtTR7KHsTOoUOsO+u4EwEfgXnSDmpB5uHkvET3x24MtbwQb2u
         2yew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594384; x=1720199184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kDBaPNFPEycMhOT2/UI1UtFZIA8Ynj6ILMi+Hz/QMsw=;
        b=HUvynf/Z56tTMc69yV8VP16SM+Y/7/Hi85VHgw21ytpVFgyrLyG16MLpgC4dfSWhC5
         gN6MHvrjyEqROQyONku1x7tBRnIfmttcPH8OeerLHSDFsiEqfTOMnmsbqlXIUST8An9t
         Y+BJ/BKHZNs7hsAfn4u2uK3+WC6hJqkIoBd2Jyr//ekc/+iVmEN0gBgxdu34R2DHOvcf
         P+00d+xiYEQVmnMQ0pAdPU9kFDTDDhrAICWaHcrjtp+LqpTKDZAvSP0swhuF/qUSQO5w
         tJKNmUum/DeQ5M1qnaY2pzt5FxgXSxlAMMOYMlbyPofjQtXp7y3XvJlbKNsWcyZKlBYb
         OvfA==
X-Gm-Message-State: AOJu0YxaWWxkbytd6BvNub4tymqTesPoqJZSiYx+Qqdbm4Q7y/TNNnwc
	ghKpchKidDWyv0w0mP5qUFucmapBXW+pOnMhC1JPz7eaefhnOsYlKLJEHg==
X-Google-Smtp-Source: AGHT+IE6PjhhzyeT0tyvzvnBPaytRByFdDyQcEQM5UfgV4ak1w0ywb3X4Mq4yEtBNYx1bgmhocdLLQ==
X-Received: by 2002:a05:6a00:84c6:b0:706:61bb:7094 with SMTP id d2e1a72fcca58-70667fa6defmr19175887b3a.2.1719594383574;
        Fri, 28 Jun 2024 10:06:23 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6afb8ef1sm1524623a12.40.2024.06.28.10.06.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2024 10:06:23 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 6/8] lpfc: Fix incorrect request len mbox field when setting trunking via sysfs
Date: Fri, 28 Jun 2024 10:20:09 -0700
Message-Id: <20240628172011.25921-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240628172011.25921-1-justintee8345@gmail.com>
References: <20240628172011.25921-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When setting trunk modes through sysfs, the SLI_CONFIG mailbox command's
command payload length is incorrectly hardcoded to 12 bytes.  SLI_CONFIG's
payload length field should be specified large enough to encompass both
the submailbox command header and the submailbox request itself.

Thus, replace the hardcoded 12 bytes with a clearer calculation by way of
sizeof(struct lpfc_mbx_set_trunk_mode) - sizeof(struct lpfc_sli4_cfg_mhdr).

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index a46c73e8d7c4..62e517719e8f 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1831,6 +1831,7 @@ static int
 lpfc_set_trunking(struct lpfc_hba *phba, char *buff_out)
 {
 	LPFC_MBOXQ_t *mbox = NULL;
+	u32 payload_len;
 	unsigned long val = 0;
 	char *pval = NULL;
 	int rc = 0;
@@ -1869,9 +1870,11 @@ lpfc_set_trunking(struct lpfc_hba *phba, char *buff_out)
 	if (!mbox)
 		return -ENOMEM;
 
+	payload_len = sizeof(struct lpfc_mbx_set_trunk_mode) -
+		      sizeof(struct lpfc_sli4_cfg_mhdr);
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
 			 LPFC_MBOX_OPCODE_FCOE_FC_SET_TRUNK_MODE,
-			 12, LPFC_SLI4_MBX_EMBED);
+			 payload_len, LPFC_SLI4_MBX_EMBED);
 
 	bf_set(lpfc_mbx_set_trunk_mode,
 	       &mbox->u.mqe.un.set_trunk_mode,
-- 
2.38.0

