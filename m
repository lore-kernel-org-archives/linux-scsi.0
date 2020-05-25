Return-Path: <SRS0=b1yV=7H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDD9C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 07:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFE912071A
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 07:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388925AbgEYHHQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 May 2020 03:07:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:44636 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388904AbgEYHHQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 May 2020 03:07:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3DC62AC5B;
        Mon, 25 May 2020 07:07:17 +0000 (UTC)
Subject: Re: [RFC v2 4/6] scsi: improve scsi_device_lookup
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20200524155814.5895-1-dgilbert@interlog.com>
 <20200524155814.5895-5-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a1a1f596-de05-0819-a291-42bb0f6b2206@suse.de>
Date:   Mon, 25 May 2020 09:07:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200524155814.5895-5-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/20 5:58 PM, Douglas Gilbert wrote:
> When the __scsi_device_lookup() function is given a "ctl" (i.e. the
> latter part of "hctl" tuple), improve the loop to find a matching
> device (LU) in the given host. Rather than loop over all LUs in the
> host, first loop over all targets to find a match on "ct" then, if
> found, loop over all LUs in that target for a match on "l". These
> nested loops are better since they don't visit LUs belonging to
> non-matching targets. This improvement flows through to the locked
> version of this function, namely scsi_device_lookup().
> 
> Remove a 21 year old comment by the author that no longer seem
> relevant.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/scsi.c | 26 ++++++++++++++++++++------
>   1 file changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 0fb650aebcfb..9e7658aebdb7 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -35,7 +35,6 @@
>    *
>    *  Jiffies wrap fixes (host->resetting), 3 Dec 1998 Andrea Arcangeli
>    *
> - *  out_of_space hacks, D. Gilbert (dpg) 990608
>    */
>   
>   #include <linux/module.h>
> @@ -789,16 +788,31 @@ EXPORT_SYMBOL(scsi_device_lookup_by_target);
>   struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
>   		uint channel, uint id, u64 lun)
>   {
> -	unsigned long l_idx;
> +	unsigned long l_idx, m_idx;
> +	struct scsi_target *starg;
>   	struct scsi_device *sdev;
>   
> -	xa_for_each_marked(&shost->__devices, l_idx, sdev,
> +	if (xa_empty(&shost->__devices))
> +		return NULL;
> +	if (xa_empty(&shost->__targets))
> +		goto inconsistent;
> +	xa_for_each(&shost->__targets, l_idx, starg) {
> +		if (!(starg->id == id && starg->channel == channel))
> +			continue;
> +		xa_for_each_marked(&starg->devices, m_idx, sdev,
> +				   SCSI_XA_NON_SDEV_DEL) {
> +			if (sdev->lun == lun)
> +				return sdev;
> +		}
> +	}
> +	return NULL;
> +inconsistent:
> +	xa_for_each_marked(&shost->__devices, m_idx, sdev,
>   			   SCSI_XA_NON_SDEV_DEL) {
> -		if (sdev->channel == channel && sdev->id == id &&
> -				sdev->lun ==lun)
> +		if (sdev->id == id && sdev->channel == channel &&
> +		    sdev->lun == lun)
>   			return sdev;
>   	}
> -
>   	return NULL;
>   }
>   EXPORT_SYMBOL(__scsi_device_lookup);
> 
... and if we had been using the LUN as an index we could have using 
'xa_load()' directly without needing any loop ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
