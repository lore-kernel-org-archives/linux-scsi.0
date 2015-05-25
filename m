From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 2/9] target/pr: Use atomic bitop for
 se_dev_entry->pr_reg reservation check
Date: Mon, 25 May 2015 15:25:37 -0700
Message-ID: <1432592737.722.19.camel@haakon3.risingtidesystems.com>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com>
	 <1432275071-28882-3-git-send-email-nab@daterainc.com>
	 <20150522082614.GA24640@lst.de>
	 <1432285557.898.28.camel@haakon3.risingtidesystems.com>
	 <20150522113404.GB28758@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150522113404.GB28758@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-05-22 at 13:34 +0200, Christoph Hellwig wrote:
> On Fri, May 22, 2015 at 02:05:57AM -0700, Nicholas A. Bellinger wrote:
> > On Fri, 2015-05-22 at 10:26 +0200, Christoph Hellwig wrote:
> > > On Fri, May 22, 2015 at 06:11:04AM +0000, Nicholas A. Bellinger wrote:
> > > > +	clear_bit(1, &orig->pr_reg);
> > > 
> > > Can you call it ->flags and give the bit a meaningful name?
> > 
> > The bit is signaling if se_dev_entry has a PR registration active.
> > 
> > I don't see how ->flags is a more meaningful name without other bits
> > defined.
> 
> It's pretty normal style: define a flags variable for any sort of
> bitops state that might show up, and then give the actual bits a meaningful
> name.  There's almost no users of using a magic numberic value with
> atomic bitops.
> 
> Besides being the usual and thus easier to read style it's also good
> future proofing.

Fair enough.  Changing this to ->deve_flags

> 
> > > It would be good to just sort out the registered and co variables
> > > here before the RCU changes, as in:
> > > 
> > > http://git.infradead.org/users/hch/scsi.git/commitdiff/6372d9f62c83acb30d051387c40deb4dbdcaa376
> > 
> > Why not just keep this patch squashed into the relevant commit in the
> > context of the larger RCU conversion..?
> 
> Because the logic in and aroudn core_scsi3_pr_seq_non_holder right
> now is rather confusing.  So before doing changes to it it's better
> to clean it up first, document that cleanup in a standalon patch
> and then apply the logic change on top.
> --

I'll keep it in a standalone patch, but having it precede the RCU
changes when it doesn't actually involve RCU is confusing.
