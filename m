From: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Subject: After memory pressure: can't read from tape anymore
Date: Sun, 28 Nov 2010 20:15:29 +0100
Message-ID: <1290971729.2814.13.camel@larosa>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:42552 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791Ab0K1TWG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Nov 2010 14:22:06 -0500
Received: from [10.0.42.6] (port-92-201-136-71.dynamic.qsc.de [92.201.136.71])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smarthost.TechFak.Uni-Bielefeld.DE (Postfix) with ESMTPSA id 6023AB2
	for <linux-scsi@vger.kernel.org>; Sun, 28 Nov 2010 20:15:30 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi, 

On our backup system (2 LTO4 drives/Tandberg library via LSISAS1068E,
Kernel 2.6.36 with the stock Fusion MPT SAS Host driver 3.04.17 on
debian/squeeze), we see reproducible tape read and write failures after
the system was under memory pressure:

[342567.297152] st0: Can't allocate 2097152 byte tape buffer.
[342569.316099] st0: Can't allocate 2097152 byte tape buffer.
[342570.805164] st0: Can't allocate 2097152 byte tape buffer.
[342571.958331] st0: Can't allocate 2097152 byte tape buffer.
[342572.704264] st0: Can't allocate 2097152 byte tape buffer.
[342873.737130] st: from_buffer offset overflow.

Bacula is spewing this message every time it tries to access the tape
drive:
28-Nov 19:58 sd1.techfak JobId 2857: Error: block.c:1002 Read error on fd=10 at file:blk 0:0 on device "drv2" (/dev/nst0). ERR=Input/output error

By memory pressure, I mean that the KVM processes containing the
postgres-db (~20million files) and the bacula director have used all
available RAM, one of them used ~4GiB of its 12GiB swap for an hour or
so (by selecting a full restore, it seems that the whole directory tree
of the 15mio files backup gets read into memory). After this, I wasn't
able to read from the second tape drive anymore (/dev/st0); whereas the
first tape drive was restoring the data happily (it is currently about
halfway through a 3TiB restore from 5 tapes).

This same behaviour appears when we're doing a few incremental backups;
after a while, it just isn't possible to use the tape drives anymore -
every I/O operation gives an I/O Error, even a simple dd bs=64k
count=10. After a restart, the system behaves correctly until
-seemingly- another memory pressure situation occured.

I'd be delighted if somebody can help me debug this; my systemtap skills
are non-existent unfortunatly.

kind regads,
Lukas Kolbe


