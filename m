Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DD73D1718;
	Wed, 15 Jul 2026 08:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784105216; cv=none; b=W/K2Kv+FnK3W1V/8eTg9An8/B7nN2t7o8NXnUGnuRATW/OVagY8B0WRnkyWRsse460U2L59Cw1+undLp4wkE5Rcd6iDDke+5sjmfRM7IM8u8MlzshayiBnzXttj5g4a8uQWs4cZfu544DmvEvHsC3lCEk72ybenha0Qqu5S62Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784105216; c=relaxed/simple;
	bh=spXNDtlKlYRaVZEpFCLB8bLI1ZdvB/oH5+tFTLWukWA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ODoooCfzD0x3l/Hwpg4DiKwkONUL6ZXsAw+uVcFM96ZsZ9oXlpyOfPxAlzERb9fw5QnnLr9xPfMSnV9X2kv1bwy/iHu2IMzgi/U2F81djATC/Jka4my+FeamxjH43iIHf9OCJIIPadtvTy+EaN03Ryj8zeZAhiIg0+l77J6YI94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowACXB+v8SFdqE4JHGA--.7917S2;
	Wed, 15 Jul 2026 16:46:52 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: martin.petersen@oracle.com
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	James.Bottomley@HansenPartnership.com,
	aradford@gmail.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] scsi: 3ware: bound firmware error strings
Date: Wed, 15 Jul 2026 16:46:50 +0800
Message-ID: <20260715084652.47248-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACXB+v8SFdqE4JHGA--.7917S2
X-Coremail-Antispam: 1UD129KBjvdXoWruF4UZw4rWFWrArWkCFykKrg_yoWxuwb_Cw
	n2kF18Kw4Fgw429w4ftFW2vrZ3Ka47XF1rX3yagws09w17AFnaqFn3Gry5Kr13Ww4Fqrnx
	JrWayan3ZFyIgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j
	6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfU8-
	B_UUUUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

The 3w-9xxx and 3w-sas drivers parse a fixed firmware-owned field
containing a description and an optional second string.  Both drivers must
terminate the field before finding that optional string and must not form a
pointer one byte past the field when the first string consumes its last
byte.

Changes in v2:
- Group the two same-root SCSI fixes into one ordered series.
- Factor the repeated bounded optional-string handling into one helper per
  driver.
- Preserve the prior standalone submission lineage below.
Link: https://lore.kernel.org/r/20260704010512.71912-1-pengpeng@iscas.ac.cn
Link: https://lore.kernel.org/r/20260704010619.81878-1-pengpeng@iscas.ac.cn

