Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002BF442139
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427163; cv=none; b=gz6vqKqoXIM1Yb0HbIDXXb+Q8BSH5dmWJWGc+7V2mgzs/pavPvaY89l1Ey0671+uxInCt5G108a8xuqF4M9k0no2Q96W6OC93ghsjbo49KFDIIPsYw9DanwFTzHdqHEZ/sxxhIROuv5yXyhkSRR6h3nkNY7spbPTK234NdEN2j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427163; c=relaxed/simple;
	bh=RKENHJyxw/VGfUrPcPvwGV2azwmaZx8xInuWrTQFMn0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VgW9er/MwWt0EvTW0Ud8uQ8vWT+vDbmMSxaBU+d8latt3BZcE8WGcbsULZJHZ8gSa6+6RTkRBSHtbVac+Cqnz4Kt4Ybcumur+FPMfVNhJOST3N7YMTO1k90VNb8pK5rxM0KwY7incadGpXFQOu0vOCwlLmOlnBt7s0IZO8kcU1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Aikn9kjS; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Aikn9kjS"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFW9rX3113489;
	Thu, 30 Jul 2026 08:59:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=L
	cAyN7APgic2fqAxjpWMj3yLKP0gon3omZQpUTq5XOc=; b=Aikn9kjS6yYlO+Av8
	u37i8cTG6lMTIXf2esBkqzs3JprLuiQQDxMjy2j1VLgIAQzAp8lEe77K5/SFp1Jv
	txAjVhVzzJh/VZSMsnMHEyVUcvKjEhBSqW5iAJE1RNN7tYe+vnB9siTQeQG4oNzX
	p3zBtWVS5e4BncrHeVR5NOBGaQoAB8w/VC3br1u9qvIt0skp8F/79coJ4goZbqiP
	LuUuvGvSKIZS9qkbvDtLpjNuL9TssmhM1wr3JzdGF/Qt0bi8yWly16ARM2w11HMG
	CC19fTvh7e1atIZdFbwLeZAGpXTG6NzSh6gC4vLxpkwA5rZQ+if853zzx6X/5k+d
	9T0Cg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7c2ry8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:18 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:17 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B5E823F7057;
	Thu, 30 Jul 2026 08:59:15 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 05/33] scsi: qla2xxx: Clarify MPI optrom address/length units
Date: Thu, 30 Jul 2026 21:28:10 +0530
Message-ID: <20260730155838.2119230-6-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX1iwyMOXb1Vqa
 f1USPCDS8lSmsS1+KlO60Vm666KwMUHWCVfHsTlpZBpkNT4TqIT8QpeGRxmxn9EbI0Er91cytHu
 iseO2EAsMbWoSinDT86U94BSWU5Yb2Q=
X-Proofpoint-GUID: MjPdwF6nAM0ewDsfkxUhWYTLGWKBMlM8
X-Proofpoint-ORIG-GUID: MjPdwF6nAM0ewDsfkxUhWYTLGWKBMlM8
X-Authority-Analysis: v=2.4 cv=HtRG3UTS c=1 sm=1 tr=0 ts=6a6b74d6 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=xjKyJS20Z64PywUY4jsA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXx0RHoPveMHqG
 qyR1RvH6wHZUdAZ7IkA3GQWqrW6mDC+4uLji5e3sgJ+9MkzZrIbfylh069CnhBv3cQ61pUcQ/Ky
 bQmE9zLELpd7FD3MdUnTjRa0YdJxnkg4TkTJvptDdaTSitQfEOryV+AcRpEzqko3sH2I6iJCw4l
 RF9CJC/bzUvPecA6hgRY3WEFWYpA2JvfiVDVtGCJVK0Jmt7zs/QLGqoxqkAy/b8qBpVbXOHfL/w
 oYdW3By2GRpTjpvcjvUyUgG5V8HWiZw1pAR1kYzgCeDbJpCGSF+NyQvnKKoJ9sicEuJhANdtG4V
 E5BBjAxlp/jPtQCeX4ggWXmtsgQNsTtN1OZ4tB1+iFIgepxEuGGiE8NOEs12IUVo8WHV5yYm3wg
 1s46XuNgIlJnkIXpnkWO/GAIdtr/z2I2tfava+ASxR3nwbg51X+4N1i4kPYoUCozOr9h4mMQA8s
 UE00zf0Mqs66AD99y6Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

The kdoc for qla29xx_mpi_optrom_data() described @offset as an "Offset into
the device memory", which reads like a byte address and invites confusion
with the per-chunk word-granular address advance in the transfer loop.

MBC_LOAD_DUMP_MPI_RAM is word-addressed: @offset is an MPI RAM address in
32-bit words, and @length is a byte count that is converted internally to a
word count. Document this to reflect the existing behavior. No functional
change.

Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_sup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 2e5fde403442..56ef2b4c7c26 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -560,8 +560,9 @@ static void set_chunk_mpi_bits(uint16_t *options, int count, int total)
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

