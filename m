Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2322F15E5DC
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023016; cv=none; b=qKfH7MS9MBVWbsDwrqJ4wKY2gQ1jiA1LBKpVfr7g+yDMkOd/BQ9St1TNuUR7QHVX5zRPRVjDPwKchhYZc8as7IaCHf2BkOp6E439nzMseoRC9Yl7+B+CAyyQQ1/XvFXn2zCJSm3nFYHe8uH6U1yVbry41d1oARaOtRAwoDlWoeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023016; c=relaxed/simple;
	bh=zR0yUnQDhhWSxNCr1D4AkeeIMg5LLbRUV8PtLDX+DhQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=owM2mXuuBS/viRnhcLlR3SFW54caef+w8QpuA4hyS0v/vm8MedkYLFU40q5ymgSBTkDUjupE1qStQXv6m+APYMkxclMS5luD88Xh81a7iLC+37Y8mvgf4IsihUP36Tq9Y8CJd7FLBIW3yZ0FeOd3Qx2IxtPalh949lbCXrddggI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=MvKW/7QQ; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="MvKW/7QQ"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UiIl3693335;
	Tue, 14 Jul 2026 02:56:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=6
	INSyIOV543cVNlh2oZ6+qZm8Vam+bSmW5hLNLEcKf8=; b=MvKW/7QQecFB0b10a
	iM93Ek2s9scqRF8X26STvnRRd3DMCHNCH2zG2RjYIRJE/9jLRowga3CzN6fXMPpQ
	GVI1mefslj/gd/KFFZkhP/xfdFIFI+eFEN4A77ws0XC1gqY3IBDj4+VoQ0Cc2oF5
	Kf54BcGvd9p2rYmbUpXWZGSXZbd1fop8vA2Fyn5U14EjvVJRfYkzcHWx/F6aV60C
	aQdsD2BF77mxY5Iobxmfb6ajUT42qV1SIqyEX/4RqPPx0hY7KPtiydzgnOzr8/kv
	Yc77maprN5eAR42J3piiNLHYct9BIYTP6EvQ8MLfJ8u/vN+Gm8hl2yHkolX2mO8b
	lSdwQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fbnbey918-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:52 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:51 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 0666E5E6867;
	Tue, 14 Jul 2026 02:56:48 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 55/56] scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()
Date: Tue, 14 Jul 2026 15:23:52 +0530
Message-ID: <20260714095353.289460-56-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: f-62WoZf2d2ZcgF5wsKSGkXecRamCA1m
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a5607e4 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=494MX3Unkl1U6TuN3o0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: f-62WoZf2d2ZcgF5wsKSGkXecRamCA1m
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX2xdYVnIxrMsx
 /IXA1VQGu/UAKPkVxx3Xe4xFPsQ+bx+epTF+aSulHT8SHoQOrOCzUh7OOmDWxidW7/X0K+9nxi5
 P/aEFDF4B1zvXFxjz8twgIb1EZmpEuk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX6MxIAUo1Gc5N
 qdL32AquXKe6sy9XTenj3rqQ7ETGjmqsLF3CnOmbR+jIckHcLIVCAG6wH2qdmgfXNCENL02f045
 x72Yf4gSrxos2wRtB1/yhZB6LBL+zhDdXLyme3H0nkiCz8oPSLGo9WDTP4t7jNxqhVQ9SGbcoqB
 ttM9PMAhC9wdmF0V7Rh6BIJX8n09FKz5LAq84v1Ngq09ZbcisKMYfe9UhOKKfv8Y/w0RxsNNftj
 vCv7c0qtTQQMVT5KtmIfXIYLj63wfW99qS08+3+nTqxceJVuJTUEHpbayyAYgbu0VuK+W/QnFOq
 GbBudLTpwEPZpT++8Wo4Fe6fUstmpNHG87NApfsCDl3TzKwzgXMtEN5RiosnHJNejJVkT8LvN6U
 1H5HwYqPSNrHFsJL/zMmGZZnf1NO1g2tRF9b5oY0VTswk1fTIaafJyDjphpiUejszckotUysCA8
 OlfTk2Gx3d0tPiqoKaw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

qla2x00_update_fru_versions() copies the user-supplied BSG request into
a fixed 256-byte stack buffer (bsg[DMA_POOL_SIZE]) and then iterates
list->count times over the qla_image_version array embedded in that
buffer, advancing the image pointer each iteration. count is taken
directly from user input with no upper bound, while only
(DMA_POOL_SIZE - sizeof(list->count)) / sizeof(struct qla_image_version)
= 6 entries actually fit. A larger count walks the image pointer off the
end of the stack buffer, reading adjacent kernel stack memory and
sending it to the device via qla2x00_write_sfp().

Reject requests whose declared count does not fit in the buffer.

Fixes: 697a4bc69159 ("[SCSI] qla2xxx: Provide method for updating I2C attached VPD.")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 2f73c9af418d..95cfdb020319 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2043,6 +2043,13 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_job)
 
 	image = list->version;
 	count = list->count;
+
+	if (struct_size(list, version, count) > sizeof(bsg)) {
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+		    EXT_STATUS_INVALID_PARAM;
+		goto dealloc;
+	}
+
 	while (count--) {
 		memcpy(sfp, &image->field_info, sizeof(image->field_info));
 		rval = qla2x00_write_sfp(vha, sfp_dma, sfp,
-- 
2.47.3

