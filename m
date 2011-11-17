From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Thu, 17 Nov 2011 11:29:20 -0500
Message-ID: <20111117162919.GA3812@redhat.com>
References: <20111018154542.GB3869@osiris.boeblingen.de.ibm.com>
 <1318955380.5169.15.camel@dabdike.int.hansenpartnership.com>
 <20111031100557.GA2621@osiris.boeblingen.de.ibm.com>
 <1320057746.2964.1.camel@dabdike>
 <4EAE8A7E.8000504@ce.jp.nec.com>
 <20111031130004.GB4768@osiris.boeblingen.de.ibm.com>
 <20111103182548.GA12131@redhat.com>
 <20111104091936.GB2397@osiris.boeblingen.de.ibm.com>
 <4EBA49C2.1000704@suse.de>
 <20111110161008.GA15659@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111110161008.GA15659@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>, gmuelas@de.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 10 2011 at 11:10am -0500,
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Wed, Nov 09, 2011 at 10:37:06AM +0100, Hannes Reinecke wrote:

...
 
> > Hmm. Just to be on the safe side, could you try this one:
> > 
> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index 5e0090e..e6fad46 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -920,8 +920,10 @@ static int multipath_map(struct dm_target *ti,
> > struct reque
> > st *clone,
> >         map_context->ptr = mpio;
> >         clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
> >         r = map_io(m, clone, mpio, 0);
> > -       if (r < 0 || r == DM_MAPIO_REQUEUE)
> > +       if (r < 0 || r == DM_MAPIO_REQUEUE) {
> >                 mempool_free(mpio, m->mpio_pool);
> > +               map_context->ptr = NULL;
> > +       }
> > 
> >         return r;
> >  }
> 
> With your patch we haven't been able to reproduce the kernel crash until now.
> Now we "only" run into I/O stalls, which before your patch we also did. But
> repeatedly rebooting and retrying and ignoring the I/O stalls always lead to
> a crash.
> Gonzalo will run a couple of extra rounds so we can have a feeling if at least
> one of the bugs could be fixed with your patch ;)

Hi,

Any update after further testing with Hannes' patch?
