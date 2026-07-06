Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234763B2FC2
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2026 17:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783359318; cv=none; b=jxQmpyZh7XKPttkVyQDZvKtpOWC3cVOQvcu3NC1c4XErW3s2LJAvUAB/u6gn88ae7JM4DMqCnPiAVL5riMo8XRoWlNMMZHZdXKVsbc1U3/HZLntLTWgn1JcWlIUFSG/kENe2MRO70HmKx4USzpOQt2CvIG0/gikyBYJX8t0JU3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783359318; c=relaxed/simple;
	bh=LeVNW5GNhWlJ4w9tsYeK2NqLr4voIZpprTxNOLRvwm8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PdNRb2O9AqwZU0cdlAaEtl1svTyuS38H1j4MPPv0FgcNQaGVbSYz+9pzHH3gYraGIsSD8rx+2m6hOL8KRe8eIRTk5Sc490PfYsTvMnWPAyyXcFU9H7NBEAMCOAfkhzwY9n7NKyowhLX3PNwcFzKhPeu1D7hT00SIsP9dv46V8M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Bah5XOkX; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Bah5XOkX"
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 666GjPs72082212
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jul 2026 10:35:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=6uEP8ifoYYjT+e6tcibpllFYgB3zeeZ4YI+fkDocXCQ=; b=Bah5XOkXhV3b
	KoKbrVVpu6oOny6Zb56Ku7a+nA7ifRkOT8dUkBqlGikHNBImMYzg8aT+nBiOyTxF
	cnfJXQeSxOArnq5QQ8aMuk1Njx+Z5h/WkTWysffWJb13oSVuCyOP5g2QfHchiIpg
	8pLTL47zkcwdnmqN4vYqQvD9/mkItd3DcHwN+/HYrvH/wS/ONXYauy12fl+G3MsD
	rm5YrCGcAXRflU6hqgSdy/PBweFxoTCW68OYtlRbRbJI0GSQmWXaWoERlOrljxfV
	HKrcCQ9AHa8mohMXuPWTslep9bO2aKEsXCs25g/cAtxwpq29eog/t3lObrSveuCX
	3crjUmykkA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 4f6wuac7f4-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2026 10:35:15 -0700 (PDT)
Received: from twshared2511.04.snb2.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 6 Jul 2026 17:35:14 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 93D08249DC71C; Mon,  6 Jul 2026 10:34:56 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>
CC: <linux-scsi@vger.kernel.org>, <axboe@kernel.dk>, <hch@lst.de>,
        <bvanassche@acm.org>, <sumit.saxena@broadcom.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [RFC PATCH 6/6] scsi: add shared-tag fairness to host_tagset drivers
Date: Mon, 6 Jul 2026 10:34:38 -0700
Message-ID: <20260706173438.3537347-7-kbusch@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260706173438.3537347-1-kbusch@meta.com>
References: <20260706173438.3537347-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE3NyBTYWx0ZWRfX745RpxVGYkgg
 CIm/sgbnUEQb3lznoy/du2qCer+ACyDV8ESw8FFVURVrVR3G8vvOVxjKV3zj8qE3PKxS+VS9Uke
 YddLsKfJhH2mKYKamPqaNIIeYnhhUDU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE3NyBTYWx0ZWRfX/ggKoUoC4BO3
 FacwGWxT6fUGiyMBPDKgyVRwBo44vR/5MoF8VCUnu4F2QwfpF7iUMakr7YhLkutL0m1BXXbVIQr
 YcT5n9wPX4CIosrcjhzrvvEmtkM1ZgwrWYsik6gcfPq7E4SgpBuVh7dtAhqEvcBETLn5/WEFLak
 Ke+oLHUqtlqv6vWxeK9zsowCFAzv4etyBG3syXHL1nVqeiVyJhQlrm29R9qG+Dw5lWaLPe5kFOq
 /dst4J0WXs1kAzMztvj9z5JMHKkUiujH9qsYnvjc7GC5FvHPZtYtPnDPAbEYZH/9P8B6ctMskMJ
 DYth2W3OqZd/SZ//XtlS58fpjyYUYD+j4WOozcybf3imzzzAuW9NHH29FMAA+3uw0/rkQW7wnCc
 h2kmNkdioRurhZgNNd03sxhCSbhXQ+ckYeZu18BsGBMRqNi5YktvI9kwwvOMDukjfRE9mTZlqNi
 vKTjXsz8PEUF4gFJvQg==
