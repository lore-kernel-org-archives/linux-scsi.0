From: Eyal Ben David <bdeyal@gmail.com>
Subject: SG does not ignore dxferp (direct io + mmap)
Date: Sun, 20 Nov 2016 18:02:49 +0200
Message-ID: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:32940 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752019AbcKTQCu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Nov 2016 11:02:50 -0500
Received: by mail-io0-f181.google.com with SMTP id j65so22155996iof.0
        for <linux-scsi@vger.kernel.org>; Sun, 20 Nov 2016 08:02:50 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

We have some IO utility that perform the IOs using sg and direct io with mmap.
Our current systems are Ubuntu 14.04, RHEL 6,7
The IO utility always set dxferp to either the address or mmap of
other allocation (valloc)
Setting dxferp was harmless since SG is supposed to ignore the address
if mmap IO is selected.
When porting to Ubuntu 16.04, we had a corruption problem - first byte
of a read task is always 0.
When setting dxferp as NULL the corruption does not occur any more.
This is a regression and not according to SCSI generic documentation.

I wrote a small program that shows the change:

Read indirect (no mmap), lba=0:
=======================
$ ./sg_mmap_read -d /dev/sg0 -l 0
0000000 eb 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0

Read with mmap, lba=0, dxferp=NULL:
============================
$ ./sg_mmap_read -d /dev/sg0 -l 0 -m
0000000 eb 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0

Read with mmap, lba=0, dxferp=address from mmap
======================================
$ ./sg_mmap_read -d /dev/sg0 -l 0 -m -b
0000000 00 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0

On the older systems all results are the same.

Thanks for any answer!
