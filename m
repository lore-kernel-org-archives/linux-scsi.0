From: Andre Hedrick <andre@linux-ide.org>
Subject: RE: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Mon, 1 Dec 2003 19:46:31 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10312011925380.17836-100000@master.linux-ide.org>
References: <Pine.LNX.4.58.0312011655240.26106@serv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astound-64-85-224-253.ca.astound.net ([64.85.224.253]:60681
	"EHLO master.linux-ide.org") by vger.kernel.org with ESMTP
	id S264308AbTLBDun (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2003 22:50:43 -0500
In-Reply-To: <Pine.LNX.4.58.0312011655240.26106@serv>
List-Id: linux-scsi@vger.kernel.org
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Naveen Burmi <naveenb@cisco.com>, hch@infradead.org, linux-scsi@vger.kernel.org



The rare cases of "data corruption" under iSCSI is because most iSCSI
products fail to follow the rules of DAS.  Operating from the mindset of
DAS, local buffers are permitted to change regardless.  This includes
execution to platter.  It includes pre and operationial IO execution or
commits to the media.

If a "memcpy" is held and the original content changes with the top level
caller not marking the request dirty, BOOM you just commited crap to
platter.

If you are not zero-copy to the network stack, you will never catch the
changes between calculation of the CRC32C and pumping to the wire.

iSCSI(MC)

BLOCK->SCSI->iSCSI->MEMCPY->CRC32C->TCP->WIRE
                              ^^^^^^^^^^^^^^
                              BOOM memory buffers change

iSCSI(ZC)

BLOCK->SCSI->iSCSI->CRC32C->TCP->WIRE
                      ^^^^^^^^^^^^^^
                      BOOM memory buffers change

iSCSI(MC) passes CRC32C

iSCSI(ZC) fails CRC32C, and retries the failed PDU.

It should be clear that any TARGET, INITIATOR, or PAIR doing iSCSI(MC)
will roast your data.

Now iSCSI(ZC) requires ERL >= 1 w/ Sync-and-Steering.

Real iSCSI does ERL >= 2, but then again > 2 means new async-connections.
To learn more join the IETF reflector.  Please be kind to the folks who
are only "network centric" they mean well but just don't get storage.

Cheers,

Andre Hedrick
LAD Storage Consulting Group

On Mon, 1 Dec 2003, Roman Zippel wrote:

> Hi,
> 
> On Mon, 1 Dec 2003, Naveen Burmi wrote:
> 
> > In linux kernel there is a rare occurrence of data corruption. This data can
> > be buffer cache data as well as raw I/O data. Don't know the actual root
> > cause of the problem, but the fix that we put under macro
> > "PREVENT_DATA_CORRUPTION" is capable of resolving this problem.
> 
> You probably mean the page cache and it's normal that a page can be
> modified, while it's written out.
> 
> > On iSCSI target, 5428-2, upon detecting the CRC data error by the QlogicFC
> > card it generates  the sense data with sense key as HARDWARE ERROR
> > and Additional sense data as LOGICAL UNIT COMMUNICATION FAILURE.
> > Upon receving this sense data iSCSI initiator driver is not retrying this
> > command and failing the command to the upper layers of SCSI subsystem.
> > But linux SCSI subsystem does not perform any error recovery for this kind of
> > sense data.
> 
> The answer from the target is weird, why does it react with a scsi error
> to an iSCSI transport problem?
> At ERL0 the target should just drop the packet and/or close the
> connection. Recovery of such case would require ERL1, where the target
> could request to retransmit the corrupted data pdu or send a CHECK
> CONDITION (but also with a different sense data).
> 
> bye, Roman
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

