Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C89014F70
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783202; cv=none; b=o3oLc6fpHfO+5PZxOk6gVfs5q5hO7S7tAEG+C1sYvpXzdegfbeY984qQSo4EkGXjw1ADudw/VSU7bFjvW3xj3Tx5ykUAv6VI/fMtmVqbuoq871yf7W2QLw6yYKPoAp8SHcL3b17MKhdRKdRH2ees1FtqDMuyW8nGcTZFv+5cT10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783202; c=relaxed/simple;
	bh=xUl7oJQOq+ItdWYKDnWNC83y2LUenvIfaLKg5Wuz5V8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AaeHcqGgEyZcsX/cZeX2OAHOtYBQTpOYU0XNlVM5DVW5ZK2BEoM+rXh5HWiILB1pvN9WiIZG0T5QM9DjpDHST9yFRxAlP8DaO7dZCB6/qf75gpNDjl+7R2BsfsXMarpnwmypQfvBd8iFX9cKsSh0wIdv6Ydn8z3LyzS5G8Cj3Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=K/jkZ9lY; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="K/jkZ9lY"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vxqD422564;
	Wed, 22 Jul 2026 22:06:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=I
	pTni9o3mowynFRuyzslX1X0JzJHJnzine1fe2CS60I=; b=K/jkZ9lY8+RtB5B9T
	qtJnQ4EYOBPeyox177mhFnmGjGq9kxVXcb69Zm9HnDD4BZC7Pb5bLdYj125OA+0k
	gJDfYrsXIkP9+w7v8sWYjrnOvb0B5H9wmoPjk3jA0ujSdHO/mnQPON6B8z58dhW7
	ZATj159XRuJZCf+DXx18oM1C5ZfKQjQIgeW/37WZFywVfPYsbu0QU3XhpnSezgNW
	4K+rR/Gf1W++ITlS/NYNscJZVK4V71cFqPKMgdoEjsADgSHRHXQCYFHHbO/ScQZW
	GPBTLhQ+6ySUopi2pgYBJJCcsx6/tgF0paBxJ6R+sorLbBteOZcagH2PcyywNylL
	EpmuA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8g7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:06:37 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:06:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:06:36 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 6F6125C68E6;
	Wed, 22 Jul 2026 22:06:34 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 44/56] scsi: qla2xxx: Add 64G/128G port speed setting support
Date: Thu, 23 Jul 2026 10:34:01 +0530
Message-ID: <20260723050413.3897522-45-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: w4j-Iakm5XrjjTUt_BdwOXINDKFPkEq0
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX26Qu5TM9iPYa
 P2XX+BReWnfYZri685XG/415MfIxuWRR64STi4Y7SsVS9yE2l+9TcawXl567hovn0H2edKevFgC
 MUwG+GlhfW+ksCzuBOSksqMORKHOc6I=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX9tfkSs/p6b/m
 SZ5YnUqY8Taa15uaDiRcWTiwDz4N+jVfzQ+2w6OnAeVuec9np19aOCcLEYFUEkZP3B6pfqNfMFl
 aNtV1pbDlH1WYV8tYwIpcBr0LhPGCkIYqLuWPyivoDIuwvPjRMArmzo/REK3bTbZMQ6nGqEMqvq
 4o1igQ8Jk0AspPHr+VJ1BDXbB/kz+WD0krC1cyRmlU5MZrePGTzRKikWPg1Y2El7kXsxNnGFrFY
 miGL8yNkv+SWNZbiztR1w+qtgcwkzDF+RhH8VUn5kuPmfUfqyTVzUNo+/mII7FJxIryovzH7zco
 +tzXQU/oRhbn/LlZPNSvGwhR5/KByK4rqGbtJSQlzE5LCRuEUsACSgqWhtOKh36uKRUFFViKuC+
 yy9TCivyBUO7SeqcBvo7QndzeViBrUh3gnlwCRPjCmZlXnOD8eQV/d1fQ+kju5WpZsy2x6qB6PL
 nJyvgdDblSIwAQbAD7w==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a15d cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=ejd8ke8xDgTskf0NWHQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: w4j-Iakm5XrjjTUt_BdwOXINDKFPkEq0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 8 +++++++-
 drivers/scsi/qla2xxx/qla_init.c | 9 ++++++++-
 drivers/scsi/qla2xxx/qla_mbx.c  | 2 ++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 6cf74f8c9628..3b24e8a5e29b 100644
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
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 545066f67e02..5f7bc68aab3c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4793,7 +4793,14 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 		ql_dbg(ql_dbg_init, vha, 0x00fd,
 		    "Speed set by user : %s Gbps \n",
 		    qla2x00_get_link_speed_str(ha, ha->set_data_rate));
-		icb->firmware_options_3 = cpu_to_le32(ha->set_data_rate << 13);
+		/*
+		 * The ICB data-rate field is 3 bits (bits 13-15); rates above
+		 * 64G do not fit and would overflow into bit 16 (75 ohm
+		 * termination select). Such rates are forced via MBC_DATA_RATE.
+		 */
+		if (ha->set_data_rate <= PORT_SPEED_64GB)
+			icb->firmware_options_3 =
+			    cpu_to_le32(ha->set_data_rate << 13);
 	}
 
 	/* PCI posting */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d0894cc90470..ba822c196894 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5720,6 +5720,8 @@ qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode)
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

