From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 1/3] mpt2sas: Wait for port enable to get complete
 before reporting devices to OS.
Date: Sat, 11 Sep 2010 09:03:02 -0500
Message-ID: <1284213782.2986.15.camel@mulgrave.site>
References: <20100804083355.GB13442@lsi.com>
	 <1283704496.15944.1271.camel@mulgrave.site>
	 <4565AEA676113A449269C2F3A549520F4918A80E@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52509 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415Ab0IKODG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Sep 2010 10:03:06 -0400
In-Reply-To: <4565AEA676113A449269C2F3A549520F4918A80E@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Thu, 2010-09-09 at 16:43 -0600, Moore, Eric wrote:
> On Sunday, September 05, 2010 10:35 AM, James Bottomley wrote:
> > On Wed, 2010-08-04 at 14:04 +0530, Kashyap, Desai wrote:
> > > Add support in driver so it will wait for discovery to complete
> > > before returning from the send_port_enable routine.  There are some
> > > cases where firmware is doing discovery after port enable completes.
> > > When it does this, the driver will not have all the devices in the
> > > sas_device_init_list list prior to calling the sort routine for
> > reporting
> > > boot devices to OS.
> > >
> > > This patch is required so the driver is waiting for all the events to
> > > be processed in the hot plug worker thread prior to reporting them to
> > the
> > > OS.
> > >
> > > (1) The driver will wait for port enable to complete
> > > (2) Wait for the first discovery stop event
> > > (3) Wait an additional 500ms in case there are additional discoveries
> > > (4) process device list -> reporting devcies to OS
> > 
> > Why is there any need to wait and sort at all?  If you just report the
> > devices as hotplug sees them, boot will be much faster (especially for
> > root devices).
> > 
> 
> IMO, this patch is really needed. Without it you probably will not be
> able to boot after a fresh installation of OS when there are multiple
> drives.

But that's an installer problem, not a kernel one.

>   The issue is Red Hat or SuSE is going to place the new OS on the
> first reported drive, e.g. /dev/sda.  This boot drive information is
> passed from the BIOS to the driver via a configuration page called
> bios page 2.

I think both installers already take this into account: grub finds it
when it builds the mapping table for the first time.

>   The driver needs to wait for all firmware to complete discovery,
> then search for boot device as indicated in the config page, then
> report it first.  Without the patch, there is no guarantee which drive
> or raid volume is getting reported first.  In other words the device
> driver could of reported bios drive located at 0x83 as /dev/sda,
> instead of 0x80, then when you reboot, the BIOS is not finding boot
> partition. The end user can select the boot device by going into the
> BIOS configuration utility; e.g. control C.

But you don't need it to be reported first.  The default install on both
SLES and RHEL (and Fedora and openSUSE) is by label.  So once we get the
boot drive from the mapping, we build its label into the grub config and
fstab files and we always run from it, regardless of the order it
appears in the bootup.

James


