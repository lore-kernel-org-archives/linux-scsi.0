From: Ewan Milne <emilne@redhat.com>
Subject: RE: Question on SCSI target scan
Date: Thu, 21 Nov 2013 13:45:30 -0500
Message-ID: <1385059530.3839.90.camel@localhost.localdomain>
References: <5645D6F831469342AF2BC26CC827D68C5940032A27@BRM-EXCH-3.corp.brocade.com>
	 <94D0CD8314A33A4D9D801C0FE68B4029547B9343@G9W0745.americas.hpqcorp.net>
	 <1384795712.3839.6.camel@localhost.localdomain>
	 <94D0CD8314A33A4D9D801C0FE68B4029547CE0FB@G4W3202.americas.hpqcorp.net>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab3KUSqK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Nov 2013 13:46:10 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029547CE0FB@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Ramesh Chikkanayakanahally <rcnagara@Brocade.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>

On Thu, 2013-11-21 at 17:37 +0000, Elliott, Robert (Server Storage)
wrote:
> 
> > -----Original Message-----
> > From: Ewan Milne [mailto:emilne@redhat.com]
> > Sent: Monday, 18 November, 2013 11:29 AM
> > To: Elliott, Robert (Server Storage)
> > Cc: Ramesh Chikkanayakanahally; linux-scsi@vger.kernel.org;
> > jbottomley@parallels.com
> > Subject: RE: Question on SCSI target scan
> > 
> > On Fri, 2013-11-15 at 23:53 +0000, Elliott, Robert (Server Storage)
> > wrote:
> > > Beware that just because the LUN inventory is the same doesn't mean
> > > the logical units are the same.  A logical unit at LUN X might have been
> > > deleted and another logical unit created and assigned to LUN X, but
> > > now containing different content.  You need to check the logical unit
> > > name (in the Device Identification VPD page) too.
> > > ---
> > > Rob Elliott    HP Server Storage
> > >
> > 
> > If the properties of the volume behind a particular LUN are changed,
> > shouldn't something like ASC/ASCQ 3F 03 INQUIRY DATA HAS CHANGED,
> > 3F 04 DEVICE IDENTIFIER CHANGED be reported?  Or can we not expect
> > this if a LUN is removed and then re-added without an intervening
> > REPORT LUNS command?  (In that case, the REPORT LUNS data returned
> > will be no different.)
> > 
> > -Ewan
> > 
> 
> It might report that, and/or these:
> VOLUME SET CREATED OR MODIFIED (3Fh/0Ah)
> NOT READY TO READY CHANGE, MEDIUM MAY HAVE CHANGED (28h/00h)
> 
> However, the device server in the new logical unit might not know that 
> there was a previous logical unit assigned to that LUN and might not know 
> all the INQUIRY data, mode page values, log page values, etc. values that 
> were in use to compare them to the current values, so is probably unable 
> to report the specifics of what changed.  It will probably just report an 
> additional sense code with ASC=29h like POWER ON OCCURRED (29h/01h).  
> 
> Per the unit attention condition precedence level rules (see SAM-5
> revision 15 table 53), the additional sense codes with ASC=29h imply that 
> all other unit attention conditions might also have happened (INQUIRY 
> data changed, mode pages changed, log pages changed, capacity
> changed, etc.).  Software is supposed to assume the worst and check 
> everything again.  I'm not confident that much software really does that, 
> though.
> 
> The unit attention condition precedence is:
> 1. POWER ON, RESET, OR BUS DEVICE RESET OCCURRED (29h/00h)
> 2. POWER ON OCCURRED  (29h/01h) or 
>    DEVICE INTERNAL RESET  (29h/04h)
> 3. SCSI BUS RESET OCCURRED  (29h/02h) or 
>    MICROCODE HAS BEEN CHANGED  (3Fh/01h) or 
>    protocol specific (e.g., TRANSCEIVER MODE CHANGED
>    TO LVD 29h/06h in parallel SCSI)
> 4. BUS DEVICE RESET FUNCTION OCCURRED (29h/03h)
> 5. I_T NEXUS LOSS OCCURRED (29h/07h)
> 6. COMMANDS CLEARED BY POWER LOSS NOTIFICATION (2Fh/01h)
> 7. All others
> 
> Also, for each ASC value, ASCQ=00h has precedence over all ASCQ values
> that are nonzero. For example, PARAMETERS CHANGED (2Ah/00h) implies 
> that all the other 2Ah/xxh codes might have happened.
> 
> ---
> Rob Elliott    HP Server Storage

Useful information, thanks for the reply.

-Ewan


