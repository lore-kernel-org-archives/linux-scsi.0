Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AD128E8
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jul 2024 03:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721793017; cv=none; b=RGZIMupFVe8lMmApyvryDK9rMKZokdIHOWoc8cgvGOTwey47AGWFhbYfpRzxXOkBVSDZikWDwKcv3BhHFDFQQHXTwAYGaSqPpl7RKE7gkJ49mok/W8+IXRC70+DYgihqZFFHq1zn6RfKGFAvJmgz8TWtelDi0t6jG0miScBKmLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721793017; c=relaxed/simple;
	bh=dBfyezCl161IJ+bp8nEpZ8blIqOQJOvtUftIjWLuzcE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JWJ2vVrJE8b0HKB02Rh68ZxI60bzw2Z2g2jlq81O4GPZCOdWnixbkEL6xd9UyxySdKgLF4cqoC082uW52D/TET6BVyORwVmjGrP6qrImEFtVFtghmn1tos3KjW5WGsoUMkJfzyKkaQEFseybHV+ul9lvQkl2EVqArFNzGB5J6dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=a/mS/k5K; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="a/mS/k5K"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46NJ2iJa025549;
	Wed, 24 Jul 2024 03:50:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=VYXLiYCTMZqHgkynC2zesNiL8WV+WlpTEax8WgjNy/U=; b=a/
	mS/k5KNrg+K8SDj77tEDdBmyorUFGtljq7pzh5RATsgN739u5b/D7PO3zKtCuEcL
	0QzgPKs4z6mGuRr6CPljQB/jAPlqXVDeu66FHtwsQg/zVrvKSfZ+aWfqaItcxqxX
	TndcBP8GIKVkPJ+kiZ9vnpC43qf3hR1atxA+xWe89UoI46YWbaETqXEJfYSXV9ej
	1/xvyygvgL2B1vTJc8NYnsq1rlzkeWv84el19VyD5XgZ8mmJmERse82FH7q61Uwr
	mxCqvLnLkUxYtSy4QZG6LzU7ppPkDVhT4jHS8p2sbZAti9LwLq05ERwqilLLRE97
	PSzv/xGXCXRUfmYENPuw==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40g60k0mr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jul 2024 03:50:04 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46O3o2FF015618
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jul 2024 03:50:02 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Tue, 23 Jul 2024 20:50:01 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <manivannan.sadhasivam@linaro.org>, <minwoo.im@samsung.com>,
        <adrian.hunter@intel.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v5 0/1] Allow platform drivers to update UIC command timeout
Date: Tue, 23 Jul 2024 20:49:31 -0700
Message-ID: <cover.1721792309.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 27AMfQoDbOhLTE8yn0GuFRUwBC6Nl2Q4
X-Proofpoint-GUID: 27AMfQoDbOhLTE8yn0GuFRUwBC6Nl2Q4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-24_01,2024-07-23_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 mlxscore=0 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407240026

The UIC command timeout default value remains as 500ms.

Allow platform drivers to change the UIC command timeout as they wish.
During product development where a lot of debug logging/printing can
occur, the uart may print from different modules with interrupt disabled
for more than 500ms, causing interrupt starvation and UIC command timeout
as a result. The UIC command timeout may eventually cause a watchdog
timeout unnecessarily. With this change, the platform drivers can set a
different UIC command timeout as desired. The supported values range
from 500ms to 2 seconds.

v4 -> v5: - Changed the logic in the function uic_cmd_timeout_set()
	    using param_set_uint_minmax() as suggested by Peter Wang.
	  - Add a space in front of the module description string for better alignment. 
v3 -> v4: - Addressed Bart's concern about the two string to int conversions
	    would yield different results.
v2 -> v3: - Addressed Bart's comments. Renamed UIC_CMD_TIMEOUT to
            UIC_CMD_TIMEOUT_DEFAULT. Changed "Default.." to "Defaults..".
            Removed an extra line in the module description.
v1 -> v2: - Created kernel module parameter namely uic_cmd_timeout
            as recommended by Bart. Addressed some other comments.
          - Un-do the change in the include/ufs/ufshcd.h file
            which added the uic_cmd_timeout field to the hba struct.
	  - Removed the patch 2 in the series where the UIC command
	    timeout value was overridden by the platform driver.

Bao D. Nguyen (1):
  scsi: ufs: core: Support Updating UIC Command Timeout

 drivers/ufs/core/ufshcd.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

-- 
2.7.4

