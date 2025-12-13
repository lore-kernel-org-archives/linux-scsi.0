Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F3D41C72;
	Sat, 13 Dec 2025 08:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765615025; cv=none; b=FREN00O3JERugRco39+AwrOyB//BqIrlsbfDNDDwIrJkZQVE+N1F2/6yEOEaCAaTu1WMkL+IuwURvVymQrO9O0Qg9OiqlhmKnnuOR6Wjyd1xQw8wnfVFPFtD2iomTDrP8l6oshxiSlMy70anQWuVD/k8EdPwJqldyk8th9RqbT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765615025; c=relaxed/simple;
	bh=jwy8x0Pv72DV5sOKYODW/uajcNmAczdG5r26stzCySE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mzbSVwEx9ddWTdGzkn7TRbM2ESD+gN+nbEGsHx5oCvC0Zuz25u0Hd3DFLuxk9Mubn4LNY7ahlsBgaD0Ro2jixdL9kwP1W6KfVpIyDoGvQGgk0J383aSuBg8OlsaL3N2R3Q9kuY+0sEbJC+8im3Sq2mKSu4vki/iHFOV0wZqvvik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn; spf=pass smtp.mailfrom=isrc.iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=isrc.iscas.ac.cn
Received: from localhost.localdomain (unknown [36.112.3.239])
	by APP-03 (Coremail) with SMTP id rQCowABHaN+dJT1pKkCPAA--.46430S2;
	Sat, 13 Dec 2025 16:36:45 +0800 (CST)
From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
To: ketan.mukadam@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	jitendra.bhivare@broadcom.com,
	hare@suse.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: be2iscsi: fix a memory leak in beiscsi_boot_get_sinfo()
Date: Sat, 13 Dec 2025 16:36:43 +0800
Message-Id: <20251213083643.301240-1-lihaoxiang@isrc.iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABHaN+dJT1pKkCPAA--.46430S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtF13WF4DZF4xGFWDWF4fuFg_yoW3tFg_uw
	4YqwnFg3yUGF4fAF4UWF1a9a90kry8Xws7uF1avryfCryfZr98XF10vr1fZw4kAa18uF1D
	A34UJ34qyw4kJjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbckFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Jr0_
	Gr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Jr0_Gr
	1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0
	cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8Jw
	ACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_Jw0_
	GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 5olkt0x0ld0ww6lv2u4olvutnvoduhdfq/1tbiBwkPE2k8yQuQYQAAs0

If nonemb_cmd->va fails to be allocated, call free_mcc_wrb()
to restore the impact caused by alloc_mcc_wrb().

Fixes: 50a4b824be9e ("scsi: be2iscsi: Fix to make boot discovery non-blocking")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
---
 drivers/scsi/be2iscsi/be_mgmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 4e899ec1477d..b1cba986f0fb 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1025,6 +1025,7 @@ unsigned int beiscsi_boot_get_sinfo(struct beiscsi_hba *phba)
 					      &nonemb_cmd->dma,
 					      GFP_KERNEL);
 	if (!nonemb_cmd->va) {
+		free_mcc_wrb(ctrl, tag);
 		mutex_unlock(&ctrl->mbox_lock);
 		return 0;
 	}
-- 
2.25.1

