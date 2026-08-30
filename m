Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B67D39E6FC;
	Sun, 30 Aug 2026 13:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788096062; cv=none; b=V4DJrqcOy9wsXjU8WuYur7+JKvJ0Be9FQuwtH0958lk61VUnXoqOB5815VlOrj7a6jkHQ1eZYozvETxIB/WF4r5WlTS3pdKYgcYk9vfNz8//Hxw2kslUA4do41LvJ/l1CXyGUu+tlUOaYWhzAf2HsKDOJRdyXOTPduQD7Q8eaRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788096062; c=relaxed/simple;
	bh=NLZIx41IyxRLq6OlBuAiEg5DnlaTksmsCHN16fSIXm0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eZn4uBiXwTXxjZ7DOPQ0RApxwliJmSWtuSc15Xnr9nvF2ilXImXkd4aoVHdqac59LPudoEl679zOurKBkmakrs7SowYIKRTJf23JiXAzlgx1PKrZrT/QHpzIsz3O6SdSBWzAnoM9QEBygyq3X4sL+1x5rMD1+LWBJJWfM7zl9A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowABHTTs1LpRq2P+aBg--.16458S2;
	Sun, 30 Aug 2026 21:20:54 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Ram Vegesna <ram.vegesna@broadcom.com>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: efct: validate firmware header size
Date: Sun, 30 Aug 2026 21:20:51 +0800
Message-ID: <20260830132051.4441-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABHTTs1LpRq2P+aBg--.16458S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xr45Xr43Zw4ktr4DKw4UJwb_yoWDZFgE9F
	4Fvrs3Kr1UKrWkJr4xCFy7ZrZIkw4DZw1fZrnagFWrur4av3yqvr4DArWfCry7Gw4DtF95
	Cw1UZF48Aw12kjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbx8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_
	Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUSLv
	NUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

The optional firmware update path casts the firmware blob to
efct_hw_grp_hdr and reads its revision before checking that the blob covers
the complete header.

Reject undersized firmware images before accessing header fields.

Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/scsi/elx/efct/efct_driver.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index 07c2f453459e1..b0d8ca58daebe 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -338,6 +338,10 @@ efct_request_firmware_update(struct efct *efct)
 		efc_log_debug(efct, "Firmware file(%s) not found.\n", file_name);
 		return rc;
 	}
+	if (fw->size < sizeof(*fw_image)) {
+		rc = -EINVAL;
+		goto exit;
+	}
 
 	fw_image = (struct efct_hw_grp_hdr *)fw->data;

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1

