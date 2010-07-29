From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 15:44:31 -0400
Message-ID: <4C51DA1F.2040701@redhat.com>
References: <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757405Ab0G2TpQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 15:45:16 -0400
In-Reply-To: <20100729014431.GD4506@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@s

On 07/28/2010 09:44 PM, Ted Ts'o wrote:
> On Wed, Jul 28, 2010 at 11:28:59AM +0200, Christoph Hellwig wrote:
>    
>> If we move all filesystems to non-draining barriers with pre- and post-
>> flushes that might actually be a relatively easy first step.  We don't
>> have the complications to deal with multiple types of barriers to
>> start with, and it'll fix the issue for devices without volatile write
>> caches completely.
>>
>> I just need some help from the filesystem folks to determine if they
>> are safe with them.
>>
>> I know for sure that ext3 and xfs are from looking through them.  And
>> I know reiserfs is if we make sure it doesn't hit the code path that
>> relies on it that is currently enabled by the barrier option.
>>
>> I'll just need more feedback from ext4, gfs2, btrfs and nilfs folks.
>> That already ends our small list of barrier supporting filesystems, and
>> possibly ocfs2, too - although the barrier implementation there seems
>> incomplete as it doesn't seem to flush caches in fsync.
>>      
> Define "are safe" --- what interface we planning on using for the
> non-draining barrier?  At least for ext3, when we write the commit
> record using set_buffer_ordered(bh), it assumes that this will do a
> flush of all previous writes and that the commit will hit the disk
> before any subsequent writes are sent to the disk.  So turning the
> write of a buffer head marked with set_buffered_ordered() into a FUA
> write would _not_ be safe for ext3.
>    

I confess that I am a bit fuzzy on FUA, but think that it means that any 
FUA tagged IO will go down to persistent store before returning.

If so, then all order dependent IO would need to be issued in order and 
tagged with FUA. It would not suffice to tag just the commit record as 
FUA, or do I misunderstand what FUA does?

(Looking for a record in the how many times can I use FUA in an email).

ric

> For ext4, if we don't use journal checksums, then we have the same
> requirements as ext3, and the same method of requesting it.  If we do
> use journal checksums, what ext4 needs is a way of assuring that no
> writes after the commit are reordered with respect to the disk platter
> before the commit record --- but any of the writes before that,
> including the commit, and be reordered because we rely on the checksum
> in the commit record to know at replay time whether the last commit is
> valid or not.  We do that right now by calling blkdev_issue_flush()
> with BLKDEF_IFL_WAIT after submitting the write of the commit block.
>
> 					- Ted
>
>    

