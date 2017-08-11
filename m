From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/6] bsg: fix kernel panic resulting from missing
 allocation of a reply-buffer
Date: Fri, 11 Aug 2017 17:32:03 +0200
Message-ID: <20170811153203.GA31625@bblock-ThinkPad-W530>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
 <9e67ce3fc2f3cd42e9e05b2753b00d6676f46ee1.1502120928.git.bblock@linux.vnet.ibm.com>
 <20170810093217.GL24539@lst.de>
 <20170810221038.GA918@bblock-ThinkPad-W530>
 <20170811083808.GA5497@lst.de>
 <20170811091415.GA8099@lst.de>
 <20170811134929.GA1249@bblock-ThinkPad-W530>
 <20170811143649.GA32381@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170811143649.GA32381@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 11, 2017 at 04:36:49PM +0200, Christoph Hellwig wrote:
> On Fri, Aug 11, 2017 at 03:49:29PM +0200, Benjamin Block wrote:
> > On Fri, Aug 11, 2017 at 11:14:15AM +0200, Christoph Hellwig wrote:
> > > But patch 1 still creates an additional copy of the sense data for
> > > all bsg users.
> > >
> > 
> > Huh? What additional copy? There is one reply-buffer and that is copied
> > into the user-buffer should it contain valid data. Just like in your
> > patch, neither you, nor me touches any of the copy-code. There is also
> > no changes to how the driver get their data into that buffer, it will
> > still be copied in both cases.
> 
> You're right - I misread your patch.  But that does make it worse as
> this means that with your patch we re-assign the scsi_request.sense
> pointer when using bsg.  That will lead to crashes if using the bsg
> code against e.g. a normal scsi device using bsg when that request
> later gets reused for something that is not bsg.
>

So when the bsg interface is used with something different than the
bsg-lib request queue? I haven't actually thought about that (presuming
the bsg-lib queue was the only one being used). Fair enough, I haven't
completely read that code now, but that seems bad then, to reassign a
space allocated in someone else's request queue. 

That still leaves open that we now over-allocate space in bsg-lib, or?

> 
> > 
> > > 
> > > Can you test the patch below which implements my suggestion?  Your
> > > other patches should still apply fine on top modulo minor context
> > > changes.
> > 
> > Only your patch on top of 4.13-rc4. din_xferp (D) is also empty, which is
> > not taken from the sense-buffer.
> 
> Can't parse this.
> 
> > =============================================================================
> > BUG kmalloc-1024 (Not tainted): Invalid object pointer 0x000000004ad9e0f0
> > -----------------------------------------------------------------------------
> 
> Oops - if we don't allocate the job separately we should not free it either.
> Updated patch for that below:
>

My diff tells that this was the same patch as before.


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
