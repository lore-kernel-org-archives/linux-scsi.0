Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D23C1AAA38;
	Tue, 10 Dec 2024 15:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733842823; cv=none; b=EKGnyBGn0deq1rain7xvfivibZFlchEiu+heQe6CdtWKGhMY9L5KJ/AnI1EMO4Cbo6Z3TXKEqN2Srf2KX27Mlo4O4EyWsJ+gv7vIE1eU0jTGggAuIc7hGF3PVuBeKUKgsRD5V4EfI3xUf1gPue9Z71oWmFUYfJyxuyubXEsNVbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733842823; c=relaxed/simple;
	bh=GL1junYsyzA1VSizXEiCYuYBKw/hxXCS28XsnjC6IyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lCe8Nva7bBY8kKKsA3tw1NJSBdt9p3S0ir9ePLY3RqZHhn7SqHjzr/v4eWIkme4kxRnzLDlXZCt7heQAJOT8104io5Vtq3ivAZnlN7AnMbE1m0YaORR9E1W40DPzZW/KZ4waU1ojEixEHxxa+ryzFRinMpgRM3Hscp+AQ1dT69Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=r5QTC2uH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="r5QTC2uH"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BADrXV5007142;
	Tue, 10 Dec 2024 15:00:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=SJU8SN
	WmHaZ9llf7g2WxAqh6wC7z21api+tXgzpzdqE=; b=r5QTC2uHS9YD2jK6/eDeym
	gNe9ahdqYTmqn264Utu93rRZrakCqHj49qGhY/2dEF4Hiz4zTDwxaXHMtRCPWCm2
	jDXMZXd46A8GuyXSr16w/Jq6p9mqpUOb01Z4JYXA0mK4DZKR2T/AUrOplsz3dxeT
	TFPjkRBXeOo2AgyJo3QsJyTytOMWl02HsDTZxZMUJZw831PlbNjLcQeadNiq8l/v
	cpNxjgdWhS43Jy5dypllZhMKi+QYx1FFgFvVHsfcJxeQVMoWOQaBb61OeCEIjVJ7
	UeyJ6ovHLuLAgi0klmUnbmTzO8xp9SwXLqk3T9beTbZTSBuhVbMi3WiPm1l3Z2vw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cdv8qr9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 15:00:18 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BADB4e9023015;
	Tue, 10 Dec 2024 15:00:17 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 43d2wjut15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 15:00:17 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BAF0BuG35258810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 15:00:11 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6AA92004B;
	Tue, 10 Dec 2024 15:00:11 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 88A4B2004F;
	Tue, 10 Dec 2024 15:00:11 +0000 (GMT)
Received: from [9.84.194.138] (unknown [9.84.194.138])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Dec 2024 15:00:11 +0000 (GMT)
Message-ID: <944fe21c-4d53-4eae-98af-60706184eda9@linux.ibm.com>
Date: Tue, 10 Dec 2024 16:00:11 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi/cxlflash: Deprecate driver
To: Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ukrishn@linux.ibm.com, manoj@linux.ibm.com,
        clombard@linux.ibm.com, vaibhav@linux.ibm.com
References: <20241210054055.144813-1-ajd@linux.ibm.com>
 <20241210054055.144813-3-ajd@linux.ibm.com>
Content-Language: en-US
From: Frederic Barrat <fbarrat@linux.ibm.com>
In-Reply-To: <20241210054055.144813-3-ajd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qL-RSgeW01Rz__y-PTiTZ6gLquCQc8JI
X-Proofpoint-ORIG-GUID: qL-RSgeW01Rz__y-PTiTZ6gLquCQc8JI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 spamscore=0 clxscore=1011 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=737
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412100112



On 10/12/2024 06:40, Andrew Donnellan wrote:
> We intend to remove the cxlflash driver in an upcoming release. It is
> already marked as Obsolete in MAINTAINERS.
> 
> The cxlflash driver has received minimal maintenance for some time, and
> the CAPI Flash hardware that uses it is no longer commercially available.
> 
> Add a warning message on probe and change Kconfig to label the driver as
> deprecated and not build the driver by default.
> 
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>


Reviewed-by: Frederic Barrat <fbarrat@linux.ibm.com>

   Fred

> ---
>   drivers/scsi/cxlflash/Kconfig | 6 ++++--
>   drivers/scsi/cxlflash/main.c  | 2 ++
>   2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/cxlflash/Kconfig b/drivers/scsi/cxlflash/Kconfig
> index 5533bdcb0458..c424d36e89a6 100644
> --- a/drivers/scsi/cxlflash/Kconfig
> +++ b/drivers/scsi/cxlflash/Kconfig
> @@ -4,10 +4,12 @@
>   #
>   
>   config CXLFLASH
> -	tristate "Support for IBM CAPI Flash"
> +	tristate "Support for IBM CAPI Flash (DEPRECATED)"
>   	depends on PCI && SCSI && (CXL || OCXL) && EEH
>   	select IRQ_POLL
> -	default m
>   	help
> +	  The cxlflash driver is deprecated and will be removed in a future
> +	  kernel release.
> +
>   	  Allows CAPI Accelerated IO to Flash
>   	  If unsure, say N.
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 60d62b93d624..62806f5e32e6 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -3651,6 +3651,8 @@ static int cxlflash_probe(struct pci_dev *pdev,
>   	int rc = 0;
>   	int k;
>   
> +	dev_err_once(&pdev->dev, "DEPRECATION: cxlflash is deprecated and will be removed in a future kernel release\n");
> +
>   	dev_dbg(&pdev->dev, "%s: Found CXLFLASH with IRQ: %d\n",
>   		__func__, pdev->irq);
>   

