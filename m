From: "Chen, Justin" <justin.chen@hp.com>
Subject: Endless loop in mptspi init
Date: Thu, 26 Oct 2006 17:24:45 -0500
Message-ID: <BD66F1A3AD5256419EBBAAA492578482A1A3D0@G3W0068.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:63121 "EHLO
	ccerelbas04.cce.hp.com") by vger.kernel.org with ESMTP
	id S1161446AbWJZWYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2006 18:24:46 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: eric.moore@lsil.com
Cc: mpt_linux_developer@lsil.com, linux-scsi@vger.kernel.org, "Helgaas, Bjorn" <bjorn.helgaas@hp.com>

Eirc,

We experienced an endless looping on mptspi init due to some drive f/w
or cabling issue on an IA64 system.  The mptspi driver kept initiating
the device (see below for part of the log) and never stopped.  I noticed
that the patch
(http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=
commit;h=6e1cad02763edec83dba8559d4be8d518a6562a5) caused the problem.
If we don't do the mptspi_dv_renegotiate(hd), the driver initialized the
device once and system boots fine.

I think regardless of what, the mptspi driver shouldn't do an endless
loop to stuck the system.  Please comment.

Thanks,

Justin Chen

--------------------------------------------------------------
 target12:0:0: Beginning Domain Validation
mptscsih: ioc3: attempting task abort! (sc=e0000040fcdee680)
sd 12:0:0:0: 
        command: Inquiry: 12 00 00 00 60 00
mptbase: Initiating ioc3 recovery
mptscsih: ioc3: task abort: SUCCESS (sc=e0000040fcdee680)
 target12:0:0: Domain Validation detected failure, dropping back
 target12:0:0: Domain Validation skipping write tests
 target12:0:0: Ending Domain Validation
 target12:0:0: asynchronous
 target12:0:1: Beginning Domain Validation
 target12:0:1: Ending Domain Validation
 target12:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target12:0:2: Beginning Domain Validation
 target12:0:2: Ending Domain Validation
 target12:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
 target12:0:3: Beginning Domain Validation
mptscsih: ioc3: attempting task abort! (sc=e0000040fcdee680)
sd 12:0:3:0: 
        command: Inquiry: 12 00 00 00 60 00
mptbase: Initiating ioc3 recovery
mptscsih: ioc3: task abort: SUCCESS (sc=e0000040fcdee680)
 target12:0:3: Domain Validation detected failure, dropping back
 target12:0:3: Domain Validation skipping write tests
 target12:0:3: Ending Domain Validation
 target12:0:3: asynchronous
 target12:0:4: Beginning Domain Validation
mptscsih: ioc3: attempting task abort! (sc=e0000040fcdee680)
sd 12:0:4:0: 
        command: Inquiry: 12 00 00 00 90 00
mptbase: Initiating ioc3 recovery
mptscsih: ioc3: task abort: SUCCESS (sc=e0000040fcdee680)
 target12:0:4: Domain Validation detected failure, dropping back
 target12:0:4: Domain Validation skipping write tests
 target12:0:4: Ending Domain Validation
 target12:0:4: asynchronous
 target12:0:15: Beginning Domain Validation
 target12:0:15: Domain Validation skipping write tests
 target12:0:15: Ending Domain Validation
 target12:0:15: wide asynchronous
 target12:0:0: Beginning Domain Validation
mptscsih: ioc3: attempting task abort! (sc=e0000040fcdee680)
sd 12:0:0:0: 
        command: Inquiry: 12 00 00 00 60 00
mptbase: Initiating ioc3 recovery
mptscsih: ioc3: task abort: SUCCESS (sc=e0000040fcdee680)
 target12:0:0: Domain Validation detected failure, dropping back
 target12:0:0: Domain Validation skipping write tests
 target12:0:0: Ending Domain Validation
 target12:0:0: asynchronous
 target12:0:1: Beginning Domain Validation
 target12:0:1: Ending Domain Validation
 target12:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target12:0:2: Beginning Domain Validation
 target12:0:2: Ending Domain Validation
 target12:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
 target12:0:3: Beginning Domain Validation
mptscsih: ioc3: attempting task abort! (sc=e0000040fcdee680)
sd 12:0:3:0: 
        command: Inquiry: 12 00 00 00 60 00
mptbase: Initiating ioc3 recovery
mptscsih: ioc3: task abort: SUCCESS (sc=e0000040fcdee680)
 target12:0:3: Domain Validation detected failure, dropping back
 target12:0:3: Domain Validation skipping write tests
 target12:0:3: Ending Domain Validation
 target12:0:3: asynchronous
 target12:0:4: Beginning Domain Validation
mptscsih: ioc3: attempting task abort! (sc=e0000040fcdee680)
sd 12:0:4:0: 
        command: Inquiry: 12 00 00 00 90 00
mptbase: Initiating ioc3 recovery
mptscsih: ioc3: task abort: SUCCESS (sc=e0000040fcdee680)
 target12:0:4: Domain Validation detected failure, dropping back
 target12:0:4: Domain Validation skipping write tests
 target12:0:4: Ending Domain Validation
 target12:0:4: asynchronous
 target12:0:15: Beginning Domain Validation
 target12:0:15: Domain Validation skipping write tests
 target12:0:15: Ending Domain Validation
 target12:0:15: wide asynchronous
 target12:0:0: Beginning Domain Validation
