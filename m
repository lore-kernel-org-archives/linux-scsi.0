From: Randy Dunlap <randy.dunlap@ORACLE.COM>
Subject: Re: [PATCH v1 10/10] mlx4_fc: Enable FC over Ethernet/Infiniband
 drivers
Date: Wed, 18 Aug 2010 10:05:34 -0700
Message-ID: <4C6C12DE.1020209@oracle.com>
References: <4C69B8E1.80702@mellanox.com> <20100816165137.d006efd0.randy.dunlap@oracle.com> <4C6C1096.9090900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:50016 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab0HRRLI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2010 13:11:08 -0400
In-Reply-To: <4C6C1096.9090900@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vu Pham <vuhuong@mellanox.com>
Cc: Roland Dreier <rdreier@cisco.com>, OpenFabrics EWG <ewg@openfabrics.org>, Linux RDMA <linux-rdma@vger.kernel.org>, Linux SCSI <linux-scsi@vger.kernel.org>, Oren Duer <oren@mellanox.co.il>

On 08/18/10 09:55, Vu Pham wrote:
> 
>> 	depends on 
>> +	select LIBFC
>> +	select LIBFCOE
>> +	help
>> +	  Fibre Channel over Ethernet/Infiniband module
>> +
>> +	  This is support for the Mellanox ConnectX/ConnectX-2 HCAs
>> +	  The module will be called mlx4_fc
>>
>> End both lines above with periods (".").
>>
>> +
>> +	  The module FIP-alike to discover BridgeX gateways in the
>> +	  Infiniband fabric
>>
>> end sentence with ".".
>>
>> What does "FIP-alike" mean?  and fix grammar:
>>
>> 	  This module attempts to discover BridgeX gateways in the
>> 	  Infiniband fabric.
>> ?
> 
>>
>> end sentence with ".".
> 
> Thanks for you comments.
> 
> From 54041f56fa1896388a52f503e43e21aa11cc9a2a Mon Sep 17 00:00:00 2001
> From: Vu Pham <vu@vu-lt.mti.mtl.com>
> Date: Tue, 17 Aug 2010 15:40:42 -0700
> Subject: [PATCH 10/10] mlx4_fc: Enable FC over Ethernet/Infiniband drivers
> 
> Add entries in scsi's Kconfig and Makefile to enable mlx4_fc
> (fcoe/fcoib offload driver) and mlx4_fcoib (FIP-alike discovery
> driver)
> 
> Signed-off-by: Vu Pham <vu@mellanox.com>

Looks good.  Thanks for the update.

> ---
>  drivers/scsi/Kconfig  |   23 +++++++++++++++++++++++
>  drivers/scsi/Makefile |    2 ++
>  2 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 158284f..e3d2850 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -687,6 +687,29 @@ config FCOE_FNIC
>  	  <file:Documentation/scsi/scsi.txt>.
>  	  The module will be called fnic.
>  
> +config MLX4_FC
> +	tristate "Mellanox FC module"
> +	select MLX4_EN
> +	select LIBFC
> +	select LIBFCOE
> +	help
> +	  Fibre Channel over Ethernet/Infiniband module
> +
> +	  This is support for the Mellanox ConnectX/ConnectX-2 HCAs.
> +	  The module will be called mlx4_fc.
> +
> +config MLX4_FCOIB
> +	tristate "Mellanox FCoIB discovery module"
> +	depends on INFINIBAND
> +	select MLX4_FC
> +	help
> +	  Fibre Channel over Infiniband discovery module
> +
> +	  The module attempts to discover BridgeX gateways in the
> +	  Infiniband fabric by implementing FIP protocol (FCoE
> +	  Initialization protocol) over Infiniband.
> +	  The module will be called mlx4_fcoib.
> +
>  config SCSI_DMX3191D
>  	tristate "DMX3191D SCSI support"
>  	depends on PCI && SCSI
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 2a3fca2..0d0dab7 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -40,6 +40,8 @@ obj-$(CONFIG_LIBFC)		+= libfc/
>  obj-$(CONFIG_LIBFCOE)		+= fcoe/
>  obj-$(CONFIG_FCOE)		+= fcoe/
>  obj-$(CONFIG_FCOE_FNIC)		+= fnic/
> +obj-$(CONFIG_MLX4_FC)		+= mlx4_fc/
> +obj-$(CONFIG_MLX4_FCOIB)	+= mlx4_fc/
>  obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	libiscsi_tcp.o iscsi_tcp.o
>  obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
>  obj-$(CONFIG_SCSI_A4000T)	+= 53c700.o	a4000t.o


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
