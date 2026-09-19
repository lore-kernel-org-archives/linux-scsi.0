Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81903BFE47;
	Sat, 19 Sep 2026 01:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781607; cv=none; b=SgleBKjXML8MI6iMHrRENsjOfmEz9ZYqapSEfuO+QUGayVKODhzbm4JmX+wdn4vDuJxGM8lrxikvPZEnNAUVLgD2F/bfvGFRWHHHkNZhgi6oLu4Lezxoyx4gp513CAqLdhVI86GsnEntcviKJpfxc88xIPuzEDk8QYDrMvmceSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781607; c=relaxed/simple;
	bh=u5oamuhUXqB9jYcFVqckUFU1xMKZJ5jOAlwQQFm4LNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MwwOmJqUG6eBU9YgWhDISnfzPf0ewa+ysrQYuIgoYee4LD/fIEYBmVV4P0jlc9NjK9O1h6JMpsKP+3wQ8BKjrmrZNehx2YuQDT0fZ6IfgcfHo59veXnQNT0EzcgA+TyYW9xU9LXH7XzpjtQgCbtyLM+GnrHBFGoEyCBhigZN+zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PCXjwVCT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PCXjwVCT"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1VoAn1676582;
	Sat, 19 Sep 2026 01:33:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7fTQf6
	ReF8hydpMgBC35nO4+APuXySgFtlnCWFDzEOY=; b=PCXjwVCTSd1Mcn6uxfT//H
	nvizIyt8ecGY2zErOlpyqjDibqBrolggVygz4U6/bIIqbg/6/+jbUy7xE9KQ27mn
	lNLrp/E84kGIu4sQsu+l76Z+dP+FpfFNrQdesZSifRMUO/4N4oB/exJv5rYEIVrw
	b5+BukGkY3EzRhK6PZYwnbJ7GaZdCNssgOqran72f+sDsWRqRGcyfPHtwUhAQ1XZ
	kMAldU6VhEU4/4dqHCzn0nySqBYNNwdfS+boMRZ2F6bGNHYydhX24CtY/5xHG012
	0i6Po4Pk2ODz0jy/75W39Trtmeh3KFEPFUjMdGpBuCKRH0REnZ8IOSnyw0+59SZg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gsgtd803m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:16 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1UIuX2574042;
	Sat, 19 Sep 2026 01:33:15 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gsgssg06e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:15 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XEAE24576536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:14 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6B7758051;
	Sat, 19 Sep 2026 01:33:14 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B7FD5805C;
	Sat, 19 Sep 2026 01:33:14 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:13 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 05/20] scsi: ibmvfc: fix uninitialized _done dereference for TMF events on send failure
Date: Fri, 18 Sep 2026 18:32:51 -0700
Message-ID: <20260919013306.2948028-6-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919013306.2948028-1-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX+yMQDyONwiPZ
 Sm5eopNHZjmWVaB+eJ9v2Zz2J60sTvRHPST+tbgw3xB0KN6HSwUwqDbxnUDQD/dmy98uHg092F6
 kqOB1udtytYmgAgvxqAxXmRTQd21ynCJSokuvAVaPs7ZtWoylAHbQ9FQtafsRQ92gv1iAWu7SkW
 knZCngDRrruTG/L1Nc3FkiPrZDcNcBYsK4eQhQ/1MzHyosC/QFGWGnfuukAxX19oejDlDCbMjYl
 If3V6t9slChoQ8Pfr+T+MKJGrYxPze1oJm1k8gGyGZ5ea7y41tUyN/9LSDHYQyTOe44yds3Sfw2
 T2X3aNyt7p+o6IVGCwjhzte4PGmoRD5+CI9R8zDbKgGbvpdiz8ZeAF5olSZ2q/6wiL3PRnmvh8R
 2ChHfmlCG9VdGZSnSWvU2zl3lIQOI4c0/hTmug+hKBcQxVwDFSUoKtVqOvGZkCNS2Lrc3+lPHFE
 XmcIMETmOY26RMzBZxQ==
X-Proofpoint-GUID: W6wdach4gRQIkxsnic1P5aaatOU6KHZ8
X-Proofpoint-ORIG-GUID: W6wdach4gRQIkxsnic1P5aaatOU6KHZ8
X-Authority-Analysis: v=2.4 cv=Q49HcI2a c=1 sm=1 tr=0 ts=6aade65c cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=qtjYkiDot-WfiDIOCeAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=O8hF6Hzn-FEA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX5yue/bK/ZGZX
 ArNk3bPKGQLBwJ9IcwgpiQzwpseP8nAnSPNteWSrJRfkCkTDndA8CawJYW2HHKNBpMVHerfPMY+
 5QR9CJONGCaAC5QzKPryzKXgrAbvTNs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

In ibmvfc_send_event(), the non-H_CLOSED error path uses a bare else
clause to handle the case where evt->cmnd is NULL, assuming the event
must be a MAD and reassigning evt->done = evt->_done before calling it.

However, SCSI Task Management Function (TMF) events created by
ibmvfc_init_tmf() are initialised with IBMVFC_CMD_FORMAT, not
IBMVFC_MAD_FORMAT. ibmvfc_init_event() only populates evt->_done for
IBMVFC_MAD_FORMAT events; for IBMVFC_CMD_FORMAT events evt->_done is
never set. Since TMF events also have evt->cmnd == NULL (cleared by
ibmvfc_init_event()), they fall through to the bare else branch,
copying the uninitialised evt->_done into evt->done and immediately
calling it — a wild function-pointer dereference that results in a
kernel panic during SCSI error recovery under SAN error conditions.

Fix this by replacing the bare else with
'else if (evt->crq.format == IBMVFC_MAD_FORMAT)', gating the _done
reassignment strictly on the MAD format where evt->_done is guaranteed
to be valid. TMF events (IBMVFC_CMD_FORMAT, cmnd==NULL) no longer reach
this branch; their evt->done (ibmvfc_locked_done wrapping
ibmvfc_sync_completion) remains correct as initialised, allowing the
waiting ibmvfc_cancel_all_sq/mq paths to receive the completion
normally.

Fixes: 848c70852e3f ("ibmvfc: split NVMe support into separate source file and add transport stubs")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 728529155ded..e4a21ca6815d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1859,9 +1859,12 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,
 			evt->done = ibmvfc_vfc_eh_done;
 		} else if (evt->fcp_req || evt->ls_req) {
 			evt->done = ibmvfc_vfc_eh_done;
-		} else {
+		} else if (evt->crq.format == IBMVFC_MAD_FORMAT) {
 			evt->xfer_iu->mad_common.status = cpu_to_be16(IBMVFC_MAD_CRQ_ERROR);
 			evt->done = evt->_done;
+		} else {
+			evt->xfer_iu->cmd.status = cpu_to_be16(IBMVFC_VIOS_FAILURE);
+			evt->xfer_iu->cmd.error = cpu_to_be16(IBMVFC_CRQ_FAILURE);
 		}
 
 		evt->done(evt);
-- 
2.55.0

