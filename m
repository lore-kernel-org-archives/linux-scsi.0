From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 11302] New: I get a kernel OOPS! If I try to
	attach an usb card reader, SD, MMC, ecc.. to my Slamd64
Date: Mon, 11 Aug 2008 08:33:24 -0500
Message-ID: <1218461604.6965.4.camel@localhost.localdomain>
References: <bug-11302-10286@http.bugzilla.kernel.org/>
	 <20080810135344.6f900129.akpm@linux-foundation.org>
	 <20080811074553.11b06602@mjolnir.drzeus.cx>
	 <20080810233352.8423614f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52710 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533AbYHKNdb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2008 09:33:31 -0400
In-Reply-To: <20080810233352.8423614f.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, pinc_o@yahoo.it

On Sun, 2008-08-10 at 23:33 -0700, Andrew Morton wrote:
> On Mon, 11 Aug 2008 07:45:53 +0200 Pierre Ossman <drzeus@drzeus.cx> wrote:
> 
> > On Sun, 10 Aug 2008 13:53:44 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > 
> > > (switched to email.  Please respond via emailed reply-to-all, not via the
> > > bugzilla web interface).
> > > 
> > > On Sun, 10 Aug 2008 13:45:49 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> > > 
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=11302
> > > > 
> > > >            Summary: I get a kernel OOPS! If I try to attach an usb card
> > > >                     reader, SD, MMC, ecc.. to my Slamd64
> > > >            Product: IO/Storage
> > > >            Version: 2.5
> > > >      KernelVersion: 2.6.26.2
> > > >           Platform: All
> > > >         OS/Version: Linux
> > > >               Tree: Mainline
> > > >             Status: NEW
> > > >           Severity: blocking
> > > >           Priority: P1
> > > >          Component: SCSI
> > > >         AssignedTo: linux-scsi@vger.kernel.org
> > > >         ReportedBy: pinc_o@yahoo.it
> > > 
> > > Is this a scsi regresion, or an mmc regression?
> > > 
> 
> OK.  There have been some regressions in the scsi area but I thought
> that a) they were fixed and b) none manifested as an oops in
> slave_alloc().
> 
> Perhaps James can take a look please?

Well, this does illustrate one of the problems of making everything
static:  slave_configure isn't a terribly distinguished name.  However,
I'd bet this is usbstorage/scsiglue.c:slave_configure()

the taxonomy looks identical to bugs 11088 and 11072.  Which are being
fixed (have been fixed) in the USB tree.

James


