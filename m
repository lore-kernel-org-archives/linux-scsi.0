From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [Emulex] Ready for next round...
Date: Fri, 18 Jun 2004 21:58:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040618205856.GB27095@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F9530@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:32196 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263664AbUFRU7B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 16:59:01 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F9530@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Fri, Jun 18, 2004 at 03:56:37PM -0400, Smart, James wrote:
> Why compile it in ? The view on how an attribute can be dynamically updated
> is either via modules.conf or a utility that runs post module load. Given
> the large adapter count and the number of attributes - it's too much for
> modules.conf.

In what way?  If there's a bug in module-init-tools or the kernel paramter
parsing please report it and we'll fix it.

> Why the character parameters ? It becomes clear rapidly. Previously, we had
> integer arrays, but as we didn't want to cap the number of adapters that can
> be supported, nor require huge numbers of elements to be dealt with (a set
> per adapter),

Capping the numbers you can pass paramters for is fine, we do it all over
the place.  Please don't try to be artifically different from other drivers,
that's the last thing we want.

> lpfc_cfgparm.h: for the most part, it's a structured way to manage the
> attributes. Contains min/max so that we can verify the user didn't
> inadvertantly screw up a setting, as well as knowing what to fall back to in
> case they did. A couple of the elements, such as the strings, are largely
> unnecessary, but could be useful for log messages.  One thing we will change
> - this huge array is currently copied per instance right now. It will be
> changes so that there is only 1 master array containing the boundaries, and
> the current values will be the only thing kept per instance.

Which then would obsolete most of that mess.  I'm looking forward to that
change.

> Since this isn't acceptable, here's what our approach is:
> - Were seeing if the need for >1 arg is really needed. If so, we'll axe this
> part of the structure.

Currently clk_data is always (at least where I checked) embedded into another
structure.  Instead of losing all type checking by using that intermediate
structure continaining void pointers just add pointers to the addition data
object directly to the structure.

> - We're removing the safety list. We shouldn't need it anyway as normal data
> structure teardown should handle it.
> If both happen, the structure will be gone.

It's actually not a safetyguard.  It's your excuse for beeing sloppy with
object lifetimes in respect to timers.  For the normal case where one
timer is used with one callback only that is:

 - init_timer, setting of callback and data on object creation
 - add_timer the first time a timer is fired off and mod_timer if it's
   running or you don't know
 - del_timer_sync on object destruction

> > > - dito for lpfc_sysfs_info_show, in short all your sysfs 
> > work is completely
> > >   wrong, also you seem to use driver attributes instead of 
> > scsi device/host
> > >   attributes.  why?
> > 
> > You're still attaching all the attributes yourself.  Please use the
> > scsi-provided host/device attributes instead.
> 
> Ok. The way I interpret this comment: the sysfs implementation (mechanics)
> is ok. The per adapter attributes are ok, with the exception of where they
> overlap with scsi attributes (such as lun skip and queue depths).  I agree -
> we'll remove the overlaps. This was old history..

Not only.  You should please use the shost_attrs and sdev_attrs fields
in struct scsi_host_template for all your attributes, please look at
the 53c700 or ipr drivers for examples.

