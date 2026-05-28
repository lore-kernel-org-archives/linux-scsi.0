Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562582E2DDD;
	Thu, 28 May 2026 02:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779937054; cv=none; b=YKTy8BOKjZ70gZRF7ghZhHeayby+1KxaSIepr41d/mVomkrLVSyhjgIzgB1GrNvdavJBofhRtx7NbjTA8adKLWIGOt0kPtQXirIhiz7xx+U16SbVcnFmmqW5vjJlae76osdQb9RLy0KunpsY8Bztqiu3OHdLlky5w/iizUXhNHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779937054; c=relaxed/simple;
	bh=SzbTmOjv4/rK6iFPkgMdazmxplSFeD7O0gwJa0Xu0xY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mb6R7DGRXfBccU01tteZ4jK2DrdI/Uuo9yKg1om7Wwi2/YU/KzHzp+6GWb3d+avJSZ0tJxmMkzkFPBkNJek1eA+tHoopIAA2J+lST4FoWrhpmkliqBhl84eCb1yG1CofeB6OPb9Wd9GZrjm9gB7VeXw3IHWnVmkuyy4QpdZSpF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowAC3RQkLrxdqiZWcEQ--.6243S2;
	Thu, 28 May 2026 10:57:15 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Kees Cook <kees@kernel.org>,
	Wentao Liang <vulab@iscas.ac.cn>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] target: iscsi: cxgbit: fix cnp kref leak in __cxgbit_free_cdev_np()
Date: Thu, 28 May 2026 02:57:01 +0000
Message-Id: <20260528025701.1036636-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAC3RQkLrxdqiZWcEQ--.6243S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF47Wr1xZr4kZr1UuF4xXrb_yoW8Xw13pF
	40kFyUJr1DJ3y3Kr4kJw4I9ryfua1ayrW3C348Cws0kws0vryDKFyYyw12qay5urWkur43
	XF45Ar1UGryqy37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUG0PhUUU
	UU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwkBA2oXgFyjjAAAsC

__cxgbit_free_cdev_np() calls cxgbit_get_cnp() which takes a kref
reference on the cnp structure. This reference is only released on
the immediate error path after cxgbit_get_cnp(). On the timeout path
and the normal completion path that successfully processes the NP,
the reference is never released via cxgbit_put_cnp(), leaking the
kref.

Add cxgbit_put_cnp(cnp) on the timeout and success paths to properly
release the kref reference.

Cc: stable@vger.kernel.org
Fixes: 9730ffcb8957 ("cxgbit: add files for cxgbit.ko")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

---
Change in v2:
-Fix code error.
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
2.34.1

