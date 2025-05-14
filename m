Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E452118DB2F;
	Wed, 14 May 2025 03:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747193363; cv=none; b=f9je7F78l2lPnxvQbHHf3b2viJ85Llp/dYy4qXk06hBevfEIgABV+J4O5A8g6hEpXcJQW7edty36gM43IWOjDimcD8QPG2nqT7//k7Lt+FHWffkLeuAPNiN1CPw7MdQMEaOhO6+BIIyBO+d0hSC/k9F/JR7Rm2yixQA+5vApJEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747193363; c=relaxed/simple;
	bh=16457uxwp94fGvkWR9aM5nt/Py5P1phZ6IQiEBarvvU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QkXvvseJdZdWUzHNFIWs+vTSTdgg+RZHqEnnCQG9+qXcSTLLiHltzgkkdTb03Ud8faFccQ0YGAFvi2iIatgH2+Iv4Iy7WemGFkvJRbRGB0Hdh7kYh7lo5QzcnGKUKsxpWGuJm5JAx4D0zvADhlMOkP1b96olG8ECeV3CZkcSVXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowAAHPgYHDiRoBSgGFQ--.55114S2;
	Wed, 14 May 2025 11:29:11 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: dgilbert@interlog.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] scsi: sg: Remove unnecessary NULL check before unregister_sysctl_table()
Date: Wed, 14 May 2025 11:28:45 +0800
Message-Id: <20250514032845.2317700-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAHPgYHDiRoBSgGFQ--.55114S2
X-Coremail-Antispam: 1UD129KBjvdXoWrArWktF48WF4xKF47ur4rZrb_yoWxWrc_GF
	Z2qrnrXr9Y9rnF93s8AF1Uury09a1UWrn3ZF1YqasxAF4xXrWDKryUZr1UZ39rXay8C3ZI
	k34UWrySkrW7ujkaLaAFLSUrUUUU1b8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb-xFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAK
	zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx
	8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwCY1x0262kKe7AKxVWUAVWUtwCY02Avz4vE14v_Gr4l42xK82IYc2Ij64vIr41l4I8I3I
	0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWU
	GVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI
	0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0
	rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r
	4UJbIYCTnIWIevJa73UjIFyTuYvjTRErWFUUUUU
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

unregister_sysctl_table() checks for NULL pointers internally.
Remove unneeded NULL check here.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 drivers/scsi/sg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index effb7e768165..3c02a5f7b5f3 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1658,8 +1658,7 @@ static void register_sg_sysctls(void)
 
 static void unregister_sg_sysctls(void)
 {
-	if (hdr)
-		unregister_sysctl_table(hdr);
+	unregister_sysctl_table(hdr);
 }
 #else
 #define register_sg_sysctls() do { } while (0)
-- 
2.25.1

