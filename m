From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 08/12] libsas: Unknown STP devices should be reported
 to libata as unknown.
Date: Wed, 07 Feb 2007 00:20:50 -0800
Message-ID: <45C98BE2.5060608@gmail.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com> <20070130091852.31530.20090.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.230]:64965 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161408AbXBGRzt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 12:55:49 -0500
Received: by nz-out-0506.google.com with SMTP id s1so246643nze
        for <linux-scsi@vger.kernel.org>; Wed, 07 Feb 2007 09:55:49 -0800 (PST)
In-Reply-To: <20070130091852.31530.20090.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, alexisb@us.ibm.com

Darrick J. Wong wrote:
> When libsas encounters a STP device whose protocol isn't recognized (i.e.
> not ATA or ATAPI), we should set the ata_device's class to ATA_DEV_UNKNOWN
> instead of ATA_DEV_ATA.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/scsi/libsas/sas_ata.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 20f3a5e..7ebda69 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -232,7 +232,7 @@ static void sas_ata_phy_reset(struct ata
>  			SAS_DPRINTK("%s: Unknown SATA command set: %d.\n",
>  				    __FUNCTION__,
>  				    dev->sata_dev.command_set);
> -			ap->device[0].class = ATA_DEV_ATA;
> +			ap->device[0].class = ATA_DEV_UNKNOWN;

ATA_DEV_UNKNOWN currently indicates 'unclassified' state and leaving 
device as unclassified after successful reset is considered failure, so 
this is a bit confusing but you need to return ATA_DEV_NONE here. 
Hmmm... maybe libata should use ATA_DEV_UNCLASSIFIED instead.

-- 
tejun

