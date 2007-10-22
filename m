From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: LSIFC909 problem
Date: Mon, 22 Oct 2007 10:11:24 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70A87BD8@NAMAIL4.ad.lsil.com>
References: <1192952032.16384.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36375 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbXJVQLl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Oct 2007 12:11:41 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1192952032.16384.11.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: egi <pfammatter-egi@swissonline.ch>, linux-scsi@vger.kernel.org, mdr@sgi.com, "Shirron, Stephen" <Stephen.Shirron@lsi.com>

On Sunday, October 21, 2007 1:34 AM, egi wrote: 
> 
> Since kenel > 2.6.8 my system doesn't regonize any more my FC-drives.
> I installed latest kernel 2.6.23-git7 incl patch but no chance.
> I get the following message during the boot:
> 
> Oct 21 08:57:06 localhost kernel: Fusion MPT base driver 3.04.05
> Oct 21 08:57:06 localhost kernel: Copyright (c) 1999-2007 LSI Logic
> Corporation
> Oct 21 08:57:06 localhost kernel: Fusion MPT FC Host driver 3.04.05
> Oct 21 08:57:06 localhost kernel: mptbase: Initiating ioc0 bringup
> Oct 21 08:57:06 localhost kernel: ioc0: LSIFC909 B1:
> Capabilities={Initiator,LAN}
> Oct 21 08:57:06 localhost kernel: mptbase: ioc0: IOCStatus(0x0022):
> Config Page Invalid Page: type=00h, page=02h, action=00h, 
> form=00000000h
> Oct 21 08:57:06 localhost kernel: mptbase: ioc0: IOCStatus(0x0022):
> Config Page Invalid Page: type=09h, page=00h, action=00h, 
> form=00000000h
> Oct 21 08:57:06 localhost kernel: scsi0 : ioc0: LSIFC909 B1,
> FwRev=01000000h, Ports=1, MaxQ=1023, IRQ=21
> modules:


Sorry for delayed repsonse, but the FC909 is not supported anymore.   I
need to suppy a patch to remove this support.  Here is feedback from
Micheal Reed.  About a two years ago the mptfc was rewrote to support
the fibre channel transport layer.


Micheal Reed wrote:

Looking at the 2.6.5 sles9 driver, I see that the WWNN and WWPN values
are still read from fc device page 0, given a "channel" and "id" as
input.  The "channel" and "id", which I equate to "bus" and "target",
are discovered the old fasioned way, by probing every possible target on
the bus to see which respond.  This is done by a call to
scsi_scan_host().

The new transport code definitely does it differently, by reading fc
device page 0, passing in the port_id of the previous port to retrieve
data for the next port, and registering the discovered targets with the
fc transport.

In the new code, the "sorting" of the targets won't work, which isn't a
showstopper.

The CurrentTargetID and CurrentBus values are taken from fc device page
0 and placed in the VirtTarget structure, so this is the cause for
concern.  This VirtTarget structure is stored in the scsi_target's
hostdata field and is used to map the fc transport's target id to the
firmware's target id.

The 909 doesn't offer the needed functionality to support usage of the
fc transport.

If the firmware accepted commands for a target via its port id instead
of bus/target there might be a way around this, but, that would be a lot
of design effort for not a lot of return, even if it were possible.
