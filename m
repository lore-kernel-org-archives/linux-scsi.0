From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 23/41] dm: implement REQ_FLUSH/FUA support for bio-based
 dm
Date: Fri, 3 Sep 2010 08:36:18 -0400
Message-ID: <20100903123617.GA23812@redhat.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
 <1283509796-1510-24-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1283509796-1510-24-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, k-ueda@ct.jp.nec.com, mpatocka@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 03 2010 at  6:29am -0400,
Tejun Heo <tj@kernel.org> wrote:

> This patch converts bio-based dm to support REQ_FLUSH/FUA instead of
> now deprecated REQ_HARDBARRIER.
> 
> * -EOPNOTSUPP handling logic dropped.
> 
> * Preflush is handled as before but postflush is dropped and replaced
>   with passing down REQ_FUA to member request_queues.  This replaces
>   one array wide cache flush w/ member specific FUA writes.
> 
> * __split_and_process_bio() now calls __clone_and_map_flush() directly
>   for flushes and guarantees all FLUSH bio's going to targets are zero
> `  length.
> 
> * It's now guaranteed that all FLUSH bio's which are passed onto dm
>   targets are zero length.  bio_empty_barrier() tests are replaced
>   with REQ_FLUSH tests.
> 
> * Empty WRITE_BARRIERs are replaced with WRITE_FLUSHes.
> 
> * Dropped unlikely() around REQ_FLUSH tests.  Flushes are not unlikely
>   enough to be marked with unlikely().
> 
> * Block layer now filters out REQ_FLUSH/FUA bio's if the request_queue
>   doesn't support cache flushing.  Advertise REQ_FLUSH | REQ_FUA
>   capability.
> 
> * Request based dm isn't converted yet.  dm_init_request_based_queue()
>   resets flush support to 0 for now.  To avoid disturbing request
>   based dm code, dm->flush_error is added for bio based dm while
>   requested based dm continues to use dm->barrier_error.
> 
> Lightly tested linear, stripe, raid1, snap and crypt targets.  Please
> proceed with caution as I'm not familiar with the code base.

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Mikulas and/or Alasdair won't be able to review this until next week.
