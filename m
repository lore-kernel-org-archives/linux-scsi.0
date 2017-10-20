From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH 9/9] bsg: split handling of SCSI CDBs vs transport
 requeues
Date: Fri, 20 Oct 2017 18:47:27 +0200
Message-ID: <20171020164727.GA26380@bblock-ThinkPad-W530>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-10-hch@lst.de>
 <20171019155933.GE26185@bblock-ThinkPad-W530>
 <20171020162630.GA14277@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171020162630.GA14277@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 20, 2017 at 06:26:30PM +0200, Christoph Hellwig wrote:
> On Thu, Oct 19, 2017 at 05:59:33PM +0200, Benjamin Block wrote:
> > > +#define ptr64(val) ((void __user *)(uintptr_t)(val))
> > 
> > Better to reflect the special property, that it is a user pointer, in
> > the name of the macro. Maybe something like user_ptr(64). The same
> > comment for the same macro in bsg.c.
> 
> Not sure it's worth it especially now that Martin has merged the patch.

He did? I only saw a mail that he picked patches 2-5. So all the bsg
changes are still open I think.

(Maybe I just missed that, I haven't exactly followed the list very
closely as of late)

> But given how many interface we have all over the kernel that use a u64
> to store a user pointer in ioctls and similar it might make sense to
> lift a helper like this to a generic header.  In that case we'll need
> a more descriptive name for sure.
> 
> > > +static int bsg_transport_check_proto(struct sg_io_v4 *hdr)
> > > +{
> > > +	if (hdr->protocol != BSG_PROTOCOL_SCSI  ||
> > > +	    hdr->subprotocol != BSG_SUB_PROTOCOL_SCSI_TRANSPORT)
> > > +		return -EINVAL;
> > > +	if (!capable(CAP_SYS_RAWIO))
> > > +		return -EPERM;
> > 
> > Any particular reason why this is not symmetric with bsg_scsi? IOW
> > permission checking done in bsg_transport_fill_hdr(), like it is done in
> > bsg_scsi_fill_hdr()?
> > 
> > We might save some time copying memory with this (we also only talk
> > about ~20 bytes here), but on the other hand the interface would be more
> > clean otherwise IMO (if we already do restructure the interface) -
> > similar callbacks have similar responsibilities.
> 
> I could move the capable check around, no sure why I had done it that
> way, it's been a while.  Probably because blk_verify_command needs the
> CDB while a simple capable() check does not.

That was my guess, too. I just though it would be more consistent otherwise.
Its not a big thing, really.


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
