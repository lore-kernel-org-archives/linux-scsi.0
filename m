From: Jens Axboe <axboe@suse.de>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Thu, 31 Oct 2002 16:12:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031151212.GG6549@suse.de>
References: <20021030213619.A183086E82@primary.mx.nitric.com> <200210302219.g9UMJ5w05948@eng2.beaverton.ibm.com> <20021031150408.GF6549@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021031150408.GF6549@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Badari Pulavarty <badari@us.ibm.com>
Cc: merlin hughes <merlin@merlin.org>, linux-scsi@vger.kernel.org

On Thu, Oct 31 2002, Jens Axboe wrote:
> On Wed, Oct 30 2002, Badari Pulavarty wrote:
> > > >- Badari
> > > 
> > > Hi; if it's of any use, the patch doesn't seem to solve the scsi
> > > problem for me (2.5.44-bk3-badari). I get the usual 'Incorrect number
> > > of segments...' and random kernel death during the boot process.
> > > 
> > > Merlin
> > 
> > Hi Merlin,
> > 
> > I am looking at the output  of your problem ..
> > 
> > 
> > Oct 28 12:36:09 badb kernel: Incorrect number of segments after building list 
> > Oct 28 12:36:09 badb kernel: counted 2, received 1 
> > Oct 28 12:36:09 badb kernel: req nr_sec 8, cur_nr_sec 8 
> > Oct 28 12:36:09 badb kernel: end_request: I/O error, dev 08:40, sector 6784528 
> > Oct 28 12:36:09 badb kernel: raid5: Disk failure on scsi/host0/bus0/target4/lun0/part7, disabling device. Operation continuing on 4 devices 
> > 
> > Huh !! Your IO size is only 4K. You are using 2 sg entries ?
> 
> Even weirder, nr_sec == cur_nr_sec so there can only be one segment or
> something is corrupted...

Ah wait, I think I may know at least what is happening in this case.
I've seen numerous reports of software raid problems botching bio's, and
this above one could easily be explained with one of the bio's having
!bi_size. In fact, it's about the only explanation, otherwise there's
just no way we can have nr_sec == cur_nr_sec unless only _one_ bio is
attached to the request.

Merlin, please also add a

	blk_dump_rq_flags(req, "scsi_init_io");

to drivers/scsi/scsi_lib.c:scsi_init_io() before it calls
scsi_end_request() and kills the request (right after the incorrect
segment complaining).

Badari, I'm not so sure that Merlin's and your bug are the same. Is
yours solved by the patch I sent out earlier? AFAICT, that should fix
the segment miscounting.

-- 
Jens Axboe

