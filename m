Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DAA1AAE33;
	Tue, 10 Dec 2024 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733842794; cv=none; b=TGBmuYdERLDo1Im3ylGwQecs0KNao3/R4rb7YwZkMrpDYKGC73vXKjxguHeO05PAuEeS1hhJiTnNcDkPDcfQAySXmgeORvF3tU+AUZ5fqJ2NFFENvSDyXTMnNBLhS2n08p368qWm8gUL1hqUpJ1pu5K1WGXn06rjLYhnCDRjruE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733842794; c=relaxed/simple;
	bh=6zwrH7NOfsoHfQqIznKg1azt1RDvRgkouT0IH9qiPds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t2CJ7ugAN2idve59tuAkW3QHd90HZG8rgz5CNPeQ5guqqHUzQautSkP0V3tYp0Qd9g9KLOMHGdDtbcSaQFvRctYqITyQMe9fztWnDQRdqVCg7jYsUM4PI+EYhx6cpOWK3wWcLH+sk90b9V9t5pMuz3FxTW2kKAbs7j/JqIQN1w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mLAbg/b7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mLAbg/b7"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BADrYSi007192;
	Tue, 10 Dec 2024 14:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Afsg7V
	UbuAH53aaPeUSfI9JRaF+ZQPD2bSYYkrMcSHA=; b=mLAbg/b75n3LOq/fpaAKSv
	UIChmJmuQRl77kBh5TFnhWqiL2cGRk5I1GC495Be4XfrOoXah8qoB/WRONoUBKNi
	8oFvzvEsbABkliVsYi+MZb+WljI1oHNaUCTg4joR+YM7y9ZGFLjc4TDMMNM8i2V9
	rRy6RlUliP1HxkUL3Mofq3+UyWL8j5GzCBivc4sJK+0A4uxeHLnDyMM/3hp3Qg1q
	jRdUnPxrZkVEa8JYuYxgXruqWeuiu+c61irH4ma5ukZGxF76d0arRrrqjT27eRQI
	nrKLxnclUQ94rbfotBjfMFmZIxXJmJMe1GiTKDh9M7PlsL+YH+gjhvNRR9KePzdA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cdv8qr78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 14:59:46 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BAB2eXn016911;
	Tue, 10 Dec 2024 14:59:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43d12y4900-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 14:59:45 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BAExdEX42533140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 14:59:40 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB83120040;
	Tue, 10 Dec 2024 14:59:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FE492004D;
	Tue, 10 Dec 2024 14:59:39 +0000 (GMT)
Received: from [9.84.194.138] (unknown [9.84.194.138])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Dec 2024 14:59:39 +0000 (GMT)
Message-ID: <bdba3042-4654-4e09-9060-57445ccac09c@linux.ibm.com>
Date: Tue, 10 Dec 2024 15:59:39 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] cxl: Deprecate driver
To: Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ukrishn@linux.ibm.com, manoj@linux.ibm.com,
        clombard@linux.ibm.com, vaibhav@linux.ibm.com
References: <20241210054055.144813-1-ajd@linux.ibm.com>
 <20241210054055.144813-2-ajd@linux.ibm.com>
Content-Language: en-US
From: Frederic Barrat <fbarrat@linux.ibm.com>
In-Reply-To: <20241210054055.144813-2-ajd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R7fSBkR1R2cVa9KkSkNJz3oqMbgnzCZj
X-Proofpoint-ORIG-GUID: R7fSBkR1R2cVa9KkSkNJz3oqMbgnzCZj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 spamscore=0 clxscore=1011 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412100112



On 10/12/2024 06:40, Andrew Donnellan wrote:
> The cxl driver is no longer actively maintained and we intend to remove it
> in a future kernel release.
> 
> cxl has received minimal maintenance for several years, and is not
> supported on the Power10 processor. We aren't aware of any users who are
> likely to be using recent kernels.
> 
> Change its MAINTAINERS status to obsolete, update the sysfs ABI
> documentation accordingly, add a warning message on device probe, change
> the Kconfig options to label it as deprecated, and don't build it by
> default.
> 
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>


Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>

   Fred


