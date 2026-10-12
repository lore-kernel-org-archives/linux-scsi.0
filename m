Received: from fraori-sdnproxy-3.icoremail.net (fraori-sdnproxy-3.icoremail.net [132.226.202.154])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE9F371887;
	Mon, 12 Oct 2026 14:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=132.226.202.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791813611; cv=none; b=XuNk9e2AheSMNl/1MycQoeyHYT0PiDNkrBdxWXbSUQdNSUyov+wLBIGoZ4J86XDzFQVskJusni6thRv/zH+lvX27ZNbBzI4sP8HrR3ghemng4aGuijlUUzcAByGLRV3auYP+684reOsOv3aeza7fXUUvz8y3w7Z9sjfQm+zycNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791813611; c=relaxed/simple;
	bh=+454kcILR8zK32RYcwr3Kr93+ihEIHEWJW2gb1jr0xo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I3FzT+wCvfzLD78rKJFmiO3fGmn6a2hIlwitLypiONbZjjOo1zM8JZTKWSW08pDcb/dRt/hW9QsuS5cs1C+irstVWvgoE0oxKtAYZStZvVuOgLaDp6sP+jH5/kpykZTsncjGGxcJ+vrGqXJY1UBbSD4zfkuS/J/KUL6yXztSGG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=132.226.202.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [112.11.3.216])
	by mtasvr (Coremail) with SMTP id _____wDHGLTd58xq1uV9AQ--.10259S3;
	Mon, 12 Oct 2026 21:59:57 +0800 (CST)
Received: from localhost.localdomain (unknown [112.11.3.216])
	by mail-app1 (Coremail) with UTF8SMTPA id yy_KCgD3BILb58xqVDBYAA--.50401S2;
	Mon, 12 Oct 2026 21:59:56 +0800 (CST)
From: Jiacheng Xu <stitch@zju.edu.cn>
To: dgilbert@interlog.com
Cc: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiacheng Xu <stitch@zju.edu.cn>
Subject: [PATCH] scsi: sg: update local scatter size when clamping
Date: Mon, 12 Oct 2026 21:59:55 +0800
Message-ID: <20261012135955.78357-1-stitch@zju.edu.cn>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:yy_KCgD3BILb58xqVDBYAA--.50401S2
X-CM-SenderInfo: qtrxiiaqttimo62m3hxhgxhubq/
X-CM-DELIVERINFO: =?B?255eEgXKKxbFmtjJiESix3B1w3tMoM3snk/k5SVzZVydjEqe1eefKHnLf95EnB4iem
	egW7q+4qg3kAwHIt6WUKLmaHrAYAC/Um2/qw0nbt36ozCid7sL/XXcUebIL95v3N9MDi+0
	MlqMv3umpxrZBGWAZEFTd8iemmd9atX43uoutfAA
X-Coremail-Antispam: 1Uk129KBj93XoW7KrWkKF4DKw17Ww47Jw45CFX_yoW8JF4kpr
	WxZryjyw48Ga1jk3Wqq3W5G3ZY93s3Ga47Kay8Zw15u395K34Dur15JFWrWFZ5Xr4rCrWk
	J3yqqwn8ua9rCacCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvvb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr1j6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7xvr2IYc2Ij64
	vIr40E4x8a64kEw24l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2Iq
	xVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r
	126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY
	6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67
	AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuY
	vjxU72NtDUUUU

When scatter_elem_sz is set to a value smaller than PAGE_SIZE through
its writable sysfs module parameter, sg_build_indirect() updates the
global scatter element size variables but leaves the local num
variable unchanged.

If the parameter is set to zero, get_order(num) is called with zero,
for which its result is undefined. On 64-bit systems, the current
implementation returns an order of 64 - PAGE_SHIFT. This causes:

    ret_sz = 1 << (PAGE_SHIFT + order);

to shift a 32-bit integer by 64 bits, triggering:

    UBSAN: shift-out-of-bounds in sg_build_indirect

Update num together with the global values when clamping it to
PAGE_SIZE.

Fixes: 6460e75a104d ("[SCSI] sg: fixes for large page_size")
Signed-off-by: Jiacheng Xu <stitch@zju.edu.cn>
---
 drivers/scsi/sg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5408f002e6c0..69013335e433 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1876,6 +1876,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 	num = scatter_elem_sz;
 	if (unlikely(num != scatter_elem_sz_prev)) {
 		if (num < PAGE_SIZE) {
+			num = PAGE_SIZE;
 			scatter_elem_sz = PAGE_SIZE;
 			scatter_elem_sz_prev = PAGE_SIZE;
 		} else
-- 
2.25.1

