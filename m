Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB7D33E368
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 02:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773194985; cv=none; b=i3XFtO0kf4b+sFS0yvLIGt0a7FLSMnagaz6ABIlPzpYoYiBZZKVzGsn+P/AKNUvfLn9PKdpTI/yEZN2AbGPwMWf9r1Hujo4hXW+YJtyAscKDYZ9Llkw7CaXZZh0uYF6rcRrBdGO6+h3kYgYXPsFJz1DSYX3AQsetGFeEeTDFgPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773194985; c=relaxed/simple;
	bh=xE7KYAkK4xFw4/l4JYsFxVsJG05A102bQjv0d5eXeo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WaOCG5MgE1GauFkGjj0nQQxJv+43f02RbYCoeTttv22Z+dCZRRcCYvnRmzYjg9Acnhxn9beaHVyU3cBOImZN7woBkZK/BFnoVViwAfsN5xANrs84d72ZvkR0e1HP2FzYo3YF4kR5pYxsSgCaVV+QevORCSINHOlUhl1KfzB4mQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AcwQwXz4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AcwQwXz4"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62B23R1R2344171;
	Wed, 11 Mar 2026 02:09:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6m8zI+fo9a+RSD2AwSDruusKRwETJNjywbDMmtqHmp0=; b=
	AcwQwXz42hNrBu5u9Gos3BncijsEXEEH9YkwzO3lQRTsrkhakMWT7D0+Mtu8VKzf
	bkRSdcdo3dA9pr07o/yWtxtTGVI2333EYi17RsVjCl/cnQLgu2U5wgc4bBiyZqt3
	2mJAN3PSgGGHo9viZv37MQMFj4xcDcsfff6bJh/QbGz0VY9wDNL2yESIkk0gIhV6
	8/CXlnMHXc9C+kMjwPUhiIxAlP028npQUQcKRNohUwKrM4c3JFJkARP+Z6GJyLoF
	bya+uF2oLSe91lWBfQp8hVg1vKz9iKvucxHmLZtjN/NrWLzcoPr3wWczEytjlYXM
	aH9DlsWigkOSSZ35GaRqNQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csks2m4sc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:09:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62ANo3Uw012926;
	Wed, 11 Mar 2026 02:09:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4craffewu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:09:39 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62B29c9g018454;
	Wed, 11 Mar 2026 02:09:38 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4craffewtr-2;
	Wed, 11 Mar 2026 02:09:38 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com, michael.christie@oracle.com,
        bvanassche@acm.org, john.g.garry@oracle.com
Subject: Re: [PATCH v2 7.0/scsi-fixes] scsi: core: fix error handling for scsi_alloc_sdev()
Date: Tue, 10 Mar 2026 22:09:33 -0400
Message-ID: <177319446944.2524613.84996799515253867.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260304164603.51528-1-junxiao.bi@oracle.com>
References: <20260304164603.51528-1-junxiao.bi@oracle.com>
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
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=821 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110016
X-Proofpoint-ORIG-GUID: dfuApRM5fsnNlPzgulzrpIDnU21ull3z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDAxNiBTYWx0ZWRfXw80Sk/QTp8EW
 jx/hHrtgIoM3WmcNJeYoNVDFtZNfnO5O+hTSEfFZc5u6uMppVsceZ9klBLBag7kcelq25vNIFeQ
 cE7ccBDHfJ6Ic8GAQqshRBj6SMjF75CnguuXrPPohoaIQFZs28ZB7DqJZ04A+apSLXMHCCpzFsy
 UEqV2FbBFoAhBoLoiDjdO2R2S+WDCYxb4qfDuy4SkkQ6tg0n12XZlZsHxy3c0A9HDV5y6qn7nIU
 EXg38umJR90d+69ShtsuiVi8VbS+38rubJei9p7P/1tWSrbXo90D5nfsbI3wiyHU8QZqKhdMHeI
 nFkckaPwnVn4cK8UY+fTQbSpBHByAcqFORsZwHEjtGIF79+c8v6Cu0zALfqW0gCOFUKz4/fsz0u
 niPScyRO8vw+XpbJ4D/9T0g/MkuGb+xM7VLCz8ZBubj25NU52sP2t+OpEZjiTnqNAfBMwwJPeyR
 LeEFQi5EBQhDKcdjrlTIXypEJapEspxKp3CXaSzE=
X-Authority-Analysis: v=2.4 cv=S4vUAYsP c=1 sm=1 tr=0 ts=69b0cee4 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=iFitYwA8o8FZqeUi2BsA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13819
X-Proofpoint-GUID: dfuApRM5fsnNlPzgulzrpIDnU21ull3z

On Wed, 04 Mar 2026 08:46:03 -0800, Junxiao Bi wrote:

> After scsi_sysfs_device_initialize() was called, error paths
> must call __scsi_remove_device().
> 
> 

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: core: fix error handling for scsi_alloc_sdev()
      https://git.kernel.org/mkp/scsi/c/4ce7ada40c00

-- 
Martin K. Petersen
