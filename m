Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B411C6FE1
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 19:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751053853; cv=none; b=KvZgWYKEzeg+KQYfpPcMpj1+4KoXyvP72iZbjdp0Hzp6mKz/dxhlRqKA1qD26+LnCiHMOv+yA92mLPJ6QhXvv8ZWzkfGeHCEbvgxHfsScMsZbciMJ+DwRoF9VMgKuMCVEBPG1GEfSzz/wEziVF5eBUB/eY/+NU5QBxjIGFE+tJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751053853; c=relaxed/simple;
	bh=FV/KYPMdrqobIMyIMNDthVWxSSVZvTbYV7+mOafMjJ8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m6sIIQH0qiSEsKBnMUKDuUa0eGRabWvXS6lvVVgwt7ur+lPzK1+BXjRZL/2/Tjhq6VL3trf8kjiuNwxMCghLbQgRqnbyp1AxkOZGLr63NcNq2LwkbCxUDfV/1UN5sQyTERamOIQ9wigRogmy1mTq2VNkULzpw07vI96MgYtETjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=abUQTxNZ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="abUQTxNZ"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-74264d1832eso578289b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 12:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1751053850; x=1751658650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AZihnsjB7MtNcemb6sICnNMh/ASUh9Tt7tR4KFO4z+I=;
        b=abUQTxNZLVIpuQFWpyI12mnuS/g3g8myIaGqhAihLAIATSV+RqlbjNL1gSaPDJe26h
         YE/xxRu1T/rJZowje4JiNnxtZBYdiDU3ly4IO3q+wdfIsYj63nP5jUOHLoSYn8VVROLQ
         gb0uzuD3tTtalmYKC2UGjd7Sc1/+pDna6mjn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751053850; x=1751658650;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AZihnsjB7MtNcemb6sICnNMh/ASUh9Tt7tR4KFO4z+I=;
        b=NDRY0gDjIOPgN1kl5Mfe8E1MRUzPqClBbZx62RLPIQilQlCNYkRmi5Mp8K0HblzNjP
         udTZ5gcVGcu+ShKxKobcYWsiTFIsowluwjAsr4/+5CPmabDDUJgGsO6ce9uUKubmmhPW
         QMbindcPQR8iMfxfTliUGqukcR2NhyR749m+3ZeHwKSWUCNe1M91NnwpG2+mty67NTZD
         yjg2LKAGtG/MZRFjG7nwoHsxBhbnRiZOPtQmCEvzNH5bttQ7gzcNEvvpMYLWnfqknCaF
         AbHYEq+CgQ26blQJRdUDPtSDUDHIvrD0Oc3lRMsMQ5qJeAGAHIjj8ciWa6S5q8uJobwD
         jt9Q==
X-Gm-Message-State: AOJu0Yx22H48mtOIqvfXz2OrjcG0xdbXZxjvRJP0bKYzPmF30qB7F9yR
	rbS3ilfjD24usa5RyXFGHMzW8sdFZmdOUwljVCM/RnzdKOsOrXjZnn4SoWonGMTksFuqygp664z
	TDZ5MoHwW6JakSg2/ou8ouzBz5vqevdiSbyoCBSBk7K92vhcZj/JnpNSEburZ4psqjrIUnpkbvL
	pexKT39sqmmNo8jfBGI69PWX8jXijpRoYBMydy5Xr58M/WNigiWw==
X-Gm-Gg: ASbGncts8Bh+Q7ohf65PzgY1NuSKKXJqm3HrgX/v+9vqMvv6NWcktx2JFwFJvirzERc
	6oiLjuqnv0kj5td+CA01VoyeDpiDeD79sa2QlL7CiVofQsTrRR3RxxJgGNGdF630Pr2lzGUaqYz
	Pay0/kfskPzLiygKKHJHyfaHFNfVTaKKl8BgEXFnJp0xIn09qiSDl7hHgbJSDTVHsNfz1yt94bL
	czC+V1xm7JKY5EGVayjk0VWb+ZrGvQW7EcuwMhPKVzTCRLHAoODV9mMVejvsIZOAaqCpuLO6HW1
	TYjax9jvsoO3TXZ05gkNNf+glwUfepS5e1CXIJgDm0vdB8Kh9Eu51x7oCL/igeua/yEGUAQpHTd
	HZh5bI++69yBTCYtSUfLze2eFFolfpqk=
X-Google-Smtp-Source: AGHT+IHIqDDL+dSMT1kaci1r0FpFwZD3Oke2W4FtlJDo/IgoQbj5iJ7OoRQegkJt98HxcflS94+epg==
X-Received: by 2002:a17:902:c949:b0:235:1706:1ff6 with SMTP id d9443c01a7336-23ac19c7a5emr73741485ad.0.1751053850099;
        Fri, 27 Jun 2025 12:50:50 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2f247csm23485175ad.79.2025.06.27.12.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 12:50:49 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 0/4] mpi3mr: Few minor bug fixes
Date: Sat, 28 Jun 2025 01:15:35 +0530
Message-Id: <20250627194539.48851-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Few minor fixes of mpi3mr driver.

Ranjan Kumar (4):
  mpi3mr: Fix race between config read submit and interrupt completion
  mpi3mr: Drop unnecessary volatile from __iomem pointers
  mpi3mr: Serialize admin queue BAR writes on 32-bit systems
  mpi3mr: Update driver version to 8.14.0.5.50

 drivers/scsi/mpi3mr/mpi3mr.h    | 10 +++++++---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 17 ++++++++++++-----
 drivers/scsi/mpi3mr/mpi3mr_os.c |  2 ++
 3 files changed, 21 insertions(+), 8 deletions(-)

-- 
2.31.1

