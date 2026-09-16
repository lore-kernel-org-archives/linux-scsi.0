Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00E5514779;
	Wed, 16 Sep 2026 23:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600193; cv=none; b=U33hivwtUKmu/cWnXXFy8PMIJ2M5hg4tF8brqW5WSqruY7xQiKc31kMlB8msQIz+xHkuri8h5CID4bA4NnoSBtuSZ+Z2hUTCjqjcd+0j3U6u4RL9nz97MNuZPsZUQIVSI9V6EORG0hdcs5ewubPFU+qo2d+mMHyYO8Kmr3BtN9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600193; c=relaxed/simple;
	bh=tUJG8WstEMawhLEU5z20g38W8rtx9VTZK8laDi0uyxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RlJyXqeoK/9fjKqa334UC1QadI0r00hngp9uHcVWRKdJqjaNPxNoH8pRBXzE/EVE2QcmGC3UCWqULRxboKoncZEQK2TDKjw0kWz7/ZMoz3a6AiVHZ7MBrCOj9kgEm4CUdvsOrBnmtWnDJadkLxaQHMmH7EsZNvRj2t9I4OXqr+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cGZAQmcT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cGZAQmcT"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1oqT2330705;
	Wed, 16 Sep 2026 23:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/rkG2+
	RTcsFvr4mbe2ojqN4MphfaV5sN28KLxxZ4wlc=; b=cGZAQmcTfgrM5HoxdNt2Di
	uejxLwBGGmes5RHOhLMQt3Bspvaqx3bghUypLuJ0IZ0d+dEqulIKZ438GZfOmx9G
	7Sru1NUenoU69SrEFQXr/oQcJNPEkhXZ/vErxn8qPNJyTO7KALWtvVhpA0P0lnIs
	g73kO4z+21jhfWzsq0hwYO6jpGZ+u2Swy8vATbW71hijcrhd43p430Eeyj41tjw3
	z2TgS5enXS05+YISuPKIsFUZ1LA8SLz1eT/SQ4QEoTToDcNxpbfwOy2k7kqYjz3k
	ifCGWuyDFGqwyx3BpDu+434tDYgR1SxJh67S7IR50XhBhTHNo6tEX8P5qDvK1F/Q
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxdqfda7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:46 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GMrtMN2599742;
	Wed, 16 Sep 2026 23:09:45 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gpw6d9e9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:45 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN91H022872730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:01 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CAB55804E;
	Wed, 16 Sep 2026 23:09:44 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B1F658060;
	Wed, 16 Sep 2026 23:09:43 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:42 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 15/20] scsi: ibmvfc: unregister NVMe local port on adapter removal
Date: Wed, 16 Sep 2026 16:09:16 -0700
Message-ID: <20260916230921.2204729-16-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfXwW9pXpANmQA5
 Sj++64eOXiaztnHyolCBtwpNKDSMASpH2zsZuhLGPDr82zVQdD571TJD4kovamOGjBDcGptyVGj
 SSgGJCJYlSoYq8K1dXsmrQ8lNKNsRXU7lz1jMvyIG6QDZojI0D6nYDg6KHtcSiJ+1tL8AjzRHmW
 4OQ7mwWiHV6WnIGQbKDIML50JPpXKXckI0fRqDgAmuR5vt0qoCA22v0PtOEO/EshQ00/LgqjB+g
 G3Cl+LD9+QKRGt44VrSRtEkI8qeE9UeD7felT57JoimqtQ779NGvr2FgQa6lAEItIJ2KmxE79Cj
 qAa6WtpOFlq0QF01mmKcYh9ModmJHYPTkusOXl9zHqyzdkAl0N/9NoQ5bf0U6khPijVqI066V4t
 0xh2V8UBDVzSRAlnhARhZKgFxKJV15XSK7t1Tj2aFp29qty47zZczpo0cQoSf+pIddQuaLIj19j
 PDW+DMQGsFU+FD+MkTQ==
X-Proofpoint-GUID: LszIPjmvfXcB7eQhFi6jmif6JIC0g1Ai
X-Authority-Analysis: v=2.4 cv=DobDa2/+ c=1 sm=1 tr=0 ts=6aab21ba cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=FP1yMjY_cEXO16Dv5WoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: LszIPjmvfXcB7eQhFi6jmif6JIC0g1Ai
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX7gOK1x4wWQk3
 N9bevllTcC0b09UXTbqhQeN61OjX2dECBWdec0UqQ5VtqK2sFcp2uwwFG17xbFvfQ/joGOsdzhY
 a3i+c+wO6Fx+ETl8LRVUhMTOZVGMs98=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 spamscore=0 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160322

ibmvfc_remove() tears down the CRQ and frees all host memory but never
calls ibmvfc_nvme_unregister().  The NVMe-FC transport therefore retains
a live reference to the local port whose private pointer points into the
now-freed ibmvfc_host, leading to a use-after-free whenever the transport
subsequently touches the port (queue creation, port scanning, etc.).

ibmvfc_nvme_unregister() is already called from the NPIV logout and host
reset paths during normal operation; driver removal simply missed it.

Add the call after ibmvfc_release_crq_queue() — at which point the CRQ
is torn down so no further completions can arrive — and before
ibmvfc_free_mem(), so host memory is still valid while
nvme_fc_unregister_localport() runs and waits for the
localport_delete callback to complete.

Fixes: 86e495358096 ("scsi: ibmvfc: implement LLDD callbacks for mapping nvme-fc queues")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 190410847efb..7af1867b69c5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6995,6 +6995,8 @@ static void ibmvfc_remove(struct vio_dev *vdev)
 	ibmvfc_release_sub_crqs(vhost);
 	ibmvfc_release_crq_queue(vhost);
 
+	ibmvfc_nvme_unregister(vhost);
+
 	ibmvfc_free_mem(vhost);
 	spin_lock(&ibmvfc_driver_lock);
 	list_del(&vhost->queue);
-- 
2.55.0

