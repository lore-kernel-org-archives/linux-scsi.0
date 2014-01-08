From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: status of block-integrity
Date: Wed, 08 Jan 2014 08:05:10 +0800
Message-ID: <1389139510.2064.22.camel@dabdike.pnp.gw>
References: <20131222192128.GA28532@infradead.org>
	 <yq11u134rmt.fsf@sermon.lab.mkp.net> <52CBBABD.50902@gmail.com>
	 <52CC0216.5060900@suse.de> <20140107233410.GA1263@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33338 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752310AbaAHAFQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2014 19:05:16 -0500
In-Reply-To: <20140107233410.GA1263@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Hannes Reinecke <hare@suse.de>, Ric Wheeler <ricwheeler@gmail.com>, "Martin K. Petersen" <mkp@mkp.net>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>

On Tue, 2014-01-07 at 16:34 -0700, Matthew Wilcox wrote:
> On Tue, Jan 07, 2014 at 02:33:10PM +0100, Hannes Reinecke wrote:
> > I would indeed like to have a discussion at LSF about the future of
> > DIX. DIF is not an issue, as most HBAs support it already and we
> > actually need it for proper connectivity.
> > 
> > DIX, OTOH, has been left dormant since time immemorial, with the
> > only known (supposed) user being Oracle.
> > (I actually talked to the DB/2 folks about it, and the response
> > was a polite feigned interest ...)
> 
> I think there's a terminology confusion here; you seem to be using DIX
> to mean the TCP CRC and DIF to mean T10DIF.  I've seen other people use
> DIX to mean separate SGLs for metadata and DIF to mean interleaved data.
> Can you confirm which thing you mean here?

No, I think you're confusing algorithms with protocols.  DIF and DIX are
two names for protection envelopes.  DIF verifies integrity from the HBA
to the device surface.  DIX verifies integrity from an application to
the HBA.  Both DIF and DIX have pluggable checksum algorithms (and, in
theory, as long as the HBA does the conversion, they don't have to use
the same one, although the confusion over protection types and
algorithms is so dense already that the only way not to go insane is to
use the same end to end one).  Oracle has the best data sources to
explain this, including Martin's slides:

https://oss.oracle.com/projects/data-integrity/documentation/

The specific problem is that there's no defined interface for any
application to use DIX easily because it has to supply additional
protection information when it reads or writes data and there's no
agreed way to extend read/write to do this and, as Martin has said,
thinging about trying to do this with mmap leads to a "bonghit bonanza".

So, the question is do we need to bother with DIX at all?  No filesystem
uses it and there seems to be weak user demand at best.  We could just
strip DIX, losing the protection envelope from the application to the
HBA but keeping DIF, which is the protection envelope from the HBA to
the device.  

James


