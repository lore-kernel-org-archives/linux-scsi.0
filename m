From: Rajat Jain <rajatja@google.com>
Subject: A bad LLD can impact other good LLD(s) if eh_timed_out repeatedly
 returns BLK_EH_RESET_TIMER?
Date: Tue, 2 Jun 2015 14:01:20 -0700
Message-ID: <CACK8Z6EGrSKCc3efUs3mG6PKA4HDi9Tgyo=jRL-bHVhq=Ji1NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33852 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbbFBVBV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2015 17:01:21 -0400
Received: by ieczm2 with SMTP id zm2so142906144iec.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2015 14:01:20 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hello,

I was trying to test some failover and reliability features, and had
instrumented the iscsi low level driver to simulate failures when some
one tries to read the disk. I observed that* iscsi disk is discovered
and sd_probe_async() is called that ultimately tries to read the
partition table using READ10 command. Now due to simulation of
failures, the iscsi LLD never completes the command which results in a
timeout. The iscsi driver provides an eh_timed_out() function, which
is called and decides what can be done about it.

Now, it seems to me that an LLD (that has provided eh_timed_out() func
ptr, such as iscsi) , can impact all the other SCSI disks if it keeps
on returning BLK_EH_RESET_TIMER from its timeout handler.

Specifically, no SCSI disk (even handled by other LLDs) in the system
can be removed. I tried removing multiple disks and pretty soon ended
up with multiple threads deadlocked, because sd_remove() for the "good
disks" is waiting on
async_synchronize_full_domain(&scsi_sd_probe_domain). This never
completes because the sd_probe_async() for the "bad disk" is trying to
read the parition table, and the "bad" LLD keeps on timing out, always
asking for more time (BLK_EH_RESET_TIMER).

My question is have I identified this problem correctly, or if I am
missing something here?

Thanks,

Rajat
