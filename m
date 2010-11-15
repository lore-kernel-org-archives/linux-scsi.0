From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/2] target: Kconfig fixes
Date: Mon, 15 Nov 2010 12:26:21 -0800
Message-ID: <20101115122621.ea812a6c.randy.dunlap@oracle.com>
References: <20101115194315.GA23989@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:64414 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab0KOU0q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2010 15:26:46 -0500
In-Reply-To: <20101115194315.GA23989@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org

On Mon, 15 Nov 2010 14:43:15 -0500 Christoph Hellwig wrote:

> Use the menuconfig verb for the main TARGET_CORE option to make it look
> better in menuconfig, use a big if TARGET_CORE to get rid of a lot of
> depends, use help instead of ---help---, shorten lines to be under 80
> chars where applicable, convert options to bool instead of tristate
> where they should be, and remove the discuraged default values for
> all the options.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yes, mostly looks good, with the small exception of a few spaces-for-indents
that should be tabs.  (identified below)

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.


> Index: lio-core/drivers/target/Kconfig
> ===================================================================
> --- lio-core.orig/drivers/target/Kconfig	2010-11-15 20:28:39.010253809 +0100
> +++ lio-core/drivers/target/Kconfig	2010-11-15 20:28:56.459254088 +0100
> @@ -1,39 +1,41 @@
> -config TARGET_CORE
> +
> +menuconfig TARGET_CORE
>      tristate "Generic Target Core Mod (TCM) and ConfigFS Infrastructure"

Unchanged line above uses spaces instead of tab for indent.

>      select CONFIGFS_FS
> -    default m
> -    ---help---
> -    Say Y or M here to enable the TCM Storage Engine and ConfigFS enabled control path for target_core_mod.  This includes built-in TCM RAMDISK subsystem logic for virtual LUN 0 access
> +    help
> +      Say Y or M here to enable the TCM Storage Engine and ConfigFS enabled
> +      control path for target_core_mod.  This includes built-in TCM RAMDISK
> +      subsystem logic for virtual LUN 0 access
> +
> +if TARGET_CORE
>  
>  config TCM_IBLOCK
>  	tristate "TCM/IBLOCK Subsystem Plugin for Linux/BLOCK"
> -	depends on TARGET_CORE
> -	default y
> -	---help---
> -	Say Y here to enable the TCM/IBLOCK subsystem plugin for non-buffered access to Linux/Block devices using BIO
> +	help
> +	Say Y here to enable the TCM/IBLOCK subsystem plugin for non-buffered
> +	access to Linux/Block devices using BIO
>  
>  config TCM_FILEIO
>  	tristate "TCM/FILEIO Subsystem Plugin for Linux/VFS"
> -	depends on TARGET_CORE
> -	default y
> -	---help---
> -	Say Y here to enable the TCM/FILEIO subsystem plugin for buffered access to Linux/VFS struct file or struct block_device
> +	help
> +	Say Y here to enable the TCM/FILEIO subsystem plugin for buffered
> +	access to Linux/VFS struct file or struct block_device
>  
>  config TCM_PSCSI
>  	tristate "TCM/pSCSI Subsystem Plugin for Linux/SCSI"
> -	depends on TARGET_CORE
> -	default y
> -	---help---
> -	Say Y here to enable the TCM/pSCSI subsystem plugin for non-buffered passthrough access to Linux/SCSI device
> +	help
> +	Say Y here to enable the TCM/pSCSI subsystem plugin for non-buffered
> +	passthrough access to Linux/SCSI device
>  
>  config TCM_STGT
>  	tristate "TCM/STGT Subsystem Plugin"
> -	depends on TARGET_CORE && EXPERIMENTAL
> +	depends on EXPERIMENTAL
>  	select SCSI_TGT
> -	default n
> -	---help---
> +	help
>  	Say Y here to enable the WIP TCM/STGT subsystem plugin for accessing STGT device
>  
>  source "drivers/target/tcm_loop/Kconfig"
>  source "drivers/target/lio-target/Kconfig"
>  source "drivers/target/tcm_fc/Kconfig"
> +
> +endif
> Index: lio-core/drivers/target/tcm_fc/Kconfig
> ===================================================================
> --- lio-core.orig/drivers/target/tcm_fc/Kconfig	2010-11-15 20:28:39.023013342 +0100
> +++ lio-core/drivers/target/tcm_fc/Kconfig	2010-11-15 20:28:56.459254088 +0100
> @@ -1,6 +1,5 @@
>  config TCM_FC
>  	tristate "TCM_FC fabric Plugin"
> -	depends on TARGET_CORE && LIBFC
> -	default n
> -	---help---
> +	depends on LIBFC
> +	help
>  	Say Y here to enable the TCM FC plugin for accessing FC fabrics in TCM
> Index: lio-core/drivers/target/tcm_loop/Kconfig
> ===================================================================
> --- lio-core.orig/drivers/target/tcm_loop/Kconfig	2010-11-15 20:28:39.043254088 +0100
> +++ lio-core/drivers/target/tcm_loop/Kconfig	2010-11-15 20:29:46.093032970 +0100
> @@ -1,13 +1,11 @@
>  config TCM_LOOP_FABRIC
> -        tristate "TCM Virtual SAS target and Linux/SCSI LDD fabric loopback module "
> -        depends on TARGET_CORE && CONFIGFS_FS
> -        default n
> -        ---help---
> -        Say Y here to enable the TCM Virtual SAS target and Linux/SCSI LDD fabric loopback module
> +        tristate "TCM Virtual SAS target and Linux/SCSI LDD fabric loopback module"
> +        help
> +        Say Y here to enable the TCM Virtual SAS target and Linux/SCSI LDD

