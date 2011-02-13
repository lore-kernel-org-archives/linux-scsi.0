From: Bart Van Assche <bvanassche@acm.org>
Subject: Storage target performance
Date: Sun, 13 Feb 2011 20:26:16 +0100
Message-ID: <AANLkTikGG-uWFTZbkd_5ZFZ6_crhbKLLc-QwLcEa28x_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56051 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab1BMT0h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2011 14:26:37 -0500
Received: by iyj8 with SMTP id 8so4135958iyj.19
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2011 11:26:37 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi,

Out of curiosity I have been running a few performance tests with the
SCST and TCM versions of the ib_srpt driver and a RAM disk (tmpfs) as
storage target. The results are as follows:

(1) fio --bs=4K --ioengine=psync --buffered=0 --rw=read
24.014 IOPS with the SCST version and 22.028 IOPS with the TCM version
or a difference of about 9%. This confirms that the TCM core needs
more time for processing a single command.

(2) fio --bs=4K --ioengine=libaio --iodepth=16 --buffered=0 --rw=read
--thread --numjobs=2 --gtod_reduce=1 --group_reporting --loops=10
184.000 IOPS with the SCST version and 167.000 IOPS with the TCM
version or a difference of about 10%.

(3) fio --bs=64M --ioengine=psync --buffered=0 --rw=read
1584 MB/s with the SCST version and 1262 MB/s with the TCM version, or
SCST reaching a 25% higher bandwidth (where SCST was using a single
I/O thread).

(4) fio --bs=64M --ioengine=psync --buffered=0 --rw=write
1409 MB/s with the SCST version and 992 MB/s with the TCM version, or
SCST reaching a 42% higher bandwidth (where SCST was using a single
I/O thread).

Notes:
- At least for the SRP protocol the initiator system is the
bottleneck. This means that the ratio of the TCM to SCST processing
overhead in the TCM core is probably larger than the IOPS ratios for
the above tests. Tests have shown that about four initiator systems
are necessary to saturate one system running ib_srpt.
- The above results should be representative for a setup with
low-latency storage (SSD). For a setup where data is stored on a RAID
array, random I/O performance depends a lot on the number of threads
used by the storage target for processing I/O. SCST, TGT and IET all
use multiple threads for processing I/O while TCM has been designed to
use a single I/O thread per target device.
- For the above tests the results did not depend on the number of
threads configured in SCST. This is consistent with what has been
observed for SCST setups with high-end SSDs - optimal IOPS numbers
with a small number of I/O threads (one or two).
- One performance optimization has been applied in the TCM version
that has not yet been applied in the SCST version: embedding the
target command data structure in another structure such that it does
not have to be allocated and deallocated each time a SCSI command is
processed.

Setup details:
- Kernel version: 2.6.38-rc4.
- Default kernel module parameter values were used for ib_srp and
ib_srpt. This means that the ib_srp parameter srp_sg_tablesize had the
value 12 in this test.
- IB hardware: QDR HCA in a PCIe slot.
- CPU model: Intel Core 2 Duo.

Bart.
