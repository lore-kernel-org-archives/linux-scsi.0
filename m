Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95126171B1;
	Thu,  3 Sep 2026 01:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788398888; cv=none; b=ViiAH3p7zugngozPiPXgpCtfdhgvmbi3k+bjzex+za4fqTtCYPzGae31qwDrEOFhFsjnOTx8x4R+O3SqHQxxY7EBsBGnw2lZUObMIgync2sGQIR+6PzKZrn6IVFTb/P50Vjvkoi1rYBaWsMoJjx/bIumvzXdpDgNuT0HcF1qnWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788398888; c=relaxed/simple;
	bh=mXl4nV02DIkoU9EW05M/ZICcMk38AfMVdgtQzrtmicY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OvesfdMzIrggFy8sGIMXe1WUcxEd55NcJEx8e8uQ8f0E87lbYUA3cY1+3hHMk5B76eVn4YDqduUc346x/q3EC3vg9KGDN16emJtv1aqPwo6aLw5Pxbx05vrm0Tr1LNYRP87gvZhXRnchnqAadzcTTKlhRBT3gvwbgv5PfCCYlx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XaB1eERK; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XaB1eERK"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682NVg7w1472100;
	Thu, 3 Sep 2026 01:28:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=MOYDww
	w5UbDPQDuCOnc4C6bpM7ArImYjmh7y2/UGN08=; b=XaB1eERKnLh7ISIZ60Q3VI
	fd7NwdaGH4JrS0Oo+ScKXK3p7nj+BrRO6offp1AmFR8n6fMoK7OoD246eAOLSHPg
	E4p7b3A1HAOnBJZ04fb0jghygOltEj4b5601SssELbfmlzK48Jv2Kpahc2jofwmx
	cBSxaYCsZ5n9rqkx8IiHwFNXZ1daDroS5e5zkIELn1qwPVDcfLA/EifEmsvEjz0K
	S/W2CvgGp5l0TFg8xcLOFWf2vd2EiQvEM+fgD4FwmT2IQOI8kQjJ8vG5aD/HMdrw
	m3qc4nelfaEmwu2OW60ia2xkaL1trbVVUV+7cOS47TPPiFrZm7Nmx9fJR+1CBlqw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq2thxx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 01:27:59 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6831QHW3012383;
	Thu, 3 Sep 2026 01:27:59 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcb8hncfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 01:27:59 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6831RwUb7209622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Sep 2026 01:27:58 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 06D385805E;
	Thu,  3 Sep 2026 01:27:58 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6BB6858055;
	Thu,  3 Sep 2026 01:27:57 +0000 (GMT)
Received: from [9.61.27.13] (unknown [9.61.27.13])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  3 Sep 2026 01:27:57 +0000 (GMT)
Message-ID: <9873559a-59df-4f4c-b653-6930636096a6@linux.ibm.com>
Date: Wed, 2 Sep 2026 18:27:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scsi: ibmvfc: Add Kconfig dependency on NVME_FC to prevent link
 failure
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        pavrampu <pavrampu@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        brking@linux.ibm.com, linux-kernel@vger.kernel.org,
        davemarq@linux.ibm.com
References: <327877a29337aa526cc50ac88fbddb86@linux.ibm.com>
 <afd6fdc7-0fae-4fcf-b30a-a69294d26576@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <afd6fdc7-0fae-4fcf-b30a-a69294d26576@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=bc1bluPB c=1 sm=1 tr=0 ts=6a98cd1f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=KZpsQks5LnckocmEDf0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDAwNyBTYWx0ZWRfX4W1QbXC2jI+E
 QGXCBnyRyrSdRn7OLNmE1v/PkbReLkQvlNRoP+jdA+adMSHtZMXTUznPIltvPLtQZzMsKkGzwmK
 +vC4Q3K5gIgF319T29lB10TFkTvorCk=
X-Proofpoint-ORIG-GUID: rRVE2T7NeSMiPmS2OLRgAJ9Xs7Hfm7_w
X-Proofpoint-GUID: rRVE2T7NeSMiPmS2OLRgAJ9Xs7Hfm7_w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDAwNyBTYWx0ZWRfX/P/b5dkJmOol
 YRmf4Fw0KOn4+snJxI9c5cO3JFTPyjel+HQKuHJcBQuVCR0XFSETn2PmMlqy2rZCjx6CvWH5iKV
 r9UbE+BChG8l4CW9k/rOw9ygap4b2CUj0byN/eJx5/qF1T87WmMbzvvk5ECVqZZiNwm+XT+Y7B2
 Z46FPQVB6z9ZBWUz65muB7WbiWJ47VFTQhI/gU90moKTIASTQuv4pRDQ6azf/6QsP/BijyhvkMc
 s7LftFllxREayr0LFn4/dkro0OZ+mqlktib/HxWxgeqKkQjK4CEHfDaq58HwJJdkACfrnHmUnAe
 MKg5/NUhqW9HB+Nfx9LCgPWdZcYPIX5f0xaYpK52g+UP5VIGzm/VTW59ae0FnR4V0KydZV097SI
 7l+tt8pBC62o2/cZqV+l7eMlBoht0aOzojns45kBJRoYjlHa5p+7deZI0TTrr8O+LJjnmMYvjWm
 dT8PoGuuukm6ROBNhZA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_06,2026-09-02_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609030007

On 9/2/26 1:40 AM, Venkat Rao Bagalkote wrote:
> 
> On 02/09/26 1:55 pm, pavrampu wrote:
>> Hi,
>>
>> I am seeing below build failure with latest linux-next repo.
>>
>> Description:
>>
>> Building the kernel with CONFIG_SCSI_IBMVFC=y and CONFIG_NVME_FC=m results in
>> a link failure when building vmlinux:
>>
>> Build failure logs:
>>
>> ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function
>> `ibmvfc_nvme_register_remoteport':
>> ibmvfc-nvme.c:488: undefined reference to `nvme_fc_register_remoteport'
>> ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function
>> `ibmvfc_nvme_unregister_remoteport':
>> ibmvfc-nvme.c:515: undefined reference to `nvme_fc_unregister_remoteport'
>> ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function `ibmvfc_nvme_register':
>> ibmvfc-nvme.c:536: undefined reference to `nvme_fc_register_localport'
>> ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function `ibmvfc_nvme_unregister':
>> ibmvfc-nvme.c:565: undefined reference to `nvme_fc_unregister_localport'
>> ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function `ibmvfc_nvme_unregister':
>> ibmvfc-nvme.c:565: undefined reference to `nvme_fc_unregister_localport'
>> ld: drivers/scsi/ibmvscsi/ibmvfc-core.c:6798: undefined reference to
>> `nvme_fc_rescan_remoteport'
> 
> 
> Below simple check in Kconfig fixes the build failure.
> 
> If this is acceptable, then I will send a formal patch.

Yep, need to force ibmvfc to be a module when NVME_FC isn't builtin, or NVME_FC
must be disabled.

-Tyrel
> 
> # git diff
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 4a2af0f702e1..6612d5d445e2 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -753,6 +753,7 @@ config SCSI_IBMVFC
>         tristate "IBM Virtual FC support"
>         depends on PPC_PSERIES && SCSI
>         depends on SCSI_FC_ATTRS
> +      depends on NVME_FC || NVME_FC=n
>         help
>           This is the IBM POWER Virtual FC Client
> 
> 
> Regards,
> 
> Venkat.
> 
>>
>> If you happen to fix this, please add below tag.
>>
>> Reported-by: Pavithra <pavrampu@linux.ibm.com>
>>
>> Thanks,
>> Pavithra
> 

