Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94B026CE04
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 17:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499711; cv=none; b=ZebrWwVDAdWbybUgT/gnravR2OfmViUSA3/b/GM8GNtTG87sH6stkZNMRTQeg6K/rEM7rYp6KGzrWI9ItBuY6nkO0SJpXqW1uil24DyxHUjYM0ktwmty0QPpyhydOLeThTafpunSUt9VxiQSi2+BA6FjtF93fGLl7dva7rgl2lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499711; c=relaxed/simple;
	bh=MqmlUOsxZneWqDKpjVCzlCG7btKXMepBIX9IyGAR6Xc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fMpG/FC2pbPzAjF6NleUkkopZAkij7j1E1Y83WCUFnyHVl1CEUmXhtBBiH1rUMqMgjVcQALggi7DdUOUftLSC3cl8CpAOZ3YB0G3/fHpx7WikThKqcYFR6pSMh1ccFyxTGMTxIOWDd8A6UlFqPOxD4a4lRIqRBRisLsX3pL9ijo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F3q5GdKL; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F3q5GdKL"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47edbae8307so757865e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 09:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768499708; x=1769104508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vRlkuk5+fZOWULCdvOCYb0Wj0W82y/EU5qrOHGX+/yA=;
        b=F3q5GdKL512UPCsJBzBJ4zMEt9oJFdQ9RmKJW9bLSHBuJUEeEWHRBjsud8kw/zTMl8
         b7CjbE8YCR/WEYPoP/it/4EYEJElhKoViDXOdRD9s/qypChN1mx8KHbX3tPqzHstGisw
         AnGTE08Qx+bbercDTswmCqBp+pyR6kHB7cyniRL229+YLgeRxirbWMSTB3qLD2MJ6LeZ
         98jyGGVOCC0mtisc5kXRF6h06w94sgXQM3mp7G96iiv2UhB0TlLCHxIelmUEf11v8JXY
         zsJoU8Z81RzxCq9muiYyK3Lx7cRGpNOvxbj0EE8peEPjdqmjktNM68yfWzDesJDrXDWS
         J/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768499708; x=1769104508;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vRlkuk5+fZOWULCdvOCYb0Wj0W82y/EU5qrOHGX+/yA=;
        b=AA2pPWR41hcwvgyHjDqfgbzl1+WlDoOpOEHVwIqZgJtvwtmbW6s2ZNqx5mMKrKdKjj
         z9z4kqJJf9O7faXUpEwe+IHAEWE6M1bUS+XEKsSeVt70rrr3BWtWepm6f+KIT88mTJxq
         a1KspjQN7t5gLOYIVYHeUPuRW5PlKSEC9508agFhkNdxqC3AX4KpF/oS5Dj03QZywnKQ
         qAXJTtBvuLJ7upAUYhc4oGrMOxAKOg1no4I4rVXS+wPf2jnWJoSSr3BU5YI4YBhOWbk8
         U4NESIIEuyMDLXKPr9tTV/NhX6Z6Pe9d5C/WBfrgiCrt2iQRf2nN2B7uW6PJfV2oq6rd
         6tWw==
X-Forwarded-Encrypted: i=1; AJvYcCUwK/BeJLF19fYPETIKB+pAJYD08W6NoMuDBHd0kiPTsxjgKBHnDZp0AIHzE5mDp5WDKNPQ8f6vqfVv@vger.kernel.org
X-Gm-Message-State: AOJu0YxJm8fsrJEw0W2x8KfZdtzfoBm6V5zL0CpVRTU+EWveSxDf3l9e
	LjaUTi+ILXgvOEZBuLoER39A+SS6ObU4Tt6S+T52Q2GlNv3L19tgPOVh
X-Gm-Gg: AY/fxX6tOo2Wgh2vLznfvjEyQPHBa+BkrpMTIAm/rEmNW8WIWDGyAjkiRaiAotJ82gO
	E8Tc4oyAQ4c9CafnSGOnaQVs0m5i1aO5CGDR8oublscGObGXGl/3LkJWDDkMR4ALdaxUalpAIvm
	N6g5ZmaoM6TuDWKtqbNE8UhHOLj2MWmo576ecouY0Sq3ys3uCEBzvpIc/+9kxVQ45G1tEv8Z5H+
	nMPslU64UG2Ul8qFM9QzbYs0I7WrEhSHGO5D/pr3sjBa6VZlYHE4/Y8GajcHoYXCYllRvOdt9rH
	vanxZWzHrMkHHiAwmGnyufpWw9ColSBNkJaWGtkgX751Q2aGmiW1KijAa+kw0bGU17+Ya5fJIVm
	zSZLHjk12xH+M/xlWjhkHhUwp38R7R0ig+MrTgDf4VsXP20IYYEcZZoPWu6bHzDO05J0old/0Oz
	gaDt684yEkGRNIse2hNNjXdqHJ1xT7GdPrEOFvWKzU9rpnykg15YzBobhcx7o=
X-Received: by 2002:a05:600c:19cf:b0:47d:3ffa:9838 with SMTP id 5b1f17b1804b1-4801e313752mr3992065e9.1.1768499707985;
        Thu, 15 Jan 2026 09:55:07 -0800 (PST)
Received: from 3ce1e5d2d1b2.cse.ust.hk (191host009.mobilenet.cse.ust.hk. [143.89.191.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4b2672d6sm59459595e9.14.2026.01.15.09.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 09:55:07 -0800 (PST)
From: Chengfeng Ye <dg573847474@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <cyeaa@connect.ust.hk>
Subject: [PATCH v2] scsi: pm8001: Fix data race in sysfs SAS address read
Date: Thu, 15 Jan 2026 17:54:27 +0000
Message-Id: <20260115175427.290819-1-dg573847474@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chengfeng Ye <cyeaa@connect.ust.hk>

Fix a data race where pm8001_ctl_host_sas_address_show() reads
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

Fix by protecting the sysfs read with the same pm8001_ha->lock
using guard(spinlock_irqsave) for automatic lock cleanup.

Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
---
V1 -> V2: Use guard instead of lock/unlock pair

 drivers/scsi/pm8001/pm8001_ctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index cbfda8c04e95..200ee6bbd413 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -311,6 +311,8 @@ static ssize_t pm8001_ctl_host_sas_address_show(struct device *cdev,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+
+	guard(spinlock_irqsave)(&pm8001_ha->lock);
 	return sysfs_emit(buf, "0x%016llx\n",
 			be64_to_cpu(*(__be64 *)pm8001_ha->sas_addr));
 }
-- 
2.25.1

