Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C696C223DE9
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 03:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506163; cv=none; b=mGVjjyeK+Xp6gKf/5ziGT8sv7Zb5K/wzJ4R8uzNT5nqzcg9LszyunVSlCNA7n/wYSbc4B9w6+1qeP1oTzoSqC0zHHo8DeqsJiGC2Lbdg8JlkFoQ4/14KT+mBKkNAld2NljR9Gw4LESLBiyKnNON9t+y+YQh0HYo3BWbSABRP4YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506163; c=relaxed/simple;
	bh=RnYw5TfDMriCpQjDdOsNm2ZyC5VABeraKsSX3H+HOsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MDZxhw0dSc9g1A+xqoKPy7+O8sb3qrTowbYUUVJLg5itd4U6SSOzh18kVw0LJ8QXkO85e/YydGy5LykjZ7rlTszx22kpe/6pGZnBvwmzT759tTvMjOlmjVfl3NI6qNHVBJEH+E7PIAfF4YOZZ9RSvd69opSb+jHrs3IHAt1+5Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YUqaPdzC; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YUqaPdzC"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N25Q5U2306639;
	Sat, 23 May 2026 03:15:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=j8rz/R9/f3ILC/S+zytDLaFC0nojuheEmb3Id4ciO2E=; b=
	YUqaPdzCV0JFNYpy049KajcmX4H/SADt6//JZsQJQiRcR3TAVLGI/qlQFgkogndT
	XgzFU0u+JloLIFJhGWauMEjDtDV1ezO8BFKBbmQflezFCqOhJ5QDD9wSQ4Uq/78q
	wx03khWxNY7ug1McdXadEopPcDzdXViW3ymIa1/eZ8pZmaZMjlS7ihoXd/qrLpYO
	AyJxQGizj5UaiZ0/R/gJvpF1nGQgDTAo5LFsp/lA4jCLwMC2IbAApMAEtdfJyTSD
	sZjmaSQdB9CU18JXeS5g3NbrOPYSQoB2S2rVADSFISFVkxg7suMQaBngJoUEDWy+
	PLji2e76pcW3BA+CUZ/MgA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb35904mp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F6a4032352;
	Sat, 23 May 2026 03:15:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsu0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:58 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3FvRK035132;
	Sat, 23 May 2026 03:15:58 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hstd-3;
	Sat, 23 May 2026 03:15:58 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        john.g.garry@oracle.com
Subject: Re: [PATCH] scsi: scsi_debug: Missing "\n" in sdev_printk() in scsi_debug_device_reset()
Date: Fri, 22 May 2026 23:15:49 -0400
Message-ID: <177950426851.1557613.6561723472178721450.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260519205356.1040855-1-emilne@redhat.com>
References: <20260519205356.1040855-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=961 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfX9HAPaGtW2Po+
 o9mooDO9jiirvd+q9SDOhr10gFOlRs3CUmJdm26eOwDU942b8I53fXy39gF5Q6qFIdkAs12gBkD
 ZI8mofNkLXUR0C674o7p0M9KXFFS9xbKs8v/exe6tdebI4jkKbXjxAk7nR2S6nAoJVc58T0iFp7
 u5yWdIZGXNR1wBSOU0hHkX0swAqKVxeXbuCx7XxoKHEpmEsC8nLCHqhGQ08vr/yiyDkkEUakb6X
 BlDuKulhiD+ipEFMUhbrugL6leEKL7Hz0B9D22Tc4Idvinek24RrX9Yn4XJBjuLzhJedmUtroqC
 F4Zj5CwFjW5kdVeMiKty/QZNNClE1XTNa6MxdFSosVhaKaWLPPkGjJNFJbgxp1Z1iGj+sasxVtD
 /zInTpsrJx4hpwnyvcLpi+NJwJi1sHg2U66Ui0X93WtBmH+hBL4Yv+A9vHIqg+eN5Hmflg8MdKK
 zYns7gosQlud1lQNYoA==
X-Proofpoint-GUID: pkK2mixOS1A1yebsLFOyLaRh-9VauR8e
X-Proofpoint-ORIG-GUID: pkK2mixOS1A1yebsLFOyLaRh-9VauR8e
X-Authority-Analysis: v=2.4 cv=TJJ1jVla c=1 sm=1 tr=0 ts=6a111bef cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=3kUUvWH8U0FaNc-y_ukA:9 a=QEXdDO2ut3YA:10

On Tue, 19 May 2026 16:53:56 -0400, Ewan D. Milne wrote:

> A "\n" at the end of the sdev_printk() string appears to have been
> inadvertently removed.  Add it back for correct log message formatting.
> 
> 

Applied to 7.1/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: Missing "\n" in sdev_printk() in scsi_debug_device_reset()
      https://git.kernel.org/mkp/scsi/c/e4bb73bf3ac1

-- 
Martin K. Petersen
