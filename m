From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V2 05/24] aacraid: Retrieve and update the device types
Date: Thu, 26 Jan 2017 09:59:52 +0100
Message-ID: <20170126085952.GG3591@linux-x5ow.site>
References: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170125180111.25401-6-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36619 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752875AbdAZI7z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 03:59:55 -0500
Content-Disposition: inline
In-Reply-To: <20170125180111.25401-6-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

On Wed, Jan 25, 2017 at 10:00:52AM -0800, Raghava Aditya Renukunta wrote:
> This patch adds support to retrieve the type of each adapter connected
> device. Applicable to HBA1000 and SmartIOC2000 products
> 
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> 
> ---

[...]

>  /*
>   *	Adapter Information Block
>   *
> @@ -1056,7 +1091,28 @@ struct aac_supplement_adapter_info
>  	/* StructExpansion == 1 */
>  	__le32	FeatureBits3;
>  	__le32	SupportedPerformanceModes;
> -	__le32	ReservedForFutureGrowth[80];
> +	u8	HostBusType;		/* uses HOST_BUS_TYPE_xxx defines */
> +	u8	HostBusWidth;		/* actual width in bits or links */
> +	u16	HostBusSpeed;		/* actual bus speed/link rate in MHz */
> +	u8	MaxRRCDrives;		/* max. number of ITP-RRC drives/pool */
> +	u8	MaxDiskXtasks;		/* max. possible num of DiskX Tasks */
> +
> +	u8	CpldVerLoaded;
> +	u8	CpldVerInFlash;
> +
> +	__le64	MaxRRCCapacity;
> +	__le32	CompiledMaxHistLogLevel;
> +	u8	CustomBoardName[12];
> +	u16	SupportedCntlrMode;	/* identify supported controller mode */
> +	u16	ReservedForFuture16;
> +	__le32	SupportedOptions3;	/* reserved for future options */
> +
> +	__le16	VirtDeviceBus;		/* virt. SCSI device for Thor */
> +	__le16	VirtDeviceTarget;
> +	__le16	VirtDeviceLUN;
> +	__le16	Unused;
> +	__le32	ReservedForFutureGrowth[68];
> +

:-(

Appart from that,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
