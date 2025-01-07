Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4388C158868;
	Tue,  7 Jan 2025 09:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736242806; cv=none; b=hFFEOOGVSR4t7jCvWupWCH6mbCH7VPker6bzmd+pVTMGsCKmggRCN+CbDH7RmvZfFSkSpid7HPWVqCrCGmbBmsFluwC6ymojuQ172Lqo8Q+pAR1Lf34UewgylLNtkGC4q5i5AzOD1xYyxq5jkGaIx3g+3+vPQVHHSpz28N7j+Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736242806; c=relaxed/simple;
	bh=vtLWhkQs8flJiusn4ywaTMHb162dpVyP5LOwRuHfYnI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lMJljKL91W71ki8gTEOp3Cuv79iAHjz+hBl7q3u1bCXOGqXk0YhFJorb1O+qT5ye438bXuQQSQpIgeE2DG35OOvyASmc8N3eCI+/dB9vF3Rv5bIlenRlZNH6GIvxAW2n89vu1dRtB/uHnJbyvl9FN3ODoLlA35TqhBWHpPfWMxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from icess-ProLiant-DL380-Gen10.. (unknown [183.174.60.14])
	by APP-03 (Coremail) with SMTP id rQCowACHjlpi9nxnP1EBBg--.12487S2;
	Tue, 07 Jan 2025 17:39:52 +0800 (CST)
From: Ma Ke <make24@iscas.ac.cn>
To: jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	James.Bottomley@SteelEye.com,
	jeff@garzik.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ma Ke <make24@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] [SCSI] raid class: Fix error handling in raid_component_add
Date: Tue,  7 Jan 2025 17:39:45 +0800
Message-Id: <20250107093945.829889-1-make24@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACHjlpi9nxnP1EBBg--.12487S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Gr15KFykGrykKryDWF1UAwb_yoW8Jr1xpr
	4xGa43C3yUGF409r9rZr1vvFyjk3yIya95uFWrCa429F93ZrySy34UtrW0qa4UJrZ5JryD
	Arnrtw18GFy8GaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9j14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
	Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
	W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI2
	0VAGYxC7MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7VUbsYFJUUUUU==
X-CM-SenderInfo: ppdnvj2u6l2u1dvotugofq/

The reference count of the device incremented in device_initialize() is
not decremented when device_add() fails. Add a put_device() and delete
kfree() before returning from the function to decrement reference
count for cleanup. Or it could cause memory leak.

As comment of device_add() says, if device_add() succeeds, you should
call device_del() when you want to get rid of it. If device_add() has
not succeeded, use only put_device() to drop the reference count.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: ed542bed126c ("[SCSI] raid class: handle component-add errors")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
---
 drivers/scsi/raid_class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
index 898a0bdf8df6..77c91dbf3b77 100644
--- a/drivers/scsi/raid_class.c
+++ b/drivers/scsi/raid_class.c
@@ -251,7 +251,7 @@ int raid_component_add(struct raid_template *r,struct device *raid_dev,
 	list_del(&rc->node);
 	rd->component_count--;
 	put_device(component_dev);
-	kfree(rc);
+	put_device(&rc->dev);
 	return err;
 }
 EXPORT_SYMBOL(raid_component_add);
-- 
2.25.1

