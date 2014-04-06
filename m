From: Meelis Roos <mroos@linux.ee>
Subject: qla2xxx: ql2xextended_error_logging problem
Date: Sun, 6 Apr 2014 09:02:28 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1404060218400.23849@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:57017 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbaDFG0M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Apr 2014 02:26:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Found that 3.13 and 3.14 on sparc64 have excessive dmesg/console spam on 
each IO completion because ql2xextended_error_logging parameter is set 
to 507510784 (QL_DBG_DEFAULT1_MASK). This causes huge slowdown of IO 
because console is serial port connected to Remote System Controller.

The parameter is uninitalized, so I tried to initialize it to zero. Whil 
this probably should be done, it did not help because it is set to 
QL_DBG_DEFAULT1_MASK following a nvram check:

        /*
         * BIT_7 in the host-parameters section allows for modification to
         * internal driver logging.
         */
        if (nv->host_p[0] & BIT_7)
                ql2xextended_error_logging = QL_DBG_DEFAULT1_MASK;

There are 3 QLA2XXX cards in the system - 2 addon 2312 cards, on of them 
having bit 7 set in NVRAM, and one onboard 2200 with invalid NVRAM:

[   82.961412] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.06.00.12-k.
[   83.068247] PCI: Enabling device: (0001:00:01.0), cmd 3
[   83.068323] qla2xxx [0001:00:01.0]-001d: : Found an ISP2312 irq 15 iobase 0x000007fd00100000.
[   83.276577] NVRAM host_p: 82 04
[   83.316876] NOT setting debug from NVRAM
[   83.658354] scsi0 : qla2xxx
[   83.698525] qla2xxx [0001:00:01.0]-00fb:0: QLogic QLA2340 - 133MHz PCI-X to 2Gb FC, Single Channel.
[   83.816693] qla2xxx [0001:00:01.0]-00fc:0: ISP2312: PCI (66 MHz) @ 0001:00:01.0 hdma- host#=0 fw=3.03.28 IPX.
[   83.946424] PCI: Enabling device: (0001:00:02.0), cmd 3
[   83.946501] qla2xxx [0001:00:02.0]-001d: : Found an ISP2312 irq 16 iobase 0x000007fd00102000.
[   84.154438] NVRAM host_p: 02 04
[   84.488355] scsi1 : qla2xxx
[   84.526991] qla2xxx [0001:00:02.0]-00fb:1: QLogic QLA2340 - 133MHz PCI-X to 2Gb FC, Single Channel.
[   84.645162] qla2xxx [0001:00:02.0]-00fc:1: ISP2312: PCI (66 MHz) @ 0001:00:02.0 hdma- host#=1 fw=3.03.28 IPX.
[   84.775038] PCI: Enabling device: (0003:00:02.0), cmd 3
[   84.775176] qla2xxx [0003:00:02.0]-001d: : Found an ISP2200 irq 38 iobase 0x000007fb00400000.
[   84.887522] qla2xxx [0003:00:02.0]-0050:2: No matching ROM signature.
[   85.066473] qla2xxx [0003:00:02.0]-0064:2: Inconsistent NVRAM detected: checksum=0x0 id=\xffffffff version=0xff.
[   85.189236] qla2xxx [0003:00:02.0]-0065:2: Falling back to functioning (yet invalid -- WWPN) defaults.
[   85.310960] NVRAM: using default host_p 00 04
[   85.367267] NVRAM host_p: 00 04
[   85.407590] qla2xxx [0003:00:02.0]-0069:2: NVRAM configuration failed.
[   98.968381] scsi2 : qla2xxx
[   99.007137] qla2xxx [0003:00:02.0]-00fb:2: QLogic QLA22xx - .
[   99.081843] qla2xxx [0003:00:02.0]-00fc:2: ISP2200: PCI (66 MHz) @ 0003:00:02.0 hdma- host#=2 fw=2.02.08 TP.

Seeing bit 7 of nvram host_p in one of the cards would normally mark the 
whole driver to be very verbose with all qla2xxx cards. This is so 
verbose that it considerably slows down IO. Currently I have commented 
out the setting of ql2xextended_error_logging on BIT7 (NOT setting ... 
in dmesg) and it is a workaround for me so far.

It seems we can not afford to default to so much debug info for this 
nvram bit - at least IO completions should be filtered out.

Is there a way to change the nvram from the driver?

-- 
Meelis Roos (mroos@linux.ee)
