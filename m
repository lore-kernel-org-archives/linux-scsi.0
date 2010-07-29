From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 15:56:33 -0400
Message-ID: <4C51DCF1.3010507@redhat.com>
References: <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab0G2T5H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 15:57:07 -0400
In-Reply-To: <20100729194904.GA17098@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ric Wheeler <rwheeler@redhat.com>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On 07/29/2010 03:49 PM, Christoph Hellwig wrote:
> On Thu, Jul 29, 2010 at 03:44:31PM -0400, Ric Wheeler wrote:
>    
>> I confess that I am a bit fuzzy on FUA, but think that it means that any
>> FUA tagged IO will go down to persistent store before returning.
>>      
> Exactly.
>
>    
>> If so, then all order dependent IO would need to be issued in order and
>> tagged with FUA. It would not suffice to tag just the commit record as
>> FUA, or do I misunderstand what FUA does?
>>      
> The commit record is ext3/4 specific terminalogy.  In xfs we just have
> one type of log buffers, and we could tag that as FUA.  There is very
> little other depenent I/O, but if that is present we need a pre-flush
> for it anyway.
>
>    

I assume that for ext3 it would get more complicated depending on the 
journal mode. In ordered or data journal mode, we would have to write 
the dependent non-journal data tagged with FUA, then the FUA tagged 
transaction and finally the FUA tagged commit block.

Not sure how FUA performs, but writing lots of small tagged writes is 
probably not good for performance...

Ric

