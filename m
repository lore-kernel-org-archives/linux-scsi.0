Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA78346A1C
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 01:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780969139; cv=none; b=skUGjr5NemsrktOj9DKsjPAMXTFGrA2YVA1k5YMfpA8uOZ25JEdm3jTnPgy60pvfT08BIqdnSlTiC723uIrDgo5dYX64VflGG7HlHF/8c4PmuX4XtN0zwXAGcuZ705/3RUJSYmdySON0fTdVd0NHWvaKiq0S9F9SZVCABSP56Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780969139; c=relaxed/simple;
	bh=AIh3dvnNQihctziG//xdQ3HB1hgtumi5pJSZXqf54mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OUcq3lFEVyNX53WhG5MpLLp+aDw9cOi/jo0r1ekSUMj8fpmZiVTHSs0VcmFynuwTfTjebJr++vFSFeL4+iaQI/SUtQgKQv1YUg6OTVW4FaYFmEzvgtVIkjMuULeMhimtahiG2+92iTbsGFQNLzQJPFtBvqJ861XcJV65myncDBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YNVXcAdH; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YNVXcAdH"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HScLf429122;
	Tue, 9 Jun 2026 01:38:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bU9WaFNzcB8oPe3O2CUP1ciL5qEo4uqiGsF1u7pZYVM=; b=
	YNVXcAdH91Z0xHua3z3s1QJKGWhG158DiJbyawMfpHx/SNYsZlYlQWoXuyOcV37x
	2bqXOc1UvjGxgiDtbItdhVecR8xXjx+joTEcY05x48lzPDgYlDlvLptNh416Jngz
	xEVLBwar0ZVu0HklYWkll+Fw0kJYkfqxdpEoA5ZtjrxSXBhVcL4iFGRBevsQ9Nnm
	8nHQIx4bcwxGmVnkuz/qba1IN5IZ4M+Sct+rkyYg4PbnaBYa3VR78/51oZLBQYu3
	0w8VGuIwvvpO1NydANkyxxlWPONSMjQUnOQBGGOxBZq9Qg9sVi3TckkH/AODKDA6
	OxkQ79UFkK0x1jTjIzsb4A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4embe7kdba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:38:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6591cWdo009093;
	Tue, 9 Jun 2026 01:38:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0pg4m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:38:38 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6591caZX009632;
	Tue, 9 Jun 2026 01:38:37 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ema0pg4hp-2;
	Tue, 09 Jun 2026 01:38:37 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alexander Perlis <aperlis@math.lsu.edu>,
        Nikkos Svoboda <nsvoboda@math.lsu.edu>, Martin Wilck <mwilck@suse.com>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        SCSI-ML <linux-scsi@vger.kernel.org>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] scsi: devinfo: broaden Promise VTrak E310/E610 identification
Date: Mon,  8 Jun 2026 21:38:20 -0400
Message-ID: <178096908540.1867344.14162914327436391638.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529205602.177515-1-xose.vazquez@gmail.com>
References: <20260529205602.177515-1-xose.vazquez@gmail.com>
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
 definitions=2026-06-08_06,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=870 phishscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606090013
X-Proofpoint-ORIG-GUID: N4rIfsIfak7ZnvSKtDF-U9LyxzLnln9h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDAxMyBTYWx0ZWRfX4D0CaCaMipIC
 deFwX4V6rNoeMVZa+dUIMEW7FDcPT4xdDA6zO19fKHnz6MXQIOcKWgSPL6nb7/6fAs4hfZCOl8n
 dWONgITVHNmeovYEMFsJRsx/EhJrb8dq7t1nX9RlPNrXjKR2u2sm+cY3HvXZMUVDGj5LDVWA5bp
 4UYoUMTyEp7g+cOv07w8cY1BR85eKsIUmrZihEFO5s7v2no0hGBLT8Syjob2neRXW5MEweLdPUv
 5akPSUBSZAQCofVIcRrVPVx0TmcdZ6+Q7XxqVGczZe+ry03x20AcusQEluW9eFXZ/4G03uc1BJm
 FbOBTR0ULLuGHI1dbDiz2TkvEjwyCSqE+teRbNj+P8zF8mkNmpRY4AUyapXh1p/H9UOM9I7IlrQ
 8x+qZ7IWm5FmkMS09l+ngFLyCgIEWgO9t0wL+GVC0dtNGGJktNCnYJ6FcWW2O6q9WdGt46H+s6B
 xIaSGWJpgvlu5MgPEj1tD33SUCzsZgdv2VFyVWCM=
X-Proofpoint-GUID: N4rIfsIfak7ZnvSKtDF-U9LyxzLnln9h
X-Authority-Analysis: v=2.4 cv=AufeGu9P c=1 sm=1 tr=0 ts=6a276e9f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=zKY0pj2RUVpoYIKHnWwA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312

On Fri, 29 May 2026 22:56:02 +0200, Xose Vazquez Perez wrote:

> The Promise VTrak Ex10 series share the same hardware base and firmware.
> Consequently all interface variants, whether fibre channel ("f") or
> SAS ("s") in dual/single controller, exhibit the same SCSI behavior.
> 
> Instead of adding separate blacklist entries for every specific model
> variant (such as E610f, E610s, E310f, E310s), consolidate and
> broaden the match strings to "VTrak E310" and "VTrak E610".
> 
> [...]

Applied to 7.1/scsi-fixes, thanks!

[1/1] scsi: devinfo: broaden Promise VTrak E310/E610 identification
      https://git.kernel.org/mkp/scsi/c/5d5221f8a406

-- 
Martin K. Petersen
