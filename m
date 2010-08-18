From: Tejun Heo <teheo@suse.de>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Wed, 18 Aug 2010 10:11:22 +0200
Message-ID: <4C6B95AA.7040502@suse.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100813114858.GA31937@lst.de> <4C654D4B.1030507@kernel.org> <20100813143820.GA7931@lst.de> <4C655BE5.4070809@kernel.org> <20100814103654.GA13292@lst.de> <4C6A5D8A.4010205@kernel.org> <20100817131915.GB2963@lst.de> <4C6ABBCB.9030306@kernel.org> <20100817165929.GB13800@lst.de> <4C6B7F4A.2040807@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C6B7F4A.2040807@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

Hello,

On 08/18/2010 08:35 AM, Tejun Heo wrote:
>> It's not bisecting to find bugs in the barrier conversion.  We can't
>> easily bisect it down anyway.  The problem is when we try to bisect
>> other problems and get into the middle of the series barriers suddenly
>> are gone.  Which is not very helpful for things like data integrity
>> problems in filesystems.
> 
> Ah, okay, hmmm.... alright, I'll resequence the patches.  If the
> filesystem changes can be put into a single tree somehow, we can keep
> things mostly working at least for direct devices.

Sorry but I'm doing it.  It just doesn't make much sense.  I can't
relax the ordering for REQ_HARDBARRIER without breaking the remapping
drivers.  So, to keep things working, I'll have to 1. relax the
ordering 2. implement new REQ_FLUSH/FUA based interface and 3. use
them in the filesystems in the same patch.  That's just wrong.  And I
don't think md/dm changes can or should go through the block tree.
They're way too invasive for that.  It's a new implementation and
barrier won't work (fail gracefully) for several commits during the
transition.  I don't think there's a better way around it.

Thanks.

-- 
tejun
