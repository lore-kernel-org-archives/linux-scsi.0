From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: [Emulex] Ready for next round...
Date: Fri, 18 Jun 2004 15:56:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F9530@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:59383 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S266780AbUFRT4x
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 15:56:53 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Christoph,

per your comments:
 
> > - your module_param usage is b0rked.  Instead of duplicating every
> >   option 31 times use module_param_array.  You also seem to miss
> >   the paramter descriptions (MODULE_PARAM_DESC)
> 
> Your paramters are still extremly crappy.  lpfc.conf is 
> horrible, as is
> having the module paramters in a header.  What's especially 
> bad is that
> they are character paramters without any abvious reasons, please use
> the proper integer types.
> 
> lpfc_cfgparm.h is truely horrible.

More guidance needed than the terms used.... What are you looking for ?

lpfc.conf - should be better renamed to a .c file and it is compiled into
the driver. It provides the default values for the attributes for each
adapter. Our requirement is to have individual attributes per instance, with
the approach to setting them being - supply a global default, then
optionally allow per-instance overrides.

Why per-instance attributes ?  With large adapter counts (no real max,
expect > 32), the potential uses and configurations can vary widely on each.
This requirement has been confirmed by customer requests.

Why compile it in ? The view on how an attribute can be dynamically updated
is either via modules.conf or a utility that runs post module load. Given
the large adapter count and the number of attributes - it's too much for
modules.conf. Given that anything that runs post module load means the
driver has already performed adapter initialization and link bringup, it's
too late for some parameters. For these late parameters, we can reconfigure
to pick up the dynamic settings, but brief behavior with the unwanted
parameters may cause undesired effects for the user. The end result - we let
users update the values and recompile the driver. If there's a better way,
please point us in the right direction. I'd love to not require
recompilation.

Why the character parameters ? It becomes clear rapidly. Previously, we had
integer arrays, but as we didn't want to cap the number of adapters that can
be supported, nor require huge numbers of elements to be dealt with (a set
per adapter), we reduced it to 1 element per attribute - a character string
so that it can be dynamic in length. The string contains the global default,
and can be extended if there are 1 or more instances that needed specific
values. This significantly reduced the memory requirements, the number of
elements, and seemed more intuitive to specify by the user.  We also looked
at module_param_array, but this doesn't seem to work with the model of
wanting to set different defaults for different elements at compile time.

lpfc_cfgparm.h: for the most part, it's a structured way to manage the
attributes. Contains min/max so that we can verify the user didn't
inadvertantly screw up a setting, as well as knowing what to fall back to in
case they did. A couple of the elements, such as the strings, are largely
unnecessary, but could be useful for log messages.  One thing we will change
- this huge array is currently copied per instance right now. It will be
changes so that there is only 1 master array containing the boundaries, and
the current values will be the only thing kept per instance.

Can you provide some additional comments or options ?

> 
> > - lpfc_clock.c should go away, just use add_timer/etc. diretly and
> >   embedd the timer into your structures.  Yes, I know that's not
> >   how SVR4-derivates work, but Linux does.  You also have an
> >   unchecked kmalloc and a list_head cast in there..
> 
> Still not much better.  In fact the crappy datastructures and code are
> still there, just spread all over the place now instead of fixed up.

Ok - so the disagreement here really is the fact we had clock data
structures.

The data structures were for 2 purposes:
- to pass more than 1 argument to a callback.  
- to keep a "safety" list of all timers when we needed to take an adapter
offline.

Since this isn't acceptable, here's what our approach is:
- Were seeing if the need for >1 arg is really needed. If so, we'll axe this
part of the structure.
- We're removing the safety list. We shouldn't need it anyway as normal data
structure teardown should handle it.
If both happen, the structure will be gone.

> 
> > - dito for lpfc_sysfs_info_show, in short all your sysfs 
> work is completely
> >   wrong, also you seem to use driver attributes instead of 
> scsi device/host
> >   attributes.  why?
> 
> You're still attaching all the attributes yourself.  Please use the
> scsi-provided host/device attributes instead.

Ok. The way I interpret this comment: the sysfs implementation (mechanics)
is ok. The per adapter attributes are ok, with the exception of where they
overlap with scsi attributes (such as lun skip and queue depths).  I agree -
we'll remove the overlaps. This was old history..

> 
> > - the lpfc_find_target usage in queuecommand looks bogus.  You have
> >   scsi_device->hostdata to put per-lun data, from which you 
> can trivially
> >   link per-target data directly.  All the checks for 
> inquiry and valid
> >   luns are similarly b0rked - scsi probing works by calling 
> ->slave_alloc
> >   first so you'll a) have a place where you know the 
> midlayer is probing
> >   and b) always private data when quecommand is called.
> 
> While you started using sdev->hostdata the whole code is 
> still more than
> fishy.  You have a complete set of secondary data structures 
> for target/lun
> data lookup yet.  Please allocate all per-lun data in 
> ->slave_alloc and
> if the target data doesn't exist yet that one too and hang it 
> off the lun
> data.
> 

Not fishy - but done differently based on the code's history.  In either
case, we'll rework to fit the desired approach.

-- James
