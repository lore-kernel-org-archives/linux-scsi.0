Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795746840;
	b=pTritIlbqFWVHJZtM1ixU4Udq1s5P9SyaMt+/XzHf80bobGu2CcXEY9O1MCKPwBemdJP
	 A/I28IsLc3W9skkKywthDOFFbQNOuVF4okYTz3FSxviHQYKJFVxtnxYKSjPo6mLKklGuW
	 A9ru0xCDQtwEd1lfq4fXZMGY9KU+bp7w1S3VxL6XLi4TkIAx65NryKe43dMybZ5BIOze1
	 +0meUp16qac5yxad9NypNsEHSxjAnpsPbZdpfKRhKpt0TmIebwsDg6xYA0DHAF2/6N0+b
	 OExQQJhDQW5sivEebpP7qp2XCKstyGmQSnqoTo8Xpv5FruwoXwJb9KSPOyZ2oRcrLMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795746840;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xE6n1K2rOWYZvPUtg02Nfzz8X5wv6KHWzgwsV5WH1EM=;
	b=1xHoSDZHpsRSV/imFDIVKH1gMbGZ7xjCzKS3l6RLe9phGeS5QSs+Gy2PLlDxj/lMvPCR
	 CaxxIEF/f12Eb0MNLGjSHWpjcTtVvYs1B9eNyQpg4RDeb63JukVS+Y9gDB3qoY9ws1XmJ
	 DgGSigxDS4M9O0DaAnWqnpTxjQK0SRekacymK6PmkmriAyZpgPAOcNBnYN0LfmmAgVWJ4
	 q//xodHGOSCngsgeQ3kB6atbyqDOBGuRHY+FogOZbCAqbTvYYwPFj00RxYTKZNer9z5P2
	 dLJsfbMOfQOIS4D1UhTz7R8Ak5YGOaOZvhYWbFmejv3pZ0qBS6Bm1gHjhUGRjkj1UDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CMYKihxe;
	arc=none smtp.remote-ip=115.124.30.112
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712F1606A324;
	Fri, 27 Nov 2026 02:33:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 712F1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CMYKihxe
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795746829; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=xE6n1K2rOWYZvPUtg02Nfzz8X5wv6KHWzgwsV5WH1EM=;
	b=CMYKihxe38ljZeNqBMxfvlQMb8PDzTOqScmAW/9PTmQw0YZqRaIFy29YvEfUDpRJ/5m5xzmrF6hNbyr2Ey95zOagTJMg4AeEtGTcwZUjZTrriYBmFZxeDWJ3hpDPNZSjxfPDQM9GFVYpGAKktZDH1RWyDI3k541QHhKQDTSMEoU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=zoutao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0XFW99xW_1795746828;
Received: from localhost(mailfrom:zoutao@linux.alibaba.com fp:SMTPD_---0XFW99xW_1795746828 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Nov 2026 10:33:48 +0800
From: Tao Zou <zoutao@linux.alibaba.com>
To: Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Tao Zou <zoutao@linux.alibaba.com>
Subject: [PATCH 1/1] tcmu: Fix inode use-after-free in global data block pool
Date: Fri, 27 Nov 2026 10:33:46 +0800
Message-Id: <20261127023346.37933-2-zoutao@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261127023346.37933-1-zoutao@linux.alibaba.com>
References: <20261127023346.37933-1-zoutao@linux.alibaba.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The global data block pool can use udev->inode from delayed unmap work
after userspace closes the UIO device. tcmu_open() only stores the raw
pointer, so VFS can reclaim the inode while the device remains on
root_udev. A later find_free_blocks() then dereferences the stale pointer
in unmap_mapping_range().

Take an inode reference in tcmu_open() and hold it until the final device
reference is released. Replace the pointer under cmdr_lock to synchronize
with find_free_blocks(), and drop the previous reference after a reopen.
Keep the reference across tcmu_release() because delayed unmap work still
needs the inode after the last UIO close.

Fixes: b6df4b79a551 ("tcmu: Add global data block pool support")
Signed-off-by: Tao Zou <zoutao@linux.alibaba.com>
---
 drivers/target/target_core_user.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 80da90a..1bd53cd 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1741,6 +1741,8 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	bitmap_free(udev->data_bitmap);
 	mutex_unlock(&udev->cmdr_lock);
 
+	iput(udev->inode);
+
 	pr_debug("dev_kref_release\n");
 
 	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
@@ -1954,12 +1956,21 @@ static int tcmu_mmap_prepare(struct uio_info *info, struct vm_area_desc *desc)
 static int tcmu_open(struct uio_info *info, struct inode *inode)
 {
 	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
+	struct inode *old_inode;
 
 	/* O_EXCL not supported for char devs, so fake it? */
 	if (test_and_set_bit(TCMU_DEV_BIT_OPEN, &udev->flags))
 		return -EBUSY;
 
+	/* find_free_blocks() may use the inode after the last UIO close. */
+	ihold(inode);
+
+	mutex_lock(&udev->cmdr_lock);
+	old_inode = udev->inode;
 	udev->inode = inode;
+	mutex_unlock(&udev->cmdr_lock);
+
+	iput(old_inode);
 
 	pr_debug("open\n");
 
-- 
2.39.5 (Apple Git-154)

