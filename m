Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2566D22FDF0;
	Wed, 15 Jan 2025 07:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736924882; cv=none; b=b/AdQEVOsqxcGWP6hbbIep2ZPveBqAk3XYWZbQYrvznvX5VWoigpBk5DiNoN30h4yX3hx/Dv8TN0+3o/QD6SbGQCzOni3rDfoblBONkJtZOwOYhRhyqKN4Oog8eteR++JfMRTOYk2KS2xYjPuj+NXgegZs1SH6UzJb/VG7/cRE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736924882; c=relaxed/simple;
	bh=USDNyDYzARFNKpdQw2Ri7q5btk7h0WwRIUi3ES2XmUk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dU/xlEoJAko3AKhsspwQRIkdX9DxjsaFcie8WH/N60nOjurTwRo1pVJxuliBmoYp35UG+S3wEm8uVwaBKvCOu88Xzt54+obhIqZm0b9jU6M5jFJPpeFiz44y+xQPKSVxl4zkH0CXZ3Kph++hh94N4sPWtz+H+gq8WnQ8ZN8c5Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=cgrfTeWi; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="cgrfTeWi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=82Na0
	E6cXSPCtTmmiK9FiuD/ySIJCvmzFIqW6VIgQOw=; b=cgrfTeWi5KXN27Ly0eok1
	e8pwgmRqR/MZapeJlGM88BipkFIxNjr8eXQpHkAc8EWbuM8idkl6h5nU/+OEvmJg
	wmKGAiC5YCyfqwMsTdsfL1tNH4HPw/5rqdCyyE6q4jBEWgzAHz/OBXzRf3nuDSWV
	2Ac0qKfdlFJVLSKkoMLMj8=
Received: from wdhh6.sugon.cn (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3cy_EXodnt3jkFw--.49365S2;
	Wed, 15 Jan 2025 15:07:49 +0800 (CST)
From: Chaohai Chen <wdhh66@163.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chaohai Chen <wdhh66@163.com>
Subject: [PATCH] target: fix All_commands parameter data header size
Date: Wed, 15 Jan 2025 15:07:39 +0800
Message-Id: <20250115070739.216154-1-wdhh66@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3cy_EXodnt3jkFw--.49365S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw1xGw18AF45Gr1UKryxAFb_yoWDXwb_Cw
	1qqry7W34ruF1UKF4UC398X342yr18uFnavan0vFW7K34j9F1kAF97ursYk34Y9r4kXr9a
	vr9Fq34DCF45KjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8Xo7JUUUUU==
X-CM-SenderInfo: hzgkxlqw6rljoofrz/1tbiKA7V1meHWNt4dAAAsK

The SPC document states that "The COMMAND DATA LENGTH field indicates the
length in bytes of the command descriptor list".

The length should be subtracted by 4 to represent
the length of the description list, not 3

Signed-off-by: Chaohai Chen <wdhh66@163.com>
---
 drivers/target/target_core_spc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ea14a3835681..61c065702350 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -2243,7 +2243,7 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
 			response_length += spc_rsoc_encode_command_descriptor(
 					&buf[response_length], rctd, descr);
 		}
-		put_unaligned_be32(response_length - 3, buf);
+		put_unaligned_be32(response_length - 4, buf);
 	} else {
 		response_length = spc_rsoc_encode_one_command_descriptor(
 				&buf[response_length], rctd, descr,
-- 
2.34.1

