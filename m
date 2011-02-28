From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 6/14] megaraid_sas: Fix megasas_get_cmd printk
Date: Mon, 28 Feb 2011 11:50:23 -0600
Message-ID: <1298915423.2487.43.camel@mulgrave.site>
References: <AANLkTimMuwYPbmear_zD49_=h7HhSy4NHg9hYh8esLSN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab1B1Ru3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2011 12:50:29 -0500
In-Reply-To: <AANLkTimMuwYPbmear_zD49_=h7HhSy4NHg9hYh8esLSN@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On Thu, 2011-02-24 at 20:56 -0800, adam radford wrote:
> James/Linux-scsi,
> 
> The following patch for megaraid_sas fixes a megasas_get_cmd printk.
> 
> Signed-off-by: Adam Radford <aradford@gmail.com>
> 
> diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
> scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
> --- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
> 18:49:07.531369391 -0800
> +++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
> 18:49:45.987337951 -0800
> @@ -186,7 +186,8 @@
>  				 struct megasas_cmd, list);
>  		list_del_init(&cmd->list);
>  	} else {
> -		printk(KERN_ERR "megasas: Command pool empty!\n");
> +		if (megasas_dbg_lvl)
> +			printk(KERN_ERR "megasas: Command pool empty!\n");

Why not just use KERN_DEBUG instead of KERN_ERR here and forget the if
(megasas_dbg_lvl)?

James


