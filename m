From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] gdth: unmap ccb_phys when scsi_add_host() fails in
 gdth_eisa_probe_one()
Date: Mon, 24 Aug 2009 13:49:25 -0700
Message-ID: <20090824134925.351095d1.akpm@linux-foundation.org>
References: <4A902570.1080103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494AbZHXU7G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Aug 2009 16:59:06 -0400
In-Reply-To: <4A902570.1080103@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Achim Leubner <achim_leubner@adaptec.com>

On Sat, 22 Aug 2009 19:05:52 +0200
Roel Kluin <roel.kluin@gmail.com> wrote:

> unmap ccb_phys as well when scsi_add_host() fails
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Right?

Partially.

> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index 185e6bc..3111503 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -4903,7 +4903,7 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
>  
>  	error = scsi_add_host(shp, NULL);
>  	if (error)
> -		goto out_free_coal_stat;
> +		goto out_free_ccb_phys;
>  	list_add_tail(&ha->list, &gdth_instances);
>  	gdth_timer_init();
>  

I suspect that we should also undo the effects of gdth_enable_int() if
taking this path.

