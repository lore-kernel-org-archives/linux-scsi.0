From: Meelis Roos <mroos@ut.ee>
Subject: Re: qlogicpti driver hangs the machine
Date: Wed, 24 Sep 2008 12:51:09 +0300 (EEST)
Message-ID: <Pine.SOC.4.64.0809241240440.5968@math.ut.ee>
References: <20080923.212513.184633012.davem@davemloft.net>
 <20080924044211.GL27204@parisc-linux.org> <20080923.215302.152506074.davem@davemloft.net>
 <20080924.014553.221132445.davem@davemloft.net> <48DA01A6.1010807@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:51413 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYIXJvL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 05:51:11 -0400
In-Reply-To: <48DA01A6.1010807@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: David Miller <davem@davemloft.net>, matthew@wil.cx, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

> Subject: [PATCH] fix fall out of sg-chaining patch
> 
> I've reviewed all patches since Matthew's, and I find one small
> problem.
> 
> In the load_cmd() there is a compound loop where the first 4 sg's are
> set then the rest are set into a memory structure in group of 7 sg's.
> 
> Well the second 7-group and on is a bug because sg pointer does not advance.
> This is a fall out from Jens's patch.
> 
> I'm not sure if this is it but it should be fixed

This definitely helps,
# modprobe qlogicpti
[  271.742828] qlogicpti0: IRQ 12 SCSI ID 7 (Firmware v1.31.32)(FCode 1.21 95/05/18)
[  272.168804] qlogicpti0: [Fast Wide, using single ended interface]
[  272.243809] scsi3 : PTI Qlogic,ISP SBUS SCSI irq 12 regs at 000001c520010000
[  272.835116] scsi 3:0:2:0: Direct-Access     FUJITSU  M2954ESP SUN4.2G 2545 PQ: 0 ANSI: 2
[  272.942031] sd 3:0:2:0: [sdg] 8385121 512-byte hardware sectors (4293 MB)
[  273.026123] sd 3:0:2:0: [sdg] Write Protect is off
[  273.087748] sd 3:0:2:0: [sdg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  273.198290] sd 3:0:2:0: [sdg] 8385121 512-byte hardware sectors (4293 MB)
[  273.282354] sd 3:0:2:0: [sdg] Write Protect is off
[  273.342641] sd 3:0:2:0: [sdg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  273.450154]  sdg: unknown partition table
[  273.511662] sd 3:0:2:0: [sdg] Attached SCSI disk
[  273.566006] sd 3:0:2:0: Attached scsi generic sg7 type 0
[  279.133183] qlogicpti0: Aborting cmd for tgt[2] lun[0]
[  279.193222] qlogicpti0: Aborting cmd for tgt[2] lun[1]
[  279.259841] qlogicpti0: Resetting SCSI bus!

and here it finishes and sdg seems to be working fine. There are two 
strange command aborts followed by a bus reset, but it recovers and 
seems to work (reading whole disc with dd seems to work at least).

Thanks!

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
