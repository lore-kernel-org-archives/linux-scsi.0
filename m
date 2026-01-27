Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060F6329E67
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 06:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769495402; cv=none; b=eKN2xt77RAxRsBYwSYeAmm3lImrKhpndBAUF6xGlWsGN3GJYHOz33On8VDqfI5uHAZQapw174MqH1lrVOW/48xxIz2yEB6kCol9h/pukAOBEwq4muU61rtlFnWIGPa3IhIydndUh9vqaLJUz103yplkNWHiuzGQ8wbz3w41CtM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769495402; c=relaxed/simple;
	bh=8vGU75+d94Bv/BjFtf5ABGVqAmnG0uL7fV7ExStXjsk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QUh4OI1gvy45tjHQJsMlNb6Gr/0ep84U0vDLuMC90BI5dGZJYXPEumHvC3Hhw26wueAuNkLEeIUgCavFN/uoEy4vaSdfJfv7GhCDNQeN93Gv24KqYLwQCgZWPyaeSbPjIg/MPrd0n2ozvhYFiy3Sb/3N5FxQG+HgVanTsH/9BXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f0b9K2bqTzKHMN0
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 14:29:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E264A4056E
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 14:29:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXxfVZW3hpL_QVFQ--.16598S5;
	Tue, 27 Jan 2026 14:29:51 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: bvanassche@acm.org,
	dgilbert@interlog.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: yangerkun@huawei.com,
	yangerkun@huaweicloud.com
Subject: [PATCH v2 1/3] scsi: sg: Fix sysctl sg-big-buff register during sg_init
Date: Tue, 27 Jan 2026 14:20:42 +0800
Message-Id: <20260127062044.3034148-2-yangerkun@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260127062044.3034148-1-yangerkun@huawei.com>
References: <20260127062044.3034148-1-yangerkun@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXxfVZW3hpL_QVFQ--.16598S5
X-Coremail-Antispam: 1UD129KBjvdXoWrur1xXw4xAFWfuryxAF1fZwb_yoWDGwc_G3
	ySqF4fXr1UKr4xG34DAF1UZFyv9a1jvws3ZF1aq34YyrWUXr1ktryUZr1Uuw45GFWxua9x
	Gw1jgrWS9r129jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUblAYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r18M2
	8IrcIa0xkI8VCY1x0267AKxVWUCVW8JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
	4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY
	6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0aVACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxV
	Aaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l42xK82IY64kExVAvwVAq07x20xyl4c8E
	cI0Ec7CjxVAaw2AFwI0_JF0_Jw1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzE_MUU
	UUU
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

Commit 26d1c80fd61e5 ("scsi/sg: move sg-big-buff sysctl to scsi/sg.c")
make a mistake, sysctl sg-big-buff was not created because the call to
register_sg_sysctls was placed on the wrong code path.

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

