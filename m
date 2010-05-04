From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: fix cxgb3i build errors
Date: Tue, 04 May 2010 13:36:30 -0400
Message-ID: <1272994590.5255.32.camel@mulgrave.site>
References: <20100504102833.db09b0df.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50100 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab0EDRgg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 13:36:36 -0400
In-Reply-To: <20100504102833.db09b0df.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, Karen Xie <kxie@chelsio.com>, akpm <akpm@linux-foundation.org>

On Tue, 2010-05-04 at 10:28 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> cxgb3i should depend on NET since it selects SCSI_ISCSI_ATTRS,
> which depends on NET.
> This change fixes multiple build (link) errors:
> 
> ERROR: "skb_trim" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> ERROR: "netlink_kernel_create" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> ERROR: "netlink_kernel_release" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> ERROR: "skb_pull" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> ERROR: "init_net" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> ERROR: "__alloc_skb" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> ERROR: "netlink_broadcast" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> ERROR: "kfree_skb" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> ERROR: "skb_put" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Karen Xie <kxie@chelsio.com>
> ---
>  drivers/scsi/cxgb3i/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- lnx-2634-rc6.orig/drivers/scsi/cxgb3i/Kconfig
> +++ lnx-2634-rc6/drivers/scsi/cxgb3i/Kconfig
> @@ -1,6 +1,6 @@
>  config SCSI_CXGB3_ISCSI
>  	tristate "Chelsio S3xx iSCSI support"
> -	depends on CHELSIO_T3_DEPENDS
> +	depends on CHELSIO_T3_DEPENDS && NET

Something's seriously wrong here.

CHELSIO_T3_DEPENDS is supposed to be the rollup for all the
dependencies.  It's actually defined as this:

config CHELSIO_T3_DEPENDS
	tristate
	depends on PCI && INET
	default y

INET is the tcp/ip stack ... so how did you build a kernel that has
NET=n and INET=y (it's guarded by an #if NET in the Kconfig file)?

James


