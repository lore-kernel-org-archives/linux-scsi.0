From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 06/32] target: Convert lu_gp_ref_cnt to kref
Date: Fri, 07 Feb 2014 11:17:28 -0800
Message-ID: <1391800648.1155.14.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-7-git-send-email-agrover@redhat.com>
	 <1387227157.20247.203.camel@haakon3.risingtidesystems.com>
	 <52F2B512.9040102@redhat.com>
	 <1391730689.14985.51.camel@haakon3.risingtidesystems.com>
	 <52F44B6C.1080405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52F44B6C.1080405@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-02-06 at 18:56 -0800, Andy Grover wrote:
> On 02/06/2014 03:51 PM, Nicholas A. Bellinger wrote:
> > The problem with this patch and all of the other patches that follow the
> > same logic is the false assumption that it's safe to return from
> > configfs_group_operations->drop_item() before all references to the
> > underlying data structure containing the associated struct config_group
> > have been dropped.
> > 
> > In this particular case, target_core_alua_drop_lu_gp() ->
> > config_item_put() -> target_core_alua_lu_gp_release() ->
> > core_alua_free_lu_gp() is still being called from ->drop_item() via
> > target_core_alua_lu_gp_ops->release(), so the same holds true here as
> > well.
> 
> Yes exactly. That's why the configfs release() doesn't free the lu_gp,
> it just lowers the lu_gp refcount. release() being called doesn't mean
> the object is going away, it just means configfs is done with it.
> 
> If do_port_transition has incremented it in the meantime, the lu_gp
> won't be freed from the release() (because the underlying object's
> refcount will still be nonzero) but only when do_port_transition is
> done. In the normal case where there isn't a ref from
> do_port_transition, then it is safe to free the lu_gp from release ->
> put_alua_lu_gp -> release_alua_lu_gp -> kmem_cache_free.

It's still completely wrong to return from ->drop_item() before all
references to the associated struct config_group have dropped because
nothing prevents a parent struct config_group (and it's parent above
that) from also being removed.

The whole point is that this type of parent/child reference counting
comes for free with configfs, and patches that introduce changes that
don't actually wait for individual references to drop, but instead
lazily allow references to drop in the background at their leisure break
this model.

--nab
