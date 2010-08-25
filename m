From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Wed, 25 Aug 2010 11:28:32 -0400
Message-ID: <20100825152831.GA8509@redhat.com>
References: <4C6A5D8A.4010205@kernel.org>
 <20100817131915.GB2963@lst.de>
 <4C6ABBCB.9030306@kernel.org>
 <20100817165929.GB13800@lst.de>
 <4C6E3C1A.50205@ct.jp.nec.com>
 <4C72660A.7070009@kernel.org>
 <20100823141733.GA21158@redhat.com>
 <4C739DE9.5070803@ct.jp.nec.com>
 <4C73FA8F.5080800@kernel.org>
 <4C74CD95.1000208@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C74CD95.1000208@ct.jp.nec.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.de>, tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, vst@vlnb.net, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 25 2010 at  4:00am -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> Hi Tejun,
> 
> On 08/25/2010 01:59 AM +0900, Tejun Heo wrote:
> > On 08/24/2010 12:24 PM, Kiyoshi Ueda wrote:
> >> Anyway, only reporting errors for REQ_FLUSH to upper layer without
> >> such a solution would make dm-multipath almost unusable in real world,
> >> although it's better than implicit data loss.
> > 
> > I see.
> > 
> >>> Maybe just turn off barrier support in mpath for now?
> >> 
> >> If it's possible, it could be a workaround for a short term.
> >> But how can you do that?
> >>
> >> I think it's not enough to just drop REQ_FLUSH flag from q->flush_flags.
> >> Underlying devices of a mpath device may have write-back cache and
> >> it may be enabled.
> >> So if a mpath device doesn't set REQ_FLUSH flag in q->flush_flags, it
> >> becomes a device which has write-back cache but doesn't support flush.
> >> Then, upper layer can do nothing to ensure cache flush?
> > 
> > Yeah, I was basically suggesting to forget about cache flush w/ mpath
> > until it can be fixed.  You're saying that if mpath just passes
> > REQ_FLUSH upwards without retrying, it will be almost unuseable,
> > right?
> 
> Right.
> If the error is safe/needed to retry using other paths, mpath should
> retry even if REQ_FLUSH.  Otherwise, only one path failure may result
> in system down.
> Just passing any REQ_FLUSH error upwards regardless the error type
> will make such situations, and users will feel the behavior as
> unstable/unusable.

Right, there are hardware configurations that lend themselves to FLUSH
retries mattering, namely:
1) a SAS drive with 2 ports and a writeback cache
2) theoretically possible: SCSI array that is mpath capable but
   advertises cache as writeback (WCE=1)

The SAS case is obviously a more concrete example of why FLUSH retries
are worthwhile in mpath.

But I understand (and agree) that we'd be better off if mpath could
differentiate between failures rather than blindly retrying on failures
like it does today (fails path and retries if additional paths
available).

> Anyway, as you said, the flush error handling of dm-mpath is already
> broken if data loss really happens on any storage used by dm-mpath.
> Although it's a serious issue and quick fix is required, I think
> you may leave the old behavior in your patch-set, since it's
> a separate issue.

I'm not seeing where anything is broken with current mpath.  If a
multipathed LUN is WCE=1 then it should be fair to assume the cache is
mirrored or shared across ports.  Therefore retrying the SYNCHRONIZE
CACHE is needed.

Do we still have fear that SYNCHRONIZE CACHE can silently drop data?
Seems unlikely especially given what Tejun shared from SBC.

It seems that at worst, with current mpath, we retry when it doesn't
make sense (e.g. target failure).

Mike
