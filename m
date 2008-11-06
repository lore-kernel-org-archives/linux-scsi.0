From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: thin provisioned LUN support
Date: Thu, 06 Nov 2008 09:17:08 -0600
Message-ID: <1225984628.4703.80.camel@localhost.localdomain>
References: <4913028B.6010405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4913028B.6010405@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2008-11-06 at 09:43 -0500, Ric Wheeler wrote:
> After talking to some vendors, one issue that came up is that the arrays 
> all have a different size that is used internally to track the SCSI 
> equivalent of TRIM commands (POKE/unmap).
> 
> What they would like is for us to coalesce these commands into aligned 
> multiples of these chunks. If not, the target device will most likely 
> ignore the bits at the beginning and end (and all small requests).
> 
> I have been thinking about whether or not we can (and should) do 
> anything more than our current best effort to send down large chunks 
> (note that the "chunk" size can range from reasonable sizes like 8KB or 
> so up to close to 1MB!).
> 
> One suggestion is that a modified defrag sweep could be used 
> periodically to update the device (a proposal I am not keen on).
> 
> Thoughts?

This one's a bit nasty.  We can't just use elevator techniques (assuming
we wanted to) beacuse a) the deletions are going to obey different
statistics and b) because the elevator eventually releases the
incorrectly sized units which then get ignored.

The way to do this properly would be to run a chequerboard of partials,
but this would effectively have trim region tracking done in the block
layer ... is this worth it?

By the way, the latest (from 2 days ago) version of the Thin
Provisioning proposal is here:

http://www.t10.org/ftp/t10/document.08/08-149r4.pdf

I skimmed it but don't see any update implying that trim might be
ineffective if we align wrongly ... where is this?

James



