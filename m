Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB568F6D
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 02:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722909889; cv=none; b=NgVZP38DNGSRx8UVmZhu+tqyRefAjoftny32sw1i5oBLYYwqeMikCXfwD9o6Vgdvww3CPiNDGC5ONeT0NDTZ1MtK1KziYMkvhtuncFPfr8BhjNeIedY5lRgXZMJn0MFVfoh6E/5tR2QcPTtnrKwvjJ8paxqWYCHBPWOmZOoUsZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722909889; c=relaxed/simple;
	bh=iPlTmklNFO8quaKBrw9Ux98RUrKz2LJF8gWS8xbcp68=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=FnLUz10VDW/fecvUpc/B2sbEmJm3NUKwkeKqusV3UnoRuDlWg/9c0cCy0i3pKMmlBIE3uuE375NNytygSMo5OKFcYHjJaqs9CFpGoNtiCHrIKKiXe1PXMkXoxfMB0047j0aCD5h1Jhg752f1QX9KovIGo5KbrhmGAeu58m0JZY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=oPd53QJP; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oPd53QJP"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240806020443epoutp026109f01c7a6e0fbf0cd37dbd9d94b5c5~pAWkaIVlE0132201322epoutp02Y
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 02:04:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240806020443epoutp026109f01c7a6e0fbf0cd37dbd9d94b5c5~pAWkaIVlE0132201322epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1722909883;
	bh=mjOFdIZ4+oy6JbxVkZV/Ap2mouHD6+CoUeSjtJBrFiw=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=oPd53QJPZMT6buzq16AmFNfu2o2M8LDQXDwhOzgL9QciIiGZhY9HgULgPTW47LMQ2
	 yetO+VhZRO8a+pDA8NVC7HaFOTxyMnhX+M93tfsaVY73Ih8aws2IEtWe/h/OPUh+f+
	 Js5hZrrroAIHArkZkpAKelED8UxxnC9kwHdu+2+k=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20240806020443epcas2p3239ab413790b8da21fef2d8eca095d18~pAWkL2EiF1427714277epcas2p3Q;
	Tue,  6 Aug 2024 02:04:43 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.70]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WdGpL23C1z4x9QD; Tue,  6 Aug
	2024 02:04:42 +0000 (GMT)
