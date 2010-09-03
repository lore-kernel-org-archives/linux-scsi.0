From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCHSET #upstream] block,
 fs: replace HARDBARRIER with FLUSH/FUA, take#2
Date: Fri, 03 Sep 2010 20:53:34 +0200
Message-ID: <4C81442E.5040301@fusionio.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: "jack@suse.cz" <jack@suse.cz>, "snitzer@redhat.com" <snitzer@redhat.com>, "mst@redhat.com" <mst@redhat.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>, "hch@lst.de" <hch@lst.de>, "k-ueda@ct.jp.nec.com" <k-ueda@ct.jp.nec.com>, "vst@vlnb.net" <vst@vlnb.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "mpatocka@redhat.com" <mpatocka@redhat.com>, "swhiteho@redhat.com" <swhiteho@redhat.com>, "chris.mason@oracle.com" <chris.mason@oracle.com>, "tytso@mit.edu" <tytso@mit.edu>
List-Id: linux-scsi@vger.kernel.org

On 09/03/2010 12:29 PM, Tejun Heo wrote:
> Hello,
> 
> This patchset is combination of the following two patchsets.
> 
>  [1] block, fs: replace HARDBARRIER with FLUSH/FUA
>  [2] block, dm: finish REQ_FLUSH/FUA conversion, take#2
> 
> Changes from the previous postings are
> 
> * Rebased on top of v2.6.36-rc3.
> 
> * 0010-block-implement-REQ_FLUSH-FUA-based-interface-for-FL.patch
>   description updated to include why special -EOPNOTSUPP handling is
>   no longer necessary as suggested by Mike Snitzer.
> 
> * 0025-dm-relax-ordering-of-bio-based-flush-implementation.patch
>   description updated to include why flush_error and special error
>   handling logic are no longer necessary as suggested by Mike
>   Snitzer.
> 
> * 0013-block-initialize-flush-request-with-WRITE_FLUSH-inst.patch and
>   0014-block-kick-queue-after-sequencing-REQ_FLUSH-FUA.patch added.
>   These fixes aren't strictly required by the current users but remove
>   fishy corner cases.
> 
> * 0015-block-make-sure-FSEQ_DATA-request-has-the-same-rq_di.patch
>   added.  This is needed to make requested based dm work.
> 
> * 0026-dm-fix-locking-context-in-queue_io.patch added.  This fixes
>   locking context problem introduced by
>   0025-dm-relax-ordering-of-bio-based-flush-implementation.patch.
> 
> * Tested/Reviewed-by's added and patches reordered such that block
>   layer conversion comes first followed by block driver conversions,
>   filesystem conversions and then finally removal of deprecate stuff.
> 
> I think the patchset is mostly ready now although I would love to have
> acked/reviewd-by's on bio-based dm conversion patches.  Jens,
> Christoph, how do you guys wanna steer these patches?  I think it
> would be best to go through the block tree but splitting parts and
> doing cross tree pull/merges should be doable too.

Since the core changes are block churn, it would probably be
sanest to pull everything in there. Core into for-2.6.37/core,
then have for-2.6.37/fs and 2.6.37/drivers on top of that.

-- 
Jens Axboe
