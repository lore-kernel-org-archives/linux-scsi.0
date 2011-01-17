From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: PMP and SEMB messages to SEP
Date: Mon, 17 Jan 2011 11:21:46 -0600
Message-ID: <1295284906.3015.136.camel@mulgrave.site>
References: <20110113192558.GE16039@MAIL.13thfloor.at>
	 <20110114142018.GA978@htj.dyndns.org>
	 <20110114165957.GH16039@MAIL.13thfloor.at>
	 <20110114170407.GE978@htj.dyndns.org>
	 <20110114173759.GI16039@MAIL.13thfloor.at>
	 <20110117154042.GG27123@htj.dyndns.org>
	 <1295281131.3015.44.camel@mulgrave.site>
	 <20110117171836.GI27123@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20110117171836.GI27123@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-01-17 at 18:18 +0100, Tejun Heo wrote:
> Hello, James.
> 
> On Mon, Jan 17, 2011 at 10:18:51AM -0600, James Bottomley wrote:
> > > The problem is that the PMP device itself is currently not allocated a
> > > userland visible device, so it doesn't have any /dev/* node.  Hmmm...
> > 
> > So perhaps it should be.  If you look at the equivalent topology on SAS,
> > our expanders have a bsg device node precisely so that we can do this.
> >
> > That said, SAS expanders have a defined protocol (SAS Management
> > Protocol) to talk to the outside world, so they are real visible objects
> > always in our topology ... I'm not sure PMP has this ... it seems that
> > all PMP visibility is an extension to the standard?
> 
> SATA PMP is mostly a dumb switch and there isn't much which can be
> done by issuing custom commands (and IIRC we didn't have bsg back
> then), so it was never made visible to userland, but yeah probably
> exporting a bsg node is a good idea.  Inside libata, the PMP device
> has its device representation and all so it shouldn't be too difficult
> either.  Not really sure how the inquiry and stuff should be handled
> tho.

Expanders aren't SCSI devices either ... that means they don't appear as
visible to standard SCSI mechanisms like INQUIRY (SMP isn't a SCSI
protocol it's a SAS extension).  They just appear as part of the
topology in the device tree.

James


