Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4323911AF
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785450707; cv=none; b=Zlg7TJ1D875qZAyKQzqgW0wNwHrUxbXU0/xBj0VHVSIQ4AnUgk4/TIWKCEe+mRoGk9eTOGqqFiJRAtKQ3BucMbhrv45LFKKrH2ieuofa4Z58ol5KP701R6xyALFos28HA3sGq/qBngZYTO0E+Xirb+EFxoLIE/qmJ0qaJNfvYOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785450707; c=relaxed/simple;
	bh=ORt3zsmR4no2vhvSyjiTQsOa7Q0wCrn/yruJ1guQpeU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O0nO7f7qqOMXcJL+LoCyDa+iI/InELcRtvKgEMpYbnA2pNLbf/0jSv0Ci8+bm/Af3vhn78gy8/hj8/7E2XIUbRs+p6upGBESBHf+H2i2IY7kJ/xALZlLZMfmu1RW6Si/uJdfipt+WzzucNYhs0JpVq2yEWBIJdInw5kjGkiWPZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i1K6AIt2; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i1K6AIt2"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f752b3423so149825f8f.3
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785450703; x=1786055503; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PlKOnAY10vVaTbHY589tMDEBcYBV0lZutRarK9tzuxA=;
        b=i1K6AIt2oGQK1C/1ULu/lCC2bOkU94JwP7UtXA+NAjdK/PRRW5NekSZXbLT3eWsh7H
         Js42zXn2inUbJdyAv9d0M+QC3zHbp9YX4DeOhg0KWFkWS+/UpSjai0Yu/Krc2RRqLHbv
         9rjPaErrRTuWC8cEBGa0q9NHYFM4MaATtlCyyuegv+s01pcr4U2j39eVnRSl32THE1Yc
         675gabmzwMKIDSvWFGd345fJ/WB/pvNtIOQH0shU6jF/8LRJd+Rr2z2vtfxmuXWeKycj
         enSf7zp5AeGLgAh/9hvAOcj/4Ip4YdtAinxh0M5Y0Cm69wEyUUCl9QF0jGGOlMu7zQrg
         bvbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785450703; x=1786055503;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PlKOnAY10vVaTbHY589tMDEBcYBV0lZutRarK9tzuxA=;
        b=YYFAsx3vCJkCZ+zCHgECsmAbX+fg9bmeCm9nsszKOauiYcHH5tfA3cv298JyVOMKD8
         bVM2O14fJ8Xb5G8j+yt6Aqbs3GVD0f/xZdFwGsBmt0vyEIocY2tgA5/Nlv4FAKfvqLM4
         hwt47FYjHGJkZdM5yxt4v1JZfchfiwSC172MVI1nTuNncpTQJSWieojarmYzJ9C+BdMp
         Tr3QJZU7pWGa4P2b7nzMsviER49VuINwr+NjaifFUABpPwwvTuns+lnYZuXDfRC/gBhj
         4iZAfdgOP2GU6mSX6WQexKenBEg7R85mHmxZEjMUuHanW5+ZuhkOuwXu1PXgqdvjUBFT
         xBqw==
X-Forwarded-Encrypted: i=1; AHgh+Rox1siXWAqH74Zebj2+2y/xWcM/aTU7RsICp/ZvY/rsjVFLewvM/JnSQFSEZrdhdRYA+2ReZ/KUCbif@vger.kernel.org
X-Gm-Message-State: AOJu0YyePlsT+D4N10flBhRiOg4yHpJrc8alIEvZPxKbIuwDHztTn160
	+C3FKu1UeRNBTuLHdc8jsUnmUcVFUKQaf+GJCzfKhi3cGpihjQJWwPAB
X-Gm-Gg: AR+sD11IYjE697uNTf3FhLsZP++h/I2dr+twpblo9G61SMyGB7GQ5uUf2VhwTDDqhSs
	VCFjbECyqZnxAx7qXxrhoxSYQtwYmSsj03UKPu81tOLHmXTfGkA02pXp53adx3vbxnH1lk9rdNG
	D7RCKfCDB0xIjCCLuvD4f6vsCNFXgLhnl2uiCD6Zr6/1cWfjYAR0pw3a7bFJoecAw2+wrtGmca9
	rIdPwhifUCzaMERNXMBaNc5tT5Mjgg/MTERrlZQnjOOqXb1JkUcR+RHpfZSF7gVFcTcIB9UoiOY
	cGLwP9HpeXlXutLO4uRvJp8OprX+rtvpq7JpdHEo7ZtZZp9Laj/o22G9KoARmUPxd3rEMJAmsXc
	+v+FcxnHuJieMGt8Ar4S/CNOpXeLmh9UVJGIK7X/MG4FwYAgs3uTJ+mVBIDu2ITCmIlvn7LgWhN
	ZjoJzaXW6bPomm2g27PIEuYEGVSKKWxhxQwOOZkdNb1uwxx5dg2jaFaduUS88=
X-Received: by 2002:a05:600c:1f90:b0:497:fecd:5b00 with SMTP id 5b1f17b1804b1-49800e74e48mr58540825e9.9.1785450703407;
        Thu, 30 Jul 2026 15:31:43 -0700 (PDT)
Received: from localhost ([5.83.201.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49800f1a7f7sm110882175e9.5.2026.07.30.15.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 15:31:42 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Tyrel Datwyler <tyreld@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: ibmvfc: Fix spelling mistake "Deleteing" -> "Deleting"
Date: Thu, 30 Jul 2026 23:29:51 +0100
Message-ID: <20260730222951.352872-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a tgt_dbg message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index dfa231b6cc47..93b9f699c2e5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6141,7 +6141,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 
 		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
 			if (tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
-				tgt_dbg(tgt, "Deleteing NVMe rport\n");
+				tgt_dbg(tgt, "Deleting NVMe rport\n");
 				nvme_rport = tgt->nvme_remote_port;
 				list_del(&tgt->queue);
 				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
-- 
2.53.0

