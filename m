From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 00/22] target: se_node_acl LUN list RCU conversion
Date: Tue, 31 Mar 2015 23:51:56 -0700
Message-ID: <1427871116.9176.240.camel@haakon3.risingtidesystems.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
	 <20150330120823.GA20193@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150330120823.GA20193@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-03-30 at 05:08 -0700, Christoph Hellwig wrote:
> I went through this in detail, and the odd patch split that splits
> one change up into muliple patches, but then also mixes up other
> changes makes it hard to read.
> 

Thanks for having a look.  Will fix up patch ordering for -v2.

> So I started rebasing the tree to understand it moving your various
> cleanups to the front of the series.  Of coure while reading through
> it the number of cleanups grew, so there are a few more now.
> 

;)

> Based on that I don't think this series will work very well, RCU works
> when replacing strutures in a lookup data structure, but not when
> changing the content of it, so the new locking scheme doesn't work
> very well, as the device_list array is static, it's just the content
> that changes.
> 

The initial series was primarily to get some feedback on the non trivial
PR cases.

Since last week, enable/disable device_list code has been converted to
use mempool + call_rcu() and performs the RCU pointer swap in
se_node_acl->lun_entry_hlist[] under se_node_acl->lun_entry_mutex.

There are a few more target_core_pr.c pieces that need to be updated to
handle NULL se_node_acl->lun_entry_hlist[] pointers, along with proper
rcu_dereference_protected() and rcu_access_pointer() notations for
se_dev_entry pointer access outside of RCU read lock.

>From there, it should be an straight-forward conversion to rcu hlist for
se_node_acl->lun_entry_list[] and se_portal_group->tpg_lun_list[] to
support dynamic LUN layouts.

> Fortunately there is the old patch from Andy to make the se_dev_entry
> dynamically allocated, which comes in useful here.  With that we might
> only change the rdonly flag on a live dev entry, or assign an ACL when
> it previously was NULL, something that RCU can handle nicely.
> 
> I've pushed a git tree to
> 
> 	git://git.infradead.org/users/hch/scsi.git target-rcu-hch
> 
> Gitweb:
> 
> 	http://git.infradead.org/users/hch/scsi.git/shortlog/refs/heads/target-rcu-hch
> 
> that implements this scheme.  Note that I dropped the percpu refcount
> changes - the reference is only taken in the SCSI3-PR slow path, and the
> percpu refcount API is extremly cumbersome.
> 

Well, there still needs to be some manner of reference counting on
se_dev_entry once rcu_read_lock() is released for the REGISTER w/ I_PORT
and REGISTER_AND_MOVE cases with a non-local I_T_L se_dev_entry
reference.

Otherwise, an RCU update can occur from below the reader unless the PR
special cases are allowed to drop pointer reference + invoke struct
completion before call_rcu() is dispatched to release memory.

> This survives I/O testing nicely, but I couldn't find a good test suite
> for the control path.
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
