From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 2.4] rewritable USB DVD-RAM vs. mode sense op choice
Date: Mon, 23 Aug 2004 19:12:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040823171253.GD24089@suse.de>
References: <1092673789.4297.7.camel@patlinux.iomegacorp.com> <20040823154850.GC2301@suse.de> <F631591B-F523-11D8-BFA2-00039398BB5E@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:49058 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266127AbUHWRM5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 13:12:57 -0400
Content-Disposition: inline
In-Reply-To: <F631591B-F523-11D8-BFA2-00039398BB5E@ieee.org>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Aug 23 2004, Pat LaVarre wrote:
> >the MODE_SENSE_10 a fall back when MODE_SENSE fails
> 
> I believe the specs on the web instead tell us to try MODE_SENSE_10 
> first and then fall back to MODE_SENSE.  I hear you requesting the 
> reverse, I will deliver what I hear you request.

That's what I would do as well, actually. But since this is 2.4 it's
safe to keep old behaviour and only try something new if that fails.

> >your device is failing ... ?
> 
> Help, I have more than one device.

Doesn't matter

> My Iomega REV drive works here because that device accepts both ops, 
> implementing the SFF/ ANSI MMC specification for op x5A and the 
> incompatible ANSI SPC specification for op x1A.  To achieve 
> compatibility, I believe every host should try both ops and every 
> device should accept both ops.
> 
> I mean only to say that I see Linux 2.4 sr_mod mischaracterises the 
> many DVD/ CD devices that do reject op x1A while accepting only op x5A 
> MODE_SENSE_10.
> 
> I hesitate to accept the Linux name MODE_SENSE for the op x1A, because 
> I do not find that claim well-founded in the web for PDT x05 = DVD/ CD 
> = MMC.  I remember Mt Fuji in particular neglects to name op x1A.

That's the classical naming, since the 6-byte variant was the original
(and surely people would have found it stupid to name it MODE_SENSE_6
back then). So experience usually tell people that when you see READ and
READ_10, the former is the old 6-byte variant.

Mt Fuji doesn't name any of the 6-byte variants, since they are long
deprecated for that class of devices.

> >your device is failing ... ?
> 
> In this thread I meant to share the example of 2.4 sr_mod 
> mischaracterising a USB DVD-RAM drive that rejects op x1A.
> 
> I hear of PATAPI DVD/CD devices that reject op x1A also.  I imagine 
> ide-cd works only by trying op x5A, and not just x1A.  Want me to 
> check?  I don't yet know how to trace in Linux the plain hex of the 
> CDB's that ide-cd sends.

Only sr issues 6-byte commands, I don't think support for them was ever
required for ATAPI devices.

So if you add a fallback to issue MODE_SENSE_10 when _6 fails, you
should be golden.

-- 
Jens Axboe

