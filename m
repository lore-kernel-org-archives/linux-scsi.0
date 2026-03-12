Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BC2390C94;
	Thu, 12 Mar 2026 17:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773337388; cv=none; b=GxayO60vbizNJm9lZTC2WwjEwcUfOwWqhh0GjxN4NrUDsI3+RCBPXfwZhCmEIJKsRdXQlQb6KCl5I7EsfgNZLtKp15usE4ZcvFgqhV11dgrx1xQEOE3Dj20Je63GFe+CPTLLkFhxH7qHjH90K9naZPoI8xb1u+lvXSF2105TxFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773337388; c=relaxed/simple;
	bh=jwM/MniTRVmIXLeYQ2P9xoLGtegag48iMmbWdWKoTL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNIlzvwv5CnaFsVkSPfLnzUPlbXSnrrhxJUGhUyb1jaJEW//a+ccPjBtrUV9t8n6NG3RSiyLpasB02JAjEKuc8MtqV8LqTRadRjNIK97JYljoPwlIz7s1XNFQn6c4IwO39ruLQSkW+OPDIW+p1P6Ym0UjWwjKrYGiNFFHKXzo1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Cmx36UKV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Cmx36UKV"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62CECoqr2208560;
	Thu, 12 Mar 2026 17:43:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=bJphuA7b4KVgB2pgv
	Zd/duGPXnMyROJyjB5SLezQs+o=; b=Cmx36UKVN4Y3I0lQoXr21sOUggFirYB47
	eUhKgOhZ4ajJmkq1bgnfJPICIqOsK3ZVVUYvoxlHVjy9ZDYpga0XxhqwDR7jArrB
	T15oBhis+MMoFLTVTDkh9moBEQjOw5nWGdh0fyYAyVnQPJXLNcWKqcx6wRU1mM8Y
	IebQqW44gpTzJN6n3cEy/RRPLPxyOfRe6PCZ8aRGMF2qQd3SRJ4q8IgWnc5neSm6
	fnzYitzBECWZnLt/DIvLCiGhyop9GgCwYFZ3E/+71BkLIKdL8tKe0IPfRaLc11GP
	WnBFLbtrCvXJ5jTahxUJBGzVb3zctO/ab35bx0ONNjvHVaiQH+4oA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh98bwxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 17:43:01 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62CEc24m014634;
	Thu, 12 Mar 2026 17:43:01 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha8bd5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 17:43:01 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CHgvoU52298238
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 17:42:57 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 241DC20065;
	Thu, 12 Mar 2026 17:42:57 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E549E2004E;
	Thu, 12 Mar 2026 17:42:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 12 Mar 2026 17:42:56 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56370)
	id CD222E0903; Thu, 12 Mar 2026 18:42:56 +0100 (CET)
From: Joshua Daley <jdaley@linux.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        jdaley@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v2 3/3] scsi: virtio_scsi: move INIT_WORK calls to virtscsi_init
Date: Thu, 12 Mar 2026 18:42:56 +0100
Message-ID: <20260312174256.1557045-4-jdaley@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260312174256.1557045-1-jdaley@linux.ibm.com>
References: <20260312174256.1557045-1-jdaley@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=M+pA6iws c=1 sm=1 tr=0 ts=69b2fb25 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=v7jRQeFWwknd2TLyXd4A:9
X-Proofpoint-GUID: x0J7iJTjVmdT6oE_TWUYtGlQ7ZPjBA6z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDE0MSBTYWx0ZWRfX6wuocgTNF0/R
 PxyEfKc4cLjz3F0RzBbpKbcwQJsNlrRSAw+L9sGV2wmq21IxqI+74JKvMUhvVxnwNggPdM9x4Th
 Q0wJk3b2dYRCYL55LK0VWVNluLytdSlLRIXyBCEZaFKBplWAQto/GUWyIVGFsd6l36gHZ/mmkdo
 E0PRIcpZGHkNGFx49QoO9THpIhd1EHQbW3t29N94EL+u8R5frCrZS4KpwXaKNT327yNpFDwiDrI
 H2J6/l/40drxXi0urthX6wCsf5D99IoFmbSlKhSFrxAZdXeX5+woIdppYze2Ts0sjta396H2uPq
 pIxsnhhsN0RZUpgEw9kkKLtkM3NXeP11eFb1oJIYI3MRXE6NQmrfkzwi1eGfUt1n1/0Ikeiab0q
 1xLE/oSyQxMBdZld1Ot9xS3NOQRr27XAvcxUqpDuU3bjhA9WE2uUhljC/IOmMC66xgfQBxa+sCD
 9FZz/fIUfReEb51tgqQ==
X-Proofpoint-ORIG-GUID: x0J7iJTjVmdT6oE_TWUYtGlQ7ZPjBA6z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_02,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603120141

The last step of virtscsi_handle_event is to call virtscsi_kick_event,
which calls INIT_WORK on it's own work item. INIT_WORK resets the
work item's data bits to 0.

If this occurs while the work item is being flushed by
cancel_work_sync, then kernel/workqueue.c/work_offqd_enable triggers a
kernel warning, as it expects the "disable" bit to be 1:

[   21.450115] workqueue: work disable count underflowed
[   21.450117] WARNING: CPU: 1 PID: 56 at kernel/workqueue.c:4328 enable_=
work+0x10a/0x120
...
[   21.450171] Call Trace:
[   21.450173]  [<000003db2e5bdc3e>] enable_work+0x10e/0x120
[   21.450176] ([<000003db2e5bdc3a>] enable_work+0x10a/0x120)
[   21.450178]  [<000003db2e5bdd86>] cancel_work_sync+0x86/0xa0
[   21.450181]  [<000003daae97d9e4>] virtscsi_remove+0xb4/0xd0 [virtio_sc=
si]
[   21.450184]  [<000003db2ef3b5ca>] virtio_dev_remove+0x6a/0xd0
[   21.450186]  [<000003db2ef9106c>] device_release_driver_internal+0x1ac=
/0x260
[   21.450190]  [<000003db2ef8edc8>] bus_remove_device+0xf8/0x190
[   21.450192]  [<000003db2ef88d72>] device_del+0x142/0x340
[   21.450194]  [<000003db2ef88fa0>] device_unregister+0x30/0xa0
[   21.450196]  [<000003db2ef3b2fa>] unregister_virtio_device+0x2a/0x40

This warning may occur if a controller is detached immediately
following a disk detach.

Move the INIT_WORK call to prevent this. Don't re-init event list
work items in virtscsi_kick_event, init them only once in
virtscsi_init instead.

Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
---
 drivers/scsi/virtio_scsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 6efbeaa30f65..fe1bf37f1317 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -240,7 +240,6 @@ static int virtscsi_kick_event(struct virtio_scsi *vs=
csi,
 	struct scatterlist sg;
 	unsigned long flags;
=20
-	INIT_WORK(&event_node->work, virtscsi_handle_event);
 	sg_init_one(&sg, event_node->event, sizeof(struct virtio_scsi_event));
=20
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
@@ -896,6 +895,9 @@ static int virtscsi_init(struct virtio_device *vdev,
 	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
 	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
=20
+	for (i =3D 0; i < VIRTIO_SCSI_EVENT_LEN; i++)
+		INIT_WORK(&vscsi->event_list[i].work, virtscsi_handle_event);
+
 	err =3D 0;
=20
 out:
--=20
2.34.1

