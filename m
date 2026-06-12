Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D89303A04
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258196; cv=none; b=f9wPUyt4Dm6A0DuQQJaXtvomsNtxdoaPCYCbcTplQaa+Yx19bo4Z4sGh1sNFnOGbXQ/c8HD1WIQu24KLym/NHxXAFjvWwOEnnChI7q6HFcMQ0LHlfvHwa1V8JMadk6jWISflobNUOE11lGIDhc1zIrpoGuMrFFMWfYPOYoyVrzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258196; c=relaxed/simple;
	bh=IcrTIsjVT+559NRowOQsYCNbz1Ywq+cm0sJrRVvX0fU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sdya7juJyWL4xSx1egYIrEaAL2osSD3Cuds7OLwNt+FCFZBC7sl55GUSvK98HU7kCPDLC6QmN1FRBNUvYVfrZoHMJR1f/5rLe8j80Z2lPVm+d+0L8T+Fmzkv5QIuGpLOsAK7QHRdkigQfS08vPMUuFxybiBLJw7o1W8E70kwCNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=JbNqhtb3; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="JbNqhtb3"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C3AtnN071606;
	Fri, 12 Jun 2026 02:56:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=Q
	ahW+vYDIanK7iwmkdVovEAw20aW4wf6zrASOuP938E=; b=JbNqhtb3gQ/wyU++A
	NvKaxDKUReFoH8cLztqZivcSbaveKpYRACqGTcPK9TK0kxKpWCL7cdYQ0fvP9tJP
	h+QyhvYUnaw6g3nECXcEvRJHAEZYfpE87zOb1nAZsfBcWmafh81+WwVSLtsdnDUx
	AGxfgRgR18Vk48hjTYUPWS81KOM6yWDKXOrGxwSF/A1jy8B85NCiK1YwGHdnC9x9
	l5VC6fztUc4A7FzYIlY4VRXS7Q4uJlZSXxfRi+RLklRGoNJrxQgyqEjzQ/URyAah
	p0MNfGiZ/X48tf5Bx9rrKWcLZzlfj5cDYoBcDzbVUIe/Vvs5KevcXQczzQNElTJp
	aIa1Q==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5vxrr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:31 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:30 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id CC6AD3F7040;
	Fri, 12 Jun 2026 02:56:27 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 49/60] scsi: qla2xxx: Add 64G/128G port speed setting support
Date: Fri, 12 Jun 2026 15:23:22 +0530
Message-ID: <20260612095333.1666592-50-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX2MXGgUl++6kV
 cwqe/Gyrk/vfCh4Ng9/ctlLitw9ySmLjISu2R58k8VSnUEXQe84gAdCxz2kChbNtWesNxA6VUwf
 ly4D/BKSboexR9IK6QgW+JpFnr8En7Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX0loJ77wuWysC
 HcpnSa8He5Vw+P0DDVtVlwMXk2AWdxMa2RkbLM1g6zntMHIH92f9r8ZRS8DQDYSmw7jNF85CPE4
 9kW5LoszhxIx7eBLd5nBmotgHQ/PYRWyAMEKAH0Zut3aY/a67/MNTC+5g9E3SfG7G6StfO8wFJl
 XbRnFsNYmixfEf8/QMnvutU/P7fRCPQbyj3yG1cIG8PDFV7ayKXWLl84sQXmErfXXjKoCpaS0u/
 6TZcqKuml7BhldpFCdV7Zm5bliGWkIwAJox63xJtO2+2vyCZv46dhKi4SJvsqZEnQKqXCSlB5+e
 H889ds5qGnhCjbRq9IHQXr92CgbY0rH2Es1QUdA96aeGtZmzX+r2C8hIcy87WyPEnw6pp22KUc4
 zUQStoLI/MJZvJOigaQVovq8d1QpHhWQD3/hpK/2SUrxDPy7+dY/GewPoWMbCkRDZsz0Ufchb2T
 S00jtkGm4IZ+fQvFFdw==
X-Authority-Analysis: v=2.4 cv=UPDt2ify c=1 sm=1 tr=0 ts=6a2bd7cf cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=7PhB5BXe-91c5wGr4VEA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: LbNmSkmSYSu0sNojwlBaZ0lcCZenMVnL
X-Proofpoint-GUID: LbNmSkmSYSu0sNojwlBaZ0lcCZenMVnL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

The port speed setting paths topped out at 32G: qla2x00_port_speed_store()
only mapped sysfs inputs up to 32 (and their no-loss-of-sync forms up to
320), and qla2x00_set_data_rate() only accepted PORT_SPEED_AUTO/4/8/16/32
in its switch.  A user request for 64G or 128G therefore hit the default
arm and was silently downgraded to auto-negotiation.

Map the 64 and 128 sysfs inputs (and their /10 no-loss-of-sync forms 640
and 1280) to PORT_SPEED_64GB and PORT_SPEED_128GB, and accept those
values in qla2x00_set_data_rate().  The firmware validates the requested
rate against the adapter's actual capability.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 8 +++++++-
 drivers/scsi/qla2xxx/qla_mbx.c  | 2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 308b85e04f26..4c1812c4b420 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1835,7 +1835,7 @@ qla2x00_port_speed_store(struct device *dev, struct device_attribute *attr,
 		return rval;
 	speed = type;
 	if (type == 40 || type == 80 || type == 160 ||
-	    type == 320) {
+	    type == 320 || type == 640 || type == 1280) {
 		ql_dbg(ql_dbg_user, vha, 0x70d9,
 		    "Setting will be affected after a loss of sync\n");
 		type = type/10;
@@ -1860,6 +1860,12 @@ qla2x00_port_speed_store(struct device *dev, struct device_attribute *attr,
 	case 32:
 		ha->set_data_rate = PORT_SPEED_32GB;
 		break;
+	case 64:
+		ha->set_data_rate = PORT_SPEED_64GB;
+		break;
+	case 128:
+		ha->set_data_rate = PORT_SPEED_128GB;
+		break;
 	default:
 		ql_log(ql_log_warn, vha, 0x1199,
 		    "Unrecognized speed setting:%lx. Setting Autoneg\n",
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7c0cc3e9c738..5a5d33e8ee7f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5728,6 +5728,8 @@ qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode)
 	case PORT_SPEED_8GB:
 	case PORT_SPEED_16GB:
 	case PORT_SPEED_32GB:
+	case PORT_SPEED_64GB:
+	case PORT_SPEED_128GB:
 		val = ha->set_data_rate;
 		break;
 	default:
-- 
2.47.3