X-AuditID: b6c32a45-ffffa700000028bf-fa-66b184b97311
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	AC.87.10431.9B481B66; Tue,  6 Aug 2024 11:04:41 +0900 (KST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: [PATCH v2 1/2] scsi: ufs: Prepare to add HCI capabilities sysfs
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From: Keoseong Park <keosung.park@samsung.com>
To: Avri Altman <avri.altman@wdc.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bart Van
	Assche <bvanassche@acm.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20240804072109.2330880-2-avri.altman@wdc.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240806020441epcms2p177c881111c1a427c33dcddcc9942d790@epcms2p1>
Date: Tue, 06 Aug 2024 11:04:41 +0900
X-CMS-MailID: 20240806020441epcms2p177c881111c1a427c33dcddcc9942d790
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdljTVHdny8Y0g5kbFCxe/rzKZjHtw09m
	i5eHNC0e3X7GaHF51xw2i+7rO9gslh//x+TA7nH5irfHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBr
	VLZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtARSgpl
	iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwC8wK94sTc4tK8dL281BIrQwMDI1OgwoTs
	jA2X9jIXrBKvuDOpmamB8atQFyMnh4SAicTP3zPYQWwhgR2MEssOeXcxcnDwCghK/N0hDBIW
	FvCRuLtmHzNEiZJE18KtzBBxA4l10/eA2WwCehJTft9hBLFFBKIljs7bDWRzcTALLGOU+Nh/
	ngViF6/EjPanULa0xPblWxlBdnEKWEusm8UNEdaQ+LGslxnCFpW4ufotO4z9/th8RghbRKL1
	3lmoGkGJBz93Q8UlJM59WAg1vl6i9f0pdpAbJAQmMEo0HvsDNUhf4lrHRrAiXgFfiedP3rOC
	2CwCqhJHpnyCqnGRmDF7C9gCZgF5ie1v5zCD3MksoCmxfpc+iCkhoCxx5BYLRAWfRMfhv+ww
	HzZs/I2VvWPeEyYIW03i0YItrBMYlWchAnoWkl2zEHYtYGRexSiWWlCcm55abFRgCI/a5Pzc
	TYzg1KjluoNx8tsPeocYmTgYDzFKcDArifB2lW5IE+JNSaysSi3Kjy8qzUktPsRoCvTlRGYp
	0eR8YHLOK4k3NLE0MDEzMzQ3MjUwVxLnvdc6N0VIID2xJDU7NbUgtQimj4mDU6qBqdExbXmt
	tK2nesjp1PUhFnx1q5lDHT89/PyG1e14uSbr61fSPma+pQre51j+NOSprGgwqz12teK+0X7m
	6ucH6r79NKq4GJ9bmKC0PUvodGQSW+alh24cS88snKkXZrO5sH5r3Sbjv5P6V1TZPjE+8E/D
	dtbF02VW+m+EUw6s6uDYdO/rtdUBz38esJw3uyl2ww2tMAGdqXLW1zVj7HdqmLYu/vD4o6pm
	kXnlGpc3X4K3Oe5l/S0eezPxv3rZBddLirUW52fZzVx7hP9IqUrC46ffi84dW6iZuyLec4HQ
	mRDdzwUOO+49L2bdNU8ySHyCwiNxwfxrek3tv88smPBmjY5074b3D2x2Lg+ZxGL0X4mlOCPR
	UIu5qDgRAFOeeWgWBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240804072309epcas2p2309ebc15f20ca598a91fe30a3245200f
References: <20240804072109.2330880-2-avri.altman@wdc.com>
	<20240804072109.2330880-1-avri.altman@wdc.com>
	<CGME20240804072309epcas2p2309ebc15f20ca598a91fe30a3245200f@epcms2p1>

Hi Avri,

> Prepare so we'll be able to read various other HCI registers.
> While at it, fix the HCPID & HCMID register names to stand for what they
> really are. Also replace the pm_runtime_{get/put}_sync() calls in
> auto_hibern8_show to ufshcd_rpm_{get/put}_sync() as any host controller
> register reads should.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/ufs/core/ufs-sysfs.c | 38 +++++++++++++++++++++---------------
>  include/ufs/ufshci.h         |  5 +++--
>  2 files changed, 25 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index e80a32421a8c..dec7746c98e0 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -198,6 +198,24 @@ static u32 ufshcd_us_to_ahit(unsigned int timer)
>  	       FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, scale);
>  }
>  
> +static int ufshcd_read_hci_reg(struct ufs_hba *hba, u32 *val, unsigned int reg)
> +{
> +	down(&hba->host_sem);
> +	if (!ufshcd_is_user_access_allowed(hba)) {
> +		up(&hba->host_sem);
> +		return -EBUSY;
> +	}
> +
> +	ufshcd_rpm_get_sync(hba);
> +	ufshcd_hold(hba);
> +	*val = ufshcd_readl(hba, reg);
> +	ufshcd_release(hba);
> +	ufshcd_rpm_put_sync(hba);
> +
> +	up(&hba->host_sem);
> +	return 0;
> +}
> +
>  static ssize_t auto_hibern8_show(struct device *dev,
>  				 struct device_attribute *attr, char *buf)
>  {
> @@ -208,23 +226,11 @@ static ssize_t auto_hibern8_show(struct device *dev,
>  	if (!ufshcd_is_auto_hibern8_supported(hba))
>  		return -EOPNOTSUPP;
>  
> -	down(&hba->host_sem);
> -	if (!ufshcd_is_user_access_allowed(hba)) {
> -		ret = -EBUSY;
> -		goto out;
> -	}
> -
> -	pm_runtime_get_sync(hba->dev);
> -	ufshcd_hold(hba);
> -	ahit = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
> -	ufshcd_release(hba);
> -	pm_runtime_put_sync(hba->dev);
> -
> -	ret = sysfs_emit(buf, "%d\n", ufshcd_ahit_to_us(ahit));
> +	ret = ufshcd_read_hci_reg(hba, &ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +	if (ret)
> +		return ret;
>  
> -out:
> -	up(&hba->host_sem);
> -	return ret;
> +	return sysfs_emit(buf, "%d\n", ufshcd_ahit_to_us(ahit));
>  }
>  
>  static ssize_t auto_hibern8_store(struct device *dev,
> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index 38fe97971a65..194e3655902e 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -25,8 +25,9 @@ enum {
>  	REG_CONTROLLER_CAPABILITIES		= 0x00,
>  	REG_MCQCAP				= 0x04,
>  	REG_UFS_VERSION				= 0x08,
> -	REG_CONTROLLER_DEV_ID			= 0x10,
> -	REG_CONTROLLER_PROD_ID			= 0x14,
> +	REG_EXT_CONTROLLER_CAPABILITIES		= 0x0C,
> +	REG_CONTROLLER_PID			= 0x10,
> +	REG_CONTROLLER_MID			= 0x14,
>  	REG_AUTO_HIBERNATE_IDLE_TIMER		= 0x18,
>  	REG_INTERRUPT_STATUS			= 0x20,
>  	REG_INTERRUPT_ENABLE			= 0x24,
> -- 
> 2.25.1

Looks good to me.

Reviewed-by: Keoseong Park <keosung.park@samsung.com>

Best Regards,
Keoseong