> ---
>   Documentation/ABI/{testing => obsolete}/sysfs-class-cxl | 3 +++
>   MAINTAINERS                                             | 4 ++--
>   drivers/misc/cxl/Kconfig                                | 6 ++++--
>   drivers/misc/cxl/of.c                                   | 2 ++
>   drivers/misc/cxl/pci.c                                  | 2 ++
>   5 files changed, 13 insertions(+), 4 deletions(-)
>   rename Documentation/ABI/{testing => obsolete}/sysfs-class-cxl (99%)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-cxl b/Documentation/ABI/obsolete/sysfs-class-cxl
> similarity index 99%
> rename from Documentation/ABI/testing/sysfs-class-cxl
> rename to Documentation/ABI/obsolete/sysfs-class-cxl
> index cfc48a87706b..8cba1b626985 100644
> --- a/Documentation/ABI/testing/sysfs-class-cxl
> +++ b/Documentation/ABI/obsolete/sysfs-class-cxl
> @@ -1,3 +1,6 @@
> +The cxl driver is no longer maintained, and will be removed from the kernel in
> +the near future.
> +
>   Please note that attributes that are shared between devices are stored in
>   the directory pointed to by the symlink device/.
>   For example, the real path of the attribute /sys/class/cxl/afu0.0s/irqs_max is
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 17daa9ee9384..1737a8ff4f2b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6228,8 +6228,8 @@ CXL (IBM Coherent Accelerator Processor Interface CAPI) DRIVER
>   M:	Frederic Barrat <fbarrat@linux.ibm.com>
>   M:	Andrew Donnellan <ajd@linux.ibm.com>
>   L:	linuxppc-dev@lists.ozlabs.org
> -S:	Supported
> -F:	Documentation/ABI/testing/sysfs-class-cxl
> +S:	Obsolete
> +F:	Documentation/ABI/obsolete/sysfs-class-cxl
>   F:	Documentation/arch/powerpc/cxl.rst
>   F:	arch/powerpc/platforms/powernv/pci-cxl.c
>   F:	drivers/misc/cxl/
> diff --git a/drivers/misc/cxl/Kconfig b/drivers/misc/cxl/Kconfig
> index 5efc4151bf58..15307f5e4307 100644
> --- a/drivers/misc/cxl/Kconfig
> +++ b/drivers/misc/cxl/Kconfig
> @@ -9,11 +9,13 @@ config CXL_BASE
>   	select PPC_64S_HASH_MMU
>   
>   config CXL
> -	tristate "Support for IBM Coherent Accelerators (CXL)"
> +	tristate "Support for IBM Coherent Accelerators (CXL) (DEPRECATED)"
>   	depends on PPC_POWERNV && PCI_MSI && EEH
>   	select CXL_BASE
> -	default m
>   	help
> +	  The cxl driver is deprecated and will be removed in a future
> +	  kernel release.
> +
>   	  Select this option to enable driver support for IBM Coherent
>   	  Accelerators (CXL).  CXL is otherwise known as Coherent Accelerator
>   	  Processor Interface (CAPI).  CAPI allows accelerators in FPGAs to be
> diff --git a/drivers/misc/cxl/of.c b/drivers/misc/cxl/of.c
> index cf6bd8a43056..e26ee85279fa 100644
> --- a/drivers/misc/cxl/of.c
> +++ b/drivers/misc/cxl/of.c
> @@ -295,6 +295,8 @@ int cxl_of_probe(struct platform_device *pdev)
>   	int ret;
>   	int slice = 0, slice_ok = 0;
>   
> +	dev_err_once(&pdev->dev, "DEPRECATION: cxl is deprecated and will be removed in a future kernel release\n");
> +
>   	pr_devel("in %s\n", __func__);
>   
>   	np = pdev->dev.of_node;
> diff --git a/drivers/misc/cxl/pci.c b/drivers/misc/cxl/pci.c
> index 3d52f9b92d0d..92bf7c5c7b35 100644
> --- a/drivers/misc/cxl/pci.c
> +++ b/drivers/misc/cxl/pci.c
> @@ -1726,6 +1726,8 @@ static int cxl_probe(struct pci_dev *dev, const struct pci_device_id *id)
>   	int slice;
>   	int rc;
>   
> +	dev_err_once(&dev->dev, "DEPRECATED: cxl is deprecated and will be removed in a future kernel release\n");
> +
>   	if (cxl_pci_is_vphb_device(dev)) {
>   		dev_dbg(&dev->dev, "cxl_init_adapter: Ignoring cxl vphb device\n");
>   		return -ENODEV;