X-Proofpoint-GUID: 0weIsKUf85IgtC2i1F8Jbur1tKIBdizv
X-Proofpoint-ORIG-GUID: 0weIsKUf85IgtC2i1F8Jbur1tKIBdizv
X-Authority-Analysis: v=2.4 cv=AsDeGu9P c=1 sm=1 tr=0 ts=6a4be754 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=_78whYxrdx1mplLwxq1U:22 a=VwQbUJbxAAAA:8 a=ZQO4bgSBkVxASXuM_48A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_02,2026-07-06_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Introduce a per-host shared_pct into the scsi block tag set so
host_tagset drivers can choose how much of the shared pool stays carved
into per-LUN exclusivity versus shared by everyone. This may be useful
for UFS where the sharing is harmful to performance.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/scsi/scsi_debug.c | 8 +++++++-
 drivers/scsi/scsi_lib.c   | 4 +++-
 include/scsi/scsi_host.h  | 8 ++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9d1c9c41d0f99..cb2bec76ba3de 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -905,6 +905,7 @@ static int sdebug_every_nth =3D DEF_EVERY_NTH;
 static int sdebug_fake_rw =3D DEF_FAKE_RW;
 static unsigned int sdebug_guard =3D DEF_GUARD;
 static int sdebug_host_max_queue;	/* per host */
+static int sdebug_shared_pct;		/* host_tagset shared tag pool % */
 static int sdebug_lowest_aligned =3D DEF_LOWEST_ALIGNED;
 static int sdebug_max_luns =3D DEF_MAX_LUNS;
 static int sdebug_max_queue =3D SDEBUG_CANQUEUE;	/* per submit queue */
@@ -7343,6 +7344,7 @@ module_param_named(fake_rw, sdebug_fake_rw, int, S_=
IRUGO | S_IWUSR);
 module_param_named(guard, sdebug_guard, uint, S_IRUGO);
 module_param_named(host_lock, sdebug_host_lock, bool, S_IRUGO | S_IWUSR)=
;
 module_param_named(host_max_queue, sdebug_host_max_queue, int, S_IRUGO);
+module_param_named(shared_pct, sdebug_shared_pct, int, S_IRUGO);
 module_param_string(inq_product, sdebug_inq_product_id,
 		    sizeof(sdebug_inq_product_id), S_IRUGO | S_IWUSR);
 module_param_string(inq_rev, sdebug_inq_product_rev,
@@ -7427,6 +7429,8 @@ MODULE_PARM_DESC(guard, "protection checksum: 0=3Dc=
rc, 1=3Dip (def=3D0)");
 MODULE_PARM_DESC(host_lock, "host_lock is ignored (def=3D0)");
 MODULE_PARM_DESC(host_max_queue,
 		 "host max # of queued cmds (0 to max(def) [max_queue fixed equal for =
!0])");
+MODULE_PARM_DESC(shared_pct,
+		 "host_tagset: %% of the shared tag pool shared by all LUNs (0=3Dexclu=
sive, 100=3Dno fairness, def=3D0)");
 MODULE_PARM_DESC(inq_product, "SCSI INQUIRY product string (def=3D\"scsi=
_debug\")");
 MODULE_PARM_DESC(inq_rev, "SCSI INQUIRY revision string (def=3D\""
 		 SDEBUG_VERSION "\")");
@@ -9569,8 +9573,10 @@ static int sdebug_driver_probe(struct device *dev)
 	 * following should give the same answer for each host.
 	 */
 	hpnt->nr_hw_queues =3D submit_queues;
-	if (sdebug_host_max_queue)
+	if (sdebug_host_max_queue) {
 		hpnt->host_tagset =3D 1;
+		hpnt->shared_pct =3D sdebug_shared_pct;
+	}
=20
 	/* poll queues are possible for nr_hw_queues > 1 */
 	if (hpnt->nr_hw_queues =3D=3D 1 || (poll_queues < 1)) {
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 22e2e3223440d..efcb49af899a2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2152,8 +2152,10 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	if (shost->queuecommand_may_block)
 		tag_set->flags |=3D BLK_MQ_F_BLOCKING;
 	tag_set->driver_data =3D shost;
-	if (shost->host_tagset)
+	if (shost->host_tagset) {
 		tag_set->flags |=3D BLK_MQ_F_TAG_HCTX_SHARED;
+		tag_set->shared_pct =3D shost->shared_pct;
+	}
=20
 	return blk_mq_alloc_tag_set(tag_set);
 }
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7e2011830ba4b..68c99bc7ad865 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -694,6 +694,14 @@ struct Scsi_Host {
 	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
 	unsigned queuecommand_may_block:1;
=20
+	/*
+	 * For host_tagset hosts: percent of the shared tag pool made available
+	 * to all LUNs rather than reserved as per-LUN exclusive floors. See
+	 * blk_mq_tag_set.shared_pct. 0 (default) divides the pool exclusively;
+	 * 100 lets every LUN allocate from the whole pool with no fairness.
+	 */
+	unsigned int shared_pct;
+
 	/* Host responded with short (<36 bytes) INQUIRY result */
 	unsigned short_inquiry:1;
=20
--=20
2.52.0

