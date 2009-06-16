From: "Michael Chan" <mchan@broadcom.com>
Subject: Re: [PATCH -next] bnx2i/cnic: more kconfig dependencies
Date: Tue, 16 Jun 2009 10:57:15 -0700
Message-ID: <1245175036.12000.70.camel@HP1>
References: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>
 <4A37D599.5080701@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <4A37D599.5080701@oracle.com>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org


On Tue, 2009-06-16 at 10:25 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> BNX2I selects CNIC, CNIC selects UIO.
> It looks like BNX2I also needs to select UIO.
> 

Yeah, it looks like if A selects B and B selects C, A does not
automatically select C, so we need to add it explicitly.

> BTW, CNIC is under NETDEV_1000, which is not enabled.
> I don't see any need to enable (select) it in this case,
> but I could be wrong(?).  Should BNX2I also select NETDEV_1000?

No that's not needed assuming we stay with using symbol_get() to resolve
a bnx2 driver symbol for now.

Thanks.

Acked-by: Michael Chan <mchan@broadcom.com>

> 
> cnic.c:(.text+0x17990b): undefined reference to `uio_event_notify'
> cnic.c:(.text+0x17a197): undefined reference to `uio_unregister_device'
> cnic.c:(.text+0x17c618): undefined reference to `__uio_register_device'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/scsi/bnx2i/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20090616.orig/drivers/scsi/bnx2i/Kconfig
> +++ linux-next-20090616/drivers/scsi/bnx2i/Kconfig
> @@ -2,6 +2,7 @@ config SCSI_BNX2_ISCSI
>  	tristate "Broadcom NetXtreme II iSCSI support"
>  	select SCSI_ISCSI_ATTRS
>  	select CNIC
> +	select UIO
>  	depends on PCI
>  	---help---
>  	This driver supports iSCSI offload for the Broadcom NetXtreme II
> 
> 
