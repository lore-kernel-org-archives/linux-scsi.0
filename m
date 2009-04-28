From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ses check name in enclosure_component_register
Date: Tue, 28 Apr 2009 17:26:29 -0500
Message-ID: <1240957589.3380.67.camel@mulgrave.int.hansenpartnership.com>
References: <49F6678D.3080207@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35322 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753360AbZD1W0a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Apr 2009 18:26:30 -0400
In-Reply-To: <49F6678D.3080207@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

On Mon, 2009-04-27 at 19:18 -0700, Yinghai Lu wrote:
> dev_set_name will use sprintf to copy the name.
> need to check if the name does valid.
> 
> otherwise will error from device_add later.

I think what you mean to say is that empty names aren't allowed in the
device model.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index 3cf61ec..68743a9 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -255,7 +255,7 @@ enclosure_component_register(struct enclosure_device *edev,
>  	ecomp->number = number;
>  	cdev = &ecomp->cdev;
>  	cdev->parent = get_device(&edev->edev);
> -	if (name)
> +	if (name && name[0])
>  		dev_set_name(cdev, name);

Actually, I think this should become

dev_set_name(cdev, "%s", name);

as well, otherwise any name with a percent in it will get interpreted in
ways we're not expecting at all.

James


