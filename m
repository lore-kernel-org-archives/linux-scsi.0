Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DC73D7D8B
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022984; cv=none; b=qy5Ipumwi3H4G4z6wI7342LddVm7XNmXoulaW0N0JZ1DDVrA94gQY2iiKRHOjxspysZ4s0HlpCDr9btDsrwjJMCRKHYpzr/HA1EHdZTHKK2e9GkdvtDqYpuyjZH8U/JInSJ8tIP2rm85p7ew/Ytr/CrI4pb3OC+mhbsgEIlWupU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022984; c=relaxed/simple;
	bh=tSFJrW89xTBgy7oapl4bMR/3IbJarsKKO0pBhZaUlEg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ebe/Q0JLawW+ZeXhZF2juO+DRl3jWB0v+5oFG3xFBr6oevZBpkkp8q+hJdluREdUu6Naicq/cquTHGB0ZrJtFflo12QLYLp5ozze0nOSGrdNVgK6rYMhRCNBDLtqiEmGXBowc3NRcp59IHPIukuxDeVYmHnzd88tFIdMs2XYdfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=fzhhwxsa; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fzhhwxsa"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UE8e2407837;
	Tue, 14 Jul 2026 02:56:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=6
	n50GVRthvkhZnxA7F1K3WiZMduEMX85wVSpXFJCqc0=; b=fzhhwxsaWGCZl/0/i
	/kDNrGdzcSRIbr1EBuXG+Bca4Yy5PMQq7jjr9WZ9suB7MnO2LV/SYYgiHohYgPeU
	oYOqd4LL0r8w35JUxe3rZKi5AvvXjOuzAp5F+PxzZRp1xCPeCBUeTVxyMh4W+5KY
	3nOEY1HkEViAdsIuIHS+CzvEXSiUsKrVOQoHl/x8I/KR2H+1iKVv+KZZHQ7y1Ns/
	ablpg7cGh6rISn5NhtsQe9T7Roh9y1y14ZFFE6afzLQmif6gH5f8LwPn3RBOqloM
	WoWhAbUh4ecPoKFHPkqUH+ZWcyox24t84jVRHgLuwXoCQbu/Y5meZWuzaA4mSezz
	iX4zA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fc6k9nq7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:20 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:19 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 3CB775E686A;
	Tue, 14 Jul 2026 02:56:16 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 44/56] scsi: qla2xxx: Add 64G/128G port speed setting support
Date: Tue, 14 Jul 2026 15:23:41 +0530
Message-ID: <20260714095353.289460-45-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: PmJH483hQ1Jn2X0BwEv4WOSLTYyvmasp
X-Proofpoint-GUID: PmJH483hQ1Jn2X0BwEv4WOSLTYyvmasp
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX9hKXR3edPS1Z
 22gNxeY+ayH4xOcUx6x5wWPOXv0JRNOp/qalXJCLa9NfxK7mia1upFT632ZbvAjImP9vGoSNCeH
 VgjLyevHKw9s65qRK7KnGWboNE+1Mxs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX4lwnonQSmkWo
 a6M/SaSPULeJwmKkrv6ZX1GO3FHxNCkdZXdpDLyAmN7o0PQQ98SZdqWZSZf1Gxol3VGwLga6mm9
 Im7TsiifBfoHZrQdOtTMYZwzlmthScEN0A522YHsUZCufkzjYZyfsE0MZC1eGqBQM2QE7aMSo3c
 BhlSOhgoEqVdc8/1Nq64w8X2LXrClFf++u1B5usTv+zch2Ox1Uw7Q8qxF4KHX1MhxMcf3ed8JUh
 n1RV8+Z88QzDIGA7FhOxhfJ/tgnVmS0BwEXowjjGt8pxbnzhdVLIzuHGIWU8dUuZC0VySCxayqd
 kDtIEbEFY0P7kMP39+iH3ggPWCHGyxAPrvPkl81yutuY3Ei3LjZpBW0X+PqAiT4MfgA0QgrQSGR
 Ja004uCInAMSYxxkcPX40iOzDLtDZMnc7CDAaa6SZyO5oobAYs+5Wa1h0IS/8IiuE5cQOHGR1fG
 Pb1iuf6XWoTpA+prJgA==
X-Authority-Analysis: v=2.4 cv=ULLt2ify c=1 sm=1 tr=0 ts=6a5607c4 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=ejd8ke8xDgTskf0NWHQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

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
index e31997241c34..5f04190c1487 100644
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

