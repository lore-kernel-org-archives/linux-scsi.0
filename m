Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AE118FDAF
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 09:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724924367; cv=none; b=XN9Ckf0hDiXMPkNYkAwFE1uSLqTBdyOMpOeN4AY8XA/j8kEl0zYFtwTUBaQunDtJrQiEWRrdQawfU3scRMNLWcAbD50IxyEAY3Cu2fqT5WcFV7BeOhaOLC2s6MUmxs8pG8TNnt7JUSPCbHDGKPtUQo/HJWThMNHR9siljejd+G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724924367; c=relaxed/simple;
	bh=vqdNvXkoRmeV6Usb0tFIK/Ojl3s9dgP2i9C4ucSMDxk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:Content-Type:
	 References; b=gelZC6t9DLRf8E31UsXRMJOJPEzIUf0F3VowxBjq0VELJKF6wGI9qMTW2G/5TBeJ+7I2U5h6ty276t1glHTffgrPaKSUGbrHUV2jT3a7SNUGbNMRnIXFLuRTzJ5UhneelVNQ9u46sAGTfRp40Gv1zegvqVYrpyxjy0cjeKdEy2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mS5GiFI5; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mS5GiFI5"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240829093923epoutp04118bbbfd1d96e413b54c0114c571396e~wKZG1tsrD2662726627epoutp04U
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 09:39:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240829093923epoutp04118bbbfd1d96e413b54c0114c571396e~wKZG1tsrD2662726627epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724924363;
	bh=aa5/JjPkt7dEuyoZ5rPhW1zLfqGVrrp1MMlIUm7auVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mS5GiFI5+bp9NexewMPNZhWqppDEMWE+4IIZ0YNGhjY9jdirLQ9oapL7guwlkyc0n
	 JB3jKsRXibIKAcVTqM/YUlbqFaY67D0IMTq59m2Lh7xFrpEsedT00ozHDMTMIenxt/
	 Oo20jafPBuJ8Jd2dXNX5yxAAFmwB6+RBSYI+gY9w=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTP id
	20240829093922epcas1p4a1bfcc85c05a026de1dcfadd7683d140~wKZGWlQpy0342303423epcas1p4V;
	Thu, 29 Aug 2024 09:39:22 +0000 (GMT)
Received: from epsmgec1p1.samsung.com (unknown [182.195.38.241]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WvbpL19lSz4x9Px; Thu, 29 Aug
	2024 09:39:22 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
	epsmgec1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	45.2B.09623.9C140D66; Thu, 29 Aug 2024 18:39:21 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64~wKZFGBBFA0443604436epcas1p3P;
	Thu, 29 Aug 2024 09:39:21 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240829093921epsmtrp240c1190c20197b8bd144f84fc720adae~wKZFCXKE92298422984epsmtrp29;
	Thu, 29 Aug 2024 09:39:21 +0000 (GMT)
X-AuditID: b6c32a36-ef9ff70000002597-62-66d041c936a3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	1B.41.19367.8C140D66; Thu, 29 Aug 2024 18:39:21 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.98.171]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240829093920epsmtip29d66190305a25b9a9276fc6b4fce4cb1~wKZEzE5SS1393413934epsmtip2T;
	Thu, 29 Aug 2024 09:39:20 +0000 (GMT)
From: Seunghwan Baek <sh8267.baek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org, avri.altman@wdc.com, alim.akhtar@samsung.com
Cc: grant.jung@samsung.com, jt77.jang@samsung.com, junwoo80.lee@samsung.com,
	dh0421.hwang@samsung.com, jangsub.yi@samsung.com, sh043.lee@samsung.com,
	cw9316.lee@samsung.com, sh8267.baek@samsung.com, wkon.kim@samsung.com,
	stable@vger.kernel.org
