Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0420E3914E5;
	Tue, 23 Jun 2026 01:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178273; cv=none; b=qXmY05I7jqXnMGDqRFWXZBp4lPWHk/MdEFOVgbVTIQmf0vgOejEgHvpHNjY45eNfC4MygeqZ8eZJLEI0sie++e0IG1BweiBT+BoOdoBqrtrtvBb+uV73GqKkkzX2eHRpoKMbBSfgbcEWGlimYC+XouZct4DCjBTPcPazDFqfZgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178273; c=relaxed/simple;
	bh=EGMjzC9aIDQLyq+SyxXPLzhx0r8GvvZPiFhxqzyse4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdZC0GzAJ0OLalNR0YrfAsTQ9UuyBbe87Y1857O56GYq9EbKYCdV4HoPHt7LsGMhpNaCTJAwYyBvQ6asE0x2N8gi0loBGwGrfCZEJsVwE//zAjIxQpq4YRElsxFdlZW58ESBM+7KtgCcypoX16IVzE5W2JDaDK9Saq7HvWkf07A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jb+F5U40; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jb+F5U40"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0mOE1408289;
	Tue, 23 Jun 2026 01:31:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ZVqzhdiGRQYsN+99H
	pSW6bxW+RQJVZN+/exizLFPWpA=; b=jb+F5U405uCi4STberoLhtT41Mc2jYDZX
	7d9kd6QgLtozys7zdN7eYwcyagCa+FhsegP2sAnxIM2dRsBoKWPpqVSTMuJ67eao
	xiKve6AljcpVrhuCEdVYAmMA/eMAUYKZysyPR+e26Da8zus1MLTcF8363LdjAyEq
	7dBt0QGQfV+FHB1kiUXBTI6rgnRAlrDFMy7P8yGZD6aYq1n4kU7nm7k6BbdV6iCZ
	L4Xn3rfiZsOAzOEPDWCmo40DG6UDPVbFQzb+yFPWYWcasyZc8rw+6MTV9Pig/rUf
	yT8MmZTkhAzprbhFAutN1fALi0uOnjtdYBLppTlwQNyXwhmqlP1QQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjc3c4re-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:31:01 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1JgpC014680;
	Tue, 23 Jun 2026 01:31:00 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ex6ph8vn1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:31:00 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UxBv31261438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:59 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2014858062;
	Tue, 23 Jun 2026 01:30:59 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 84A9558056;
	Tue, 23 Jun 2026 01:30:58 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:58 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 29/29] ibmvfc: fail nvme-fc fcp-io and ls requests during transport reset
Date: Mon, 22 Jun 2026 18:30:35 -0700
Message-ID: <20260623013035.3436640-30-tyreld@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=X4Ni7mTe c=1 sm=1 tr=0 ts=6a39e1d5 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=czMmi51XX4O85vg_JHUA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX/o2pfFUDHwk3
 wBxnxsBS38J3WPR83s8MzrRQepA/ny4wyIg1kzfUYw+qN22HWPbbilw80PU+4jOql5NOqyzXsdR
 uiAAmXiLCvtPcXSN/Iu9w2CIgWstI8w=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX6YJvf0s7MlxL
 GqwVKfdp6dOE+4hZRNQADI88aFYwq6io4BsUxtZi4676CGWLl5yR+SuBuKirKWqjnIfTqiofMch
 Rotku80lnLFFx+idF2nMUpkTnzJKL3D3XXqHrUAGaNdlklKRO3eK+UjNPHY4ZyAXimkLg0MIl1F
 +NMl+wsRe8hKxyHMwYGDJ8tCBZEVhy6VnTBLSrJVkCnei2Dl1Lvuc7/0KiTe9CaqZkhYw3Kj7CO
 JlJn3KoIcZsLSpZfiE2WMTvD5jjDtPqHygem1dIkrcR2VkcrK50AjpXE6IIM4T8bLqMMpmAQcFW
 H45FGH93+JyFwg94YzdHEuj5kNz5UiJ3hVKFh5HEn6nHDzhgA5XwMVHQSN6tJsS5lGax06inF2P
 QDED7mX7eWt+rP4iT+69mIlIuY+tcHOJexiBDko0mINpUj4y0yq49Dgf6+gTWG5FmScZhc/3fN+
 BON5rc2wuVPZQan7RoQ==
X-Proofpoint-ORIG-GUID: QhxdvlhlAJdwfvESnb_67Xd3XO9ytN7g
X-Proofpoint-GUID: QhxdvlhlAJdwfvESnb_67Xd3XO9ytN7g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

The current purge code for flushing outstanding commands during a
transport reset only deals with SCSI commands. Rename the
ibmvfc_scsi_eh_done completion handler to ibmvfc_vfc_eh_done and wire it
to correctly complete nvme fcp and ls commands when flushing the
inflight command list during a reset.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 30 ++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index a7183493cf96..aeb5b8902aa5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1092,20 +1092,28 @@ void ibmvfc_free_event(struct ibmvfc_event *evt)
 }
 
 /**
- * ibmvfc_scsi_eh_done - EH done function for queuecommand commands
+ * ibmvfc_vfc_eh_done - EH done function for queued IO
  * @evt:	ibmvfc event struct
  *
- * This function does not setup any error status, that must be done
- * before this function gets called.
+ * This function does not setup any error status for scsi commands, that must be
+ * done before this function gets called.
  **/
-static void ibmvfc_scsi_eh_done(struct ibmvfc_event *evt)
+static void ibmvfc_vfc_eh_done(struct ibmvfc_event *evt)
 {
 	struct scsi_cmnd *cmnd = evt->cmnd;
+	struct nvmefc_ls_req *ls_req = evt->ls_req;
+	struct nvmefc_fcp_req *fcp_req = evt->fcp_req;
 
 	if (cmnd) {
 		scsi_dma_unmap(cmnd);
 		scsi_done(cmnd);
-	}
+	} else if (fcp_req) {
+		fcp_req->rcv_rsplen = 0;
+		fcp_req->transferred_length = 0;
+		fcp_req->status = NVME_SC_INTERNAL;
+		fcp_req->done(fcp_req);
+	} else if (ls_req)
+		ls_req->done(ls_req, -EIO);
 
 	ibmvfc_free_event(evt);
 }
@@ -1146,8 +1154,10 @@ static void ibmvfc_fail_request(struct ibmvfc_event *evt, int error_code)
 	BUG_ON(!atomic_dec_and_test(&evt->active));
 	if (evt->cmnd) {
 		evt->cmnd->result = (error_code << 16);
-		evt->done = ibmvfc_scsi_eh_done;
-	} else
+		evt->done = ibmvfc_vfc_eh_done;
+	} else if (evt->fcp_req || evt->ls_req)
+		evt->done = ibmvfc_vfc_eh_done;
+	else
 		evt->xfer_iu->mad_common.status = cpu_to_be16(IBMVFC_MAD_DRIVER_FAILED);
 
 	timer_delete(&evt->timer);
@@ -1816,8 +1826,10 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,
 		dev_err(vhost->dev, "Send error (rc=%d)\n", rc);
 		if (evt->cmnd) {
 			evt->cmnd->result = DID_ERROR << 16;
-			evt->done = ibmvfc_scsi_eh_done;
-		} else
+			evt->done = ibmvfc_vfc_eh_done;
+		} else if (evt->fcp_req || evt->ls_req)
+			evt->done = ibmvfc_vfc_eh_done;
+		else
 			evt->xfer_iu->mad_common.status = cpu_to_be16(IBMVFC_MAD_CRQ_ERROR);
 
 		evt->done(evt);
-- 
2.54.0

