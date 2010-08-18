From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Wed, 18 Aug 2010 08:35:54 +0200
Message-ID: <4C6B7F4A.2040807@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100813114858.GA31937@lst.de> <4C654D4B.1030507@kernel.org> <20100813143820.GA7931@lst.de> <4C655BE5.4070809@kernel.org> <20100814103654.GA13292@lst.de> <4C6A5D8A.4010205@kernel.org> <20100817131915.GB2963@lst.de> <4C6ABBCB.9030306@kernel.org> <20100817165929.GB13800@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100817165929.GB13800@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

Hello,

On 08/17/2010 06:59 PM, Christoph Hellwig wrote:
> I think we really need all the conversions in one tree, block layer,
> remapping drivers and filesystems.

I don't know.  If filesystem changes are really trivial maybe, but
md/dm changes seem a bit too invasive to go through the block tree.

> Btw, I've done the conversion for all filesystems and I'm running tests
> over them now.  Expect the series late today or tomorrow.

Cool. :-)

>> I might just resequence it to finish this part of discussion but what
>> does that really buy us?  It's not really gonna help bisection.
>> Bisection won't be able to tell anything in higher resolution than
>> "the new implementation doesn't work".  If you show me how it would
>> actually help, I'll happily reshuffle the patches.
> 
> It's not bisecting to find bugs in the barrier conversion.  We can't
> easily bisect it down anyway.  The problem is when we try to bisect
> other problems and get into the middle of the series barriers suddenly
> are gone.  Which is not very helpful for things like data integrity
> problems in filesystems.

Ah, okay, hmmm.... alright, I'll resequence the patches.  If the
filesystem changes can be put into a single tree somehow, we can keep
things mostly working at least for direct devices.

>> IIUC, when any of flushes get DM_ENDIO_REQUEUE (which tells the dm
>> core layer to retry the whole bio later), it trumps all other failures
>> and the bio is retried later.  That was why DM_ENDIO_REQUEUE was
>> prioritized over other error codes, which actually is sort of
>> incorrect in that once a FLUSH fails, it _MUST_ be reported to upper
>> layers as FLUSH failure implies data already lost.  So,
>> DM_ENDIO_REQUEUE actually should have lower priority than other
>> failures.  But, then again, the error codes still need to be
>> prioritized.
> 
> I think that's something we better leave to the DM team.

Sure, but we shouldn't be ripping out the code to do that.

Thanks.

-- 
tejun