Subject: [PATCH v1 1/1] ufs: core: set SDEV_OFFLINE when ufs shutdown.
Date: Thu, 29 Aug 2024 18:39:13 +0900
Message-Id: <20240829093913.6282-2-sh8267.baek@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240829093913.6282-1-sh8267.baek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdlhTV/ek44U0gyMfLCwezNvGZvHy51U2
	i2kffjJbzDjVxmqx79pJdotff9ezW2zs57Do2DqZyWLH8zPsFrv+NjNZXN41h82i+/oONovl
	x/8xWTT92cdice3MCVaLBRsfMVpsvvSNxUHQ4/IVb49pk06xeXx8eovFo2/LKkaPz5vkPNoP
	dDMFsEVl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA
	3a6kUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAr0CtOzC0uzUvXy0stsTI0MDAy
	BSpMyM64d7+fueCTVMXZpTPZGxhPiHQxcnJICJhInLzbzAhiCwnsYJR4cIavi5ELyP7EKDH3
	wkNmOOfwp/OMMB1zl21kh0jsZJR4/GwyE4TzmVFi9ZXvLCBVbAJ6Eq/aD7OBJEQEjjJK3Nr2
	gBHEYRb4ySjx/vpBdpAqYQE3ifVndgK1c3CwCKhKfH7DCxLmFbCW2L+6lwVinbzE6g0HmEFs
	TgEbifcLJoJtkxCYyiHR9PodE0SRi8Spl81Q9wlLvDq+hR3ClpL4/G4vG4RdLLFw4yQWiOYW
	Ronry/9ANdhLNLc2s4EcwSygKbF+lz5ImFmAT+Ld1x5WkLCEAK9ER5sQRLWqxKkNW6E6pSWu
	NzewQtgeEhvX7YeGVz+jxO0NVxgnMMrOQpi6gJFxFaNYakFxbnpqsWGBETyekvNzNzGCU6SW
	2Q7GSW8/6B1iZOJgPMQowcGsJMJ74vjZNCHelMTKqtSi/Pii0pzU4kOMpsAAm8gsJZqcD0zS
	eSXxhiaWBiZmRiYWxpbGZkrivGeulKUKCaQnlqRmp6YWpBbB9DFxcEo1MDkvytQv+J12se36
	9Fktby8uPJCfl7bxgWboxE/7Hh60CqsO6GtpClvzembZydfrrDR3LotbtidQKNhU79Vu3Xvv
	2P8yqa+5KPjDI6x1oRPfPeFa/xDfvu6GopCrDnPXMK8V+rft0OwKfbWINe63eW64cgeesP/M
	HDB9PSMnd+5kQ6u/ge4VzprdJzReLlMVfm6SKas/w+u5Ttllzs3H9ebslFI/tp99Vl35u7PT
	GTdM9BFpZ7Cx2r1005rlbwKt+n79K1g4oU++qelmcgp/fD739ahUo8VfjzfeObeX6+6t6QYW
	x5UuyR5bkNn+3/FQyJ47gn1BHn8ebvCd8O6fU9XLXwd0L1k4zJrjoH3r7HIlluKMREMt5qLi
	RABJWa4hGgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWy7bCSvO5JxwtpBlM2Mlo8mLeNzeLlz6ts
	FtM+/GS2mHGqjdVi37WT7Ba//q5nt9jYz2HRsXUyk8WO52fYLXb9bWayuLxrDptF9/UdbBbL
	j/9jsmj6s4/F4tqZE6wWCzY+YrTYfOkbi4Ogx+Ur3h7TJp1i8/j49BaLR9+WVYwenzfJebQf
	6GYKYIvisklJzcksSy3St0vgyrh3v5+54JNUxdmlM9kbGE+IdDFyckgImEjMXbaRvYuRi0NI
	YDujxKcNbWwQCWmJxwdeMnYxcgDZwhKHDxdD1HxklDh1+T4zSA2bgJ7Eq/bDYPUiAmcZJY5O
	LAApYhZoZZI4t7WNCSQhLOAmsf7MTiaQQSwCqhKf3/CChHkFrCX2r+5lgdglL7F6wwGwmZwC
	NhLvF0wEaxUCqvk48y37BEa+BYwMqxhFUwuKc9NzkwsM9YoTc4tL89L1kvNzNzGCw1oraAfj
	svV/9Q4xMnEwHmKU4GBWEuE9cfxsmhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFe5ZzOFCGB9MSS
	1OzU1ILUIpgsEwenVAOTzpErprZ2+lOspkc/uupiscCi97zrrf2NLfl2BWzP776J38Rss5ix
	cOGnZTopurEs2c/EhbmDPeYIVUnsbOzWtbt/zP+tSnLZ1QeOS+dqvLpXoN4Q/OWPRJzMVMWJ
	Ah/mBQT+WtDu9VW47VjrxP81Zyutn177fMpkziEf6Tts0z/9fVe2ucNdbvGRb57f+n7NWaVY
	cNfRy+VL6dGtp6/WnlVZ379LfplTVOuD7f5q0vOcX+zb0T3HJ7QzWk//aHzyvekz+kpzIiel
	+XALS+1fYvFdeGOBXGCpB6PCr4KPisuKu4UPTnBmP+BWvbO+XXzBXK6rGwtL/7/zimipv7GQ
	O3nm96hlToed/5TzvhRVYinOSDTUYi4qTgQAhIQqmNoCAAA=
