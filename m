Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3142338D6A2
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 16:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427212; cv=none; b=bHMOM6o8app88prlpbuh2szpUmruM1dkxJIwhTgEBy2V5m7VXLivGFXHwVFFo4kbhPSOHA8CgvZCtczq088SzC96zt7Di09r+0sjsygpGM0MRovrHWJLgiAVEIc2LwbPq27Yf4E4YW3bT1RHBIKpp6EkU+EgBFvd8mRZuBH3Vw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427212; c=relaxed/simple;
	bh=SbXFodOz1elX7YcuHJGxCsmCKVBbRrOODRNoirENK1o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ec5DCFZQtU7YUa1mVhwRhInBoDfAAnoah1hQ/tgQnnl2OC2D+6Xb45nEZ4nDbLy55MWxlVz/7YTSK1n1cat8NJIuOauS4gZb0E3mHSIU76nAzQl10O7C8kXQVoXEUmQwSqAjDtZSLSYynkmWuU596cJiVgmr6QRyK/WAtXHOtPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=XXzAkVYY; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="XXzAkVYY"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFWXj61322245;
	Thu, 30 Jul 2026 09:00:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=H
	telketStdTtxwlisPA85OG7Uj1eLdZu3EYDpYhrRys=; b=XXzAkVYYNi14v+1KY
	zkPBRIjA/whL5bSHMTBwzIuvqTQGnMJyquZp4lScz0+jf3ALxQO9x7Jl+bRKVZg3
	PGWkDr2Z1u6cKeblhU1vouCRVvAt6hu1UoSai5q8N764rFkYdLjbBQT0E4gUBiqn
	RQA3UEm1Chk2vI7xVhXzGMKLN1N55vF/pfFpT2hYl+qi/ptVpnwhv2cPZ8rTQEt6
	NfjjMfJR2hO8ybQSoD0Gtkh0oQPIBl2OQFBZGouYVBBf/0Yv2HhcEnaQgDR3qykS
	o5Hr20l27Y2VQzzD0Kmdzp14T8N8i+ZFSia2JAcXg3z0D3Dy8kCyWoP0mVZIOKwa
	rNJpQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7ktqk0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 09:00:04 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 09:00:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 09:00:04 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 6E0393F7054;
	Thu, 30 Jul 2026 09:00:01 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 22/33] scsi: qla2xxx: Drop vport reference under lock in report ID acquisition
Date: Thu, 30 Jul 2026 21:28:27 +0530
Message-ID: <20260730155838.2119230-23-njavali@marvell.com>
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
X-Proofpoint-GUID: ZS65MMVeyrcMrVX1WFMH3skFSuBqwjUc
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXz3KPv3YiUeFF
 6I6c0+Kx7GT1fxHlIQcmxySbDswquvi1Kgh0kR+92mHKXc+Gh4/poXG3GHO85BcePeQgn4JrlQP
 06zPPlWgl4y8mFToZ09CeV9xXvA7H8s=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXxOQ6U7sBcTX0
 cJp6sx1EaAR2d5w/O/UT31yBTtxne980GWy7E58DAvcgWSvj3YHOnOr2kyVNlrX0/FYsC270Kww
 g0HNn7FjtPVqjrWyKeHJ/VUecwAQMychCWmnLL5J3+WROa8y3kgaoS/WjXWEZB7TyyKc0uUMTQK
 eGUn+MU7+hcDgjMWaPhLvrwxhMP62qIUne7cF7hiAcGgSiYA7pJ7hbll8bHEbKaZlbWf65O3l30
 Ju4aavkmXE/eSXzuNj3R3ys4ZWo64oB8VisEBWERyT9gMWA/3mWwpgSTac3l8dkANPnrDJJob7T
 xU/WV2isPn2Kb7t9uokPelKqu753ZQh10IoEIAerKl8sarG6yHJSkBmbIWBFuTqTxaDt7B0dP6/
 1gzYFaAH1QwwAmr59GSNNd4+BFvn2vX3kCv7VB+6Gbgis/GOYg6NnB/8GA9i4d9ZrKZu1LKylFP
 quQOQPkBfxD3p2TW0+g==
X-Proofpoint-ORIG-GUID: ZS65MMVeyrcMrVX1WFMH3skFSuBqwjUc
X-Authority-Analysis: v=2.4 cv=TrnWQjXh c=1 sm=1 tr=0 ts=6a6b7504 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=B7vDQ8MdAg9om8iqQakA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

qla24xx_report_id_acquisition() format-1 handling takes the vport
reference under vport_slock but drops it outside the lock, after setting
vp->vp_flags and vp->dpc_flags:

	set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
	set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
	set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);

	atomic_dec(&vp->vref_count);

Neither set_bit() nor atomic_dec() imply a memory barrier, so on a weakly
ordered architecture the decrement can become visible before the flag
stores. qla24xx_deallocate_vp_id() polls vref_count under vport_slock and
unlinks the vport once it reads zero, after which qla24xx_vport_delete()
frees it via scsi_host_put(). The poller could therefore observe
vref_count == 0 early and tear the vport down while the pending vp_flags/
dpc_flags stores land on freed memory.

Drop the reference under vport_slock, as is done for the matching
increment and by every other vref_count user. The unlock release pairs
with the deallocate poller's lock acquire so the flag stores are ordered
before vref_count == 0 can be observed.

Fixes: 87c20ed7521c ("scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index affcd87893cd..e88c3a989a51 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4290,7 +4290,9 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
 			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
 			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
 
+			spin_lock_irqsave(&ha->vport_slock, flags);
 			atomic_dec(&vp->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 		}
 		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);
-- 
2.47.3

