From: Timofey Titovets <nefelim4ag@gmail.com>
Subject: LIO: FILEIO vs IBLOCK read performance
Date: Wed, 1 Feb 2017 11:18:13 +0300
Message-ID: <CAGqmi770AJ1v5188DijUB6oNZvsrRAMca4yeo=mqe1AW_x-Zjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:34809 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbdBAISz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2017 03:18:55 -0500
Received: by mail-lf0-f53.google.com with SMTP id v186so224454863lfa.1
        for <linux-scsi@vger.kernel.org>; Wed, 01 Feb 2017 00:18:55 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi, we want move to iSCSI from NFS storage.
So our data servers have a big ram cache, for utilize it we want use
fileio backend (use file on fs for LUN).

So, question, we did some tests, and have and get strange results with
random read performance.

What we have:
Old dell server in lab 4 cpu, 16GB RAM, 6x2TB SATA HDD (RAID10)
3 backends on storage server:
/dev/sdb
/storage/LUN/1 (reside on fs, on /dev/sdb)
/dev/loop0 -> /storage/LUN/1

For testing on the client side, we use fio:
directio=1, libaio, iodepth=32, bs=4k
Before and after every test we do vm.drop_caches (with results are
more interesting) on both servers.
1 fronend on test server
/dev/sdb

We try do fio with NFS and get ~ 500 iops

so, short results (random read on /dev/sdb on client):
block + /dev/sdb ~ 500 iops (emulate_write_cache=0)
fileio + /dev/sdb ~ 90 iops (emulate_write_cache=0)
fileio + /dev/sdb ~ 90 iops (emulate_write_cache=1)
fileio + /storage/LUN/1 ~90 iops (emulate_write_cache=0)
fileio + /storage/LUN/1 ~90 iops (emulate_write_cache=1)
block + /dev/loop0 ~ 90 iops loop directio=0
block + /dev/loop0 ~ 500 iops loop directio=0

So, if i understand correctly, it's a some problem with buffering
mode, can you give some explain for that?

Thank you for any help.

P.S.
By iostat i see what with target_mod_iblock i have a ~32 queue size to
disk, with target_mod_file, i see ~ 1 queue size to disk.

P.S.S.

Kernel 4.9.6
-- 
Have a nice day,
Timofey.
