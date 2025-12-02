Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57AC2FCC0F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 05:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764654357; cv=none; b=UNUBX4g4wiJ4qYj/t6bRo2EMNSDHSbCwp4igC1o5jLjv8Vzfiam06GYQmed3Np5jCWqW1WHjUlILPM3HlkpKSHXEIdNqloADHAuyKv3GDJGeVkwlT+nUWXmSK7CyC10BJgOdonwz2vJOLqV/MH2d3LeGCWwckbzFTkPzWVtqRXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764654357; c=relaxed/simple;
	bh=dm2tc3tFDghkUc4/4TCPOdXzK/7p+Ow4D+payn9lCJI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cbPF4EhGgpF9IWXRqc3fQnOQ/0uRxqjXPnR/aMecwFXDAJf3zxOpJ9W2syCsghglqW3fCEU3ylX2JhS4dfdIAPZuvMK/QOqy+ir9fxO1oUbKtivsI8uTP4yZMDNUU56ZxU+rLJtuXitwm9Sd/cB0WIDaAPiuyIfo0+p3vyptnUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=YhyQslt/; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="YhyQslt/"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B23wOgm1218581;
	Mon, 1 Dec 2025 21:45:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=S
	HVnF6EEwx89Hu2wOlg+97UJeYOgVUOArronokj5Rwg=; b=YhyQslt/Vz/Ewk2p4
	LhiHWnZaz+PwK/gnQhdmtul9ex/3VT67DpcWKSFRn+KFMtT19G408w2DH1mDA+OC
	S1msFMe2Pu7RbiWyzBwPZKBbHn1RqtsgmXyps+F8g6MUvRNhjY9p7HhFjYzrlcbk
	Cfjw/KXeICqvfZR8K8l1MGv9EmLedOc1LxdrS62WKoxSasDKKTkboNaqDlVZ8bVL
	rE9Y11Q4DYHJAqUNBS5HIgpkuosBcgJTXfGjHZEg/IlmviLf1B3QLE3Ts7dTRKOJ
	t7lJbzCsC6zK4oYyUhtAttZXPRisRP9jHqqfBPhm2TNQJr/AjbVxtgHvz8YHRlDt
	v/ZgQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4as99ca9hu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 21:45:51 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Dec 2025 21:45:44 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Dec 2025 21:45:44 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 359C45B697D;
	Mon,  1 Dec 2025 21:45:01 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 01/12] qla2xxx: Add Speed in SFP print information
Date: Tue, 2 Dec 2025 11:14:33 +0530
Message-ID: <20251202054444.1711778-2-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251202054444.1711778-1-njavali@marvell.com>
References: <20251202054444.1711778-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: YgpJG7uVlKO9Sx-2v4D-jjhLhXTrbG5Z
X-Proofpoint-ORIG-GUID: YgpJG7uVlKO9Sx-2v4D-jjhLhXTrbG5Z
X-Authority-Analysis: v=2.4 cv=U+6fzOru c=1 sm=1 tr=0 ts=692e7d10 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8
 a=DIr9iR-pfdiJ7R9a4dgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA0MyBTYWx0ZWRfX/tpWDeD6UklK
 JKAcsKW9gHeQOBfv0s6Qk56n/Jo6vnJNOS0wOhlow8n1RjEF7lGfDwVLTs62wgYbwPsJFL4/jBg
 jI2Fe72ZB3aZUc4BiyDVjX+GnZ4F18qet9QPDdV0NMy0AhoO8XKiwPN7Q0j0FA+ZZt3Wf1UnNDL
 Y/m3jH415ukjjfx7R4L2Bj/FVoAJU5HsyPYKNYO88b849HjAcIpItxhSOUhEaZXBiJijO5o+TIv
 NcQH/El4vpcWv7KTRGOGyOoNg3gTkq5guUO6gK6t3t1PmMBsvwxLFFN0ukaAj0miyPc29G8KKMR
 A2iWWJLeNLWNDFpPh8gUrk+xkqHrHXfVjCqLc229NXSgVghjslyodO2aSdhzTI3HAK4RYUol2PN
 UOUOeANjZ3+0Sl/t7nGS6Ya+HHcXyw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01

From: Himanshu Madhani <hmadhani@marvell.com>

Print additional information about the speed
while displaying SFP information.

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6a2e1c7fd125..66eeee84be05 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4074,6 +4074,20 @@ static void qla2xxx_print_sfp_info(struct scsi_qla_host *vha)
 	u8 str[STR_LEN], *ptr, p;
 	int leftover, len;
 
+	ql_dbg(ql_dbg_init, vha, 0x015a,
+	    "SFP: %.*s -> %.*s ->%s%s%s%s%s%s\n",
+	    (int)sizeof(a0->vendor_name), a0->vendor_name,
+	    (int)sizeof(a0->vendor_pn), a0->vendor_pn,
+	    a0->fc_sp_cc10 & FC_SP_32 ? " 32G" : "",
+	    a0->fc_sp_cc10 & FC_SP_16 ? " 16G" : "",
+	    a0->fc_sp_cc10 & FC_SP_8  ?  " 8G" : "",
+	    a0->fc_sp_cc10 & FC_SP_4  ?  " 4G" : "",
+	    a0->fc_sp_cc10 & FC_SP_2  ?  " 2G" : "",
+	    a0->fc_sp_cc10 & FC_SP_1  ?  " 1G" : "");
+
+	if (!(ql2xextended_error_logging & ql_dbg_verbose))
+		return;
+
 	memset(str, 0, STR_LEN);
 	snprintf(str, SFF_VEN_NAME_LEN+1, a0->vendor_name);
 	ql_dbg(ql_dbg_init, vha, 0x015a,
-- 
2.23.1

