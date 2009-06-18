From: "Michael Chan" <mchan@broadcom.com>
Subject: Re: [PATCH -next] bnx2i/cnic: kconfig interactions
Date: Thu, 18 Jun 2009 11:39:21 -0700
Message-ID: <1245350361.12000.219.camel@nseg_linux_HP1.broadcom.com>
References: <20090618145949.d933719a.sfr@canb.auug.org.au>
 <4A3A7175.8080006@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4949 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbZFRSrd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2009 14:47:33 -0400
In-Reply-To: <4A3A7175.8080006@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>, Anil Veerabhadrappa <anilgv@broadcom.com>, scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>


On Thu, 2009-06-18 at 09:55 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> NETDEVICES + NETDEV_1000 need to be enabled so that kconfig will check
> those branches for selects and enforce "select UIO" under CNIC.
> Otherwise the build fails with:

I think this patch is better than your previous patch to select UIO.
Other iSCSI drivers that select net drivers will probably need something
similar too.

Thanks.
Acked-by: Michael Chan <mchan@broadcom.com>

> 
> ERROR: "uio_unregister_device" [drivers/net/cnic.ko] undefined!
> ERROR: "uio_event_notify" [drivers/net/cnic.ko] undefined!
> ERROR: "__uio_register_device" [drivers/net/cnic.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Anil Veerabhadrappa <anilgv@broadcom.com>
> Cc: Michael Chan <mchan@broadcom.com>
> ---
>  drivers/scsi/bnx2i/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-next-20090618.orig/drivers/scsi/bnx2i/Kconfig
> +++ linux-next-20090618/drivers/scsi/bnx2i/Kconfig
> @@ -1,6 +1,8 @@
>  config SCSI_BNX2_ISCSI
>  	tristate "Broadcom NetXtreme II iSCSI support"
>  	select SCSI_ISCSI_ATTRS
> +	select NETDEVICES
> +	select NETDEV_1000
>  	select CNIC
>  	depends on PCI
>  	---help---
> 
> 
> 


