Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044823101CE
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403874; cv=none; b=Z4VOADy4+gE48nNXTLeC/InHyki3RpCwwvr4+vPxWgdfmlcPAyJUoCDtl/qI1BCfByQ3WFO2V3v/1KoQ9K7RdAiE778TWEnDCbqRdmI729OaK0StzJLpIZFvf2TZVitMsxYlBoj6sNjTYC6PexITLke4Vrn2A3Gmr6QOCSBareY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403874; c=relaxed/simple;
	bh=FlRttHDa8P91jJLGQH6uf4d09z4ZLjYAHeBGH/Bm2Uw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qvgaClcltLmMgG4qou7Y3Fc+WwBoBLJxmYJhaT3ci0PdKXrwEasl1IA2BFYHWsfRps12cfnPhX+Dn65B7eH/sSc1/cFHxxTKydqvJR7OC8EPqh+8oBJxALJ1N81PTuW1HcEj2UZdNYFJOzwrl+uHysZwoa6PEDf/xvoy1BwzdZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=EEwdnI/+; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="EEwdnI/+"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667493tq1620032;
	Mon, 6 Jul 2026 22:57:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=u
	JbPVxeOlyamo8jROa9OFn4pHyI1cKnp541q60xM+NU=; b=EEwdnI/+jK5PIxo99
	qPi0WXi6BJ3gAn3z8iZ7JPNElZaaV2lM8Pk+i/5g5B9eX7gZfLRGsut3fKODVCKU
	8kxG6hAFUYIMqQyFQzxalKdqrbL5lai6ayR1Z/P6y8jYSnwY4+RB8te4J3C43/Yp
	ytFrAdNd09u/6ffxqXatnoUU5D7/Z15hP0Mc4+t93Qs9ckGBpkfct/wDbHOBio/O
	hLVLnXytNcoAjpWp0HL68xYaIb1tyuQo7E3Oqun8R9Mog7YJlPfoqRnAliTRt8lY
	nJaYCPcq1jJeA3FG5AxYm+HHP/NjxWsnItVO+lytDfB494g5m424bm1pBaVk2bOv
	NlO2Q==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p31gqma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:49 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:48 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 909FF3F7067;
	Mon,  6 Jul 2026 22:57:46 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 58/88] scsi: qla2xxx: Serialize flash version read in reset handler
Date: Tue, 7 Jul 2026 11:24:05 +0530
Message-ID: <20260707055435.2680300-59-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX/wXd1dxFjw1T
 hp+VxyXNj7jsnmd8VH9afekzvoM7g52nNV8i+gR3WoSRElfKq/lWcnotmqipLrwuzS6/t/aEGA3
 gdArmWz4dTgPAEjl7dw0pcB4x1nQOg0=
X-Proofpoint-GUID: hMbX9i6N_jTjgussK-xYG-cXSBWtlk1r
X-Proofpoint-ORIG-GUID: hMbX9i6N_jTjgussK-xYG-cXSBWtlk1r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX+wOQj2wQIBho
 4OIHeZhJhFxPdfN7O8OKERikG3pZWEQaxK33RrnpIPCjStwAMrZYAuWDCVnQ2JClW57m4/v8eio
 oOL2HtXuc1ukOEV70gFDZa4rNF+BfRJR6nyDRAmou2TN69w8+vpvvfv9bKFoAgoVXTNlyoE4mgX
 pBfZiGnhGUVLf6KFuojKdK7C2WI0N3sn0LOJvoDpReXxGw+rs2wTUKJ4bvLcbE7bzvCSJq9VSn4
 vM/gGVfhNi6tn19ZXCOPliPoEa6YQopk2CctgWl9N7xuC66S0QUWTwh4PdnhyvHrdJkyZKQ9foB
 aEZNfvb2OZX7g1FQRZZCCLZMh5U3EY7aP+MTT8A81lk9RojXP2ukJZ4EQsSLS7G+30hK26c2JIF
 UwrBiTmub84PpUEhFh8KqWB3tOLZeUUgeBXRnGpeGVzQ2hmNHQvSxyd3ZmVGTejVANI04kA+2k+
 qVdfsQvbGGi0+VqYvVw==
X-Authority-Analysis: v=2.4 cv=c5ubhx9l c=1 sm=1 tr=0 ts=6a4c955d cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=tXqVgsO6JuwmXGL3b0kA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

The "update cache versions without reset" sysfs reset operation (0x20261)
calls get_flash_version(), which reads hardware flash registers, without
holding ha->optrom_mutex. The VPD update path serializes the same call
under optrom_mutex, so this reset path can interleave its flash register
accesses with a concurrent VPD or optrom flash operation and corrupt the
reads.

Hold ha->optrom_mutex across the get_flash_version() call to match the
VPD update path.

Fixes: 8c2cf7d4e387 ("[SCSI] qla2xxx: Add a new interface to update versions.")
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

