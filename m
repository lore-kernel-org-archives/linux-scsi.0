Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bell-sw-com.20230601.gappssmtp.com header.i=@bell-sw-com.20230601.gappssmtp.com header.b="wiVFfJWb"
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B55312C
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 09:14:46 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-50bb92811c0so1000866e87.1
        for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 09:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bell-sw-com.20230601.gappssmtp.com; s=20230601; t=1701191684; x=1701796484; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QCcwI5Fsx/m7FQ+379CJxqfI5J6SA+TgM6DUnwjy9a0=;
        b=wiVFfJWbQ4AK3bFS8hdLapk30fV2W/h7qgokd9mfZ+eJHQlMx0sdzXtReG2KbFy0sf
         TK/NdCvWfskOySZthgVQVIBamSSR+VxUywzE67NsevDUgFsx5Fpl4zTt+2Ra1FYnLH72
         r7B0BCbsfj/rMWFs1XNJXV7phmZGZ5ylkaAtbrgP05Ye45wfGFqurrYrG2F1qXXg7+Q7
         zXL7E4vJ1m591NSYOu5JEI0LNxo0VKXSmQTaivMJI3Yv0fSEcmQ8zPoC5UQCOdRgSEFj
         CeXppCJSd3XKcKRCqCJqfcVl0KwFTc5XwmFfzd5+MR4zMyd1CY54BJvtTWuUgNuy5aR+
         PiYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701191684; x=1701796484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QCcwI5Fsx/m7FQ+379CJxqfI5J6SA+TgM6DUnwjy9a0=;
        b=gJxrEVKH8GYdWdcCvyysU0fsjY/6M1Icf8+fuOCCs8uXUd9LphA5JxBsAeJfUp8HFe
         rILzMJRdfoWhzOtw7NccmQTa3OH7GAHqW0vtjbj25e2k5lL5T1VzTZFt7hAK8vlTAgnM
         qaSRu1y8to68Kjyb+QGq2mp41snR0SmHDCXypjmCnIZglzLAtUWzra+y6VnLSx80br0a
         FTEqDmtktZw/uqItYGK7oaeLfsKkwD2KRfdSsrGEuff5hBXlNVq/szwIHBnzycKIlVMH
         j0wCKQ6L9j1qkswnEnZvxSdOLwUT3iZ8AAPsUU4kXQBtA5nVbfMm8MX0HJarM0slSpOo
         UZGA==
X-Gm-Message-State: AOJu0YwA/fthNv1ESNDJM/6ON0EKbztyhV8ffCP+jWHzX5ljoFkJBBZY
	c1Bp8bAt5Ac7Ain98VpiW2fYIOEeIyRzhhES1g==
X-Google-Smtp-Source: AGHT+IEGglxL3q0PVkQI9U1+znrjwhbUm//7kav22xDv/c/n6AOVx5OgUDK66Xxps5lCZyoQy1Ighg==
X-Received: by 2002:ac2:5596:0:b0:50b:c230:2bff with SMTP id v22-20020ac25596000000b0050bc2302bffmr198177lfg.19.1701191684423;
        Tue, 28 Nov 2023 09:14:44 -0800 (PST)
Received: from belltron.int.bell-sw.com ([95.161.223.113])
        by smtp.gmail.com with ESMTPSA id m25-20020a197119000000b005042ae2baf8sm1870333lfc.258.2023.11.28.09.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 09:14:44 -0800 (PST)
From: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
To: linux-scsi@vger.kernel.org
Cc: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Subject: [PATCH 2/2] scsi: fnic: drop unnecessary NULL check in is_fnic_fip_flogi_reject()
Date: Tue, 28 Nov 2023 17:13:52 +0000
Message-Id: <20231128171352.221822-2-aleksei.kodanev@bell-sw.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231128171352.221822-1-aleksei.kodanev@bell-sw.com>
References: <20231128171352.221822-1-aleksei.kodanev@bell-sw.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

    if (desc->fip_dtype == FIP_DT_FLOGI) {
        ...
        els = (struct fip_encaps *)desc;
        fh = (struct fc_frame_header *)(els + 1);

'fh' cannot be NULL here after shifting a valid pointer 'desc'.

Detected using the static analysis tool - Svace.

Fixes: d3c995f1dcf9 ("[SCSI] fnic: FIP VLAN Discovery Feature Support")
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
---
 drivers/scsi/fnic/fnic_fcs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 55632c67a8f2..ca4214db72f5 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -338,9 +338,6 @@ static inline int is_fnic_fip_flogi_reject(struct fcoe_ctlr *fip,
 		els = (struct fip_encaps *)desc;
 		fh = (struct fc_frame_header *)(els + 1);
 
-		if (!fh)
-			return 0;
-
 		/*
 		 * ELS command code, reason and explanation should be = Reject,
 		 * unsupported command and insufficient resource
-- 
2.25.1

