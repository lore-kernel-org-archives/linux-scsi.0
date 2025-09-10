Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3424D8F4A;
	Wed, 10 Sep 2025 03:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757473491; cv=none; b=G9JQ2H6SMCqEjbK8axSKZ594Qm0kaSnVvJMUYMfXRrWS4rcFB4yb/MOx10F0WFSziO6DLpAO+2bKxTudVo3dQoaOQhEUefdWFNKMwk+YrteKRXUaPq2xyL0LBM918qgoBjW8OSDX+xscX3Pk92MI1fFXYM2nCqCTes3UrJ7CWkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757473491; c=relaxed/simple;
	bh=zZls9VydvkW7BT8Oe5ewZFMsn3XJbo6fsl2m0x0QkSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G0Dza1S9VaVFu9ktem9O8Z4x8Vkc+WwczgiJa09DJdoRPUfFnrH2uQMsdy+bxWRAFEDzZMXS8mNlJrAcb7jfn0KVj9oOvU1tZGz6LXwS4XCQzfVdCVxvda+1NdykRnVnTiYYCisCzXYGEDGxTvXT/t/N05ehttWl9eFbPLLvQsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oAay4zL6; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oAay4zL6"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589L1H6k031540;
	Wed, 10 Sep 2025 03:04:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lZ2OxVOuOq3CuIOOpip5vmwDUa1ddH8YaTfLbZPa5Yo=; b=
	oAay4zL6kaEZbc7Yj32YRW83unjivZ1Obrn00jirWpGZ8xDNvVfuRUVXLjVDdIRi
	7Ak3+P8IVjG+YyIPJbk2cP3R81os32ElQCSYtHS4W+RaJFTPZt+nx25CHFfN1lWl
	/KnafDzVPquJqiKVPvjoOLil/fvy/YSy3Bd5ZP2MCHJDJXcxoIwT966JGMU4FNAH
	kTRUh0uRe7ZqTusXM5rsjUgWzHYvZq95h2JUVzkoOyIaGVn4R2AS93O4XGAOZPZ/
	PzR3lq/adeEoAVzaHArbbvEkTOMr/fWWVkLL4WB4Wsmw/ijnxdfhLW8WiQ8Zrwd4
	XpwcJU4dCJyA74DdpvvNNA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921peb9r8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 03:04:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A07kju030662;
	Wed, 10 Sep 2025 03:04:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdadcw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 03:04:45 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58A34g5a011326;
	Wed, 10 Sep 2025 03:04:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 490bdadcur-4;
	Wed, 10 Sep 2025 03:04:45 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qianfeng Rong <rongqianfeng@vivo.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: pm8001: Use int instead of u32 to store error codes
Date: Tue,  9 Sep 2025 23:04:36 -0400
Message-ID: <175746865970.2804493.9739069209179213836.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826093242.230344-1-rongqianfeng@vivo.com>
References: <20250826093242.230344-1-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=928 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509100024
X-Proofpoint-GUID: gr6o4hOq9WDGofbqN9ZRh49I0fG0n4BE
X-Proofpoint-ORIG-GUID: gr6o4hOq9WDGofbqN9ZRh49I0fG0n4BE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfX/sf4OP+KomuE
 0TO6iCpzfsCUYlvyh7jG0FznyrqodAlzbLsuOfbJ4PisUdVHcPRmlsly3s41tAwC1LY3p2/S+DZ
 C40WTtqJRCOqjILJC95G9g4CRBZuf35U5cwMZfL1xTGMvM//uDMBxIMzDdATAmy8duJhzfxRNSN
 TYz8gizFTWJ4HC45YaPEaGSnTrVr0HtCN2fuTe5CBDcka808P9y/DiuGaxl2hdmI1pnOgt9Reu3
 BpdbftOolVrufF40MlQHgs8U3ymjgzK/FUswm5eZTv9HyNzvtAADwvFx8eXEevHTA4iO5tLJRMJ
 8p+vqNihi08OVBHSgTvBYUiygJmRuLGDLvp3qXtsUnhkBaa7bhy8YqyeJZj7M4PYVTzmYWEdMRG
 hfC9gF9n
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68c0eace cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=piqvh46ZcRaUUjBHJjsA:9
 a=QEXdDO2ut3YA:10

On Tue, 26 Aug 2025 17:32:42 +0800, Qianfeng Rong wrote:

> Use int instead of u32 for 'ret' variable to store negative error codes
> returned by PM8001_CHIP_DISP->set_nvmd_req().
> 
> 

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: pm8001: Use int instead of u32 to store error codes
      https://git.kernel.org/mkp/scsi/c/bee3554d1a4e

-- 
Martin K. Petersen
