Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CF7134D1
	for <linux-scsi@vger.kernel.org>; Fri, 23 Feb 2024 07:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708674333; cv=none; b=HVyQAkg2Ankir3pt4ro8saLZ1AdTI+e41GBLrRQhkAJX9I3B2hHviJDEmch550fFORMiSpecLev6nPUH1jrHanv4BkEUInqIDUPjEnOxtBZSxoGMhWfT2oSE/2dDL3gUxM/HRmW/NAb6SRFBAKz1xtaY8vNEEtVX7M2FBr34SXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708674333; c=relaxed/simple;
	bh=Hefd3OZG/mB7XJ3V1w6c5xdyBvsv6saAcM/R4Fmw0u0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GImrRVCJYdSvfID6GLdFFcOEjx9oZtzXJbcg2n+LemAxuylCcZVfqUYF0KbL8ANuE4SWq1NJaSVio+leOHXhWJKe1NUxuBqivSEhyLAvPlDzOjiAz+l6NGjeiNHDU9Wkk4XuQRNRpIdn+Ggw1g3NRn2Ie4iuDWZYOpPy1yZ10j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=fBsN7PkJ; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fBsN7PkJ"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41ML8YSg001863;
	Thu, 22 Feb 2024 23:45:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=pfpt0220; bh=xqnUvseV
	UXuhv759wyhOLIr4ZU5BUUv6uB08Y7/rWGI=; b=fBsN7PkJCTCbKPjzd+lVVUaF
	vNtaXuOhYndl0LCHe3Yh9NyxyMlcVK3fjYV5XHxnmjNGd4MaUagxSo/14iu5YCIh
	/Rl4uBdUkfoUsB5tim2oiqefb1ZG69z2HbyZODIq1HgleGwBa/gwToQtricJcaLw
	wXuyt6wgS4Ud/bQ1FViLr+RfTYv6jtgFLtVIAdbAUdl0qaThoIrJN+07poic+Wer
	14nkFUY6pk0ptZbitzqKpPMdNObMuCfdKUgu09xfleq0GBevtuIoWX5I+714Lu5z
	/EybY2cVldr0AjCAhdpmhqQz2oSDf1BcVh+CcL6QMQDgveXzioWZ60h8C0wM+w==
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3wedwxht1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 23:45:27 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Thu, 22 Feb 2024 23:45:26 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Thu, 22 Feb
 2024 23:45:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 22 Feb 2024 23:45:25 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 36D493F714A;
	Thu, 22 Feb 2024 23:45:22 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 00/11] qla2xxx misc. bug fixes
Date: Fri, 23 Feb 2024 13:15:03 +0530
Message-ID: <20240223074514.8472-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 1zadvqvn69ZvjyZJ4dyGjs-El2UIUiZ9
X-Proofpoint-ORIG-GUID: 1zadvqvn69ZvjyZJ4dyGjs-El2UIUiZ9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_15,2024-02-22_01,2023-05-22_02

Martin,

Please apply the qla2xxx driver miscellaneous bug fixes
to the scsi tree at your earliest convenience.

Thanks,
Nilesh

Bikash Hazarika (1):
  qla2xxx: Update manufacturer detail

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.09.200-k

Quinn Tran (6):
  qla2xxx: Prevent command send on chip reset
  qla2xxx: Fix N2N stuck connection
  qla2xxx: Split FCE|EFT trace control
  qla2xxx: NVME|FCP prefer flag not being honored
  qla2xxx: Fix command flush on cable pull
  qla2xxx: Delay IO Abort on PCI error

Saurav Kashyap (3):
  qla2xxx: Fix double free of the ha->vp_map pointer.
  qla2xxx: Fix double free of fcport
  qla2xxx: change debug message during driver unload

 drivers/scsi/qla2xxx/qla_attr.c    |  14 +++-
 drivers/scsi/qla2xxx/qla_def.h     |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   2 +-
 drivers/scsi/qla2xxx/qla_init.c    | 126 +++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_iocb.c    |  68 ++++++++++------
 drivers/scsi/qla2xxx/qla_mbx.c     |   2 +-
 drivers/scsi/qla2xxx/qla_os.c      |   3 +-
 drivers/scsi/qla2xxx/qla_target.c  |  10 +++
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 9 files changed, 138 insertions(+), 93 deletions(-)


base-commit: f4469f3858352ad1197434557150b1f7086762a0
-- 
2.23.1

