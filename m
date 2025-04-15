Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1C81922E7
	for <linux-scsi@vger.kernel.org>; Tue, 15 Apr 2025 06:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744700301; cv=none; b=OQo9aa2SswwUafIbIzvunNNWvECBtS32bcGoxWCFcfvwtH7zn0C1tBkTXqYNPgrzw1K+XbsLWv0rg4KQ37xXPb0NaDrhRyi6PmWUazZZLwRfo0njHJvIAgUyHKJJ+mUG8Bb8VmqLvlQH10CxIKrH/LT4+pphkfc/FmbS2yqv7Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744700301; c=relaxed/simple;
	bh=paTxeaUm/BJ+KaT7Z3PjrzKcAVBgCED8AmU1yo7Q9ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HsWPXUK0LPU8TgTxdnoQZcyyH9u1JGW3ZhGmC0jFlRZO6Yqs8uHIK1mifLu4+uklAAT9ENhNlyQcnEdauq5JSZlCKBGIFPEMflt0d/Q6dO6CvfUIlgl9hBK+tLTs3loyVbYhbsDlR/yJL4hTTWUeHnHkchi/4U51Y6fAbE7Brjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn; spf=pass smtp.mailfrom=iie.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iie.ac.cn
Received: from localhost.localdomain (unknown [159.226.95.28])
	by APP-05 (Coremail) with SMTP id zQCowAAHQQl0A_5nSYIQCQ--.14068S2;
	Tue, 15 Apr 2025 14:57:59 +0800 (CST)
From: Chen Yufeng <chenyufeng@iie.ac.cn>
To: bootc@bootc.net
Cc: martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	Chen Yufeng <chenyufeng@iie.ac.cn>
Subject: [PATCH] sbp: potential integer overflow in sbp_make_tpg()
Date: Tue, 15 Apr 2025 14:57:43 +0800
Message-ID: <20250415065744.719-1-chenyufeng@iie.ac.cn>
X-Mailer: git-send-email 2.43.0.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAHQQl0A_5nSYIQCQ--.14068S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF1UWF4xtr18CFW3Ww43trb_yoW8Jw4DpF
	s7X3s0yrW7KFWUJw48AF4UXFy5Wa1kKryjyr4xtw40vay3JFWxXrnrKay2vF15XFyxGa1U
	Kay8Z3Z8AFs8AaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU5WlkUUUUU
X-CM-SenderInfo: xfkh05xxih0wo6llvhldfou0/1tbiBwwNEmf95HVzNAAAsY

The variable tpgt in sbp_make_tpg() is defined as unsigned long and is 
assigned to tpgt->tport_tpgt, which is defined as u16. This may cause an 
integer overflow when tpgt is greater than USHRT_MAX (65535). I 
haven't tried to trigger it myself, but it is possible to trigger it
by calling sbp_make_tpg() with a large value for tpgt.

I modified the type of tpgt to match tpgt->tport_tpgt and adjusted the 
relevant code accordingly.

This patch is similar to commit 59c816c1f24d ("vhost/scsi: potential 
memory corruption").

Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
---
 drivers/target/sbp/sbp_target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 3b89b5a70331..ad03bf7929f8 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1961,12 +1961,12 @@ static struct se_portal_group *sbp_make_tpg(struct se_wwn *wwn,
 		container_of(wwn, struct sbp_tport, tport_wwn);
 
 	struct sbp_tpg *tpg;
-	unsigned long tpgt;
+	u16 tpgt;
 	int ret;
 
 	if (strstr(name, "tpgt_") != name)
 		return ERR_PTR(-EINVAL);
-	if (kstrtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)
+	if (kstrtou16(name + 5, 10, &tpgt))
 		return ERR_PTR(-EINVAL);
 
 	if (tport->tpg) {
-- 
2.34.1

