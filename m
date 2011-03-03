From: Matthew Curley <Matthewc@pivot3.com>
Subject: mpt2sas - SG_IO return truncated with cross page buffe
Date: Thu, 3 Mar 2011 10:52:22 -0600
Message-ID: <A94BFDB17DC4E1478F7ACF6EBA3FD8234B3169A355@p3saturn.p3corpnet.pivot3.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wg.pivot3.com ([74.202.66.30]:8623 "EHLO
	p3saturn.p3corpnet.pivot3.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758381Ab1CCQwu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Mar 2011 11:52:50 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "kashyap.desai@lsi.com" <kashyap.desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Apologies to Kashyap on the resend, accidentally sent this the first time with HTML formatting.

Description:  
If the user space buffer passed to the SG_IO command crosses the 4K page boundary and the return data is greater than the amount of buffer before that page boundary, the command output can be truncated at the end of the first page.  Depending on the kernel version, additional error handling may occur at the driver.

Configuration:
The platform is a Dell PowerEdge R510 with 2 processors (from /proc/cpuinfo: 'Intel(R) Xeon(R) CPU           E5620  @ 2.40GH')
Initial discovery environment was a 2.6.32 pvops kernel using sdparm v0.96 on mpt2sas 06.00.00, where the SG_IO ioctl was retrieving VPD 0x80 output.  The behavior has also been reproduced on Fedora Core 14,  using 2.6.38-rc6 with mpt2sas version 07.100.0.   The controller involved is an LSI 2008 with Dell Firmware.  Running the test with 2.6.38-rc6, I also get a number of kernel errors starting with an mpt2sas fault state.  That output is shown below, it includes firmware/chip revision/adapter BIOS versions and some information about the storage layout on the adapter.

Additional info:
Reproducing required disabling the PCI DMA Remapping support in the kernel.  With this setting off the two pages in the command's scatter list were physically discontiguous every time I tried, and the problem occurs.  With DMAR enabled the DMA addresses were always contiguous, and the problem behavior wasn't seen.  I'm not sure about the stability/risks of enabling this experimental setting as a 'fix'.

The only other LSI controller I have access to is a 1068--using a different driver stack of course--which does not appear to show the same behavior in limited testing.  

Appreciate any help or information.  I have a simple debug utility that issues VPD 0x89 if that's useful, and of course will provide any other needed details.  Please cc-me on replies.

Thanks,
Matthew Curley
-----------------
Fault kernel output on 2.6.38r6:
[  311.130264] mpt2sas0: fault_state(0x2665)!
[  311.130519] mpt2sas0: sending diag reset !!
[  312.322448] mpt2sas0: diag reset: SUCCESS
[  312.391755] mpt2sas0: LSISAS2008: FWVersion(02.15.59.00), ChipRevision(0x02), BiosVersion(07.01.08.00)
[  312.392228] mpt2sas0: Dell PERC H200 Integrated: Vendor(0x1000), Device(0x0072), SSVID(0x1028), SSDID(0x1F1E)
[  312.392706] mpt2sas0: Protocol=(Initiator,Target), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[  312.393769] mpt2sas0: sending port enable !!
[  319.683451] mpt2sas0: port enable: SUCCESS
[  319.683862] mpt2sas0: _scsih_search_responding_sas_devices
[  319.685049] scsi target4:0:1: handle(0x000b), sas_addr(0x500065b36789abe0), enclosure logical id(0x500065b37689abff), slot(13)
[  319.685607] scsi target4:0:2: handle(0x000c), sas_addr(0x500065b36789abe1), enclosure logical id(0x500065b37689abff), slot(12)
[  319.686154] scsi target4:0:3: handle(0x000d), sas_addr(0x500065b36789abe2), enclosure logical id(0x500065b37689abff), slot(0)
[  319.686699] scsi target4:0:4: handle(0x000e), sas_addr(0x500065b36789abe3), enclosure logical id(0x500065b37689abff), slot(4)
[  319.687257] scsi target4:0:5: handle(0x000f), sas_addr(0x500065b36789abe4), enclosure logical id(0x500065b37689abff), slot(5)
[  319.687801] scsi target4:0:0: handle(0x0010), sas_addr(0x500065b36789abe5), enclosure logical id(0x500065b37689abff), slot(1)
[  319.688355] scsi target4:0:6: handle(0x0011), sas_addr(0x500065b36789abe6), enclosure logical id(0x500065b37689abff), slot(2)
[  319.688903] scsi target4:0:7: handle(0x0012), sas_addr(0x500065b36789abe7), enclosure logical id(0x500065b37689abff), slot(3)
[  319.689458] scsi target4:0:8: handle(0x0013), sas_addr(0x500065b36789abe8), enclosure logical id(0x500065b37689abff), slot(10)
[  319.690002] scsi target4:0:9: handle(0x0014), sas_addr(0x500065b36789abe9), enclosure logical id(0x500065b37689abff), slot(11)
[  319.690555] scsi target4:0:10: handle(0x0015), sas_addr(0x500065b36789abea), enclosure logical id(0x500065b37689abff), slot(7)
[  319.691114] scsi target4:0:11: handle(0x0016), sas_addr(0x500065b36789abeb), enclosure logical id(0x500065b37689abff), slot(8)
[  319.691648] scsi target4:0:12: handle(0x0017), sas_addr(0x500065b36789abf0), enclosure logical id(0x500065b37689abff), slot(6)
[  319.692195] scsi target4:0:13: handle(0x0018), sas_addr(0x500065b36789abf1), enclosure logical id(0x500065b37689abff), slot(9)
[  319.692794] mpt2sas0: _scsih_search_responding_raid_devices
[  319.693054] mpt2sas0: _scsih_search_responding_expanders
[  319.693397]  expander present: handle(0x000a), sas_addr(0x500065b36789abff)
[  319.693722] mpt2sas0: _base_fault_reset_work: hard reset: success
[  319.694216] mpt2sas0: removing handle(0x0019), sas_addr(0x500065b36789abfd)
