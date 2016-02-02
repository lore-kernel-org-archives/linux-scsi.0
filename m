From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] iscsi_ibft: Always display netmask
Date: Tue, 2 Feb 2016 00:45:31 -0600
Message-ID: <56B0508B.9020003@cs.wisc.edu>
References: <cover.1453419653.git.lduncan@suse.com>
 <71c84546d99332f77d1f462d735ec1e38aa1e7ba.1453419653.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55741 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbcBBGpn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2016 01:45:43 -0500
In-Reply-To: <71c84546d99332f77d1f462d735ec1e38aa1e7ba.1453419653.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org
Cc: hare@suse.de

On 01/22/2016 01:49 PM, Lee Duncan wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Some older user-space code might rely on the netmask attribute
> being present, so we should always display it.
> This fixes a regression introduced by commit
> 0b2eb3c4060a16f3ec11a4d6d4c934e7e5d5334f.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/firmware/iscsi_ibft.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
> index 2dd1fbb8cccc..81037e5fe301 100644
> --- a/drivers/firmware/iscsi_ibft.c
> +++ b/drivers/firmware/iscsi_ibft.c
> @@ -464,14 +464,8 @@ static umode_t ibft_check_nic_for(void *data, int type)
>  			rc = S_IRUGO;
>  		break;
>  	case ISCSI_BOOT_ETH_PREFIX_LEN:
> -		if (nic->subnet_mask_prefix)
> -			rc = S_IRUGO;
> -		break;
>  	case ISCSI_BOOT_ETH_SUBNET_MASK:
> -		if (!memcmp(nic->ip_addr, nulls, 10) &&
> -		    (nic->ip_addr[10] == 0xff) &&
> -		    (nic->ip_addr[11] == 0xff) &&
> -		    nic->subnet_mask_prefix)
> +		if (nic->subnet_mask_prefix)
>  			rc = S_IRUGO;
>  		break;
>  	case ISCSI_BOOT_ETH_ORIGIN:
> 

Sorry. I thought I sent this mail already.

Is the commit id above supposed to be referencing the first patch? I
could not match it to anything. If so, then shouldn't this patch just be
combined with the second patch and some comment about us always
displaying it for compat reasons added to the code?

Also, you should normally cc Konrad for iscsi_ibft.c patches, because he
is actually the maintainer.
