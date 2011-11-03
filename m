From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Thu, 3 Nov 2011 14:25:48 -0400
Message-ID: <20111103182548.GA12131@redhat.com>
References: <1318608184.3018.42.camel@dabdike.int.hansenpartnership.com>
 <4E9BEB68.1050707@ce.jp.nec.com>
 <1318860403.4794.12.camel@dabdike.int.hansenpartnership.com>
 <4E9D7FA8.9000000@ce.jp.nec.com>
 <20111018154542.GB3869@osiris.boeblingen.de.ibm.com>
 <1318955380.5169.15.camel@dabdike.int.hansenpartnership.com>
 <20111031100557.GA2621@osiris.boeblingen.de.ibm.com>
 <1320057746.2964.1.camel@dabdike>
 <4EAE8A7E.8000504@ce.jp.nec.com>
 <20111031130004.GB4768@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111031130004.GB4768@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>, gmuelas@de.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 31 2011 at  9:00am -0400,
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Mon, Oct 31, 2011 at 08:46:06PM +0900, Jun'ichi Nomura wrote:
> > Hm, dm_softirq_done is generic completion code of original
> > request in dm-multipath.
> > So oops here might be another manifestation of use-after-free.
> > 
> > Do you always hit the oops at the same address?
> 
> I think we saw this bug the first time. But before that the scsi
> logging level was higher. Gonzalo is trying to recreate it with
> the same (old) scsi logging level.
> Afterwards we will try with barrier=0.
> 
> Both on v3.0.7 btw.
> 
> > Could you find corresponding source code line for
> > the crashed address, dm_softirq_done+0x72/0x140,
> > and which pointer was invalid?
> 
> It crashes in the inlined function dm_done() when trying to
> dereference tio (aka clone->end_io_data):
> 
> static void dm_done(struct request *clone, int error, bool mapped)
> {
>         int r = error;
>         struct dm_rq_target_io *tio = clone->end_io_data;
>         dm_request_endio_fn rq_end_io = tio->ti->type->rq_end_io;

Hi,

Which underlying storage driver is being used by this multipath device?

Thanks,
Mike
