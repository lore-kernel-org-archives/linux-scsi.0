From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 01/12] target: Convert se_node_acl->device_list[] to RCU
 hlist
Date: Mon, 18 May 2015 23:05:47 -0700
Message-ID: <1432015547.9093.76.camel@haakon3.risingtidesystems.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com>
	 <1431422736-29125-2-git-send-email-nab@daterainc.com>
	 <20150513063555.GA21770@lst.de>
	 <1431506771.26897.78.camel@haakon3.risingtidesystems.com>
	 <20150517165142.GA17217@lst.de>
	 <1431933444.24645.7.camel@haakon3.risingtidesystems.com>
	 <20150518074102.GA6157@lst.de> <20150518080155.GA6451@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150518080155.GA6451@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

(resending)

On Mon, 2015-05-18 at 10:01 +0200, Christoph Hellwig wrote:
> On Mon, May 18, 2015 at 09:41:02AM +0200, Christoph Hellwig wrote:
> > > Here's a first pass at this along with kref + completion conversion for
> > > the special case PR ALL_TGT_PT=1 pointer dereference.
> > 
> > Btw, I started hacking up a patch to merge se_port and t10_alua_tg_pt_gp_member
> > in se_lun, which seems even better as it closes all kinds of other
> > races.  Can you keep this one back for now, I'll send out that patch
> > ASAP after finishing some testing.
> 
> Ok, testing showed that the baseline (your for-next tree from yesterday)
> already doesn't work for tcm_loop and probably any generated nodeacl case,
> and gets a:
> 
> [   12.830576] kernel BUG at ../drivers/target/target_core_device.c:337!
> 

How did you hit this..?

I'm not triggering this with normal tcm_loop LUN creation, nor generated
node_acls for iscsi-target.

This particular BUG_ON() should only be triggered when the generated ->
explicit conversion happens, when the generated LUN does not match the
explicit one created in configfs.

In practice, this should fail with -EINVAL instead and not trigger a
BUG_ON().

> I've also looked over your patch and found at least two issues with it:
> 
>  - given that core_dev_unexport clears ->lun_se_dev all the callers
>    in the stats code still need to check for it being zero
>  - the 64-bit stats still need a lock protecting them, or made atomics.
>    The same issue already applies with the base RCU patches for the counters
>    in the se_dev_entry, btw.
> 

Fixing this up.

> Anyway, below is my patch, which I think will be very useful as it
> closes all kinds of races by merging the structures.  Applying rcu
> lookups for ->lun_se_dev and removign the busy loop for the refcount
> would be a good next step on top of that.
> 

This is obviously another huge change, and as a single patch is going to
take a while to understand and review.

That said, I'll take it for now and put the ALL_TGT_PT=1 changes on top.

--nab
