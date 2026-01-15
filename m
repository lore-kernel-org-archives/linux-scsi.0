Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4904D29ACDD
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 17:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497119; cv=none; b=bCR36nFe8JgrQ+Cq5DrrKqsYnPpZCDCkb52G5QNSIZ2VeXeIDZp8NBtTj17oyibJnCVFu0HOBUD6FmwtS6NEiApT8uFraAA6l+lKVSiVMTeU8Tw8CO4+Fszxwmx8vxBwtsuyE4htuO7e4Vi+fAH0cx9mxnBQdv+6UWSdKA0C3Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497119; c=relaxed/simple;
	bh=5jvT77sR0fzLjhtGZIstKrpDDk4IPsEN3tBAzUsO4vE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GdVhzferyUB6ogxlXxZMDvhdO1aqVLLHFeggxi8G3F11V8Mw7gkZ6js3Ki0Q1mSM03WLCYXnu6646EzINUq02qipR6iby2Irhd9fgeb1xk2Abkdsebn2HBJ+Y0lHpbFC6gM83lmdKGdgvP+OhQ5Gj7x5yrkcxHxkIcLhcq20P2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ip276U89; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ip276U89"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47eda5806d7so1349265e9.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 09:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768497117; x=1769101917; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JfnPKfCJdkhp9EqSDp2pIOhI0ZkfZNyhP7oMAkYw2+4=;
        b=Ip276U898QP/2QCdBWUtZ7pbxNZMfO3TgNz6+JWQ3mQbPcDIVhBvlImXfvFzcdQ2VW
         qR1RbKwUfUvoajw1cnoNdimtiTfiAHnr3LzcDuaS365OZsVptR9Hvq/0hDFuiwDFwlaF
         /6+oTZrqFlHztT8qHMYjnh5h9Q5ozG895HdA1gpHBdh1CTCKzkzmoDQrL/Z2hTuH5srI
         /aRC0n6XsI4LuDMa1Z/6oSYXzJV49OhsTgNGLyUZZrtNjCQoj3MYRDV6QhzNQgh1ZdAl
         VQO5B+Fiw3M3kFdy+uBsBNeDgVftUlNEhKrdx5ejggZnoSR5An9RA4Z0ynBdoM9X2NGX
         Z6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768497117; x=1769101917;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JfnPKfCJdkhp9EqSDp2pIOhI0ZkfZNyhP7oMAkYw2+4=;
        b=oQlXwSz7xwfdQP3/uL30us+4dF45zA9BbiG2y3wb8BDszwK0bqmBpf7DmoEb+/mDq4
         IZZ8iuPX8AsVByKpUaL3y8DWryfGqBmkgRCUTH/xm4z5MeMlCDjhrLHeaPK8K2MO3cbo
         Q6EDUUI+nl9oTfLux0qqb375C7v0qLqKUd2L+zjUyGL7BcD3SVw2ExFpWW02Q/ZQsBf9
         W3rOQA4R19QC1NfF3CUwqSwpCTQRBEuxCkNtNkxXn5ul7NDNiXvegyYKPkV+gYobkFRp
         8VxZIjoBLhMQxZkhadKAlPt8gm6Lks6M7UYWo62eb0simuSieXsFmq8KPHViguOY3Sp0
         996w==
X-Forwarded-Encrypted: i=1; AJvYcCWyUxss1ZZM3OEoo1O3/vRXeT2kXUswEhwUYeRTTn3YBFnHs7MCJ8bg8HC33x/g2HiP8zS7ZOz9QyQn@vger.kernel.org
X-Gm-Message-State: AOJu0YxN5kH4x317zcPslpM6nW0qOXpTOu5xodRtg3UxekE5fjQKFUAr
	XPWXovFgkibeURxnuNLPtRx571CEJuhwarTGJVR93eQTjW9y3vHmpbvO
