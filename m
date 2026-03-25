Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476AC41C2F5;
	Wed, 25 Mar 2026 18:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774462156; cv=none; b=SK10EYUVVflgvrY76oFgXtGUCaUVaZ6dPLa8XvlIdnSfNdOXy+CYUCJj+8STkbZ2zVhA8X3zMyaj0Oiu6sadRIjkRKL735Uih6rSKZ+9/ereOL0rKCFwlk1vBa6UXAv+TdhYWOFVTcRkhzogyDl+r6gQb3ApSB0dE/vedgUoJQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774462156; c=relaxed/simple;
	bh=pGi6LjVbBbi/68KK7LUs8qySEoJFyhofTsttJ1TLs88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TePAn1ZDh2fIxF6yzFivZJBCUaUEqex8XJ2OEb6Lm/LkfaoDcYKDOYu7BJyymCPe0iE8ltzKOA4x6N3jzi2sKRIwulBOX2e9INrNnQhc0UFi7XNXP0FvjPBlY7aOHIaYXbtkwpMfmjNYVTjpzcWgaIsXrfPSJAIYWDU4FMDP70k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iAEBefsr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iAEBefsr"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PB6SJm486138;
	Wed, 25 Mar 2026 18:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=riJ4k8wcC/B6wPy16
	7MskGiAMZ0MLojTu2lTrqqMofk=; b=iAEBefsrM0P/3SSkDpnHvRQr1SzgunxuE
	AriYCe1yIH75me7GKkLLdUTW4zu2ehfK7bY6rPYrTDNtBFHitYBk6u7jHl3sDPgu
	uMdm5VLLlCUK8XImuZ/3RDFamJQCmqz6FsB+bwraZ0MdXbRrFYeve11qcOql3usk
	rwU0EoGXPDG5r1w/CTA+6fR8aLt89wxpRBj3HXOkEieaUCrc7ZbUMgoqwc3TT3de
	gq+xwbf+MMHmHTc4wrHkX53Xwd0CzVgKORhiQhN1Txe+si3bvgUiy+uN4fUQJkXj
	J+pXDs1vtxBR8wntkWbkpn6040HYyhKSnq02WNlYHxFE84G+MYhAA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kty1s6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 18:09:03 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62PGK32x026698;
	Wed, 25 Mar 2026 18:09:02 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d275kym4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 18:09:02 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62PI8wUH48496970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Mar 2026 18:08:58 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D6792004D;
	Wed, 25 Mar 2026 18:08:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6ECB20049;
	Wed, 25 Mar 2026 18:08:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 25 Mar 2026 18:08:57 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56370)
	id CCD14E041B; Wed, 25 Mar 2026 19:08:57 +0100 (CET)
From: Joshua Daley <jdaley@linux.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        jdaley@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v4 1/2] scsi: virtio_scsi: move INIT_WORK calls to virtscsi_probe
Date: Wed, 25 Mar 2026 19:08:56 +0100
Message-ID: <20260325180857.3675854-2-jdaley@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260325180857.3675854-1-jdaley@linux.ibm.com>
References: <20260325180857.3675854-1-jdaley@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=IqITsb/g c=1 sm=1 tr=0 ts=69c424bf cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=v7jRQeFWwknd2TLyXd4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDEyOSBTYWx0ZWRfXwBr/0xI4mLQj
 jMZ3dMHbDEK9HnPJyh4B1i2QTbHnWCS/LLi25g4s1/rHfym5wX0ip2P02nVHgiSpH+IJ6qGM7U6
 TzggFavvJokLykps6PDeQWVt/z67twkcx34QlJOOiGaQnJ70kSvWvzvqzcIsaRcTMmU7vIvbdWP
 QOIfIeIEPZh4Zq/+inRPwMnnyTgBw/5fvte6RD5SCJNelWz8KZc8qtW0i76C6GXIXxNxuVJVZvY
 2EsTcblcN4M99SgZJkfdNQKUgPcpR1vhJJSpBAWUfWlUj3MmjRjO25VEoHC7k4Ks4Ydw/vd6kke
 DxTzx95aalJ9VVMgncbFKanIqeN8u347nPhRJqBZg3e+KZEB7Gm/ImTJg5fL78awsBHu6fl1Ek3
 ht4bDgfdKorFsQzNg6mMiomdGFBbe8iS8mzLEzhWMIXhO8WQGI5E7XcEjGbrNvusIcvwNKGMHS7
 jfhStSFH9n1T5ksfssg==
X-Proofpoint-GUID: _JRx8aPT80gy2TlQCl3upBKkSmy20lmB
X-Proofpoint-ORIG-GUID: _JRx8aPT80gy2TlQCl3upBKkSmy20lmB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_05,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603250129

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
virtscsi_probe instead.

Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
---
 drivers/scsi/virtio_scsi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 0ed8558dad72..64b6c942f572 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -233,7 +233,6 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
 	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
 };
=20
-static void virtscsi_handle_event(struct work_struct *work);
=20
 static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 			       struct virtio_scsi_event_node *event_node)
@@ -242,7 +241,6 @@ static int virtscsi_kick_event(struct virtio_scsi *vs=
csi,
 	struct scatterlist sg;
 	unsigned long flags;
=20
-	INIT_WORK(&event_node->work, virtscsi_handle_event);
 	sg_init_one(&sg, event_node->event, sizeof(struct virtio_scsi_event));
=20
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
@@ -984,8 +982,11 @@ static int virtscsi_probe(struct virtio_device *vdev=
)
=20
 	virtio_device_ready(vdev);
=20
-	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
+	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) {
+		for (int i =3D 0; i < VIRTIO_SCSI_EVENT_LEN; i++)
+			INIT_WORK(&vscsi->event_list[i].work, virtscsi_handle_event);
 		virtscsi_kick_event_all(vscsi);
+	}
=20
 	scsi_scan_host(shost);
 	return 0;
--=20
2.34.1

