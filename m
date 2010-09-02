From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] scsi: fix SCSI_SAS_ATTRS' reference to BLK_DEV_BSG
Date: Thu, 2 Sep 2010 07:56:57 -0700
Message-ID: <20100902075657.7a699c3c.randy.dunlap@oracle.com>
References: <4C7FBF290200007800013FB9@vpn.id2.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:54347 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab0IBO5e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2010 10:57:34 -0400
In-Reply-To: <4C7FBF290200007800013FB9@vpn.id2.novell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Beulich <JBeulich@novell.com>
Cc: James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Thu, 02 Sep 2010 14:13:45 +0100 Jan Beulich wrote:

> Since SCSI_SAS_ATTRS gets selected in a few places, making it merely
> depend on the (user selectable) BLK_DEV_BSG isn't correct (as the
> result may be that the latter doesn't get enabled, which recent
> kconfig validly warns about). Convert the "depends on" to a "select".
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> ---
>  drivers/scsi/Kconfig |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.36-rc3/drivers/scsi/Kconfig
> +++ 2.6.36-rc3-scsi-sas-attrs/drivers/scsi/Kconfig
> @@ -316,7 +316,8 @@ config SCSI_ISCSI_ATTRS
>  
>  config SCSI_SAS_ATTRS
>  	tristate "SAS Transport Attributes"
> -	depends on SCSI && BLK_DEV_BSG
> +	depends on SCSI
> +	select BLK_DEV_BSG
>  	help
>  	  If you wish to export transport-specific information about
>  	  each attached SAS device to sysfs, say Y.
> 
> 
> 
> --

Ack if it will help.
http://marc.info/?l=linux-scsi&m=128214896025671&w=2

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
