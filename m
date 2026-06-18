Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0082FDC53;
	Thu, 18 Jun 2026 16:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781801781; cv=none; b=cFa7gTDMQSkKpQXuteQlPKpHeUs0+dY7F+/dmMpMFyDz36XjeF9v6AG+M5WDY8p1D0u2PNq1I5iFqvS7zgdb0CVlu/QBEgDRZhe3k4vvA5DZgFVl+bBfrWeqyuiN1FFZjsa7N2ZORz227BsySTo9XmDBOwbElhZTixGN3i13coc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781801781; c=relaxed/simple;
	bh=pL05IKwYx4UstC4ZgKgoFcdh/6UBtNNYEKqbUbo4usY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oFoDqzhsmq1RZ5yBo39WIb4/mIEy4sIlU1ITkrfQ+/tm9lZ9xABYdxerZXjAXM0q4EWuxfvXnblyeEbFiQXvpYblfuiDYdnrZJuZ9Jlr4PeLUmL8cVIDeFlMON/W4kL6LdPYpmrQuquH0ouD2cQjTh43Hy8EuoCY6Jky6glHL14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BXfkUctz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BXfkUctz"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65IFIAEs3791117;
	Thu, 18 Jun 2026 16:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/M89B4
	3eLy86dQw26BGfTceoT1IpnWgn1jyHCgZo9Ao=; b=BXfkUctzqCFgcXBiVegj/c
	RHqINvfJ8+ggVntCpowfi0zN4Wsl1sF+3uVih0A70QeKrLBGMKQ801btxmKGjpzY
	JG/AQDCcP/GAsGtqDw7Xw7n4UMDOfDPDPhAqdbsF1bOaK+rUTdzCccBPoxiy5fXF
	Y4yxc817ip657TBaFWFOKhuxHra6IyNM6DNyumPBpnnS+VAzJaBqn4Q694aPyRmI
	e3IjNQEBCi/eDuLqE6LY7BZTTQCWeJw9AiDDZ9IyJPR/Vxk3sgmB6Owqou4RpSIa
	S0ljt8r5dhogCv9JZNyM6jY1bmN1G55tl8nFSby8pMvUftQPCsADf9ofGFqBaF4w
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eueqw19ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 16:56:14 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65IGnf75005083;
	Thu, 18 Jun 2026 16:56:14 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ev1724r51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 16:56:14 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65IGuDk126346182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 16:56:13 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E74158052;
	Thu, 18 Jun 2026 16:56:13 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68ABF58056;
	Thu, 18 Jun 2026 16:56:12 +0000 (GMT)
Received: from [9.61.18.44] (unknown [9.61.18.44])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Jun 2026 16:56:12 +0000 (GMT)
Message-ID: <75268c28-c937-47c4-aba1-9ff47d9cd9a2@linux.ibm.com>
Date: Thu, 18 Jun 2026 11:56:11 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [SCSI] qla2xxx: Handle the INTx not connected while
 passing through
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@nvidia.com
References: <177885270578.1573.14283751510936407585.stgit@linux.ibm.com>
Content-Language: en-US
From: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
In-Reply-To: <177885270578.1573.14283751510936407585.stgit@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDE1NiBTYWx0ZWRfX3GfdovMaL4SM
 RwSCaeI9yUuCEwXGmkx3+mJ5jIThtbnCAQnswJ/JPhReVURODc2uTYT0D/yrrNmm916oqo2fQXV
 qnRJxuj3W2K+jUEgxTUUMloxtWvSJ7E=
X-Proofpoint-GUID: 81LH3OvHIGWHpyraig_G4Y7ui_a4WvJ5
X-Authority-Analysis: v=2.4 cv=bMgm5v+Z c=1 sm=1 tr=0 ts=6a34232f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=tgEE0hn4WxFvroNNBIsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 81LH3OvHIGWHpyraig_G4Y7ui_a4WvJ5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDE1NiBTYWx0ZWRfX04LQpfOnU72g
 j9dg8VFmi9sR8I5lP4P/3Gsij+yvZEHLFC1R0tlQP7Ee74j6gdDbFXv5+8DBLvPMCxzc1q02+tR
 r2PZ04Z1awkW9eGoIKl/n+uH5LyuMyKRZhsf4yxZXrRpPSKwakMxjX/OzLP2YX3ktO+IkZkLVfu
 Q7jqjBQpyridUu29XvdzkicHFqagUOWvC0wh8YfdkGULd8tAfqNDJElGP2aHICrrWYqVZ/e7DI/
 ite0wPdi5ahRQysuykByeYNTCLLGIwhtnoYLSZ4M4//AAvw/y+qSuHIvq99SEkl2ZnwCVbOHldN
 bK1Ho3Q9/xZyHiEpcWOuoUYc6uxVj4qG420LggXN7KniiKndELHga+7chpWXC/rJuchb786grYE
 Fr2yvb1xd8oGvSs0LtD+75tfwSAlhvRvgk5XCtCmcp+2evxfZdL9nzBkiyWvqYTvXd2QuKzNP/k
 hUOMePITXqxFAGxdduA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_02,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 clxscore=1011 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606180156

> The PCI_INTERRUPT_PIN reports if the device supports the INTx.
> However, when the device is assigned to a guest via vfio, the
> PCI_INTERRUPT_PIN is set to 0(i.e none) if the line is not
> connected and|or the platform cannot route the interrupt.
> 
> In such cases, the guest PCI_INTERRUPT_PIN is 0 and the port
> number becomes -1(255, uint8_t underflow) for qla[25|27|28]xx and
> qla2031 devices. The flt_region_nvram is never set, and subsequently
> the lun detection fails. Below warnings show the NVRAM configuration
> failure.
> 
>   []-0073:1: Inconsistent NVRAM checksum=0xffffffc0 id=HCAM version=0x100.
>   []-0074:1: Falling back to functioning (yet invalid -- WWPN) defaults.
>   []-0076:1: NVRAM configuration failed.
> 
> The patch handles the case, and sets the port_no to devfn like
> its done everywhere else.
> 
> Reference: commit 2bd42b03ab6b ("vfio/pci: Virtualize zero INTx PIN if no pdev->irq")
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>

Hi Shiva,
Your changes look reasonable and fix a known bug.

Reviewed-by: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
