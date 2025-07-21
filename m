Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1755F22EF5;
	Mon, 21 Jul 2025 12:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753099306; cv=none; b=sdZ871iJBvUNQ1QOBnspYYHfJGYE2Ef256/cZ5h0R2dYqZWU8dI8EEUJY6QcJTd7+70j+siBi9nAevY24Fefsp8ImbAnGvvAo7O/P0SisqtzuK/E0hOgQtXbPeCcl/9VVkkO96QZ5y3880Y7jaWm9QSuFmGmvtIZ5dK19az5Sdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753099306; c=relaxed/simple;
	bh=Wb+HX4VKOUFl91tCoHBuhfncV72kvghandqQDQ/1Yxk=;
	h=Date:Message-ID:Mime-Version:From:To:Cc:Subject:Content-Type; b=O+cAYsRfqlrgPuUxnIBb68ZDTxtKjYlbL8iySvoeSo10OukzH5acdKzp0z+T/826V1dWjgFSKY7rSzvHqKS2uCc+u/WFnGiZv3Y23b1tIP7gE3CkiQ/K90jI6ECFgRHuJuD8DF2v2J3lM5vtGTHdkeC33l3SYWnyKkeKicPhAv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4blzX05sh2z8Xs70;
	Mon, 21 Jul 2025 20:01:36 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 56LC1Z4p001219;
	Mon, 21 Jul 2025 20:01:35 +0800 (+08)
	(envelope-from liu.xuemei1@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 21 Jul 2025 20:01:38 +0800 (CST)
Date: Mon, 21 Jul 2025 20:01:38 +0800 (CST)
X-Zmail-TransId: 2afb687e2c22ffffffffd82-2e7c3
X-Mailer: Zmail v1.0
Message-ID: <20250721200138431dOU9KyajGyGi5339ma26p@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <liu.xuemei1@zte.com.cn>
To: <james.bottomley@hansenpartnership.com>, <martin.petersen@oracle.com>
Cc: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
        <huobean@gmail.com>, <peter.wang@mediatek.com>, <tanghuan@vivo.com>,
        <liu.song13@zte.com.cn>, <viro@zeniv.linux.org.uk>,
        <quic_nguyenb@quicinc.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBzY3NpOiB1ZnM6IGNvcmU6IFVzZSBzdHJfdHJ1ZV9mYWxzZSgpIGhlbHBlciBpbiBVRlNfRkxBRygp?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 56LC1Z4p001219
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: liu.xuemei1@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Mon, 21 Jul 2025 20:01:36 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 687E2C20.004/4blzX05sh2z8Xs70

From: Liu Song <liu.song13@zte.com.cn>

Remove hard-coded strings by using the str_true_false() helper function.

Signed-off-by: Liu Song <liu.song13@zte.com.cn>
---
 drivers/ufs/core/ufs-sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 00948378a719..4bd7d491e3c5 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -5,6 +5,7 @@
 #include <linux/string.h>
 #include <linux/bitfield.h>
 #include <linux/unaligned.h>
+#include <linux/string_choices.h>

 #include <ufs/ufs.h>
 #include <ufs/unipro.h>
@@ -1516,7 +1517,7 @@ static ssize_t _name##_show(struct device *dev,				\
 		ret = -EINVAL;						\
 		goto out;						\
 	}								\
-	ret = sysfs_emit(buf, "%s\n", flag ? "true" : "false");		\
+	ret = sysfs_emit(buf, "%s\n", str_true_false(flag));		\
 out:									\
 	up(&hba->host_sem);						\
 	return ret;							\
-- 
2.27.0
