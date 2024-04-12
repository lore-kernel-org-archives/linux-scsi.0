Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F6F17C7F
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 02:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712887543; cv=none; b=lLXlxWdIr6enbs/jAalYylZoIxkmnI+YrNT3+dZhBBavdT2b9e52dNCnUQJzcKCV6xNZZpgbyYgQ2WnUfmU7UumXwVDphWoqQjME1hL264xEPmylQ7rbBa3waDQd1djCov1RIToKi066/l7xqTRhTBg/wwPGC3iyQUb5FCLlzmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712887543; c=relaxed/simple;
	bh=8r6k0eMn9oiKIMzEeQD37fSCHGRA/ADJmz0choKRDUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u01DLo5qk0ybimcnnAvxYd/ZFfqKswlQ76pNRRQRfROXGFMFo5IX/2GUTErAfbD9CDwXmz74YHhhWqQQr1fOprLvzbkbID6dhLvKUJqEFcKgPkzGgFzpx8xeErj+L7tSsxw7p7AgXZFDQu84HblQw6GDOtu0PqrqdLx5hJ0qJhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eoeEDNTn; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eoeEDNTn"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43C1r7KM008546;
	Fri, 12 Apr 2024 02:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=q2LTTI25yNDXfX3qPkWlcjsXmaXq0gzwkeCzs3exrzo=;
 b=eoeEDNTnXRKnJp9IekzWe3z3kyFYPCj0T2OD2EfcoL5phkp4WeRBR3THy0vJMmG6+xhI
 1vp8BowABVGSRVQTNnwWraDHfY2fHpdjpmJ7J+7XI/uw6QJyhvJf0PQPVWqfMRQ7OUiw
 8c7/muNZCFfXqvHlOW9mqa27oiHJcZd2vV76Y0ryVugiBwuDPf/bHFcCUOk4IySqEIZU
 OndR5LyOuep4T3T5eyLHqT7UgfXkf7yHr7sG0ixro8q7z8E9RO8Xz+v8Lr+p2RXw8E42
 8U+hRBiDlYVH/Tbv3rrg4f6qDj70YDsglj74xeM2g7ZkK7vqyCj7pWs9+YaY4Vp6AkEu OQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xax9baq7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 02:05:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43BN8rNe040021;
	Fri, 12 Apr 2024 02:05:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavugmd3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 02:05:33 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43C25UFq013100;
	Fri, 12 Apr 2024 02:05:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3xavugmd1x-6;
	Fri, 12 Apr 2024 02:05:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Prasad Pandit <ppandit@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        megaraidlinux.pdl@broadcom.com, Prasad Pandit <pjp@fedoraproject.org>
Subject: Re: [PATCH v1] scsi: megaraid: indent Kconfig option help text
Date: Thu, 11 Apr 2024 22:05:13 -0400
Message-ID: <171288602646.3729249.14585843901938832619.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240311121127.1281159-1-ppandit@redhat.com>
References: <20240311121127.1281159-1-ppandit@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_14,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=895
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404120014
X-Proofpoint-GUID: enjGmBeapMVQBypRxMHm0r0yZfUrFXiv
X-Proofpoint-ORIG-GUID: enjGmBeapMVQBypRxMHm0r0yZfUrFXiv

On Mon, 11 Mar 2024 17:41:27 +0530, Prasad Pandit wrote:

> Fix indentation of megaraid options help text by adding
> leading spaces. Generally help text is indented by couple
> of spaces more beyond the leading tab <\t> character.
> 
> 

Applied to 6.10/scsi-queue, thanks!

[1/1] scsi: megaraid: indent Kconfig option help text
      https://git.kernel.org/mkp/scsi/c/e75f7555e1e7

-- 
Martin K. Petersen	Oracle Linux Engineering
