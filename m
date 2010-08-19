From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/6] libata: Report supported TRIM payload size
Date: Thu, 19 Aug 2010 14:05:51 -0400
Message-ID: <yq1fwyamq9s.fsf@sermon.lab.mkp.net>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
	<1282232941-9910-3-git-send-email-martin.petersen@oracle.com>
	<AANLkTike+4Z2Z7eHEN=NHY=N72cO5bGJUwJbXzgJAKUx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <AANLkTike+4Z2Z7eHEN=NHY=N72cO5bGJUwJbXzgJAKUx@mail.gmail.com>
	(Greg Freemyer's message of "Thu, 19 Aug 2010 13:27:21 -0400")
Sender: linux-ide-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

>>>>> "Greg" == Greg Freemyer <greg.freemyer@gmail.com> writes:

>> + /* Default to 1 if unspecified in word 105. Cap at 1 page. */

Greg> Should there at least be a todo comment about raising that cap?

We don't currently plan to.  The payload is a single page which we can
allocate fairly easily.  A bigger payload would be more problematic.

With the 4KB payload you can adress 16GB with one command.


Greg> Or is there a fundamental reason for it.  ie. I don't think the
Greg> ATA spec calls for it, so this is a kernel restriction I assume.

Yes, this is part of the internal SCSI-ATA translation mechanism in
Linux.  But fwiw, there I'm only aware of one drive that currently
supports more than 512 bytes of payload and it also caps at 4KB.


Greg> Is this patch actually enabling the block layer to initiate ATA
Greg> multi-sector trim payloads, or is this only allowing the max
Greg> payloads sectors to be queried?

TRIM only takes 65535 blocks per entry.  So we need many entries to
decribe a single, contiguous space being freed.  That's what's being
bumped here.


Greg> Are there plans (or existing code) to accumulate trim ranges in
Greg> the block layer and create trim commands with multiple sectors?

I have worked on this on and off.  It's not trivial for several reasons.
We discussed the issues at the storage workshop last week and there was
concensus that the changes were too intrusive.  So we're holding off
until we see what's happening with:

      a) the SSD market. Win 7 also issues lots of small, individual
         trims like we do

      b) the TRIM TNG command that's being worked on in T13

This doesn't mean that TRIM coalescing is impossible and that it will
never happen.  But right now it appears to be more hassle than it's
worth...

-- 
Martin K. Petersen	Oracle Linux Engineering
