From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 14 Jan 2003 14:52:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E246A90.9060908@splentec.com>
References: <3E1ADC9A.6090800@splentec.com> <20030107102127.B15528@beaverton.ibm.com> <3E1B2934.8060805@splentec.com> <20030107123301.A16378@beaverton.ibm.com> <3E1B513B.2090409@splentec.com> <20030107173633.A17825@beaverton.ibm.com> <20030111181224.B3178@infradead.org> <20030113123306.A16718@beaverton.ibm.com> <3E232FDD.5000906@splentec.com> <20030114104945.A24400@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Mon, Jan 13, 2003 at 04:30:05PM -0500, Luben Tuikov wrote:
> 
> 
>>I brought this up last year sometime, either privately or here (search
>>the archives if anyone is interested) and the idea of using a 64-bit LUN
>>was shot down as in ``we don't need so many bits''.
>>
> 
> I didn't mean we should never change to 64-bits, more along the lines of I
> didn't find the effort of coding the change worth supporting more than
> (our current) 32 bit lun. 

You have to closely listen to the FC and iSCSI folks.

64-bit lun is *well* worth the effort.  As well as the primary
method of discovering luns being REPORT LUNS.  Anything which doesn't
support REPORT LUNS, but has more than a single LUN, should be considered
wierd/black listed/gray listed, etc.  Yes, I realise this is quite new,
but this is where things are going...

> IMO a 64-bit lun and the hierarchy stuff (see the SAM spec, page 49 of
> ftp://ftp.t10.org/t10/drafts/sam3/sam3r04.pdf) is a waste, but my opinion

I've read SAM-3 dosens of times, and the hierarchy organization is *not*
a waste when you think /storage networks/.

> won't change the spec. (BTW has anyone ever seen a target that supports

Exactly -- it won't change the spec.  64-bit lun is here to stay.
It is a real pain in the a*s to convert 64-bit lun to whatever the kernel
has decided that day to code LUNs as.

> such a hierarchy, and is visible from the host, much like a switch?). IP

Ideally, the ``host'' (old name), or ``initiator port'' (new name) should
not try to interpret LUN structure (a few exceptions of course).  LUN, as I
mentioned, should be blindly copied around by the kernel.  Application
clients and multipathing may be interested in LUN structure, but in general
not SCSI Core.

> addresses are _still_ primarily 32 bits, can you imagine anyone with a
> _single_ target (like a disk array) with 2^62 LUNs?  If there was no
> target ID, a 64-bit lun might be sensible.

Right, there's not going to be a ``target ID'' in SPI sense.  It gets
substituted with Target port/device name and identifiers.  SCSI Core
will decide what to use once those are finalised by T10.

BTW, this is still in discussion and development. If anyone is interested,
please see T10 document T10/02-419r1 or any later revision.

> (And, it is a bit odd that the SCSI specs have a 64-bit LUN for interfaces
> that only support 5 bit LUNs.)

But that's the *whole* point -- unification of transports.  This is what
SAM-3 is all about.  I.e. the transport should be transparent to the
application client.

> With the current scsi code, going to a 64-bit lun means changing sdev->lun
> and conditionally changing references to it to use a 64-bit struct
> scsilun, or (mainly in the lldd) to call a conversion function if you must
> use less than 64-bits.

Those are implementation issues, let's not go there right now, as they
are highly volatile and subject to change. (like gas and gas prices :-) )

> (Currently, no open source FCP adapters use an 8
> byte lun to talk to the host adapter hardware, not even the qlogic
> adapter.)

Well, give the SCSI/FC manufacturers a breather, they'll catch up.
BTW, any iSCSI device uses 64 bit luns.

The whole point is that the transport could be a *network* of transports
and one would want a unified representation.

> We could change scsilun_to_int to be a:
> 
> 	scsilun_convert(biglun, size, &smaller_lun).
> 
> SPI could use something like: scsilun_convert(biglun, 1, &one_byte_lun)
> 
> The qlogic drivers would use: scislun_convert(biglun, 2, &two_byte_lun)

I'd actually say just ``lun'' instead of ``biglun''.

Those two functions of course are to support only older LLDD, who never
knew about 64-bit luns.

Newer LLDD, even SPI and anything else, will do *their own* conversion
from 64-bit LUNS to whatever the transport uses. This will be transparent
to SCSI Core.

> Then, there is an issue with shost->max_lun, it's currently an int.
> max_lun or some other method (a shost function and/or flag) is needed so
> the scsi scan code can figure out when to stop a serial scan, or when to
> skip a LUN value via REPORT LUNS scanning if it exceeds the size supported
> by the adapter. Then, always checking max_lun is wrong (for lldd with
> 64-bit LUN support), and a 64-bit max_lun seems wrong.

Yes, one big mishmash of older and newer, broken and fixed hardware,
and patchwork solutions.

Right, there's no such thing as max_lun in 64-bit LUN space, since it
is not linear/enumerable, but hierarchical (space).

A couple of tiny notes is that, either a scsi device has a single LUN,
or it must support REPORT_LUNS (SPC-3); if a device reports the wrong
number LUNS from REPORT_LUNS, it is broken.

-- 
Luben



