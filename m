From: Robert Love <robert.w.love@intel.com>
Subject: Re: [Open-FCoE] [PATCH v3 03/10] libfcoe: add implementation to
 support fcoe transport
Date: Fri, 14 Jan 2011 17:25:35 -0800
Message-ID: <1295054735.1836.1.camel@fritz>
References: <20110113021649.12798.71742.stg.yi.zou@intel.com>
	 <20110113021955.12798.84485.stg.yi.zou@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48575 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab1AOBZg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2011 20:25:36 -0500
In-Reply-To: <20110113021955.12798.84485.stg.yi.zou@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yi Zou <yi.zou@intel.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Wed, 2011-01-12 at 18:19 -0800, Yi Zou wrote:
> Add the new fcoe_transport.c file that implements basic fcoe transport
> interface. Eventually, the sysfs entries to create/destroy/enable/disable
> an FCoE instance will be coming to the fcoe transport layer, who does a
> look-up to find the corresponding transport provide and pass the corresponding
> action over to the identified provider.
> 
> The fcoe.ko will become the default fcoe transport provider that can support
> FCoE on any given netdev interfaces, as the Open-FCoE.org's default software
> FCoE HBA solution. Any vendor specific FCoE HBA driver that is built on top
> of Open-FCoE's kernel stack of libfc & libfcoe as well as the user land tool
> of fcoe-utils can easily plug-in and start running FCoE on their network
> interfaces. The fcoe.ko will be converted to act as the default provider if
> no vendor specific transport provider is found, as it is always added to the
> very end of the list of attached transports.
> 
> The lookup is based on the "drv_name" to fetch the fcoe_transport
> structure. The pointers to netdev obtained from "if_name" and the
> fcoe_transport structure are saved in 'fcoe_netdev_mapping' and added to the
> 'fcoe_netdev' list.  Subsequent destroy/disable/enable will lookup
> fcoe_netdev_list using netdev as the key and obtain fcoe_transport structure,
> and call ft->destroy, ft->disable and ft->enable.
> 
> Signed-off-by: Yi Zou <yi.zou@intel.com>
> Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
> ---
> 
>  drivers/scsi/fcoe/fcoe_transport.c |  540 ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/fcoe/libfcoe.h        |    6 
>  2 files changed, 546 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/scsi/fcoe/fcoe_transport.c
> 
> diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
> new file mode 100644
> index 0000000..517c29b
> --- /dev/null
> +++ b/drivers/scsi/fcoe/fcoe_transport.c
> @@ -0,0 +1,540 @@
> +#include <linux/types.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/spinlock.h>
> +#include <linux/timer.h>
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <linux/ethtool.h>
> +#include <linux/if_ether.h>
> +#include <linux/if_vlan.h>
> +#include <linux/errno.h>
> +#include <linux/bitops.h>
> +#include <linux/slab.h>
> +#include <net/rtnetlink.h>
> +
> +#include <scsi/fc/fc_els.h>
> +#include <scsi/fc/fc_fs.h>
> +#include <scsi/fc/fc_fip.h>
> +#include <scsi/fc/fc_encaps.h>
> +#include <scsi/fc/fc_fcoe.h>
> +#include <scsi/fc/fc_fcp.h>
> +
> +#include <scsi/libfc.h>
> +#include <scsi/libfcoe.h>
> +
> +#include "libfcoe.h"
> +

I'm going to remove the following unnecessary includes.

 #include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/timer.h>
 #include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/ethtool.h>
-#include <linux/if_ether.h>
-#include <linux/if_vlan.h>
 #include <linux/errno.h>
-#include <linux/bitops.h>
 #include <linux/slab.h>
-#include <net/rtnetlink.h>
 
-#include <scsi/fc/fc_els.h>
-#include <scsi/fc/fc_fs.h>
-#include <scsi/fc/fc_fip.h>
-#include <scsi/fc/fc_encaps.h>
-#include <scsi/fc/fc_fcoe.h>
-#include <scsi/fc/fc_fcp.h>
-
-#include <scsi/libfc.h>
 #include <scsi/libfcoe.h>

//Rob

