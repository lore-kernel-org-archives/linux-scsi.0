From: Martin Geier <linux-scsi@ml.martin.geweb.net>
Subject: SCSI breakage on PowerMac 9500 (oldworld) between 2.6.19.7 and 2.6.20
Date: Wed, 11 Apr 2007 00:12:17 +0200
Message-ID: <20070410221217.GA21776@galaxy.int.geweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bigmac.geweb.net ([217.197.85.170]:2916 "EHLO bigmac.geweb.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030383AbXDJWaH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Apr 2007 18:30:07 -0400
Received: from bigmac.geweb.net (localhost [127.0.0.1])
	by bigmac.geweb.net (smtpd-av) with ESMTP id 703DFD2F1
	for <linux-scsi@vger.kernel.org>; Wed, 11 Apr 2007 00:12:18 +0200 (CEST)
Received: from galaxy.int.geweb.net (galaxy.dmz.int.geweb.net [10.10.10.252])
	by bigmac.geweb.net (smtpd) with ESMTP id 30A09A04
	for <linux-scsi@vger.kernel.org>; Wed, 11 Apr 2007 00:12:18 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

it seems SCSI got broken somewhere on the way from 2.6.19.7 to 2.6.20 o=
n
oldworld Apple PowerMacs 9500 using the internal mesh-controller. The
kernel fails to read the partition table from the drive(s) with the
following messages:
| mesh_host_reset
| mesh: target 0 synchronous at 10.0 MB/s
| sd 0:0:0:0: scsi: Device offlined - not ready after error recovery
| sd 0:0:0:0: rejecting I/O to offline device
| sd 0:0:0:0: rejecting I/O to offline device
| sd 0:0:0:0: rejecting I/O to offline device
| sd 0:0:0:0: rejecting I/O to offline device
| sda : READ CAPACITY failed.
| sda : status=3D0, message=3D00, host=3D1, driver=3D00=20
| sda : sense not available.=20
| sd 0:0:0:0: rejecting I/O to offline device
| sda: Write Protect is off
| sd 0:0:0:0: rejecting I/O to offline device
| sda: asking for cache data failed
| sda: assuming drive cache: write through
| sd 0:0:0:0: Attached scsi disk sda
(...)

mesh.c and mesh.h (in drivers/scsi/) are identical between the two vers=
ions,
so it seems that this is something at a different layer...
Maybe it's connected to http://marc.info/?l=3Dlinux-scsi&m=3D1175964257=
06527&w=3D2
but my test of 2.6.21-rc5 failed similarly to the test of 2.6.20.

You can find kernel-config, full boot-time-output and build-logs at
http://www.geweb.net/tmp/linux-kernel/
README contains the commands used (on a debian r3.1 sarge box) if you'd
like to check the builds (see linux-$VERSION for precise make-calls).

I can test a version between the two mentioned above if you let me know=
 which
one.

Martin

--=20
 /=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=
=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=
=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF\=20
| PGP-Key 0x0F10B493 available via www.de.pgp.net, see header for fpr |
 \___________________________________________________________________/=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
