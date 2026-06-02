Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3911D349CFE
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 02:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780366264; cv=none; b=dBwW74CEneoYGbjgClezW9HtNp4j/ILeLs8wwITeqTw/ZM208EhENpWxlHuwPkZylRmE7vn9796Em7WDa+vTRScaFQ+0ejR4eoY61BqVAyKo7jSjaouF492H5ON2H7Mq0RQAhrFjHw4v8O5k43wmzShb5SBE6BwbcbDPyU9SMbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780366264; c=relaxed/simple;
	bh=xP7Bw2KRV+4lG+7Vm/bo7mGRF4Ljm0VOjaPr1FVDyiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sdrjmBtoKUavFMWXeb+DCGKn9/MKieXTQels4tl1o5BQClZjZfkyAYaQ+FEkW7TNwL72kqQlF5pHsTxTnqwm9TRilT/U9QVZ/6hxbmOyd/PbKPt5KFxzGFbiR9Ty4zqZTByaokmbkTjfzzLHAo3Rg80Iu+/TBYaIxqM/ukrbMB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X3H+Q3l4; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X3H+Q3l4"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651Gtv2A665474;
	Tue, 2 Jun 2026 02:10:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bsOaMR10TnjkuO+4xrtkhkIvKa0qmqMmW9NIdZV3gSo=; b=
	X3H+Q3l4on2SAHPbUekxflqrDP69l87D2Yfo/D+e3cUNO937JMPtIJVXiIvTpZEh
	Ou2mSvt1bpAjZDLgTYflIZwi2o0NY4ikWF6NoZPlGV0L1X1Bf9BR4uegbrMyJLQP
	XHZr+MyYK30IReq58eEzih/MMVjvbu9nyEvhMMcz7v+Kcf8hg2K4vg7EDU1U2bDB
	auWSQ9It3aB1jyD/cfC6AiLtNcM+FczBvh8DhpAWIHwjiUpYO5vBlMLWQdgAqEFh
	Tw91fHbF3R6X4xbkRTA3TG9WRzUSJaR4Q+hvelTl8ipdr4fkHux6Sut0gDg82Pjj
	hNfgHGMRpVEQOoGa8wJ9HQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efpaau8d3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:10:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6522A5Rd020253;
	Tue, 2 Jun 2026 02:10:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbc2wyc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:10:56 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6522ArCA023303;
	Tue, 2 Jun 2026 02:10:56 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4efpbc2ww0-4;
	Tue, 02 Jun 2026 02:10:55 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH v2] scsi_debug: Remove the set-but-not-used variable "sdebug_any_injecting_opt"
Date: Mon,  1 Jun 2026 22:10:45 -0400
Message-ID: <178036282196.1628204.9291487772026370229.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520171454.4035623-1-bvanassche@acm.org>
References: <20260520171454.4035623-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=969 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020018
X-Authority-Analysis: v=2.4 cv=T/S8ifKQ c=1 sm=1 tr=0 ts=6a1e3bb1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=0mlL1PYO3GfcHMNWUR0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: CvB-0fiMDEvkfwAjNDb_KF746Cx_l6Qu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxOCBTYWx0ZWRfXxbXFvaA4r/xu
 8OVrPaX/Rd4rkuRMahF6IaHIckMpSgcqAsC6IIjhQ5i8n+rqXLiBVvIZ2a44WR5HT21XbhhhES1
 QzVFhUvH0xquXj7dSJSGjosEIDUeldY0GLIhFb7kndEWtZsWQVNBP8jVCj3bwuQNw8kHsnd96vF
 14zNpwqpSIQdUIZlMkLIyFLaAB0Qsp8Mp6cZv8naFQCWDUvbe1uvyWl8Ogk80YALZGGpsqgEIKc
 BmTFOHGwcq/WqGmQRsHdwssO83PtaY2mKtxueUtRnr5/GUm4cGSXKHSrsTr/w7ZQmD2mYyYfmp2
 /rFhkEVy2E3N482X2tSt0bDaasHv8cmykfZ3Ata3LtL9ZTMnpouV0YUPLqSLoFi5YCZierHg4BE
 NCxxqkxA9u/f+pds1NsujGkWVO9HuQcXX2AEayi/dthcDf9dBqCFyhawV8mnUx1kV4YZkGhkdpv
 l2Kbgu4pYIKvNDXYdtg==
X-Proofpoint-GUID: CvB-0fiMDEvkfwAjNDb_KF746Cx_l6Qu

On Wed, 20 May 2026 10:14:53 -0700, Bart Van Assche wrote:

> The static variable sdebug_any_injecting_opt is no longer read. Commit
> 3a90a63d02b8 ("scsi: scsi_debug: every_nth triggered error injection")
> removed all code that reads this variable. Hence, also remove this
> variable itself. Remove SDEBUG_OPT_ALL_INJECTING because there is no
> code left that uses this constant if sdebug_any_injecting_opt is
> removed. This has been detected by building the scsi_debug driver with
> the git HEAD version of Clang and with W=1.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi_debug: Remove the set-but-not-used variable "sdebug_any_injecting_opt"
      https://git.kernel.org/mkp/scsi/c/f199cee401f7

-- 
Martin K. Petersen
