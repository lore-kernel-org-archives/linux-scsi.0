From: sullivan <sullivan@austin.ibm.com>
Subject: Re: Removal of driverfs files in drivers/cdrom/cdrom.c
Date: Thu, 25 Jul 2002 08:36:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020725083649.D1757@austin.ibm.com>
References: <Pine.LNX.4.44.0207241456570.954-100000@cherise.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0207241456570.954-100000@cherise.pdx.osdl.net>; from mochel@osdl.org on Wed, Jul 24, 2002 at 02:57:11PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mochel <mochel@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Wed, Jul 24, 2002 at 02:57:11PM -0700, Patrick Mochel wrote:
> 
> 
> So, I'm looking at changing the driverfs API. In doring so, I came across 
> this code in drivers/cdrom/cdrom.c:unregister_cdrom:
> 
>         if (atomic_read (&cdi->cdrom_driverfs_dev.refcount)) {
>                 device_remove_file (&cdi->cdrom_driverfs_dev, "name");
>                 device_remove_file (&cdi->cdrom_driverfs_dev, "kdev");
>                 put_device (&cdi->cdrom_driverfs_dev);
>         }
> 
> This looks wrong, based on the fact that it wasn't the cdrom layer that 
> created these files. They were, I believe, created by the SCSI cdrom 
> layer. So, why are they being removed here, esp. since they are removed at 
> a more general layer? 

Yes, I struggled with this one. I would prefer the implementation where the
lower layer (ie. scsi, ide) setup only the parent and bus fields of the
cdrom_driverfs_dev structure and let the more general layer (cdrom.c) do the
rest as part of the register_cdrom() call. Similarily, unregister_cdrom() would
do the removal.

Since there are a lot of drivers that register with the general cdrom layer 
that don't support driverfs yet, I didn't want to make changes across a whole
bunch of components needlessly until people got a chance to look at what the
device tree might look like for the scsi implementation. 

Maybe a first good step would be to move the cdrom support completely up into
the general layer and use the presence of a non NULL parent field to indicate
whether the lower level driver has added support for driverfs. We'd have to
make sure the cdrom_drverfs_dev structure is initialized with zeros for all of
the cdrom related driver layers that don't support driverfs yet. Let me know
what you think. I'll pull a patch together... 

> 
> Thanks,
> 
>         -pat
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
