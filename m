From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 14/14] sd: Honor block layer integrity handling flags
Date: Mon, 01 Sep 2014 00:17:51 +0300
Message-ID: <540390FF.2040703@dev.mellanox.co.il>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com> <1409254292-2540-15-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:36749 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaHaVR4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 17:17:56 -0400
Received: by mail-wg0-f50.google.com with SMTP id x12so4580028wgg.9
        for <linux-scsi@vger.kernel.org>; Sun, 31 Aug 2014 14:17:55 -0700 (PDT)
In-Reply-To: <1409254292-2540-15-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, axboe@fb.com
Cc: hch@lst.de, sagig@mellanox.com

On 8/28/2014 10:31 PM, Martin K. Petersen wrote:
> A set of flags introduced in the block layer enable better control over
> how protection information is handled. These flags are useful for both
> error injection and data recovery purposes. Checking can be enabled and
> disabled for controller and disk, and the guard tag format is now a
> per-I/O property.
>

Hi Martin,

Not sure why I didn't post a review for this one...
Anyway sorry, I hope it's not too late...
just two comments below.

> Update sd_protect_op to communicate the relevant information to the
> low-level device driver via a set of flags in scsi_cmnd.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   drivers/scsi/sd.c        | 73 ++++++++++++++++++++++++++++--------------------
>   drivers/scsi/sd.h        | 66 +++++++++++++++++++++++++++++++++++++++++--
>   drivers/scsi/sd_dif.c    | 23 ++++++---------
>   include/scsi/scsi_cmnd.h | 36 +++++++++++++++++-------
>   4 files changed, 142 insertions(+), 56 deletions(-)
>

<SNIP>

> +/*
> + * Returns a mask of the protection flags that are valid for a given DIX
> + * operation.
> + */
> +static inline unsigned int sd_prot_flag_mask(unsigned int prot_op)
> +{
> +	const unsigned int flag_mask[] = {
> +		[SCSI_PROT_NORMAL]		= 0,
> +
> +		[SCSI_PROT_READ_STRIP]		= SCSI_PROT_TRANSFER_PI |
> +						  SCSI_PROT_GUARD_CHECK |
> +						  SCSI_PROT_REF_CHECK |
> +						  SCSI_PROT_REF_INCREMENT,
> +
> +		[SCSI_PROT_READ_INSERT]		= SCSI_PROT_REF_INCREMENT |
> +						  SCSI_PROT_IP_CHECKSUM,
> +
> +		[SCSI_PROT_READ_PASS]		= SCSI_PROT_TRANSFER_PI |
> +						  SCSI_PROT_GUARD_CHECK |
> +						  SCSI_PROT_REF_CHECK |
> +						  SCSI_PROT_REF_INCREMENT |
> +						  SCSI_PROT_IP_CHECKSUM,
> +
> +		[SCSI_PROT_WRITE_INSERT]	= SCSI_PROT_TRANSFER_PI |
> +						  SCSI_PROT_REF_INCREMENT,
> +
> +		[SCSI_PROT_WRITE_STRIP]		= SCSI_PROT_GUARD_CHECK |
> +						  SCSI_PROT_REF_CHECK |
> +						  SCSI_PROT_REF_INCREMENT |
> +						  SCSI_PROT_IP_CHECKSUM,
> +
> +		[SCSI_PROT_WRITE_PASS]		= SCSI_PROT_TRANSFER_PI |
> +						  SCSI_PROT_GUARD_CHECK |
> +						  SCSI_PROT_REF_CHECK |
> +						  SCSI_PROT_REF_INCREMENT |
> +						  SCSI_PROT_IP_CHECKSUM,

A bit strange to me that you put REF_CHECK & REF_INCREMENT flag
depending on the prot_op while it really depends on the prot_type.
It is &'nd with preset scmnd->prot_flags anyways.. so no worries...

> +	};
> +
> +	return flag_mask[prot_op];
> +}
> +

<SNIP>

> +/*
> +enum scsi_prot_flags {
> +	SCSI_PROT_TRANSFER_PI		= 1 << 0,
> +	SCSI_PROT_GUARD_CHECK		= 1 << 1,
> +	SCSI_PROT_REF_CHECK		= 1 << 2,
> +	SCSI_PROT_REF_INCREMENT		= 1 << 3,
> +	SCSI_PROT_IP_CHECKSUM		= 1 << 4,

I have a question here,
What are your plans with explicit ref/app escape flags?
Were these just left behind on this series?


Other than that, looks good.

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>

Sagi.
