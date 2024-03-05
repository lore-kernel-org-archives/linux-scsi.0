Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BDC5C607
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 19:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709668152; cv=none; b=SE4MxQ2nYhG8lt4tsVO4p483XLgkoZcJ1zqREKVTRPkDMrgpHmF9nJeUOeQgJmWQ4vn7NiiZhvRvcyTK0wkZOkLmtTw5D20g7fVU3JhlXYP2vLkcdMfZnJX0dZInALbI/vQTnk2OX1/Pi1cSKuST0ffNO3UeUWBPS36oYXf4M/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709668152; c=relaxed/simple;
	bh=3Tv335XBDQaloogBYjJslsIFJyxfpHfC6/Ms/8rZwiY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WbI+SuVL6+77CUYo31No1zGGkfKltN4zNDuqpMlhnQb8tBDIsaWyydlDLjTPhlV2wRwErgBsOD4HzNUTjMMD3sKzIBCeDkGfV8J5DIZwjHhIvArmXMK3YGvNpXk7FwQfgic/jcBPEv1HoOSpXKOO5G1PK/uyLMrt17cqQViNC1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OBqwRukh; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OBqwRukh"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-42e4b89bd3cso10081841cf.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 11:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709668150; x=1710272950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sBY88P3rtRMZpIydbDmgEuFEfCAqJBWF6YxBqP04hEw=;
        b=OBqwRukhxwlgkXqxwK4ITOimReccLrRjFsWeVXo9rsHlnpebmeq1zuFNBBOYiau47E
         VFAMmjW50I88gnYtrY8QJEziGLOzDmHNVVyXvFOVm2WRrYWLO3S/QOMIEVxzXIToYDZi
         nvfC3oGmhWI1Ibfo/eUPgxu5MPxCgCBjVeEfKMy7W/BgmJhbHW3IIFQ7ah7ag2I8FBRj
         3TydDjM7DvbiAGahTXTKySgugZf7gdmmCZYlfy7wSvQ+JumEakFn+dRxTlvr0IMEtW0x
         fpYNzuss8qTXCg6rkyOAH2sPVGhTgVEARCWGJfMFlb0Ee9UHQnWVqear7KIpfxUje8/g
         8K5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709668150; x=1710272950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sBY88P3rtRMZpIydbDmgEuFEfCAqJBWF6YxBqP04hEw=;
        b=HROt2rNqMiiM0OdX6Lf/BiLGWoEhz2ck9mW+p/VrBKZN8C9N7LhwhRUaSSqHYErd1J
         9+oenUV4n7+RN5eXvIZB0vWEQWO+R9Qv+XrG9jQ4fka+OWCuRqpxtU22eTxCvGORlINF
         2DNGC6I5vKHK45ojWo2USHOeLPzSwGi0KztO92F4aBvQ1ZiJHnKu3QxNWbqodSn2u92c
         bxbw2sXiIsMscieXTiVMBF37Gh32Gvj6AcbwsohdsqCyRnvXWlbcWoOBnJkcWXsXy4n7
         OiA6ckpWC90uS/bJp6AWyavlMDyndhE+o1gH1INFqC+MHyDz0OmqHqQ4wsOpUZJFzKw+
         ptNA==
X-Gm-Message-State: AOJu0Yw13i9yy/O9yjUSYndgfhDN6bOy7lL9r9u9YTRZ5H5nYU7FBDXQ
	lfFAN1fm6azijtwLb0SHRf2o4sty9aptD3k44nqlaSRZzeeZ/Fq31BoQBUsY
X-Google-Smtp-Source: AGHT+IGlYkhbDaIMZWtW/d7695ijlJSu6bSF1pn4uqu3kWXc1fy5ZMJcURQ6zIV7i0n3g636sLEuqA==
X-Received: by 2002:a05:620a:4150:b0:787:f4bf:507e with SMTP id k16-20020a05620a415000b00787f4bf507emr1377985qko.4.1709668150251;
        Tue, 05 Mar 2024 11:49:10 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bj13-20020a05620a190d00b007877f52a6b9sm5706050qkb.136.2024.03.05.11.49.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:49:10 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 03/12] lpfc: Remove IRQF_ONESHOT flag from threaded irq handling
Date: Tue,  5 Mar 2024 12:04:54 -0800
Message-Id: <20240305200503.57317-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240305200503.57317-1-justintee8345@gmail.com>
References: <20240305200503.57317-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IRQF_ONESHOT is found to mask HBA generated interrupts when thread_fn is
running.  As a result, some EQEs/CQEs miss timely processing resulting in
SCSI layer attempts to abort commands due to io_timeout.  Abort CQEs are
also not processed leading to the observations of hangs and spam of "0748
abort handler timed out waiting for aborting I/O" log messages.

Remove the IRQF_ONESHOT flag.  The cmpxchg and xchg atomic operations on
lpfc_queue->queue_claimed already protect potential parallel access to an
EQ/CQ should the thread_fn get interrupted by the primary irq handler.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 88b2e57d90c2..3363b0db65ae 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13055,7 +13055,7 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		rc = request_threaded_irq(eqhdl->irq,
 					  &lpfc_sli4_hba_intr_handler,
 					  &lpfc_sli4_hba_intr_handler_th,
-					  IRQF_ONESHOT, name, eqhdl);
+					  0, name, eqhdl);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0486 MSI-X fast-path (%d) "
-- 
2.38.0

