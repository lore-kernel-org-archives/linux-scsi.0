Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B43E2CCB9
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 16:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427206; cv=none; b=nQLvbRVmNDtSSWIcpQmw2PVun/nerCvAmxLMZkO/u0p3VSwkuuYgT0cegcA+/UJptspO7R7cbPm+bJfkfp1Eyz7s7nwf+vGHBngH2zCq2AmZ6u8qHhw5eWQAUvHMxbn6aE6DhDJ7eEHnyrBFtICpQznQzbIk3QIRt01jmsWULy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427206; c=relaxed/simple;
	bh=2rWr8sgHP7ODfCXckkaynkKFIIAY6eCqbEVF9Qa1RNY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WdSTL4jtOxhGCEzd7jUWcPeaq2LBSIIPQQvbkO/eGk2MsTQ9t8+VYm1GF94znSKsNOUIUrzRs6rahK02a/WDAJKshIeYSs4XHJB8ugh+bUEPiUUHugxdtfNs5GBmiIqSfsJj3WhBTJeIfqaXy1KMOU03dy6zRC4Nz4GmmuWtnLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=HIJIKEJ8; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HIJIKEJ8"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFWQl51321733;
	Thu, 30 Jul 2026 09:00:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=z
	KtE3wm3AzoFdjtaqxqrZvVT+CgSqSVD8tUHMWGy2+4=; b=HIJIKEJ8mveUc23ad
	QPdTRsHPeKhHo9MCxp6E/5f4wkd92fU4mMI4EEFF6gDi8HKhVyl9L+udeYfxXU8N
	mIQeRGD3xkPMZWjpyRFAxRgKQc70R5MzFsBXyT4QwcPzjD3627dyEN/rAlx5yRN5
	mbBoUvcRhgHCzXKgCDnII7ojNHEwiYvAlsdlyPjKCEyMUUguRvF/Ql3FHfwzqFqq
	4c5HWzqSHbWMpSh12bxDQaWSAbwOTBLi+TNR3mSo16RdgT5NeQY82sWeaFChdsrc
	1ex/uHtm/33VosUnWkSpEvwTB+rNxxF3TPfWUcwWBqiVk9ekvVaBQpPgFgFQK6ql
	7ji7A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7ktqjr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 09:00:01 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 09:00:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 09:00:00 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id D370D3F704A;
	Thu, 30 Jul 2026 08:59:58 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 21/33] scsi: qla2xxx: Skip vport under deletion in report ID acquisition
Date: Thu, 30 Jul 2026 21:28:26 +0530
Message-ID: <20260730155838.2119230-22-njavali@marvell.com>
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
X-Proofpoint-GUID: o5dkIqFYB8RCmDRcaQhr23AN6NTjvuEk
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXy2Ci3epIEepK
 GL0GdfGN6tACmFpItX9MDSOlugurGJAbNy5sZEVVuaG5+7b/wKaGuxjQ5HEewt7Z65RyqIvFAjm
 y+t2i4zm7v6+edSXGhX08Nxx56LECo8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX833H9EEtKHJX
 nsdJb4VJQMSU29a8QXffusd8NDzrQny2ZN1Kv7DIhY6fRKxXr+YApBF5VUeZDTM7iVVnaF/2hnX
 KaT+YgYd0TpJp+ixIefpjUig7SRvRfph+PV8IZV2FFmvdVgUpNw7Vw6jp3IQcw+3BNnylzArs3P
 C17k6ea8z5/Sa9nCbfQbZFw8bNElQ0Bxow4o+99BpipmYd4iFhgkscTf49JIuEADDpTDd/QZkNH
 SOgC1UDEWv6KW65KwPweLBMZH/AXN/oNLxJBuufYFMyUj2uG6ciR7yYKZZc/u7Gto4pxpcAhJB9
 XNJ2QjlUjejFw8LFgkwOP135zNO8iqdVDVGCRoE5xU+5SiVMXYnbWpdkgfO2kKVniFBqnrRVVev
 8e5tpdEBOsNNbriwqnNJFfzu+d9N3y3W+qeflMLKoKuWQuqf0Uvg7l1E18CHrknUwtjysIoeBC6
 KmRo9iap3bCSiTjb1Xg==
X-Proofpoint-ORIG-GUID: o5dkIqFYB8RCmDRcaQhr23AN6NTjvuEk
X-Authority-Analysis: v=2.4 cv=TrnWQjXh c=1 sm=1 tr=0 ts=6a6b7501 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=JiY0gFca9aj9Y5FZhyIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

qla24xx_report_id_acquisition() format-1 handling walks ha->vp_list under
vport_slock, takes a vref_count on the matching vport and calls
qla_update_host_map() to register its port id.

A vport teardown via qla24xx_vport_delete() sets VPORT_DELETE, then
qla24xx_disable_vp() removes the vport from the host_map btree and zeroes
vha->d_id (RESET_AL_PA). The vport is only unlinked from vp_list later,
in qla24xx_deallocate_vp_id(), which clears vp_map[idx] (RESET_VP_IDX)
but does not touch host_map. In the window in between, report ID
acquisition can still find the vport on vp_list and call
qla_update_host_map(); with d_id already zeroed it takes the
btree_insert32() path and re-inserts the dying vport into host_map.
Nothing cleans that entry afterwards, so once scsi_host_put() frees the
vha a later host_map lookup dereferences freed memory.

Skip a vport that has VPORT_DELETE set before taking the reference, so it
is neither re-registered nor scheduled for DPC re-registration. This
mirrors the existing guard in qla2x00_alert_all_vps().

Fixes: 41dc529a4602 ("qla2xxx: Improve RSCN handling in driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ab5648eb5f20..affcd87893cd 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4268,6 +4268,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
 			spin_lock_irqsave(&ha->vport_slock, flags);
 			list_for_each_entry(vp, &ha->vp_list, list) {
 				if (vp_idx == vp->vp_idx) {
+					if (test_bit(VPORT_DELETE, &vp->dpc_flags))
+						break;
 					found = 1;
 					atomic_inc(&vp->vref_count);
 					break;
-- 
2.47.3

