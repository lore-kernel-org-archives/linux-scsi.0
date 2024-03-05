Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9682618639
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 19:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709668144; cv=none; b=GL6VJeiHTKtRtVzxwlUZMpalDJihzxmnmZGcBxTv2Xmb91OsuDPSgH7rwIVMDkKVXSnqkj5YGFy7OI6XD86YypAWJWqONihNoxixfYTxM5Xfj2s2dRvSLQ76VK9ThIkVuPS+gRiBBf4FoCEJC4E4K84ZYo0x8T8OO4KXrci328I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709668144; c=relaxed/simple;
	bh=UKLMP4QdbgL68D4hKgIg/xYHPQfpiT1vw8U5Fi323Kc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UwxkHKZa3lJ5X0fVJwOI4GVQt2j57D2rk3BE0/d7mk2XXiPIpUBtxSBRcF9ZZkM0DgH4C0H20WzwK6FdmwF6nQxj5Br3iObiYCNrkLOzLHyDIeQSiqv5+5wOkj8agW3ngXtKfhN0j2vkmIQ/Tl9IQzxZ9Hvw62bC0cRxMCR0zww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d5B7nwu6; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d5B7nwu6"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-42e4b89bd3cso10081501cf.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 11:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709668141; x=1710272941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6IhrXmGZCVEocJxTVveamRg46bVFo3O8o60C7+XKQB4=;
        b=d5B7nwu60zuXj/FqsEu6rfSf+qsoMEVBMRx0NYKL2GyhIIbhJVDVMp+gdDQKZyecQa
         raELd+ZY0sLtv8BvzKSDJHMvUW8t/cAoMtHQHeZDVYq8euD/couKwlCd9yTWKpEYku3G
         srSPqWcbp7Bs/1wvNMvbnQliW3M/0W8aslTR8D8QhoW8BZM2bOScb1LfHG/Imh2bC02Z
         zCLLEAdfvBisuXNBIVkMb0GWWTcjbl5gXTQwnXu9h9UdopXWN7NjzB0ayapJRIdR03tM
         XD7dzvD3aGaxpuv/6ZLndfw/FJtTxHqofXdjlsmPKs7uYldZieBVVDK8leSleonVWvYX
         XtOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709668141; x=1710272941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6IhrXmGZCVEocJxTVveamRg46bVFo3O8o60C7+XKQB4=;
        b=oS0s2WAOX2q/eURrUqsD7SW8KXHNmDIdBjapTD2BIqo9bQ7Lk9x1RsUObc3cgFpdwB
         Dg99gzWXavYn0S5KfB2+9YUMpmhPrLCIWEaSf9hC7WJOQ2nbO/QHeY1oJBJ1lrQNsNp6
         JEc+tyhleiszniTwg14I4DeGO5A74Y+aYiYqIKROde9vGuPpgS2OuwL0imRQf3nI7o39
         05Lvu7dBwxChFQww8q5mi8UU7urk3jXuZ11mDHTNEelqTucnmpOLqE4Mgq/XVBjKFLKg
         iQib4OX3QbmgFIDpb8KCTOlU7pWTpgMjKoeGGxW9ziJ7Qfltwwg3+6I1VwqHqI+H+9tF
         0KxQ==
X-Gm-Message-State: AOJu0Yyv0lhcN1/OlUYe9AUCr0SDYwt0R626UcowstrlbVFaf7LIFf/u
	r6OCOy6uqCFlcdIKYhyoC8Dru0+Ngx+IZsiCorHgys3OTT0KHBG/lE79HsNr
X-Google-Smtp-Source: AGHT+IFA2snVcKyMSusawXFufBPu8rJzIf2EdM4gGV34fZy3hP12lqdYMzF9oao85j8NBIM+nb0YZw==
X-Received: by 2002:a05:620a:191d:b0:788:33ed:e34e with SMTP id bj29-20020a05620a191d00b0078833ede34emr1418548qkb.3.1709668141483;
        Tue, 05 Mar 2024 11:49:01 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bj13-20020a05620a190d00b007877f52a6b9sm5706050qkb.136.2024.03.05.11.49.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:49:01 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 00/12] Update lpfc to revision 14.4.0.1
Date: Tue,  5 Mar 2024 12:04:51 -0800
Message-Id: <20240305200503.57317-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.1

This patch set contains updates to log messaging, bug fixes related to
unregistration, interrupt handling, resource recovery, and clean up patches
regarding the abuse of hbalock and void pointers in the driver.

The patches were cut against Martin's 6.9/scsi-queue tree.

Justin Tee (12):
  lpfc: Remove unnecessary log message in queuecommand path
  lpfc: Move NPIV's transport unregistration to after resource clean up
  lpfc: Remove IRQF_ONESHOT flag from threaded irq handling
  lpfc: Update lpfc_ramp_down_queue_handler logic
  lpfc: Replace hbalock with ndlp lock in lpfc_nvme_unregister_port
  lpfc: Release hbalock before calling lpfc_worker_wake_up
  lpfc: Use a dedicated lock for ras_fwlog state
  lpfc: Define lpfc_nodelist type for ctx_ndlp ptr
  lpfc: Define lpfc_dmabuf type for ctx_buf ptr
  lpfc: Define types in a union for generic void *context3 ptr
  lpfc: Update lpfc version to 14.4.0.1
  lpfc: Copyright updates for 14.4.0.1 patches

 drivers/scsi/lpfc/lpfc.h           |  2 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  4 +-
 drivers/scsi/lpfc/lpfc_bsg.c       | 36 +++++------
 drivers/scsi/lpfc/lpfc_debugfs.c   | 12 ++--
 drivers/scsi/lpfc/lpfc_els.c       | 45 +++++++-------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 33 +++++-----
 drivers/scsi/lpfc/lpfc_init.c      | 13 ++--
 drivers/scsi/lpfc/lpfc_mbox.c      | 30 +++------
 drivers/scsi/lpfc/lpfc_nportdisc.c | 12 ++--
 drivers/scsi/lpfc/lpfc_nvme.c      |  4 +-
 drivers/scsi/lpfc/lpfc_scsi.c      | 23 ++-----
 drivers/scsi/lpfc/lpfc_sli.c       | 99 +++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_sli.h       | 30 +++++++--
 drivers/scsi/lpfc/lpfc_sli4.h      |  7 ++-
 drivers/scsi/lpfc/lpfc_version.h   |  2 +-
 drivers/scsi/lpfc/lpfc_vport.c     | 10 +--
 16 files changed, 177 insertions(+), 185 deletions(-)

-- 
2.38.0

