Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9B53A5427;
	Thu, 12 Mar 2026 17:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773337389; cv=none; b=Xf9CVa9QS7MGpSl0Gfe/gjnbapyvMpeCeBMdCtPs5dfiYQCdB3FAqhAgFK+gJ127bIGSZEe+SbPPhotP2f+l7Tk3pRODqlLsRmJZWkIlxcYzCSJ0gTsC9WCzdN821DFn/3OI/8j/efj4IVNaOFs/ag7b0sIho8FWl83mTKIFR2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773337389; c=relaxed/simple;
	bh=QJkYOr1cfybF5EYNJZEH/LzMfpNz7HR2eQgVbuSZJCA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=suiKSQIWlEAbEPq1glmCpPMKUuO1Ouwmt86XtHVFBJXfjuaTgtY0KwolMbNOQa5n0JR1cGvQARwEF9hbpYVcxq/4eu/z1FQQLl2qprBHErQ6NKuXQBA9R1xYTp0Nygi2cDjoYKNbrsh4ugHd8PBVQp3VWGM+o3Jax6+ZOYuy5m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gx1Qwn/T; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gx1Qwn/T"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62CEmNQ32279397;
	Thu, 12 Mar 2026 17:43:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=ZjWGqEdyicZGNnfr4p1/dwSs1y1szPTKIKJQ2+bbt
	vM=; b=gx1Qwn/TKdG12ra4cvL75d85Iy9YFsH0sxKNAyUHmfmO4DloU5cXd1BI7
	cvsSIn97sKNMKnUAIfGhTo9Bc17WbDGIudw1fibKPNrrKlTItVKs4G37TGATcDqx
	V9dMVaLAuwROsK6usAAT8GpBlbOB0j6XeAjMGl8ooV4QeqrnQ0WoybgRz2foNNwQ
	AkSrWGzdK5v5QqL1BFMCqoSUczgyRJK/c1zxY/ZhdatMMc1yZZL1cxqAIA6slI1+
	zjlV5k0O4x1lYKS+3P76K8xyP6hNWtVqJuqC9lKyTEuL5gGfkJ5VUJpLlomd/fB/
	/93X7hvtNA+qUPa0dWlOYhheyoSww==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh91m2y2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 17:43:02 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62CESg4s014631;
	Thu, 12 Mar 2026 17:43:01 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha8bd5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 17:43:01 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CHgvq860162358
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 17:42:57 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13E792006A;
	Thu, 12 Mar 2026 17:42:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD6BF20063;
	Thu, 12 Mar 2026 17:42:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 12 Mar 2026 17:42:56 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56370)
	id C63F9E033C; Thu, 12 Mar 2026 18:42:56 +0100 (CET)
From: Joshua Daley <jdaley@linux.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        jdaley@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v2 0/3] scsi: virtio_scsi: move INIT_WORK calls to virtscsi_init
Date: Thu, 12 Mar 2026 18:42:53 +0100
Message-ID: <20260312174256.1557045-1-jdaley@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V2lfBuRxhH8Su_6MpVKgPX8NXKiEOhtp
X-Authority-Analysis: v=2.4 cv=E6/AZKdl c=1 sm=1 tr=0 ts=69b2fb26 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=CFRfbv1PXe9UI1TNNxIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDE0MSBTYWx0ZWRfX8RyZeTvNFY2n
 u7LrnmtYK5dFcj3vIZrbd7e7tptBic2m7hcb4WkO4b90Zhlb3VSZctAQSEzOb5d/F4sPMeIHlSJ
 q5UR20WdLfwsSAhSu5IFNXjtXxk8TiLsbTbs3gYAaLfpxt4/3ebMbTKzgc0Jmc4LnOkRvrAjpxb
 wgqJv6GsOJWYVFqdaTOwW24FKTSYSXTs+tY8ZVa0sa+/RmMTK3fEiv+JIog2vsAm7+7Sbf/rcMn
 IZpJD9RMskqxY1QJM7v49seSFESaeHGQ/z1zdsRh9qL648dC5+kSKI4qom10W3s5B38hjjZPACM
 daoHd8w8x6GaDpnM6Pa8k+XEnnwhupgqMMkduNGmp0A4XIK6vInlm3mU73z0p8frDmkC7G23xRx
 q4+yNc1pzV8MMmMW4isDJck2ppKhSmULKVSYKt0nls7hvFuBdJgRWBKpM1zdc1QpjP0BPmPBatp
 lnak9yynmH0vjobz37A==
X-Proofpoint-ORIG-GUID: V2lfBuRxhH8Su_6MpVKgPX8NXKiEOhtp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_02,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120141

Changelog v1 -> v2:

- Added 2 additional patches:
  - [PATCH v2 1/3] scsi: virtio_scsi: kick event_list unconditionally
    - Removes the conditions surrounding event_list operations (suggested=
 by Stefan Hajnoczi <stefanha@redhat.com>)
  - [PATCH v2 2/3] scsi: virtio_scsi: remove unnecessary fn declaration
    - Removes virtscsi_handle_event() prototype (suggested by Eric Farman=
 <farman@linux.ibm.com>)

- [PATCH 1/1] -> [PATCH v2 3/3] scsi: virtio_scsi: move INIT_WORK calls t=
o virtscsi_init
  - Removed the condition surrounding INIT_WORK calls

-----

v1 cover letter:

This patch avoids a kernel warning that may occur if a virtio_scsi
controller is detached immediately following a disk detach. See the
commit message for details. The following are instructions to
produce the warning (without the proposed patch).

Timing matters--if all event work items call INIT_WORK before they are
flushed by cancel_work_sync, then the warning will not occur.

The warning will occur consistently if a sleep is added in
virtscsi_kick_event before the INIT_WORK call, like so:

#include <linux/delay.h>

static int virtscsi_kick_event(struct virtio_scsi *vscsi,
			       struct virtio_scsi_event_node *event_node)
{
    int err;
    struct scatterlist sg;
    unsigned long flags;

 -> msleep(1000);
    INIT_WORK(&event_node->work, virtscsi_handle_event);
=09
    ...
}

Then, just detach a disk and its controller in quick succession:

virsh detach-device --domain <domain> disk.xml; \
virsh detach-device --domain <domain> controller.xml

where disk.xml and controller.xml are text files containing the XML
of the disk and controller.

Or, with the libvirt python module:

domain.detachDevice(str(disk_xml))
domain.detachDevice(str(controller_xml))

Joshua Daley (3):
  scsi: virtio_scsi: kick event_list unconditionally
  scsi: virtio_scsi: remove unnecessary fn declaration
  scsi: virtio_scsi: move INIT_WORK calls to virtscsi_init

 drivers/scsi/virtio_scsi.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--=20
2.34.1

