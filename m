Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60243FE37A;
	Thu, 12 Mar 2026 17:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773337390; cv=none; b=oA7YSeKSUpBhvOprTShojCeklnwXVH8JLjpiMU8syuzjkK1D3Vo16ZZMi0/G7K4C1zyrG3JAWQqhsZDR03WeBzOoOPkPamcz++P1cQMXcAaa9jmEhABwTtExHTwZZYH3hNx5AUqgzh7qDdsmLtjD2WBk0zR9s6gJRj2onS8o/iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773337390; c=relaxed/simple;
	bh=cQpRzyP7bOHomQ5KjgVTuBu3n+2i+LcUgTPd1n+Pk8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RH7pxJhd/bqvAKdZNEFIa1Rp5A1HTCCuLe08DBbKCVSuvzffq9CFqzW2xL2+gls82op53P2DZwSNOsyGPa+bRebdfCqSX04HyJ/QMrtcRPPT1EU4yNYJWiHgMvPeIXppD6M/laqD1156S4S9vMihBUajRAtodB53YoPv2KqouP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EtAKtr6C; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EtAKtr6C"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62CE4dFf2277871;
	Thu, 12 Mar 2026 17:43:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/0vLc6q/LATwN62xa
	8S6UogsUfCoBr/42ZN+uaUWM08=; b=EtAKtr6C8xSo452FU/MjOwW0DcJD84ZLt
	VvFdzco7MuVYT+aM53TaUE+bwSQgv5ew0VNSfLJdQmpbTjI1pTeBvx+jBv65f7T5
	s3AGgm3AOr0/k5nsLMA6Yt8dt+nPyH/l5h9+OruHIFJScfcJ/CdY5ihayNU95ows
	NJZM5VfwkuB8u3nJLxlHfTHJV7RvxjenKBj0cMsHZXHJKXKsMFykQypsZtfmIlL6
	u2fsPmN/TOoZw4a5EuhXLB7Xmq5uUOLE6K75jAWgUNMygcZr3Ty5mgjGHaV+NNgi
	8voAmEItnRE4a/2duyHTNadeFdR/1ZclUk9GX67erf/pKu2F3ziXw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh91m2y1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 17:43:02 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62CEQQPT014667;
	Thu, 12 Mar 2026 17:43:01 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha8bd5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 17:43:01 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CHgvCC44630366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 17:42:57 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2975E20063;
	Thu, 12 Mar 2026 17:42:57 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3CCF2004F;
	Thu, 12 Mar 2026 17:42:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 12 Mar 2026 17:42:56 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56370)
	id C7B6AE02A3; Thu, 12 Mar 2026 18:42:56 +0100 (CET)
From: Joshua Daley <jdaley@linux.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        jdaley@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v2 1/3] scsi: virtio_scsi: kick event_list unconditionally
Date: Thu, 12 Mar 2026 18:42:54 +0100
Message-ID: <20260312174256.1557045-2-jdaley@linux.ibm.com>
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
X-Proofpoint-GUID: vnTWpdV3tDX2TUJGsogrJNYxyCwCIux7
X-Authority-Analysis: v=2.4 cv=E6/AZKdl c=1 sm=1 tr=0 ts=69b2fb26 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=fOgkfDuy17jzwl4HYOQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDE0MSBTYWx0ZWRfX5PRkPhAiUyJ6
 1u5hBB34YniR5WKQoNAJE701yh54neWMUtO36lbvB8cQrPKUBYIte2bCvqfF6n7pbrq5A0yVWLK
 Qi4SdGh5qY67DWRwnz+JyunQO+zQY8I82b7vY0t1wtKgYmOyQl1+PpxNRjflUDgrhlzTVYuz6X7
 W7b2hLFuyejv8Te50jtgIAzWlzD1TX1X1x941V9RIfLPFiy3NTbDZfVFhIkrmlitkgaOAoCPXba
 DyEeDJ4LkPIWrQCJO3c72rXHbfjFSPeuLiZRcIAKpiT0+mkWj+qoa9hiLh045KhVsxpIc9ZQQI8
 t+XbDGEm8nnaoDTDCMj79OWVGKklwo44MxA1MtvbvkebO5UnKRjSQEQWSBb8lveYx4V8hiSJPCH
 ue/Hu9j8qKdFGKg2zYnwvFFscfNPkmZadyR+YQn0lEYQvdUX2anQnfFvGGnmxUuWvdN2KQjZIAA
 zzw900nFMhXaAwlp7zQ==
X-Proofpoint-ORIG-GUID: vnTWpdV3tDX2TUJGsogrJNYxyCwCIux7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_02,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120141

The event_list processes non-hotplug events (such as LUN capacity
changes), so remove the conditions that guard the initial kicks in
_probe() and _restore(), as well as the work cancellation in _remove().

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
---
 drivers/scsi/virtio_scsi.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 0ed8558dad72..982f49bc6c69 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -983,9 +983,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 		goto scsi_add_host_failed;
=20
 	virtio_device_ready(vdev);
-
-	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
-		virtscsi_kick_event_all(vscsi);
+	virtscsi_kick_event_all(vscsi);
=20
 	scsi_scan_host(shost);
 	return 0;
@@ -1002,8 +1000,7 @@ static void virtscsi_remove(struct virtio_device *v=
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
@@ -1028,9 +1025,7 @@ static int virtscsi_restore(struct virtio_device *v=
dev)
 		return err;
=20
 	virtio_device_ready(vdev);
-
-	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
-		virtscsi_kick_event_all(vscsi);
+	virtscsi_kick_event_all(vscsi);
=20
 	return err;
 }
--=20
2.34.1

