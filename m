Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE49D3A0EB1;
	Mon, 16 Mar 2026 15:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773675238; cv=none; b=FB1iHFMXuCu4WdvvqIzmHZkaVxoHcr+Mnmq1HGqIvZMdyewPAXCbkxDazC5KKDv0cP54XsiV33iUB7fpDymosG1x9GjPjJ+aJjvkYUj9JIL7sfmjWrqNSWtxU8cCChLwlWQ8MV7syDhVRLTMST3HOdSj3fdkPAwu4o4UXEaw6AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773675238; c=relaxed/simple;
	bh=DL2ac9OnJv3Fq/xVqfXOb/t5ETJ66jc57gLPp1PZJZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3Ou/PXLzjgLDEUsS8VA9tA6ReH5lKmcvB2AUVrsjFWWcsF3QOyiUoGOe44yEdpKrHaHHqE/f8TR/5+WPoJzMOQqPnxf37dF2V9gYJ92roUXhkvL9aJwSv8wUfNG0+ntAPflCoLhP5d3tCNboaIZmVmOvZB+YugHK5iD9bBRfO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SC8d6P08; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SC8d6P08"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G14kq61189532;
	Mon, 16 Mar 2026 15:33:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QFkhCorH22uyFoF9L
	HbviC9UCB0m/J8xRtt6YSZnI+I=; b=SC8d6P08JegjvWmQgkBmDwL5nm+oHgLJQ
	2j58Q//HtSbG2b3nQMYEdYT+VruRY/MxymCAAmXtQuQMZ4M31ecOXN92uOQRv+zA
	v0c0MC4PJBL48Yr4/Jqn3cHZyzi8qQ5GhSevc+jEytwkAdgkpH3AbMqFjb6/saH6
	qaa9zmFdo7ALQxRixZ5PN6fUfsqsYwhwh2jRqkgIHo+UbpFY8NTCbQk/RP1c7cVh
	Iav7n6uRHht4kD5QCnMSc4YS+a2Rqpqz/yjmcxDNoRf0fmTnH6bWCH4AHodmlCx/
	NA0fHcC+t7+dVxkxfOTvJaYVav6/omtFSGjBOoMlB7yYri6ilPhnQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cx7vfau3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 15:33:47 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62GAkfvF029194;
	Mon, 16 Mar 2026 15:33:46 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cwkgk5a10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 15:33:46 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62GFXgOw29360524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 15:33:42 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4DB6920043;
	Mon, 16 Mar 2026 15:33:42 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B7D020040;
	Mon, 16 Mar 2026 15:33:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 16 Mar 2026 15:33:42 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56370)
	id 0269EE03D4; Mon, 16 Mar 2026 16:33:42 +0100 (CET)
From: Joshua Daley <jdaley@linux.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        jdaley@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v3 2/3] scsi: virtio_scsi: move INIT_WORK calls to virtscsi_init
Date: Mon, 16 Mar 2026 16:33:40 +0100
Message-ID: <20260316153341.2062278-3-jdaley@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260316153341.2062278-1-jdaley@linux.ibm.com>
References: <20260316153341.2062278-1-jdaley@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yNUPtiGdc0RtYb1-tu-JoIAgrnoxHKHW
X-Authority-Analysis: v=2.4 cv=KajfcAYD c=1 sm=1 tr=0 ts=69b822db cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=v7jRQeFWwknd2TLyXd4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDExNCBTYWx0ZWRfX9pCntnbcG3xP
 GpVOxL+Pqzy1oxJdxAAy6g4m3LYvJa89xmC8MOJKVUxsOq2O5nv3w3O3A+SZ97I282cDyp1Lslt
 59lFJz+8AoWC153003C8yZk3nGxqD1z5FZkGOZxkRw35YSh2NuWuBkNOPkaR9yCAzDypxrMNRfk
 F9nJnfx2Drp/AVLBvyZssWJqfFcXoeaDi0l82ADbWXKY6MSQYfvA6Gad6ZLK1mN7ntJew9OqDLo
 hRJuh6TnV1T1bUp8UK09PoDdlO6ZANogEt2mUjsWo6EBKHttgYH6wLgwXKLvCgEszHuNEx4jgT7
 SqGRvzYP8/vxgKK7nwgcxV0w2P/5699iX6YYatiRnrvtHG+OxtOnE4ti/cC2dUOw2djMsR44pKh
 HkSTDdFtrUroWexLMrGsysTe1bHa8MffghJw626WAprCQLdNeP7V3kn9epvOATlzEqcq+Dihi+5
 CmJF7mkUJUCKUumOBzA==
X-Proofpoint-GUID: yNUPtiGdc0RtYb1-tu-JoIAgrnoxHKHW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603160114

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

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
---
 drivers/scsi/virtio_scsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 982f49bc6c69..15ca2a2d7aa4 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -242,7 +242,6 @@ static int virtscsi_kick_event(struct virtio_scsi *vs=
csi,
 	struct scatterlist sg;
 	unsigned long flags;
=20
-	INIT_WORK(&event_node->work, virtscsi_handle_event);
 	sg_init_one(&sg, event_node->event, sizeof(struct virtio_scsi_event));
=20
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
@@ -898,6 +897,9 @@ static int virtscsi_init(struct virtio_device *vdev,
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

