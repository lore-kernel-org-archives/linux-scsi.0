From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] dm: implement REQ_FLUSH/FUA support
Date: Tue, 17 Aug 2010 15:13:09 +0200
Message-ID: <20100817131309.GA2963@lst.de>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-6-git-send-email-tj@kernel.org> <20100816190203.GA22299@redhat.com> <4C6A5780.2090100@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C6A5780.2090100@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, Tejun Heo <tj@kernle.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 17, 2010 at 11:33:52AM +0200, Tejun Heo wrote:
> > That logic wasn't just about retries (at least not in the latest
> > kernel).  With commit 708e929513502fb0 the -EOPNOTSUPP checking also
> > serves to optimize the barrier+discard case (when discards aren't
> > supported).
> 
> With the patch applied, there's no second flush.  Those requests would
> now be REQ_FLUSH + REQ_DISCARD.  The first can't be avoided anyway and
> there won't be the second flush to begin with, so I don't think this
> worsens anything.

In fact the pre-flush is completely superflous for discards, but that's a
separate discussion and should not be changed as part of this patchset but
rather explicitly.

