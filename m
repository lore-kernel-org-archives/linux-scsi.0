Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA4D246788;
	Thu, 17 Sep 2026 15:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789657819; cv=none; b=h1BFZI/miuCFgibE4/ah+CbLHb1IbOe3+vUmMFaIhsHyENgJhytSk7CAtYa40ztLRAEHvNv1+jZWL+ZSrKT3zqCEKA/aQk0vTbO/jN5fGFYaDHddVGgOSbduePd26xLtVOKl0ms/5f1ieEMpepZjJ25QOicp8m/ZkKfCHhAE0OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789657819; c=relaxed/simple;
	bh=IRNAXAYORERSYLYEMnZ8WOVGtv+p/4vgQd4zzseasuI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ivwtHyKeF07c1iRBM3qqjkMmMrdYTJ7C0WaDzdGOtoh/jamJViAtYgfMoYaQHoJaTqhHRChKHok4Aaqd4vEPGl/oWEXP3Y4B8Ssd5CQAcinjSAlEDMRR2WRkDbr8aaLcDw/NpW1I3RgD3pKvjbzL2A/B37/QL9ocymfeUN0gL9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowAA3oz3LAqxqlDuDCA--.5466S2;
	Thu, 17 Sep 2026 23:10:03 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com
Cc: himanshu.madani@oracle.com,
	kashyap.desai@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	sumit.saxena@broadcom.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: Fix tgtdev reference leak in mpi3mr_sas_port_add()
Date: Thu, 17 Sep 2026 15:10:02 +0000
Message-Id: <20260917151002.2158393-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAA3oz3LAqxqlDuDCA--.5466S2
X-Coremail-Antispam: 1UD129KBjvJXoWrKr18Kw4rAFW8uFWrGF4DArb_yoW8Jr15pa
	nFqa45Aryqgr42vr1kGF42qF4ft3WDJ3s8KFW8t3sYkw4YyFy7Ary7ury0vFy8AFs7WFyr
	Zr4Dtr95Zr1DJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmlb7Iv0xC_KF4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI
	0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
	Yx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26F4UJVW0owAm72CE4IkC6x0Yz7
	v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0E0s8F02x267IIx4CEVc8vx2IErcIFxwAC
	I402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrw
	CF04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI
	1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
	Wlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I
	6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r
	1j6r1xMIIF0xvEx4A2jsIE14v26r4UJVWxJr1lIxAIcVC2z280aVCY1x0267AKxVW0oVCq
	3bIYCTnIWIevJa73UjIFyTuYvjxUFBT5DUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgkNA2qr888lIwAAs6

mpi3mr_get_tgtdev_by_addr() takes a reference on the target device for
SAS end devices, and it is only dropped on the success path. When the
function bails out to out_fail, for example because the parent device
is missing or sas_port_add() fails, the reference is never released
and the target device is leaked.

Drop the reference on the out_fail path.

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index a95c9352e859..5a0bc11a23c7 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1501,6 +1501,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	list_for_each_entry_safe(mr_sas_phy, next, &mr_sas_port->phy_list,
 	    port_siblings)
 		list_del(&mr_sas_phy->port_siblings);
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
 	kfree(mr_sas_port);
 	return NULL;
 }
-- 
2.34.1

