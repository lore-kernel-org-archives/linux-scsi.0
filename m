From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 14 Jan 2003 10:49:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030114104945.A24400@beaverton.ibm.com>
References: <3E1ADC9A.6090800@splentec.com> <20030107102127.B15528@beaverton.ibm.com> <3E1B2934.8060805@splentec.com> <20030107123301.A16378@beaverton.ibm.com> <3E1B513B.2090409@splentec.com> <20030107173633.A17825@beaverton.ibm.com> <20030111181224.B3178@infradead.org> <20030113123306.A16718@beaverton.ibm.com> <3E232FDD.5000906@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E232FDD.5000906@splentec.com>; from luben@splentec.com on Mon, Jan 13, 2003 at 04:30:05PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 13, 2003 at 04:30:05PM -0500, Luben Tuikov wrote:

> 
> I brought this up last year sometime, either privately or here (search
> the archives if anyone is interested) and the idea of using a 64-bit LUN
> was shot down as in ``we don't need so many bits''.
> 

Luben - 

I didn't mean we should never change to 64-bits, more along the lines of I
didn't find the effort of coding the change worth supporting more than
(our current) 32 bit lun. 

IMO a 64-bit lun and the hierarchy stuff (see the SAM spec, page 49 of
ftp://ftp.t10.org/t10/drafts/sam3/sam3r04.pdf) is a waste, but my opinion
won't change the spec. (BTW has anyone ever seen a target that supports
such a hierarchy, and is visible from the host, much like a switch?). IP
addresses are _still_ primarily 32 bits, can you imagine anyone with a
_single_ target (like a disk array) with 2^62 LUNs?  If there was no
target ID, a 64-bit lun might be sensible.

(And, it is a bit odd that the SCSI specs have a 64-bit LUN for interfaces
that only support 5 bit LUNs.)

With the current scsi code, going to a 64-bit lun means changing sdev->lun
and conditionally changing references to it to use a 64-bit struct
scsilun, or (mainly in the lldd) to call a conversion function if you must
use less than 64-bits. (Currently, no open source FCP adapters use an 8
byte lun to talk to the host adapter hardware, not even the qlogic
adapter.)

We could change scsilun_to_int to be a:

	scsilun_convert(biglun, size, &smaller_lun).

SPI could use something like: scsilun_convert(biglun, 1, &one_byte_lun)

The qlogic drivers would use: scislun_convert(biglun, 2, &two_byte_lun)

Then, there is an issue with shost->max_lun, it's currently an int.
max_lun or some other method (a shost function and/or flag) is needed so
the scsi scan code can figure out when to stop a serial scan, or when to
skip a LUN value via REPORT LUNS scanning if it exceeds the size supported
by the adapter. Then, always checking max_lun is wrong (for lldd with
64-bit LUN support), and a 64-bit max_lun seems wrong.

-- Patrick Mansfield
