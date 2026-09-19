Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815253DEAC6;
	Sat, 19 Sep 2026 01:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781614; cv=none; b=bTwfGAL5XsrHu1uxXQ2U6JJFvWE2UsI4jEx9Ho4e1XZ02OkHx1pDo0mq8pgnlDeC5ZZ+gg6sdZ4AHbiBNHoRvVqD1KuXFXtmTbh+6gg6T1K7gsAmAjw1+vWEBGin9K2RuxN+Si/MuVxY31oCSrjHUk/FGa3ONM4it+govuH7lw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781614; c=relaxed/simple;
	bh=z03hf1g/MGed8ekQc4L1G2OMt/GvDb21+J9E3kK0TPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twj9jsX9NnMywEVZ/89oEiEQcfrF5PIX38cY6a+L0xOb1cujNnhvNT5uGpkFsNfH6JPh6rMKagRM8KKvQIVeNfxP5tMGFl/g/KpFPAmJoomCrqxw3560hWz5bEq0CAVthupt7N3hihXkme0N1owXORuGylh7lKBiAEkm3zUyO7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TlAUPq2v; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TlAUPq2v"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J01TvK801747;
	Sat, 19 Sep 2026 01:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=XCp+AIx+BVjjqDwGo
	ZSl8tZmJ+UwiSozL3ueZE1nGqI=; b=TlAUPq2vkvXuZIqMJAphdfzu6Loev31dJ
	zB0ZlwPWCdAbnV8VnJZ+X3+1n129azT2cuUl6RUD1H4nqFYdBaL8Q17KqobQwXAn
	pFicTw3/QvmqzZBhWm1YiOEgO2ItEum51cN3deqZqA4QboNuOh2weqSp5DW+0HoQ
	6XJFGs2OsTxhxONX2nSCAVG9NiKRhvYTmqoLCPDrjFoB5O5iSGT6FHUUElyvvW6Z
	zTJxjh0hpydohr41AOvfVAYRf7c8722v0YNxiv3QKrGZSpEobDVi2c1J0JjF5suR
	yNci0AgyBrpSdUjU8zaEy56Uczp2kdCnWQ5UvC05l2lMfvsTz7Fqw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxdqu07w-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:26 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1RstO1659870;
	Sat, 19 Sep 2026 01:33:25 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gsgrgg0dd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:25 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XNw318350746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:24 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFAA85805E;
	Sat, 19 Sep 2026 01:33:23 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EE615805A;
	Sat, 19 Sep 2026 01:33:23 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:23 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 17/20] scsi: ibmvfc: fix TOCTOU race in ibmvfc_nvme_create_queue() on adapter removal
Date: Fri, 18 Sep 2026 18:33:03 -0700
Message-ID: <20260919013306.2948028-18-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919013306.2948028-1-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfXzZnQQG9DzIcY
 ockY50V1eZmXyW9nujxj1NyTyjWhJistTaZnSxpTlPmeKwgezasqatXtPG8q+KAbIzRO4JNSVz1
 WgO8tA43E72DTv05maTDA9QRxsTIP90g4XqxWtysLDAzc3OJM89zhPMXwinLrKzq4d8NKP5k1TF
 FDV3U+z862s2P28dkgsT2mCbhrWX4LWKZnhJBEuaDoGCW8rJAsw2B0AVJFVCUsIjE8aGiORejsP
 f68M8Gt6pU8/9uEg6lt8a8xkTJj4KvLA2cElUAQ9jGfm7/X8uxKg+Zem4iukcTr/auQ6J3EnyH/
 EhfbBjiI7oCZbWsd2IlnJ4CE5juGIJZDiHBS1ddRNm8upTKpTTW+zMQuwgb8YfKQiXJeK7RJDJD
 +Mju1zklNFZt4cp/7xryD/7cBFiYRZyq+0t1wk4DT0qeNJ+v7Aub2muqum5uKySc2wb5B1AKG1E
 Yjz7Tzl8VOmsf7rY3Dw==
X-Proofpoint-GUID: x7o3pkMooAMBmDjjJv3a5KC856JhmAdm
X-Authority-Analysis: v=2.4 cv=DobDa2/+ c=1 sm=1 tr=0 ts=6aade666 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=M1I_nbD3KY5Z_so_vh8A:9
X-Proofpoint-ORIG-GUID: x7o3pkMooAMBmDjjJv3a5KC856JhmAdm
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX03FWc3gzEWZd
 uLEs34T+iCQBKUFshK6GDVj2A+UCE0HcHG/YeMJjFfbsjoERyEWodkHXPCHhJv53MqMm9zSUzx5
 1VS1YhihpfrRuk7gco665bZHkCIHHWQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 spamscore=0 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

ibmvfc_remove() called ibmvfc_release_sub_crqs() before
ibmvfc_nvme_unregister().  ibmvfc_release_sub_crqs() frees the
nvme_scrqs.scrqs array and sets active_queues to 0, but the nvme-fc
transport is still live at that point and can call back into
ibmvfc_nvme_create_queue().  That callback reads active_queues and
dereferences scrqs without any lock, so the window between the guard
check and the actual use can race with the teardown, leading to:

  - divide-by-zero in '(qidx - 1) % vhost->nvme_scrqs.active_queues'
    when active_queues has been zeroed concurrently, and
  - NULL pointer dereference on 'vhost->nvme_scrqs.scrqs[qhandle->index]'
    when scrqs has been freed and set to NULL concurrently.

ibmvfc_nvme_unregister() already calls nvme_fc_unregister_localport()
followed by wait_for_completion(), which blocks until the transport has
fully quiesced all queue operations.  It just needs to happen before the
sub-CRQ memory is released.

Move ibmvfc_nvme_unregister() before ibmvfc_release_sub_crqs() in
ibmvfc_remove() so the transport is quiesced before the sub-CRQ arrays
are freed.  The reset path (ibmvfc_reset_crq) is unaffected: it only
deregisters sub-CRQs at the hypervisor level and never frees them, so
active_queues and scrqs remain valid across a reset.

Fixes: 86e495358096 ("scsi: ibmvfc: implement LLDD callbacks for mapping nvme-fc queues")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index e68ed5e79e58..701a9ebf2b7f 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -7014,11 +7014,10 @@ static void ibmvfc_remove(struct vio_dev *vdev)
 	list_splice_init(&vhost->purge, &purge);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 	ibmvfc_complete_purge(&purge);
+	ibmvfc_nvme_unregister(vhost);
 	ibmvfc_release_sub_crqs(vhost);
 	ibmvfc_release_crq_queue(vhost);
 
-	ibmvfc_nvme_unregister(vhost);
-
 	ibmvfc_free_mem(vhost);
 	spin_lock(&ibmvfc_driver_lock);
 	list_del(&vhost->queue);
-- 
2.55.0

