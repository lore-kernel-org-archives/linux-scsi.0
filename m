From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 2/9] target/pr: Use atomic bitop for
	se_dev_entry->pr_reg reservation check
Date: Fri, 22 May 2015 13:34:04 +0200
Message-ID: <20150522113404.GB28758@lst.de>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com> <1432275071-28882-3-git-send-email-nab@daterainc.com> <20150522082614.GA24640@lst.de> <1432285557.898.28.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432285557.898.28.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 22, 2015 at 02:05:57AM -0700, Nicholas A. Bellinger wrote:
> On Fri, 2015-05-22 at 10:26 +0200, Christoph Hellwig wrote:
> > On Fri, May 22, 2015 at 06:11:04AM +0000, Nicholas A. Bellinger wrote:
> > > +	clear_bit(1, &orig->pr_reg);
> > 
> > Can you call it ->flags and give the bit a meaningful name?
> 
> The bit is signaling if se_dev_entry has a PR registration active.
> 
> I don't see how ->flags is a more meaningful name without other bits
> defined.

It's pretty normal style: define a flags variable for any sort of
bitops state that might show up, and then give the actual bits a meaningful
name.  There's almost no users of using a magic numberic value with
atomic bitops.

Besides being the usual and thus easier to read style it's also good
future proofing.

> > It would be good to just sort out the registered and co variables
> > here before the RCU changes, as in:
> > 
> > http://git.infradead.org/users/hch/scsi.git/commitdiff/6372d9f62c83acb30d051387c40deb4dbdcaa376
> 
> Why not just keep this patch squashed into the relevant commit in the
> context of the larger RCU conversion..?

Because the logic in and aroudn core_scsi3_pr_seq_non_holder right
now is rather confusing.  So before doing changes to it it's better
to clean it up first, document that cleanup in a standalon patch
and then apply the logic change on top.
