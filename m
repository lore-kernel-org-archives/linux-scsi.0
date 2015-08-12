From: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH v4 3/3] cxlflash: Virtual LUN support
Date: Wed, 12 Aug 2015 13:24:11 +1000
Message-ID: <1439349851.28873.48.camel@neuling.org>
References: <1439226594-7944-1-git-send-email-mrochs@linux.vnet.ibm.com>
	 <1439290473.28873.3.camel@neuling.org>
	 <55CA71FB.7090705@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:55735 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684AbbHLDYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 23:24:13 -0400
In-Reply-To: <55CA71FB.7090705@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: manoj@linux.vnet.ibm.com
Cc: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com


> > Be good to do some clear sanity check the "struct dk_cxlflash_resize *resize"
> > here.  It's passed from userspace but then gets propogated to a bunch of other
> > things here like nsectors, get_context etc who will all now be responsible for
> > handling any dodgy data passed in.
> >
> > Same with all the other ioctl calls.  Sanity check the parameters ASAP.  Don't
> > propagate potentially dodgy values all over the code base.
> >
> 
> The ioctls have a standard header structure, with version etc. that are 
> sanity checked before we get here. The other fields are sanity checked 
> where they are used, i.e. in get_context().

That was my point.  Let's do it upfront so it's clear they've been
checked.

> >> +	/*
> >> +	 * The requested size (req_size) is always assumed to be in 4k blocks,
> >> +	 * so we have to convert it here from 4k to chunk size.
> >> +	 */
> >> +	nsectors = (resize->req_size * CXLFLASH_BLOCK_SIZE) / gli->blk_len;
> >> +	new_size = DIV_ROUND_UP(nsectors, MC_CHUNK_SIZE);
> >
> > Like here. resize->req_size => new_size => grow_lxt() now grow_lxt() need to
> > sanity check new_size.
> 
> 
> This is a best effort allocator. If an allocation request y, cannot be 
> satisfied because of insufficient space in the LUN (i.e. only x amount 
> of space is available), then the allocator returns the remaining space 
> (x). This best effort allocation mechanism avoids having to sanity check 
> the size parameter.

Sounds delicate to me.

> 
> 
> >> +	struct dk_cxlflash_uvirtual *virt = (struct dk_cxlflash_uvirtual *)arg;
> >
> > Again, this should be sanity checked.
> 
> Same as comment above.
> 
> >> +	/* Resize even if requested size is 0 */
> >> +	marshal_virt_to_resize(virt, &resize);
> >
> > Virt has not been sanity checked.  So now resize can contain bad data.
> >
> >
> >> +	resize.rsrc_handle = rsrc_handle;
> 
> Same as above. As mentioned earlier, the size is immaterial. The rest of 
> the parameters are set here (rsrc_handle).

Humm.

> >> +#define LXT_LUNIDX_SHIFT  8	/* LXT entry, shift for LUN index */
> >> +#define LXT_PERM_SHIFT    4	/* LXT entry, shift for permission bits */
> >
> > What is LXT?
> 
> LXT = lun translation table. There is one LXT entry per set of 
> contiguous blocks for a virtual LUN (known both to the host and to the 
> AFU). Will clarify this with inline comments.

Please document this acronym before using it.

Mikey



