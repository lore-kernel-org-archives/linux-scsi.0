From: Denys Fedoryschenko <denys@visp.net.lb>
Subject: MPT Fusion SAS 2.6.31 regression, crash on heavy load
Date: Tue, 29 Sep 2009 22:25:09 +0300
Message-ID: <200909292225.09188.denys@visp.net.lb>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hosting.visp.net.lb ([194.146.153.11]:60427 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbZI2TZh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2009 15:25:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

Filled a bugzilla entry, no answer for 3 days, and at same time it is clear 
regression.
http://bugzilla.kernel.org/show_bug.cgi?id=14242

While on 2.6.30.5 MPT SAS controller worked fine, on 2.6.31 it fails on heavy
operations and start spitting errors to dmesg (they vary). Failsystems also
stopped, and i am unable to reboot box properly (only over sysrq or 
hardreset). 

x86, Sun Fire X4100, 8 GB RAM, PAE kernel enabled, module loaded with default
options

I upgrade BIOS, LSI controller BIOS to latest version, it didn't fix the bug.
I cannot do bisection, because this is loaded server and semi-embedded system.
But i can do tests of patches or reverse specific commits, if you point me to
exact commit.

http://www.nuclearcat.com/files/dmesg.ok from 2.6.30.5 kernel
http://www.nuclearcat.com/files/dmesg.fail from 2.6.31.1 kernel
http://www.nuclearcat.com/files/config.gz config from 2.6.31.1 kernel

Let me know if you need any additional information.

Additionally - i have few other similar units (X4100), but with less amount of 
RAM (4GB),HDD's(2 only), less load (but still enough heavy at some moments) 
working ok. I dont think it is hardware issue, since it works on 2.6.30 very 
stable, and worked on other (older) kernels for 1 year and more. It is clear 
regression and i guess dangerous regression (causing data loss on high 
loads). I will try to bisect some changes on mpt driver today. 

Please CC me on answers, i am not subscribed at any SCSI/LSI list.

Crossposting to linux-kernel, since there is no mails about issue from 
linux-scsi.

Here is some technical info about controller over lsiutil
Current active firmware version is 01102800 (1.16.40)
Firmware image's version is MPTFW-01.16.40.00-IE
  LSI Logic
x86 BIOS image's version is MPTBIOS-6.14.04.00 (2007.02.27)

SAS1064's links are 3.0 G, 3.0 G, 3.0 G, 3.0 G

 B___T     SASAddress     PhyNum  Handle  Parent  Type
        50003ba0000003ba           0001           SAS Initiator
        50003ba0000003bb           0002           SAS Initiator
        50003ba0000003bc           0003           SAS Initiator
        50003ba0000003bd           0004           SAS Initiator
 0   0  500000e01277abd2     0     0005    0001   SAS Target
 0   1  500000e011e3b602     1     0006    0001   SAS Target
 0   2  500000e012779792     2     0007    0001   SAS Target
 0   3  500000e0120efb42     3     0008    0001   SAS Target

Type      NumPhys    PhyNum  Handle     PhyNum  Handle  Port  Speed
Adapter      4          0     0001  -->    0     0005     0    3.0
                        1     0001  -->    0     0006     1    3.0
                        2     0001  -->    0     0007     2    3.0
                        3     0001  -->    0     0008     3    3.0

Enclosure Handle   Slots       SASAddress       B___T (SEP)
           0001      4      50003ba0000003ba
