Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823F33515CB
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783209; cv=none; b=CK/AAO9LsSX1qEpCCnVTeScu6GyCW1z/9MN75l7+LCjFDn4uLoK0p6nbNiafA++m7TaZoQ3o1mXqx3p6sSJsNpYr0fjBZjZva9OlwH052J3NKKbhtppvSw3uRi22wqlpIV2qeSh7g6kDM4OFtAMHG/0GhbxgK91tm5YsC0xz1xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783209; c=relaxed/simple;
	bh=2g0OZbzyNlcbpl6670X4NvJXIlwPRy3To/9y5PdLKf0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m9AUNal3tVWngT8zpkoOFbfn4FrIQGc/cRjgwMQ4NQooPYQlzSHi0iWu79zE0ELkc2BGQQb/dgbIkwsMt6De8tMQ2gHtMIdAb0bjZfHjT8zrKsGW3YP5HGm7XbH786BUZCrExlBa21yYe21E0z54Z+MCIG39aAMRWipc5IIfk34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=deJY8DBp; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="deJY8DBp"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vlkJ2441570;
	Wed, 22 Jul 2026 22:06:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=O
	JPGqqbn5HindJKnJV9QtnYkoZD0K9Y87bszxDmyilI=; b=deJY8DBpOdFDYUczd
	6I+qnUfQVU1eE6YUZqWqny9SJ8V5vgSUHDyAUnRKY2mmT6t/L6Gb+3IRFio4UPKp
	z/+htP3yqbZePAmLEOBmyBM+rL2CWncxqUdeODTGRUd2ZNWrxdK+MTUfhgUQv5LR
	4a7jkTerUZdMbfLCoG/rgBbrCDts8ja9X3KQSOYMAZ/7x2cMdRmEVKJQbUMup/uD
	cpToLvuQ09dOqg+wt3mFDSEL305XyalQv/UPE2ACbMEfqZFmGjP2mfliL4gatNp7
	96EW4j4Ie5He9zb3ftL6+io1PNSomTKAYf4QDTC1ZA8LQCrNvA0xTaGZ8RaEK3xN
	aQK4A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fk7jkrm40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:06:42 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:06:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:06:42 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 24AAC5C68E6;
	Wed, 22 Jul 2026 22:06:39 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 46/56] scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check
Date: Thu, 23 Jul 2026 10:34:03 +0530
Message-ID: <20260723050413.3897522-47-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX5sQ2PDimOUe7
 ofCwAVsnpDAaw+TLwaq1mqvLD1D/NZHBFdc5JnXrdgbPSRcMzI5Z/HpkKsWPe7t9JOxbsLWCWLJ
 GkdGC5f6BaBqxp7S/1uL8Npf7QElD75lD+12Zp/7+CAmztRxAqqzWWxxOTFClsQGXN50dXZ6m89
 GSDmuRnYfH0TBLPfeUh4KKWBMmR1zq07dniJtlDSo8AFRtYALxl3tBaZLfkpc1JZz3+lj85yt38
 85bYUVDVOs/TJQMeGwHvZqWNWHLiUyEHzD7m0MYS5Z/PcR+SqAyqw6uWZAQjdlU6E24crNRuRWU
 EKS6BlR/SxgArzW1LEq0fdGCrakOEp3bwAkrTj0iD7eCq9HIn1Vl5J1CiPhK4F9TCwlG3vyrMj7
 ghfMt6mGgmOwS5/2l7paLj3MLwTOX+1KVK9J9n5B8U0xaMLE/qO6vBV84lkAJ1gxKEPL1hMSG2e
 WwXo1ZdOrRKiR88YASg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX8g8l7BiZmj2k
 nzVTWETOMIvJpGSHJT8/wfr5xaC5IcF2WZKEl681RFbwji3EUjZU/B1mCXewlIzaiazvZEs2kGj
 OSfJzr7y7LefNavZJqRycpfwAqbCPtU=
X-Proofpoint-GUID: 8oeqEtWguFKRs8AF7yPl0NvrA4YIN-7y
X-Proofpoint-ORIG-GUID: 8oeqEtWguFKRs8AF7yPl0NvrA4YIN-7y
X-Authority-Analysis: v=2.4 cv=Zrzd7d7G c=1 sm=1 tr=0 ts=6a61a163 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=reP9pj-AO4Wx2xJZjeUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

qla_chk_edif_rx_sa_delete_pending() obtains the SCSI command via
GET_CMD_SP(sp) and immediately dereferences cmd->sc_data_direction.
That command pointer can be NULL: the firmware may post a status
completion for a command that has already been returned or aborted.
The caller qla2x00_status_entry() acknowledges this on the very same
status path, re-fetching GET_CMD_SP(sp) and bailing out with the
"Command already returned" message when it is NULL -- but that check
runs only after qla_chk_edif_rx_sa_delete_pending() has already
dereferenced the pointer, so a NULL cmd crashes the kernel in
interrupt context.

Return early when cmd is NULL, before touching cmd->sc_data_direction.

Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index ade1d8178573..bfa520f936a2 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -3540,6 +3540,9 @@ void qla_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
 	uint32_t handle;
 	uint16_t sa_index;
 
+	if (!cmd)
+		return;
+
 	handle = (uint32_t)LSW(sts24->handle);
 
 	/* find out if this status iosb is for a scsi read */
-- 
2.47.3

