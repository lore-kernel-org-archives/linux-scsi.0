From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Wed, 16 Mar 2005 19:53:59 +0100
Message-ID: <20050316185358.GC7842@suse.de>
References: <200503160209.j2G29cAf010870@hera.kernel.org> <20050316075839.GC7842@suse.de> <1110986016.5771.3.camel@mulgrave> <20050316160447.GU7842@suse.de> <20050316164806.GO21986@parcelfarce.linux.theplanet.co.uk> <20050316165338.GX7842@suse.de> <20050316170259.GA25056@infradead.org> <20050316170417.GY7842@suse.de> <42387EA2.5020106@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:32472 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262750AbVCPSyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 13:54:14 -0500
Content-Disposition: inline
In-Reply-To: <42387EA2.5020106@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, g.liakhovetski@gmx.de

On Wed, Mar 16 2005, Mike Christie wrote:
> Jens Axboe wrote:
> >On Wed, Mar 16 2005, Christoph Hellwig wrote:
> >
> >>On Wed, Mar 16, 2005 at 05:53:39PM +0100, Jens Axboe wrote:
> >>
> >>>The list doesn't really need dma mapping at that point, the problem here
> >>>is that the driver needs to punt to pio mode because of foo. So calling
> >>>pci/dma_map_* is pointless, since the CPU will have to do the transfer
> >>>anyways. What the driver is really looking for at this point, is a way
> >>>to map the pages in the sglist to a virtual address.
> >>
> >>Given that there's quite a few cases of this "problem" it would be nice
> >>to have common helpers for it.  Especially as it's really difficult when
> >>we allow merging of sg list entries
> >
> >
> >I thought about that when writing the above, but is there really more
> >than one case for SCSI drivers? If there is, sure lets add the helpers.
> >But I would consider it a quite rare occurence, I've never seen it
> >before.
> >
> 
> I got lost here. If you are talking about the need to kmap a sglist then 
> software iscsi has it. iscsi-sfnet used to do

I guess the need to kmap the sglist is not that uncommon, for other
reasons - libata would need it for manually filling data for commands it
emulates, other drives I know do the same. The punt-to-pio part is the
weird part, I hope no one else does that :-)

I guess we should add something ala

        sg_map_each_entry(sglist, entries, sg, ouput_ptr, flags) {
                /* transfer sg_virt_len(sg) to/from output_ptr */
        }

> while (...)
> 	kmap()
> 
> but I fixed that (I think I need to use kmap_atomic though, is that 
> correct or is it just a performance improvement - I am calling kmap from 
> a thread too so). I just added kmap_atomic to open-iscsi and I believe 
> pyx does something similar to the loop above.

The problem with this driver was that it did multiple kmaps, that is no
good. There's no problem doing a single kmap, copy, kunmap from your
thread. kmap_atomic() may be faster, but it requires that you stay
pinned on the same CPU. Usually it is still faster to us it, if you only
keep the mapping for a short time.

-- 
Jens Axboe

