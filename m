From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Mon, 23 Aug 2010 10:17:33 -0400
Message-ID: <20100823141733.GA21158@redhat.com>
References: <4C654D4B.1030507@kernel.org>
 <20100813143820.GA7931@lst.de>
 <4C655BE5.4070809@kernel.org>
 <20100814103654.GA13292@lst.de>
 <4C6A5D8A.4010205@kernel.org>
 <20100817131915.GB2963@lst.de>
 <4C6ABBCB.9030306@kernel.org>
 <20100817165929.GB13800@lst.de>
 <4C6E3C1A.50205@ct.jp.nec.com>
 <4C72660A.7070009@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C72660A.7070009@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.de>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, vst@vlnb.net, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 23 2010 at  8:14am -0400,
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 08/20/2010 10:26 AM, Kiyoshi Ueda wrote:
> > I think that's correct and changing the priority of DM_ENDIO_REQUEUE
> > for REQ_FLUSH down to the lowest should be fine.
> > (I didn't know that FLUSH failure implies data loss possibility.)
> 
> At least on ATA, FLUSH failure implies that data is already lost, so
> the error can't be ignored or retried.
> 
> > But the patch is not enough, you have to change target drivers, too.
> > E.g. As for multipath, you need to change
> >      drivers/md/dm-mpath.c:do_end_io() to return error for REQ_FLUSH
> >      like the REQ_DISCARD support included in 2.6.36-rc1.
> 
> I'll take a look but is there an easy to test mpath other than having
> fancy hardware?

It is easy enough to make a single path use mpath.  Just verify/modify
/etc/multipath.conf so that your device isn't blacklisted.

multipathd will even work with a scsi-debug device.

You obviously won't get path failover but you'll see the path get marked
faulty, etc.

> > By the way, if these patch-set with the change above are included,
> > even one path failure for REQ_FLUSH on multipath configuration will
> > be reported to upper layer as error, although it's retried using
> > other paths currently.
> > Then, if an upper layer won't take correct recovery action for the error,
> > it would be seen as a regression for users. (e.g. Frequent EXT3-error
> > resulting in read-only mount on multipath configuration.)
> > 
> > Although I think the explicit error is fine rather than implicit data
> > corruption, please check upper layers carefully so that users won't see
> > such errors as much as possible.
> 
> Argh... then it will have to discern why FLUSH failed.  It can retry
> for transport errors but if it got aborted by the device it should
> report upwards.

Yes, we discussed this issue of needing to train dm-multipath to know if
there was a transport failure or not (at LSF).  But I'm not sure when
Hannes intends to repost his work in this area (updated to account for
feedback from LSF).

> Maybe just turn off barrier support in mpath for now?

I think we'd prefer to have a device fail rather than jeopardize data
integrity.  Clearly not ideal but...
