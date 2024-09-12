Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823E61C245A
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 23:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726182586; cv=none; b=m6w6JkbibtaQixkO97eetXrQfjx9aCTWR5jVQ36Zn/SPp/OEC2e7geldwlK+L8kYTnY0NuNVHNNBVv1NnyhFbmq4tGgWk8+b1/oRuM/PBo6dZH3fM6lS1Tl8Ar/KgOvYdSnAx9jRi8dhvwv1cCLPIZmP5RFWDN9QYk+VUZNY1EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726182586; c=relaxed/simple;
	bh=uHwMzOdA8pP6nzd9weXCbBym5dDYZ5WWddA+63PXnc8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=acGgX66KrMR4jkaN767Ij1AsmgJ5ETYh6V0ZCiTwrnE6l/l8U3uWUAxbbhCcQ9/GAFAkCK9ZFhExD3avDbHd5WYrEtDVm7BSQP02sQVLLyVz4CogU3YfX9kMOp2ZN7stbYT8E7h5TAA4OjBremzTypYP43zb5bwTrYLriS2oqlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lla3NdaS; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lla3NdaS"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6c34c2a7dc7so8527086d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 16:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726182583; x=1726787383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M91GQ5oFigHVLJ8GRTSz8CVNEJCAXqYSjMJPGZzxHZA=;
        b=lla3NdaSdw8CuaI6rvgdNV3T02w2CLTLc+Fp4GukXOB+HkxPruCDt1+Fwv/VCSfWYF
         COPPJnP20gKsSBuPCRO4gKfiR/0skw+odYbT0/lZyj1IiHCt9xD1cbsTGWbff0Nsplxg
         CXi9ccyCSYYiD2+C2DCy8zl0+9clwruJGfjwZIndyYOPflRKaOfhKDq2bptqFGuYzsoV
         oaBIOtMHclDeKMTaXNsZWM/8QzSgPouj0UhQQqlQ6l8PZSrOUe2T0THvj/F6fSz9VBvR
         5TZhs9ECQvBhd1wJKOoOk9yEqAD9yAxD0VEHOAqb4jGy0Tkm/EADEhAaTeyAFw5sQ/jz
         aYlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726182583; x=1726787383;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M91GQ5oFigHVLJ8GRTSz8CVNEJCAXqYSjMJPGZzxHZA=;
        b=DI3opoxx2xs808OTEfMS5JBCPa0jczWMhGbzsfZiaJ954n+Tqezb5BaSosM7cXa/qV
         L1umlJKGvJAy0kQlwADVci9hnHHzsxrgS8FjBz+cYsJjGy8031ZRLp5FIri7+zNXw6F2
         TxOTMe/xIXWMzewMUFjhi3Cv6FE5laiKXqb9AKR0KsSOydsSEXtKhGEGTayhvaWzrhzn
         7aOQ3eZvx7ArPqMmGWRVNqZxlPucZTUbr2BpPcG1dpTsEUrxfxLMYiueU+y0QaZWD21O
         dUduAIJV16q4udlMYhEoEuhGAqT+I0Sa7q910awh4rU4nuheKP6O64PGPpCSgOSM3owt
         fzTw==
X-Gm-Message-State: AOJu0Ywj1uIHFekG+bYl7IvVykCMSPBT+GNI2jfN1GOJWiRmXxI45iOs
	DJEUuFBUFeKCFXVXFWoy252QR+DpIpGub2EMHmPDTKjBoqvLiCKhwr98LQ==
X-Google-Smtp-Source: AGHT+IHpWprjHEb/5idJFx0z/HhRzLIwRFV1hZK2V+AYcX6ZWfRNgTUbTZzGv/B7z/ofxlL1S48v6w==
X-Received: by 2002:a05:6214:4498:b0:6c3:6cf5:d567 with SMTP id 6a1803df08f44-6c57350e755mr72998116d6.7.1726182583255;
        Thu, 12 Sep 2024 16:09:43 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c534339a88sm59363136d6.50.2024.09.12.16.09.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2024 16:09:42 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 0/8] Update lpfc to revision 14.4.0.5
Date: Thu, 12 Sep 2024 16:24:39 -0700
Message-Id: <20240912232447.45607-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.5

This patch set contains bug fixes related to HBA state clean ups, FCP
discovery on older adapters, kref imbalances, log message improvements,
and support for a new diagnostic loopback testing mode.

The patches were cut against Martin's 6.12/scsi-queue tree.

Justin Tee (8):
  lpfc: Add ELS_RSP cmd to the list of WQEs to flush in
    lpfc_els_flush_cmd
  lpfc: Update phba link state conditional before sending CMF_SYNC_WQE
  lpfc: Restrict support for 32 byte CDBs to specific HBAs
  lpfc: Fix kref imbalance on fabric ndlps from dev_loss_tmo handler
  lpfc: Ensure DA_ID handling completion before deleting an NPIV
    instance
  lpfc: Revise TRACE_EVENT log flag severities from KERN_ERR to
    KERN_WARNING
  lpfc: Support loopback tests with VMID enabled
  lpfc: Update lpfc version to 14.4.0.5

 drivers/scsi/lpfc/lpfc_bsg.c     |   3 +
 drivers/scsi/lpfc/lpfc_ct.c      |  22 ++++--
 drivers/scsi/lpfc/lpfc_disc.h    |   7 ++
 drivers/scsi/lpfc/lpfc_els.c     | 132 +++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  10 +--
 drivers/scsi/lpfc/lpfc_hw.h      |  21 +++++
 drivers/scsi/lpfc/lpfc_hw4.h     |   3 +
 drivers/scsi/lpfc/lpfc_init.c    |  32 ++++++--
 drivers/scsi/lpfc/lpfc_scsi.c    |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c     |  48 +++++++++--
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c   |  43 ++++++++--
 12 files changed, 226 insertions(+), 99 deletions(-)

-- 
2.38.0