The 3 lines above use spaces for indents instead of tabs.

> +	fabric loopback module.
>  
>  config TCM_LOOP_CDB_DEBUG
> -	tristate "TCM loopback fabric module CDB debug code"
> -	depends on TARGET_CORE && CONFIGFS_FS && TCM_LOOP_FABRIC
> -	default n
> -	---help---
> +	bool "TCM loopback fabric module CDB debug code"
> +	depends on TCM_LOOP_FABRIC
> +	help
>  	Say Y here to enable the TCM loopback fabric module CDB debug code
> Index: lio-core/drivers/target/lio-target/Kconfig
> ===================================================================
> --- lio-core.orig/drivers/target/lio-target/Kconfig	2010-11-15 20:29:50.375009781 +0100
> +++ lio-core/drivers/target/lio-target/Kconfig	2010-11-15 20:32:04.538290269 +0100
> @@ -1,29 +1,16 @@
>  config LIO_TARGET
>          tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
> -        default m
> -        depends on TARGET_CORE
> -	select CONFIGFS_FS
> -        ---help---
> -        Say Y here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI Target Mode Stack
> -
> -config LIO_TARGET_SNMP
> -	tristate "LIO-Target iSCSI MIBs"
> -	default y
> -	depends on LIO_TARGET && PROC_FS
> -	---help---
> -	Say Y here to enable the iSCSI MIBs via procfs for LIO-Target.
> +        help
> +        Say Y here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI

2 lines above use spaces instead of tabs for indent.

> +	Target Mode Stack.
>  
>  config LIO_TARGET_DEBUG
> -	tristate "LIO-Target iscsi_debug.h ring buffer messages" 
> -	default n
> -	depends on LIO_TARGET
> -	---help---
> +	bool "LIO-Target iscsi_debug.h ring buffer messages"
> +	help
>  	Say Y here to enable the legacy DEBUG_ISCSI macros in iscsi_debug.h
>  
>  config LIO_TARGET_DEBUG_ERL
> -	tristate "LIO-Target ErrorRecoveryLevel debug code"
> -	default n
> -	depends on LIO_TARGET
> -	---help---
> -	Say Y here to enable the iSCSI ErrorRecoveryLevel debugging code
> +	bool "LIO-Target ErrorRecoveryLevel debug code"
> +	help
> +	Say Y here to enable the iSCSI ErrorRecoveryLevel debugging code.
>  	
> --

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
