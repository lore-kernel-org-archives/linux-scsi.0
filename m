From: "Scott M. Ferris" <sferris@acm.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Mon, 1 Dec 2003 11:19:15 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031201171915.0F9DB5DC7E@bambi.visi.com>
References: <Pine.LNX.4.58.0312011655240.26106@serv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from conn.mc.mpls.visi.com ([208.42.156.2]:20434 "EHLO
	conn.mc.mpls.visi.com") by vger.kernel.org with ESMTP
	id S263887AbTLARTR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2003 12:19:17 -0500
In-Reply-To: <Pine.LNX.4.58.0312011655240.26106@serv> from Roman Zippel at "Dec
 1, 2003 10:22:36 am"
List-Id: linux-scsi@vger.kernel.org
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Naveen Burmi <naveenb@cisco.com>, hch@infradead.org, linux-scsi@vger.kernel.org

Roman Zippel wrote:
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

I don't think he's describing an iSCSI transport problem.  It's not
the iSCSI CRC that was bad.  A Fibre Channel HBA in an iSCSI<->FCP
gateway detected a Fibre Channel CRC error, and the gateway decided to
report it as a HARDWARE ERROR to the iSCSI initiator.  Linux doesn't
retry HARDWARE ERRORs, so they have a problem.

I think that's a bad choice of sense key by the gateway. COMMAND
ABORTED would be a better choice if the gateway wants the initiator to
retry the command.  0B/47xx and 0B/48xx are commonly used to report
CRC and parity errors.  Fixing the gateway seems like the best
solution to me.

Copying the data is not a good solution to anything.  If they think
there's a bug in the TCP stack that is corrupting the data, they ought
to go fix the TCP stack.  If the TCP stack isn't corrupting the data,
then copying the data is a waste of time, and puts memory allocation
in the I/O path, which is really not a good idea.

-- 
Scott M. Ferris,
sferris@acm.org 
