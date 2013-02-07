From: "Mahesh Rajashekhara" <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: Linux Libsas/Libata updates/releases
Date: Wed, 6 Feb 2013 22:18:37 -0800
Message-ID: <340C71CD25A7EB49BFA81AE8C83926671B282939@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:54299 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759Ab3BGGSk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Feb 2013 01:18:40 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Tony Ruiz <Tony.Ruiz@pmcs.com>

** Resending in TEXT/PLAIN, earlier sent email bounce back **

Adding linux-scsi group to this email...

I would like to check with you if anyone had encountered similar issues
with upper layers older libsas/libata drivers. It would be of great help
if anyone can shed some light on this issue.  

Please advise!

Sincerely,
Mahesh

From: Tony Ruiz 
Sent: Tuesday, February 05, 2013 6:15 AM
To: 'James Bottomley'
Cc: Mahesh Rajashekhara
Subject: Linux Libsas/Libata updates/releases


Hi James,

I am the manager for the PMC-Sierra driver team working on the arcsas
and pmc8001 drivers.   

We are in the Beta testing phase of the pmc8001 Linux driver with newer
ASIC support.  When we use the updated libsas/libata libraries like
those in RHEL 6.3 or SuSe SP3 Beta, medium error handling works fine.
When we use kernels with older libsas/libata libraries with medium error
(details below) the system crashes.   We worked with SuSe and they
provided the updated libraries which work well and asked us to opened a
bug with SLES to make sure they include the latest into their kernel:
"798738 - SLES 11 SP2 does not contain several libsas/libata backport
commits for handling ATA errors."

My question is:
-	Is there a recommend way to release our driver with these
updated libraries?
-	If there are none, is there an easy solution for customers' to
update only these components instead of the entire kernel?

Thanks in advanced.

Tony Ruiz
Manager of Host Software
PMC-Sierra, Inc.

====================================================

Details of the issue:
1.	If a target/drive has medium error and IO has been aborted,
during this phase LibATA has some issues in this Error Handling Path and
system eventually crashes.
a.	This is very consistent with SUSE11SP2 (3.0.13) Kernel, but the
private branch of SLES11SP3 (3.0.57) which is still in BETA has all the
LibATA Error Handling back ported, this resolved all these error
handling issues.
b.	This very same issue with Debian 6.0.3 till 6.0.6
c.	With RHEL6.3 everything is working fine, since the Libsas/LibATA
changes are back-ported from 3.4 kernels to their RHEL6.3 Kernel
(2.6.32-279).
Sequence:
-	Medium Error Reported by drive for an IO either Read/Write_FPDMA
(NCQ Command) 
-	Firmware Raise NCQ Event 
-	Holds the IO expects RLE and puts the drive into Error State
-	Internally driver is issuing RLE because we don't have the IO
Context 
-	FW/Drive processes RLE 
-	Driver Receives RLE Response
-	Issues Abort ALL (as per SATA Spec)
-	FW releases all IO's by completing as IO Aborted
-	Driver Completes these to Midlayer

In the Successful case the sequence follows:
-	Receives RLE, but driver is faking it now
-	then receives Hard-Resetting Link
-	Domain Revalidation
-	Rediscover
-	IO's Successfully restarted.

In the Failure case the sequence follows:
-	System hangs
