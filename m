From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Mon, 15 Aug 2005 07:19:40 -0700 (PDT)
Message-ID: <20050815141941.46167.qmail@web51603.mail.yahoo.com>
References: <20050815135537.GB19426@lst.de>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web51603.mail.yahoo.com ([206.190.38.208]:41325 "HELO
	web51603.mail.yahoo.com") by vger.kernel.org with SMTP
	id S964784AbVHOOTp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 10:19:45 -0400
In-Reply-To: <20050815135537.GB19426@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

Good stuff, Christoph!

    Luben


--- Christoph Hellwig <hch@lst.de> wrote:

> This is a minmal, bottom-up SAS transport class.  So far it only exposed
> information about the SAS port/phy and SAS device (scsi target).  I hope
> this will integrate nicely with the top-down work Luben has done once he
> finally releases it publically, but for now I think we should have
> something so SAS drivers can go in the tree.
> 
> In detail this transport class does:
> 
>  - introduces a SAS port object between the Scsi_Host and scsi_target,
>    this is used to hold all information specific to the SAS port and
>    PHY - right now they're used interchangable as I haven't found the
>    right abstraction for wide ports yet - if there is a proper solution
>    at all as the SAS spec leaves binding PHYs together to wide ports
>    up to the implementation.
>  - adds some attributes to the scsi_target, and an API call to
>    preinitialize them.
> 
> It does not:
> 
>  - handle any managment interfaces or chaning of attributes
>  - any SAS devices that are not scsi targets, most importantly there's
>    no support for SMP and extenders yet
>  - wide ports (as mentioned above)
>  - software device discovery (although I know Luben has some nice code
>    for that)
>  - everythig not mentioned here
> 
> A bit of warning: I've only tested this with an SATA disk attached to
> a SAS HBA so far because I don't have any real SAS storage yet.
> 
> To use the transport class you need a patched fusion driver for now,
> use the LSI tarball at:
> 
>  
>
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/mptlinux-3.02.55-src.tar.gz
> 
> plus my patch at:
> 
>   http://verein.lst.de/~hch/fusion-sas-transport-class.diff
> 
> I'll try to port my changes plus basic SAS support over to the mainline
> driver, but the driver is currently not endian clean which makes it hard
> for me to actually test it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: scsi-misc-2.6/drivers/scsi/Kconfig
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/Kconfig	2005-08-13 13:53:51.000000000
> +0200
> +++ scsi-misc-2.6/drivers/scsi/Kconfig	2005-08-15 15:34:56.000000000 +0200
> @@ -229,6 +229,13 @@
>  	  each attached iSCSI device to sysfs, say Y.
>  	  Otherwise, say N.
>  
> +config SCSI_SAS_ATTRS
> +	tristate "SAS Transport Attributes"
> +	depends on SCSI
> +	help
> +	  If you wish to export transport-specific information about
> +	  each attached SAS device to sysfs, say Y.
> +
>  endmenu
>  
>  menu "SCSI low-level drivers"
> Index: scsi-misc-2.6/drivers/scsi/Makefile
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/Makefile	2005-08-13 13:53:51.000000000
> +0200
> +++ scsi-misc-2.6/drivers/scsi/Makefile	2005-08-15 15:35:12.000000000 +0200
> @@ -29,6 +29,7 @@
>  obj-$(CONFIG_SCSI_SPI_ATTRS)	+= scsi_transport_spi.o
>  obj-$(CONFIG_SCSI_FC_ATTRS) 	+= scsi_transport_fc.o
>  obj-$(CONFIG_SCSI_ISCSI_ATTRS)	+= scsi_transport_iscsi.o
> +obj-$(CONFIG_SCSI_SAS_ATTRS)	+= scsi_transport_sas.o
>  
>  obj-$(CONFIG_SCSI_AMIGA7XX)	+= amiga7xx.o	53c7xx.o
>  obj-$(CONFIG_A3000_SCSI)	+= a3000.o	wd33c93.o
> Index: scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c	2005-08-15
> 15:40:00.000000000 +0200
> @@ -0,0 +1,491 @@
> +/*
> + * Copyright (C) 2005 Dell Inc.
> + *	Released under GPL v2.
> + *
> + * Based on the FC transport class work by James Smart, Emulex Corporation.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/err.h>
> +
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_transport.h>
> +#include <scsi/scsi_transport_sas.h>
> +
> +
> +#define SAS_TARGET_ATTRS	25
> +#define SAS_PORT_ATTRS		25
> +
> +struct sas_internal {
> +	struct scsi_transport_template t;
> +	struct sas_function_template *f;
> +
> +	struct class_device_attribute private_target_attrs[SAS_TARGET_ATTRS];
> +	struct class_device_attribute private_port_attrs[SAS_TARGET_ATTRS];
> +
> +	struct transport_container port_attr_cont;
> +
> +	/*
> +	 * The array of null terminated pointers to attributes
> +	 * needed by scsi_sysfs.c
> +	 */
> +	struct class_device_attribute *target_attrs[SAS_TARGET_ATTRS];
> +	struct class_device_attribute *port_attrs[SAS_PORT_ATTRS + 1];
> +};
> +#define to_sas_internal(tmpl)	container_of(tmpl, struct sas_internal, t)
> +
> +/*
> + * Hack to allow attributes of the same name in different objects.
> + */
> +#define SAS_CLASS_DEVICE_ATTR(_prefix,_name,_mode,_show,_store) \
> +	struct class_device_attribute class_device_attr_##_prefix##_##_name = \
> +	__ATTR(_name,_mode,_show,_store)
> +
> +
> +/*
> + * Pretty printing helpers
> + */
> +
> +#define sas_bitfield_name_match(title, table)			\
> +static ssize_t							\
> +get_sas_##title##_names(u32 table_key, char *buf)		\
> +{								\
> +	char *prefix = "";					\
> +	ssize_t len = 0;					\
> +	int i;							\
> +								\
> +	for (i = 0; i < sizeof(table)/sizeof(table[0]); i++) {	\
> +		if (table[i].value & table_key) {		\
> +			len += sprintf(buf + len, "%s%s",	\
> +				prefix, table[i].name);		\
> +			prefix = ", ";				\
> +		}						\
> +	}							\
> +	len += sprintf(buf + len, "\n");			\
> +	return len;						\
> +}
> +
> +#define sas_bitfield_name_search(title, table)			\
> +static ssize_t							\
> +get_sas_##title##_names(u32 table_key, char *buf)		\
> +{								\
> +	ssize_t len = 0;					\
> +	int i;							\
> +								\
> +	for (i = 0; i < sizeof(table)/sizeof(table[0]); i++) {	\
> +		if (table[i].value == table_key) {		\
> +			len += sprintf(buf + len, "%s",		\
> +				table[i].name);			\
> +			break;					\
> +		}						\
> +	}							\
> +	len += sprintf(buf + len, "\n");			\
> +	return len;						\
> +}
> +
> +static struct {
> +	u32		value;
> +	char		*name;
> +} sas_device_type_names[] = {
> +	{ SAS_PHY_UNUSED,		"unused" },
> +	{ SAS_END_DEVICE,		"end device" },
> +	{ SAS_EDGE_EXPANDER_DEVICE,	"edge expander" },
> +	{ SAS_FANOUT_EXPANDER_DEVICE,	"fanout expander" },
> +};
> +sas_bitfield_name_search(device_type, sas_device_type_names)
> +
> +
> +static struct {
> +	u32		value;
> +	char		*name;
> +} sas_protocol_names[] = {
> +	{ SAS_PROTOCOL_SATA,		"sata" },
> +	{ SAS_PROTOCOL_SMP,		"smp" },
> +	{ SAS_PROTOCOL_STP,		"stp" },
> +	{ SAS_PROTOCOL_SSP,		"ssp" },
> +};
> +sas_bitfield_name_match(protocol, sas_protocol_names)
> +
> +static struct {
> +	u32		value;
> +	char		*name;
> +} sas_linkspeed_names[] = {
> +	{ SAS_LINK_RATE_UNKNOWN,	"Unknown" },
> +	{ SAS_PHY_DISABLED,		"Phy disabled" },
> +	{ SAS_LINK_RATE_FAILED,		"Link Rate failed" },
> 
=== message truncated ===

