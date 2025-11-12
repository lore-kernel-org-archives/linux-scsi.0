Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA18915E8B;
	Wed, 12 Nov 2025 03:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762917345; cv=none; b=JKpWtaWFVOHQeAx7sq/rf/auxEkKcgWnUbLbItkUYBm5+YIKbGWu5xyCwekq/5ocY14t/Q+tBegeD+kOBxCRW7ULo2+qcRrQO93/X8pLqxwm/hTrj4+NR1GI7ycETfuR7LexMcyPCKWLj95gtztShGy3yX+jNVZvEvUBCElTyTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762917345; c=relaxed/simple;
	bh=o3ovrkrVPbzb+rAwmTlMbs2Ng7H+7gYQTYjZxBQ41NI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b6fCkrQLcXV60yWHMArdSg+ZE1i7Uk9UbUTNH3XK4IXzQsRUkSjxFrMFM4FJdIG/RKRl1QiIiPazztaxOsFjfkewvkrpc9MtSW+dJ2czqHrQ4vpwfe3561N4FRDxBnh3bsGE2iDzRMiXLl21XZsUiQ8s2KCOeT8s6DJZg5qEpSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S (unknown [124.16.141.245])
	by APP-03 (Coremail) with SMTP id rQCowABH19nU+xNpzItvAA--.21749S2;
	Wed, 12 Nov 2025 11:15:34 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: linuxdrivers@attotech.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: [PATCH] scsi: esas2r: Add check for alloc_ordered_workqueue() return value
Date: Wed, 12 Nov 2025 11:15:21 +0800
Message-ID: <20251112031521.2000-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABH19nU+xNpzItvAA--.21749S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Wr4fuw43Wrykuw4xCFW8Xrb_yoWkurb_C3
	9rZr12yrsrCF42kryktFyavrWvvr48Zw4fuF4Yqa4fA34Igr1UXr48Ar17ZwsrC3409FyD
	Cws0gry8Zr17ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4kFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUehL0UU
	UUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAUEA2kT1NOpQAAAsa

alloc_ordered_workqueue() may return NULL. Failure to check this
could lead to NULL pointer dereference.

Add return value check and call esas2r_kill_adapter() on failure
to ensure proper cleanup.

Fixes: 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 drivers/scsi/esas2r/esas2r_init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 04a07fe57be2..640b59250f72 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -313,6 +313,12 @@ int esas2r_init_adapter(struct Scsi_Host *host, struct pci_dev *pcid,
 	esas2r_fw_event_off(a);
 	a->fw_event_q =
 		alloc_ordered_workqueue("esas2r/%d", WQ_MEM_RECLAIM, a->index);
+	if (!a->fw_event_q) {
+		esas2r_log(ESAS2R_LOG_CRIT,
+				"failed to allocate fw_event workqueue!");
+		esas2r_kill_adapter(index);
+		return 0;
+	}
 
 	init_waitqueue_head(&a->buffered_ioctl_waiter);
 	init_waitqueue_head(&a->nvram_waiter);
-- 
2.50.1.windows.1

