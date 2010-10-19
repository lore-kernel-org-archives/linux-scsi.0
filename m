From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH] libfc: fix mem leak in fc_seq_assign()
Date: Tue, 19 Oct 2010 10:29:29 -0700
Message-ID: <4CBDD579.2010101@cisco.com>
References: <AANLkTimLBm2z=nWb_Q3MsyzFo_r6omMMQKnZ9FD2rtwW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:63386 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab0JSR3a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2010 13:29:30 -0400
In-Reply-To: <AANLkTimLBm2z=nWb_Q3MsyzFo_r6omMMQKnZ9FD2rtwW@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org


On 10/19/10 7:17 AM, Hillf Danton wrote:
> There seems exchs should get released in cases that FC_RJT_NONE is
> returned, or they will no longer get freed.
> 
> It also looks a typo like the following,
> 
> -		    fc_seq_lookup_recip(lport, ema->mp, fp) != FC_RJT_NONE)
> +		    fc_seq_lookup_recip(lport, ema->mp, fp) == FC_RJT_NONE)

True.

> 
> but I am not sure.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/drivers/scsi/libfc/fc_exch.c	2010-09-13 07:07:38.000000000 +0800
> +++ b/drivers/scsi/libfc/fc_exch.c	2010-10-19 21:48:22.000000000 +0800
> @@ -3,6 +3,9 @@
>   * Copyright(c) 2008 Red Hat, Inc.  All rights reserved.
>   * Copyright(c) 2008 Mike Christie
>   *
> + * Copyright(c) Oct 19, 2010	Hillf Danton
> + *				minor fix of memory leakage
> + *

Thanks for fixing the bug, but I don't think you should add a copyright.
I didn't add a copyright when I created the bug.

>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms and conditions of the GNU General Public License,
>   * version 2, as published by the Free Software Foundation.
> @@ -1246,9 +1249,16 @@ static struct fc_seq *fc_seq_assign(stru
>  	fr_seq(fp) = NULL;
> 
>  	list_for_each_entry(ema, &lport->ema_list, ema_list)
> -		if ((!ema->match || ema->match(fp)) &&
> -		    fc_seq_lookup_recip(lport, ema->mp, fp) != FC_RJT_NONE)
> -			break;
> +		if (! ema->match || ema->match(fp))
> +			if (fc_seq_lookup_recip(lport, ema->mp, fp) !=
> +				FC_RJT_NONE)

Should continue in this case ... we hope to find the exchange in another
exchange manager.

> +				break;
> +			else {
> +				struct fc_seq *seq = fr_seq(fp);
> +				struct fc_exch *exch = fc_seq_exch(seq);
> +				fc_exch_release(exch);

I want the sequence to be held by the frame, so don't do the release.
In this case we should break, since we found the frame.

This function is currently only used by target modules.  A later
patch exposes a release so they can release the sequence/exchange.

So, my original code was right except for the != vs == bug.
That turns out not to cause major problems if the first exchange
manager assigns the exchange, which is why I didn't see the bug.

> +			}
> +
>  	return fr_seq(fp);
>  }

By the way, I think patches to libfc, libfcoe, and fcoe should go to
the open-fcoe list only, not to SCSI.  Robert Love as the open-fcoe
maintainer will forward them after testing to the SCSI list.

	Regards,
	Joe
