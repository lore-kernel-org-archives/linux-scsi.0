Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3953DF008;
	Sat, 19 Sep 2026 01:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781614; cv=none; b=khh1PWAeMeaTD0nGert5kIDh6Gji2SEALTrNKTrQ3/qSj3NocfxWVduhDSfcdKqYPKSUKFmlPDwCz+6gVUVLxAXzrjmBhs2q3TXv+RwCxwo/R8fiaLdRr+DVbOCIP6ZWk/8UJw18wHj1Fx73oHWa//NBUO9mtVW9xTjyK0hzE0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781614; c=relaxed/simple;
	bh=gC5CtJvCE/UeLyLYW3gJmGIK4MsYGFvv3WeROwLAxBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s6u7NE9/hTbY2qx7Rvsy4/gNvgujFypYrkx2+saOj+yQnpvweplcSl8sCCJ1q9g9/+H1VubL02xTgalNSNBYzyJt5bppomFBt9kBk1QA6E/rBkIs6OPoCrK/ajhHmdGjCiiKaTtf5xl1GJ5XvgcHUth375TuiBy0Zle8ASaRJ0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o52m33fU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o52m33fU"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J01WWx801775;
	Sat, 19 Sep 2026 01:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HcYrKj
	QC1tsZ3EaUndU0ikjcJs/juHwwYA7r9AuQGTs=; b=o52m33fUtyAv4g9NmYptNe
	WoOj5z20+saplxo/96/Dd9T9iGJdrwKH/XoETx2bnhJ/zlnHZLPyHXwwtynkaAvl
	DRXiYQSPT8jqU51yAkwUIP3JcR5HmYfwUUTU8wm7kl58oYFzAu50ytgOheFfyAmV
	O+tskBBA7RNJPAnJm+erNtIPODCzQAnnpxbMQcJcWVqAJnYrDUa38jWeKFGmO1ou
	oKcqvfLZMvM69TZXrGb+QRe3zibjIvNJLQg+D4F/oMBKAt3wdlUm6fDPRXoMRU0y
	KeGRpbwF8wsFl1v/EgPoOH1YzpES/l3h0rZTjp2YVv/mblZFYa+okx5voHLOwl8g
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxdqu07x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:26 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1TW5F1630405;
	Sat, 19 Sep 2026 01:33:25 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gsgsar08v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:25 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XOBI33620714
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:24 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91E8158051;
	Sat, 19 Sep 2026 01:33:24 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB02F5805A;
	Sat, 19 Sep 2026 01:33:23 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:23 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 18/20] scsi: ibmvfc: fix NVMe sub-queue registration failure disabling SCSI multiqueue
Date: Fri, 18 Sep 2026 18:33:04 -0700
Message-ID: <20260919013306.2948028-19-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX5nakQqkm8b2x
 rT0iJ+9wui29RimkAspRRoOuTscjTKRRwK1OB4L/5jQx0ULyvhQvQMk/uhvsKAmNBFAZcI9a+Uy
 5oVMmq1pkCXQ1j6Uja3hJjw0TjZ0mmqQ1+HKrwJdIIF6VKeYKXa+L1m0cMfAyxGDHsgYQmSetJM
 3cj/pkx3aweO9KOtBlf5hC1x+57Ajo7XWLzO4hiR0Zf4SDnS+W8oCwSopf3egrP9wdzKQALfMlA
 H98QQ3SMigAbR9dMZhbVZWEMrf/LmK2eaQmzxUqrfVU0DSR8k6im4ZxWD7z7k0wq9u2BnpgrE4x
 T3IKbKKWMXD5qa7G9WhH7IwdfdLrylUyanUNRdsZ5hLHObd9DNYtCye+OJ5TW/nNbwtB70m4sez
 magCXtSYiQI0PpO4JjGvNu5FoI4tOvaTITqDk/JSbhXRcOxej4L9PH/TPVki65KD9SLBTfFoa1P
 bopr7GNP0pWShPPam9A==
X-Proofpoint-GUID: Hp85aObUSyI770F8iJk-7OSdbNmfklGW
X-Authority-Analysis: v=2.4 cv=DobDa2/+ c=1 sm=1 tr=0 ts=6aade666 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=f5D_ObsrWLTxtF3643IA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Hp85aObUSyI770F8iJk-7OSdbNmfklGW
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfXyUCxme7mSS+b
 cFn0+c/0k6O2ZFZvgyBDVUX51hv2TuqPIXY90karkkXjgTb7yazsXq3XUwGNH1aCPMb6fpoY40s
 wXQqUOrQJAHkD8JHREv/b9nqtZyhlJI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 spamscore=0 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

ibmvfc_reg_sub_crqs() clears vhost->do_enquiry unconditionally when any
channel registration fails.  The function is called for SCSI channels
first and then for NVMe channels (in ibmvfc_init_sub_crqs(),
ibmvfc_reset_crq(), and ibmvfc_reenable_crq_queue()).  If the NVMe
channel registration fails, do_enquiry is cleared even though SCSI
channels registered successfully, preventing the IBMVFC_CHANNEL_ENQUIRY
MAD from being sent and silently disabling multiqueue support for SCSI.

ibmvfc_init_sub_crqs() already handles NVMe *allocation* failure
correctly — it only clears nvme_enabled without touching do_enquiry.
The same logic needs to apply when NVMe *registration* fails.

Fix ibmvfc_reg_sub_crqs() to check channels->protocol in the failure
path: clear do_enquiry only for a SCSI channel failure (preserving
existing behaviour), and clear nvme_enabled instead for an NVMe channel
failure.  This covers all three call sites in one place.

Fixes: 319f6545a2d4 ("scsi: ibmvfc: alloc/dealloc sub-queues for nvme channels")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 701a9ebf2b7f..914dafd576a0 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -992,6 +992,8 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	vhost->do_scsi_login = 0;
 	vhost->do_nvme_login = 0;
 	vhost->do_nvme_register = 0;
+	if (vhost->nvme_scrqs.scrqs)
+		vhost->nvme_enabled = 1;
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
@@ -1034,6 +1036,8 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	vhost->do_scsi_login = 0;
 	vhost->do_nvme_login = 0;
 	vhost->do_nvme_register = 0;
+	if (vhost->nvme_scrqs.scrqs)
+		vhost->nvme_enabled = 1;
 
 	/* Clean out the queue */
 	memset(crq->msgs.crq, 0, PAGE_SIZE);
@@ -6532,7 +6536,10 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 		if (ibmvfc_register_channel(vhost, channels, i)) {
 			for (j = i; j > 0; j--)
 				ibmvfc_deregister_channel(vhost, channels, j - 1);
-			vhost->do_enquiry = 0;
+			if (channels->protocol == IBMVFC_PROTO_SCSI)
+				vhost->do_enquiry = 0;
+			else
+				vhost->nvme_enabled = 0;
 			return;
 		}
 	}
-- 
2.55.0

