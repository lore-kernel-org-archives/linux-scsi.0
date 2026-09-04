Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8AD3A4510
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 09:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788514121; cv=none; b=ij9WNSZw+pNx7h1Grs1rf7xqoiFduouPR8nFsOUS5qNOfZlpAp+UmQoXh5vNycrR9KozdQn3CvAlBlqOb0stxmKjpEtDzOQcmujs6ki/h1FHZdk+/y0oZj3D+GskAZHn2+TpLkpTSNoeNppniWe5XU3jic4zMVIHBMBEEKK0cDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788514121; c=relaxed/simple;
	bh=Z1I/J7lwSRYQWfAPyvrHuXZUSxt9qnHtOtcoN56nNRk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lUhIAlac0CRQUchksIKz1bppQusSzmI5qpaZ0EKm3gj+aZLvKHHejeFmF1eDTFD+0AKPIXikGJLt0nUjUVMg44p3m0SVLaFeworB1bdx2n8kt2+Azf8b8ehJU7sjWiluuS9T7Gy04YEc0Loe96JxRE/LTeAIw3obO7ddW25vtRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=OmjhLAoz; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="OmjhLAoz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=oe
	g0mLDemFYqLpCw1Oje4bppEWvPjDz8JraMi3ANq8o=; b=OmjhLAoz0EtR1HF5xL
	MAfrSm4BN3y7tjPu1XDxe+M3eQ95wuzAyszOxMjhCZlAnWq+oUjEUpptyrjWyJRv
	J4q3JmQEgQ3EAcJd6AGtJULVh2FG7OVC2OGrokezmfOn+K5/U7WE33RXFGFE4bqB
	HFzGiPpeejFy1zoMigivLTRQQ=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDXqSUNj5pqZBzPPw--.20052S2;
	Fri, 04 Sep 2026 17:27:42 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com
Cc: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	Li Youhong <liyouhong@kylinos.cn>
Subject: [PATCH] scsi: megaraid_sas: fix hb_host_mem leak on init failure
Date: Fri,  4 Sep 2026 17:27:40 +0800
Message-Id: <20260904092740.2612033-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDXqSUNj5pqZBzPPw--.20052S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CFyxGr1kCry3Gw4UJFyfXrb_yoW8Wr1fpr
	95Kr17tr1UZw40grWDur4rCayjyw4rtas8KrW8t34Ykw1YqryqvFs2va1fZ3Z7JFZ3t3ZI
	qF1qgr48CFW5Jr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjZXrUUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3Q8o1mqajw-iaAAA3W

From: Li Youhong <liyouhong@kylinos.cn>

hb_host_mem is allocated in megasas_sriov_start_heartbeat() but only
freed in megasas_detach_one(). megasas_init_fw() and megasas_resume()
failure paths clean up through megasas_free_ctrl_dma_buffers(), which
did not free this buffer.

Move the free from megasas_detach_one() into
megasas_free_ctrl_dma_buffers().

Fixes: 229fe47cd046 ("[SCSI] megaraid_sas: Add Dell PowerEdge VRTX SR-IOV VF support")
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f0152b043e18..b1fbe06d3c67 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7404,6 +7404,12 @@ void megasas_free_ctrl_dma_buffers(struct megasas_instance *instance)
 				  instance->host_device_list_buf,
 				  instance->host_device_list_buf_h);
 
+	if (instance->hb_host_mem)
+		dma_free_coherent(&pdev->dev,
+				  sizeof(struct MR_CTRL_HB_HOST_MEM),
+				  instance->hb_host_mem,
+				  instance->hb_host_mem_h);
+
 }
 
 /*
@@ -8081,11 +8087,6 @@ static void megasas_detach_one(struct pci_dev *pdev)
 				    instance->vf_affiliation_111,
 				    instance->vf_affiliation_111_h);
 
-	if (instance->hb_host_mem)
-		dma_free_coherent(&pdev->dev, sizeof(struct MR_CTRL_HB_HOST_MEM),
-				    instance->hb_host_mem,
-				    instance->hb_host_mem_h);
-
 	megasas_free_ctrl_dma_buffers(instance);
 
 	megasas_free_ctrl_mem(instance);

-- 
2.25.1

