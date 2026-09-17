Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2974DDB45;
	Thu, 17 Sep 2026 15:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658258; cv=none; b=Nyzn/zxlIZgFKK4a0cqqZ4V9kH7IY04A6Lvm9xy6kamLh/chjfYdIbzQFly94pcf+DmMrXSRvTQg7e87lG91FrfIpqajkH1a3xWJueDpKvwfNG16BuTHpsO/vV2XRonkqAry0Zfw25TEVXtdcY+tLkKK1qN8AFYP6BBgDTHa6u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658258; c=relaxed/simple;
	bh=MyrCZPq1zLdshcZFFuVAg7Lo1rP5zN/MNNiF+2MWjgk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nsqcyOtwBR5U85PqP1k9fBCc3ePmzezSwE+bZLh10cBaPy4Fr19GtJeqtr+u1LA2zyS4Ia5kUmnqk6uUa2Tsvyn+hENw/5kLYz2eVDZxXMDEiwyJ//lFU+bYTscCzjYu4b6B40hDQLw7htNUPTKUlDvJxuQiVyuxp0xqo0exjMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowABHsTuABKxqsl2DCA--.5477S2;
	Thu, 17 Sep 2026 23:17:20 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	ranjan.kumar@broadcom.com,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: Fix sas_device reference leak in mpt3sas_transport_port_add()
Date: Thu, 17 Sep 2026 15:17:20 +0000
Message-Id: <20260917151720.2158664-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABHsTuABKxqsl2DCA--.5477S2
X-Coremail-Antispam: 1UD129KBjvJXoW7XryxJF1Duw4fCFy3JryrZwb_yoW8JrWfpa
	yDCa4Yyas8Gw4I9rn7Gw15JF4rX3W7C3s8KFW0v3Z5ur4UJFyft34I9rs0qF1UArZ3Ja98
	Jr4DJrZ5CF4UJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPvb7Iv0xC_KF4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI
	0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
	Yx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26F4UJVW0owAm72CE4IkC6x0Yz7
	v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0E0s8F02x267IIx4CEVc8vx2IErcIFxwAC
	I402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrw
	CF04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E
	5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtV
	W8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY
	1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14
	v26r4UJVWxJr1lIxAIcVC2z280aVCY1x0267AKxVW0oVCq3bIYCTnIWIevJa73UjIFyTuY
	vjxUFBT5DUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRMNA2qr9LYmfgAAsP

mpt3sas_get_sdev_by_addr() takes a reference on the sas device for SAS
end devices, but it is only dropped on the success path. When the port
cannot be created, for example because the parent device is missing,
sas_port_add() or sas_rphy_add() fails, the function bails out to
out_delete_port/out_fail without releasing the reference.

Drop the reference on the out_fail path.

Fixes: 7d310f241001 ("scsi: mpt3sas: Get device objects using sas_address & portID")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e74a526efa8d..f831d4823503 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -869,6 +869,8 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	list_for_each_entry_safe(mpt3sas_phy, next, &mpt3sas_port->phy_list,
 	    port_siblings)
 		list_del(&mpt3sas_phy->port_siblings);
+	if (sas_device)
+		sas_device_put(sas_device);
 	kfree(mpt3sas_port);
 	return NULL;
 }
-- 
2.34.1

