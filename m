From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 06/32] target: Convert lu_gp_ref_cnt to kref
Date: Thu, 06 Feb 2014 18:56:44 -0800
Message-ID: <52F44B6C.1080405@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>  <1386979160-6928-7-git-send-email-agrover@redhat.com>  <1387227157.20247.203.camel@haakon3.risingtidesystems.com>  <52F2B512.9040102@redhat.com> <1391730689.14985.51.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaBGC4r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Feb 2014 21:56:47 -0500
In-Reply-To: <1391730689.14985.51.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 02/06/2014 03:51 PM, Nicholas A. Bellinger wrote:
> The problem with this patch and all of the other patches that follow the
> same logic is the false assumption that it's safe to return from
> configfs_group_operations->drop_item() before all references to the
> underlying data structure containing the associated struct config_group
> have been dropped.
> 
> In this particular case, target_core_alua_drop_lu_gp() ->
> config_item_put() -> target_core_alua_lu_gp_release() ->
> core_alua_free_lu_gp() is still being called from ->drop_item() via
> target_core_alua_lu_gp_ops->release(), so the same holds true here as
> well.

Yes exactly. That's why the configfs release() doesn't free the lu_gp,
it just lowers the lu_gp refcount. release() being called doesn't mean
the object is going away, it just means configfs is done with it.

If do_port_transition has incremented it in the meantime, the lu_gp
won't be freed from the release() (because the underlying object's
refcount will still be nonzero) but only when do_port_transition is
done. In the normal case where there isn't a ref from
do_port_transition, then it is safe to free the lu_gp from release ->
put_alua_lu_gp -> release_alua_lu_gp -> kmem_cache_free.

-- Andy

