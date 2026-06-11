Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD963F7A9E;
	Thu, 11 Jun 2026 12:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781180535; cv=none; b=B6nI2EfrKZNuRJIRalfu22e91rrV08h6chzcso4cmO/HbtXWwvSzufRlTACxkcFhwjQZCsAKGdFyuEDvrn6pT139eoHJ5x0IMOKljNO/nYUMPnu20nBSq5La0qps/S3N0Ltt5q9dMV229o3p0HK6Ey2fsFTPKjggiI0T22HoJRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781180535; c=relaxed/simple;
	bh=NNuGjHW7aiMuGvUX+YqgBQNUEL3YlheFCzAZacSIzBE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YuuE7jl70ozE3tAK4RVG1YTlvZxAnx7FIYE1PTo5wlhHyJqdWcEuzAwJEJzjD0LwPRMHAwwTbFS8O+8NHBSjFgZJkcMnHppIuaWlUAN+wIsbDMcyz2ts0R6WRpQl2ZR/+NSYe+cpI3zvOCrXVMjU2aRQcCCothTbf6Q4rdiHe4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [117.182.75.76])
	by APP-05 (Coremail) with SMTP id zQCowACXHgJtqCpqb3IVEw--.237S2;
	Thu, 11 Jun 2026 20:22:07 +0800 (CST)
From: WenTao Liang <vulab@iscas.ac.cn>
To: martin.petersen@oracle.com
Cc: kees@kernel.org,
	vulab@iscas.ac.cn,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: cxgbit: fix refcount leak in __cxgbit_free_cdev_np
Date: Thu, 11 Jun 2026 20:22:03 +0800
Message-ID: <20260611122203.78379-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACXHgJtqCpqb3IVEw--.237S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw1fGw1fCF4rGw15XFWkZwb_yoW8CFyfpF
	W0kFyUJF1DJrW5Jr4kAw4Ikr1Iva1ayFW3C348CwsIvws0vr4DKr1UAw12gay5Crykur43
	Xa1Yvr15G3yDAw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjJ73PUUUU
	U==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAcPA2oqh3hi8AAAsq

__cxgbit_free_cdev_np() calls cxgbit_get_cnp() to take a reference
on cnp for the duration of the firmware remove-server operation.
If cxgb4_remove_server() fails, the reference is correctly released
in the error path with cxgbit_put_cnp(). However, once past that
check, the reference is never released on any other path:
 - when cxgbit_wait_for_reply() times out,
 - when cxgbit_wait_for_reply() succeeds,
 - or when cxgbit_wait_for_reply() returns another error.

All three paths return without dropping the reference, and no
called function consumes or releases the kref. The caller,
cxgbit_free_cdev_np(), does not balance the reference either.

Add the missing cxgbit_put_cnp() on the timeout and success paths,
and use a unified cleanup to handle all non-early-error returns.

Cc: stable@vger.kernel.org
Fixes: 9730ffcb8957 ("cxgbit: add files for cxgbit.ko")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
---
 drivers/target/iscsi/cxgbit/cxgbit_cm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index 146705845fa3..f8cd6457666b 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -544,8 +544,10 @@ __cxgbit_free_cdev_np(struct cxgbit_device *cdev, struct cxgbit_np *cnp)
 
 	ret = cxgbit_wait_for_reply(cdev, &cnp->com.wr_wait,
 				    0, 10, __func__);
-	if (ret == -ETIMEDOUT)
+	if (ret == -ETIMEDOUT) {
+		cxgbit_put_cnp(cnp);
 		return ret;
+	}
 
 	if (ipv6 && cnp->com.cdev) {
 		struct sockaddr_in6 *sin6;
@@ -558,6 +560,7 @@ __cxgbit_free_cdev_np(struct cxgbit_device *cdev, struct cxgbit_np *cnp)
 
 	cxgb4_free_stid(cdev->lldi.tids, stid,
 			cnp->com.local_addr.ss_family);
+	cxgbit_put_cnp(cnp);
 	return 0;
 }
 
-- 
2.50.1 (Apple Git-155)

