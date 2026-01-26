Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB40533A6F7
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2026 13:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769434612; cv=none; b=EG6ELUdRShZ5PPx8wGdWvgSMI/MTqne/UfWJdKYOgIDd6xH8IezEj1ALlB2lmThrifkjKyFhd7zZ+QT/a5Ld8Bg9gbSF2F1ZWWIkLOfmKmPbcSpoWSTIlrJYY+ku7EUEkQgYjBRlB189TJ7fiZYn83hycZmBZwQ/iDB/lgOI6Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769434612; c=relaxed/simple;
	bh=IeBUq0gU6ehrywsxBMMsAQ3EHjKPsxiZ3dbEJNzIzg0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UZduwy+BNx4f/XjbXFEJV2wNKGZki1aCgXkaHtJzb+oc86T8ZVDKhQ2Fov9rtoIKNpnVKz+ehpaAVYhgi68lxYndySqI6v9tc8bMeafBWz4Y9kws5PMA0sp4YZIxZQ3mPila4nkeouDj3t5gicF4Kar0JCVJe4+OxG/m+UmcZVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f08hP4zTDzKHMZn
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2026 21:36:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2C6024058F
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2026 21:36:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP1 (Coremail) with SMTP id cCh0CgA3pOnrbXdpsyh1FA--.8226S5;
	Mon, 26 Jan 2026 21:36:47 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: dgilbert@interlog.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: yangerkun@huawei.com,
	yangerkun@huaweicloud.com
Subject: [PATCH 1/3] scsi: sg: Fix sysctl sg-big-buff register during sg_init
Date: Mon, 26 Jan 2026 21:27:43 +0800
Message-Id: <20260126132745.1830629-2-yangerkun@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260126132745.1830629-1-yangerkun@huawei.com>
References: <20260126132745.1830629-1-yangerkun@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3pOnrbXdpsyh1FA--.8226S5
X-Coremail-Antispam: 1UD129KBjvdXoWrtryrAF1UZFyxJr1kur15Arb_yoWDGrX_C3
	yfXF4fXr1DKr4xG34DAF1UZFyv9a10vrs3Zr1aq345ArWUXrWDtryDZr13ua15GrW8Wa9x
	G3yjg34S9ry7ujkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUblAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r18M2
	8IrcIa0xkI8VCY1x0267AKxVWUCVW8JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
	4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY
	6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0aVACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxV
	Aaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l42xK82IY64kExVAvwVAq07x20xyl4c8E
	cI0Ec7CjxVAaw2AFwI0_GFv_Wryl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUIdgADU
	UUU
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

The sysctl interface sg-big-buff will no longer be available after this
commit. I believe this is a mistake, so fix it by invoking
register_sg_sysctls when everything is proceeding correctly.

Fixes: 26d1c80fd61e5 ("scsi/sg: move sg-big-buff sysctl to scsi/sg.c")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 57fba34832ad..c93cc9323f56 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1689,13 +1689,13 @@ init_sg(void)
 	sg_sysfs_valid = 1;
 	rc = scsi_register_interface(&sg_interface);
 	if (0 == rc) {
+		register_sg_sysctls();
 #ifdef CONFIG_SCSI_PROC_FS
 		sg_proc_init();
 #endif				/* CONFIG_SCSI_PROC_FS */
 		return 0;
 	}
 	class_unregister(&sg_sysfs_class);
-	register_sg_sysctls();
 err_out:
 	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), SG_MAX_DEVS);
 	return rc;
-- 
2.39.2

