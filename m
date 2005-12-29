From: mark@markschaefer.org
Subject: Re: Booting from or using a Compaq RA4100 Array
Date: Thu, 29 Dec 2005 16:51:21 -0500 (EST)
Message-ID: <62187.24.3.12.198.1135893081.squirrel@www.markschaefer.org>
References: <1135801791.9541.12.camel@gateway.markschaefer.org>
    <200512290845.17192@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host79.host79-server.com ([66.49.184.32]:10678 "EHLO
	host79.host79-server.com") by vger.kernel.org with ESMTP
	id S1751028AbVL2Vvf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Dec 2005 16:51:35 -0500
In-Reply-To: <200512290845.17192@bilbo.math.uni-mannheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org

Eike,

I think I've resigned myself to the fact that it won't boot.  I've done=
 a
bit of digging by directly sending commands to the unit.  I'm not sure =
why
I can't force scsi_scan to do a REPORT_LUN on it through the Black List=
,
but what I know is that it reports luns as 0x40...00 - 0x40...MAX_LUNS =
-
they are reported as flat addressing, according to the SCSI Architectur=
e
Manual.

Since TYPE_RAID implements a standard (albeit deprecated), it might
actually be worth trying to create a driver for it.  The real question =
I
have is whether I could get at the drives simply by masking the LUN's l=
ike
the cpqfc driver does, or whether something like BLIST_SPARSE_LUNS woul=
d
do the trick, or maybe even a new blasklist entry like
BLIST_FLAT_LUN_ADDRESSING.

Here's a quote from cpqfcTSworker.c:
// e.g., the Compaq RA4x00 f/w Rev 2.54 and above may report
// LUNs 4001, 4004, etc., because other LUNs are masked from
// this HBA (owned by someone else).  We'll make those appear as
// LUN 0, 1... to Linux

I'm not sure what the direction of Linux is at this point, but there ar=
e a
lot of RA4x00's out there for cheap and they (at least initially) seeme=
d
like a good entry-level FC RAID system.  Also, I'm not sure how strange=
 of
a beast the RA4x00 is.  If it's a one-off, maybe I could create a speci=
fic
driver for it that acts as a LUN masker.  If there are more, it may mak=
e
sense to make the changes necessary to deal with flat addressing.

At this point, I'm convinced that it would be a minor change to at leas=
t
the scsi_scan code to deal with TYPE_RAID.  I'm a bit more concerned ab=
out
how widespread a change like flat addressing would be.

Mark

>
> I'm now quoting mkp:
>
> ---
> But the other reason the cpqfcTS driver is special is the RA4100
> array. =A0The two were sold as a packaged solution. =A0The RA4100 isn=
't a
> "real" fibre channel disk device. =A0It represents itself as a TYPE_R=
AID
> as opposed to TYPE_DISK. =A0So even if you had my driver in 2.6.5, yo=
u
> wouldn't be able to use it.
> ---
>
> What he was talking about as his driver is a replacement he writes fo=
r
> cpqfc.
> cpqfc was deleted from 2.6 because it was horribly written and curren=
tly
> broken. The 2.4 version is the same, but it might work because the 2.=
4
> infrastructure is different from the 2.6 one.
>
> Eike
>


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
