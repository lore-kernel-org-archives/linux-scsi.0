Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC8626AD9
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 03:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753412480; cv=none; b=vEKa8KNXYabXkHOtDLxifHSKiibftiSzcm6i3HpJMr7RKSEbDAwd13QsiwYNLQJS0szlCKrzhCBgCUVZR2bLqQrvseMRaINwYBEs+Y5Mv+eBpWDXnVZPre6JGdkqYMKIn91keCucQeU+08VCtwH/C2ViBA5HSvlg+h73g2lx75k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753412480; c=relaxed/simple;
	bh=a2IdFPf4kGkvZLsFAyIReSENIckRdOlBqU4ybK8IdCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R7xAldGyR/7VZexqSbLGTqhUSmhVUSjNxJtSQyvcoD+mc5AJIx0j9n0VtFDLwiaj/Zksnlqxg6tsDnsNK3ZVCTQdUa+soLI4wHjhY1288PqyiI5ThuxPkcwukzjj6vgrOp/hmQwaTW4QCJv2HIc3qoxeTF5okLiA6Op7chKw8qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jD/hz15u; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jD/hz15u"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLjwRj008847;
	Fri, 25 Jul 2025 03:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=O5m1GXIsiGKff7Gyxy2+tqLrGlXrcpn2X5Z3CiXjf7c=; b=
	jD/hz15uW/bmIuFF4fY0E8pz+tinSv3aM2FjkaJnZ4NnjIe7IxSBdQQ86OKo0mNM
	rteFUZTWFOI8/OmqqDflSexIuBrcyFcmvY3xFmt7BeXKksNijc17szHkC4Dj3+xs
	r9CKtihsrFuLmW+Dmpe3P8dlVekL4OUFTXVRJrsAvEhtM8ZrvkmqF3iaDxeh+cEY
	i0M4vTo6eH7tvTgG4wc1kwBccSoOa+Z+vwekEFETKx5P1cjYSTVTSNlrtXgbFYmY
	phcSDV5P79R66wvvDqnND9sXO9qX3FNb8WsyzOzIZKoYP4JYSROWsEdsPTWIdg5l
	6OAmXs7Ix7m5wvbHg0itsg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1jg84b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 03:01:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P2xWpI005746;
	Fri, 25 Jul 2025 03:01:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tcjmqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 03:01:09 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56P317Vt037766;
	Fri, 25 Jul 2025 03:01:08 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4801tcjmnp-2;
	Fri, 25 Jul 2025 03:01:08 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: lduncan@suse.com, michael.christie@oracle.com, cleech@redhat.com,
        Showrya M N <showrya@chelsio.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, bharat@chelsio.com
Subject: Re: [PATCH for-rc] scsi: libiscsi: initialize iscsi_conn->dd_data only if memory is allocated
Date: Thu, 24 Jul 2025 23:00:56 -0400
Message-ID: <175340373568.67790.1419246132424722713.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250627112329.19763-1-showrya@chelsio.com>
References: <20250627112329.19763-1-showrya@chelsio.com>
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
 definitions=2025-07-25_01,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=751
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507250023
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDAyMyBTYWx0ZWRfX/UDtx8StFnuu
 etwZLed4kg0x54r7VoVQNgIH1ZWrwnFJYljOT7eG3eTyZQRtYVI4IUZ87+trPoJj8cBPUq2BvyZ
 DZNxUHfAXo8AFImHL2/lRxBZeGOyQqYhgEZRP0zqM38S4lNW+5Ly25Quag6M6R267T4OUvBU9F7
 /wBi8F9aXSKAsKcKCyTmZCK9/JnXGWQBismh26uaJ3SmZqgzpLVvI/Y9Rgt0+6k+JVCfhk7OrhQ
 tqxk8F7/4Hl91JJXpqnb4XYNe7m1lQM946AeOnwG2mjpEIS5VQWH0uR0FrahtpFQZRfYwqVIb8/
 CovmP8o79r/4kVJQIiK8kWuwlOoBZXoY1vkP/j0T1q/aFpQ2IT7lSQPYv+rYs1V8aSjpJQYZpsM
 qKrXLD1QrvNMWnr1H6vgedbIxrPtLXhusFEvB/S/jqZ+0h7UAT3k0fuRkrvmsLbcBXkvZzOp
X-Authority-Analysis: v=2.4 cv=W+s4VQWk c=1 sm=1 tr=0 ts=6882f375 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=4ccISY7aMYaioOn7AhUA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: iPn5ocC8qSdHldHyeRweoglclSkxKfYZ
X-Proofpoint-GUID: iPn5ocC8qSdHldHyeRweoglclSkxKfYZ

On Fri, 27 Jun 2025 16:53:29 +0530, Showrya M N wrote:

> In case of an ib_fast_reg_mr allocation failure during iSER setup,
> the machine hits a panic because iscsi_conn->dd_data is initialized
> unconditionally, even when no memory is allocated (dd_size == 0).
> This leads invalid pointer dereference during connection teardown.
> 
> Fix by setting iscsi_conn->dd_data only if memory is actually allocated.
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: libiscsi: initialize iscsi_conn->dd_data only if memory is allocated
      https://git.kernel.org/mkp/scsi/c/3ea3a256ed81

-- 
Martin K. Petersen	Oracle Linux Engineering
