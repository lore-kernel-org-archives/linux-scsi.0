Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6856844CAE2;
	Thu, 26 Feb 2026 20:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772138642; cv=none; b=GSNUCinjCFDmEC79G/nRydDQPVbbGBIDn6rQGPiC0t/FOHHioziCfdyEg2oPsUdyfK03L8jOX9QkJwq8fSIFL9LinaTqdc4L3H5DrhOvkbw+Ur915SCapHLpNFcFVQQ8a3oKxvIQ12LDQCg4ojRd5mx2PiI+QyIc8GkFeq1Wl8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772138642; c=relaxed/simple;
	bh=Y7JfbH+ztCrlYdAyB618i6lDAzmJpIuBqLu1FWi92u8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JLevgeglYqaEv+WSiO1LYuUDGiuSkjSVqE0f6suo7lRxwcl8SvzCekc2ayB4QfcJlBrKkakwMqFs1h38pbLIQWrdtaxaDMxZMFom0xiEx8PrrgG/aendAvRF3ouxhuRWdd99gYmiVWiTBCvrElurVgu2FXUuQ3RPf0HZpCoxyz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QNJfoq2B; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QNJfoq2B"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QExECj2347002;
	Thu, 26 Feb 2026 20:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=L/pl8e0Ab6W8Nh9zOWFA+VaDN8oP4VGd2DbfLEsY3
	/s=; b=QNJfoq2BAPC/xpNGoIYyeu8rkfeof2kXkOZnmJg7nILqdRvcMZZnshNUg
	uuNxrrjzdZr0P4iAVpwcEWoWc5ARb7sBjnh5U5/K1vA2k8Viy34UykjpyhwVsTAm
	k/qG0lGr90enqkiywk9+qTaRyAehMV2TefcwpXdtmfNkygtBMMfQxkkVJX+xTGin
	lAVt5F1KIHikxjp6NN6FddnFk9IwXqM2FymSJ732ZE3UlJh0UVXtvYC6KtIROp1Y
	blerymq9DLl59dJEp0ccv504O3A/Z1b+YSpLdtFgc1H59S6ltlm1xWVeg1cxveCe
	rTgGRQHwe5x1WC/SnG20NDUUHrOpg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ch858xd77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 20:43:51 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61QIYgsm030414;
	Thu, 26 Feb 2026 20:43:50 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfrhknxrd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 20:43:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61QKhjiJ30146976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 20:43:46 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E14E02004B;
	Thu, 26 Feb 2026 20:43:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5E3720040;
	Thu, 26 Feb 2026 20:43:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 26 Feb 2026 20:43:45 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56370)
	id 9E837E0BEB; Thu, 26 Feb 2026 21:43:45 +0100 (CET)
From: Joshua Daley <jdaley@linux.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        jdaley@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH 0/1] scsi: virtio_scsi: move INIT_WORK calls to virtscsi_init
Date: Thu, 26 Feb 2026 21:43:44 +0100
Message-ID: <20260226204345.1904786-1-jdaley@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDE4NCBTYWx0ZWRfXxrzJtN95SkO9
 vz7GgFHlWCYYYwOeV82TDDxVCv6gt29NyBeZF/DlPb7Ouu1HIBJ9x6rsc/Smi5Czhbow1HxZD6w
 hCZ/aXUKY3zNXLqxuB04WBibSun8FR5ALzDigpFxN9gqNSvFuqsPhX4tEbUUZdjBV735/uSZn0F
 WimnVmKSkIfU+OPowxX1+JHDwm+Tq86H3wIr3L3sNUidMMjq3BY7yFfCoy8Pw/6B6SeOIwlHzlQ
 KZd1UVrYnOcIMPag9mQtTm7XHXmCuSPi7zpkpS8ew81jPq+z/Ay2IHs9z7R5eSi83B5MqMvAciX
 pjbzlvHyo6DGFfao2VPvRdX9yAz1vZrO4QFEkULyqdUirXDZXVXf+E1IoirrRhuWO2/xRVZLYW2
 a5v53ybkP6I3bwT2ZYF7pfaw5NYpMnEPM1gL+pJ9XaZZEOIGfm0sbOJDbIO9FaF42i6BbyjFkLr
 dwNHXoX7y3vGPVnfcMw==
X-Proofpoint-GUID: ThtvA5rGUu0M2tlVNBEYvJ9GZb2jLnuZ
X-Authority-Analysis: v=2.4 cv=S4HUAYsP c=1 sm=1 tr=0 ts=69a0b087 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=QsrBqZypJrsHG3eT-GAA:9
X-Proofpoint-ORIG-GUID: ThtvA5rGUu0M2tlVNBEYvJ9GZb2jLnuZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-26_02,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602260184

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

Joshua Daley (1):
  scsi: virtio_scsi: move INIT_WORK calls to virtscsi_init

 drivers/scsi/virtio_scsi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--=20
2.34.1

