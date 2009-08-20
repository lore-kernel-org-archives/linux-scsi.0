From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Thu, 20 Aug 2009 09:48:50 -0400
Message-ID: <4A8D5442.1000302@redhat.com>
References: <20090816004705.GA7347@infradead.org> <20090819203916.GA25296@elte.hu> <4A8CA956.2060406@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4A8CA956.2060406@rtr.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, IDE/ATA development list <linux-ide@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 08/19/2009 09:39 PM, Mark Lord wrote:
> [resending, after fixing the Cc: list; somebody trimmed it earlier]
>
> Jamie Lokier wrote:
> ..
>> I don't remember - does TRIM guarantee the blocks read zeros afterwards?
> ..
>
> No, it doesn't.
>
> A drive can optionally support "deterministic TRIM", whereby it will 
> return
> consistent data for any given trimmed sector afterwards, but that 
> doesn't mean zeros.
>
> -ml

Note that returning consistent data is critical for devices that are 
used in a RAID group since you will need each RAID block that is used to 
compute the parity to continue to return the same data until you 
overwrite it with new data :-)

If we have a device that does not support this (or is misconfigured not 
to do this), we should not use those devices in an MD group & do discard 
against it...

ric

