Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF567E8
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jul 2024 00:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721261889; cv=none; b=pJgvp/g1fgb0gQ5zFKd9JCyVzj0/71nqyhlqcta+7tWozYpitoFAV6Y7+tB4J/BBQW8luz0w1bY9KxzMjB9UX2gsz71DmBHSiQyTzf/8yzQ417VBsPbDvZZTzn1AHj+CvyR6b7llqtTUJ1M70Fe46PzfOP2BRSmQOyui9qILmQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721261889; c=relaxed/simple;
	bh=mKWgYeY4gLnLHtmMwnpQy9oPd7PliCqTN60EYlGkzCQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=d0uraWn+HG6gO9+Ix3ANhD5IUuhKCJuzn9x39/4pvrrxQD6vJdrAeiSbRpB7uHEQi/Mr/mZwaqZ5sjmTefuw2d6uoWgWfLRlOebgMai5g25XtRBSBxOWJFazAZClMEX1xssUDo0PDApyX2N+3gkcAM8F7+gBKAOhkWtk1ZhuS8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=kdoq6etF; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="kdoq6etF"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46HHIiOY028426;
	Thu, 18 Jul 2024 00:17:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=MfYzGyWoMs7jg+mMh8FoJFs1RaRMj6poCS+PytaLeE8=; b=kd
	oq6etFe7NDooA49/rmlmPYWGaf6Rxg1EZTdm6vuf8Y1MlTeTEeZyUwqambg9o6CU
	ywI2skqL09RGkCED/6dg16cHOSSkK9uYypP7t+clEfxG7eUJ0HJ71/pM8BNHXbCt
	aQHB0UV6b27d8m8JeWwpm86MfOrYFe0GOrK6Jy3137LPCV/DqmN778Rxik/DQ1cd
	wAQN6i3i9pQc1xcwgZA5k41LI1jQ35UZEKtn0Sq30kBBueHLHYcD5VZeWb5HXsXn
	bmagLQTgLEBj2vm6Ul9IpWC2bOo3A30lKO3vdi7J9tos0b1mGkCjCaVh/tyJve+V
	mpA1NQbtMocLxR6dRMJQ==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40dwfukx5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 00:17:52 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46I0HqnY023003
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 00:17:52 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Wed, 17 Jul 2024 17:17:51 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <manivannan.sadhasivam@linaro.org>, <minwoo.im@samsung.com>,
        <adrian.hunter@intel.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v4 0/1] Allow platform drivers to update UIC command timeout
Date: Wed, 17 Jul 2024 17:17:33 -0700
Message-ID: <cover.1721261491.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: CVtTv24kiE-Wvto-ptxpepMz3x68Jl4S
X-Proofpoint-ORIG-GUID: CVtTv24kiE-Wvto-ptxpepMz3x68Jl4S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-17_19,2024-07-17_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407180000

The UIC command timeout default value remains as 500ms.

Allow platform drivers to change the UIC command timeout as they wish.
During product development where a lot of debug logging/printing can
occur, the uart may print from different modules with interrupt disabled
for more than 500ms, causing interrupt starvation and UIC command timeout
as a result. The UIC command timeout may eventually cause a watchdog
timeout unnecessarily. With this change, the platform drivers can set a
different UIC command timeout as desired. The supported values range
from 500ms to 2 seconds.

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

 drivers/ufs/core/ufshcd.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

-- 
2.7.4

