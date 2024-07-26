Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA2514E2CC
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 23:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722034811; cv=none; b=XqPuAjOK++rXFapzUlSE9vAi9FgkWO1l+DOfufMqH0XB0Z8600iEyyj+wgq0cU32vOq+lqmdrcE7SN188WJMBsHiPAuNIOxseO2sSJLX5WUeCO3uuwcYOiQxzjCjFg33h0Ao66gdr5QCtyBwXpn/ddRcrx7nMWPZskXXokQg+ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722034811; c=relaxed/simple;
	bh=x78SigZZKpv4PGuy6dVQbxwWxETEUsAp+e9sK/1QOmQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qt8VtUCeSnZD0bQsUbhq09CBr6Fm2OcOKuk75GJnMHAv/VtYH54UEHchL10X91oUTLZnLvTqj7S9mKDmt/LhETDeHgcUl9nj0s2dPY1phvdFXXcF12K2/Lgcne/0qiuCUw7179sqL28qzOUMHiVjINuCsBKEhYNkF5bASnx4wIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vvrje0NE; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vvrje0NE"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2cb7344ed8cso239096a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 16:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722034809; x=1722639609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hkGGT6Cl4eQMAs1FA6JIr0lCMLReUe6VTrJIDGqg9Wc=;
        b=Vvrje0NEkJSFJgUvnErbbOmgq23YhNTBikra5fgPZ/SbjDzBhvPSvIfUXNPNxm8mJZ
         T5kds/P6lb7cyfqqMbyQQGn9NVxI5Dkq64bcSUeyVSnF21uLLdyD8qSn1YYyiB6DfnBp
         ooBKe4+aiO3iOPfSeuEFCkRK0gTpjcFfapzf6LYnIoVVD7lD429M8WojHx2k4hSF/t+l
         +EId2UFwNVfab6LC185OmNpb/nMi26Iws0aEjvUtydt6ji69pI6M67NGIK/XuOqQ/u2e
         zxpkRLZQVJhbmpIiBzF8XbxRveaOqRfjoAHUcTer+oE/YlAsa/eSW/WOsI3OyG5EZ2ZF
         m0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722034809; x=1722639609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hkGGT6Cl4eQMAs1FA6JIr0lCMLReUe6VTrJIDGqg9Wc=;
        b=kAP/AjgUO1RuV50NcU96yskpnpiZVRq60CAkcjWQtSgU3vGMD1PMTko/BIOkKCozib
         /a32F9/aC2ijm5GL1UtWgMzBqOvJQQh3mGJ94OTwbNbI9GM33TBcuBzgARmfr2PeJm9z
         pRyqDY32iDeWrkl4tdwM14FWVKNCX89UmaCsX7NQAYwZqYKWdU3NvoH/RBSUTICWc0UZ
         MCUOabSDRi0FXDN/FryPkd1MouaP9qAaWpvn2PGtL2a1TGy9jRdN8BbYJbsvw+GjdCP8
         9a52Lz0VLuDBmP7CFtM6LYxm9V3ORYl2EY/7s5Z37OwqevnYoFpU8QrimlOXTiSM/uI1
         xyuQ==
X-Gm-Message-State: AOJu0YwGpjaThWGo0DqOLjNPEUgsxGEe2XNK8hiu0M4u2t4HCXXOJnrE
	aUxQjhArCPhDDmGHBQcWExifcfahDxkoV5dmTsHHbTGHNwSq1XoBc10NBQ==
X-Google-Smtp-Source: AGHT+IGyXGDtKt4yHmTqIKg4hsxcdSi8lAofQjTN4TeTuM86p/o35BdJwD7ia7SdlHrczu34R1N/pg==
X-Received: by 2002:a05:6a20:9d94:b0:1be:c3fc:1ccf with SMTP id adf61e73a8af0-1c47737480amr5423659637.2.1722034808951;
        Fri, 26 Jul 2024 16:00:08 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead8834b1sm3308540b3a.178.2024.07.26.16.00.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2024 16:00:08 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 7/8] lpfc: Update lpfc version to 14.4.0.4
Date: Fri, 26 Jul 2024 16:15:11 -0700
Message-Id: <20240726231512.92867-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240726231512.92867-1-justintee8345@gmail.com>
References: <20240726231512.92867-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.4

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 7ac9ef281881..2fe0386a1fee 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.3"
+#define LPFC_DRIVER_VERSION "14.4.0.4"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

