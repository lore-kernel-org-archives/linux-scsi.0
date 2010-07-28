From: Tejun Heo <teheo@suse.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 16:23:12 +0200
Message-ID: <4C503D50.4010006@suse.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <4C4FE860.7000903@suse.de> <4C5036BC.30709@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C5036BC.30709@vlnb.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

Hello,

On 07/28/2010 03:55 PM, Vladislav Bolkhovitin wrote:
>> The only benefit of doing it in the block layer, and probably the
>> reason why it was done this way at all, is making use of advanced
>> ordering features of some devices - ordered tag and linked commands.
>> The latter is deprecated and the former is fundamentally broken in
>> error handling anyway.
> 
> Why? SCSI provides ACA and UA_INTLCK which provide all needed
> facilities for errors handling in deep ordered queues.

I don't remember all the details now but IIRC what was necessary was
earlier write failure failing all commands scheduled as ordered.  Does
ACA / UA_INTLCK or whatever allow that?

>> Furthermore, although they do relax ordering
>> requirements from the device queue side, the level of flexibility is
>> significantly lower compared to what filesystems can do themselves.
> 
> Can you elaborate more what is not sufficiently flexible in SCSI
> ordered commands, please?

File systems are not communicating enough ordering info to block layer
already so we already lose a lot of ordering information there and
SCSI ordered queueing is also pretty restricted in what kind of
ordering it can represent.  The end result is that we don't gain much
by using ordered queueing.  It may cut down command latencies among
commands used for barrier sequence but if you compare it to the level
of parallelism filesystem code can exploit by ordering requests
themselves...  Another thing is coverage.  We have ordered queueing
for quite some time now but there are only a couple of drivers which
actually support them.

Thanks.

-- 
tejun
