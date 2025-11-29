Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100FD15A864
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 03:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764387039; cv=none; b=TO4Wp2vgZW/XNX5JVVtgVRD8vfmuloeyyryGlBoSuC0gXMRuomvZb3ow6hIjfrq3ka9sH0Vuyc1feWHhmx72+6AaPAzp3z++VDVeIImEmE8uwC4XCcNi5fUsFTNBc3ouqOhvVpwf+KO8zjPYGfoRi9cksaZE+S+A7LIIShmnHsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764387039; c=relaxed/simple;
	bh=AGaHj00oWGi9g1Sg5OlxCtXGuH7yOz/2IVM/3J+D4y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ml5TbsFe81tm3GoDNhjg9nAkfouR2IuZKs61RmpGsnu69hwppQbvIvn/FMsJrsns3jTUBsD6Puwxgbg3qhQs5kNxfiyHWshNzdViu+vQLxVro9jqcKx5pFWDBWyIRfvJ81Oc+oxgQtwcFZQNhbkFDzfkCsMeydUbKKqf3pMgm9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H3xvYkhW; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H3xvYkhW"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AT1wZ53556472;
	Sat, 29 Nov 2025 03:30:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sqFClT4X0qSVuMmmJv+fAjPHfPzl/UezGyMDTUPpNnY=; b=
	H3xvYkhW8CjCUTpPQme0Ye+gDJ7GbkWGl14KgN4wFU7u2QSU/JGVnkYdQLWykZ8E
	Wz6EGxCrYoWsrAJXuQ+3tYFoAkkUW14XF1qGXbyu/omv0rdlG3slMTOb8pxKHujP
	M2aVHg97pMCCRFcffgKeZxZ8x16WFbcoEAc7qeXDPK0nCm61TkvBwqqrMubrGgR7
	7ifg6egw5WoDUvXvxttOk962PtSki298ScKXDmFsBSWthGV76nZNSWq3Fc1B8F07
	7cV5vGUT+T6k5kqoLxjScmTvat2xEfQSogz2S3dF0waBFRyCfQhL34vxKLYyjhs1
	ak39OonwblXu94SuXCq+TQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqqm201en-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 03:30:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AT1XfBB032003;
	Sat, 29 Nov 2025 03:30:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq961na0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 03:30:18 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AT3UEpJ015090;
	Sat, 29 Nov 2025 03:30:17 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aqq961n85-4;
	Sat, 29 Nov 2025 03:30:17 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Peter Wang <peter.wang@mediatek.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Avri Altman <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] ufs: core: Use scsi_device_busy()
Date: Fri, 28 Nov 2025 22:30:03 -0500
Message-ID: <176438479583.3682470.11784883283179680096.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251113235252.2015185-1-bvanassche@acm.org>
References: <20251113235252.2015185-1-bvanassche@acm.org>
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
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=785
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290024
X-Proofpoint-GUID: yY9Btl0psdlrWcI2ZNL88Fyh8_pJpYEN
X-Proofpoint-ORIG-GUID: yY9Btl0psdlrWcI2ZNL88Fyh8_pJpYEN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAyNSBTYWx0ZWRfX5AeZM5ybCt2x
 12ODRnMQNZR4TU51OYmDSAIwJE6t5e9AHISMPoVQGxFm6mwv8tvp7+BajmoamF2+z7BDZg0y3qB
 woxFdp8oyxg8GOJ8PbJ5ORMIgAOzj6SlfAg68br0BakXPa/wXY8UgF2krzHfwBiYA7wo8DhJcGp
 e4+tO/fcbDZHVEfVvyFajal7cMEhnbUTI4nZ1cjmMoNPV/Z1pSS0Yj3absfRyvXrbXMyVGYBKk3
 L2A3V1QQWVVGK2v0sESCsU8ucJa+kR4Lie/BCalvKxJ6FbMM6VeGl6vX4RvNeDkfVqNu6OahHZO
 9sbHQKBmmg1n90/kBMeoOSFYyUIXQj+fAxDVHaXSEv9JMqaRsvILy4wfheW7GOW0u1pSFwWv588
 7i9dCbpp8LoJCA6sBw1aaEOsgg/E3A==
X-Authority-Analysis: v=2.4 cv=S+bUAYsP c=1 sm=1 tr=0 ts=692a68cb cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=aFAAcLUjLsWwAMECXloA:9 a=QEXdDO2ut3YA:10

On Thu, 13 Nov 2025 15:52:43 -0800, Bart Van Assche wrote:

> Use scsi_device_busy() instead of open-coding it. This patch prepares
> for skipping the SCSI device budget map initialization in certain cases.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] ufs: core: Use scsi_device_busy()
      https://git.kernel.org/mkp/scsi/c/31e6e7e54b29

-- 
Martin K. Petersen
