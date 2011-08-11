From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] cxgb3i: ref count cdev access to prevent modification
 while in use (v3)
Date: Thu, 11 Aug 2011 15:11:47 -0400
Message-ID: <20110811191147.GC23747@hmsreliant.think-freely.org>
References: <1313086002-23653-1-git-send-email-nhorman@tuxdriver.com>
 <1313087766.4166.27.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57208 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1HKTLz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2011 15:11:55 -0400
Content-Disposition: inline
In-Reply-To: <1313087766.4166.27.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Divy Le Ray <divy@chelsio.com>, Steve Wise <swise@chelsio.com>, Karen Xie <kxie@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>, "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>

On Thu, Aug 11, 2011 at 06:36:10PM +0000, James Bottomley wrote:
> On Thu, 2011-08-11 at 14:06 -0400, Neil Horman wrote:
> > This oops was reported recently:
> > d:mon> e
> > cpu 0xd: Vector: 300 (Data Access) at [c0000000fd4c7120]
> >     pc: d00000000076f194: .t3_l2t_get+0x44/0x524 [cxgb3]
> >     lr: d000000000b02108: .init_act_open+0x150/0x3d4 [cxgb3i]
> >     sp: c0000000fd4c73a0
> >    msr: 8000000000009032
> >    dar: 0
> >  dsisr: 40000000
> >   current = 0xc0000000fd640d40
> >   paca    = 0xc00000000054ff80
> >     pid   = 5085, comm = iscsid
> > d:mon> t
> > [c0000000fd4c7450] d000000000b02108 .init_act_open+0x150/0x3d4 [cxgb3i]
> > [c0000000fd4c7500] d000000000e45378 .cxgbi_ep_connect+0x784/0x8e8 [libcxgbi]
> > [c0000000fd4c7650] d000000000db33f0 .iscsi_if_rx+0x71c/0xb18
> > [scsi_transport_iscsi2]
> > [c0000000fd4c7740] c000000000370c9c .netlink_data_ready+0x40/0xa4
> > [c0000000fd4c77c0] c00000000036f010 .netlink_sendskb+0x4c/0x9c
> > [c0000000fd4c7850] c000000000370c18 .netlink_sendmsg+0x358/0x39c
> > [c0000000fd4c7950] c00000000033be24 .sock_sendmsg+0x114/0x1b8
> > [c0000000fd4c7b50] c00000000033d208 .sys_sendmsg+0x218/0x2ac
> > [c0000000fd4c7d70] c00000000033f55c .sys_socketcall+0x228/0x27c
> > [c0000000fd4c7e30] c0000000000086a4 syscall_exit+0x0/0x40
> > --- Exception: c01 (System Call) at 00000080da560cfc
> > 
> > The root cause was an EEH error, which sent us down the offload_close path in
> > the cxgb3 driver, which in turn sets cdev->lldev to NULL, without regard for
> > upper layer driver (like the cxgbi drivers) which might have execution contexts
> > in the middle of its use. The result is the oops above, when t3_l2t_get attempts
> > to dereference cdev->lldev right after the EEH error handler sets it to NULL.
> > 
> > The fix is to reference count the cdev structure.  When an EEH error occurs, the
> > shutdown path:
> > t3_adapter_error->offload_close->cxgb3i_remove_clients->cxgb3i_dev_close
> > will now block until such time as the cdev pointer has a use count of zero.
> > This coupled with the fact that lookups will now skip finding any registered
> > cdev's in cxgbi_device_find_by_[lldev|netdev] with the CXGBI_FLAG_ADAPTER_RESET
> > bit set ensures that on an EEH, the setting of lldev to NULL in offload_close
> > will only happen after there are no longer any active users of the data
> > structure.
> > 
> > This has been tested by the reporter and shown to fix the reproted oops
> > 
> > Change notes:
> > 
> > v2) Resent because of some build warnings with the first version on request of
> > JBottomley
> > 
> > v3) Modified to use kref refcounting api. It doesn't do much for this code,
> > since the purpose of refcounting is primarily to serialize the clearing of a
> > pointer in another data structure in a different module, but I think it does
> > look a bit cleaner.  I've built this code, but not had the chance to test it
> > yet, given that I'm about to leave on vacation.  I wanted to get it posted for
> > review before I left. It should work fine, since its effectively a replacement
> > of the raw atomic with struct krefs.  Karen, if you could run this on some
> > cxgb3i equipment to make sure I didn't inadvertently do anything stupid, I'd
> > aprpeciate it.  Thanks!
> 
> With any of these updates, doesn't cxgb4i also need updating?
> 
Possibly, I've not looked (nor had the opportunity to get testing) done there
yet.

> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > CC: Divy Le Ray <divy@chelsio.com>
> > CC: Steve Wise <swise@chelsio.com>
> > CC: Karen Xie <kxie@chelsio.com>
> > CC: Mike Christie <michaelc@cs.wisc.edu>
> > CC: "James E.J. Bottomley" <JBottomley@parallels.com>
> > CC: stable-commits@vger.kernel.org
> > ---
> >  drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |    8 +++++++-
> >  drivers/scsi/cxgbi/libcxgbi.c      |   21 +++++++++++++++++----
> >  drivers/scsi/cxgbi/libcxgbi.h      |    5 +++++
> >  3 files changed, 29 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> > index bd22041..855ee23 100644
> > --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> > +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> > @@ -1303,9 +1303,13 @@ static void cxgb3i_dev_close(struct t3cdev *t3dev)
> >  
> >  	if (!cdev || cdev->flags & CXGBI_FLAG_ADAPTER_RESET) {
> >  		pr_info("0x%p close, f 0x%x.\n", cdev, cdev ? cdev->flags : 0);
> > +		if (cdev)
> > +			cdev_put(cdev);
> > +		while (cdev && atomic_read(&cdev->use_count.refcount) > 1)
> > +			msleep(1);
> 
> OK, so this was what leapt out the last time as a big no-no.  Firstly,
> do you really have to wait for destruction?  If so, use a completion.
> 
So, this is really the crux of the issue.  I'm sorry If it wasn't sufficiently
clear in the explination above. Let me try again:

The root of the problem is the racy assignments of ->lldev in offload_open and
ofload_close.  cdev->lldev is dereferenced in init_act_open every time a new
iscsi connection is established.  If we encounter an adapter error and go down
the cxgb3 EEH path, we wind up in offload_close, which sets->lldev to NULL.  If
this occurs while a connection is being established in init_act_open, we can get
a NULL pointer as ->lldev, and we get the oops above.

So my approach to fix this was to serialize the setting of cdev->lldev to NULL behind
a guarantee that there are no current users of cdev.  Since the cxgb3i driver
only grabs cdevs via cxgbi_find_by_lldev or find_by_netdev, a reference count
seemed like the way to go.  Not sure I could do the same efficiently with a
completion.

I had also thought about moving the NULL setting into part of the release
routine of kref_put (or previously my raw atomic use), but since that code (or
the code that accesses it isn't at all serialized with a spinlock, I figured a
reference count would be more efficient.  It all boils down (In my mind) to the
fact that we're just modifying a pointer here, not actually dstroying a struct.

Truthfully, the way this code works probably needs a larger re-working than what
I'm doing here, given how often I got turned around in it, but I'm nowhere near
familiar enough with this driver to do that effectively.  I'm just trying to fix
the oops at hand.

> >  		return;
> >  	}
> > -
> > +	cdev_put(cdev);
> >  	cxgbi_device_unregister(cdev);
> >  }
> >  
> > @@ -1320,6 +1324,7 @@ static void cxgb3i_dev_open(struct t3cdev *t3dev)
> >  	int i, err;
> >  
> >  	if (cdev) {
> > +		cdev_put(cdev);
> >  		pr_info("0x%p, updating.\n", cdev);
> 
> Other way around, otherwise it's use after free.
> 
Doh, thanks!

> >  		return;
> >  	}
> > @@ -1392,6 +1397,7 @@ static void cxgb3i_dev_event_handler(struct t3cdev *t3dev, u32 event, u32 port)
> >  		cdev->flags &= ~CXGBI_FLAG_ADAPTER_RESET;
> >  		break;
> >  	}
> > +	cdev_put(cdev);
> >  }
> >  
> >  /**
> > diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> > index 77ac217..297efaa 100644
> > --- a/drivers/scsi/cxgbi/libcxgbi.c
> > +++ b/drivers/scsi/cxgbi/libcxgbi.c
> > @@ -95,8 +95,10 @@ void cxgbi_device_portmap_cleanup(struct cxgbi_device *cdev)
> >  }
> >  EXPORT_SYMBOL_GPL(cxgbi_device_portmap_cleanup);
> >  
> > -static inline void cxgbi_device_destroy(struct cxgbi_device *cdev)
> > +void cxgbi_device_destroy(struct kref *kr)
> >  {
> > +	struct cxgbi_device *cdev = container_of(kr, struct cxgbi_device, use_count);
> > +
> >  	log_debug(1 << CXGBI_DBG_DEV,
> >  		"cdev 0x%p, p# %u.\n", cdev, cdev->nports);
> >  	cxgbi_hbas_remove(cdev);
> > @@ -111,6 +113,7 @@ static inline void cxgbi_device_destroy(struct cxgbi_device *cdev)
> >  		cxgbi_free_big_mem(cdev->pmap.port_csk);
> >  	kfree(cdev);
> >  }
> > +EXPORT_SYMBOL_GPL(cxgbi_device_destroy);
> 
> There's no cross module use, is there? so no need of an export.
I suppose not. Sorry, was thinking that libcxgbi had common code that wen't in
its own module.

> 
> >  struct cxgbi_device *cxgbi_device_register(unsigned int extra,
> >  					   unsigned int nports)
> > @@ -125,6 +128,7 @@ struct cxgbi_device *cxgbi_device_register(unsigned int extra,
> >  		pr_warn("nport %d, OOM.\n", nports);
> >  		return NULL;
> >  	}
> > +	kref_init(&cdev->use_count);
> >  	cdev->ports = (struct net_device **)(cdev + 1);
> >  	cdev->hbas = (struct cxgbi_hba **)(((char*)cdev->ports) + nports *
> >  						sizeof(struct net_device *));
> > @@ -151,7 +155,7 @@ void cxgbi_device_unregister(struct cxgbi_device *cdev)
> >  	mutex_lock(&cdev_mutex);
> >  	list_del(&cdev->list_head);
> >  	mutex_unlock(&cdev_mutex);
> > -	cxgbi_device_destroy(cdev);
> > +	cdev_put(cdev);
> >  }
> >  EXPORT_SYMBOL_GPL(cxgbi_device_unregister);
> >  
> > @@ -167,7 +171,7 @@ void cxgbi_device_unregister_all(unsigned int flag)
> >  				cdev, cdev->nports, cdev->nports ?
> >  				 cdev->ports[0]->name : "");
> >  			list_del(&cdev->list_head);
> > -			cxgbi_device_destroy(cdev);
> > +			cdev_put(cdev);
> >  		}
> >  	}
> >  	mutex_unlock(&cdev_mutex);
> > @@ -181,6 +185,9 @@ struct cxgbi_device *cxgbi_device_find_by_lldev(void *lldev)
> >  	mutex_lock(&cdev_mutex);
> >  	list_for_each_entry_safe(cdev, tmp, &cdev_list, list_head) {
> >  		if (cdev->lldev == lldev) {
> > +			if (cdev->flags & CXGBI_FLAG_ADAPTER_RESET)
> > +				continue;
> > +			cdev_hold(cdev);
> >  			mutex_unlock(&cdev_mutex);
> >  			return cdev;
> >  		}
> > @@ -210,7 +217,10 @@ static struct cxgbi_device *cxgbi_device_find_by_netdev(struct net_device *ndev,
> >  	list_for_each_entry_safe(cdev, tmp, &cdev_list, list_head) {
> >  		for (i = 0; i < cdev->nports; i++) {
> >  			if (ndev == cdev->ports[i]) {
> > +				if (cdev->flags & CXGBI_FLAG_ADAPTER_RESET)
> > +					continue;
> >  				cdev->hbas[i]->vdev = vdev;
> > +				cdev_hold(cdev);
> >  				mutex_unlock(&cdev_mutex);
> >  				if (port)
> >  					*port = i;
> > @@ -469,7 +479,7 @@ static struct cxgbi_sock *cxgbi_check_route(struct sockaddr *dst_addr)
> >  	struct sockaddr_in *daddr = (struct sockaddr_in *)dst_addr;
> >  	struct dst_entry *dst;
> >  	struct net_device *ndev;
> > -	struct cxgbi_device *cdev;
> > +	struct cxgbi_device *cdev = NULL;
> >  	struct rtable *rt = NULL;
> >  	struct flowi4 fl4;
> >  	struct cxgbi_sock *csk = NULL;
> > @@ -542,6 +552,8 @@ rel_rt:
> >  	if (csk)
> >  		cxgbi_sock_closed(csk);
> >  err_out:
> > +	if (cdev)
> > +		cdev_put(cdev);
> >  	return ERR_PTR(err);
> >  }
> >  
> > @@ -2491,6 +2503,7 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
> >  	return ep;
> >  
> >  release_conn:
> > +	cdev_put(csk->cdev);
> 
> This isn't right.  an embedded device reference should be released in
> the csk release function (cxgbi_sock_free).
> 
Ok, I can fix that

> >  	cxgbi_sock_put(csk);
> >  	cxgbi_sock_closed(csk);
> >  err_out:
> > diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
> > index 9267844..08788ac 100644
> > --- a/drivers/scsi/cxgbi/libcxgbi.h
> > +++ b/drivers/scsi/cxgbi/libcxgbi.h
> > @@ -24,6 +24,7 @@
> >  #include <linux/scatterlist.h>
> >  #include <linux/skbuff.h>
> >  #include <linux/vmalloc.h>
> > +#include <linux/kref.h>
> >  #include <scsi/scsi_device.h>
> >  #include <scsi/libiscsi_tcp.h>
> >  
> > @@ -514,6 +515,7 @@ struct cxgbi_device {
> >  	unsigned int flags;
> >  	struct net_device **ports;
> >  	void *lldev;
> > +	struct kref use_count;
> >  	struct cxgbi_hba **hbas;
> >  	const unsigned short *mtus;
> >  	unsigned char nmtus;
> > @@ -557,6 +559,8 @@ struct cxgbi_device {
> >  	void *dd_data;
> >  };
> >  #define cxgbi_cdev_priv(cdev)	((cdev)->dd_data)
> > +#define cdev_hold(x) do {kref_get(&(x)->use_count);} while(0)
> 
> hold is non standard, use put instead.
> 
You mean get?  I can do that.


Given what I noted above, do you think its worth pursuing this?  Or does this
need a larger fix than what a refcount can offer.  We want to be able to
tdel_lldev to NULL in offload_close safely, when there are no other users of
that structure.  I can't really see a way to do it without completely
overhauling how this code works.  I suppose we could do some rcu magic to do the
serialization, but I'm nto sure that would be much better.  Let me know if
you're ok with the above wait loop, and if so, I'll make the other corrections
you've noted and repost

Regards
Neil

