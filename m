From: Chris Clayton <chris2553@googlemail.com>
Subject: Re: Nero 4 Linux applications broken in 4.12
Date: Wed, 5 Jul 2017 14:45:06 +0100
Message-ID: <f44717d2-81bf-98b6-1f70-9b2a2f016c25@googlemail.com>
References: <460fefb4-d002-6989-0c90-63ea0e209fc3@googlemail.com>
 <20170705073928.GA4076@linux-x5ow.site>
 <9c58bac7-ddf4-3e47-b729-76e595804836@googlemail.com>
 <20170705084447.GD4076@linux-x5ow.site>
 <20170705084810.GE4076@linux-x5ow.site>
 <d92e31ed-db7f-aa4b-5dfd-3f6df4a49ea9@googlemail.com>
 <20170705115235.GF4076@linux-x5ow.site>
 <3790b5ad-c02f-6406-173b-f2a0563f642b@googlemail.com>
 <20170705120927.GG4076@linux-x5ow.site>
 <8834e9d2-3018-ee8f-b40e-ccd8aecc367c@googlemail.com>
 <20170705124229.GH4076@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34640 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdGENrK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2017 09:47:10 -0400
Received: by mail-wm0-f68.google.com with SMTP id p204so32696425wmg.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2017 06:47:09 -0700 (PDT)
In-Reply-To: <20170705124229.GH4076@linux-x5ow.site>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org



On 05/07/17 13:42, Johannes Thumshirn wrote:
> On Wed, Jul 05, 2017 at 01:19:09PM +0100, Chris Clayton wrote:
>> I'm happy to test any patches you may propose.
> 
> Can you verify this fix? Preferedably with using Nero. It passes my small
> reproducer:
> 
Thanks Johannes.

With your patch applied to 4.12.0, all three of the nero applications can now detect my drives again.

Excellent work! Thank you.

Tested-by: Chris Clayton <chris2553@googlemail.com>

> From f52502180cc3843f8acc956253af2575245546a8 Mon Sep 17 00:00:00 2001
> From: Johannes Thumshirn <jthumshirn@suse.de>
> Date: Wed, 5 Jul 2017 14:31:47 +0200
> Subject: [PATCH] scsi: sg: fix SG_DXFER_FROM_DEV transfers
> 
> SG_DXFER_FROM_DEV transfers do not have a dxferp as we set it to NULL,
> but must have a length bigger than 0. This fixes a regression introduced
> by commit 28676d869bbb ("scsi: sg: check for valid direction before
> starting the request")
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: 28676d869bbb ("scsi: sg: check for valid direction before starting the request")
> ---
>  drivers/scsi/sg.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 21225d62b0c1..3c91593260aa 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -758,8 +758,11 @@ static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
>  		if (hp->dxferp || hp->dxfer_len > 0)
>  			return false;
>  		return true;
> -	case SG_DXFER_TO_DEV:
>  	case SG_DXFER_FROM_DEV:
> +		if (hp->dxferp || hp->dxfer_len < 0)
> +			return false;
> +		return true;
> +	case SG_DXFER_TO_DEV:
>  	case SG_DXFER_TO_FROM_DEV:
>  		if (!hp->dxferp || hp->dxfer_len == 0)
>  			return false;
> 
