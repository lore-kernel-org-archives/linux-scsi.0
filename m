From: Mark Vitnell <kernelml@sinusoid.com>
Subject: sym53c8xx phase errors
Date: Wed, 17 Nov 2004 20:45:02 +1100
Message-ID: <5A516287-387D-11D9-91D3-000393DA18A8@sinusoid.com>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.sinusoid.com ([218.214.7.26]:25472 "EHLO
	alpha.sinusoid.com") by vger.kernel.org with ESMTP id S262255AbUKQJpL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 04:45:11 -0500
Received: from [192.168.100.140] (mac [192.168.100.140])
	by alpha.sinusoid.com (Postfix) with ESMTP id D2ED3D409F
	for <linux-scsi@vger.kernel.org>; Wed, 17 Nov 2004 20:45:11 +1100 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have been having problems with sym53c8xx in recent kernels, with the 
following errors:

...
sym0:5:0:phase change 6-7 11@17168b84 resid=2.
sym0:6:ppr msgout: 1-6-4-a-0-1f-1-0.
sym0:6:0:phase change 6-7 11@1f860f84 resid=2.
sym0:6:ppr msgout: 1-6-4-a-0-1f-1-0.
sym0:6:0:phase change 6-7 11@1f860f84 resid=2.
sym0:4:ppr msgout: 1-6-4-a-0-1f-1-0.
sym0:4:0:phase change 6-7 11@1f860f84 resid=2.
sym1:1:ppr msgout: 1-6-4-a-0-1f-1-0.
sym1:1:0:phase change 6-7 11@016d4384 resid=2.
sym0:5:ppr msgout: 1-6-4-a-0-1f-1-0.
sym0:5:0:phase change 6-7 11@17168b84 resid=2.
sym1:3:ppr msgout: 1-6-4-a-0-1f-1-0.
...

The above a small portion of the kernel logs and occurs on every disc 
access.

This was from 2.6.10-rc2, but I've had similar errors with 2.6.9 and 
various 2.6.10-rc1-mm kernels also.

The hardware in question is a Compaq 64-bit  dual channel wide Ultra2 
SCSI adapter (53c896) and 6x Seagate  SX118202LS/LC  drives in a raid0 
configuration.

Throughput is severely affected, typically getting 5MB/s on the raid 
array, and 2MB/s  on the individual scsi drives. On kernels prior to 
2.6.9 these figures were 100MB/s  and 18MB/s respectively.

I have tried the patch mentioned in 
http://www.spinics.net/lists/kernel/msg314806.html, but it makes no 
difference with either the phase 6-7 messages, or with the ppr 
messages. The throughput remains poor.

Note that the bus appears as :

sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
sym1: No NVRAM, ID 7, Fast-40, LVD, parity checking

and on the earlier kernels , the drives appear as:

   Vendor: SEAGATE   Model: SX118202LS        Rev: B804
   Type:   Direct-Access                      ANSI SCSI revision: 02
sym1:3:0: tagged command queuing enabled, command queue depth 64.
scsi(1:0:3:0): Beginning Domain Validation
sym1:3: wide asynchronous.
sym1:3: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 15)
scsi(1:0:3:0): Domain Validation skipping write tests
scsi(1:0:3:0): Ending Domain Validation
SCSI device sda: 35566480 512-byte hdwr sectors (18210 MB)

Any suggestions would be appreciated,

Mark

