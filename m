Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC2F1DA113;
	Tue, 17 Dec 2024 08:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734423076; cv=none; b=dH76veBoLu5kGsVKgET9hmzayKFiFuFEmv3Y5pQivyU9HEWYembb0IM51HTqS9UK994IT+BcrjI/WEbPfgDt/DYMUaVPUQfgfC1P4BYTbOWvAJHsFDs8O4srO7Otl7xaxqFJzmGFsfY6lIOMHoK0NL2VtqFDuidjeOEXMMXIgsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734423076; c=relaxed/simple;
	bh=+tmVQNDbPLLjALMas9jkB+FitqvhPC+w92rzlYHAmaQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Psnv2tw+bj5L/tRCab12jOHpR77ubQaRXN27tKYJH+LslMiFsvgqOVHf8oJlx+slL0osMdDExz5Vfp/8lpGfIz5bNfieUD7Vdhnx1LCynO8bfopNzyAE5Qm2ldJKlyfBJ5DgcARp1uOUb9F0ZKB7z0dohvnyoi91QQV81zHxzHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=EMM+MPKT; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="EMM+MPKT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=rv8l9
	YFNfbS2Fc/AUsV3HzdcDIM3qTrTB46nCaLjGlg=; b=EMM+MPKTqMV6xOv8zQ/ot
	lvv10XN/krfZkJ1c5IJ/KCZ1k/hBOXfm4yTbgpHXRJPUWznI/kTQCxX/pCbZcmtC
	MKPz8fzTIcdoQ5DBOnxDas7bWM5Uts/LdXu4Wbtpe47pjbY/24zcCakXZIEiqkSb
	MIB90AawKLUfsyBd7GSphg=
Received: from icess-ProLiant-DL380-Gen10.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDXb4kGMmFn2IKJBA--.19125S4;
	Tue, 17 Dec 2024 16:10:49 +0800 (CST)
From: Ma Ke <make_ruc2021@163.com>
To: jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	jeff@garzik.org,
	James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ma Ke <make_ruc2021@163.com>,
	stable@vger.kernel.org
Subject: [PATCH] [SCSI] raid class: Fix error handling in raid_component_add
Date: Tue, 17 Dec 2024 16:10:39 +0800
Message-Id: <20241217081039.2911399-1-make_ruc2021@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXb4kGMmFn2IKJBA--.19125S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gr15JF48GrWrAw48ZFW3GFg_yoWkAFg_GF
	40vryIgr1Ikrs7XasxtanxZr1vgFsF93yfuFWIvFn3Zay3XFZFqr1DWrs0vryUW3yUXw17
	J3W5tr40vr409jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRZnYFUUUUUU==
X-CM-SenderInfo: 5pdnvshuxfjiisr6il2tof0z/xtbBFQC4C2dhLpU15wABsI

The reference count of the device incremented in device_initialize() is
not decremented when device_add() fails. Add a put_device() call before
returning from the function to decrement reference count for cleanup.
Or it could cause memory leak.

As comment of device_add() says, if device_add() succeeds, you should
call device_del() when you want to get rid of it. If device_add() has
not succeeded, use only put_device() to drop the reference count.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: ed542bed126c ("[SCSI] raid class: handle component-add errors")
Signed-off-by: Ma Ke <make_ruc2021@163.com>
---
 drivers/scsi/raid_class.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
index 898a0bdf8df6..2cb2949a78c6 100644
--- a/drivers/scsi/raid_class.c
+++ b/drivers/scsi/raid_class.c
@@ -251,6 +251,7 @@ int raid_component_add(struct raid_template *r,struct device *raid_dev,
 	list_del(&rc->node);
 	rd->component_count--;
 	put_device(component_dev);
+	put_device(&rc->dev);
 	kfree(rc);
 	return err;
 }
-- 
2.25.1

