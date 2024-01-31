Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520D12135A
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726225; cv=none; b=R7UP4gmWOof0MqK8n0gmW2qSJlONzhh76NYvFNT1nkQwX5sd7877Qdpxo46gsU7+rWK/zsexxlkEPI/yK0EzL3LJBuIzHUZtLXzsZ4AX/ouriHuOAv+DKXElJ5ztbTUTnYEfubMjLhxDvGa1nn63qopYcfc4S61/i6SZvYpa9hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726225; c=relaxed/simple;
	bh=gDm2BaCy0BUtg05iJ7ByS6gA0fToR3Bnsk3/MRUPz48=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IuPXX4Ihg27hTgko3ckPRm2hNP7yJhkZ1u+sNi5F++GdWMjeaJ4n7xSsx59SqwXkLKFB59LAukZxaBdIXWf9djjJT74n033BcMRazdL6UYVyesJTPBYFSby2Phd5ehsMLXXlDVSCRxvLX/5dVOiPKICqShxPUqwFqNgW5isKddA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FaGsnwXp; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FaGsnwXp"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4bda0abc59dso20684e0c.0
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726223; x=1707331023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G02PxKYH/d/xuogNFC50KNVfD5cQDSP0cX0mGmNZDcM=;
        b=FaGsnwXpcHX26FVrol3zcEjfC00u1RklBnjVD4pk+f5lEA16FZDfN3CJDXrWdYDWnx
         wwvqTBQhsymETVL6fAAxhi02wmClaV0Vbi6XmDds5l6DZfWC9JJ+XDGPKM4KqZ3LbdFZ
         Sk/1pN54GpsTe0TZXGxjTX4EEQr5qs1CPLqFQFbgGNhnh3yRDKZh/cvsnYppPJjAeQv1
         t7htNKv9adigCcUybHTtPAPA2arxyVci2t9fm6hkM85WLAzz43WOVmC/JjOOL3BwrSKZ
         +OUWwRWbqdpSSMaYnEya/D0sHqieOhiJTgToxadUfaxwoRtRZ/Y3v6dKU97ZbNgud/0f
         nWRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726223; x=1707331023;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G02PxKYH/d/xuogNFC50KNVfD5cQDSP0cX0mGmNZDcM=;
        b=nR6f8Yej9H4Ii5Qoefyr7xk1fkBoldFe3CWUiC0LngMBn/nbFgE8EgxD8fSXCpjTdK
         flWFada9lnURzGmi6M95egqLkO79bbPhdCjKPM1sbzP9sSDH8yJ4l0htYgJj9RKCFVIK
         +m83kH48zSUKkKaQKquoJ6T8gNrTBW255Zovb3IQAGuL9oK3Inf+FyC/KYXrhSRaBORK
         VM9D421c+c2AzuFwjhWVBbqtQjwU++k6baj5rIVrs5Aiy5qtg1E9/23jz+zHMay7W0Wc
         TenmM5d6YD9CYjYj2KMCHljp3F9x+Qa4aWCkoBfQACCBO7uZvPb40ML0qVaOgcUFDm/m
         Rr0g==
X-Gm-Message-State: AOJu0YyOBHp2xtJ3WZZRvKTCcxzfxVnHql0vSgckgKmoT2QyN0t8EY0D
	0O+uw8tyBXv+zMpP52TA1KXnrjkw+Hl/RZ8yc3k89+tUU7ZEqVcDgJqHc/bt
X-Google-Smtp-Source: AGHT+IFJpQkPu3MMjZNckCntWeVzuMi3bORcx5CqIRKaNo/Cpx5uDr4gURKZitXCZk292XStvxvGJQ==
X-Received: by 2002:a05:6102:3669:b0:46c:aeda:e240 with SMTP id bg9-20020a056102366900b0046caedae240mr401321vsb.3.1706726222822;
        Wed, 31 Jan 2024 10:37:02 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:02 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 00/17] Update lpfc to revision 14.4.0.0
Date: Wed, 31 Jan 2024 10:50:55 -0800
Message-Id: <20240131185112.149731-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.0

This patch set contains fixes identified by static code analyzers, updates
to log messaging, bug fixes related to discovery and congestion management,
and clean up patches regarding the abuse of shost lock in the driver.

The patches were cut against Martin's 6.9/scsi-queue tree.

Justin Tee (17):
  lpfc: Initialize status local variable in lpfc_sli4_repost_sgl_list
  lpfc: Fix possible memory leak in lpfc_rcv_padisc
  lpfc: Use sg_dma_len API to get struct scatterlist's length
  lpfc: Remove D_ID swap log message from trace event logger
  lpfc: Allow lpfc_plogi_confirm_nport logic to execute for Fabric nodes
  lpfc: Remove NLP_RCV_PLOGI early return during RSCN processing for
    ndlps
  lpfc: Fix failure to delete vports when discovery is in progress
  lpfc: Add condition to delete ndlp object after sending BLS_RJT to an
    ABTS
  lpfc: Save FPIN frequency statistics upon receipt of peer cgn
    notifications
  lpfc: Move handling of reset congestion statistics events
  lpfc: Remove shost_lock protection for fc_host_port shost APIs
  lpfc: Change nlp state statistic counters into atomic_t
  lpfc: Protect vport fc_nodes list with an explicit spin lock
  lpfc: Change lpfc_vport fc_flag member into a bitmask
  lpfc: Change lpfc_vport load_flag member into a bitmask
  lpfc: Update lpfc version to 14.4.0.0
  lpfc: Copyright updates for 14.4.0.0 patches

 drivers/scsi/lpfc/lpfc.h           |  94 +++---
 drivers/scsi/lpfc/lpfc_attr.c      | 107 +++----
 drivers/scsi/lpfc/lpfc_bsg.c       |   8 +-
 drivers/scsi/lpfc/lpfc_ct.c        | 154 +++++-----
 drivers/scsi/lpfc/lpfc_debugfs.c   |  14 +-
 drivers/scsi/lpfc/lpfc_els.c       | 446 +++++++++++++----------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 350 ++++++++++------------
 drivers/scsi/lpfc/lpfc_hw4.h       |   4 +-
 drivers/scsi/lpfc/lpfc_init.c      | 137 +++++----
 drivers/scsi/lpfc/lpfc_mbox.c      |  10 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  91 +++---
 drivers/scsi/lpfc/lpfc_nvme.c      |  20 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     |  14 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |  10 +-
 drivers/scsi/lpfc/lpfc_sli.c       |  56 ++--
 drivers/scsi/lpfc/lpfc_version.h   |   6 +-
 drivers/scsi/lpfc/lpfc_vport.c     |  69 ++---
 17 files changed, 717 insertions(+), 873 deletions(-)

-- 
2.38.0

