Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4985644CF3E;
	Thu, 26 Feb 2026 20:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772138642; cv=none; b=uUdE6t9js0+jztbGwV+rf3Q576/ZT2tVcjEQAU0MmJ7slLbXHKW68E5vexusqKUPxJAmVWTd5lJuz8eEISljyIA3HRXGY6ASWOmoqMdXx7rug1yveEXGQCzytr4jQbdFouQm8uCZkSNADtTblq3hl4uAjfcYdI1HUfgqImd2his=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772138642; c=relaxed/simple;
	bh=9OOC6f/Ds/rqW97Eauqzcuaa/GLZ9nKBYf2+qnYYkB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjHky4Vm+pj1GHWzWPexEAvQIArG7gfcXWIo3yN7ERdiBGKQfL+8DlKE56zNvdyuqiDcr7JzNsBIbTov5SEgvrKmynlImEUu+/RuI5NxwbunM3BLpwC5UBSyRibZXN4yAAQMzdam6+WgAlO71NkGTGotNwCvXPFJ5WFo+w328do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ESZ3dWh4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ESZ3dWh4"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QFiDea3390406;
	Thu, 26 Feb 2026 20:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=MIR7aTzBeWmbzk2UP
	2NRGTWnfx1YZ/uxI7afZhu5YOw=; b=ESZ3dWh420ZanQsEv5ew8W6aV/BfKEj+B
	f1rz3lNq8rhvy7Ktixl4S7sC0G+pf9p73pmX6xdHIAx4+f9VrZWMl/E8aEI5IP54
	Cj1ABVJ3NwgQbr3cziYH5NUcPJJ7OQ1gwi16W85geDdv72x9sQZzy7UN+I9c660M
	ghFGT+9CEbr88uXgAgrDSZgAezRpMU9ysp21sUMhJbRzUZvfi8kM2PaMiDBfC9f8
	lVjf8/QiCaNxFa7gHGlgX0XK9GSd2pIVX19o44XhPIQixNJXdFvxPOiAaLjVw8rH
	CMYDO1AbYodmbtvAGhIrukPQEYKv8VKW6ORJ/LDDT21nGqyPmGUIQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf472932c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 20:43:50 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61QJKjHR027812;
	Thu, 26 Feb 2026 20:43:49 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfsr25t79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 20:43:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61QKhkkA38142448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 20:43:46 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4DAC2004D;
	Thu, 26 Feb 2026 20:43:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B756320043;
	Thu, 26 Feb 2026 20:43:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 26 Feb 2026 20:43:45 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56370)
	id A02A7E0B5E; Thu, 26 Feb 2026 21:43:45 +0100 (CET)
From: Joshua Daley <jdaley@linux.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        jdaley@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH 1/1] scsi: virtio_scsi: move INIT_WORK calls to virtscsi_init
Date: Thu, 26 Feb 2026 21:43:45 +0100
Message-ID: <20260226204345.1904786-2-jdaley@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260226204345.1904786-1-jdaley@linux.ibm.com>
References: <20260226204345.1904786-1-jdaley@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NhWtBY5ItWdSNhAlMvIkhS4pMiPlf3Ee
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDE4NCBTYWx0ZWRfX7JDkeYENbPbF
 Vh/LGlaXb4pIfaQ8v7uaJjgLBIOPZd6H8CYbvG+OCMFCcxLSOLtARuTDQGC9ubgsY5tWkf0aHuj
 2ZHA+6M2jvXGdGlAu5qEHQhuRioA97Ub409ACjKbW2FkRM7utBMCzf87TkUDEbS87NKHgPdYmtg
 ELphWOhiNAySiJklMeyRadd0n3WXXea6JjwAj9RgLSXE35uR7kHrI5gfyPci8VB3m7D7L5x243u
 lpjm5f7IAMcNlyJbUPbfmDoVEwKSRcRY7H45q2PNMIy6zyRJxpDfs3Dv2ukvFkyMqKIqJqgoXkJ
 QytIWkBgtTYT4K4UbSuZHaKLvKZ7HO8TNSSYks7GowW8LaWRpW0tAWyOfpZS2rIuSIOBCRULYVx
 rqC8CNMA9zs4HH6AX2gJlWjCeJ/dLydADJVKtw/QfheBALIj38jbTlNY3p3m9Oq3SuhRqzhDdt0
 AWnmHgAzcwG0aOdu1TA==
X-Authority-Analysis: v=2.4 cv=R7wO2NRX c=1 sm=1 tr=0 ts=69a0b086 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=v7jRQeFWwknd2TLyXd4A:9
X-Proofpoint-GUID: NhWtBY5ItWdSNhAlMvIkhS4pMiPlf3Ee
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-26_02,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1011 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602260184

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
 drivers/scsi/virtio_scsi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 0ed8558dad72..173092931df6 100644
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
@@ -898,6 +897,11 @@ static int virtscsi_init(struct virtio_device *vdev,
 	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
 	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
=20
+	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) {
+		for (i =3D 0; i < VIRTIO_SCSI_EVENT_LEN; i++)
+			INIT_WORK(&vscsi->event_list[i].work, virtscsi_handle_event);
+	}
+
 	err =3D 0;
=20
 out:
--=20
2.34.1

