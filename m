Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77E1409131;
	Wed,  3 Jun 2026 08:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780474382; cv=none; b=V4laFOySIIsrbGF2JjmkKFH4Y7pTJ+4PLdBhuspIhOJSmVpPOGlQ+1CQDAt4auOZ5zzN27M6TRBP+qwIHKuOGi7mfWrZkIowXGIS6JDBHgd24QvPRHNNtwqsk9OZJzBmWosoOjvk1UEfNlRTeZ1x+pDWO2TI/sEXvaFAh3N8upY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780474382; c=relaxed/simple;
	bh=Ma3jcYXbVtGj0knML/bLRIw9RHcQBFWr1kjtw/C6auU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wf+Jj0wzuYnEoV5C5CJ7tCU3FhuGLdJxvCo4LnLBjYl+TNTeRefnRDrqbS2S0DtSvj9JWZB4ggRhepjXgtniJ+2aJdNhpEBUZfAuKLKo/NPFltn3UKppzDs6x2mL20uJdkETCxsQUE7kiQRzE7ZFcRFo8kfznboyeeAfFA7joqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nCcPMvPN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nCcPMvPN"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65370QAF3707938;
	Wed, 3 Jun 2026 08:12:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NFJOuf
	vQt8BD8lEftdSQx0McGoMPi5Wr6OjcZr1fq7A=; b=nCcPMvPNXzjcBtHepmvH4V
	MAo37apCc7qk0E+K5O3E8r/GF6WzBFA9wAlFnm2CgNMTmLUnFdX1A1apCYiauuyE
	szMHAP3hbw5vJkJEIir9rwq02j89JJ1piXTz5mNuFWYBA5KO5IZPvrbTAGjxD8t5
	YuRKDO7P0QbNh5R7Y3cDGqcQvWCkmuSITjKMmgJM9wbAqnvvvD17Be8sxZZMxBGw
	2wi8EJ/Izc72AoyTHWzVIoNJU/1V3RIUwecvoOTCU6r7Zy1zZxAKOz9+/5q4y7vO
	W9rw3xQ0X5MBPIhFjaIbcKnCeo+yqMKSdkxKS5tEHSaeuj+pXPB7L4m14Qn5xY6Q
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efpae9ds3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jun 2026 08:12:49 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65389DQc000587;
	Wed, 3 Jun 2026 08:12:48 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ega7qfe6h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jun 2026 08:12:48 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6538Cl5B54133194
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 Jun 2026 08:12:47 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8666E5805E;
	Wed,  3 Jun 2026 08:12:47 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EAC415805F;
	Wed,  3 Jun 2026 08:12:43 +0000 (GMT)
Received: from [9.43.74.208] (unknown [9.43.74.208])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  3 Jun 2026 08:12:43 +0000 (GMT)
Message-ID: <66039318-07c0-4453-a295-bc39a2a5b8ec@linux.ibm.com>
Date: Wed, 3 Jun 2026 13:42:42 +0530
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
        alex.williamson@nvidia.com, Kyle.Mahlkuch@ibm.com,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
References: <177885270578.1573.14283751510936407585.stgit@linux.ibm.com>
Content-Language: en-US
From: Madhavan Srinivasan <maddy@linux.ibm.com>
In-Reply-To: <177885270578.1573.14283751510936407585.stgit@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Zt3d7d7G c=1 sm=1 tr=0 ts=6a1fe201 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=5Kag_sxTX4npdQ8vrmgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: DloX0hs752n9nOVtAfP7Ta6L2ag0gAsL
X-Proofpoint-ORIG-GUID: DloX0hs752n9nOVtAfP7Ta6L2ag0gAsL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAzMDA3NiBTYWx0ZWRfXxeBod29K6jTk
 F2FkP4wRX9UZQn192C/W2D3oFLNfAJRmoFNABWBdG2rLNNS6GslV5r6mrojSl5kX9kUnRiw7pX9
 nlIij5m72UTWGCLFuHGVT1nrHVWpnUKKTFiLJOqAkV4J5/sBplEaFe+ZCC6GmvJPmrXjx2n43v0
 PJUWqIsGRmSwW3Lr2Cd2iQI8QDuDfzQnMVsiDFMHzY7SFPqDJ9p2kXq2vSi3+c9YrakWW9pQYrP
 MVxpapw7gAynJgVaDj3TVrz4bI3a+UKZYM3ha9rq09ctwy4TYgzUI9CHLO+01ECR0l8fMfXkBqq
 xa/5zccuWSGLjH0s/do2Sw4lSh9UODpprLMX5cd1Nu5Ci3ixZJ+aDiH5drL7kk9C7All9kOTHn2
 vZUTjpBrDfjal81gCn86zzZN93XJ/5uL8/ADNa1441JkyOh7vZnHMomZmdqTQFlInzLBvd9ObQP
 yDc/M9YUSo31VgXvOVA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-03_03,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 clxscore=1011
 phishscore=0 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606030076


On 5/15/26 7:15 PM, Shivaprasad G Bhat wrote:
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

Any update on this? do you have any comments/concerns that should be 
addressed

Maddy

> Reference: commit 2bd42b03ab6b ("vfio/pci: Virtualize zero INTx PIN if no pdev->irq")
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>   drivers/scsi/qla2xxx/qla_os.c |   15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 72b1c28e4dae..a8d6a0a021f4 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2803,11 +2803,16 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
>   	else {
>   		/* Get adapter physical port no from interrupt pin register. */
>   		pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &ha->port_no);
> -		if (IS_QLA25XX(ha) || IS_QLA2031(ha) ||
> -		    IS_QLA27XX(ha) || IS_QLA28XX(ha))
> -			ha->port_no--;
> -		else
> -			ha->port_no = !(ha->port_no & 1);
> +		if (ha->port_no == 0) {
> +			/* None of INT[A|B|C|D], may be virtualized by vfio */
> +			ha->port_no = PCI_FUNC(ha->pdev->devfn);
> +		} else {
> +			if (IS_QLA25XX(ha) || IS_QLA2031(ha) ||
> +			    IS_QLA27XX(ha) || IS_QLA28XX(ha))
> +				ha->port_no--;
> +			else
> +				ha->port_no = !(ha->port_no & 1);
> +		}
>   	}
>   
>   	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x000b,
>
>
