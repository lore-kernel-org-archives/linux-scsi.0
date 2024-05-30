Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349B415886D
	for <linux-scsi@vger.kernel.org>; Thu, 30 May 2024 21:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717105042; cv=none; b=LX9GfiWTErY9jRMypLEe+S5He+g48dPuOr97Ph9jL6meOsSx6P/f2Vxqoq5pZTKNHwIheq1Bq8dglf2D/936CKbgGMrzdpx5wkJQTNzYNU8XGaw6K7qp3FNINrfBZoJDctFjmxWuvNtGcOPtJnDCfqEERwqXCIwXNYFWDg5zZDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717105042; c=relaxed/simple;
	bh=BgYb3dEulMCMlLVHLPeAfF/6t4BJKpxedVJm1Zo/PVY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ub/dqpsvpbA+SCSI2gXcYlQ8CkbKNzYWbLjqo+nzijVKkholbkb0to76jeXR3fqeHe8S6GexEjZUtgGO/1qGWKoXekRt/iqwjFBHjcYbuNPjmeWU+cIqn2NVVMdZW2f6Kom8JtfzwnjgHRH8wd04SvGaetn9Q9W2UOJX/ZiMhNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=AdUTLtem; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="AdUTLtem"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44UCuCf3003481;
	Thu, 30 May 2024 21:36:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=KRtyUpBgoUL+n2NZHqq5zFJRab8KAoOM9NKu8a9Mhik=; b=Ad
	UTLtemKqpQPmF6WMMkgJpGX+a3AhHiXpagPkMJ8dYxyVOPM2ZgnOogz3nulJvcgc
	ZxOfof3ZTBPIzxYvkl7aTaha9TW+8NpZdmia2Ab5iG0bEMRfctegrHGoDytim+UB
	tF72OR6Pt4Nm1huvCt1S/FEhbL9TNfUdDalO6k0mArZQtIhy7ItJWSq13CfE76NR
	JZO//N2stiEtWL1obvTImZzqiXSB1meE3EKHF2aTh2NoJeDvgwlXRGFYBURobLPr
	63P5Oi9oImDW0Lqf+9NRTTFUmlGAcTsblAeXw59bzJZa83VYtHqa+sq9GQ9Q0GIC
	3swpdaOY7m6D9oippmHw==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yesw5h5cq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 May 2024 21:36:55 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44ULasSE024026
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 May 2024 21:36:54 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 30 May 2024 14:36:53 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <beanhuo@micron.com>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v2 0/1] Allow platform drivers to update UIC command timeout
Date: Thu, 30 May 2024 14:36:39 -0700
Message-ID: <cover.1717104518.git.quic_nguyenb@quicinc.com>
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
X-Proofpoint-ORIG-GUID: jH7GMED0zcR-seukeQl2hTK2YNZb94dn
X-Proofpoint-GUID: jH7GMED0zcR-seukeQl2hTK2YNZb94dn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_17,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2405300162

The UIC command timeout default value remains as 500ms.

Allow platform drivers to change the UIC command timeout as they wish.
During product development where a lot of debug logging/printing can
occur, the uart may print from different modules with interrupt disabled
for more than 500ms, causing interrupt starvation and UIC command timeout
as a result. The UIC command timeout may eventually cause a watchdog
timeout unnecessarily. With this change, the platform drivers can set a
different UIC command timeout as desired. The supported values range
from 500ms to 2 seconds.

v1 -> v2: - Created kernel module parameter namely uic_cmd_timeout
            as recommended by Bart. Addressed some other comments.
          - Un-do the change in the include/ufs/ufshcd.h file
            which added the uic_cmd_timeout field to the hba struct.
	  - Removed the patch 2 in the series where the UIC command
	    timeout value was overridden by the platform driver.

Bao D. Nguyen (1):
  scsi: ufs: core: Support Updating UIC Command Timeout

 drivers/ufs/core/ufshcd.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

-- 
2.7.4

