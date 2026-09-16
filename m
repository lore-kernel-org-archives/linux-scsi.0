Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBB7530DEA;
	Wed, 16 Sep 2026 23:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600197; cv=none; b=QzGEJFPTB1pMEfS12UeMMSDpZdsl3DRYs0VCAYF1pmYfJFHYfUDaZe+pjazvhZApPLoU7+g4SMXIlbuLWMISty+7Dsk/IgF5H4b9zc7T9snbkna5XDooUfAaGY3/r/NjQMuZG+QLOeXfQnod96JcBuqZIpXhNUsp+gfHOelMZ5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600197; c=relaxed/simple;
	bh=rgVT3wN05mtR0wVmodPRJgzZeltxN2x8DeHhU3FVo7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YzZ7A4KdD9sGBE2w+LDBRUXGfO7avdALC0h+qjEnalPzvGzmo3TcpIgtNzPepIfhs/ZBBNnsi872RHE6yDOdtpTga+/bc9H9hG/M3RY1RVngSXSnHb6fHnr80Su2cIZsx+CSBKTFVnJGj4ePNPKvjiMvfQPu+2Fa2zqHahYdUq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ia3PeJ0k; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ia3PeJ0k"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1bMS4057200;
	Wed, 16 Sep 2026 23:09:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=CUWkOg
	NJs+S2I9guIEGrq4RU0vb6psXCglD3/VkXnr4=; b=Ia3PeJ0k3dnqRnXLmHi+wc
	hwFT9LxrOnmEvUw/bnaCsIZSQYz8vLeU5n9wEXIgc82JSGhpA8BCz2H9mDI5Qcy4
	YT+zcqlBgjm0GLiSjihHzvUE3K37Fk6MiUfczq/rHaWQ4cLFFS0ibcYMSW5ajnke
	DEaHcbta1DCGnXQWe9Hqfm+S3vnt6KFSsmeqkVRSTY9D82sFwT3XOjAR5/xeY5Pe
	pReoBUFG70mnOMTwBz5hrP1Adxy5963tVy8YvpGb0U0qice9DjK1/6w1WqBXpqWJ
	xwMSIKd+rwryB/TTnYXxQwhmdRYP9m6NuEU2SU3cjH2iRAyH3HNjk2D3/OkIEy/A
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmv5hy9vj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:49 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GN2IAV1699595;
	Wed, 16 Sep 2026 23:09:48 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gq03vgug6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:48 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9lDJ24117778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:47 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 57B2C58054;
	Wed, 16 Sep 2026 23:09:47 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CAAA5804E;
	Wed, 16 Sep 2026 23:09:46 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:46 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 18/20] scsi: ibmvfc: fix NVMe sub-queue registration failure disabling SCSI multiqueue
Date: Wed, 16 Sep 2026 16:09:19 -0700
Message-ID: <20260916230921.2204729-19-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916230921.2204729-1-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX2mRyg3CP3mu9
 Llbq6bokMo0MQmI4+jqWZNlYmegVdsBRGZMKhfhO6qnEMhVTGs3F7U91EKF9VDzMOQKImhYCGWw
 oksmMYlmauCYi+1cxpmPz6Yyvcln7mAlnAKc1ewUl5R7ZSXmtnFqexQhaka49W5sWpqWtuybdxj
 smz9RlrRaUVfMD21e2AWc+sS9pkikTGwXfjc/GoPLqMHqON2r/HEck+dKCkZcg3X6pjN+UDiiWy
 2n81p5habBT6uk3sykxYCK4Zi1MMxGajUZdQVVif2qo45jYaRwKOyr+QQo+3dbqEygVryS5+Dhb
 OHvNdDO5nEEjI2ehOYITUl4mdrEgq8kKnqPK675F7/sEPusNeP3n/nMk65NFl1BNiOQjFxZBzJr
 nyo8uudjRcASqHSlRPXpy/0IxAbtLx6A3hdxmUHcUekT+a8+3GODMJ+LUjsdxn1SKu/z/++TdKo
 ZoPHPex55OeKTmxwraA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfXxY5Vdo/emS4H
 8uYs9phZnO+X+CXfA6S6JxqR51DZJFwJPzrQDZFJ90OyvsCH06AmJ8fREXxz09EO0/mztKXjc8v
 TmbBUUskxEAuQm9eL2RJEcGU/JZ45eM=
X-Authority-Analysis: v=2.4 cv=Zsx4uN7G c=1 sm=1 tr=0 ts=6aab21bd cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=To5To57u1w-uQxo1Mx4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: oqtPaZAwKHanj0Mqrz0476d9XTXaaxtk
X-Proofpoint-GUID: oqtPaZAwKHanj0Mqrz0476d9XTXaaxtk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160322

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

Fixes: bf86ac3ca0d2 ("scsi: ibmvfc: alloc/dealloc sub-queues for nvme channels")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 93189692191e..d79a6ae278a2 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6527,7 +6527,10 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
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

