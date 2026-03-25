Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8187C7263B;
	Wed, 25 Mar 2026 18:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774462155; cv=none; b=JbCs6r8XpBCFPkpsr+uS7EDof7jO5cQcR9lwGI5DlZ5Cv/Zc5n7OHFdoo0u7pMm7kxPVIM6KPdcQTkt0uOQJUUeAro6sQSXfgcbxfekgzu/Py384l7oe4MmL9vV5HNwUlxGNpx/bc8NfC9ybjfPzLhDLXs9wMA1ZV5H/hkuPPq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774462155; c=relaxed/simple;
	bh=YOLTyhMdaqgptdgS7Xr6cneJmP7tltwCYxGztnMm5AA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZRQoccMMJdBC3myRJYG4ZKEj/xXeg3+pgZul6NS98s52G/ziQQ1OoKXKNdxijMWuG9K2ULGLZQa4ql57psZgS4gagBRgblzSx0W6uYZXy1zTkcNFtmWgbMXE92L11MFUfjTmUavI3GGBTHf2s6mRYDkkEMknZ7lCqRN4fOEDmYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gzJSw5AX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gzJSw5AX"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PFo9SE3011996;
	Wed, 25 Mar 2026 18:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=vIrf9M33ixy5kPT8YVVUFWKNQS7KjLsBRP/hLnG+D
	sw=; b=gzJSw5AXAjggkNAfMvEt9UB2YkqI9dkN0Im6J9f9cvKluYHA8CLT4uZKS
	7WUItO2XxNx2tskpXGXEQbRhVTN5mfnGTB2azQUOre1pk3WKRhxqVll/HMADIIuP
	mcCv5016/dXTvjESxqpU2IhDpgwClgpOvD4fThO6sa56yw3uHTEyCeHktzRMbrSj
	cvryNuFVTHV7cEKDHv8yp61SMlBsrpvS/k0kZ/OqEs4WVu1OV6nFw29PPkRGv63K
	vuA/ztw8TIE6G1I0VSXAfVtyvrRGnN56gqbfc7JFTlLtb+f3fXN3p37Gbi2tjNh5
	QcDB90YlX22YGPUfQIseTU5fILj3A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kxqhu96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 18:09:02 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62PF7FUK031583;
	Wed, 25 Mar 2026 18:09:02 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d25nsytxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 18:09:01 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62PI8wcP43581858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Mar 2026 18:08:58 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 318E12004B;
	Wed, 25 Mar 2026 18:08:58 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB9EB20040;
	Wed, 25 Mar 2026 18:08:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 25 Mar 2026 18:08:57 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56370)
	id CB11EE0471; Wed, 25 Mar 2026 19:08:57 +0100 (CET)
From: Joshua Daley <jdaley@linux.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        jdaley@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v4 0/2] scsi: virtio_scsi: move INIT_WORK calls to virtscsi_probe
Date: Wed, 25 Mar 2026 19:08:55 +0100
Message-ID: <20260325180857.3675854-1-jdaley@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZFOYTNYnzsMF1Bte4xdU-j-NUH4GLscx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDEyOSBTYWx0ZWRfX0rwb2plh2AYO
 p2jmjtgLkU7cd6n05uCw2CEUfGSfgQeM75INRNP7sLTG7bgg94yQYr6eBXWCo2lWCX+7O0vsm+8
 Lp+anWusLV6g8ekYALecPKrZ3gxZnpLctaEo6HnnLgKiWPpQueYvFF+6CRESILU62dO6i4sz0+R
 YujJRpGuslyYwE27lXFgTdbEYrNGrzANYh3qzbqi2IOxFR46nVmIbho6eihoSlV7mXScvvBDCr6
 uZ2gi/zQ2UutdadxwsNhItu/8d6ciQNv7CrlHTXKw6U4TbouRY202tw0MkVbNUVkKY+jcBhQ4fP
 9c37GFohyVAq2rZLr60wO39rgdCmrYalHGL5EW/cUUmH9M6L/hkgSf5UT6DPL2Mxo7m0jNZ8CIZ
 FGbDZiSb0p2BobHpw79mzK6zfIEN59iJB/pkMtkOUNzxJilb4PfqLBz0cmSwI26T0BzWk/O3Rhj
 6+D/CP3/n6Tq+vvQ6vw==
X-Authority-Analysis: v=2.4 cv=bLEb4f+Z c=1 sm=1 tr=0 ts=69c424be cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8
 a=LNY0ek4hQKP4GrC02joA:9 a=lqcHg5cX4UMA:10
X-Proofpoint-GUID: ZFOYTNYnzsMF1Bte4xdU-j-NUH4GLscx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_05,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603250129

TITLE CHANGED! Original series title:
"scsi: virtio_scsi: move INIT_WORK calls to virtscsi_init"
Previous version:
https://lore.kernel.org/linux-scsi/4a93583c-47a1-4700-a7bb-da75fbd231dc@l=
inux.ibm.com/T/#t

Changelog v3 -> v4:

[PATCH v3 1/3] scsi: virtio_scsi: kick event_list unconditionally
-> [PATCH v4 2/2] scsi: virtio_scsi: kick event_list unconditionally
    - this patch now comes after moving the INIT_WORK calls, to address b=
isection concerns:
      https://lore.kernel.org/linux-scsi/4a93583c-47a1-4700-a7bb-da75fbd2=
31dc@linux.ibm.com/
    - the code changes are a bit different given that the INIT_WORK calls=
 are now moved into
      virtscsi_probe(), but the concept is the same.

[PATCH v3 2/3] scsi: virtio_scsi: move INIT_WORK calls to virtscsi_init
-> [PATCH v4 1/2] scsi: virtio_scsi: move INIT_WORK calls to virtscsi_pro=
be
   - the INIT_WORK calls are now moved to virtscsi_probe() to address con=
cerns
     with suspend/resume. The title of the series is changed to reflect t=
his.

[PATCH v3 3/3] scsi: virtio_scsi: remove unnecessary fn declaration
- squashed into [PATCH v4 1/2]

-----

v3 cover letter:

Changelog v2 -> v3:

- switched the order of patches 2 & 3 to fix compilation error.
- added reviewed-by tags.

-----

v2 cover letter:

Changelog v1 -> v2:

- Added 2 additional patches:
  - [PATCH v2 1/3] scsi: virtio_scsi: kick event_list unconditionally
    - Removes the conditions surrounding event_list operations (suggested=
 by Stefan Hajnoczi [<stefanha@redhat.com>](mailto:stefanha@redhat.com))
  - [PATCH v2 2/3] scsi: virtio_scsi: remove unnecessary fn declaration
    - Removes virtscsi_handle_event() prototype (suggested by Eric Farman=
 [<farman@linux.ibm.com>](mailto:farman@linux.ibm.com))

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

Joshua Daley (2):
  scsi: virtio_scsi: move INIT_WORK calls to virtscsi_probe
  scsi: virtio_scsi: kick event_list unconditionally

 drivers/scsi/virtio_scsi.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--=20
2.34.1

