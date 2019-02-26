From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1] mpt3sas: Use driver scsi lookup to track outstanding
 IOs
Date: Tue, 26 Feb 2019 15:53:28 +0100
Message-ID: <6f94a905-45c9-4a77-bbb6-9669197e8d8f@suse.de>
References: <1550751105-46065-1-git-send-email-sreekanth.reddy@broadcom.com>
 <d0672a75-2900-5f6b-368f-5808914322a8@suse.de>
 <CAK=zhgpuB9Y+Z1e64D1Dm4fJtJ2rjZPf5g_TLNwnKbauRpqrJQ@mail.gmail.com>
 <61a8f703-3f20-b777-08b9-54ae34dffa59@suse.de>
 <CAK=zhgrWWtCf+N7EmbhK69PEc2L0hfc8ybOyFddUed8yufhvJQ@mail.gmail.com>
 <0dfb09ca-8723-3a3c-a6a8-c643856c57e3@suse.de>
 <20190226143313.GA23865@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190226143313.GA23865@infradead.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2/26/19 3:33 PM, Christoph Hellwig wrote:
> On Tue, Feb 26, 2019 at 02:49:30PM +0100, Hannes Reinecke wrote:
>> Attached is a patch to demonstrate my approach.
>> I am aware that it'll only be useful for latest upstream where the legacy
>> I/O path has been dropped completely, so we wouldn't need to worry about it.
>> For older releases indeed you would need to with something like your
>> proposed patch, but for upstream I really would like to switch to
>> blk_mq_tagset_busy() iter.
> 
> While this is better than the driver private tracking we really should
> not have to iterate all outstanding command, because if we have any
> there is a bug we need to fix in the higher layers instead of working
> around it in the drivers.
> 
Ah-ha.

But what else should we be doing here?
The driver needs to abort all outstanding commands; I somewhat fail to 
see how we could be doing it otherwise ...

Cheers,

Hannes
