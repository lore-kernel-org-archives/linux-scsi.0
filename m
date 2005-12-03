From: Jan =?ISO-8859-1?Q?L=FCbbe?= <jluebbe@lasnet.de>
Subject: libata problems with Promise SATA 300 TX4
Date: Sun, 04 Dec 2005 00:03:04 +0100
Message-ID: <1133650986.5857.17.camel@mordor>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sirius.lasnet.de ([62.75.240.18]:45488 "EHLO sirius.lasnet.de")
	by vger.kernel.org with ESMTP id S1751301AbVLCW4B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Dec 2005 17:56:01 -0500
Received: from d072.apm.etc.tu-bs.de ([134.169.175.72] helo=mordor)
	by sirius.lasnet.de with esmtpsa
	(Cipher TLS-1.0:RSA_ARCFOUR_MD5:16) (Exim 4.50 #1)
	id 1EigIT-0000KC-NK by authid <jluebbe@lasnet.de> with cram_md5
	for <linux-scsi@vger.kernel.org>; Sat, 03 Dec 2005 23:56:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

I'm not sure if this is the correct list, as my problem is about sata
and not SCSI...

We run a debian push mirror (debian.tu-bs.de) and have recently switche=
d
from a scsi hardware raid to a SATA linux software raid. 3 Maxtor
Maxline III are attached to a Promise SATA 300 TX4. It worked well for
about one month while we were testing it with low load parallel to the
SCSI raid and it worked flawlessly. One week ago, we move all our data
over to the software raid.

Since about 4 days we get scsi errors about once per day. libata report=
s
an error about every 30 seconds and after about one hour, the disk is
dropped from the array. It continues in degraded mode without further
problems until another disk shows errors.

After rebooting the server, all disks are accessible again and i can
perform a resync (which completes without errors). Then sata works
without problems until the same errors appear again.

This happens with a 2.6.13.4, today we tried 2.6.14.3, but it froze
completely after 22 hours. So we only have logs when the error happend
with 2.6.13.4 :(

This shows up in the logs:

Dec  2 17:01:05 apmsrv01 kernel: ata2: command timeout
Dec  2 17:01:05 apmsrv01 kernel: ATA: abnormal status 0xFF on port 0xF8=
81229C
Dec  2 17:01:05 apmsrv01 kernel: ata2: status=3D0xff { Busy }
Dec  2 17:01:05 apmsrv01 kernel: SCSI error : <2 0 0 0> return code =3D=
 0x8000002
Dec  2 17:01:05 apmsrv01 kernel: sdd: Current: sense key: Aborted Comma=
nd
Dec  2 17:01:05 apmsrv01 kernel:     Additional sense: Scsi parity erro=
r
Dec  2 17:01:05 apmsrv01 kernel: end_request: I/O error, dev sdd, secto=
r 57303239

The sector differs each time, but the rest is always the same.

What could cause this error? Which information should i try to gather?

Thanks,
--=20
Jan L=C3=BCbbe <jluebbe@lasnet.de>            http://sicherheitsschwank=
ung.de
 gpg-key      1024D/D8480F2E 2002-03-20
 fingerprint  1B25 F91F 9E7B 5D4F 1282  02D6 8A83 8BE4 D848 0F2E

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
