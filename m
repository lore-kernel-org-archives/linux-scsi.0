Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB6A471CFA
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075610; cv=none; b=nY/+GVkg7Kw5O3vX0u+oPE91jqWwfDzKApPTrBbkCmr40xMXDDzqR18r31VRDt056gJFNSUnlGyi2WmGFOgRxbqplaLSccdJadCeahp7FvzWy9HWxy5pLs6+kxYxajPp5sOgkHHmRWiksOJf8uuTsupPK1JsALJNJUPCViQi+8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075610; c=relaxed/simple;
	bh=SZHyITtIDScNooashDzy82V1xB83tStOWg0WY75kBkk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ieB73aL/IDz+j+nkdM4owJz7fFrmXq3kUR705YzGB5/QdnKWhSyjgoS7cMK4h3GECHlKsyaqgfJjqUTCp/6dYTRhrCk9NWQYfF0UBJ4dMFy2Tr7AM614qBccaRQH6c8n00sIJDV6DjME2TQGBmNc20mn2z0TV1I46krdfihs6Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=bmG+oOJ7; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bmG+oOJ7"
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cbe6295f05bso973121a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:53:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075608; x=1787680408;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=S8yT5MLcmwDHcZNcUmXv0h7oHriO4FbtMVMJc3B+V5M=;
        b=GJsbOc2oUbnY3Y8E00kBaBUfGmFnwM9ygoaY6rmZC4BkQRWw2tsEPYsdpHjJnnX9eY
         cvjYqB90EpSusoRCwOJ3Jm7ibKDfZ4k8SihB74O3HUINWB+jvalXvlnpU7l4sWI3NDju
         IcxsKZLa8WktfP4KGKSKvRnwwRykyuTc/3GBqi+w9AwtgGzh1SySGMYTHZIC9ZhukFlb
         TrrYJz+rL+brDV3ojMHkg19llenC8+7+lPrWjZrIR/61SJ17Kw/s+tk6v7JKkazzG2K/
         yHdN6lEmvowg1JNmiOeV1hQLokRvQiRKcK8A4zt1WxajDlG56BosL+3cAzKTzp3ez5Kv
         jk1Q==
X-Gm-Message-State: AOJu0YysV7x+T1HKOwZYT5PQ1sHyTpJSg7Qsq5hBIHH5UTWD48aSYZs1
	uTu5s+oaOPZ55T1xQSplp16ziirwzDUOZTfaW+vNUw08Dj3kl6Ejv0IyLYht2ytP0xDYRH5KIEF
	S7Qtdof4HCyN8JgjQkkYo5wBadXicLtsuIAtT8PXfIviW01NLFn1kwMWSVP+j634e1zYU6//RL2
	LfSIl3P3Q1UDb/m8iMgMlp5Jt8JsTRH1Xiji/gRg+cXXkjyg8f6Yj3RhPYded03XQZjBK0Sxaah
	yEYF/oBhWnQ7GycsOcaNJhv
X-Gm-Gg: AR+sD13m3y2AuKLkYrnp6RwNUrlZo0fthn5dgstwux1z5L9VuohXlLtx7U2Lp6bH5Rw
	JnDXPBZ5R70hU3x/Q+01vfccFCxg/pjsAyH5V6alPY0S2QNVCluohMBrOY5q2TK1Q9921AL/LwY
	B2Apm6H1QYF9+iQXXSA9jJGzvEKQy/PyOc7ybITz5BWM9g4aoB+WZUdno9YxCD5ipqJU3zuePZi
	0Uj9+kNkrLgogQzziTQiMuzGVoqrWbJsiOmOKNnhmvT6iY+6vYQ+kJ/GfdpGGxQsbnDZJw+WF9u
	aqjDPFnB0+MNfi39h2AdfgryznEGUpWIGQHzcFdBjMobtHXrWPeGR/3Hgp8x7QLUsS83danWsuW
	G1iqABXYDh/65K+Ffe6GCjnCdE9zt3BiVtGyXuOT2vXEFQ8uRA0Yec0onwfSNRXZOkUQ9lb7vQM
	+WL1VK6OUIpz3AS9hP5Yrn2SNiYuCzd+ptJk9QBpUMCrE=
