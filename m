Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9289E176FB1
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302175; cv=none; b=PuopihjXFcGIux+ZJXQn7ATTxfs3enGYNXH+FA4tTVQpx33rQHRv4NG5NLW5c04f56jGZ7AoPe0gefOz2FMqsC4nlOK8BAT1mnDh1+V5/1WEJd7Tc++6vFB7SgKAWgGUciKKA5FA8ul3WTn34sAESvB/AjN4kmiNMt5n32wkAf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302175; c=relaxed/simple;
	bh=uOgiFMTdwtVZ8U/oFutaGQDWkePj1vhsDcIEctqlGc0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HPDeFcDGZVFPITFTXMaoazH2+/ghvqLeostHU/m/mrxLRVbrm0ctkyzu7DDQwnd/mf+Qg55RbmYl1f5QmJaX0WyADFVse0zmfhcJRo2MKvJ234IDdwXxUq61iFeGIuQZchcI28ONtpkmIZezOSH1GoZ6nqI/NMnLvK4+TozFHOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=FU3Kv3nd; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="FU3Kv3nd"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7j0P094538;
	Fri, 17 Jul 2026 08:29:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=e
	GceIkWFP5+sCcf7Rblqie67ZO+wFzIqvS2AGOw+tos=; b=FU3Kv3ndqwaOuAVQN
	oxtysMGDXcCAO21roSG2SzKRm4CURF1fvnb8CYikJvoYwHY9oa8F3oPjpTpRDOpU
	4QftboEHjz4ktvwKI4NZl/wc0RNOLXFdjz4dIUVk3j4nggbJD2Y2e3JTrknCOgXz
	ZRAtO/kpOYYOW6ZfyuUXu6twmxoYAokStuiXX6JxWCo8DOSWAf35IlqsSxwpU5OQ
	E4ju9SZZTEAMVG5K/shBuvcDombiNfVIg1hyYBPDi/6Qa+YlP+nWisNNBFsP40uK
	sk0Ts3jKoZTpuHD8iXMYuy6yHPI8o5HgFUOEWt7XhwxFxroqFw2LMKC8/rhfFkCL
	z7t/w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ffhg8rx98-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:29:30 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:29:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:29:29 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 444EA5B693D;
	Fri, 17 Jul 2026 08:29:27 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 06/56] scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path
Date: Fri, 17 Jul 2026 20:58:14 +0530
Message-ID: <20260717152904.3155730-7-njavali@marvell.com>
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
X-Proofpoint-GUID: lMCNXsLQjG6ZP23-FEOMWSlF5zvPLvWJ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX6VZHzuCvSWgg
 ZqhdJGTntgu3EoUbunPmHBomtrOdCVyuEaRjPPAJwHJR3lhz2Vs9mmpit/MwZXEbeQdQY/W6ND5
 LH+sgTebn7MN+yleMw7J0yLtsY5HEKo=
X-Authority-Analysis: v=2.4 cv=SpKgLvO0 c=1 sm=1 tr=0 ts=6a5a4a5a cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=eVv-LjW39nYWXZrQooYA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX5BAm1jabx/Gb
 zR8qfypM/8iVpfrNdOQOqgfsvuJQV8j/nbbjovs1ZzqczN2WuLUTFPXSd5T/VOHPHqEUrnxLGXW
 1gwuxhYPDW5NpYe83jBWOEK0n0rQcVD1KJqxFNYWbueegza90jcCk1CRKgl9zW5aHt5IlEdg+JW
 vc8/PeeK65LDbdxzxK37T08qj/fk/ahvEmE0qLclXj70xZ9Yme07ijGWO4oGifL9200abXY/moo
 IT5RXQLXOxICuXz87r9XOziQiiW6bTiL6V55KB4rRKftW9ZUfrdJfFFGqFSoieseMGnSfZe6uxY
 5nW+rAo+uApCFVEAuSw12JyG4fOAi1TMTLLi95Cwsntl4l44qwdvZx+KSqPYGPcjVQAYTAykyyf
 yHxtWtxvCNCXa4ymYV2Wd5JHd36pUAcNiQOC8i+lFYcptjaiu6Kj+vQY3Qw+gz2o/jroSuOXBQC
 ZwU1btn88e+WP13/3UQ==
X-Proofpoint-ORIG-GUID: lMCNXsLQjG6ZP23-FEOMWSlF5zvPLvWJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

qla2x00_sysfs_read_vpd() called ha->isp_ops->read_optrom() a second
time after releasing optrom_mutex. The repeated read is redundant and,
unlike the first, runs without optrom_mutex held, exposing flash access
to concurrent optrom operations. Drop the duplicate call.

Fixes: 5fa8774c7f38 ("scsi: qla2xxx: Add 28xx flash primary/secondary status/image mechanism")
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 6a05ce195aa0..800751ab562a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -580,7 +580,6 @@ qla2x00_sysfs_read_vpd(struct file *filp, struct kobject *kobj,
 	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
 	mutex_unlock(&ha->optrom_mutex);
 
-	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
 skip:
 	return memory_read_from_buffer(buf, count, &off, ha->vpd, ha->vpd_size);
 }
-- 
2.47.3

