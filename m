From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 30 Jul 2010 17:25:52 +0400
Message-ID: <4C52D2E0.5000609@vlnb.net>
References: <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca> <20100729230406.GI4506@thunk.org> <4C52CBFF.6090406@vlnb.net> <20100730130957.GA26894@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100730130957.GA26894@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig, on 07/30/2010 05:09 PM wrote:
> On Fri, Jul 30, 2010 at 04:56:31PM +0400, Vladislav Bolkhovitin wrote:
>> For a simpler device (a disk without support for ORDERED queuing) the
>> same meta-data updates would be:
>>
>> 1. 1st journal write command
>>
>> 2. 2d  journal write command
>>
>> 3. 3d  journal write command
>>
>> 4. The queue draining.
>
> Which is complete overkill.  We have state machines for everything we do
> block I/O on (both data and the journal), which allows us to just wait
> on the I/O requests we need inside the filesystem instead of draining
> the queue, or enforce global ordering using ordered tags.

Sure. It was only a naive example to illustrate my points. But the FS is 
still waiting for the requests, so "draining" its "local queue"?

Vlad
