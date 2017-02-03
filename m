From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/4] sg: disable SET_FORCE_LOW_DMA
Date: Fri, 3 Feb 2017 10:32:28 +0100
Message-ID: <56d69348-13e0-8daa-9fac-942033ab564a@suse.de>
References: <1486112091-68470-1-git-send-email-hare@suse.de>
 <1486112091-68470-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41935 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751958AbdBCJcc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 04:32:32 -0500
In-Reply-To: <1486112091-68470-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


On 02/03/2017 09:54 AM, Hannes Reinecke wrote:
> The ioctl SET_FORCE_LOW_DMA has never worked since the initial
> git check-in, and the respective setting is nowadays handled
> correctly.
> So disable it entirely.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---

[...]

>   	case SG_SET_FORCE_LOW_DMA:
> -		result = get_user(val, ip);
> -		if (result)
> -			return result;
> -		if (val) {
> -			sfp->low_dma = 1;
> -			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
> -				val = (int) sfp->reserve.bufflen;
> -				sg_remove_scat(sfp, &sfp->reserve);
> -				sg_build_reserve(sfp, val);
> -			}
> -		} else {
> -			if (atomic_read(&sdp->detaching))
> -				return -ENODEV;
> -			sfp->low_dma = sdp->device->host->unchecked_isa_dma;
> -		}
> -		return 0;
> +		return -EINVAL;

I'm not sure if returning a bogus '0' is better here to not break any 
existing application, which assumed it always worked.
