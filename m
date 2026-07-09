Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C403A1E81;
	Thu,  9 Jul 2026 04:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783572039; cv=none; b=rY3MVdwoFS4ZOCejLi16MLMpN9ELFGZvJ0jV08yuApyMyZX/RFL9VyjCJHTPh/vyzhs96JfeImMTTefku8POjo1rXsFDNs+KVM0KxS5mmjcRSJXObll66a72e7LYUvwivmNKya37y/sk6rMHFfVD820q4Bwg9M9Fw755PqXiAB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783572039; c=relaxed/simple;
	bh=pHnQGHoE7Mm1rXl414hI51iA5lcUF3Cd3POY/6PqgPw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qxFojriZqYNk4Gf4cTWfcSAFdy0TZIX85bNmVAPFY0TkflSiL0CITGKa3Gh1QcQXzyvrAKiykDTPQRHCmZUtdQ+Vj666/NcS0flHi1xdRgSB0DM7JKWF5GzEe+HPXIZO1TMJpfyJLzfAR4URduiBNJb+YcGk2GItKRHLmRrLDag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gwj1l6f0czKHMPK;
	Thu,  9 Jul 2026 12:40:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id CD22340594;
	Thu,  9 Jul 2026 12:40:28 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgBHWHQ4Jk9qUIhNAg--.33862S4;
	Thu, 09 Jul 2026 12:40:28 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: bvanassche@acm.org,
	dgilbert@interlog.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	yukuai@kernel.org,
	hch@lst.de,
	axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	yangerkun@huawei.com
Subject: [PATCH v2 0/2] scsi: sg: validate and clean up scatter_elem_sz handling
Date: Thu,  9 Jul 2026 12:32:32 +0800
Message-ID: <20260709043234.2447340-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHWHQ4Jk9qUIhNAg--.33862S4
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYL7kC6x804xWl14x267AKxVW8JVW5JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
	64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r
	1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628v
	n2kIc2xKxwCF04k20xvY0x0EwIxGrwCF04k20xvEw4C26cxK6c8Ij28IcwCF54CYxVCY1x
	0262kKe7AKxVWUtVW8ZwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_
	Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU173ktUUUUU==
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

v1->v2:
1. Split into two patches, patch 1 is the minimal bugfix that adds
validation to the scatter_elem_sz module parameter; patch 2 does the
refactoring
2. Rebased; no functional change versus v1.

v1:
https://patchwork.kernel.org/project/linux-scsi/patch/20260708063045.2008478-1-yangerkun@huawei.com/

Yang Erkun (2):
  scsi: sg: validate scatter_elem_sz module parameter
  scsi: sg: clean up scatter_elem_sz handling and module param
    permissions

 drivers/scsi/sg.c | 68 +++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

-- 
2.52.0

