Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75302C0268
	for <linux-scsi@vger.kernel.org>; Sun,  8 Feb 2026 02:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770516127; cv=none; b=Wn9pD5+pfYCAzugnwKh/RJomQo/lzCsTaTD7xL9+asXkaYu6F+MO2tISHHphI0/zjif4OwAR8kLjb5qd/+4kPmoaQ103KxP9LvTDaOCYGGK4hJ9g0Zo+V+9jLFaSzlLtGfXXIUoLKniPh3aR3fc8XloRadf7jb3KYES4NLAi3fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770516127; c=relaxed/simple;
	bh=rlB/9QCTEcbrvRkE3Zz89nNjR23ygwPKGNbYvLCS4Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aQwiM/12+8GhKmokSTZuYol57gOiWyTCoVoacr02jIqKjlnSKEIFAirTN5YraseEbN3PXZ2on94V+r2pumSQpp+QLKTN3ONveincrrOsZkkQ2s076QerY2NxPH2G/EvFhYziWwEpCxIoDOFLRMWA55A2wJdNLDp5LwfQEEecYAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B2y0b2h5; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B2y0b2h5"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6181j2731948907;
	Sun, 8 Feb 2026 02:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CYAAcD2fFeHMTXwA6IIa1xUIdkoAsE+se4wBC2eRRtY=; b=
	B2y0b2h5dDZwK+43+7I3X1VgSf/b1LkctZu71E37WYGPfr/4fBczpeRwz8Z7TmNo
	gFJ5NORWdqpONSngTsgjmq+8heLrTFE2r61/3U0D1Jq+3ASaYrNUsSPivlBTY6n7
	nGzetMj2S0D1rdHes6AQKkpwqtVFvx3HvSyc+S91YBLZ0iAbGEqLV9jzP/cc0uMh
	IleIbw+YvmXf7DCzsqL98OK8V0AiudpBxZixG66OVNxIW53wFSwScJtuEbOOdFN2
	LIk94RJVX9Yj4RUPtDy0Ok2jHckf7+5mtJ/Q8GbQT24OEKkzhsZTq+8EIzJWkPvT
	E+A2OG736TpWaeBRFQ9+0g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xes0hyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 08 Feb 2026 02:01:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6181A7dG006552;
	Sun, 8 Feb 2026 02:01:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uubuk5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 08 Feb 2026 02:01:58 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61821sxV016745;
	Sun, 8 Feb 2026 02:01:58 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4c5uubuk3y-6;
	Sun, 08 Feb 2026 02:01:57 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Guixin Liu <kanie@linux.alibaba.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: Make driver probing asynchronously
Date: Sat,  7 Feb 2026 21:01:47 -0500
Message-ID: <177051564488.3805738.987932524511486331.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260130080207.90053-1-kanie@linux.alibaba.com>
References: <20260130080207.90053-1-kanie@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_01,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=698 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602080015
X-Authority-Analysis: v=2.4 cv=KaTfcAYD c=1 sm=1 tr=0 ts=6987ee97 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=Hvy75GJ01QyooZ2wtikA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12103
X-Proofpoint-GUID: w898CH4JHu-fkaZ0y2PPuhNBDEuwuuwG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDAxNSBTYWx0ZWRfX/B4Klk1Em78i
 ULTUZ7ozVCExBHGILcMGyrDUFTHN1wGew244VY2TkfNCQ8jzOiFuDPv3Y4jvfjU9idoolVi/qHa
 ljJr47v3tO023scSaEVeuQFVsgk/K38UmRzjvwxsicKW3/uXUbyDiapejSXx0zTu6FRC4lsqzvg
 5ublVosyOanwz8D/5kpZvSIG2+WuqaqDWjqdRg4/yE6asZ5Wj64gFW1QJS1BgMYAL+GGhzRPZSG
 I6OCQaMLWPraWHcKu/4ntvENyQcmdfRI92fiDsGgezf0ikQawdpfd3dCVTRje+mVVoaZs2HeKHU
 F3o4wByUMt1e+keuY0R9wYHRmarFqN1mE+Q8HvLmOJWCHZac9UuyY0k2PJxVK3Xkq1cAZt9juwb
 htP6cLGIeIguqH+YH7ua4+cRqZmAFcbSMxs5oEffl8tHc3yS5Q5zhI4mgtx6VfhuzDAeqF5MNw5
 8lg8oqJmzaSWZnLP4SU073WvXmHw8OcQQwhhIeoA=
X-Proofpoint-ORIG-GUID: w898CH4JHu-fkaZ0y2PPuhNBDEuwuuwG

On Fri, 30 Jan 2026 16:02:07 +0800, Guixin Liu wrote:

> Speed up the boot process by using the asynchronous probing feature
> supported by the kernel.
> 
> Set the PROBE_PREFER_ASYNCHRONOUS flag in the device_driver
> structure so that the driver core probes in parallel.
> 
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/1] scsi: mpi3mr: Make driver probing asynchronously
      https://git.kernel.org/mkp/scsi/c/21a16f0f0226

-- 
Martin K. Petersen
