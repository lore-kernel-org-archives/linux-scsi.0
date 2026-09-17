Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BDF4D2ED9;
	Thu, 17 Sep 2026 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789655895; cv=none; b=Dfljw/spU3oxLZq2lAz8rES/zNO1wmIGtixz3QBqdB2uFHSZkLnXhfxAyIboHkWovAofIVfitsDs+g1QdJQXkvy2Fz7mPCpVHS0UVl7KRbQVG9FmWKJRK7Jv3WVgPvwfcA8Rm9P0ynVSFt4KNapLvh0IbNvGTyFs+qH7qgvg+B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789655895; c=relaxed/simple;
	bh=g1kI8CaQJuUyNGXO/JnpYheG/Qk/YV0V3SBNBh5sC6M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=COqKCtiXE+OeUaEM/XDaIgydyPDALB7xtEC48WNG3eB5LcExtpzd1//umQOlD3z9lfYitlToJEEFj5MBbMHwQdPChA/uBBOuXpBf6nOQ42M6mfpc3z/adHKJJybVBUFNHfnxWc3cXsY1eOHKoX0SCuD/zFZBufAOUx6ZM2Tbl4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowACXAz5I+6tquqaCCA--.4856S2;
	Thu, 17 Sep 2026 22:38:00 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: JBottomley@Parallels.com
Cc: James.Bottomley@HansenPartnership.com,
	djbw@kernel.org,
	jacek.danecki@intel.com,
	john.g.garry@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	stern@rowland.harvard.edu,
	yanaijie@huawei.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: libsas: Fix use-after-free in sas_suspend_devices()
Date: Thu, 17 Sep 2026 14:38:00 +0000
Message-Id: <20260917143800.2157286-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACXAz5I+6tquqaCCA--.4856S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF1DCw1xAr1DKryfWF1fXrb_yoW8Wr1xpF
	s3AFy2kFWDJa18Wan8Ww4q9FWYga4kK3yrCw45G345Ka4fAr98JFy8Gr4UZryrCrZ7WFZ0
	vr4DtryDJa1kJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPvb7Iv0xC_tr1lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
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
	vjxUFsjjDUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwENA2qr9tgKTAAAsh

sas_suspend_devices() walks port->dev_list with list_for_each_entry()
while sas_notify_lldd_dev_gone() may drop the last reference and free
the current device, so the next iteration dereferences freed memory.

Use list_for_each_entry_safe() to keep the next entry around.

Fixes: 303694eeee5e ("[SCSI] libsas: suspend / resume support")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/libsas/sas_discover.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index b07062db50b2..91045966612e 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -231,7 +231,7 @@ static void sas_probe_devices(struct asd_sas_port *port)
 static void sas_suspend_devices(struct work_struct *work)
 {
 	struct asd_sas_phy *phy;
-	struct domain_device *dev;
+	struct domain_device *dev, *n;
 	struct sas_discovery_event *ev = to_sas_discovery_event(work);
 	struct asd_sas_port *port = ev->port;
 	struct Scsi_Host *shost = port->ha->shost;
@@ -245,7 +245,7 @@ static void sas_suspend_devices(struct work_struct *work)
 	 * suspension, we force the issue here to keep the reference
 	 * counts aligned
 	 */
-	list_for_each_entry(dev, &port->dev_list, dev_list_node)
+	list_for_each_entry_safe(dev, n, &port->dev_list, dev_list_node)
 		sas_notify_lldd_dev_gone(dev);
 
 	/* we are suspending, so we know events are disabled and
-- 
2.34.1

