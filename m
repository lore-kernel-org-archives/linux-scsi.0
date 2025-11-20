Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E237330B03
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 12:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763640445; cv=none; b=utXtwA9HUrGoYiEWxxQtcp95pFcjeearZe2o45PzzpnkXqh8uYk222eazGjHLV9hG+5HW8tY8Fd1GfEUR8K9DrN9wD2O+n1RqYauXos6LFMmxjiOBuMkCfTM6SUWvQazD0KkNRH/MGgLSGtrFDqxqUAq1bGs00Ve01/LnHR5sIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763640445; c=relaxed/simple;
	bh=g9ajC52WCvLvBV8xT7zxZvL3Erd9bjm+j62g4t78Ras=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=uS7NCOKCRLkEGcy8GPeDUMrQsaxlZGUkXADiZLx5i3UE75XELtEpVV4pP2hqwiyxzAFLlBc1EaFxED6cJUVYpnxCKZZyNg41ZrEjfz+EPtdf3Ju/oZUobSLqLT8/92OHHxH3Nap4q1PRbsaRTwISZPhfdj/yJlbyEcCfTii4egE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id E6471180F2C0;
	Thu, 20 Nov 2025 13:07:06 +0100 (CET)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id NN+zN2oEH2nxYjsAKEJqOA
	(envelope-from <lukas@herbolt.com>); Thu, 20 Nov 2025 13:07:06 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 20 Nov 2025 13:07:06 +0100
From: lukas@herbolt.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi: sd: Rounddown host->opt_sectors to logical
In-Reply-To: <yq1ecpt9yqb.fsf@ca-mkp.ca.oracle.com>
References: <20251114102853.1476938-2-lukas@herbolt.com>
 <20251114102853.1476938-4-lukas@herbolt.com>
 <yq1ecpt9yqb.fsf@ca-mkp.ca.oracle.com>
Message-ID: <75b29f2e38d88e5cfb246500c793a085@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2025-11-20 04:26, Martin K. Petersen wrote:
> Lukas,
> 
>> The host->opt_sectors are by default 512 bytes aligned if we have 4KN
>> SAS disk reporting zero or smaller opt_xfer_block than the
>> host->opt_sectors we will end up with unaligned queue_limit->io_opt.
> 
> I am intrigued wrt. which controller returns a host->opt_sectors that
> would trigger this misalignment. What is the actual value reported?
> 

I have seen it on mpt3sas, I do not have the hardware in hand, but I do
not think is related to specific driver as it goes trough 
sas_host_setup()

static int sas_host_setup(struct transport_container *tc, struct device 
*dev,
                           struct device *cdev)
{
...
         if (dma_dev->dma_mask) {
                 shost->opt_sectors = min_t(unsigned int, 
shost->max_sectors,
                                 dma_opt_mapping_size(dma_dev) >> 
SECTOR_SHIFT);
         }

         return 0;
}

I have vmcore from the system.

crash> scsishow | grep ^host | grep -v ahci
host0     mpt3sas                ffff90b78c936000         
ffff90b83ac92d20         ffff90b78c9368d0
crash> Scsi_Host.opt_sectors ffff90b78c936000
       opt_sectors = 0x7fff
crash> pd 0x7fff<<9
$3 = 16776704

and lsblk output:

NAME          ALIGNMENT MIN-IO   OPT-IO PHY-SEC LOG-SEC ROTA SCHED       
RQ-SIZE    RA WSAME
sdc                   0   4096 16776704    4096    4096    1 mq-deadline 
     256 32764    0B


>> +	lim.io_opt = rounddown(lim.logical_block_size,
>> +			sdp->host->opt_sectors << SECTOR_SHIFT);
> 
> Those parameters would need to be reversed, I think. You want to round
> down opt_sectors and not the logical_block_size.

Ugh! My bad! Will send v2.
