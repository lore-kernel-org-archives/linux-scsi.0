Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD92238735D
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403880; cv=none; b=svE1wEy7obYgtxdeYn1mu6KvZ9lS9zTf4PR8BkJfqVzObZPaIv61+kuLUZwQ0CETHQAnMQ2b1sodSuJycdtR5DQaAL8VQDDO2C2vKWSR/ggPL+JH6KW4nIrMwkqBaSI/2oxFISQOJwUvp9bEYY/bMW1AHv4GyzVxE6CsWYYuw+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403880; c=relaxed/simple;
	bh=WO3U4C2zB6ml6gXZ9gVsdbOpVyj5Mh8n599BdbOCALc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VjCKqsB6Os9s2aphDIWFomqnJKblorD2RTU209C22cmzOffasvbpNxjurT1wMnadEdPz8i3YbUbQqdu46D/nS+mGoYk2yp5h1qT/VJ5dGENryCeONQu6tEnK2Zm4sD7wyXTsAaY9xU2C5RDptlEP5G16XuK2s48C6WpDtOh18vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=DDp2p1Sm; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DDp2p1Sm"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66747g2Y854295;
	Mon, 6 Jul 2026 22:57:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=E
	XHVsqBRi9UAPD5CZLR4mrTMvjd2VtUE+Sj9zcngls0=; b=DDp2p1SmM95AX7CT+
	ugaQzvBxVhOcyWlxuZbtswxHT1QRwObIqZOVaovYw8XmwRcNqGyH8WGgMs8IfsUf
	96BZPcLiQbQR+3Db6b5lbUKIiwMp9YvkWlN2cMTf13xJs29P8CN5NQ8kGuWOrGCb
	cWgRvUP9IuTZDzj7clmvBMlNOF/LRzEFE+FuEXbCR9ug62y7ohp4s9b2/bSH2PAf
	Ax7fwXvkV/jcBnCg8DH2MOC1MAB8dq7NycksdPJi9j2MssbKo+SI2RY4a9e30jp/
	6wYmpw5ujd89KZSlRxG0VM41lkUjW1xrzAmZ/TZP7vqtxuNAwAB307UGO8rrRUXr
	ZN5Sg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p2y0q7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:55 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:54 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 4EC9F3F7066;
	Mon,  6 Jul 2026 22:57:52 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 60/88] scsi: qla2xxx: Clarify MPI optrom address/length units
Date: Tue, 7 Jul 2026 11:24:07 +0530
Message-ID: <20260707055435.2680300-61-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX62nHGAZcQ8t1
 N6sBzYkktzZbxi1VIKg+sww6qwX16Cvo4tKiO9FtH7hSPBPt6d6t7GGRd0fizfy9v0xCtw48RrZ
 XuOp+34vMI8qoqcd9xFKkI9LzGKCQ/fbh5jIorScRoSBqdT89cDEXOdvFGnwFc0MGrIMV4AEuS4
 O9T4B7WrIHxz1bMSeWyGgBYwCbPCGdkT2EwKkRZ+buxpsn2uvIgEfHU+RQosIPb0PGmp8vXCVKF
 iRuBYuaYymrTayogu9IiDE8m2xL9U+kBGJ6td1ygM3wvC7+JcGnVXzDZx4TR06dcIDZMqlDjm8W
 5UX6bNXI1TmLztlqFTcPGqpRicis3Mw3V+EVaMCa0CnYt8NRJ3TgZXTI4sjwtaRxVvI1mrwlLDN
 xZNTFyFBazRL7LIEtOIgwQkdprbzmiWAl6fXa+AM2397TCLmcLhN1O/NzYbv3mlgvxvgvIUhZtE
 Xw57aH2nt/pFGlL9xqw==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a4c9563 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=xjKyJS20Z64PywUY4jsA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX2stjwufk4jYl
 FLqryhwjQfxesq3l5r9mEJ7N3ORn5tpGV9gfSZVUfI61mgHcMOhNAcuf4/WxYCodJR8TV2gZylS
 xWs34uNU+Cmm5I3kZSZVEEF71gOr/sc=
X-Proofpoint-ORIG-GUID: 9vOkVkmJDtwAyHW5KdEWLQqFPyb78PGO
X-Proofpoint-GUID: 9vOkVkmJDtwAyHW5KdEWLQqFPyb78PGO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

The kdoc for qla29xx_mpi_optrom_data() described @offset as an "Offset into
the device memory", which reads like a byte address and invites confusion
with the per-chunk word-granular address advance in the transfer loop.

MBC_LOAD_DUMP_MPI_RAM is word-addressed: @offset is an MPI RAM address in
32-bit words, and @length is a byte count that is converted internally to a
word count. Document this to reflect the existing behavior. No functional
change.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_sup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 1f5596a4c405..d70ddba84305 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -562,8 +562,9 @@ static void set_chunk_mpi_bits(uint16_t *options, int count, int total)
  * @vha: Pointer to SCSI QLogic host structure.
  * @opts: Options for the operation.
  * @buf: Buffer to read from/write to.
- * @offset: Offset into the device memory.
- * @length: Length of data, in bytes.
+ * @offset: MPI RAM address, in 32-bit words (MBC_LOAD_DUMP_MPI_RAM is
+ *	    word-addressed; not a byte offset).
+ * @length: Length of data, in bytes (converted internally to a word count).
  * @op: Operation, either QLA29XX_MPI_OP_DUMP or QLA29XX_MPI_OP_LOAD.
  *
  * Returns:
-- 
2.47.3

