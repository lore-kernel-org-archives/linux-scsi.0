Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF9141C309;
	Wed, 25 Mar 2026 18:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774462157; cv=none; b=cGOFhHlZUBVm7cg6vANWTB2rf8JkP8I2EBNHpPi/pZ3IfIXF7KVqOgEmJGLq3Atiq8sIcNPGll08t4Cp8i/UJlLyfz3dJZmMgKV8BtZMBb27WrLoQKnPBcYQysjjmn7lGOlpafIG0sa+xhEJNLoPAtEUzgz/rVkzsiOAQEhlhcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774462157; c=relaxed/simple;
	bh=6BuOBRXmTWUCtl9y7zduCFX25TYqL88ILxR7IGOe5x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=np2AOfmsSRsVkzegZJMAvfVareSEu+Ow2H4s9j1Btk1h4b/Hogq4CzMjWCuf7luXBVX5LGeiocN50fnzyqmEm9R2EmDqaPCRtmFGa0x0VST7nQyXhYlblB3EV+Eu4aAM7PLwSuNgXgeYKnLjuYkpJQSshkDD9AamI1Kw6ysGB2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sOYsXbcG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sOYsXbcG"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62P9A3F1768705;
	Wed, 25 Mar 2026 18:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=GNPu0plGhuI444jjm
	RL0uWJ74ZWYu727MBGUUs7VFhA=; b=sOYsXbcGnHZneJ6FMS4o+bkBffFp2fjXb
	PQKjwS8xGdapW4EDYXJqEMQPUUVBfZrb99fw9O8A1kCGoKUaB2SZ8FdqKOYicEqn
	Q3Es1c9ltDfatVz1u0FHphG/CSHHPa57levxQDiH84F87ehYJuK1SYrU2jkuge+c
	pUgg2P5HmaKXucj47GzJFFAUTuB8EhCS/g9FmVFg9Fe32AxkHuzTyFZFv/l6QJZM
	cSikIhLC7CgIu47sCw1/7rn1M/eo25WR/W89ieD+eQykh2/F5xl8i+KIzr3t1Zdh
	pemC0yakJcEdcFuw+ipiSVO/T8lvUT2rNptHFkPXJQ3vfUzJsTi5g==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kxqhu97-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 18:09:03 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62PF7TV6009143;
	Wed, 25 Mar 2026 18:09:02 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d26nnqq61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 18:09:02 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62PI8wpJ52625706
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Mar 2026 18:08:58 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2183A2004E;
	Wed, 25 Mar 2026 18:08:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EACF42004B;
	Wed, 25 Mar 2026 18:08:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 25 Mar 2026 18:08:57 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56370)
	id CFE3CE0729; Wed, 25 Mar 2026 19:08:57 +0100 (CET)
From: Joshua Daley <jdaley@linux.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        jdaley@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v4 2/2] scsi: virtio_scsi: kick event_list unconditionally
Date: Wed, 25 Mar 2026 19:08:57 +0100
Message-ID: <20260325180857.3675854-3-jdaley@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: rQmsXwBnlcELviMN4oh3p2fzunCy43JK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDEyOSBTYWx0ZWRfX7jqxZdKbw9so
 ZnSyAiDL6Z9H3PbMaGvLXInzIsg1HE/BHHaHVXIfdRwLg4if32T9N0P7BlILq8c1rwUwUXVVPvy
 zCruP25KlK+8w4LxCS9UqyAReGSQ1L/tWVcZCG6hGG5HXuqwoAxwDLDdXCDO19Wie/ji+nPcJYv
 iR5GrcHfqLvI2eTImBkKtNdTDMpdtcNg70IYrPfmlSCA/pCTBVxK5lzSaXYX6kmbJf/ku26vfgN
 0nc/OKfTVcD6XS3wNPX2reQGtEcn/LprL+Ko9LmECX04vTQb8PCaP+LedFAW7vzOxD5b1scSHTs
 A8mqqNtpkUyHSDxTYNFZ8taHUXNgZlpD+vosrCTfiT9TTfV9bS6jbEhOlB0V+pFfrbDsuO/pTEZ
 Wcs0aRx+mpCioEfUEFNBqTsGoEB0R4+iauyugSEV7+Ul9Ai8UbY4P5kywZrrNOEwFbBWmLaq0Xp
 oswUqeEvecNQ/OxbGTQ==
X-Authority-Analysis: v=2.4 cv=bLEb4f+Z c=1 sm=1 tr=0 ts=69c424bf cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=fOgkfDuy17jzwl4HYOQA:9
X-Proofpoint-GUID: rQmsXwBnlcELviMN4oh3p2fzunCy43JK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_05,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603250129

The event_list processes non-hotplug events (such as LUN capacity
changes), so remove the conditions that guard the initial kicks in
_probe() and _restore(), as well as the work cancellation in _remove().

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
---
 drivers/scsi/virtio_scsi.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 64b6c942f572..5fdaa71f0652 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -982,11 +982,10 @@ static int virtscsi_probe(struct virtio_device *vde=
v)
=20
 	virtio_device_ready(vdev);
=20
-	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) {
-		for (int i =3D 0; i < VIRTIO_SCSI_EVENT_LEN; i++)
-			INIT_WORK(&vscsi->event_list[i].work, virtscsi_handle_event);
-		virtscsi_kick_event_all(vscsi);
-	}
+	for (int i =3D 0; i < VIRTIO_SCSI_EVENT_LEN; i++)
+		INIT_WORK(&vscsi->event_list[i].work, virtscsi_handle_event);
+
+	virtscsi_kick_event_all(vscsi);
=20
 	scsi_scan_host(shost);
 	return 0;
@@ -1003,8 +1002,7 @@ static void virtscsi_remove(struct virtio_device *v=
dev)
 	struct Scsi_Host *shost =3D virtio_scsi_host(vdev);
 	struct virtio_scsi *vscsi =3D shost_priv(shost);
=20
-	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
-		virtscsi_cancel_event_work(vscsi);
+	virtscsi_cancel_event_work(vscsi);
=20
 	scsi_remove_host(shost);
 	virtscsi_remove_vqs(vdev);
@@ -1030,8 +1028,7 @@ static int virtscsi_restore(struct virtio_device *v=
dev)
=20
 	virtio_device_ready(vdev);
=20
-	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
-		virtscsi_kick_event_all(vscsi);
+	virtscsi_kick_event_all(vscsi);
=20
 	return err;
 }
--=20
2.34.1

