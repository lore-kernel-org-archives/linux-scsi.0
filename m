Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B97367B6C;
	Wed,  1 Jul 2026 05:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782884196; cv=none; b=aznkJ7OSCT7B9UC6i0C0rSgjp3E2kB7uWuOR+BDvn9mqg74fgXnI8WehyEihcZrKWk6tArr4+nKSKlbm20/SOcMkZ2ikLB4la4Yo9zhg5h2lmP/K/hGcBi025NOi+M0twYaeMZxAAcq3eACYq5zd4XilDQw2UviMjx91xYyDAFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782884196; c=relaxed/simple;
	bh=O8KZ/89uBb4t5wM6zxP1pL8sEHjrzoPb28RohCb36Us=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=osuALYg8zjL50qBLAwHfSgpsZYcSJNnyOfTQCilh1Zrg2t3eXJZgFHGg0Y3bqSyTjT2ZKu3jyCXxY3V228KD2iMvQVXxVirJ7VTdcdELsuYJ64FgKh07m+RSr5LfAe/w47+4ui6j+fDQ6o6YKReLd+mtUyxhFyh3ZuhhPFLUdF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-03 (Coremail) with SMTP id rQCowABngNdbp0Rqjc+HFg--.52043S2;
	Wed, 01 Jul 2026 13:36:28 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: hpsa: clamp physical LUN count in fallback report
Date: Wed,  1 Jul 2026 13:36:26 +0800
Message-ID: <20260701053626.44118-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABngNdbp0Rqjc+HFg--.52043S2
X-Coremail-Antispam: 1UD129KBjvJXoWrZrWfJr4fAr4rWw15Wr15urg_yoW8JF1fpF
	Z5Ga42yF92yryfKrsrW3yv934Yqa4rJryUGa1Uu345uas8GryxWFWUWry0qFyrCrsYg3yD
	tF1kta4xWFW5WFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQo7NUUU
	UU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

When REPORT PHYS EXTENDED is not supported,
hpsa_scsi_do_report_phys_luns() falls back to REPORT LUNS and converts
each 8-byte LUN entry into the extended report buffer. The number of
entries comes from the device-provided LUNListLength field, but the loop
did not clamp it to either the source ReportLUNdata array or the
destination ReportExtendedLUNdata array.

Clamp the converted count to both arrays and update the output
LUNListLength to match the entries that were actually copied.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/scsi/hpsa.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a1b116cd..a7115efd 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3797,6 +3797,10 @@ static inline int hpsa_scsi_do_report_phys_luns(struct ctlr_info *h,
 		/* Copy ReportLUNdata header */
 		memcpy(buf, lbuf, 8);
 		nphys = be32_to_cpu(*((__be32 *)lbuf->LUNListLength)) / 8;
+		nphys = min_t(u32, nphys, ARRAY_SIZE(lbuf->LUN));
+		nphys = min_t(u32, nphys, ARRAY_SIZE(buf->LUN));
+		put_unaligned_be32(nphys * sizeof(buf->LUN[0]),
+				   buf->LUNListLength);
 		for (i = 0; i < nphys; i++)
 			memcpy(buf->LUN[i].lunid, lbuf->LUN[i], 8);
 	}

