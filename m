From: Matthew Curley <Matthewc@pivot3.com>
Subject: RE: mpt2sas - SG_IO return truncated with cross page buffe
Date: Thu, 3 Mar 2011 11:56:06 -0600
Message-ID: <A94BFDB17DC4E1478F7ACF6EBA3FD8234B3169A3BE@p3saturn.p3corpnet.pivot3.com>
References: <A94BFDB17DC4E1478F7ACF6EBA3FD8234B3169A355@p3saturn.p3corpnet.pivot3.com>
 <4D6FD35C.6030703@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wg.pivot3.com ([74.202.66.30]:9622 "EHLO
	p3saturn.p3corpnet.pivot3.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932295Ab1CCR4c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Mar 2011 12:56:32 -0500
In-Reply-To: <4D6FD35C.6030703@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: "kashyap.desai@lsi.com" <kashyap.desai@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

0x80 was what I initially noticed this with (a script on our product was 
retrieving that info), VPD 0x89 was what I used for debug for exactly 
the reason you noted: it gave me a lot more buffer to play with. 
I initially thought this might be cache-line size related since the 
buffer misalign from sdparm was so small.  It seems to happen with 
any SG_IO inquiry I've done so far though.

Sorry about the line formatting, apparently something from outlook 
isn't handling that right.  I'll try to manually keep lines short,
and I can resend anything unreadable to anyone that cares.

Matthew Curley
-----Original Message-----
From: Douglas Gilbert [mailto:dgilbert@interlog.com] 
Sent: Thursday, March 03, 2011 11:44 AM
To: Matthew Curley
Cc: kashyap.desai@lsi.com; linux-scsi@vger.kernel.org
Subject: Re: mpt2sas - SG_IO return truncated with cross page buffe

On 11-03-03 11:52 AM, Matthew Curley wrote:
> Apologies to Kashyap on the resend, accidentally sent this the first
> time with HTML formatting.
>
> Description:
> If the user space buffer passed to the SG_IO command crosses the 4K 
> page boundary and the return data is greater than the amount of buffer 
> before that page boundary, the command output can be truncated at the 
> end of the first page.  Depending on the kernel version, additional error 
> handling may occur at the driver.
>
> Configuration:
> The platform is a Dell PowerEdge R510 with 2 processors (from 
> /proc/cpuinfo: 'Intel(R) Xeon(R) CPU           E5620  @ 2.40GH')
> Initial discovery environment was a 2.6.32 pvops kernel using sdparm v0.96 
> on mpt2sas 06.00.00, where the SG_IO ioctl was retrieving VPD 0x80 output.  
> The behavior has also been reproduced on Fedora Core 14,  using 2.6.38-rc6 
> with mpt2sas version 07.100.0.   The controller involved is an LSI 2008 
> with Dell Firmware.  Running the test with 2.6.38-rc6, I also get a number 
> of kernel errors starting with an mpt2sas fault state.  That output is 
> shown below, it includes firmware/chip revision/adapter BIOS versions and 
> some information about the storage layout on the adapter.

Matthew,
You mention VPD page 0x80 (unit serial number) and later
page 0x89 (ATA information). Did you mean 0x89 in both cases
as page 0x80 is particularly short?

Doug Gilbert

P.S. Your lines at too long in my email reader.

> Additional info:
> Reproducing required disabling the PCI DMA Remapping support in the kernel.  
> With this setting off the two pages in the command's scatter list were 
> physically discontiguous every time I tried, and the problem occurs.  
> With DMAR enabled the DMA addresses were always contiguous, and the problem 
> behavior wasn't seen.  I'm not sure about the stability/risks of enabling 
> this experimental setting as a 'fix'.
>
> The only other LSI controller I have access to is a 1068--using a different 
> driver stack of course--which does not appear to show the same behavior in 
> limited testing.
>
> Appreciate any help or information.  I have a simple debug utility that 
> issues VPD 0x89 if that's useful, and of course will provide any other 
> needed details.  Please cc-me on replies.
