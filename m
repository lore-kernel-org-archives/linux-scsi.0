Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7285C2900A0;
	Mon, 21 Jul 2025 11:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753097468; cv=none; b=WYZfRsB4O37LR/ULl93pH+k6UC8qgthbzYT/Mp6T/+QYt71+3dTWnzR/Na9CfPxWIogh7Qt7og/n/2RsU7vMugwVaFOBfkvW790JtyyQN3AKgwnIXXhbpgxZbKMEDFBxhhLi5dkiYVet9eJMhmBRMSO++kOmLijxNIzJnE3h4Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753097468; c=relaxed/simple;
	bh=ToflseDBkJ7JeScdTbOcRWTX+e6By2Q5HLseuMSonI0=;
	h=Date:Message-ID:Mime-Version:From:To:Cc:Subject:Content-Type; b=UbbT4nEvjhgisPVCXbszYDmbWDpiOPkeoM/KRpyHOiawBcuXQ1siYDpao9AvvUC3sGjqS032RFGuoj6FPVPuV0+RA/ECqK7zEFLuY1jYR9ohB9Rx9/5F92H1Brk2u3RVeqWc4LlAk8+0PWssGar3ZfSIIdx1/kbrBcRlQRfEufg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4blyrj6kLrz6FyBw;
	Mon, 21 Jul 2025 19:31:01 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 56LBUvWX043429;
	Mon, 21 Jul 2025 19:30:57 +0800 (+08)
	(envelope-from liu.xuemei1@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 21 Jul 2025 19:31:00 +0800 (CST)
Date: Mon, 21 Jul 2025 19:31:00 +0800 (CST)
X-Zmail-TransId: 2afb687e24f4ffffffffd23-0878a
X-Mailer: Zmail v1.0
Message-ID: <20250721193100468gyyO8d5CbSflXqevXFgIM@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <liu.xuemei1@zte.com.cn>
To: <njavali@marvell.com>
Cc: <james.bottomley@hansenpartnership.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liu.song13@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIXSBzY3NpOiBxbGEyeHh4OiBVc2Ugc3RyX3RydWVfZmFsc2UoKSBoZWxwZXIgaW4gcWxhMngwMF9hbGxvd19jbmFfZndfZHVtcF9zaG93KCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 56LBUvWX043429
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: liu.xuemei1@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Mon, 21 Jul 2025 19:31:01 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 687E24F5.001/4blyrj6kLrz6FyBw

From: Liu Song <liu.song13@zte.com.cn>

Remove hard-coded strings by using the str_true_false() helper function.

Signed-off-by: Liu Song <liu.song13@zte.com.cn>
---
 drivers/scsi/qla2xxx/qla_attr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2e584a8bf66b..e58658ade770 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/string_choices.h>

 static int qla24xx_vport_disable(struct fc_vport *, bool);

@@ -1722,7 +1723,7 @@ qla2x00_allow_cna_fw_dump_show(struct device *dev,
 		return scnprintf(buf, PAGE_SIZE, "\n");
 	else
 		return scnprintf(buf, PAGE_SIZE, "%s\n",
-		    vha->hw->allow_cna_fw_dump ? "true" : "false");
+		    str_true_false(vha->hw->allow_cna_fw_dump));
 }

 static ssize_t
-- 
2.27.0
