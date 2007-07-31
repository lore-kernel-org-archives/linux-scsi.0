From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 1/1] scsi: Fix SRP_ATTRS Kconfig
Date: Wed, 1 Aug 2007 00:24:50 +0900
Message-ID: <20070731154505V.tomof@acm.org>
References: <11858119293805-patch-mail.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:49482 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756134AbXGaPZN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 11:25:13 -0400
In-Reply-To: <11858119293805-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] scsi: Fix SRP_ATTRS Kconfig
Date: Mon, 30 Jul 2007 11:12:10 -0500

> 
> Since the srp transport class was added, if scsi tgt support is not
> selected, the current Kconfig allows for enabling a dependent device
> driver, such as ibmvscsi, which does a select of SCSI_SRP_ATTRS. This
> does not, however, enable SCSI_TGT also. This fixes this up to prevent
> the following build problem:
> 
> ERROR: ".scsi_tgt_it_nexus_create" [drivers/scsi/scsi_transport_srp.ko] undefined!
> ERROR: ".scsi_tgt_it_nexus_destroy" [drivers/scsi/scsi_transport_srp.ko] undefined!
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  scsi-pending-2.6.git-bjking1/drivers/scsi/Kconfig |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/Kconfig~scsi_tgt_kconfig_fix drivers/scsi/Kconfig
> --- scsi-pending-2.6.git/drivers/scsi/Kconfig~scsi_tgt_kconfig_fix	2007-07-30 10:44:34.000000000 -0500
> +++ scsi-pending-2.6.git-bjking1/drivers/scsi/Kconfig	2007-07-30 10:45:00.000000000 -0500
> @@ -291,7 +291,8 @@ source "drivers/scsi/libsas/Kconfig"
>  
>  config SCSI_SRP_ATTRS
>  	tristate "SRP Transport Attributes"
> -	depends on SCSI && SCSI_TGT
> +	depends on SCSI
> +	select SCSI_TGT

Thanks, but I guess that I should have made the srp transport class
independent of tgt since most people want only initiator support. I'll
send a patch to do that soon.
