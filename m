From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Mon, 1 Dec 2003 12:31:51 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10312011224360.17836-100000@master.linux-ide.org>
References: <yquju14kqp4z.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astound-64-85-224-253.ca.astound.net ([64.85.224.253]:50697
	"EHLO master.linux-ide.org") by vger.kernel.org with ESMTP
	id S263996AbTLAUgN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2003 15:36:13 -0500
In-Reply-To: <yquju14kqp4z.fsf@chaapala-lnx2.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Clay Haapala <chaapala@cisco.com>
Cc: "Scott M. Ferris" <sferris@acm.org>, Roman Zippel <zippel@linux-m68k.org>, Naveen Burmi <naveenb@cisco.com>, hch@infradead.org, linux-scsi@vger.kernel.org


Well it sounds like you are passing the FC error back over the iSCSI
transport, as a CRC32C would only invoke a retry or session reinstatement
in worst case (well absolute worst case, TPGT migration blab blah).

It is a bad target unless it was under a task management command set where
the frontend to scsi management would require the full senes data back.
Otherwise, all things considered in storage is a lie, the response is
faked.

Cheers,

Andre
--------------------------------------
If liberals could make it on the airwaves they would not whine; however,
they have the LA Times.


On Mon, 1 Dec 2003, Clay Haapala wrote:

> On Mon, 1 Dec 2003, Scott M. Ferris verbalised:
> > Roman Zippel wrote:
> >> Hi,
> >> 
> >> On Mon, 1 Dec 2003, Naveen Burmi wrote:
> >> 
> >> > In linux kernel there is a rare occurrence of data
> >> > corruption. This data can be buffer cache data as well as raw I/O
> >> > data. Don't know the actual root cause of the problem, but the
> >> > fix that we put under macro "PREVENT_DATA_CORRUPTION" is capable
> >> > of resolving this problem.
> >> 
> >> You probably mean the page cache and it's normal that a page can be
> >> modified, while it's written out.
> >> 
> >> > On iSCSI target, 5428-2, upon detecting the CRC data error by the
> >> > QlogicFC card it generates the sense data with sense key as
> >> > HARDWARE ERROR and Additional sense data as LOGICAL UNIT
> >> > COMMUNICATION FAILURE.  Upon receving this sense data iSCSI
> >> > initiator driver is not retrying this command and failing the
> >> > command to the upper layers of SCSI subsystem.  But linux SCSI
> >> > subsystem does not perform any error recovery for this kind of
> >> > sense data.
> >> 
> >> The answer from the target is weird, why does it react with a scsi
> >> error to an iSCSI transport problem?
> > 
> > I don't think he's describing an iSCSI transport problem.  It's not
> > the iSCSI CRC that was bad.  A Fibre Channel HBA in an iSCSI<->FCP
> > gateway detected a Fibre Channel CRC error, and the gateway decided
> > to report it as a HARDWARE ERROR to the iSCSI initiator.  Linux
> > doesn't retry HARDWARE ERRORs, so they have a problem.
> > 
> > I think that's a bad choice of sense key by the gateway. COMMAND
> > ABORTED would be a better choice if the gateway wants the initiator
> > to retry the command.  0B/47xx and 0B/48xx are commonly used to
> > report CRC and parity errors.  Fixing the gateway seems like the
> > best solution to me.
> > 
> > Copying the data is not a good solution to anything.  If they think
> > there's a bug in the TCP stack that is corrupting the data, they
> > ought to go fix the TCP stack.  If the TCP stack isn't corrupting
> > the data, then copying the data is a waste of time, and puts memory
> > allocation in the I/O path, which is really not a good idea.
> 
> We need to make sure which type of error we are really talking about,
> here, iSCSI-CRC32c digest error or Fibre Channel link error.
> 
> Using the Cisco SN 5428-2 as the example gateway here, in the case of
> a Fibre Channel CRC error, the command is retried a [configurable]
> number of times.  If no success, then the ususal SCSI sense codes are
> sent back to the initiator, and they should indicate HARDWARE ERROR.
> 
> In the case of an error in the iSCSI-CRC32c digest, this is computed
> in the SN 5428-2 by the QL 2320 HBA.  (That's where the references to
> QLogic came from.)  Early releases of the SN 5428 returned the
> HARDWARE ERROR (LUN failure) status, but that has been changed to
> match the iSCSI spec in an upcoming release and return the 0B/4705
> code (COMMAND ABORT) in that case.  (That fix for the 2320-offload
> lagged the fix in the software computation.)
> 
> So, Naveen, which type of error are we talking about here?  If it is
> the digest error, and COMMAND ABORT happens instead of HARDWARE ERROR,
> is the buffer copy still necessary?  I can see the case above where
> the page buffer is modified while it is being written (and,
> presumably, still marked dirty so another write of it will happen),
> but I dimly recall discussion of a case where the buffer got thrown
> away.  If a COMMAND ABORT is returned rather than the other code, does
> this case still obtain?
> -- 
> Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
>    6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
>      Well, looks like hypocrisy is back on the airwaves.
>        C'mon, Rush!  Do the crime, do the time, right?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

