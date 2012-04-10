From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: Cannot detect SATA disk's FUA/DPO feature
Date: Tue, 10 Apr 2012 21:15:07 +0200
Message-ID: <4F8486BB.2000701@stud.tu-ilmenau.de>
References: <20120409083412.GA4927@gmail.com>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:47604 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab2DJTPm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Apr 2012 15:15:42 -0400
In-Reply-To: <20120409083412.GA4927@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: linux-scsi@vger.kernel.org

Am 09.04.2012 10:34, schrieb Zheng Liu:
> Hi list,
> 
> Recently I meet a problem in upstream kernel, which the problem is that
> disk driver can not detect FUA/DPO feature of SATA disk.  This machine
> has two SATA disks, one is C400-MTFDDAK256M and another is WDC
> WD1002FAEX-0, both of them are plugged into mainboard.  I read the data
> sheet and both of them support FUA feature.  I am not sure whether this
> is a bug or not in kernel.  Meanwhile, I have tested in SAS disk and
> kernel displays that the disk supports FUA feature in dmesg.
> 
> When we detect FUA feature for SAS disk in kernel, we will use SCSI
> command set to detect FUA feature.  Namely, in current kernel, we use
> FUA bit to check whether this SAS disk supports FUA feature or not.
> However, SATA disk uses ATA command set.  So in current kernel, this
> method doesn't detect whether or not SATA disk supports FUA feature.  Am
> I missing something?
> 
> I put dmesg file in attachment.  Hopefully it is useful.
> 
> Regards,
> Zheng

Hi Zheng,

as far as I read specs, libata should translate FUA stuff as described
in the SAT spec:
--------snip-->
9.17.2 WRITE commands with FUA
This subclause applies to the translation of the WRITE (10) command,
WRITE (12) command, and WRITE (16) command.
If the FUA bit is set to zero in the SCSI write command CDB, then the
SATL shall process this command as described in 9.17.1.
If the FUA bit is set to one in the SCSI write command CDB, then the
SATL shall send the following, in accordance with the constraints
described in 9.1:
a) the following ATA commands:
1) an ATA write command (see 3.1.26) excluding WRITE DMA FUA EXT, WRITE
DMA QUEUED
FUA EXT, WRITE MULTIPLE FUA EXT, and WRITE FPDMA QUEUE; and
2) an ATA verify command (see 3.1.24);
b) one of the following ATA commands (see ATA8-ACS):
A) WRITE DMA FUA EXT;
B) WRITE DMA QUEUED FUA EXT; or
C) WRITE MULTIPLE FUA EXT;
or
c) an ATA WRITE FPDMA QUEUED command (see SATA-2.6) with the FUA bit in
the Device field set to
one.
<--snap-----------

so if the disks supported FUA according to their ATA_IDENTIFY_DEVICE
data, I'd guess someone wanted to care about that part of the SATL in
the near future ;)

Greets,
Stefan
