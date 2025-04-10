Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED9B28150E
	for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 14:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744293994; cv=none; b=IBotmFEoCLLLQ9I4cRNQApkogUgFhtUv7AVZfl2ElRMJTDMZUeRg18ajFGaQf/bUd8ia7hIlviSkmru8zh3usM6f3gBQTBj8+QKyMXEEw4kMcX70kKw+8WDjPdk7hrUMZKxrTHTp9HZbq0Cd3l34obNSzhANq/oeow6OtqH/rBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744293994; c=relaxed/simple;
	bh=N89AIc1FJHEdN6qfDj076QgHE1yg1O9HYZPYLzwIJn4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IO6LF+SFVPid8HVZujNBXIW+pg22/iojJKhMhlnazSLtpgpAqvvM+lopC6xZoO8OWUanjrAxhmqjcjGOOZAKrmhosMptkC6S/IPxvX6M4grhJOi1eb23ti8Fxe6SZ+H5D5vcBN/CfbdCnx3+suQk4AJYFYnXdiWdX5k8ZoeLgcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn; spf=pass smtp.mailfrom=iie.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iie.ac.cn
Received: from localhost.localdomain (unknown [159.226.95.28])
	by APP-05 (Coremail) with SMTP id zQCowADn5w9P0PdnXmD_Bw--.12137S2;
	Thu, 10 Apr 2025 22:06:08 +0800 (CST)
From: Chen Yufeng <chenyufeng@iie.ac.cn>
To: bootc@bootc.net
Cc: martin.petersen@oracle.com,
	gregkh@linuxfoundation.org,
	Thinh.Nguyen@synopsys.com,
	linux-scsi@vger.kernel.org,
	Chen Yufeng <chenyufeng@iie.ac.cn>
Subject: [PATCH] drivers: Two potential integer overflow in sbp_make_tpg() and usbg_make_tpg()
Date: Thu, 10 Apr 2025 22:05:49 +0800
Message-ID: <20250410140550.1647-1-chenyufeng@iie.ac.cn>
X-Mailer: git-send-email 2.43.0.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADn5w9P0PdnXmD_Bw--.12137S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar17Xw4UWF4UCF45XrWUArb_yoW8Aw1kpa
	n7Xr90yrySy3ykX3yxJan8XFyru3WkKFyUtrWxt39YvF4fJFWrZrnrtayIgF13XFy8Cw4a
	ga1qvFyrC3y8ArJanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9I14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE
	5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeV
	CFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l
	c7CjxVAaw2AFwI0_Jw0_GFylc2xSY4AK67AK6ry5MxAIw28IcxkI7VAKI48JMxC20s026x
	CaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_
	JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r
	1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_
	Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8Jb
	IYCTnIWIevJa73UjIFyTuYvjfUnBMKDUUUU
X-CM-SenderInfo: xfkh05xxih0wo6llvhldfou0/1tbiCQ4IEmf3zWQLaQAAsG

The variable tpgt in sbp_make_tpg() and usbg_make_tpg() is defined as
unsigned long and is assigned to tpgt->tport_tpgt, which is defined as u16.
This may cause an integer overflow when tpgt is greater than USHRT_MAX
(65535). 

My fix is based on the implementation of tcm_qla2xxx_make_tpg() in 
drivers/scsi/qla2xxx/tcm_qla2xxx.c which limits tpgt to USHRT_MAX.

This patch is similar to
commit 59c816c1f24d ("vhost/scsi: potential memory corruption").

Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
---
 drivers/target/sbp/sbp_target.c     | 2 +-
 drivers/usb/gadget/function/f_tcm.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 3b89b5a70331..525d978ce41f 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1966,7 +1966,7 @@ static struct se_portal_group *sbp_make_tpg(struct se_wwn *wwn,
 
 	if (strstr(name, "tpgt_") != name)
 		return ERR_PTR(-EINVAL);
-	if (kstrtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)
+	if (kstrtoul(name + 5, 10, &tpgt) || tpgt > USHRT_MAX)
 		return ERR_PTR(-EINVAL);
 
 	if (tport->tpg) {
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 5a2e1237f85c..5c570d4c87b5 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1648,7 +1648,7 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 
 	if (strstr(name, "tpgt_") != name)
 		return ERR_PTR(-EINVAL);
-	if (kstrtoul(name + 5, 0, &tpgt) || tpgt > UINT_MAX)
+	if (kstrtoul(name + 5, 0, &tpgt) || tpgt > USHRT_MAX)
 		return ERR_PTR(-EINVAL);
 	ret = -ENODEV;
 	mutex_lock(&tpg_instances_lock);
-- 
2.34.1

