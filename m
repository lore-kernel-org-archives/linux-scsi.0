From: "Fajun Chen" <fajunchen@gmail.com>
Subject: Bugs on Linux 2.6.18-rc2 sg code?
Date: Thu, 10 Aug 2006 19:43:12 -0600
Message-ID: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:12851 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S932369AbWHKBnO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Aug 2006 21:43:14 -0400
Received: by py-out-1112.google.com with SMTP id z74so1070856pyg
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2006 18:43:12 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dgilbert@interlog.com

Hi Folks,

I use ATA pass through via sg ioctl interface for data read/write.
Linux 2.6.18-rc2 patched with Jeff Garzik's libata git patch was
running on ARM IOP80321 board. The HBA Sil3124 was used.

Two problems were observed:
1. sg mmap bug?
    My test program could not write data correctly to the mmapped
buffer in the user space.      The program did a read immediately
after a write and the data mismatches.  Swapped the sg_vma_nopage()
function with the one in 2.6.15.4 release fixed the problem. So this
appears to be a wrong change to the sg mmap code in 2.6.18-rc2
release.

2. sg hangs or have really slow response
   Under certain unknown conditions, sg will be busy with one
read/write ioctl call for over half an hour.  From scsi proc
interface, sg and scsi mid layer were processing requests as  states
"act" or "rcv" was shown in /proc/scsi/sg/debug. My test program set
the command timeout to be 30 seconds, but this timeout did not trigger
the command abort.

Are these problems genuine bugs in sg 2.6.18-rc2 release? Since the
problem is reproducible in my test hardware, please let me know if any
log/traces can be collected.

BTW, scsi logging through proc FS seems to be broken as well even
though SCSI logging and Proc FS are enabled in my 2.6.18-rc2 kernel
config.

Thanks,
Fajun
