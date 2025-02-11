Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037A51F192E;
	Tue, 11 Feb 2025 13:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739281156; cv=none; b=hctSAJm9nNuTTKQob7NOCVoYJ9UDg7mb3WpXUmRCk+2RX99l0GPztC+aaYW8rAFXB8xobQQQXu1IbRRmwiF2TmkiiwmbI2FUDcoVKDXgZXI9cjuXRGtJmZIaofZ+7gCOAXm6Jlv7UAzdwfJLJ+jK2Clwq4Aiu11xrUQjSKdeUPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739281156; c=relaxed/simple;
	bh=Pi3y4dmEW1UEme+HX6yYi09ZtTkO/xqgAF/M7VX6HHw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jznBHMt41PT6jeViTaoxJAR07u/BFygu3KFZOCqZIBtgpAeiCvNb2/X9KJiM7JgH77qE29f7XLuL+qpoocDAZXcq71G37B0/J+adllGEsuwFpktK1xuhVcFAMVeDymSoCom95isxH6O6VpAlV08u3V1tnmJuwROjq834d06CoJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [124.16.141.245])
	by APP-01 (Coremail) with SMTP id qwCowACHj2_4UqtnBvFvDA--.42125S2;
	Tue, 11 Feb 2025 21:39:06 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: njavali@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: mrangankar@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH] scsi: qla4xxx: Add missing is_qla4022 check in device initialization
Date: Tue, 11 Feb 2025 21:38:44 +0800
Message-ID: <20250211133844.855-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.42.0.windows.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACHj2_4UqtnBvFvDA--.42125S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JFWxGryUGF1rGw15XFWfGrg_yoWkuwb_ua
	10v34Iv3ZIyr4kZ3W7XF18JFnavrsYqr1jq34Sqr4fA34UZ3s3Xryqv343Zw15G3yjyasx
	Gws5Xry5Ar1fKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbcAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
	1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0
	cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8Jw
	ACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_JF0_
	Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUejjgDUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCREKA2eq70K8UgACsd

The current code only checks for is_qla4032 in the adapter initialization
logic, but is_qla4022 is also required for proper handling of qla4022
devices. This can lead to incorrect behavior on qla4022 adapters.

This patch adds the missing is_qla4022 check to ensure proper handling
of both qla4022 and qla4032 devices during adapter initialization.

Fixes: d915058f4874 ("[SCSI] qla4xxx: add support for qla4032")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/qla4xxx/ql4_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 301bc09c8365..dfe3d0b26224 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -513,7 +513,7 @@ static int qla4xxx_fw_ready(struct scsi_qla_host *ha)
 			      "seconds expired= %d\n", ha->host_no, __func__,
 			      ha->firmware_state, ha->addl_fw_state,
 			      timeout_count));
-		if (is_qla4032(ha) &&
+		if ((is_qla4022(ha) || is_qla4032(ha)) &&
 			!(ha->addl_fw_state & FW_ADDSTATE_LINK_UP) &&
 			(timeout_count < ADAPTER_INIT_TOV - 5)) {
 			break;
-- 
2.42.0.windows.2

