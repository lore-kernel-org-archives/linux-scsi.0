From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/4] bdi: Fix use-after-free in wb_congested_put()
Date: Wed, 8 Mar 2017 17:56:51 -0500
Message-ID: <20170308225651.GC21117@htj.duckdns.org>
References: <20170308164834.14302-1-jack@suse.cz>
 <20170308164834.14302-3-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170308164834.14302-3-jack@suse.cz>
Sender: linux-block-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Omar Sandoval <osandov@osandov.com>, Arthur Marsh <arthur.marsh@internode.on.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 08, 2017 at 05:48:32PM +0100, Jan Kara wrote:
> bdi_writeback_congested structures get created for each blkcg and bdi
> regardless whether bdi is registered or not. When they are created in
> unregistered bdi and the request queue (and thus bdi) is then destroyed
> while blkg still holds reference to bdi_writeback_congested structure,
> this structure will be referencing freed bdi and last wb_congested_put()
> will try to remove the structure from already freed bdi.
> 
> With commit 165a5e22fafb "block: Move bdi_unregister() to
> del_gendisk()", SCSI started to destroy bdis without calling
> bdi_unregister() first (previously it was calling bdi_unregister() even
> for unregistered bdis) and thus the code detaching
> bdi_writeback_congested in cgwb_bdi_destroy() was not triggered and we
> started hitting this use-after-free bug. It is enough to boot a KVM
> instance with virtio-scsi device to trigger this behavior.
> 
> Fix the problem by detaching bdi_writeback_congested structures in
> bdi_exit() instead of bdi_unregister(). This is also more logical as
> they can get attached to bdi regardless whether it ever got registered
> or not.
> 
> Fixes: 165a5e22fafb127ecb5914e12e8c32a1f0d3f820
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
