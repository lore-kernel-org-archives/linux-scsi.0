From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/7] scsi: Export scsi_bus_type
Date: Wed, 18 Jan 2012 12:05:19 +0400
Message-ID: <1326873919.2898.15.camel@dabdike>
References: <20111206163731.GB3629@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20111206163731.GB3629@homac.suse.de>
Sender: linux-acpi-owner@vger.kernel.org
To: Holger Macht <holger@homac.de>
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-12-06 at 17:37 +0100, Holger Macht wrote:
> From: Matthew Garrett <mjg@redhat.com>
> 
> We need scsi_bus_type in order to be able to bind ata devices against
> acpi devices. Export it from the scsi core.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Acked-by: Holger Macht <holger@homac.de

If you're transmitting a patch, that needs to be a signed-off-by not an
acked-by (because you're part of the transmission sequence).

>  drivers/scsi/scsi_priv.h |    1 -
>  include/scsi/scsi.h      |    2 ++
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux/drivers/scsi/scsi_priv.h
> ===================================================================
> --- linux.orig/drivers/scsi/scsi_priv.h
> +++ linux/drivers/scsi/scsi_priv.h
> @@ -134,7 +134,6 @@ extern int scsi_sysfs_target_initialize(
>  extern struct scsi_transport_template blank_transport_template;
>  extern void __scsi_remove_device(struct scsi_device *);
>  
> -extern struct bus_type scsi_bus_type;
>  extern const struct attribute_group *scsi_sysfs_shost_attr_groups[];
>  
>  /* scsi_netlink.c */
> Index: linux/include/scsi/scsi.h
> ===================================================================
> --- linux.orig/include/scsi/scsi.h
> +++ linux/include/scsi/scsi.h
> @@ -187,6 +187,8 @@ struct scsi_cmnd;
>  
>  #define SCSI_MAX_VARLEN_CDB_SIZE 260
>  
> +extern struct bus_type scsi_bus_type;
> +

For about the third time, no to this: You're exposing deep SCSI internal
magic you shouldn't be touching.  The whole reason scsi_bus_type is in
scsi_priv is that only SCSI internals should be touching it.  We don't
want its use to leak outside of this.

The only reason you need it is because the odd type acpi_bus_type
insists on a bus_type parent.  So the correct fix is some type of
wrapper in scsi_lib.c:

scsi_register_acpi_bus_type(struct acpi_bus_type *bus)
{
	bus->bus = &scsi_bus_type;
	return register_acpi_bus_type(bus);
}
EXPORT_SYMBOL_GPL(scsi_register_acpi_bus_type);

For symmetry we probably want the unregister (it can be a pure inline
passthrough).

James


