From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Fri, 27 Aug 2010 09:49:40 -0400
Message-ID: <20100827134940.GA22504@redhat.com>
References: <4C6ABBCB.9030306@kernel.org>
 <20100817165929.GB13800@lst.de>
 <4C6E3C1A.50205@ct.jp.nec.com>
 <4C72660A.7070009@kernel.org>
 <20100823141733.GA21158@redhat.com>
 <4C739DE9.5070803@ct.jp.nec.com>
 <4C73FA8F.5080800@kernel.org>
 <4C74CD95.1000208@ct.jp.nec.com>
 <20100825152831.GA8509@redhat.com>
 <4C7789BE.1060609@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C7789BE.1060609@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.de>, tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, vst@vlnb.net, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 27 2010 at  5:47am -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> Hi Mike,
> 
> On 08/26/2010 12:28 AM +0900, Mike Snitzer wrote:
> > Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> >> Anyway, as you said, the flush error handling of dm-mpath is already
> >> broken if data loss really happens on any storage used by dm-mpath.
> >> Although it's a serious issue and quick fix is required, I think
> >> you may leave the old behavior in your patch-set, since it's
> >> a separate issue.
> > 
> > I'm not seeing where anything is broken with current mpath.  If a
> > multipathed LUN is WCE=1 then it should be fair to assume the cache is
> > mirrored or shared across ports.  Therefore retrying the SYNCHRONIZE
> > CACHE is needed.
> > 
> > Do we still have fear that SYNCHRONIZE CACHE can silently drop data?
> > Seems unlikely especially given what Tejun shared from SBC.
> 
> Do we have any proof to wipe that fear?
> 
> If retrying on flush failure is safe on all storages used with multipath
> (e.g. SCSI, CCISS, DASD, etc), then current dm-mpath should be fine in
> the real world.
> But I'm afraid if there is a storage where something like below can happen:
>     - a flush command is returned as error to mpath because a part of
>       cache has physically broken at the time or so, then that part of
>       data loses and the size of the cache is shrunk by the storage.
>     - mpath retries the flush command using other path.
>     - the flush command is returned as success to mpath.
>     - mpath passes the result, success, to upper layer, but some of
>       the data already lost.

That does seem like a valid concern.  But I'm not seeing why its unique
to SYNCHRONIZE CACHE.  Any IO that fails on the target side should be
passed up once the error gets to DM.

Mike
