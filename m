From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH] hpsa: add heartbeat sysfs host attribute
Date: Mon, 15 Aug 2011 10:04:09 -0500
Message-ID: <20110815150409.GS27723@beardog.cce.hp.com>
References: <20110812180314.21808.59261.stgit@beardog.cce.hp.com> <20110813020147.GB15554@kroah.com> <20110815144022.GR27723@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:13582 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1HOPER (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2011 11:04:17 -0400
Content-Disposition: inline
In-Reply-To: <20110815144022.GR27723@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com

On Mon, Aug 15, 2011 at 09:40:22AM -0500, scameron@beardog.cce.hp.com wrote:
> On Fri, Aug 12, 2011 at 07:01:47PM -0700, Greg KH wrote:
> > On Fri, Aug 12, 2011 at 01:03:14PM -0500, Stephen M. Cameron wrote:
> > > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > > 
> > > The cciss driver had a CCISS_HEARTBEAT ioctl which
> [...]
> > >  
> > > +  The "heartbeat" read-only attribute returns the value of a heartbeat
> > > +  counter register on a Smart Array controller as a 32 bit unsigned
> > > +  hexadecimal integer (e.g: "0x12345678").  The value should change
> > > +  periodically, not less than once per second.  If this value fails to
> > > +  change for a period longer than one second, it means something has
> > > +  gone wrong (e.g. Smart Array controller firmware has locked up.)
> > > +
> > 
> > This all belongs in Documentation/ABI/ care to move it there instead?
> 
> Sure.

Now that I look, I'm not seeing where any of the generic scsi
host or device attributes are documented in Documenation/ABI.

It's not very clear to me where in Documentation/ABI I should
document a driver's custom scsi device and host attributes as
even the generic scsi device and host attributes seem to be
undocumented.

from scsi_sysfs.c, I see these, for example:

        &dev_attr_device_blocked.attr,
        &dev_attr_type.attr,
        &dev_attr_scsi_level.attr,
        &dev_attr_vendor.attr,
        &dev_attr_model.attr,
        &dev_attr_rev.attr,
        &dev_attr_rescan.attr,
        &dev_attr_delete.attr,
        &dev_attr_state.attr,
        &dev_attr_timeout.attr,
        &dev_attr_iocounterbits.attr,
        &dev_attr_iorequest_cnt.attr,
        &dev_attr_iodone_cnt.attr,
        &dev_attr_ioerr_cnt.attr,
        &dev_attr_modalias.attr,
        REF_EVT(media_change),
        NULL
};

but I don't see them documented anywhere in Documentation/ABI,
and hpsa.c adds these custom sdev attrs:

static struct device_attribute *hpsa_sdev_attrs[] = {
        &dev_attr_raid_level,
        &dev_attr_lunid,
        &dev_attr_unique_id,
        NULL,
};


Likewise, there are generic scsi host attrs in scsi_sysfs.c:

static struct attribute *scsi_sysfs_shost_attrs[] = {
        &dev_attr_unique_id.attr,
        &dev_attr_host_busy.attr,
        &dev_attr_cmd_per_lun.attr,
        &dev_attr_can_queue.attr,
        &dev_attr_sg_tablesize.attr,
        &dev_attr_sg_prot_tablesize.attr,
        &dev_attr_unchecked_isa_dma.attr,
        &dev_attr_proc_name.attr,
        &dev_attr_scan.attr,
        &dev_attr_hstate.attr,
        &dev_attr_supported_mode.attr,
        &dev_attr_active_mode.attr,
        &dev_attr_prot_capabilities.attr,
        &dev_attr_prot_guard_type.attr,
        NULL

Also undocumented.

hpsa.c adds custom host attrs:
static struct device_attribute *hpsa_shost_attrs[] = {
        &dev_attr_rescan,
        &dev_attr_firmware_revision,
        &dev_attr_commands_outstanding,
        &dev_attr_transport_mode,
        &dev_attr_resettable,
        &dev_attr_heartbeat,
        NULL,
};


How should I proceed?

-- steve

