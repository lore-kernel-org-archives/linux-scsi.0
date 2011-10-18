From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Tue, 18 Oct 2011 11:29:40 -0500
Message-ID: <1318955380.5169.15.camel@dabdike.int.hansenpartnership.com>
References: <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com>
	 <1317183038.17578.9.camel@dabdike.hansenpartnership.com>
	 <4E832A55.30709@kernel.dk>
	 <1317219074.19034.4.camel@dabdike.hansenpartnership.com>
	 <4E832BD2.50409@kernel.dk> <4E96E2FF.6070601@linux.vnet.ibm.com>
	 <1318608184.3018.42.camel@dabdike.int.hansenpartnership.com>
	 <4E9BEB68.1050707@ce.jp.nec.com>
	 <1318860403.4794.12.camel@dabdike.int.hansenpartnership.com>
	 <4E9D7FA8.9000000@ce.jp.nec.com>
	 <20111018154542.GB3869@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111018154542.GB3869@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-10-18 at 17:45 +0200, Heiko Carstens wrote:
> On Tue, Oct 18, 2011 at 10:31:20PM +0900, Jun'ichi Nomura wrote:
> > On 10/17/11 23:06, James Bottomley wrote:
> > > On Mon, 2011-10-17 at 17:46 +0900, Jun'ichi Nomura wrote:
> > >> On 10/15/11 01:03, James Bottomley wrote:
> > >>> On Thu, 2011-10-13 at 15:09 +0200, Steffen Maier wrote:
> > >>>> Initially, we encountered use-after-free bugs in
> > >>>> scsi_print_command / scsi_dispatch_cmd
> > >>>> http://marc.info/?l=linux-scsi&m=130824013229933&w=2
> > >>
> > >> It is interesting that both this and the older report
> > >> got oopsed in scsi_log_send(), while there are other
> > >> dereferences of 'cmd' around scsi_dispatch_cmd().
> > >> Are there any reason they are special? Just by accident?
> > > 
> > > Right, that's why it looks like the command area got freed rather than
> > > the command pointer was bogus (6b is a poison free pattern).  Perhaps if
> > > the reporter could pin down the failing source line, we'd know better
> > > what was going on?
> > 
> > Yeah, that might be useful.
> 
> The struct scsi_cmnd that was passed to scsi_log_send() was already freed
> (contents completely 6b6b6b...).
> Since SLUB debugging was turned on we can see that it was freed from
> __scsi_put_command(). Not too much of a surprise.

But it does tell us the put must be racing with dispatch, since
dereferencing the command to find the device worked higher up in
scsi_dispatch_cmd().

There is one way to invalidate the theory that we cloned something with
an attached command, and that's to put 

BUG_ON(rq->special)

in blk_insert_cloned_request().  I think we're careful about clearing
it, so it should work (perhaps a warn on just in case).

James
