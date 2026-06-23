Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21FB38CFE8;
	Tue, 23 Jun 2026 01:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178268; cv=none; b=fWLGEpYAtHYDiFqU+M2FSuXcfGbejkDFXmSZ88XBrUwDTPSFav+XxHVWSjmdiR2a9r35eHdhX6rSxDw2GTOzEzAI71qnQGRhG3Zq0x3+X0F9vo1AUyve6tg4KgYstD+kaHwkvMLQCIgbAks+k/4V0152uWP+azxrZH/J7emxbcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178268; c=relaxed/simple;
	bh=nfW1cJqFe2gsOJFfZBAMjMwzh2zu9uZ6d91Pq9hyq/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvmDp0N/5KIb6U4t5F2ffAaaYOS6bZrTI4RwigIbKJmMauU+cpbuT+UFyBrlIK27s39BXkkhZ0RrYpvI9687EYuAGI/8G19XTI9l9pd1SrvpnFdbvczZNFDP+TP2QquUcLi4PXiniqdRJpEgeChjcYas0j5FFDWIODw8ANQFBeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fld41Nux; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fld41Nux"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0mLv7408262;
	Tue, 23 Jun 2026 01:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=SF6J2O2xrVCAztnDF
	1oOJqULGTiZTizzLIdiwv5hgnk=; b=fld41NuxjW9Wl04adeQibmgJfjH4TAV3+
	wE+V+wrSAYWDVjWOUCAko/Gwzj5Llv5Qj/WJKo3Fatw0NuGepa8YBC1ARD2BDToh
	EtgPkgHKTmFo/cgzS3FVWRqOOki/yRxW8kHbS0HbDcMhrE7pl1KGEUwQmndfmz94
	E6SA9gojqI9E+wdNLaNCbQbBwDQG5wPVcpMPSuvgtokbIPaECKabOVA2fBPDpZR9
	iz44oD132AI2vfpb1ayyh+1sazmi1hr3+9+4pZaaTsil+QBdVyujZfc68zjdbxx4
	eGS4hvK01UjY95lVrkv3LiAcSgQ8ew49xoubqUFns0HmCjwKumcEg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjc3c4r6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:56 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1K6Kt002685;
	Tue, 23 Jun 2026 01:30:55 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex56q95mn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:55 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UsFq19989104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:54 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11B725805A;
	Tue, 23 Jun 2026 01:30:54 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C8E258052;
	Tue, 23 Jun 2026 01:30:53 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:53 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 22/29] ibmvfc: extend ibmvfc_debug visibility to ibmvfc-nvme.h
Date: Mon, 22 Jun 2026 18:30:28 -0700
Message-ID: <20260623013035.3436640-23-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623013035.3436640-1-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=X4Ni7mTe c=1 sm=1 tr=0 ts=6a39e1d0 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=Jem0i5WXB_Or_wZ5oY8A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX6iPOMUyK1nOr
 tPfPO0t0eyQHhHnm44mZ9XXSomiGyNBDxov9FlHZ+EJBBQmfU/joRZCN7FQ9fCaF0Jm7mayF2Y4
 WgxjRoC282tc0UnbVWHlI7TeiRGksag=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX+wQ5NcfJqzcE
 THwaXQLVJZ8NnBc3E3QxOlKSX5+nFrKEKZ1L60juVkVLvib062JMpXqiffRsguj8o3iFZ5YgyUe
 rxp4PoQ9kMiIDFR82MNQNZIBbaowEkhshnukveT3HHm1BFDAwK/O5QzEr2/3iadakCmHw5dMd0P
 Mx+sPcHSEnzE8WA2jw4fShlwYs7QdTI2hq99IZLYbHHMIA/loifS3tYgw3uALYWUtctEOK+lt09
 CkMw4j6erX47ff1nSCKxLOn/LrHaVYkQbsgD8Hh7uMFI3Cg+YGM3t9Drx4KGJh4S2wqjDBWLjeK
 d09eEfnf9wNF5ODFmTmYDh0wnKWZBis5OfktYDrJ1E8fMUedd3TOPcFKD+XKmlZUAR6NF0EPnil
 Q0aDgw1mPa43pSkR1fNAQ7Zqz+8iGNAFtnv8l4T8YKAFOn4aj4WcjSM9BtkszUl6iVX+NW+cmAE
 9BMQTRDAHkGzfSE1LIg==
X-Proofpoint-ORIG-GUID: z7Wvp4mdHeoZkErIEwFraLIWMhSA5Fqv
X-Proofpoint-GUID: z7Wvp4mdHeoZkErIEwFraLIWMhSA5Fqv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

Export ibmvfc_debug so the NVMe support code can use the
existing ibmvfc_dbg logging macro.

The debug control variable is currently file-local to the core driver,
which prevents protocol-specific code in ibmvfc-nvme.c from using the
shared debug infrastructure. Make the variable global within the module
and declare it in ibmvfc-nvme.h.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 3 ++-
 drivers/scsi/ibmvscsi/ibmvfc-nvme.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 5f6ee99d0dba..7e6912fba899 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -41,7 +41,6 @@ static unsigned int max_requests = IBMVFC_MAX_REQUESTS_DEFAULT;
 static u16 max_sectors = IBMVFC_MAX_SECTORS;
 static u16 scsi_qdepth = IBMVFC_SCSI_QDEPTH;
 static unsigned int disc_threads = IBMVFC_MAX_DISC_THREADS;
-static unsigned int ibmvfc_debug = IBMVFC_DEBUG;
 static unsigned int log_level = IBMVFC_DEFAULT_LOG_LEVEL;
 static unsigned int cls3_error = IBMVFC_CLS3_ERROR;
 static unsigned int mq_enabled = IBMVFC_MQ;
@@ -53,6 +52,8 @@ static unsigned int nr_nvme_channels = IBMVFC_NVME_CHANNELS;
 static unsigned int mig_channels_only = IBMVFC_MIG_NO_SUB_TO_CRQ;
 static unsigned int mig_no_less_channels = IBMVFC_MIG_NO_N_TO_M;
 
+unsigned int ibmvfc_debug = IBMVFC_DEBUG;
+
 static LIST_HEAD(ibmvfc_head);
 static DEFINE_SPINLOCK(ibmvfc_driver_lock);
 static struct scsi_transport_template *ibmvfc_transport_template;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h b/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
index 0465e8719881..3aa285788795 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
@@ -22,6 +22,8 @@
 #define IBMVFC_MAX_NVME_QUEUES	16
 #define IBMVFC_NVME_CHANNELS	8
 
+extern unsigned int ibmvfc_debug;
+
 struct ibmvfc_host;
 struct ibmvfc_target;
 
-- 
2.54.0

