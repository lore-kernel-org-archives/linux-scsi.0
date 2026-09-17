Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EB14B44D8;
	Thu, 17 Sep 2026 15:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789657506; cv=none; b=lpdSuew+ygluk8xki+oUSY7h8mqSzRk2qwwA6fF9xDsCeXIxOk3OcqCzeTPEDG23Ub8pO+mGCj+RNR7JeIt7OvCG9In162S7jq11jjz7IhNlBAEIbruamIhsWVlsNFEJzPgiyxmoIcd6h3TaPM6BzaDN4rKr87+EV3IKUhHesOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789657506; c=relaxed/simple;
	bh=iUYMy/jPtd7swNRgdrUkgdWM4CgSi5DsQrBEn4Ousgo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=auj7wBnRKy3WqOlQE6DrgLQwPM/5j1pYha1PVsjFMUn3SjntZrhFtD4hT8+6iMnEaSo9UX7TCugO27BRTHEFnkYqR957GPh+NqnUps/FTmyICExyodfE99va55aomGrPg6lg0Sa54UmXDK26jwp7cXeoL+8WkV8dNwwfUngXDQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowACH8z2EAaxqASKDCA--.5391S2;
	Thu, 17 Sep 2026 23:04:36 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com
Cc: hare@suse.de,
	himanshu.madhani@oracle.com,
	kashyap.desai@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	sumit.saxena@broadcom.com,
	thenzl@redhat.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: Fix tgtdev reference count in mpi3mr_sastopochg_evt_bh()
Date: Thu, 17 Sep 2026 15:04:36 +0000
Message-Id: <20260917150436.2158151-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACH8z2EAaxqASKDCA--.5391S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw48WrWfJF1fArWDWrWDCFg_yoW8JF43pa
	n29a4Yyrs5WayIyw4xGF45WFyIy3ZFyrWrKayUKwn0gF4Fkry3CFy5CryDuFykAF97Xr1v
	vr1DJryfZF1UtrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmmb7Iv0xC_KF4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VAI37AI020EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMx
	AIw28IcVCjz48v1sIEY20_Gr43Wr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xF
	xVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWw
	C2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_
	JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr
	0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6xkF7I0E14v26rxl6s0D
	YxBIdaVFxhVjvjDU0xZFpf9x07UWCJPUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAENA2qr9nAaqwABs0

mpi3mr_get_tgtdev_by_handle() takes a reference on the target device
and the loop drops it with mpi3mr_tgtdev_put() at the end of every
iteration. The MPI3_EVENT_SAS_TOPO_PHY_RC_TARG_NOT_RESPONDING branch
drops the same reference a second time before breaking out, so the
reference is put twice and the kref can be released prematurely.

Drop the redundant put and let the loop release the reference once.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 0c974f2627d1..5ff5720f2491 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1869,7 +1869,6 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 			if (tgtdev->host_exposed)
 				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
 			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, false);
-			mpi3mr_tgtdev_put(tgtdev);
 			break;
 		case MPI3_EVENT_SAS_TOPO_PHY_RC_RESPONDING:
 		case MPI3_EVENT_SAS_TOPO_PHY_RC_PHY_CHANGED:
-- 
2.34.1

