Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A9133A9E5
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2026 13:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769434617; cv=none; b=rR5q1cfKGa15+xIJQBpgcKTCVM3RGUWYD9L/93Wcxx03+/Eypn48R1Mr8vqm8o//uqDuNPHPTbfJA3DK8punWx/lOzYn19Rrzs2L5WgYy7yxrS7FUVzlteXTNvEKdxpxh2GYM2pF5/7op7dXuSZb7yjRSb751LDSRgde3gLjick=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769434617; c=relaxed/simple;
	bh=gzFvtJrUiWIlVV+um4JggUkkviV/hcZaCHJ+jJjXFDw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F7WTZBQFqEdiySNrC2TJakuhdZTOgWC9i17rvS70Q8ksVgZWIYzaCxpjkaQ0kw678oSJ7gHAYkN+DuYF8YmxgVmaVW+1ESo7G3UCPTaT9hrHRvTW/iQzXTo4QdxFStkcNAwV/Ez1DST9dcDdebXbMxkbAtYSauN8lPWAnfaGbd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f08gx1FSLzYQv0G
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2026 21:36:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2406940575
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2026 21:36:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP1 (Coremail) with SMTP id cCh0CgA3pOnrbXdpsyh1FA--.8226S4;
	Mon, 26 Jan 2026 21:36:46 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: dgilbert@interlog.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: yangerkun@huawei.com,
	yangerkun@huaweicloud.com
Subject: [PATCH 0/3] scsi: sg: minor bugfix and cleanup
Date: Mon, 26 Jan 2026 21:27:42 +0800
Message-Id: <20260126132745.1830629-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3pOnrbXdpsyh1FA--.8226S4
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYZ7kC6x804xWl14x267AKxVW8JVW5JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
	64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r
	4UJVWxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0aVACjI8F5VA0
	II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY64kExVAvwVAq07x20xyl4c
	8EcI0Ec7CjxVAaw2AFwI0_GFv_Wryl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUoMa0
	DUUUU
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

Yang Erkun (3):
  scsi: sg: Fix sysctl sg-big-buff register during sg_init
  scsi: sg: Resolve soft lockup issue when opening /dev/sgX
  scsi: sg: Remove deprecated sg-big-buff

 drivers/scsi/sg.c | 88 ++++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 50 deletions(-)

-- 
2.39.2

