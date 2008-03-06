From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mvsas: fix default can_queue
Date: Thu, 06 Mar 2008 11:44:34 -0600
Message-ID: <1204825474.3062.25.camel@localhost.localdomain>
References: <1204308113.4003.45.camel@localhost.localdomain>
	 <1204504945.3069.30.camel@localhost.localdomain>
	 <6b2481670803030017h43da68bcxd78a6142f8f5c6bb@mail.gmail.com>
	 <1204556371.3043.7.camel@localhost.localdomain>
	 <1204682849.3091.95.camel@localhost.localdomain>
	 <1204750960.3047.67.camel@localhost.localdomain>
	 <6b2481670803060646m54675625g729a82c4da33ce05@mail.gmail.com>
	 <1204818725.3062.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60803 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498AbYCFRoi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 12:44:38 -0500
In-Reply-To: <1204818725.3062.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, jgarzik <jgarzik@redhat.com>

On Thu, 2008-03-06 at 09:52 -0600, James Bottomley wrote:
> On Thu, 2008-03-06 at 22:46 +0800, Ke Wei wrote:
> > On Thu, Mar 6, 2008 at 5:02 AM, James Bottomley
> > <James.Bottomley@hansenpartnership.com> wrote:
> > 
> > 1.
> > > >
> > > > OK, I instrumented more ... you're right, the first failing command is
> > > > REPORT_LUNS.  The failure isn't because the DVD doesn't accept the
> > > > command, but because it gets errored and we fail to report back the
> > > > error data.
> > 
> > First, I noticed that scsi_probe_and_add_lun function has changed
> > since v2.6.17-git4.
> > It will cause bflagsp to miss BLIST_NOREPORTLUN flag after calling scsi_add_lun.
> > On the other hand,  Even though mvsas driver can succeed in reporting
> > back the error data, scsi subsystem also will force device to reset
> > because of wrong REPORTLUN status. But Error again, then reset.
> > Maybe I may write simulation codes for this command.
> 
> But this isn't the problem.
> 
> I'll look into the mid layer changes and see if we have a problem.
> However, this device does respond correctly (with an error) to
> REPORT_LUNS (however, at the moment, for me, the current setup is a
> great test of ATA error handling).
> 
> When I have it on the aic94xx it terminates the command and sends back a
> Register D2H FIS with
> 
> error = 0x54 (sense key ILLEGAL REQUEST, ABRT)
> status = 0x51 (DRDY, SERV, CHK)
> 
> So the device does a correct termination for an unsupported command.
> The problem seems to be that mvsas isn't terminating and picking up the
> register D2H fis properly.  Which, in turn seems to be connected with
> the way it's not really processing a RXQ_ERR return.
> 
> This is a perfectly proper termination, and the scan routine will
> proceed normally without invoking any error handling (it's aware of the
> conflict between SPC and MMC regarding REPORT_LUNS).

Actually, I looked in your mvi->rx_fis area where the D2H FIS should be
and there seems to be a correct one collected.  The problem is that if
the slot returns RXQ_ERR without any other flags set (other than the
slot number), the driver does nothing.  Shouldn't the slot be completed
and the D2H FIS returned so we can then do a request sense?

James


