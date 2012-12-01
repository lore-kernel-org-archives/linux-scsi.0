From: Hiroyuki Yamada <mogwaing@gmail.com>
Subject: one 16K random read I/O issues 2 scsi I/O (16K and 4K) requests
Date: Sat, 1 Dec 2012 18:44:42 +0900
Message-ID: <CAPDOW76Mp8FKDv3oEo=rKZpXf2+uwG0kB5ejCusnrkY4Euq_NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56850 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2LAJom (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Dec 2012 04:44:42 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so441089vcd.19
        for <linux-scsi@vger.kernel.org>; Sat, 01 Dec 2012 01:44:42 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I noticed weird issue when benchmarking random read I/O for files in
linux (2.6.18-274).
The Benchmarking program is my own program and it simply keeps reading
16KB of a file from a random offset.

I traced I/O behavior at system call level and scsi level with systemtap and
I noticed that one 16KB pread issues 2 scsi I/Os as following.

=============================================
SYSPREAD random(8472) 3, 0x16fc5200, 16384, 128137183232
SCSI random(8472) 0 1 0 0 start-sector: 226321183 size: 4096 bufflen
4096 FROM_DEVICE 1354354008068009
SCSI random(8472) 0 1 0 0 start-sector: 226323431 size: 16384 bufflen
16384 FROM_DEVICE 1354354008075927
SYSPREAD random(8472) 3, 0x16fc5200, 16384, 21807710208
SCSI random(8472) 0 1 0 0 start-sector: 1889888935 size: 4096 bufflen
4096 FROM_DEVICE 1354354008085128
SCSI random(8472) 0 1 0 0 start-sector: 1889891823 size: 16384 bufflen
16384 FROM_DEVICE 1354354008097161
SYSPREAD random(8472) 3, 0x16fc5200, 16384, 139365318656
SCSI random(8472) 0 1 0 0 start-sector: 254092663 size: 4096 bufflen
4096 FROM_DEVICE 1354354008100633
SCSI random(8472) 0 1 0 0 start-sector: 254094879 size: 16384 bufflen
16384 FROM_DEVICE 1354354008111723
SYSPREAD random(8472) 3, 0x16fc5200, 16384, 60304424960
SCSI random(8472) 0 1 0 0 start-sector: 58119807 size: 4096 bufflen
4096 FROM_DEVICE 1354354008120469
SCSI random(8472) 0 1 0 0 start-sector: 58125415 size: 16384 bufflen
16384 FROM_DEVICE 1354354008126343
=============================================


As shown above, one 16KB pread issues 2 scsi I/Os. (I traced scsi io
dispatching with probe scsi.iodispatching)

One scsi I/O is 16KB I/O as requested from the application and it's OK.
The thing is the other 4KB I/O which I don't know why linux issues that I/O.

Of course, I/O performance is degraded by the weired 4KB I/O and I am
having trouble.
I also use fio (famous I/O benchmark tool) and noticed the same issue,
so it's not from the application.
Does anybody know what is going on ?
Any comments or advices are appreciated.

Thanks
