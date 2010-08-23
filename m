From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Mon, 23 Aug 2010 14:14:02 +0200
Message-ID: <4C72660A.7070009@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100813114858.GA31937@lst.de> <4C654D4B.1030507@kernel.org> <20100813143820.GA7931@lst.de> <4C655BE5.4070809@kernel.org> <20100814103654.GA13292@lst.de> <4C6A5D8A.4010205@kernel.org> <20100817131915.GB2963@lst.de> <4C6ABBCB.9030306@kernel.org> <20100817165929.GB13800@lst.de> <4C6E3C1A.50205@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C6E3C1A.50205@ct.jp.nec.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

Hello,

On 08/20/2010 10:26 AM, Kiyoshi Ueda wrote:
> I think that's correct and changing the priority of DM_ENDIO_REQUEUE
> for REQ_FLUSH down to the lowest should be fine.
> (I didn't know that FLUSH failure implies data loss possibility.)

At least on ATA, FLUSH failure implies that data is already lost, so
the error can't be ignored or retried.

> But the patch is not enough, you have to change target drivers, too.
> E.g. As for multipath, you need to change
>      drivers/md/dm-mpath.c:do_end_io() to return error for REQ_FLUSH
>      like the REQ_DISCARD support included in 2.6.36-rc1.

I'll take a look but is there an easy to test mpath other than having
fancy hardware?

> By the way, if these patch-set with the change above are included,
> even one path failure for REQ_FLUSH on multipath configuration will
> be reported to upper layer as error, although it's retried using
> other paths currently.
> Then, if an upper layer won't take correct recovery action for the error,
> it would be seen as a regression for users. (e.g. Frequent EXT3-error
> resulting in read-only mount on multipath configuration.)
> 
> Although I think the explicit error is fine rather than implicit data
> corruption, please check upper layers carefully so that users won't see
> such errors as much as possible.

Argh... then it will have to discern why FLUSH failed.  It can retry
for transport errors but if it got aborted by the device it should
report upwards.  Maybe just turn off barrier support in mpath for now?

Thanks.

-- 
tejun
