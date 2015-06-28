From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: [PATCH] SCSI-OSD: Delete an unnecessary check before the function
 call "put_disk"
Date: Sun, 28 Jun 2015 12:39:59 +0300
Message-ID: <558FC0EF.1080904@electrozaur.com>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net> <546E238A.5050606@users.sourceforge.net> <558ABBC2.8080304@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35389 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbbF1JkD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2015 05:40:03 -0400
In-Reply-To: <558ABBC2.8080304@users.sourceforge.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, Benny Halevy <bhalevy@primarydata.com>, "James E. J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>

On 06/24/2015 05:16 PM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 24 Jun 2015 16:06:21 +0200
> 
> The put_disk() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

ACK-by: Boaz Harrosh <ooo@electrozaur.com>

> ---
>  drivers/scsi/osd/osd_uld.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> index 243eab3..e2075522 100644
> --- a/drivers/scsi/osd/osd_uld.c
> +++ b/drivers/scsi/osd/osd_uld.c
> @@ -407,9 +407,7 @@ static void __remove(struct device *dev)
>  
>  	OSD_INFO("osd_remove %s\n",
>  		 oud->disk ? oud->disk->disk_name : NULL);
> -
> -	if (oud->disk)
> -		put_disk(oud->disk);
> +	put_disk(oud->disk);
>  	ida_remove(&osd_minor_ida, oud->minor);
>  
>  	kfree(oud);
> 

