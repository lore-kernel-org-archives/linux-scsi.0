From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Mon, 17 Feb 2003 12:20:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E5119EC.7080907@splentec.com>
References: <3E495862.3050709@splentec.com>	<20030211212048.GC1114@beaverton.ibm.com> <3E49698D.3030402@splentec.com>	<20030211224119.A23149@infradead.org> <3E4AAA3F.8040002@splentec.com>	<20030212204634.A17425@infradead.org> <3E4AC0B5.9030208@splentec.com>	<20030213154748.A1965@infradead.org> <3E4BEA13.50402@splentec.com>	<20030213192440.A6660@redhat.com> <20030214165827.GA1165@beaverton.ibm.com>	 <3E4D44EB.1090402@splentec.com> <1045257640.1726.23.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Fri, 2003-02-14 at 14:35, Luben Tuikov wrote
 >[...]
>>struct scsi_lun {

This should've been ``struct scsi_lu { ... ''

 >[...]
 >
> I don't like this on several grounds:
> 
> 1. You have a really complex locking hierarchy.  It may be
> philosophical, but I regard locking heirarchies as evil.  The only good
> they can possibly serve is if you give a clear demonstration that they
> avoid hot lock contention.  Otherwise, they tend to create more problems
> than they solve.

There is no ``locking hierarchy'' -- i.e. a lock *only* locks its list
manipulation. So, you don't have to have a string of locks to change
a scsi_command, for example.

It is *not* ``philosophical''.  It's what's in SAM-2/3.  And it is what
most SPI HBA do this already (since you use SPI HBA's in your example).

When was the last time a SPI HBA set channel/bus to anything different
than 0?

My Adaptec AIC-7899P dual channel, presents two hosts, not two channels.
And this is the right behaviour.

IOW, it already is hinting that those are ``portals''.  There is no
such thing as a ``host'' in SCSI-3.  ``host'' is an SPI term, and is gone
from SAM and SPC (which is what scsi-core should represent).

> 2. The data structures you propose don't match reality.  The reality is
> that we will have to cope with SPI for a while yet, and it doesn't have
> scsi_portal.

See above.  I've never seen an SPI HBA which sets channel/bus different
than zero.  I.e. for all N-channel SPI HBA that export a scsi_host for
a channel (i.e. bus/channel != 0 ever) you have a ``portal''.  I.e.
this is easily convertible to a ``portal''.

> 3. I don't see where the mid-layer has a use for the data.  By and

Well, how can I contend *that* statement?...  This basically means
that the whole thing I proposed is cr*p.

> large, we queue at the LUN level and we control parameters at the host
> level.

Not anymore, you don't.

You queue at LU level, and control parameters
	- at LU level, for the device server itself (i.e. the thingy
which executes scsi commands),
	- at Target level, (for target specific parameters),
	- at Portal level, for the service delivery subsystem (i.e.
controls specific for SPI, FC, etc.).

It's not that hard to imagine a target whose LUN 3 is the enclosure
and LU 1 is a certain disk, and the target is the whole ``box''.


> The only current times we need to even associate puns and luns
> is for error handling (reset non-locality) and for certain times when
> the host is negotiating transfer parameters.  The current sibling list
> may be a bit ugly, but it serves its purpose.

Patchwork solutions only cripple expansion of functionality.

Versatility (what SCSI-3 is aiming at) is tied very closely
with design (i.e. structure).  As an example of this
statment, try arithemtic in roman numerals and then you'd
appreciate the widely used arabic notation.

So you have OO structure from SAM-2/3 (bottom), and you have OO structure
from sysfs (top), and scsi-core should follow suit.

That OO structure for scsi-core is the one I posted -- it is a representation*
of the SCSI Architecture Model from SAM-3.

* I.e., suitable for a kernel.

-- 
Luben


