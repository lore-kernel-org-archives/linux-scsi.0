Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF85E3BC687;
	Mon, 20 Jul 2026 07:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784532480; cv=none; b=HZ5j52IRi0EGJrWJQVu5gcMekmaJUxYcY1xSW7UxKp8Hp05SY4dXT/VOtgbITMYOeoeU0pcWySTOunKGlzYaXFd1u1UYpGlGgeNWD5O/66tVfvOpkoM0bWaV6BevzRcl1Ou+IjNAdJkr2lO8XIym4UBEPbc7I94dsZoNtEkR0+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784532480; c=relaxed/simple;
	bh=UP2dQiaZlor9vs4dbDakM/4yamswZALAJAz3oXL/AmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMRU6xv8LXT023j3p9TTaQIQ068oZkCAvD28UR3GnpVGBrjZPx+Ge8UV2z1/mEHv5MRtpZETl7IONSws8rcMKIpS1e0OBtZ3R85QY0EOTq9zzcBTecgS3is5+CPWZ3FbTj9aPqeEY2RHhkOLX7aYBCOdv9GX6COuWC+v3uj4Fvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IdRdRj/3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IdRdRj/3"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K6gPlK1463116;
	Mon, 20 Jul 2026 07:27:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=20TuT4+W+JteQtxBN
	H7J29UffUoKdHdaQDzNgRkigJA=; b=IdRdRj/3si1qm4CBQExKcT6KI2FC9NiRr
	3MnqvJOEuWRASgaIkmtHakaSGzi8uP3PyMS4w0duxhhS8FUQSZTlUHrav9XIYVGm
	GvV0vRZAT1qhtdMDrZHmwDmy7WGZeP29pdBbZFhgTbCyJR7dXuw5/SuwaYK23jZB
	dSKXxjggtQQdPs276DrmBP4snT/HeXAr4HGSKtz7B11g2g0rhkspZeWRrj/G7jUy
	fD4omOm5hU6chqUEbsLEVc2ooeGLHqGiYJ+qafMDzfrk5Hr+g8pgAK0QwjQUjlWl
	Kuz7GwKX6wNvgPjkeWrxMMjnHqb5tnTCEQoXjp/HYlEJUQDDL5CSg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7ab69xt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jul 2026 07:27:53 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66K7OdUG022982;
	Mon, 20 Jul 2026 07:27:52 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgnagvgd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jul 2026 07:27:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66K7RkHI30933310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jul 2026 07:27:46 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B0782004D;
	Mon, 20 Jul 2026 07:27:46 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D936220040;
	Mon, 20 Jul 2026 07:27:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Jul 2026 07:27:45 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        =?UTF-8?q?Vasily=20Gorbik=C2=A0?= <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntraeger=C2=A0?= <borntraeger@de.ibm.com>,
        =?UTF-8?q?Nihar=20Panda=C2=A0?= <nihar.panda@ibm.com>
Subject: [PATCH 1/1] fix memory leak during adapter release by destroying gid_pn_req
Date: Mon, 20 Jul 2026 09:27:36 +0200
Message-ID: <20260720072736.3381816-2-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720072736.3381816-1-niharp@linux.ibm.com>
References: <20260720072736.3381816-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA3OCBTYWx0ZWRfX2QErAt7lIEqY
 EZyXQCHyXpHyAUJE/xrvV0GVybPXiEzs4V29y3EKVb1u8ov5gaRVw+5SyW80wjqeFnGYVQQtLND
 0LvvkRgjy0nMKx+/I4fJOF4SHHvgIgMMS38ZGsy6KqoBOf1J4IwaSNsVr+q3+AkoRDd+vnUjdVf
 O/VWtP/molFe5ZkzfW15o5cPxPyaF28mbGYJGpD6mClbFq8X3bHlx45WJLm8LUFKJ1nY6w/oC54
 kMKXFKcYHL7C6aIojQppb5gjGL/YiBcJLns9NARABvTuAVFIrfunr8eTPG9dwg5/uInN0j1Ipue
 Gts3K/sb5GHUSsCBaUt9lUyxnBZjduiPCiTGXfx+Ovak+X81k4UDtokL3sXyt6fAGIrypag3TEn
 Io09cNUVliMQn3vhCQp03DdCnC0yvaWdBnRnzX63JC3VGDbjImDL53e25bKN0pSyL001Q5FI2N2
 CEy5q9btjt4LM8TbsgA==
