Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D65A43A7FF
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427190; cv=none; b=E0fJgpt6wcKdY7E1ESM0xrOMrwuEzkXnE/ZfxWDvnqNmC9khw8UNPNpgmsxFEl322TlXVDrlfvutkma+Igt4Z9JjFgqrbrgmjcLXP/Crv6D+ZHZ2Th1rNKyHNC2sh/Yd3+shKiKlDFnShgZdRxgR8O4hca3xfa8lT2D67nRpGjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427190; c=relaxed/simple;
	bh=jAj2NE9ejNQA1YPxThSFY579xSqPhOYTJu9lP58JkP8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b2QZs1w99pi0k0ESO1DbEDMUgCiz3yLgW+l+DE8mQYankVShsP0iSi1VrW8gftR5g43rT1S3MWRRtEVgAQZegyIeDC+oGQpx1slOQZdj2IzsDgXh0YYi/pOu8iGu9LOdcBne/+0PA9Lfq/OKJpYPBbiaERvk0ujD1kNbxP6VAXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=TfhdsjFz; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="TfhdsjFz"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFVkHP1300968;
	Thu, 30 Jul 2026 08:59:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=t
	XS6oh+aNj54LKkDJubz2rUth84RPSfG+/Db0poHJkk=; b=TfhdsjFzCF50Y0Jzy
	ovasgWG3DoVPZ518jzWTzz/AjOs79Va5+fYgbZjw356Ovx+pOoZBFokI1TiTTE4Y
	9P8TI/FBnrHisOgk9K1GRFxmfwfkD7ukJxrNOeYn2qgvVdpLJKhRFJvmjVcw59Rz
	6Ov78SjhBL3WUchr9Lzpr6vJSfHWu7AdO+b0fDDPOqbLZwc3UHzlWLuzhhWkYOJT
	A6Lg5Tq5FxYC+0G1TNfIfTG8qPD2FZVIEc+sbEhiyAsGLT3nhU8axxGAs9NZZBXZ
	pdzoqxTDx3NtMiIObBY49Aew4Pzi8q9GG2jYy4dDQywpz6pVuUAXbjvVW17RhJq9
	9HBtw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fq0f08c8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:45 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:44 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 68BBE3F704A;
	Thu, 30 Jul 2026 08:59:42 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 15/33] scsi: qla2xxx: Bound rsp_info_len to avoid OOB sense-data read
Date: Thu, 30 Jul 2026 21:28:20 +0530
Message-ID: <20260730155838.2119230-16-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260730155838.2119230-1-njavali@marvell.com>
References: <20260730155838.2119230-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4p6BN4jQuVW95xdunziwyN1Gvx1lcZ7-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX/R51KGltkIle
 G+2k6EY8/SycRG5NDtpUV5++beT1FW6xwFfUY4x2tnxaEqr9fM0TG7awEuAN7dbMapZvusyuzTK
 gh+ZE97JQju5Obw8BHmqbStAYcLQA1/2oDnrgoZtBN5pgwau4UBm3dWT7qRVguAK/AgbgsrlOT8
 xFlfKgHomlPB6dLE/SBaYk7XsxfEK5OytREfyznLoSZITKYv+jcFGsAF63t11MckQFKKB1H/tts
 ApCJpw5ZkVYZrWxKllrPJDOJYK0rMDXFxnLP5zSwZHr0hzQGedzJ5S3M47dBJB/Yl2/93BGQCKi
 ClIBCedq5hHuQVNubH7oXs7lkDLpB1w9x9sM14jIYVZpkuHxH0YxaS6Ad3PWbxweEpMN2jWHcRT
 eZS8YXNOmtgFneF4PC0JDamoU2fYfmwtKveWDs7dQSrs6YUjS4tEy9gYp8RsITYt2Z5KFPuAJN/
 90H2n4cqY9DFjTU2PpA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX382WmW1s4Hc7
 y3yoDkb3SQWkFCswgbndIPae1ugqrvzEGDZcwNeqZee/wreffbD77arWixzJIET2jqTmj5sROsa
 uenyHYWi/TXaw8lMvv2pq92Pthhl8dk=
X-Authority-Analysis: v=2.4 cv=NOLlPU6g c=1 sm=1 tr=0 ts=6a6b74f1 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=NicNEeuCglI7K_BArFcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: 4p6BN4jQuVW95xdunziwyN1Gvx1lcZ7-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

In qla2x00_status_entry(), the FWI2 status path advances sense_data and
shrinks par_sense_len by rsp_info_len:

	if (IS_FWI2_CAPABLE(ha)) {
		sense_data += rsp_info_len;
		par_sense_len -= rsp_info_len;
	}

rsp_info_len is a 32-bit value taken directly from the target's FCP
response (sf.rsp_data_len), while par_sense_len is the IOCB data area
size (28 bytes for 24xx, 60 bytes for 29xx). A hostile or buggy target
reporting an rsp_info_len larger than par_sense_len makes the unsigned
subtraction underflow to a huge value and advances sense_data out of
bounds.

The underflowed par_sense_len then defeats the cap in
qla2x00_handle_sense():

	if (sense_len > par_sense_len)
		sense_len = par_sense_len;
	memcpy(cp->sense_buffer, sense_data, sense_len);

so the memcpy reads up to SCSI_SENSE_BUFFERSIZE bytes from the
out-of-bounds sense_data pointer, leaking adjacent response-ring/heap
memory into the command's sense buffer.

Clamp rsp_info_len to par_sense_len before the subtraction so
par_sense_len can never underflow and sense_data stays within the IOCB
data area. The fix sits before the comp_status switch, covering both
qla2x00_handle_sense() call sites.

Fixes: 5544213be7b4 ("[SCSI] qla2xxx: Correct extended sense-data handling.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d9019f2b059c..02f88a79964a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3598,6 +3598,18 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	if (scsi_status & SS_RESPONSE_INFO_LEN_VALID) {
 		/* Sense data lies beyond any FCP RESPONSE data. */
 		if (IS_FWI2_CAPABLE(ha)) {
+			/*
+			 * A hostile or buggy target may report an
+			 * rsp_info_len larger than the IOCB data area.
+			 * Clamp it so the par_sense_len subtraction cannot
+			 * underflow and walk sense_data out of bounds.
+			 */
+			if (rsp_info_len > par_sense_len) {
+				ql_log(ql_log_warn, fcport->vha, 0x3107,
+				       "Truncating bogus rsp_info_len 0x%x to 0x%x.\n",
+				       rsp_info_len, par_sense_len);
+				rsp_info_len = par_sense_len;
+			}
 			sense_data += rsp_info_len;
 			par_sense_len -= rsp_info_len;
 		}
-- 
2.47.3

