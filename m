From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Emulex] Ready for next round...
Date: Wed, 16 Jun 2004 09:31:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040616083142.GA8757@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F94D5@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:22166 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S266217AbUFPIbq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 04:31:46 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F94D5@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Tue, Jun 15, 2004 at 01:32:56PM -0400, Smart, James wrote:
> Christoph, et al...
> 
> I'd like to request the next round of review comments on the driver.
> 
> We believe that tonights posting on SourceForge has addressed all of the
> comments to date with only a couple of exceptions (see below).

Okay, here's a review vs the original comments:

> - your module_param usage is b0rked.  Instead of duplicating every
>   option 31 times use module_param_array.  You also seem to miss
>   the paramter descriptions (MODULE_PARAM_DESC)

Your paramters are still extremly crappy.  lpfc.conf is horrible, as is
having the module paramters in a header.  What's especially bad is that
they are character paramters without any abvious reasons, please use
the proper integer types.

lpfc_cfgparm.h is truely horrible.

> - lpfc_clock.c should go away, just use add_timer/etc. diretly and
>   embedd the timer into your structures.  Yes, I know that's not
>   how SVR4-derivates work, but Linux does.  You also have an
>   unchecked kmalloc and a list_head cast in there..

Still not much better.  In fact the crappy datastructures and code are
still there, just spread all over the place now instead of fixed up.

> - dito for lpfc_sysfs_info_show, in short all your sysfs work is completely
>   wrong, also you seem to use driver attributes instead of scsi device/host
>   attributes.  why?

You're still attaching all the attributes yourself.  Please use the
scsi-provided host/device attributes instead.

> - the lpfc_find_target usage in queuecommand looks bogus.  You have
>   scsi_device->hostdata to put per-lun data, from which you can trivially
>   link per-target data directly.  All the checks for inquiry and valid
>   luns are similarly b0rked - scsi probing works by calling ->slave_alloc
>   first so you'll a) have a place where you know the midlayer is probing
>   and b) always private data when quecommand is called.

While you started using sdev->hostdata the whole code is still more than
fishy.  You have a complete set of secondary data structures for target/lun
data lookup yet.  Please allocate all per-lun data in ->slave_alloc and
if the target data doesn't exist yet that one too and hang it off the lun
data.

