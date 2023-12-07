Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WcrMJdZt"
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E537171A
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 14:28:22 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1d0481b68ebso3331535ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Dec 2023 14:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701988101; x=1702592901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yEmb2DYg+e1p/KL46nudQm0korS2UiuF0YwL/pXIg3M=;
        b=WcrMJdZtD/uOVnlknuutQ71p/+VKhWn0Hg+PBUgLusFMcJzPitYVDtb8ffWTZhFysa
         3eSn1xG6izhhD1aN47T3r7YrAMRCdAj2TjQU+81A36SLrF3EvlCxPpOtxjE4CZSFpgLV
         m1Vbe+K65WQ5TTLY47I6rfWwDc3BAltOwktxkNIYtCWcoJJ+PM+fJkLyN3iLrLhSjBz8
         ipNcEl2LhrUfOhQ/udTKuMpEKJ1Oigbi9PItRUB7wIyzYX1RLQQKFrny5jGhR3at0/wj
         RbuVruf19LPH6A1AEbSO2SDQWf39SQiq/oxy3pi1FOYUCtZI5z/I8IB1wMt9FkbnqkmA
         5iQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701988101; x=1702592901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yEmb2DYg+e1p/KL46nudQm0korS2UiuF0YwL/pXIg3M=;
        b=LDE597uiRKNHdkGDWEJpIF1WmtU3IfDtAgaxtD0oAIGTGVmenFTm9hpuoUu9W35Rk8
         GVHlnNYOs7Rfos/Cgzn9RTRjkNM9Iw7pL2oTJbMg1mV9Gx72P+F8sA+OGx0P92qRQu/R
         tn4/kWW6J69SvRh5P0+LG4E8RpU8KfQCZS50cwshU/eLaGEsN74XTce2WXrefrAmWtJG
         M6VjbMjtSF73JoYdcy8EecqvV/aEO5DSOIPszaBxrw1zZn1zQmva8VyHAJ7bgQmx0+W1
         ito/CcWZoQjE+etIX11l7vrWavuNJOsR/HLcrQ4sj0eDC7p/rCNIVbXFA496kEzJxYTp
         9jPQ==
X-Gm-Message-State: AOJu0YznEXCokbuqTYbUbPeBa084QLUcwO6XLI0N/wYsULWYVqXSYFx+
	kml46+otic0aPBoeLfBevdaVUhFjIWkTFA==
X-Google-Smtp-Source: AGHT+IE11lyb/i0AIzRjsY12d9pQO/5Ry5J79iRxmQxtuAJGZbdii/HYucdxi3SNS/uTsn8aV9znjQ==
X-Received: by 2002:a17:902:ee45:b0:1d0:9661:161b with SMTP id 5-20020a170902ee4500b001d09661161bmr6439550plo.6.1701988101500;
        Thu, 07 Dec 2023 14:28:21 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j18-20020a170902c3d200b001cc3a6813f8sm312417plj.154.2023.12.07.14.28.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Dec 2023 14:28:21 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 0/4] lpfc: Update lpfc to revision 14.2.0.17
Date: Thu,  7 Dec 2023 14:40:35 -0800
Message-Id: <20231207224039.35466-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.2.0.17

This patch set contains bug fixes for the VMID feature.

The patches were cut against Martin's 6.8/scsi-queue tree.

Justin Tee (4):
  lpfc: Change VMID driver load time parameters to read only
  lpfc: Reinitialize an NPIV's VMID data structures after FDISC
  lpfc: Move determination of vmid_flag after VMID reinitialization
    completes
  lpfc: Update lpfc version to 14.2.0.17

 drivers/scsi/lpfc/lpfc_attr.c    |  8 ++++----
 drivers/scsi/lpfc/lpfc_els.c     | 14 +++++++++++---
 drivers/scsi/lpfc/lpfc_version.h |  2 +-
 drivers/scsi/lpfc/lpfc_vmid.c    |  1 +
 4 files changed, 17 insertions(+), 8 deletions(-)

-- 
2.38.0