X-Received: by 2002:a17:90a:d404:b0:38e:7f22:f674 with SMTP id 98e67ed59e1d1-39579a03ad7mr2326a91.11.1787075607811;
        Tue, 18 Aug 2026 10:53:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3954d176bfesm2720119a91.0.2026.08.18.10.53.27
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:53:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-385d2703b64so1367869a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075606; x=1787680406; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S8yT5MLcmwDHcZNcUmXv0h7oHriO4FbtMVMJc3B+V5M=;
        b=bmG+oOJ7aBE+O/U6wbsZzPUsC2t/SzIQowb+2GlCB0hv5Mw0fXW4FaPI2bRfDyKKvB
         aOapRnkNTDLl8x+lQIP6Q0RsCFR4D4/BC5Ohfvw+7Pj5uE0eiGgVu578YHeyG0dBIXiW
         Kd5+ud7e0Bx7ltKE3wITtqI95Pz3T99CZeghY=
X-Received: by 2002:a17:90b:5404:b0:380:8bb9:aba9 with SMTP id 98e67ed59e1d1-3955f0c0364mr9533123a91.3.1787075605771;
        Tue, 18 Aug 2026 10:53:25 -0700 (PDT)
X-Received: by 2002:a17:90b:5404:b0:380:8bb9:aba9 with SMTP id 98e67ed59e1d1-3955f0c0364mr9533069a91.3.1787075605160;
        Tue, 18 Aug 2026 10:53:25 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:53:24 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	ranjan.kumar@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com
Subject: [PATCH 0/17] mpi3mr: fix out-of-bounds accesses and reference leaks
Date: Wed, 19 Aug 2026 04:44:09 +0530
Message-ID: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This series contains a set of fixes for the mpi3mr driver:

 - out-of-bounds accesses where values reported by the controller
   (device handles, phy numbers, topology event entry counts, reply and
   sense buffer addresses, event data lengths) are used to index arrays,
   derive pointers or size copies without being checked first

 - out-of-bounds accesses in the BSG passthrough paths, from a request
   size held in too narrow a variable and from a copy made without
   checking the payload holds that much data

 - target device reference leaks and an I/O block counter leak on error
   and teardown paths, the latter leaving a device blocked for I/O

 - a response buffer copied back to user space without being zeroed
   first, so its unwritten fields carry whatever the allocation held

 - a use-after-free and a NULL dereference around the firmware event
   workqueue during driver removal and PCI error recovery

Chandrakanth Patil (17):
  mpi3mr: Fix buffer overflow in BSG passthrough request copy
  mpi3mr: Fix out-of-bounds read when copying BSG MPI requests
  mpi3mr: Fix I/O block counter leak on admin request post failure
  mpi3mr: Fix target device reference leak in BSG task management
  mpi3mr: Fix buffer overflow when caching log data
  mpi3mr: Fix out-of-bounds reply frame access
  mpi3mr: Fix out-of-bounds sense buffer access
  mpi3mr: Fix out-of-bounds bitmap access during device removal
  mpi3mr: Fix target device reference leak in device removal handshake
  mpi3mr: Fix out-of-bounds read in SAS topology change events
  mpi3mr: Fix out-of-bounds read of event data
  mpi3mr: Fix out-of-bounds phy array access on link change
  mpi3mr: Fix buffer overflow in the BSG target device map
  mpi3mr: Fix out-of-bounds read in PCIe topology change events
  mpi3mr: zero out diagnostic buffer status memory
  mpi3mr: Fix use-after-free of the firmware event workqueue
  mpi3mr: Fix NULL pointer dereference on PCI error recovery

 drivers/scsi/mpi3mr/mpi3mr_app.c       | 43 +++++++++++++++++-----
 drivers/scsi/mpi3mr/mpi3mr_fw.c        |  9 +++--
 drivers/scsi/mpi3mr/mpi3mr_os.c        | 76 +++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/mpi3mr/mpi3mr_transport.c |  7 ++++
 4 files changed, 111 insertions(+), 24 deletions(-)
