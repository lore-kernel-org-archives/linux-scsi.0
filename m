Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989DA215075;
	Sat,  4 Jul 2026 01:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783127394; cv=none; b=L56jqKqzNOG7UzXiAYZah4nccrAYhhyRP51g8NVtcxkHGByIzqnTDFBqBSGXbc+oUt2qN5K1uDGM7sN24xTJMYt5v8bk1SpjyLjYoh7FHGQE0fh+DTIhHJA11GR7C6jR6QvLQwOmmp8HSZf8pl9UoQ1SYyv26ffiUGUWiKDLqJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783127394; c=relaxed/simple;
	bh=7sdzQ9GYnvBK1pPNhOde3D1gp3/5F+iYNxw8Hy+NYTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dy8rYLMnq733RkasgCNFDDcAIuruEAtLZ8hBk79Hc355c7cPsZUEOEb5DVAbQumsimSB/ymlzXYUWHdDVr0FdzcF/nEU1fPgEkzKxa1xdwUQKvL8jfhiGNu4JgYCtGzfEi0ne9+E3I0gstLSKpd7yBH0dblmoLWjf8gOLk/qWaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowAA3xglZXUhqmZfEFg--.53954S2;
	Sat, 04 Jul 2026 09:09:45 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH] scsi: hpsa: validate active path number before enclosure arrays
Date: Sat,  4 Jul 2026 09:09:43 +0800
Message-ID: <20260704010943.16707-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAA3xglZXUhqmZfEFg--.53954S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JFWfGFyfCry7JFyktFWfuFg_yoWfZwc_uF
	Z5ur4Iqw4jka4I93W7Krs5Z34I9w4xWr1Fka9FqrWfXa4Sqrsay34kJryrXw4UG3y8XF1q
	93Z09r48ZF4jkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbPl1P
	UUUUU==
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

hpsa_get_enclosure_info() uses the firmware-provided
active_path_number as an index into the eight-entry box[] and
phys_connector[] arrays in struct hpsa_scsi_dev_t.  The value is not
checked before the array write and connector copy.

Reject enclosure information with an out-of-range active path number
before updating those fixed per-path arrays.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/scsi/hpsa.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3501,6 +3501,14 @@
 
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
+		rc = -1;
+		goto out;
+	}
+
+	if (id_phys->active_path_number >= ARRAY_SIZE(encl_dev->box)) {
+		dev_warn(&h->pdev->dev,
+			 "%s: invalid active path %u for bdi[0x%x]\n",
+			 __func__, id_phys->active_path_number, bmic_device_index);
 		rc = -1;
 		goto out;
 	}

