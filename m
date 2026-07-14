Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6230F2E2840
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022917; cv=none; b=o2ZoFz5LB+LncyDTAyO7odiQZsMSbH24GU+9ghZEd2qmQe5FX1MakE+i05nKNyl4G9HIvvt8jpq462bc2KTzXXyWgPpTVThPxiEkoKPmUVBOHeapamW3mnI2YF+rnAqj3JDQBUgjKcGigCFcOC0lmNc58iEobsdeXVYxRqEsJrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022917; c=relaxed/simple;
	bh=XBweKRoe2iV+j+QDP57gNIPWkFSpzqNvh5kItWbGoY8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SqG4k89r3cpWDjv01ZT+Bj8C0uzbYjifB+C6Axth7KuwKp2D6KCYGIdjJ49DfxfeCPgrZoioX1YhyNx7O7l5nqpRd0MotNjSgryxk9aJmOGgz2Z1oYI96u2F8yCx5colBMLb3M0X1ZThGG/Xt01kYJipX1/OrfaLpCq3P413bkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=EUrf4Hk0; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="EUrf4Hk0"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6Ui8r3693327;
	Tue, 14 Jul 2026 02:55:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=T
	G9Rjbv/gWTuYO3pC+FOHAYqPLzfSVkpZiKVpas+3tk=; b=EUrf4Hk0hMnXyUcf5
	+ZMVxhXGt53CzRvNJIHiRT3VPTySHCg5aORm9AgEsu1HM1rge15y0qrGGuQXlquF
	YC2+p4mBqvIt2E6yuFTFg6yjtB6/TBp3QgUjqWlgl6MN7GGHDwc9NlxWNQAYzQzL
	Tb9r4dHR44/lMLHso4s/HcWhslwO4Ivn/Xwg7dHlJ+EKypmgL7Jgi7VtutRtr+P0
	vKIEbE9nOyl08P+ve0xv79/YnhoOboy0enFhgEIzzIoxYFZ/fjF3cu2tUWZj1pDZ
	NSWjmUpLo/QemUr2/Re4MyqMwXKDU6Tea989j5FQ52j9jg1bkedsR5QiDieBo4uH
	3LJPA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fbnbey8jy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:55:13 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:55:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:55:12 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 4870D5E6867;
	Tue, 14 Jul 2026 02:55:10 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 22/56] scsi: qla2xxx: Enable qla2x00_shutdown for 29xx
Date: Tue, 14 Jul 2026 15:23:19 +0530
Message-ID: <20260714095353.289460-23-njavali@marvell.com>
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
X-Proofpoint-GUID: 1k36nK0I3r549LdEfUZmsrvqZ1EU4_TE
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a560781 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=C3ITPKR1BmyQqgtea3sA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 1k36nK0I3r549LdEfUZmsrvqZ1EU4_TE
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX8GHbGmKt7daZ
 7d6c+okhEBY85MYMt2LROatm85HAxLSl4G0x+eVS/8Sh2Bk45y9KXv0IuSljAO9rR9EHGJ6hTrw
 97JEOfXmPti4U+b/4lvubqxXew8E9RM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfXwy8tvDHOzZn7
 4exhAmZqe4RygUTtZmayQeoR7iYcRLPI46jo6eVWVWf/avPbqMrc83ypWHcZvSuTXl7jcVKSosl
 imAKlbxoUtNrDYElzad8E8PZFHtZ2tUhBQJ9JgYAzQH5zgVsCuEag9s04A7sJWZz/pJ5uNwPtFh
 g5pU6Gjp0XyoQgUCGwz4Ik9kyWuEPDkrpInYZa+Y2wdzbUsTv/B5BwsxkPrRprKr9UtyC8tMI5E
 C1OH62WF7dUbhSOJB2LNMdbooEDOhM+dLCTr7el9ePcUL/Z03h7zB2O21C+GhaoaRzgilqOllkG
 Ki2/L7aWj9WG7kFP16SdZXQEeYvYX5yVgYDjbp1cIKjMEuq3t+7HEhbUBVXWfICcpJW6oKMJKFD
 Zt1abBn9j5YtTgyPZ6zJ9IpFmu5z/T6qLKmmdqYOUfvy5ao6qr5ldLBp3gURQ3VlpJfF219gvVF
 eVufzfBHsIkDQiAM0Fg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

Enable qla2x00_shutdown for 29xx adapter by adding IS_QLA29XX check
to the shutdown path that performs firmware abort cleanup.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 146701445485..5450c40259bf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3840,7 +3840,7 @@ qla2x00_shutdown(struct pci_dev *pdev)
 		qla2x00_disable_eft_trace(vha);
 
 	if (IS_QLA25XX(ha) ||  IS_QLA2031(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha)) {
+	    IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 		if (ha->flags.fw_started)
 			qla2x00_abort_isp_cleanup(vha);
 	} else {
-- 
2.47.3

