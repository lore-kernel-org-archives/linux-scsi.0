Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB02D4D7D2F;
	Thu, 17 Sep 2026 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789656008; cv=none; b=i7QwPGf/e9F95+O9rfORfES9mxdoA+B2AXLL//n/ravnzwiavFASu2Wl1kHKCgM80/M+SadWnE7fu/FXIYJzS49ZLtJowSR+AX+zITQuQKoTs4c/P5xfMkm1d3HymwtG4TDduC+siNRYWFF7u5i+dT0GMz3pmsa5FpIARvSkNDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789656008; c=relaxed/simple;
	bh=UQd++g2MZYKtVFFn9rNTlYGYNrpBrPJep7M7ltcYHxg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=X5mq0+XAwA8u0DfSe97kaPwwcVyd4CihOFw31fxDB/FoSJN/q+pI5ZGMMO9h8AMFUWXiDPY2znZ8qbRDE94M9eppll3nqP/mz55YQ5Crvg2fYh7/8LWBeaNihVUSx6l928dDYetVaRs6S+tBWf7GXxyBzARX/qmuXkX+7VcmwOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowACXADuy+6tqwq+CCA--.4889S2;
	Thu, 17 Sep 2026 22:39:46 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: JBottomley@Parallels.com
Cc: James.Bottomley@HansenPartnership.com,
	djbw@kernel.org,
	john.g.garry@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	yanaijie@huawei.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: libsas: Fix use-after-free in sas_eh_handle_resets()
Date: Thu, 17 Sep 2026 14:39:46 +0000
Message-Id: <20260917143946.2157366-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACXADuy+6tqwq+CCA--.4889S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr17CF17GryfXry3Ww1rWFg_yoW8Gr1Dpr
	Z5Jay3CFW8Gw4vganruw1FgFyYvan2g348GFWfKay8G3WrX34YvrW8CFWjqFy8Jry8CFZ0
	vr47t3yrW3WUArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPvb7Iv0xC_tr1lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI
	0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
	Yx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26F4UJVW0owAm72CE4IkC6x0Yz7
	v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0E0s8F02x267IIx4CEVc8vx2IErcIFxwAC
	I402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrw
	CF04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E
	5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtV
	W8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY
	1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14
	v26r4UJVWxJr1lIxAIcVC2z280aVCY1x0267AKxVW0oVCq3bIYCTnIWIevJa73UjIFyTuY
	vjxUFsjjDUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgUNA2qr888SPwABsc

sas_eh_handle_resets() drops the reference it took on the domain device
with sas_put_device() and then accesses dev->state again while holding
ha->lock. The put may release the last reference, so the clear_bit()
can touch freed memory.

Clear the pending flag first and drop the reference last.

Fixes: 5db45bdc87ce ("[SCSI] libsas: enforce eh strategy handlers only in eh context")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/libsas/sas_scsi_host.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index c83282733ec4..14ca19c93c32 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -680,10 +680,15 @@ static void sas_eh_handle_resets(struct Scsi_Host *shost)
 		if (test_and_clear_bit(SAS_DEV_RESET, &dev->state))
 			i->dft->lldd_I_T_nexus_reset(dev);
 
-		sas_put_device(dev);
 		spin_lock_irq(&ha->lock);
 		clear_bit(SAS_DEV_EH_PENDING, &dev->state);
 		ha->eh_active--;
+		spin_unlock_irq(&ha->lock);
+
+		/* dev->state is no longer used, this may be the last reference */
+		sas_put_device(dev);
+
+		spin_lock_irq(&ha->lock);
 	}
 	spin_unlock_irq(&ha->lock);
 }
-- 
2.34.1

