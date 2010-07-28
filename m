From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 20:16:15 +0400
Message-ID: <4C5057CF.1080701@vlnb.net>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <4C4FE860.7000903@suse.de> <4C5036BC.30709@vlnb.net> <4C503D50.4010006@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C503D50.4010006@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <teheo@suse.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

Tejun Heo, on 07/28/2010 06:23 PM wrote:
> Hello,
>
> On 07/28/2010 03:55 PM, Vladislav Bolkhovitin wrote:
>>> The only benefit of doing it in the block layer, and probably the
>>> reason why it was done this way at all, is making use of advanced
>>> ordering features of some devices - ordered tag and linked commands.
>>> The latter is deprecated and the former is fundamentally broken in
>>> error handling anyway.
>>
>> Why? SCSI provides ACA and UA_INTLCK which provide all needed
>> facilities for errors handling in deep ordered queues.
>
> I don't remember all the details now but IIRC what was necessary was
> earlier write failure failing all commands scheduled as ordered.  Does
> ACA / UA_INTLCK or whatever allow that?

Basically, ACA suspends the whole queue in case if a command in the head 
finished with CHECK CONDITION status. The queue should be resumed later 
by CLEAR ACA Task Management function. During ACA one or more new 
commands can be sent in the head of the queue. It allows, eg, restart 
the failed command.

UA_INTLCK allows to establish a Unit Attention if a command in the head 
finished with error other that CHECK CONDITION status. Then next command 
will finish with CHECK CONDITION and then ACA comes into action.

Overall, they look as a complete facility for effective errors recovery 
of ordered queues.

>>> Furthermore, although they do relax ordering
>>> requirements from the device queue side, the level of flexibility is
>>> significantly lower compared to what filesystems can do themselves.
>>
>> Can you elaborate more what is not sufficiently flexible in SCSI
>> ordered commands, please?
>
> File systems are not communicating enough ordering info to block layer
> already so we already lose a lot of ordering information there and
> SCSI ordered queueing is also pretty restricted in what kind of
> ordering it can represent.

What restrictions do you mean?

> The end result is that we don't gain much
> by using ordered queueing.  It may cut down command latencies among
> commands used for barrier sequence but if you compare it to the level
> of parallelism filesystem code can exploit by ordering requests
> themselves...  Another thing is coverage.  We have ordered queueing
> for quite some time now but there are only a couple of drivers which
> actually support them.

Agree, file systems should provide full ordering info to the block 
level. The block level then should do the best to provide the needed 
ordering requirements using available hardware facilities.

Thanks,
Vlad
