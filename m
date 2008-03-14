From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] mpt fusion: Power Management fixes for MPT SAS PCI-Econtrollers-revised
Date: Fri, 14 Mar 2008 09:27:55 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70D82C72@NAMAIL4.ad.lsil.com>
References: <1205444515.2893.77.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:41858 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbYCNPde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Mar 2008 11:33:34 -0400
Content-class: urn:content-classes:message
In-reply-to: <1205444515.2893.77.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, djwong@us.ibm.com

On Thursday, March 13, 2008 3:42 PM,  James Bottomley wrote:
> On Fri, 2008-03-07 at 16:19 +0530, Prakash, Sathya wrote:
> > This patch includes the review comments from James on the 
> previous version.
> > 
> > The system power state changes like hibernation and standby 
> are not happening
> > properly with 106XE controllers, this patch modifies the 
> driver to free
> > resources and allocate resources in power management entry points
> 
> This is supposed to be a bug fix patch to get suspend/resume working.
> Because you've made it dependent on the msi_enable patch, which is a
> feature enhancement, it still can't go in the scsi-rc-fixes tree.
> 
> Isn't it just best at this point to go with Darrick's patch for fixing
> 2.6.25 and 2.6.24?
> 

James, 

The patch supplied by Darrick will not fix the issue reported on the
x-series IBM platforms.    To fix the problem we need to be sending a
diagnostic reset, instead of MUR (message_unit_reset), when we are
coming out of resume.  Regarding MSI, the driver already has MSI support
for a couple years, however you would have to manually enable it thru a
command line option.  The patch we supplied will have it always enabled
for SAS parts.   Enabling MSI helped with debugging this issue IBM
reported, however its not required.  We have no issues with having MSI
always enabled, as today we are shipping other drivers having that
enabled, and we've been testing this in the labs for the past year.
The other part of the patch was to release/allocate resource power
management seems to me to be more efficient method for power management,
and this was coded it when we were working this issue, do you agree?

Here is the contents of the Power Management Errata which only effects
PCIe SAS Parts:

Doorbell does not reset on a D0->D3->D0 transition.  If the part is
power managed to D3 state, the doorbell register will remain at whatever
it was set to before the part was power managed.  The driver will issue
a MUR just before we are shutdown, to clear out all I/O's (there
shouldn't be any, but just in case) and mainly to disable events.  If
events are enabled the F/W can get stuck trying to issue an event even
though the device has been unmapped.  Anyway, the doorbell will be in
the Ready state due to the MUR.  Now, after the D0->D3->D0 transition
the driver comes back up and immediately sees Ready in the doorbell and
starts to try to initialize the device (IOCInit, PortEnable, etc.).
But, the device really isn't ready yet (H/W and F/W are still getting
things initialized after the D3->D0 transition).  So these handshake
messages fail.  The workaround I was told to use is to do a diag reset
after coming out of any power transisiton state.

Eric Moore



