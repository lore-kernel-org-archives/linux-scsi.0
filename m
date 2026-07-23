Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8300230DEBA
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783232; cv=none; b=HntlPS1bGz0CCNr0/FD8vKM69D3WiWl5CMO530XXhy36VYlqddLwWuVIuI9AjMg/4Dwj/6f90H7LC63T9ZZd6hLh63QWdiTJ2eQO1lXgklB5JT9IrsW8Dk+vLnvd9re7qBQENtOWumQG2G7ubMTAVCMdSfyEH5TKCSm6hVi/gP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783232; c=relaxed/simple;
	bh=imQsF2vqR2kGYbvPbWnzkzseXDhT8Qo3mZJGNRnbZzE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ae5S1/TKZPR0I1ulp41jfek57bSqnV5ecpJTi6fYQna8tyrEFAdiKNQPr3vVcZ/Z2TEOqSvIK5grS0bXJieiWcnyl+QfDEGpHBLMMWzkYqsihKEdoR6Hk/5nQhgHISP4w2P4K/UbdkgwFlMAZEQ3UotMnYzetA9KY4OK74tMy3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=OupjfhML; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="OupjfhML"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vkD22441525;
	Wed, 22 Jul 2026 22:07:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=/
	hLugKSNqJKQ44KqCKu/YWOB/G2iIgSWItbqUFYZNz0=; b=OupjfhMLMysbRkKYy
	STp2916gkG4HxqmiaqT0fvbW3uE6fm6GMXZR++ZWKHv3eE00TzVo8kbEpbPGjvAo
	2muWHP6WpjJ3IJqNGS4MnRVGB7HWZd1TAoYEdp7uM8kv6UkRpDAzy7J4tI6Mmk9z
	ZzHsYiHaTXw5fp2Ic8nJgge7LCk4oI+AJh5qOuo4KDe4aKzgaBRI9ao/GFxIHlJ9
	qGyhMQtROrEPyi//NCOH4IrYNvI1z1NAICvlsAq0foMKBnMbVe5fU/qAJhkFZs5k
	TFf2cIkBjSmRvN1w6ah7uzaqIDlfkDIx1vjLVd7BToyYTIjUsIiGrFpiWws8ibSp
	qn/3g==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fk7jkrm4u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:07:07 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:07:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:07:05 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 6EB945C68E8;
	Wed, 22 Jul 2026 22:07:03 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 54/56] scsi: qla2xxx: Fix BSG job leak on validate flash image error path
Date: Thu, 23 Jul 2026 10:34:11 +0530
Message-ID: <20260723050413.3897522-55-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX14Tq8IjRXOlZ
 QMRPQ2MUDcXZh13NPW5c8FTQUc/sYE41cBxWMDJ84VGEgtw93Oc5Lg7MluIWKWFdmj2wmiOqki9
 X68w1CNFKX/SXifT09My7oRtXT7FHUtqNZ7MAbOUSsr2i4t8Rcq22gsGZlO7Wr2ozQRHpkvvFaB
 lE9ibJuFDvBHXkCuxqKPBHE/W8jmTiARnKvS6WFU2ZnLjElhDZCMcFAkdpSHrJRkXzKUKd7eZW3
 G0Qr5waeXAuS49CoOiq4vqhG/5m5wUWFLhSkH0/3zcQHtHtip+Xc97hT9NXUMBmJHiMUC9YBuha
 5ClGv/HlFC+5xt2I0wCBJ7LkZpwHszLvhyizvX6a8zkW9H1EtTApTpbHD8o6nb7tU+Xf5MHoi29
 EEvSeD3eOWX6UKDDzs/8x8F8SY89k2ZqXCqfs00vKomRhedeM3aMWkrzze5I4q2IHYMbJ0L5i+L
 E+WaT6mdVzlCrIHGdkA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX5YizVTRLsmDc
 nkr5GsVnv0vGMhKd6/qe1mN5Tvlc2b8Mj9mYw2uWhEWlHM4vJk9y2P2u/x5/QNbw8frhXjvhrbv
 kBTj4SK3hDoY0wg95FYzJFHuiDT5hjQ=
X-Proofpoint-GUID: 9UgNhly9yA-r3b8LroQ5JoJEcpaK_yFi
X-Proofpoint-ORIG-GUID: 9UgNhly9yA-r3b8LroQ5JoJEcpaK_yFi
X-Authority-Analysis: v=2.4 cv=Zrzd7d7G c=1 sm=1 tr=0 ts=6a61a17b cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=YLGBn9Xrq-Gyn1ev87cA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

qla28xx_validate_flash_image() returns QLA_SUCCESS (0) unconditionally,
telling the FC BSG transport (fc_bsg_host_dispatch()) that the driver
owns and will complete the request. But bsg_job_done() is guarded by
"if (!rval)", so on the error path (rval == -EINVAL) neither the driver
nor the transport completes the job. The request dangles until it times
out, leaking block layer resources.

Commit c2c68225b145 ("scsi: qla2xxx: Fix bsg_done() causing double
free") added the "if (!rval)" guard to a batch of BSG handlers. That is
correct for handlers that also return the error code (the transport then
completes the job once via fail_host_msg), but this function returns
QLA_SUCCESS unconditionally, so the guard turned a correct single
completion into a leak.

Always call bsg_job_done(): bsg_reply->result is DID_OK and the error is
reported in vendor_rsp[0], and since the function returns 0 the transport
will not complete the job a second time.

Fixes: c2c68225b145 ("scsi: qla2xxx: Fix bsg_done() causing double free")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 4a9cf8da67a6..76c57e574c22 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -3796,9 +3796,8 @@ static int qla28xx_validate_flash_image(struct bsg_job *bsg_job)
 	bsg_reply->result = DID_OK << 16;
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	if (!rval)
-		bsg_job_done(bsg_job, bsg_reply->result,
-			     bsg_reply->reply_payload_rcv_len);
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
 
 	return QLA_SUCCESS;
 }
-- 
2.47.3

