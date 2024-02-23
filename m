Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525FF168CD
	for <linux-scsi@vger.kernel.org>; Fri, 23 Feb 2024 07:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708674364; cv=none; b=VaYUpRmf4MYxO3ae3jP9yI8Is0U83XR6SkSq9zUoRypfyh+oSpoUBB8O9/v+T4ojcXOFylC+SCDQTKcKDgw8dYzHK4zvqzW9DePkHpded5HbmPrTuz42GUZixWEmb8xzOcaq/QDkEfdgl9loGk8eblDuqpvRnHww0CmmbEyYbpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708674364; c=relaxed/simple;
	bh=dIB6C+R3qYe9MBzS6bKi83TfYEoNZ5ee4WnNVwVAj4s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JZvCFxFw3acA8I6LFqVErhgH1ymsrSA5eLSAZhk0r2ojdiwrS25PmmZYcUipGzd7kUAmp1EP02P1Q4P848ADjGzem31IvOCw3ri5hVAECVKdBFccD9Zx741TfqI8NRrbUyyEW2RVZOqvPz9G8UI7mJK16uZFXO28wx9mUN+XK7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=AnpTtG7n; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="AnpTtG7n"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41ML8vmE003174;
	Thu, 22 Feb 2024 23:46:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=LW7nALvjwQmw1/drcUF6qnm1eTVVwc1/b2lfrHeEjL8=; b=Anp
	TtG7negwxfHtOM2YCpyROXUT8fTLCqAEx1EGd7pwDu3idlbtKiMEfvbNYHanZG1J
	Z2wP2rT479qgTgRyGNJEDCRKPUcEKtUiTRMa/GhwmKT8xook0wHF3PeA0g+D/dZc
	4LF/IHlWsq6r4STHVm6w+EtsrgBBjwHCJStwYgMj0krQ5js6PPjxymQlFcWkoNAO
	6xNsg17dbjI3auJ9+FXk0GMktC/h2KRw1tJsr0Z3w3aVuFN8vljRxWzxkdw/8215
	GLeImVXhxkcsHxiezVUPnTrb0q9oIQQSgUwyEYpBNsnAUjctDVRVSgytTQ644Zh4
	dOebjc2Y9y14nhaxeew==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3wedwxht4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 23:46:00 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Thu, 22 Feb 2024 23:45:59 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Thu, 22 Feb
 2024 23:45:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 22 Feb 2024 23:45:58 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 5024A3F714C;
	Thu, 22 Feb 2024 23:45:56 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 11/11] qla2xxx: Update version to 10.02.09.200-k
Date: Fri, 23 Feb 2024 13:15:14 +0530
Message-ID: <20240223074514.8472-12-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240223074514.8472-1-njavali@marvell.com>
References: <20240223074514.8472-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 2ybHV0wOQzBU80_SAdjobpJEsajSNGxE
X-Proofpoint-ORIG-GUID: 2ybHV0wOQzBU80_SAdjobpJEsajSNGxE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_15,2024-02-22_01,2023-05-22_02

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index d903563e969e..7627fd807bc3 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.09.100-k"
+#define QLA2XXX_VERSION      "10.02.09.200-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	9
-#define QLA_DRIVER_BETA_VER	100
+#define QLA_DRIVER_BETA_VER	200
-- 
2.23.1