X-Gm-Gg: AY/fxX6y5Zpa01KyI9QT6Saic1VRNLJ5A/JhRSjLUvcFdc2h5ghTxWi3IBQd5g3zzr/
	c+fYpaWk1RYWnVbyzp/MyNTX6Vrmwv99Mie0VG87WfIy8ZyNAely4pbZ47+c3TbziuXQN8foEAk
	QMeQfjbNKRaIvD9gqiyETT4usCOU4ABS1IzJC0wajxO58vQjW4hnyYzSXJRTPpYF0/KfL+sakU+
	zcJp8PDkp0OEcUvfvWBhgj3I2B/dfWh4z+Fsjo76cfPZi/7G0Uo5J+tfTPcWARJsWp+OTr9u1Lb
	3wW5SDGMWKAdhtDXaDxBOofLqSjUd2KPFMM/INLCD2aWWxh+sORbn2Hj8Psq2cFd4tp0xwOhd6W
	RmzSJqajsxg6MT5NEXIT+ZGCHo7eRw/GbsUPl8EXH6z8Q3TEKGNK9u9/wQCc0A/Mih0l3WBq//a
	NKWJIlNJgjxX800/vVqGuYyB8PZatd6yQL0g5pMUdAueL5J70g8ZSrZ/EgKxla9fzxAVGh
X-Received: by 2002:a05:600c:4e43:b0:477:a478:3f94 with SMTP id 5b1f17b1804b1-4801e347e3bmr3517515e9.5.1768497116436;
        Thu, 15 Jan 2026 09:11:56 -0800 (PST)
Received: from 3ce1e5d2d1b2.cse.ust.hk (191host009.mobilenet.cse.ust.hk. [143.89.191.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435696fbea8sm223315f8f.0.2026.01.15.09.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 09:11:55 -0800 (PST)
From: Chengfeng Ye <dg573847474@gmail.com>
X-Google-Original-From: Chengfeng Ye <cyeaa@connect.ust.hk>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <dg573847474@gmail.com>
Subject: [PATCH] scsi: pm8001: Fix data race in sysfs SAS address read
Date: Thu, 15 Jan 2026 17:11:40 +0000
Message-Id: <20260115171140.281969-1-cyeaa@connect.ust.hk>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chengfeng Ye <dg573847474@gmail.com>

Fix a data race where sysfs read pm8001_ctl_host_sas_address_show() reads
pm8001_ha->sas_addr without synchronization while it can be written
from interrupt context in pm8001_mpi_get_nvmd_resp().

The write path is already protected by pm8001_ha->lock (held by
process_oq() when calling pm8001_mpi_get_nvmd_resp()),
but the sysfs read path accesses the 8-byte SAS address without
any synchronization, allowing torn reads.

Thread interleaving scenario:

           Thread A (sysfs read)     |    Thread B (interrupt context)
-------------------------------------+------------------------------------
pm8001_ctl_host_sas_address_show()  |
|- read sas_addr[0..3]               |
                                     | process_oq()
                                     | |- spin_lock_irqsave(&lock)
                                     | |- process_one_iomb()
                                     | |  |- pm8001_mpi_get_nvmd_resp()
                                     | |     |- memcpy(sas_addr, new, 8)
                                     | |        /* writes all 8 bytes */
                                     | |- spin_unlock_irqrestore(&lock)
|- read sas_addr[4..7]               |
   /* gets mix of old and new */    |

Fix by protecting the sysfs read with the same pm8001_ha->lock.

Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index cbfda8c04e95..e49f11969b3b 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -311,8 +311,15 @@ static ssize_t pm8001_ctl_host_sas_address_show(struct device *cdev,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
-	return sysfs_emit(buf, "0x%016llx\n",
-			be64_to_cpu(*(__be64 *)pm8001_ha->sas_addr));
+	unsigned long flags;
+	ssize_t ret;
+
+	spin_lock_irqsave(&pm8001_ha->lock, flags);
+	ret = sysfs_emit(buf, "0x%016llx\n",
+			 be64_to_cpu(*(__be64 *)pm8001_ha->sas_addr));
+	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+
+	return ret;
 }
 static DEVICE_ATTR(host_sas_address, S_IRUGO,
 		   pm8001_ctl_host_sas_address_show, NULL);
-- 
2.25.1

