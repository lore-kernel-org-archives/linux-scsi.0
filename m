Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CE212F585
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302281; cv=none; b=eYp4L25X2h4hc4npnqWO1rj/PqtM9h39zVcmMcA3hIEVSlcJi6BfK/oVsaCotDASvfVHDqH/a4x7i+BxnQ7M2spoTWo90/4FGHG/web+MP0ouRfVtGQsKQbJzTRj6l1mivKNjc35NRqnSjlUDq8II2CoJUNiJJiTJwzxrXuelDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302281; c=relaxed/simple;
	bh=xUl7oJQOq+ItdWYKDnWNC83y2LUenvIfaLKg5Wuz5V8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=erXo1Epkaaws+O5Zw9s3arrvZ7/IHu/X4X3bLpb+0Aax2ipyB+kviURNY7qnUfvhrbV45bZcKbNyG+IMG2EquFpog+AHYD8AxF3Jcb98iRbHn0Lqle/XB7Ya+coClnvGOGaDGjKx8z0VKRQ/IfrStXCPzV3ps+6qTx50KYn9uAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=h5Br7VS4; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="h5Br7VS4"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE5qmc113130;
	Fri, 17 Jul 2026 08:31:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=I
	pTni9o3mowynFRuyzslX1X0JzJHJnzine1fe2CS60I=; b=h5Br7VS4V1l1PBAsL
	Km/E5u6TfMFqffvgiFmP97Ur0+0e5iEY6h91PsoJ+BHqpEezQs1RULcbD9EpZQN3
	I3riXpOOwY0Ov01HQ/Pv8JJ13slxWLlUC3WTulZncun9QQG/zQdggTQQU2KxLjEM
	sHhh2BGG2uS/6hcWhem/gAGFAc8GAjkirQzPNZHAUO1iJ3qveRUAYXX471pi7qGU
	0EId+5hxr+78XD62t/8pH5gdQu/f1Zd7aPZnNJMPpol2rFQCZ+zs2a/K8c2VcRzY
	SrPbCKvpOU9uI2tciIdBSNaIjASJE0TbcFr1U5BelqByAGOXzyUA4oK5febST//X
	k9K9w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fetcbn1a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:14 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:14 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id BDA3C5B693D;
	Fri, 17 Jul 2026 08:31:11 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 44/56] scsi: qla2xxx: Add 64G/128G port speed setting support
Date: Fri, 17 Jul 2026 20:58:52 +0530
Message-ID: <20260717152904.3155730-45-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: NS0B2R54isTi3yXDwc0Ksuk5EFRC7a9u
X-Authority-Analysis: v=2.4 cv=Y7jIdBeN c=1 sm=1 tr=0 ts=6a5a4ac2 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=ejd8ke8xDgTskf0NWHQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX6eIApYRSeRVQ
 4JcwIK7mShYoC8UDpMy5hHVSW4Q1diIzhtwo0TGi7jop6LlmmK/+xoPIoSE91KRc3d8I3AoX5T0
 vydpNXYZ1SjGaZbdGNI0HVthAngnBHs=
X-Proofpoint-GUID: NS0B2R54isTi3yXDwc0Ksuk5EFRC7a9u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX4+TnCoRlZM2Y
 32NwpYErbBklpgTwobonyFTvujp4OwDPo9cSksO/7ETyQAF+AypBTTGtI7TqTcFNTtwpedEHwVg
 a8cfFSYzFb4eNg9lHQ4FhwguV+W8elDOaihyNtlQzyKAXmbSq7g9hJj1Kn/L4OQubYxnSznA120
 95115TnfUlxY1kGdT363kJmW5VVzS1GqvbUaglLk5kWV/2mkHI3GcqhJlwNIdj+ZiojACV9jRJQ
 4+Tl9Y9i0qm6LW0GdZV6CU/BJjTABskdjkiGOjSJp5oJlFns7By6dA7rEWcM7PvLapYYSTGy+/J
 jytcw/uT/aVSuTDZZMuaiUvYgHt5kntqbuZFNnvRLX96cJrxxO5EVQrleMEYDYmaPzCQKJNlpH4
 c2YaXhYlOluuWxZvAhdJCmW+FqaBiGeN7PnR6A/VJHS/I5EJhxSVbCXljkMLA5JY+qeZZWBUfhR
 TJG5EvwOIy1iTuSeFcQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

