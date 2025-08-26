Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E1E2114
	for <linux-scsi@vger.kernel.org>; Tue, 26 Aug 2025 02:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756175666; cv=none; b=M+hyPQ2P90NxVNKNWQ1bgE/BKmHCNE6rr0uzSTva74WJNJYuyLyXOQNpclSO5mECuW31KIjs4WlYacI1w+RR8GoEGRTDNPznSEiZTZonnTRlThgL5oN9x6zk3HsS67je4yYSgopatwkavU4yt86sjQaTrLRGSlYA1M4tmRs5w7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756175666; c=relaxed/simple;
	bh=pvq8g9SKYxWNrBjtysuBfMm4r6dc/f3cNso0zqrssPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2vMYApg8TTn46ynQcRFQGDMaPDHx7RZM94AljK5Jyolr3n7TOqIAkUq2/ecp81V2BT6lAXpEj/ATYk6WHh5Pfdk5PkrQfG70vq2vNyCKWIbaxfiwrLEeh2TGBqBYB5eiO9sXJQ2iMWchI2KTrlGPevjBucXHugwGNG98efuRmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mkquoqMy; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mkquoqMy"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q1BnV6027507;
	Tue, 26 Aug 2025 02:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pfasYzKUMKYZZMe/HUBGvxeaarCbG7a9jsR4Wry7S7g=; b=
	mkquoqMy1oVt+ZBgICU5Wmmef+8UXvLT5+yAPoBukjlHA/8LpTcwT3inqxfo51k7
	CxyQ2CP58ccW5cYB+QgyxwNWNYOdw4M77rTEszEHdj9M12BuEUmYBgEKJVyRwQsm
	wf8sNtL/omPCLqkUiQs9Yar2cmzw12Q9lEREw2ulqz3k20e5w09kPp6PzN3JTNCa
	A8CHB0Ihat/POM9SW+wSDIrE5vN86ug1qmVAxDQ6y30za0YFbJV0K4rIlxfHU5gc
	x17l81PsqsHgfMU1en5+cAcIUSPcZal9dL21if1OJ6rv0yA+uWD/UqU3EW4GkdPJ
	98U1yJ362adi48O9A6Kt2w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q48ekhj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 02:34:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q0VRK2012351;
	Tue, 26 Aug 2025 02:34:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q438xc35-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 02:34:03 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57Q2Y2s2010861;
	Tue, 26 Aug 2025 02:34:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48q438xc0n-2;
	Tue, 26 Aug 2025 02:34:03 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Yihang Li <liyihang9@h-partners.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Terrence Adams <tadamsjr@google.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        Salomon Dushimirimana <salomondush@google.com>,
        Deepak Ukey <deepak.ukey@microsemi.com>,
        Viswas G <Viswas.G@microsemi.com>, Niklas Cassel <cassel@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@profitbricks.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 00/10] scsi: pm80xx: Fix expander support
Date: Mon, 25 Aug 2025 22:33:54 -0400
Message-ID: <175613417222.1984137.6870869642050987098.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814173215.1765055-12-cassel@kernel.org>
References: <20250814173215.1765055-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_01,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=832 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508260021
X-Proofpoint-GUID: _egI4bswKqWnFsdCeB3gdwtsbqZebiWc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNCBTYWx0ZWRfX9IOzec6KY2ZX
 vOMcle05cO9F8RxvGg0Ez2Uw30O6LwH4Vu8FhpyTHTe0bFGTWRFAvJo/zJ8fRz5xcHrC6MN81fg
 lTk+SbIyABU/t/AtIh+h1x/pUKECnsbmSEVJJ0Feic5K4K+huSjec3hDG76B2l8m/VLPLC15g0s
 ON2hEh+6Ek7p8mXYgaK+Dx5/tpxqJI7DZGa5gIgMXvs8S2yK21QbeaA99CfEJqrRwIDePmB4Dk3
 GMj3ig8eUx6Ymp8YqzuqyG5nsck7C40ojUH1Wyjahh0vvTz8EYNw6YPoSNSdNaxcZAQHdIKemqA
 2SoyojKuB/wOFXz8Fpd4bp8+O1YeWmSBgrlNAJTXMDE8CD5FY1kBUTA6rACkomJ0Pkkvhg2THfs
 7DYD5B1Bdmj6FpgYts1a/Ij2aKV9eA==
X-Authority-Analysis: v=2.4 cv=FtgF/3rq c=1 sm=1 tr=0 ts=68ad1d1d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=rHCXdx7icpoE5c1uHeYA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070
X-Proofpoint-ORIG-GUID: _egI4bswKqWnFsdCeB3gdwtsbqZebiWc

On Thu, 14 Aug 2025 19:32:15 +0200, Niklas Cassel wrote:

> Some recent patches broke expander support for the pm80xx driver.
> 
> The first two patches in this series make sure that expanders work with
> the pm80xx driver again.
> 
> It also fixes a bug in pm8001_abort_task() that was found through code
> review.
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[01/10] scsi: pm80xx: Restore support for expanders
        https://git.kernel.org/mkp/scsi/c/eeee1086073e
[02/10] scsi: pm80xx: Fix array-index-out-of-of-bounds on rmmod
        https://git.kernel.org/mkp/scsi/c/251be2f6037f
[03/10] scsi: libsas: Add dev_parent_is_expander() helper
        https://git.kernel.org/mkp/scsi/c/e5eb72c92eb7
[04/10] scsi: hisi_sas: Use dev_parent_is_expander() helper
        https://git.kernel.org/mkp/scsi/c/0c0188dd200e
[05/10] scsi: isci: Use dev_parent_is_expander() helper
        https://git.kernel.org/mkp/scsi/c/ad6ae22927a7
[06/10] scsi: mvsas: Use dev_parent_is_expander() helper
        https://git.kernel.org/mkp/scsi/c/3adf77948983
[07/10] scsi: pm80xx: Use dev_parent_is_expander() helper
        https://git.kernel.org/mkp/scsi/c/35e388696c3f
[08/10] scsi: pm80xx: Add helper function to get the local phy id
        https://git.kernel.org/mkp/scsi/c/b4ec98303f9f
[09/10] scsi: pm80xx: Fix pm8001_abort_task() for chip_8006 when using an expander
        https://git.kernel.org/mkp/scsi/c/ad70c6bc776b
[10/10] scsi: pm80xx: Use pm80xx_get_local_phy_id() to access phy array
        https://git.kernel.org/mkp/scsi/c/03f69351b63e

-- 
Martin K. Petersen
