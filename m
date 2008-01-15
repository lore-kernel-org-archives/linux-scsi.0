From: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Subject: [RFC] A SCSI fault injection framework using SystemTap.
Date: Tue, 15 Jan 2008 12:04:09 +0900
Message-ID: <478C22A9.5000009@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:35723 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbYAODBb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 22:01:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com


I would like to introduce a SCSI fault injection framework using SystemTap.

Currently, kernel has Fault-injection framework and Faulty mode for md,
which can also be used for testing the error handling. But, they could
only produce fixed type of errors stochastically. In order to simulate
more realistic scsi disk faults, I have created a  new flexible fault injection
framework using SystemTap.

The new fault injection framework has the following features:

 1) The new framework is flexible, easy to change the condition without changing
    the kernel because actually they are SystemTap scripts.
    For example, device faults resulting in scsi command timeout, and media
    faults which could be corrected by writing data to the failed sector
    could be simulated using this framework.

 2) The new framework generates "pseudo" faults in the SCSI mid-layer.
    Any upper layer app/driver using the SCSI mid-layer can apply this framework.

 3) The new framework rewrite the status code and sense data for SCSI command and
    pass it to the upper layer. So the real error handling routine of the upper
    layer for I/O request can be tested.

I have tested the software RAID (md/dm-mirror) using this framework
and found some bugs.
 e.g.
  -The kernel thread for md RAID1 could cause a deadlock when the error handler for
    md RAID1 contends with the write access to the md RAID1 array.

  -dm-mirror's redundancy doesn't work. A read error from the disk consisting
   the array will be directory passed to the userspace, without reading from
   the other mirror.
   (It turns out that this issue is a known issue, but the patch is not merged.
    http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-raid1-handle-read-failures.patch)

There are also some other bugs for error handling routine in the multiple
fault situation. I will report the details about these bugs later.

The new framework is tested on Fedora8(i386) running with kernel 2.6.23.12.
So far, I'm cleaning up the tool set for release, and plan to post it in the near future.
If you are interested, take a look at it.
If you have any comments, please let me know.

-- 
------------------------------------------------------------------------
Kenichi TANAKA    | Open Source Software Platform Development Division
                  | Computers Software Operations Unit, NEC Corporation
                  | k-tanaka@ce.jp.nec.com


