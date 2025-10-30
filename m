Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79216279DA2
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 03:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761795232; cv=none; b=IB01UWSmP9ztBH4wEQdaeSAq+af83q+BMSvFtaqkSzVPmAy8GE2IgLaCXd/jy6HBMH9Ngs+suRttsWPYbaWC09G8ecLllHDiljCnbug2yAvbw3we3l7crzvhjiISwPINN61AgjolFLgvawZQz5jspWHL2ujLME63kmAo+Pfb2/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761795232; c=relaxed/simple;
	bh=1MlKUJ7jiHqPoX44bzkwsEue3yKYRqMk3k+xNmJ/zsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QxziYnqvz1guLhdGWO/x98VPyxwQrE4Qk3MR3XW2xG5OIR8QWkmc4VeYfwNWXgnAoZxaBPH0taIaldiYDhBoZzNzJwUaN3PvvsDHbOXSWjFZ9lhcvSTRqSFkd4B96hJfMiMNuy4ejSBaqWpX+stkSrocuV0Krz6zpl6hXNlII74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VRJYIymo; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VRJYIymo"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U2Yepj023051;
	Thu, 30 Oct 2025 03:33:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tTyTDiRB/WZSgQhNtt9wgwi5QkB8EL8Xh/Uy4agbjHw=; b=
	VRJYIymocEhtbOBJrOGbm1hHQrA4swwct5k0gO+CxwdnfHRSyLjBB+8K1+eBWQTN
	YC2/BpXMsdC0dpqutrzuioJHgRWAi+3Vf41jVCK4f91pQhiH4ZyFhS8YpZQmsO0A
	mA9odnXrrkEGJDVHrf/DB/h5zFScy28JT175xT+LZQAmqT7o+69af3O7uZiHXeOj
	2+iF5oHH0Ehn8DaqSyWRzZahpARRt+5CPIRD3vOy0mWdRXvxV5dBB/UbslhtT1EX
	i0CnJTmu9Aictu+mVgA65vGoW+t4rw162HnNO0rWyIx+aQBsWwEpGhopYKJLco3w
	LWJPHP8gJJf6SlydEOKuhQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3ybsr25t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 03:33:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U01e6M022866;
	Thu, 30 Oct 2025 03:33:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33y01upp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 03:33:37 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 59U3XYQi034192;
	Thu, 30 Oct 2025 03:33:37 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a33y01uh6-3;
	Thu, 30 Oct 2025 03:33:37 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: james.bottomley@hansenpartnership.com, willy@infradead.org, hare@suse.com,
        John Garry <john.g.garry@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, bvanassche@acm.org, ming.lei@redhat.com
Subject: Re: [PATCH] scsi: advansys: Don't call asc_prt_scsi_host() -> scsi_host_busy()
Date: Wed, 29 Oct 2025 23:33:19 -0400
Message-ID: <176178801895.1949089.18036045339458864565.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251023085451.3933666-1-john.g.garry@oracle.com>
References: <20251023085451.3933666-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_01,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=909 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300026
X-Proofpoint-ORIG-GUID: 4sax-W3-3pcm19X1cyEX2getiWznSDl2
X-Proofpoint-GUID: 4sax-W3-3pcm19X1cyEX2getiWznSDl2
X-Authority-Analysis: v=2.4 cv=afxsXBot c=1 sm=1 tr=0 ts=6902dc92 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=NFhBO6CLu36heb9FUW4A:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDAxOSBTYWx0ZWRfX7unS4ZbTIcee
 tZvTgNx7GikPJcWjj0fDjsGMHnIsfR7ajgD3vz+7wykRv0m/0l2yI1CqFLthXxdqVc7AF1xnzHg
 2Ko+UyMs2DfHm/9dYjm6p/IWjF6/S9JRLsso+GNl0bdbj2UmRpZYTmCYj5SPcPyHCgXmRFhZ1NK
 YUNlT0JTzA/OAVTvsp0eFmmuIt8IDnh6sYlSCusyINXZriSixWXS8MqU/GXE4TMANJC0w55xUuY
 /HDD0A4YspllyOboJV8nJklDcL3s5sMpr6zOL5eHCVWmy90YrQWZE1Gqa+tHcrtdGF3O947KjrP
 yOqnfHzYyx0MsheGbxsL8uLXmSCMX5d32FibTxiADGShPlj/3tSZQK46o6AVczU1h0kBHhNzr5j
 Y41+YFw96h+xprlhhVFMVXjTmyF3og==

On Thu, 23 Oct 2025 08:54:51 +0000, John Garry wrote:

> The driver calls asc_prt_scsi_host() -> scsi_host_busy() prior to
> calling scsi_add_host(). This should not be done, and has raised issues for
> other drivers, like [0].
> 
> Function asc_prt_scsi_host() only has a single callsite, as above, where
> the shost busy count would always be 0.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: advansys: Don't call asc_prt_scsi_host() -> scsi_host_busy()
      https://git.kernel.org/mkp/scsi/c/bb798c1f43c0

-- 
Martin K. Petersen
