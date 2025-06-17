Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ABD2D23A0;
	Tue, 17 Jun 2025 10:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750154622; cv=none; b=jwj/hN+dhfgE1HIEpKP2bfRqhb2Do2H4+LdMRlKZy4ZsD14nxwW/Mu+61vsZhNnyYOeLkqPrqHXiHoC3cQ3AuhYkeLwEjgcamyuneMZNNFBDBb/iVa5t+LSrJ4BLOZ8idNHQdwsSZlr5WJMmgSxkRxn9Z0IbjuKmuxVlMmphbEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750154622; c=relaxed/simple;
	bh=xZzaPQlpIrbi97YOWHoRLymCctu5qDd1ggIffT6vUE8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aG6NT9v02w7JeW3t7h2zdkHwCvQiT6D6kVRKsEoqi9oRyJwVpcZ+CKSKAfFdvr1JfzI+zAXWzLRpB2yKI0HP7PKvHnNMDR0RL/IjIFKtWNLjSw/s6cI4uaDlw14Ro84gKrWheXo5G/Hk4ETEtVQPMy50mQJIGCVBqh1ImxXMniw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=GAhz8S16; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="GAhz8S16"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1750154618; x=1781690618;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xZzaPQlpIrbi97YOWHoRLymCctu5qDd1ggIffT6vUE8=;
  b=GAhz8S16Lqg3L1mvXAxROnHdsNHlkYt8+nFWFPnfQVAWDsG7wEFfFfGo
   D7Pyqn/qkY0ErHfVjMpVpR824SOZF2Ljzw9qiXLqnqMW6KBKy84L/bF5/
   VFcXepQoxNCWx7YCkxwmqMRKW/ZscWyJRSBgJnZHXqSNwb/xi4N///ceV
   tRvjmahkeN+jb4ztJKq0T4HMYzbhamZdGQ2ZHxGth8THW6XWrhH0eL1zG
   4fajMSKZfn8cZZdc+JBufzFhAI2GjBdbYhZcWPH7WBSoOByTp/VEoxi6+
   r3xrInsY5V2igjq6KYEMQaKBkIyDjPuYhzJ8PlUOYCGeVn7JMUOEpVeXM
   Q==;
X-CSE-ConnectionGUID: X8cbpjJVSGOYowb9bnn4Fw==
X-CSE-MsgGUID: 9V0J9rmrSxCt9YDCltm0BA==
X-IronPort-AV: E=Sophos;i="6.16,242,1744041600"; 
   d="scan'208";a="84195219"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2025 18:03:37 +0800
IronPort-SDR: 68512f06_EDsh+emL2h8ARRUQoKa8uCmBB8XinhrVMKqakuy4+CRnc1/
 Y/8J5mRXuZfl1oprUG0aot/kHHHX8LbZMdiDB2w==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jun 2025 02:01:58 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jun 2025 03:03:36 -0700
From: Avri Altman <avri.altman@sandisk.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>
Subject: [PATCH 2/2] scsi: ufs: Document NOP_OUT transaction code
Date: Tue, 17 Jun 2025 12:56:11 +0300
Message-Id: <20250617095611.89229-3-avri.altman@sandisk.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250617095611.89229-1-avri.altman@sandisk.com>
References: <20250617095611.89229-1-avri.altman@sandisk.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

UPIU_TRANSACTION_NOP_OUT is 0x0, which is the default value after
memset. Comment out the explicit assignment and leave it as
documentation.

Signed-off-by: Avri Altman <avri.altman@sandisk.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c2048aca09fc..84165b45467d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2835,7 +2835,7 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 	memset(ucd_req_ptr, 0, sizeof(struct utp_upiu_req));
 
 	ucd_req_ptr->header = (struct utp_upiu_header){
-		.transaction_code = UPIU_TRANSACTION_NOP_OUT,
+		/* .transaction_code = UPIU_TRANSACTION_NOP_OUT = 0x0, */
 		.task_tag = lrbp->task_tag,
 	};
 }
-- 
2.25.1