X-CMS-MailID: 20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64
References: <20240829093913.6282-1-sh8267.baek@samsung.com>
	<CGME20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64@epcas1p3.samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

There is a history of dead lock as reboot is performed at the beginning of
booting. SDEV_QUIESCE was set for all lu's scsi_devices by ufs shutdown,
and at that time the audio driver was waiting on blk_mq_submit_bio holding
a mutex_lock while reading the fw binary. After that, a deadlock issue
occurred while audio driver shutdown was waiting for mutex_unlock of
blk_mq_submit_bio. To solve this, set SDEV_OFFLINE for all lus except wlun,
so that any i/o that comes down after a ufs shutdown will return an error.

[   31.907781]I[0:      swapper/0:    0]        1        130705007       1651079834      11289729804                0 D(   2) 3 ffffff882e208000 *             init [device_shutdown]
[   31.907793]I[0:      swapper/0:    0] Mutex: 0xffffff8849a2b8b0: owner[0xffffff882e28cb00 kworker/6:0 :49]
[   31.907806]I[0:      swapper/0:    0] Call trace:
[   31.907810]I[0:      swapper/0:    0]  __switch_to+0x174/0x338
[   31.907819]I[0:      swapper/0:    0]  __schedule+0x5ec/0x9cc
[   31.907826]I[0:      swapper/0:    0]  schedule+0x7c/0xe8
[   31.907834]I[0:      swapper/0:    0]  schedule_preempt_disabled+0x24/0x40
[   31.907842]I[0:      swapper/0:    0]  __mutex_lock+0x408/0xdac
[   31.907849]I[0:      swapper/0:    0]  __mutex_lock_slowpath+0x14/0x24
[   31.907858]I[0:      swapper/0:    0]  mutex_lock+0x40/0xec
[   31.907866]I[0:      swapper/0:    0]  device_shutdown+0x108/0x280
[   31.907875]I[0:      swapper/0:    0]  kernel_restart+0x4c/0x11c
[   31.907883]I[0:      swapper/0:    0]  __arm64_sys_reboot+0x15c/0x280
[   31.907890]I[0:      swapper/0:    0]  invoke_syscall+0x70/0x158
[   31.907899]I[0:      swapper/0:    0]  el0_svc_common+0xb4/0xf4
[   31.907909]I[0:      swapper/0:    0]  do_el0_svc+0x2c/0xb0
[   31.907918]I[0:      swapper/0:    0]  el0_svc+0x34/0xe0
[   31.907928]I[0:      swapper/0:    0]  el0t_64_sync_handler+0x68/0xb4
[   31.907937]I[0:      swapper/0:    0]  el0t_64_sync+0x1a0/0x1a4

[   31.908774]I[0:      swapper/0:    0]       49                0         11960702      11236868007                0 D(   2) 6 ffffff882e28cb00 *      kworker/6:0 [__bio_queue_enter]
[   31.908783]I[0:      swapper/0:    0] Call trace:
[   31.908788]I[0:      swapper/0:    0]  __switch_to+0x174/0x338
[   31.908796]I[0:      swapper/0:    0]  __schedule+0x5ec/0x9cc
[   31.908803]I[0:      swapper/0:    0]  schedule+0x7c/0xe8
[   31.908811]I[0:      swapper/0:    0]  __bio_queue_enter+0xb8/0x178
[   31.908818]I[0:      swapper/0:    0]  blk_mq_submit_bio+0x194/0x67c
[   31.908827]I[0:      swapper/0:    0]  __submit_bio+0xb8/0x19c

Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Cc: stable@vger.kernel.org
Signed-off-by: Seunghwan Baek <sh8267.baek@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a6f818cdef0e..4ac1492787c2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10215,7 +10215,9 @@ static void ufshcd_wl_shutdown(struct device *dev)
 	shost_for_each_device(sdev, hba->host) {
 		if (sdev == hba->ufs_device_wlun)
 			continue;
-		scsi_device_quiesce(sdev);
+		mutex_lock(&sdev->state_mutex);
+		scsi_device_set_state(sdev, SDEV_OFFLINE);
+		mutex_unlock(&sdev->state_mutex);
 	}
 	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
 
-- 
2.17.1

