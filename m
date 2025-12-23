Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B395E2D4806;
	Tue, 23 Dec 2025 14:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766499369; cv=none; b=HSxIdaXbYR0Nv21vQkW80E3cJRhYKPVczLr5QRa6N4mBuAiSfmMe7uaQAJQUdEQyhZ7mAUEt0N/9Gmb4wHHSpX1KkK340EIhAigIUdjOFinko/c8iOsREeCXo4SCKAHvuYVAHWTppFdG5jd3B7dVe6WQUOHmN15MdRbuHCYwvxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766499369; c=relaxed/simple;
	bh=m5sLTp/UIzs+P3oJR1WEZ9eeBmKmZPWUA6z9v2cpVJQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D14JBA+PnCYyFRUu/jlWQpSpEJicEKoAoTU3NbJchi695MKTqqRJd5LOIGMm6lfOEU7siNwGoYTE1AX7sRs86ybzlnU/lIcxzdSVhfhny2X6WUSLtYfzYba7X8v6mDZtgWKxt7mWwMsv/DczchAMikdOrpcWzas2JCoBq4VQx5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn; spf=pass smtp.mailfrom=isrc.iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=isrc.iscas.ac.cn
Received: from localhost.localdomain (unknown [36.112.3.209])
	by APP-05 (Coremail) with SMTP id zQCowAC3SQ0UpEppP9+oAQ--.17880S2;
	Tue, 23 Dec 2025 22:15:48 +0800 (CST)
From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: esas2r: fix a resource leak in esas2r_resume()
Date: Tue, 23 Dec 2025 22:15:47 +0800
Message-Id: <20251223141547.1506688-1-lihaoxiang@isrc.iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAC3SQ0UpEppP9+oAQ--.17880S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr15ur1rGF1kAry7WF4Uurg_yoW8Gr4DpF
	4rC3WqkF18AF47C3Z8CF1Yvas5tayUtF93WFWrW3sxuan8ArZ8Jr18XryjvF1kKFy8JF15
	JFn2q398tFyDJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r1j
	6r4UM28EF7xvwVC2z280aVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r
	4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUU
	UU=
X-CM-SenderInfo: 5olkt0x0ld0ww6lv2u4olvutnvoduhdfq/1tbiCRAFE2lKc7t2wgAAsQ

Add esas2r_unmap_regions() to release the resources
allocated by esas2r_map_regions() in some error paths.

Found by code review and compiled on ubuntu 20.04.

Fixes: 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
---
 drivers/scsi/esas2r/esas2r_init.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 04a07fe57be2..114239373f28 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -684,7 +684,7 @@ static int __maybe_unused esas2r_resume(struct device *dev)
 	if (!esas2r_power_up(a, true)) {
 		esas2r_debug("yikes, esas2r_power_up failed");
 		rez = -ENOMEM;
-		goto error_exit;
+		goto error_unmap;
 	}
 
 	esas2r_claim_interrupts(a);
@@ -700,9 +700,11 @@ static int __maybe_unused esas2r_resume(struct device *dev)
 		esas2r_debug("yikes, unable to claim IRQ");
 		esas2r_log(ESAS2R_LOG_CRIT, "could not re-claim IRQ!");
 		rez = -ENOMEM;
-		goto error_exit;
+		goto error_unmap;
 	}
 
+error_unmap:
+	esas2r_unmap_regions(a);
 error_exit:
 	esas2r_log_dev(ESAS2R_LOG_CRIT, dev, "esas2r_resume(): %d",
 		       rez);
-- 
2.25.1

