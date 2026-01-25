Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98152701CF;
	Sun, 25 Jan 2026 16:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769357534; cv=none; b=RnxnLVmGnPEOQJ4TmOGxlyW+XvZBak7pbxY/xWkoSufZ245qA2qGj5e4Y8cfLIXX8btC49hWtx9aBAlefTYKo2zozS6ayxnOm5tTEd4lWW6+qaMUXYCOsnsQLnE+5TJh+xkcDJ82/jaWkctB/5UfHEcrU/EGZugKN0pEFzSjyQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769357534; c=relaxed/simple;
	bh=h8iQDJ4naQ8Mp4cUa8Pth+gQcxS248SX1gtYD2G2Ztc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cZUuLA99l+/J3o2rZIGzmJ3wkDwLdXk+w+Yt6t+ogblhddmloWvt8lNUJINxmGYOvZu4p15ysp3xBnzr89DKBxtZKQNlvkQoyg8fnh6v53yYx/jqcjhYDJw9+a0435i77srH2jBoISTI7fWMTM4VSwOwNNdH81c1QlDcCguptZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn; spf=pass smtp.mailfrom=isrc.iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=isrc.iscas.ac.cn
Received: from localhost.localdomain (unknown [36.112.3.223])
	by APP-01 (Coremail) with SMTP id qwCowAB3427SQHZp9kYxBg--.54709S2;
	Mon, 26 Jan 2026 00:12:03 +0800 (CST)
From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Subject: [PATCH] scsi: mpt3sas: fix a potential memory leak in scsih_pci_slot_reset()
Date: Mon, 26 Jan 2026 00:12:01 +0800
Message-Id: <20260125161201.2156109-1-lihaoxiang@isrc.iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAB3427SQHZp9kYxBg--.54709S2
X-Coremail-Antispam: 1UD129KBjvdXoW7GryUZry3XF4Dtw47uw13CFg_yoWfGwcEgw
	42gr97Aw10krs2yay8A347uryavFykZw1kurs0vay5Ar17ZF4Dtrs7Z3Z5Jr4UX3yIya4U
	Gw15Z3s3CryUJjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbckFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
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
X-CM-SenderInfo: 5olkt0x0ld0ww6lv2u4olvutnvoduhdfq/1tbiCRASE2l2MSIRZAAAsh

In scsih_pci_slot_reset(), if mpt3sas_base_hard_reset_handler()
fails, call mpt3sas_base_unmap_resources() to release the memory
allocated by mpt3sas_base_map_resources().

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 7092d0debef3..7a884a278163 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12529,8 +12529,9 @@ scsih_pci_slot_reset(struct pci_dev *pdev)
 
 	if (!rc)
 		return PCI_ERS_RESULT_RECOVERED;
-	else
-		return PCI_ERS_RESULT_DISCONNECT;
+
+	mpt3sas_base_unmap_resources(ioc);
+	return PCI_ERS_RESULT_DISCONNECT;
 }
 
 /**
-- 
2.25.1