X-Authority-Analysis: v=2.4 cv=F7ZnsKhN c=1 sm=1 tr=0 ts=6a5dcdf9 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=wSSWrSJ168eZuL-QGrgA:9
X-Proofpoint-ORIG-GUID: 7e41cPfA0tr7-2aq2ReZT6-9GMNsKMfI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA3OCBTYWx0ZWRfX01DP/f8/Skq9
 OQqDd1DaQd072oAz6NE/SoJdFx10c/Re33NZGq+aaM6gbyZc4FMWchrZ9ckYDPC4BRu2EoYN+Qh
 AmmzugVdmAhURD47Xfu4CiLu7HVScX0=
X-Proofpoint-GUID: 7e41cPfA0tr7-2aq2ReZT6-9GMNsKMfI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200078

From: Benjamin Block <bblock@linux.ibm.com>

When releasing an adapter we don't free the mempool `gid_pn_req` that is
allocated during the enqueue. This leaks memory:

  unreferenced object 0xd8d29297de700 (size 256):
    comm "(udev-worker)", pid 2105, jiffies 4294945794
    hex dump (first 32 bytes):
      00 00 00 00 de ad 4e ad ff ff ff ff 00 00 00 00  ......N.........
      ff ff ff ff ff ff ff ff 00 0d c4 5f 67 9d 99 e0  ..........._g...
    backtrace (crc 4a5b5da2):
      [<000dc45f64da418c>] kmemleak_alloc+0x6c/0xa0
      [<000dc45f62b430aa>] __kmalloc_cache_node_noprof+0x36a/0x4d0
      [<000dc45f629a535a>] mempool_create_node_noprof+0xaa/0x150
      [<000dc45ee2c065e6>] zfcp_allocate_low_mem_buffers+0x96/0x370 [zfcp]
      [<000dc45ee2c070f8>] zfcp_adapter_enqueue+0x598/0xd40 [zfcp]
      [<000dc45ee2c08eb0>] zfcp_ccw_set_online+0x160/0x210 [zfcp]
      [<000dc45f643d4762>] ccw_device_set_online+0x232/0xd80
      [<000dc45f643d53d4>] online_store_recog_and_online+0x124/0x390
      [<000dc45f643d8238>] online_store+0x298/0x5b0
      [<000dc45f62eb0a04>] kernfs_fop_write_iter+0x2c4/0x480
      [<000dc45f62c81150>] new_sync_write+0x370/0x4b0
      [<000dc45f62c87abe>] vfs_write+0x43e/0x5b0
      [<000dc45f62c87ff4>] ksys_write+0x114/0x1f0
      [<000dc45f621c4a16>] do_syscall+0x2f6/0x430
      [<000dc45f64d9d5d8>] __do_syscall+0xc8/0x1c0
      [<000dc45f64dc2224>] system_call+0x74/0xa0

Fix this by destroying the mempool during the adapter's release.

Fixes: 799b76d09aee ("[SCSI] zfcp: Decouple gid_pn requests from erp")
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
Tested-by: M Nikhil <nikh1092@linux.ibm.com>
Acked-by: M Nikhil <nikh1092@linux.ibm.com>
Reviewed-by: Chinmaya Kajagar <chinmayk@linux.ibm.com>
Reviewed-by: Nihar Panda <niharp@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 8ff7db7921b5..fea573e00f9d 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -253,6 +253,7 @@ static int zfcp_allocate_low_mem_buffers(struct zfcp_adapter *adapter)
 static void zfcp_free_low_mem_buffers(struct zfcp_adapter *adapter)
 {
 	mempool_destroy(adapter->pool.erp_req);
+	mempool_destroy(adapter->pool.gid_pn_req);
 	mempool_destroy(adapter->pool.scsi_req);
 	mempool_destroy(adapter->pool.scsi_abort);
 	mempool_destroy(adapter->pool.qtcb_pool);
-- 
2.53.0

