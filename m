Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1840409114
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427161; cv=none; b=fEbye5BFKtOzt10kcJ0AVcAC+Vz/tRV5Em8sG/hfrFeHUZMifRvQ/xoJbKBVebcdvxBhkKV9FBfUMY3RbVZ4t+HF/WfQXZx4aJGhXE3RJvDyT9xpqHMbTuaKLuPGLokr1Db0b07SO66nqtkx0Xl4YtYp59+hsOzYn7Ge/AZimXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427161; c=relaxed/simple;
	bh=N7xE1Uwb/yTA9umMxJQjpavaUyALnMzLM4yei8gt3Xo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=teoxNy/7Xufp6pJb+J+541pKC6zKFJfLBaCM9vyZUelA9Y/AkMIpDL/xZKsT6QxiAQaB8JZ6dkYiClA88+oePKmTsR/H1mhqub0nQhcUD/C5OzvQf7R0MfTyMWoGWRKfZJuQLbdVgL32oKKelIaqmv4yY/gCYnMarqsdk/+BDA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=fTV2FX9c; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fTV2FX9c"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFWVQW3113826;
	Thu, 30 Jul 2026 08:59:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=e
	xxCv3yYSYjJFms79vv1pVILO9xH4r8sJ7Wz03I9iYc=; b=fTV2FX9c52cj0tbb1
	DGCw/NWk+iq5YjwTduth0qaqPzss6N8cWd9q0Eq4WXnF/yjPhYterprjF9riOhT+
	pb3etx6FCMAFCHVnsfTsmSgVpY1Wl/PbhqPZm6I82GuDNe6ZI1lmRWSx7UOpP3mc
	RaK6B1ga65TMJ45MdHU5nDmnU+qdLQvCHq1+kB7Vy5/ug47Dn5153bsCZMsMw5uT
	Jzw9eqtTHoL79tMZpz/AEdEwU5hshC58oNIERtjsNysrNrOi4XvJ+naYUdMHlHI1
	k1qyZZfudFqrw6rBI2uJGkxLcuHtmEylzgpak3nD4lsu0kf2RWm2/kwhZebIoEoH
	TbEFg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7c2rxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:13 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:12 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 6B2C83F704A;
	Thu, 30 Jul 2026 08:59:10 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 03/33] scsi: qla2xxx: Serialize flash version read in reset handler
Date: Thu, 30 Jul 2026 21:28:08 +0530
Message-ID: <20260730155838.2119230-4-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260730155838.2119230-1-njavali@marvell.com>
References: <20260730155838.2119230-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX18O35SA/EG4b
 AA78Ap7ePPYIlLG2sb0zcYrkX7yfp6VgDnz6LdLaf4ZSEw3D/EFerwddwjTRgLBR1f+jQ8Jj/uP
 1P75VL24O2W9MaugYSJMOCL6KaRGdAI=
X-Proofpoint-GUID: i7lJhsu-_lc18fbDNwKcI3-jVvOLX9ZH
X-Proofpoint-ORIG-GUID: i7lJhsu-_lc18fbDNwKcI3-jVvOLX9ZH
X-Authority-Analysis: v=2.4 cv=HtRG3UTS c=1 sm=1 tr=0 ts=6a6b74d1 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=tXqVgsO6JuwmXGL3b0kA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX4NGG/68uWQ+2
 GPDovdai15G4tWvX/v/RfAFN8p6rE4j/YgzyKCSYgP8FDojzetSntBIwFIEwAmn3Tcz8IP0iUSZ
 49HDL6tazhdL0t9Gi+Imd67iJzTUs7uKNT8SY/QhN+z3FIRfIat0h47XJtvZ/+dpPI3wAB2GTpQ
 7znCt0x5gIUuW6jLv+PiMqYrkx4I2zULEynkpa5VghbDrCOVL2bV2zhBC2Svgx5QO73ELZ07vt6
 rrceO5Oey2lwaUChAC/2srnCPCC7a2Nah8QVoOk+Q1kL+k1FWs7hFbqYgk6bazLDmkEXwlVyj2M
 /QUhLHBHNvrYuS5XJsPa5bK32T4RjnXUwygywgndRGrKAdO2RV2VRzou/dGX8watsJkV7epuocW
 QEekig4iczMhHAy1Nn4PMKkhVDg7rTSMZ8OWsNMBQXb6h7MjKXNHM6SC4KVPA4LWnmukEUbei1a
 54c1t21cR/t5VGnrUzg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

The "update cache versions without reset" sysfs reset operation (0x20261)
calls get_flash_version(), which reads hardware flash registers, without
holding ha->optrom_mutex. The VPD update path serializes the same call
under optrom_mutex, so this reset path can interleave its flash register
accesses with a concurrent VPD or optrom flash operation and corrupt the
reads.

Hold ha->optrom_mutex across the get_flash_version() call to match the
VPD update path.

Fixes: 8c2cf7d4e387 ("[SCSI] qla2xxx: Add a new interface to update versions.")
Reported-by: Sashiko <sashiko-dev@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 3b24e8a5e29b..6a87d3bb0b0e 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -815,7 +815,9 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 			    "Unable to allocate memory for VPD information update.\n");
 			return -ENOMEM;
 		}
+		mutex_lock(&ha->optrom_mutex);
 		ha->isp_ops->get_flash_version(vha, tmp_data);
+		mutex_unlock(&ha->optrom_mutex);
 		vfree(tmp_data);
 		break;
 	}
-- 
2.47.3

