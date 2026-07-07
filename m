Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ED527466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403926; cv=none; b=t3ptexspmJe8GbiYKD1rZIe3YW5tUEQ7vZdcUFkauEmMdMLwSBuwOC3ew5SDrn5Xxp3cNUReMEySu/u/o54RKr8oQUVdmKBw7gKNPHaiWjljJLTsNINVLeDP2cHbhTTRTbUKicr73hASK0jkQW3YbPX+8N9N17erbM5sApJMk0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403926; c=relaxed/simple;
	bh=2rWr8sgHP7ODfCXckkaynkKFIIAY6eCqbEVF9Qa1RNY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uQohL1fTN2Y8laCDxj2WaZk7qvR3xI1m/wzi7+XKWgCPLAr2k7vkKXUHQKi519ggzG1JTIZvH+ySK/eIyqKhcg1wWKQMMIuZsYATiXYc038+tfWAXJdeRkGGlh9lqNnTs0N6yzVFsUsGXxZz/562DsigK5PGdZVYaKMzUvAMc4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=WndXq48H; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="WndXq48H"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748rfM874066;
	Mon, 6 Jul 2026 22:58:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=z
	KtE3wm3AzoFdjtaqxqrZvVT+CgSqSVD8tUHMWGy2+4=; b=WndXq48Hqe+r4J6n9
	gaYfmxBCZOX153CWuvKRS5v6no7ws/4fQGW2/hFhf01Tq234GMWjwicEI3tA602u
	XpDi3L6uJE+28iTYo0lac27KHsrkN7emNHFY/Vz8ilAn/KJEetmP6mP0IIVlxMFQ
	QxkHTfgD4h0ZSqc+LEW0GcPD/DBl33TvT6dKkQ3QambjyPX4tlpO6dEtee1fTDrh
	TLlQ7HqCrx8NW8kIB3ZztPci5uCnj8pRborm9FZI9Hd8T88bGe/5ckBD21TZf/tT
	jCmZdHVNz+lATDE8RyM0TFR4jP52HCL9HUs4UMtkYeewE9d7UGaWYRf9FmwMLhHG
	EQFuQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waabg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:41 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:40 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 7DF543F7066;
	Mon,  6 Jul 2026 22:58:38 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 76/88] scsi: qla2xxx: Skip vport under deletion in report ID acquisition
Date: Tue, 7 Jul 2026 11:24:23 +0530
Message-ID: <20260707055435.2680300-77-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: sp6oLHebXR2NwYSoT-RxxpWNFLwiwOmU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX7O51/P4b0/s+
 K+6o+uTHzAgJb7qE+uGLkshK66nb6kfCKTCOXDS7Sk64Tgl7uYW8YUN/gp2IwmjkA7yW/+n1oe5
 j35sewkZHP78gWKqWkVKwiLgGlMJGFZB5wwV7e7jRzBG/ajYp+ag10OQ/wo03o4h0o+wr7qbI1t
 Oippzqt3eLpw2GcmXw56cXrRl6+q7sioI05EvsDyzLMe9dv0IlWwaN4e38vv9VPMFAHVez8gTCN
 YRZILgcK4pwDfsJEsqgAKvsEFzGJwSZajrosE0MJhh+EOujn9U5b+VktkISQe1RggXIxCRVxzZP
 OyWa+2MTEo5o5rv3hYznCsC+nWqyDE1HYlNq3jw9ux9e85uAt/OI4jj0y+n2Ykp2QIl2nkWfn2a
 XwF0toqoV38OCJYPuWFeH2ZP8gUh3gR9y434t7WZPmHKw47YXaBRvFZxeX+oG4B96yexoYNzqdR
 0ELJdcOwE9TYCzG0ysw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXxpMVf7pa5I7b
 s5nHOilztZSi05B/VUjCBNgRH4Yr2WvUIzCPo1iioHIh+jlVtGkYOp2ypqxppycYZwEKjwFXKj8
 J/1jYpKiJXUGFyBrxGUPZkNfN9sq77k=
X-Proofpoint-GUID: sp6oLHebXR2NwYSoT-RxxpWNFLwiwOmU
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c9591 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=JiY0gFca9aj9Y5FZhyIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

