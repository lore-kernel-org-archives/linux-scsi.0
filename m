Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7E33EC2EF
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022872; cv=none; b=sEZxKspt+YckGHNddII19/JKgMDltOe7YqlZvBhgaxBT32Hu+CuptXM9X0ADi7wyPzaLY2mrXv2A1vch5FFDeEC1SBeC2oGWi+G4SsbGOn7XQybS9HQjO3bzZnEKqLKRMgnaEqSf9RtCbY3chn2GhuxgsW0n8TZr6jrdn0Q26CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022872; c=relaxed/simple;
	bh=uOgiFMTdwtVZ8U/oFutaGQDWkePj1vhsDcIEctqlGc0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FY1sV/1svtcigg+BTaX6Nb0j8EhocFoWyyZkYdnhWyHUsYKeotWeridKSnXd8giec4VlVDHzKrr6XZORmTynJRT/xDlDYrOcHlYnehZQ5FGuo4RByWJ8m0g6Yzr8U9jlNl4KuSsXIkrws4uJ5MyY8vzGOpTC+5B9lIBFhEx5+tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Vq7vLvX0; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Vq7vLvX0"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UJYN3668179;
	Tue, 14 Jul 2026 02:54:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=e
	GceIkWFP5+sCcf7Rblqie67ZO+wFzIqvS2AGOw+tos=; b=Vq7vLvX0wN+/fX9XQ
	p7msaxD0cUbr1KLuAs0tFe0XgFXggFsia0RJK8Ih7i9l+7Ce8yX3PiQ5hpD+3Sia
	TJe3UvHnxDrjkbOtc3ZS7NQID5rJmzrNphcgLK2pQiEtUBoDALjYxtqiyNFCNuvB
	FX2fFYqiuxtevVRaRVOG32WvavizqbM454XS+i2m7nPa/ppD/WJa4Rq+IchAxmQ9
	fXpXrsrEnEzpmgYUGsttfuZtYolI0KKeli+TVFtNMMmRyBLSxA0IRaMCyxbm2Ivd
	AK+hbVaZ9pOhEYZlvlsFE0Je4kc0LI4Nh36f0QWJAAF4FcDGYcUwtM268KYUw9kk
	tt1dA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fcwvc3ekq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:54:24 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:54:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:54:23 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id CF7DD5E6867;
	Tue, 14 Jul 2026 02:54:20 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 06/56] scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path
Date: Tue, 14 Jul 2026 15:23:03 +0530
Message-ID: <20260714095353.289460-7-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: Yd85bZ-pzcYbUBhjBbySP7_RVDJWQftS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX2F6QF6Jqgzgd
 aqII8MwI6wBTnJ1vAfCPfjVI+IKeXKlJ4RGgH+Kr61zeZpdkzoEmxswaxKtW665L8omfN7khDQe
 8G0BI6m9J+UWoeMMMaSun2302SRdCaQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX8QIu7CmoUzXx
 Bs0erytJOCF84HZhnxB9evJhFM9TKnQ5niMuQ8G66FtdZijS7KADhRtR5RiifP+yUT/twiNaQIZ
 5FUgQw0mcuq5mQ1WOtPfUUL+Wt5mZ7KqfaecWcU0wMpFmbsSwXVhDlhZKhQLrUr7jb0JQPKssQn
 Q0EmpTfOkKUxpR9uctWvxAHG6z0pBWb6lzriB0trs5ge4kuhe3H4GZVaq/3MEkcaMFDjGtz7ZQB
 GXJB7RY5YUhy/ibQF4FAQk+xwX9GhnCmJRRB2qOk7Hy3ccKT9Bakv4swy8RU9hgNJvT81D3hlTM
 CAhNquO7pwvRKXj62RtxSl7P5M8Cx3x3yvjsWYT9xXVPsrQ68WKUntDgkkmYkyXyXN6DgLnMj9n
 /L+66mjAXKFSUMpPz1ucNgtBOfA2QKC2OqSaZN/ngFS6nVTQi6U+4fGcrEZA2jq3SYz7FtHt3Zw
 cp2Osz7Xu0PDPgflqvQ==
X-Authority-Analysis: v=2.4 cv=cIXQdFeN c=1 sm=1 tr=0 ts=6a560750 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=eVv-LjW39nYWXZrQooYA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: Yd85bZ-pzcYbUBhjBbySP7_RVDJWQftS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

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

