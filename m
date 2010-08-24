From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Tue, 24 Aug 2010 19:24:41 +0900
Message-ID: <4C739DE9.5070803@ct.jp.nec.com>
References: <4C654D4B.1030507@kernel.org> <20100813143820.GA7931@lst.de> <4C655BE5.4070809@kernel.org> <20100814103654.GA13292@lst.de> <4C6A5D8A.4010205@kernel.org> <20100817131915.GB2963@lst.de> <4C6ABBCB.9030306@kernel.org> <20100817165929.GB13800@lst.de> <4C6E3C1A.50205@ct.jp.nec.com> <4C72660A.7070009@kernel.org> <20100823141733.GA21158@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:53701 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab0HXKZs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2010 06:25:48 -0400
In-Reply-To: <20100823141733.GA21158@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, vst@vlnb.net, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com, dm-devel@redhat.com

Hi Tejun,

On 08/23/2010 11:17 PM +0900, Mike Snitzer wrote:
> On Mon, Aug 23 2010 at  8:14am -0400, Tejun Heo <tj@kernel.org> wrote:
>> On 08/20/2010 10:26 AM, Kiyoshi Ueda wrote:
>>> By the way, if these patch-set with the change above are included,
>>> even one path failure for REQ_FLUSH on multipath configuration will
>>> be reported to upper layer as error, although it's retried using
>>> other paths currently.
>>> Then, if an upper layer won't take correct recovery action for the error,
>>> it would be seen as a regression for users. (e.g. Frequent EXT3-error
>>> resulting in read-only mount on multipath configuration.)
>>>
>>> Although I think the explicit error is fine rather than implicit data
>>> corruption, please check upper layers carefully so that users won't see
>>> such errors as much as possible.
>> 
>> Argh... then it will have to discern why FLUSH failed.  It can retry
>> for transport errors but if it got aborted by the device it should
>> report upwards.
> 
> Yes, we discussed this issue of needing to train dm-multipath to know if
> there was a transport failure or not (at LSF).  But I'm not sure when
> Hannes intends to repost his work in this area (updated to account for
> feedback from LSF).

Yes, checking whether it's a transport error in lower layer is
the right solution.
(Since I know it's not available yet, I just hoped if upper layers
 had some other options.)

Anyway, only reporting errors for REQ_FLUSH to upper layer without
such a solution would make dm-multipath almost unusable in real world,
although it's better than implicit data loss.


>> Maybe just turn off barrier support in mpath for now?

If it's possible, it could be a workaround for a short term.
But how can you do that?

I think it's not enough to just drop REQ_FLUSH flag from q->flush_flags.
Underlying devices of a mpath device may have write-back cache and
it may be enabled.
So if a mpath device doesn't set REQ_FLUSH flag in q->flush_flags, it
becomes a device which has write-back cache but doesn't support flush.
Then, upper layer can do nothing to ensure cache flush?

Thanks,
Kiyoshi Ueda
