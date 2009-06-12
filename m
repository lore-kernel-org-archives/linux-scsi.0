From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12727] New: AIC79xx problem on Adaptec 29320A-P controller
Date: Fri, 12 Jun 2009 09:41:55 -0500
Message-ID: <1244817715.4184.10.camel@mulgrave.site>
References: <bug-12727-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55595 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756324AbZFLOlz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2009 10:41:55 -0400
In-Reply-To: <bug-12727-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Tue, 2009-02-17 at 10:09 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12727
> 
>            Summary: AIC79xx problem on Adaptec 29320A-P controller
>            Product: SCSI Drivers
>            Version: 2.5
>      KernelVersion: 2.6.25.20-0.1-default
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>         ReportedBy: j@jensen-net.org
> 
> 
> Latest working kernel version: N/A
> Earliest failing kernel version: 2.6.25.20-0.1-default
> Distribution: OpenSUSE 11.0
> Hardware Environment: Supermicro server
> Software Environment: 
> Problem Description:
> When there is a pause in writing to the tape after that the error occurs.
> 
> Steps to reproduce: tar some data to tape.
> 
> Hardware information and error is below:
> Linux version 2.6.25.20-0.1-default (geeko@buildhost) (gcc version 4.3.1
> 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #1 SMP
> 2008-12-12 20:30:38 +0100
> scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
>         <Adaptec 29320A Ultra320 SCSI adapter>
>         aic7901: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 101-133Mhz, 512 SCBs
>  target0:0:3: asynchronous
> scsi 0:0:3:0: Sequential-Access IBM      ULTRIUM-TD3      7AP5 PQ: 0 ANSI: 3
>  target0:0:3: Beginning Domain Validation
>  target0:0:3: wide asynchronous
>  target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
>  target0:0:3: Ending Domain Validation
> scsi 0:0:3:1: Medium Changer    EXABYTE  MAGNUM 224       C270 PQ: 0 ANSI: 4
> 
> osst :I: Tape driver with OnStream support version 0.99.4
> osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> st: Version 20080221, fixed bufsize 32768, s/g segs 256
> st 0:0:3:0: Attached scsi tape st0
> st 0:0:3:0: st0: try direct i/o: yes (alignment 4 B)
> st0: Block limits 1 - 16777215 bytes.
> 
> scsi0: PCI error Interrupt
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x7f Mode 0x22

Following up on this, we have a Novell bugzilla (partner restricted, I'm
afraid):

https://bugzilla.novell.com/show_bug.cgi?id=509845

The good thing about the novell one is that the partner managed to get a
SCSI analyser on the tape.  The analysis shows that the tape actually
has a firmware bug in that if it sees Information Units of type 0x02
(MULTIPLE COMMANDS) it just stops responding.  It can cope with any
other type of Information Unit, apparently.

We'll be trying to get HP to fix the firmware, but an alternative
solution might simply be to blacklist this device in the SPI transport
class to disable information unit transfers, which should fix your
problem

[Of course, a second problem is how to get the aic79xx driver to behave
nicely handling errors in situations like this, but I'll leave that for
another day.]

James


