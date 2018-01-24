From: Meelis Roos <mroos@linux.ee>
Subject: Re: qla2xxx UBSAN warning in 4.14-rc1
Date: Thu, 25 Jan 2018 00:18:17 +0200 (EET)
Message-ID: <alpine.LRH.2.21.1801250012070.28967@math.ut.ee>
References: <alpine.LRH.2.21.1709181335450.628@math.ut.ee> <1516828413.3987.18.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:53954 "EHLO smtp1.it.da.ut.ee"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932845AbeAXWq5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Jan 2018 17:46:57 -0500
In-Reply-To: <1516828413.3987.18.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>

> > Hello, I decided to widen the coverage of my kernel testbed and put some 
> > FC cards into servers. This one is a PCI-X QLA2340 in HP Proliant DL 380 
> > G4 (first 64-bit generation of Proliants). I got a UBSAN warning from 
> > qla2xxx before probing for the firmware.
> 
> Would it be possible for you to test the (completely untested) patch below?

It compiles without warnings and the driver loads without warnings.

Meanwhile I tried the following patch, also successfully.

However, the same problem is present in qla24xx_mbx_completion (and can 
also be trivially patched over).

I did not understand the logic of what's goind on with mailboxes - there 
seem to be up to 32 of them and for some reason, a bitmask is used for 
iterating over them, with mboxes = ha->mcp->in_mb filtering out some 
mailboxes, and in_mb bitmap value comes from firmware?

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 2fd79129bb2a..7868930ae1c8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -272,7 +272,7 @@ qla2x00_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	/* Read all mbox registers? */
-	mboxes = (1 << ha->mbx_count) - 1;
+	mboxes = (1ULL << ha->mbx_count) - 1;
 	if (!ha->mcp)
 		ql_dbg(ql_dbg_async, vha, 0x5001, "MBX pointer ERROR.\n");
 	else

-- 
Meelis Roos (mroos@linux.ee)
