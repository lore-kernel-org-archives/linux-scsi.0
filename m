Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7046719AD8D;
	Fri, 29 Nov 2024 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732894355; cv=none; b=kCwrI+NNDufaYC/zsCO0nTK/vX4pROlBoUHELe/xfcNUzkZKQobEh5lUpXuZuUEvKw9+GbiGDWrgxKD/IQZHIaFGzbzx3KZzwGX7aPKfCONyBMlvNRbDHNCRI+2a6d8djmpLiWMSSpJABNjB4HLRtySCBRodsSoIRbBZHCki0Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732894355; c=relaxed/simple;
	bh=HqKp4pZYLOOJ9PKWiNHkBeid6ZqL+Yq42Dyw19NuLzE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dpSGTrOpHoKxWN9GnmHUBXXo7MZGAb3PVZUWQ/pVPVYP4VrgfcSRAG5bj4YGY33SsyQ73hWs0XZmoWeBTOiuUFVdZ7WSNNC5yBA57GT6iCBTb0+M+jXwcZZdgIXHwnEjdWeMEEh7mXMXIgByqRoUlVBf2Daf2aEJrJVEfYlAHaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=FQjUJ539; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=vmisQc/e; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="FQjUJ539";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="vmisQc/e"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 9E34BE0008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1732894348; bh=qelkvFIqTDcrX/c6d/5lNK7nISUQo0uKSwagX/sB1AE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=FQjUJ5392veDyfKAakEC9tvn89XtyI+ypZl9DYJ0ClaBWv6y2qIF+RW+YKW1oMykH
	 uucPPzWNnwQM9gld4lr+nG7YOdhLSO99GTDZ3ZbNTkaDx014dP+mc4cSqIgUa79dem
	 extgQmq0qDhYs6tTqbrh3caRpHGrafBq88EDLep1sh7cLc+VZX7n3Lb0KIcEHnLsPO
	 oPQECECLbn4aCJQAeu2l/1iVAGg50KkGZi6/kKPCYHNFXa9PL6tB5dGfeLWkIfkHV+
	 M0vNNFimboN7ZZIecKHiLBT1x1sE0IEycQNakMPCwAP6TpA6OBQoqLepy6ONhqA9hA
	 Vb2ASPYCx4iKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1732894348; bh=qelkvFIqTDcrX/c6d/5lNK7nISUQo0uKSwagX/sB1AE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=vmisQc/e3Y2EkUxJVnZQhl+dbVbkcreJ74qWbzvY2Wvd1jUBjQAkRs8kmajm/YA6R
	 AX9mn/9/gwul755A/UF+A6gmEesXwMAZtHQdRuCYmIGuI/Re+Kgul5ePRijF7Yl4/Y
	 XItSu4FaHM94TJSE5Ck1/NYaljky5uHGRRjLkeJn55v/RAXlXlVOG0k9As8a+hXWnj
	 UgYUYptQ5eWi9GHPtZRJwKTrE7+d0/c87Svgp98gesGmIeQa3Xx6VAVSsVrCwybZEQ
	 XKB6i0ENF/ZqVcyh7+Mz2i4VGQGhGklEmubw7S51/B5it8HxBBD8Wz0TBjaf/nGJ69
	 zW1xzObG8DKhw==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <martin.petersen@oracle.com>, <bootc@bootc.net>, <bostroesser@gmail.com>,
	<michael.christie@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux@yadro.com>
Subject: [PATCH 07/10] target: core: Extend CaW logging
Date: Fri, 29 Nov 2024 18:30:53 +0300
Message-ID: <20241129153056.6985-8-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.3
In-Reply-To: <20241129153056.6985-1-a.kovaleva@yadro.com>
References: <20241129153056.6985-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-09.corp.yadro.com (172.17.11.59) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

Pass se_cmd to the compare_and_write_do_cmp() for extended logging.

Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
---
 drivers/target/target_core_sbc.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 86b9a0bc6e90..22b705bc7f91 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -375,10 +375,12 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
  * @miscmp_off and return TCM_MISCOMPARE_VERIFY.
  */
 static sense_reason_t
-compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
-			 struct scatterlist *cmp_sgl, unsigned int cmp_nents,
-			 unsigned int cmp_len, unsigned int *miscmp_off)
+compare_and_write_do_cmp(struct se_cmd *cmd, unsigned int cmp_len, unsigned int *miscmp_off)
 {
+	struct scatterlist *read_sgl = cmd->t_bidi_data_sg;
+	struct scatterlist *cmp_sgl = cmd->t_data_sg;
+	unsigned int read_nents = cmd->t_bidi_data_nents;
+	unsigned int cmp_nents = cmd->t_data_nents;
 	unsigned char *buf = NULL;
 	struct scatterlist *sg;
 	sense_reason_t ret;
@@ -394,7 +396,7 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
 
 	rc = sg_copy_to_buffer(cmp_sgl, cmp_nents, buf, cmp_len);
 	if (!rc) {
-		target_err("sg_copy_to_buffer() failed for compare_and_write\n");
+		target_cmd_err(cmd, "sg_copy_to_buffer() failed for compare_and_write\n");
 		ret = TCM_OUT_OF_RESOURCES;
 		goto out;
 	}
@@ -413,7 +415,7 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
 			for (i = 0; i < len && addr[i] == buf[offset + i]; i++)
 				;
 			*miscmp_off = offset + i;
-			target_warn("Detected MISCOMPARE at offset %u\n", *miscmp_off);
+			target_cmd_warn(cmd, "Detected MISCOMPARE at offset %u\n", *miscmp_off);
 			ret = TCM_MISCOMPARE_VERIFY;
 		}
 		kunmap_atomic(addr);
@@ -425,7 +427,7 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
 		if (!cmp_len)
 			break;
 	}
-	target_debug("COMPARE AND WRITE read data matches compare data\n");
+	target_cmd_debug(cmd, "COMPARE AND WRITE read data matches compare data\n");
 out:
 	kfree(buf);
 	return ret;
@@ -479,12 +481,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 		goto out;
 	}
 
-	ret = compare_and_write_do_cmp(cmd->t_bidi_data_sg,
-				       cmd->t_bidi_data_nents,
-				       cmd->t_data_sg,
-				       cmd->t_data_nents,
-				       compare_len,
-				       &miscmp_off);
+	ret = compare_and_write_do_cmp(cmd, compare_len, &miscmp_off);
 	if (ret == TCM_MISCOMPARE_VERIFY) {
 		/*
 		 * SBC-4 r15: 5.3 COMPARE AND WRITE command
-- 
2.40.3

