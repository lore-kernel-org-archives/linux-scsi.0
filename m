From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Thu, 20 Aug 2009 10:38:19 -0400
Message-ID: <4A8D5FDB.7080505@rtr.ca>
References: <20090816004705.GA7347@infradead.org> <20090819203916.GA25296@elte.hu> <4A8CA956.2060406@rtr.ca> <4A8D5442.1000302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A8D5442.1000302@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, IDE/ATA development list <linux-ide@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-scsi@vger.kernel.org

Ric Wheeler wrote:
>
> Note that returning consistent data is critical for devices that are 
> used in a RAID group since you will need each RAID block that is used to 
> compute the parity to continue to return the same data until you 
> overwrite it with new data :-)
> 
> If we have a device that does not support this (or is misconfigured not 
> to do this), we should not use those devices in an MD group & do discard 
> against it...
..

Well, that's a bit drastic.  But the RAID software should at least
not issue TRIM commands in ignorance of such.

Would it still be okay to do the TRIMs when the entire parity stripe
(across all members) is being discarded?  (As opposed to just partial
data there being dropped)
