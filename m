From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 20:17:49 +0400
Message-ID: <4C50582D.7050304@vlnb.net>
References: <20100727165627.GA474@lst.de>	 <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com>	 <4C4FE58C.8080403@kernel.org> <4C4FE860.7000903@suse.de>	 <4C5036BC.30709@vlnb.net>  <4C503D50.4010006@suse.de> <1280327839.30808.188.camel@mulgrave.site> <4C504237.4070105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C504237.4070105@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <teheo@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

Tejun Heo, on 07/28/2010 06:44 PM wrote:
> Hello,
>
> On 07/28/2010 04:37 PM, James Bottomley wrote:
>>> I don't remember all the details now but IIRC what was necessary was
>>> earlier write failure failing all commands scheduled as ordered.  Does
>>> ACA / UA_INTLCK or whatever allow that?
>>
>> No.  That requires support for QErr ... which is in the same mode page.
>
> I see.
>
>> The real reason we have difficulty is that BUSY/QUEUE_FULL can cause
>> reordering in the issue queue, which is a driver problem and not in the
>> SCSI standards.
>
> Ah yeah right.  ISTR discussions about this years ago.  But one way or
> the other, given the limited amount of ordering information available
> under the block layer, I doubt the benefit of doing would be anything
> significant.  If it can be done w/o too much complexity, sure, but
> otherwise...

Hmm, this thread was started from the need to avoid queue draining, 
because it is a big performance hit. The use of ordered commands allows 
to _completely_ eliminate queue draining _at all_. It looks to be a 
significant benefit worth some additional complexity.

Vlad
