Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EF712FB34
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 06:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720505248; cv=none; b=sYYoT/Cy99yT/UvfHvCHwXXZI0MrJIfy74Wk+sXHGQ505Lp6OnOyfrJYaMKhHfOQus8o/M+ItoZ+meGat16SExyZcnFnVvFLJjjrSnCelv26pN0GT5gCeyJgTC8oPLMgdR2GbLKUmlkQ+NpssOLUyYm9dgUbOlh3EiWESFUj8ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720505248; c=relaxed/simple;
	bh=OvkLidUHdlniult7TsA6Qlgpr/jZDrekW/0sIyUW/O8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CX6DNQ+IDGdD9+IOmGRco7sx2FjcoNmdZc8C94NaKx5KAls+H55/rluWxiFqBTDexqsjmGXoUuEPOKv1MA5I1TTceghYu/xMMXbBElqXA/aLyvfKxUCBoyM2nTgmGd4nABMfqbqln3E5Kwcyi0fRrE/10R0KzlLQmgFWSvgEz4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=nDXDCXRU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="nDXDCXRU"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46936ec8003930;
	Tue, 9 Jul 2024 06:07:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=tQ336xX7xBZuH2N7unSntFzhInYyn99JIJokL5JSNCI=; b=nD
	XDCXRUAoJaAo2xjIqDTAi6eX7sM/AwlHgit1CSP/udtrg1Pmjb7ckzdRC4qm6Mg0
	7M6qGTEOaw0iKsO9OBqwr9Y5uqwyQ/DDD3155sK3uF7h5qEN28LbNkLM51a7f7KU
	uCV9ez7ruQ5KL1evtkCiikwgE8p6ESivLA8+0ppdS/aFA66Beo19jr8YeMtSvjFU
	E6lO6r/qGucn6YuaNhK9pCQ1SSqjeO19VtR9d5R3ckNgzqH2ZO0+Etj1vY8IHNdx
	vH3AEGAnB4GV4SssO+8EbosBIpDPjFgX/8SEzJxAka4mpV3I8hFz/orLXcG7Hw4e
	vfVLv7DTgdfGxtV2CNJw==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 408w0r8anq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 06:07:03 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 469672V4011016
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 9 Jul 2024 06:07:02 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Mon, 8 Jul 2024 23:07:01 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <manivannan.sadhasivam@linaro.org>, <minwoo.im@samsung.com>,
        <adrian.hunter@intel.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v3 0/1] Allow platform drivers to update UIC command timeout
Date: Mon, 8 Jul 2024 23:06:35 -0700
Message-ID: <cover.1720503791.git.quic_nguyenb@quicinc.com>
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
X-Proofpoint-ORIG-GUID: Ywmj9lF8wKXjrbxz2PkR7NbLOleLXsfn
X-Proofpoint-GUID: Ywmj9lF8wKXjrbxz2PkR7NbLOleLXsfn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-08_15,2024-07-08_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 adultscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407090039

The UIC command timeout default value remains as 500ms.

Allow platform drivers to change the UIC command timeout as they wish.
During product development where a lot of debug logging/printing can
occur, the uart may print from different modules with interrupt disabled
for more than 500ms, causing interrupt starvation and UIC command timeout
as a result. The UIC command timeout may eventually cause a watchdog
timeout unnecessarily. With this change, the platform drivers can set a
different UIC command timeout as desired. The supported values range
from 500ms to 2 seconds.

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

 drivers/ufs/core/ufshcd.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

-- 
2.7.4

