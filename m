From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v2 5/5] lib: scatterlist: move SG pool code from SCSI
 driver to lib/sg_pool.c
Date: Mon, 4 Apr 2016 13:15:45 -0700
Message-ID: <CAF1ivSarDagJvHbOTG9yaOpjS9DufE9HLEr==UgE4en47LRuRA@mail.gmail.com>
References: <1458684196-15923-6-git-send-email-mlin@kernel.org>
	<201603231036.A8dUuAli%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201603231036.A8dUuAli%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: Ming Lin <mlin@kernel.org>, kbuild-all@01.org, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 22, 2016 at 7:38 PM, kbuild test robot <lkp@intel.com> wrote:
> Hi Ming,
>
> [auto build test WARNING on scsi/for-next]
> [also build test WARNING on v4.5 next-20160322]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
>
> url:    https://github.com/0day-ci/linux/commits/Ming-Lin/mempool-based-chained-scatterlist-alloc-free-api/20160323-060710
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
>
>
> coccinelle warnings: (new ones prefixed by >>)
>
>>> lib/sg_pool.c:152:3-18: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.
>    lib/sg_pool.c:154:3-21: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.

mempool_destroy()/kmem_cache_destroy() is OK to accept NULL pointer.
But the logic is more readable that we do NULL check when cleanup due to error.

cleanup_sdb:
        for (i = 0; i < SG_MEMPOOL_NR; i++) {
                struct sg_pool *sgp = sg_pools + i;
                if (sgp->pool)
                        mempool_destroy(sgp->pool);
                if (sgp->slab)
                        kmem_cache_destroy(sgp->slab);
        }

I'll keep the NULL check if no objection.

Thanks.
