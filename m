From: Douglas Gilbert <dgilbert@interlog.com>
Subject: mpt2sas,mpt3sas: SATA affiliations
Date: Wed, 12 Nov 2014 14:59:11 -0500
Message-ID: <5463BC0F.4050605@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44697 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbaKLT7W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2014 14:59:22 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id 85B38204295
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2014 20:59:19 +0100 (CET)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vKwoejDHs3Q4 for <linux-scsi@vger.kernel.org>;
	Wed, 12 Nov 2014 20:59:17 +0100 (CET)
Received: from [192.168.48.86] (host-23-91-188-34.dyn.295.ca [23.91.188.34])
	by smtp.infotech.no (Postfix) with ESMTPA id 8DA0D204293
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2014 20:59:17 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

 From a correspondent and my own testing I have seen way
too many of these messages in the log:
    log_info(0x31160000): originator(PL), code(0x16), sub_code(0x0000)

That comes from either the mpt2sas or mpt3sas driver and may be
a problem with their interaction with the SCSI EH. In one case,
those messages go on forever, requiring a reboot; in my testing
(with sg_readcap) the command timeout (60 seconds) stopped them.


How they occur needs a bit of explaining: ATA disks are designed
to have only only initiator (host). So if you build a SAS fabric
including at least two initiators, an expander and one SATA disk,
then there is potentially a problem which SAS expanders address
with "affiliations". An affiliation is a mechanism for the
expander to remember the SAS address of the initiator (host)
that first "grabbed" the SATA disk, and rejecting any other
initiator that tries to access that SATA disk.

That rejection, in the link layer in SAS for the STP protocol,
is a OPEN_REJECT (STP RESOURCES BUSY) response. That is *not*
a retry-able error (so the use of "busy" is unfortunate).
FreeBSD handles this correctly, Linux in some cases retries
which results in chaos plus bloated logs.

There are mechanisms for the owner of the affiliation to clear
it so another initiator can claim it. However affiliations are
designed to thwart brute force attempts by non-owners. At best
non-owners should get one log message along the lines of:
   cannot access SATA disk xxxx since another machine/HBA is
   affiliated with it

Linux properly handles SATA affiliations when it comes across
them in normal device discovery. It is the "surprise"
disappearance of an affiliation that causes instability. That
surprise is caused by a utility like smp_phy_control telling
the expander to clear the affiliation and doing a rescan on
the other machine to claim the affiliation.

Doug Gilbert


