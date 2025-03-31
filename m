Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675CC1ADC93;
	Mon, 31 Mar 2025 07:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.216.63.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743407733; cv=none; b=e8aArKlqPlkSdueqoIoQLaOG6UfZW5EMOtzC3UBursk2DzELQMnWEf0X1Rm/6qdbgUMWZrPmrs2U3RHIMS+LD897UDazzcfOTJ8EjKD0PqR94jjTt4SZgwcLK+nliVr/tzpOFE2yX4T8sdmQGr8MheS8OfSMrHSLMLMDzDjcMfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743407733; c=relaxed/simple;
	bh=VUKbKBaVh3xlTZoUznJu12czNySEyMf6Vn5I0VYQZ78=;
	h=Date:Message-ID:Mime-Version:From:To:Cc:Subject:Content-Type; b=feG2jWO7/jb9B5+MD+rFu28a0KvtkIRfQN9TNUOJ56BPrlLQP2S7ajfxaGsNuHcIlwpWeaLzWVcyDVy9dc/BAKVFF5A651vTZUzuttc6LLP15T/7xUOQkXO7dNIiHzHJqPT15yQWKwhYSRP6JuyKB+epw8StDunS8sLfjwEdhyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=63.216.63.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4ZR3MZ5SVBz5B1L5;
	Mon, 31 Mar 2025 15:55:22 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 52V7t8AT046377;
	Mon, 31 Mar 2025 15:55:08 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 31 Mar 2025 15:55:11 +0800 (CST)
Date: Mon, 31 Mar 2025 15:55:11 +0800 (CST)
X-Zmail-TransId: 2afc67ea4a5fffffffffb7a-972eb
X-Mailer: Zmail v1.0
Message-ID: <202503311555115618U8Md16mKpRYOIy2TOmB6@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <james.bottomley@hansenpartnership.com>
Cc: <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yang.yang29@zte.com.cn>,
        <xu.xin16@zte.com.cn>, <ye.xingchen@zte.com.cn>,
        <li.haoran7@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIXSBzY3NpOiBzY3NpX3RyYW5zcG9ydF9zcnA6IHJlcGxhY2UgbWluL21heCBuZXN0aW5nIHdpdGgKCiBjbGFtcCgp?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 52V7t8AT046377
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 67EA4A6A.007/4ZR3MZ5SVBz5B1L5

From: Li Haoran <li.haoran7@zte.com.cn>

This patch replaces min(a, max(b, c)) by clamp(val, lo, hi) in the SRP
transport layer. The clamp() macro explicitly expresses the intent of
constraining a value within bounds, improving code readability.

Signed-off-by: Li Haoran <li.haoran7@zte.com.cn>
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
 drivers/scsi/scsi_transport_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 64f6b22e8cc0..aeb58a9e6b7f 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -388,7 +388,7 @@ static void srp_reconnect_work(struct work_struct *work)
 			     "reconnect attempt %d failed (%d)\n",
 			     ++rport->failed_reconnects, res);
 		delay = rport->reconnect_delay *
-			min(100, max(1, rport->failed_reconnects - 10));
+			clamp(rport->failed_reconnects - 10, 1, 100);
 		if (delay > 0)
 			queue_delayed_work(system_long_wq,
 					   &rport->reconnect_work, delay * HZ);
-- 
2.25.1
