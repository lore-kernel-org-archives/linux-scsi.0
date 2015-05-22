From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 2/9] target/pr: Use atomic bitop for
 se_dev_entry->pr_reg reservation check
Date: Fri, 22 May 2015 02:05:57 -0700
Message-ID: <1432285557.898.28.camel@haakon3.risingtidesystems.com>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com>
	 <1432275071-28882-3-git-send-email-nab@daterainc.com>
	 <20150522082614.GA24640@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150522082614.GA24640@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-05-22 at 10:26 +0200, Christoph Hellwig wrote:
> On Fri, May 22, 2015 at 06:11:04AM +0000, Nicholas A. Bellinger wrote:
> > +	clear_bit(1, &orig->pr_reg);
> 
> Can you call it ->flags and give the bit a meaningful name?

The bit is signaling if se_dev_entry has a PR registration active.

I don't see how ->flags is a more meaningful name without other bits
defined.

> 
> > diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> > index c0b593a..d29b39c 100644
> > --- a/drivers/target/target_core_pr.c
> > +++ b/drivers/target/target_core_pr.c
> > @@ -327,9 +327,13 @@ static int core_scsi3_pr_seq_non_holder(
> >  	int we = 0; /* Write Exclusive */
> >  	int legacy = 0; /* Act like a legacy device and return
> >  			 * RESERVATION CONFLICT on some CDBs */
> > +	bool registered = false;
> >  
> >  	rcu_read_lock();
> >  	se_deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
> > +	if (se_deve)
> > +		registered = test_bit(1, &se_deve->pr_reg);
> > +	rcu_read_unlock();
> 
> It would be good to just sort out the registered and co variables
> here before the RCU changes, as in:
> 
> http://git.infradead.org/users/hch/scsi.git/commitdiff/6372d9f62c83acb30d051387c40deb4dbdcaa376

Why not just keep this patch squashed into the relevant commit in the
context of the larger RCU conversion..?
