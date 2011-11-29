From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 2/2] hpsa: add the Smart Array 5i to the kdump blacklist
Date: Tue, 29 Nov 2011 13:17:40 -0600
Message-ID: <20111129191740.GN6635@beardog.cce.hp.com>
References: <4ED39D3B.9080305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:37586 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab1K2TRm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2011 14:17:42 -0500
Content-Disposition: inline
In-Reply-To: <4ED39D3B.9080305@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, scameron@beardog.cce.hp.com

On Mon, Nov 28, 2011 at 03:39:55PM +0100, Tomas Henzl wrote:
> The '5i' controller freezes when a kdump is attemted.
> This patch admits it and adds the controller
> to the unresetable list.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> 
> ---
>  drivers/scsi/hpsa.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index e011937..b21491b 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -292,12 +292,14 @@ static u32 unresettable_controller[] = {
>  	0x3215103C, /* Smart Array E200i */
>  	0x3237103C, /* Smart Array E500 */
>  	0x323D103C, /* Smart Array P700m */
> +	0x40800E11, /* Smart Array 5i */
>  	0x409C0E11, /* Smart Array 6400 */
>  	0x409D0E11, /* Smart Array 6400 EM */
>  };
>  
>  /* List of controllers which cannot even be soft reset */
>  static u32 soft_unresettable_controller[] = {
> +	0x40800E11, /* Smart Array 5i */
>  	/* Exclude 640x boards.  These are two pci devices in one slot
>  	 * which share a battery backed cache module.  One controls the
>  	 * cache, the other accesses the cache through the one that controls
> -- 
> 1.7.6.4
> 
> 

Ack.  

I don't actually still have anything so old as a 5i to try it myself.
But at this point, finding out that the reset fails on some old Smart array
does not surprise me very much.  :(

-- steve
