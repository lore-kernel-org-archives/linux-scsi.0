Received: from out28-221.mail.aliyun.com (out28-221.mail.aliyun.com [115.124.28.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528B512B94;
	Fri, 16 Oct 2026 07:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792134559; cv=none; b=n7dlE0Bv7QoNeUFbJwYZ/eqJygPqqDTBGMm7BnJ8X6nEGbxpljNVH7Q44qDVIdNRDvaU2Mma/vm1S2TInDW/wxu+HpYVzmNMDX8q2oJxQBc7skgTk7AvZz6URhaCo/tpvDMUDF/C+d/vRjfNC1a7Ni+R4mp5gR0sNa1cfjSQyYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792134559; c=relaxed/simple;
	bh=JGhbFoMjIp2HJITS9fWWLGbxGA1uhdBDi0HItF4IXs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/lOgrxZoKUdz+x79FXVtDnGm4i0xNsJMMmL90gMKpeVrz9Ydggr12EYd0AUdgiqp7yZF7FoPuF/Wgrj1d8H7sS35IKOdMsxaL7oZalaYOXGHTrdfwsVNIOyp/uNEL5TPj6JDHJl3YSiT1dCAo7aZQJ8MeeuuPHb7ZNqGY9O25A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=b02fXNNw; arc=none smtp.client-ip=115.124.28.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="b02fXNNw"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1792134546; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=mMUKFStFuGDOgA3Mp4/58wDT/3w5ShHljK9O89VxF6c=;
	b=b02fXNNwIc2Jcw+skDeIHpSeJGNC6Tr2Rr1yhCygLjCUF8u7Q2DTAyKW3w3QGV2b2BqbZKDxa+WOMV83ECZMCh7DhkpQ2m+Yi8JR5sc5fHKHAewDL5MFNJmWQYiSmrV268zHA1/G3VovDov9S9aDW5ZUQD2Or3zrSnh/GnO2n7o=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07471094|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.226883-0.00234884-0.770768;FP=10254528247144974291|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam011083013073;MF=liuwb@xiaopeng.com;NM=1;PH=DS;RN=11;RT=11;SR=0;TI=SMTPD_---.jg64wPY_1792134544;
Received: from localhost(mailfrom:liuwb@xiaopeng.com fp:SMTPD_---.jg64wPY_1792134544 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 16 Oct 2026 15:09:05 +0800
From: Weibin Liu <liuwb@xiaopeng.com>
To: suganath-prabu.subramani@broadcom.com,
	sreekanth.reddy@broadcom.com,
	sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	stable@vger.kernel.org,
	Guanglei Zhu <zhugl3@xiaopeng.com>
Subject: [PATCH v2] scsi: mpt3sas: fix OOB SGE write at the request frame boundary
Date: Fri, 16 Oct 2026 15:09:03 +0800
Message-ID: <20261016070904.3566806-1-liuwb@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <sashiko-outbox-172135@kernel.org>
References: <sashiko-outbox-172135@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The MPT3COMMAND ioctl validates the user-supplied data_sge_offset
with

	if (karg.data_sge_offset * 4 > ioc->request_sz ||
	    karg.data_sge_offset > (UINT_MAX / 4))

which only keeps the start of the SGE array,

	psge = (void *)request + (karg.data_sge_offset * 4),

inside the request frame.  The SGE builders, however, write complete
SGEs at psge: _base_build_sg() and _base_build_sg_ieee() emit up to
two SGEs for dual-direction requests, and the MCTP passthrough path
always builds both an H2D and a D2H SGE.  When data_sge_offset * 4
is within 2 * sge_size bytes of the end of the request frame, those
writes cross the frame boundary and corrupt the adjacent frame in
the contiguous request DMA pool.

Require room for two SGEs of the largest format in use past
data_sge_offset, mirroring the max_sge_elements computation in
_base_get_ioc_facts(), so that the SGE builders can never write
outside the request frame:

	sge_room = 2 * max_t(u16, ioc->sge_size, ioc->sge_size_ieee);
	if (sge_room > ioc->request_sz ||
	    karg.data_sge_offset * 4 > ioc->request_sz - sge_room ||
	    karg.data_sge_offset > (UINT_MAX / 4))

Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Cc: stable@vger.kernel.org
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Reviewed-by: Guanglei Zhu <zhugl3@xiaopeng.com>
---
Changes in v2:
- v1 only rejected offsets that place psge at or past the end of the
  request frame.  As the Sashiko AI review of v1 pointed out, offsets
  that merely leave less room than the SGE builders need (up to two
  SGEs, 16 bytes each with 64-bit DMA) still allowed the SGE writes
  to cross the frame boundary.  Require room for two SGEs of the
  largest format in use so that no builder can write outside the
  request frame.

 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 8bb947004885..2fef6aa83d34 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -716,6 +716,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	size_t data_in_sz = 0;
 	long ret;
 	u16 device_handle = MPT3SAS_INVALID_DEVICE_HANDLE;
+	u16 sge_room;
 	int tm_ret;
 
 	issue_reset = 0;
@@ -738,8 +739,16 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		goto out;
 	}
 
-	/* Check for overflow and wraparound */
-	if (karg.data_sge_offset * 4 > ioc->request_sz ||
+	/*
+	 * Check for overflow and wraparound.  The SGE builders write up
+	 * to two SGEs at psge (dual-direction requests get a WRITE and a
+	 * READ SGE, and the MCTP passthrough path always builds an H2D
+	 * and a D2H SGE), so the request frame must have room for two of
+	 * the largest SGE format in use past data_sge_offset.
+	 */
+	sge_room = 2 * max_t(u16, ioc->sge_size, ioc->sge_size_ieee);
+	if (sge_room > ioc->request_sz ||
+	    karg.data_sge_offset * 4 > ioc->request_sz - sge_room ||
 	    karg.data_sge_offset > (UINT_MAX / 4)) {
 		ret = -EINVAL;
 		goto out;
-- 
2.50.1

