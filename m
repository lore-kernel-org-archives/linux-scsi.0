Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F72618DF8D;
	Sat, 10 May 2025 10:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746871236; cv=none; b=uHkEGiFoTfXCcL04nuctDPYbUYeGhatK214YqbXqXSO5VgtyzIyp0hpbbpsVGKFLLdeIljDWjOi+Kh+jhH0cgubsi8f/1/sYcHw8gJXn2pEBROY27w78OsVir7dyL3cqGC995ak6CiPinknoR5Rt2WZQ7vng9oWV4V2yH2dvnrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746871236; c=relaxed/simple;
	bh=Pi3y4dmEW1UEme+HX6yYi09ZtTkO/xqgAF/M7VX6HHw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qyCuMaL1+vEYEeZaFhERp3J/ZTD84P71wISLcZrJgiEXB8fF471rHxPHunxA7hunc7SqUFu3HiKsvV5qS3PCql/DEH63A30hY2jVnEMwW09AfrLqqWq/AZtAtgZoBDq/w9tBiWwovjs6UXU/IOfnnP36ksTHb2FMiarrm6m3pSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.199.70.239])
	by APP-05 (Coremail) with SMTP id zQCowADnJg8iIh9oBnoDEw--.48103S2;
	Sat, 10 May 2025 17:53:42 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: njavali@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: mrangankar@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [RESEND PATCH] scsi: qla4xxx: Add missing is_qla4022 check in device initialization
Date: Sat, 10 May 2025 17:52:57 +0800
Message-ID: <20250510095257.921-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.42.0.windows.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADnJg8iIh9oBnoDEw--.48103S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JFWxGryUGF1rGw15XFWfGrg_yoWkuwb_ua
	10v34Iv3ZIyr4kZ3W7XF18JFnavrsYqr1jq34Sqr4fA34UZ3s3Xryqv343Zw15G3yjyasx
	Gws5Xry5Ar1fKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Jr0_
	Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUYCJmUU
	UUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAYSA2gesI3jzAAAs-

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

