Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEFD13B293;
	Tue, 13 May 2025 02:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747104544; cv=none; b=II8c0/0OjMqXLz3qqAU1SsW0piCxhLAKGMXabW4mh9l+C8eq5ZJs6L/fvSw/6xIuaj7/RqOqDtn2/Xz7eyFpEaGCfbMoUytkmlN5xsPKVrsky9ayCW7RN58MFnVx8bQMtexVs0tigcy9aI1osd37Vas6e3xCkxnGaeYbzkro/JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747104544; c=relaxed/simple;
	bh=LsFLUtRDreIFjVzUSwx3NwwW7MN4CBmCPWRiNNv9hgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LcYd4ia/oIUkHcUe0RqSykUiJwmzL20aXZu2+zOfkOFMC8mKSuhYYoiuG2O+L9+mTIRDG5bBxaz2UwMum8eX+OPgjGlVQZCT15Q4TT2uO5yfSF7Ndft6B0cpJaCaXsYTjpI293HiV669+DOU2dDNvVq301SXBkZmj8OBKvCT+8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nPTeU75u; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nPTeU75u"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54D1CmIq002350;
	Tue, 13 May 2025 02:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Q/d+YLvXV53SrVRPF28IXHJ7fqNllMPkLqmy9fK0M0c=; b=
	nPTeU75uRLUoKQxTZSDb8dM768acO6OlZfeMFkKm10pttFop88me2DgnDtL/qghl
	jv6a9ABkL5Sfx79o+pQAtCzvmmdNFCPU0nG1HA7IMIXVLoUto/vDsVoXKFLuf2lV
	MrHcp2NrS00QJlbzZFJRVoRS7cZSFID4szFVicnqdn96ggtQ+UckfDK/i0H8eTar
	bEKfOoV54EtVaMPsQsuex66Ux34TcYVv0AFqr9GSGuPW3soboevz53InllEj98V+
	Wmf+zQ6KV5GPfxnxwTrWu1W4ooxpB6gEPvm/q8aRbmOlJasAmLYWkguowJOrusV8
	6x3EhphEiUbyo00JbqSLag==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46j11c3qm7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:48:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54D2gEDP016012;
	Tue, 13 May 2025 02:48:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46hw8841h2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:48:58 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54D2muX8003994;
	Tue, 13 May 2025 02:48:58 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46hw8841cw-3;
	Tue, 13 May 2025 02:48:58 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: isci: Remove unused sci_remote_device_reset
Date: Mon, 12 May 2025 22:48:12 -0400
Message-ID: <174710241025.4089939.3214335938289536079.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250503230601.124794-1-linux@treblig.org>
References: <20250503230601.124794-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=698 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505130025
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAyNCBTYWx0ZWRfX238m9lMIx995 hrUXemU00kLYy4JF0tQRgxlsgPI5M6ZpCGVAK5BsAzp8JxugBfMYF8V9X1ltpy7yjp+NtcXgqjt ZqKAplbsI/XK/kpatzHj0jMfnoasqwr8ZblfX45M9S/txHhNi4+ToLCxG7h8uy0LPnru5xOD1SD
 p89bSw4YGsuB0tYss5+KfGXMUy99TUWWpU9cWCBXNn6+ck3RJcKcyB6FGM0SnnOMibEYT2NwgSi uJUZPtGMjI6i2n9dH1poKPu+kdxay9sIfsqTAr81hLvh4cAvTyFDmzH2xwldZvcHUm/k9C5ZG6E AriKvR+zscx8Gz4iL8NH5GIALXfKHeEzKEU9cKcLxjrPA6c3EM3tvCGm4E/ldMcdN852imvG8pP
 A023lzbUx3Mqgbs4FmQWDQmMzk6T8yk3dZP5jx5WMhp9dda6CTNFhfeRP9BrrJzgbidGnJru
X-Authority-Analysis: v=2.4 cv=YJ2fyQGx c=1 sm=1 tr=0 ts=6822b31b cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=3WJfbomfAAAA:8 a=NphK5FIVpzKq009dLO4A:9 a=QEXdDO2ut3YA:10
 a=1cNuO-ABBywtgFSQhe9S:22
X-Proofpoint-GUID: yW765tNbS1VMwjvlE_vWj5EjF9bcHVon
X-Proofpoint-ORIG-GUID: yW765tNbS1VMwjvlE_vWj5EjF9bcHVon

On Sun, 04 May 2025 00:06:01 +0100, linux@treblig.org wrote:

> sci_remote_device_reset() last use was removed in 2012 by
> commit 14aaa9f0a318 ("isci: Redesign device suspension, abort, cleanup.")
> 
> Remove it.
> 
> 

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: isci: Remove unused sci_remote_device_reset
      https://git.kernel.org/mkp/scsi/c/7c56921936a4

-- 
Martin K. Petersen	Oracle Linux Engineering
