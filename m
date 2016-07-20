From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: HDD Unrecovered readerror issue
Date: Wed, 20 Jul 2016 12:01:56 +0300
Message-ID: <87twfkn0mz.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33846 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbcGTJCD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2016 05:02:03 -0400
Received: by mail-lf0-f48.google.com with SMTP id l69so33515821lfg.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2016 02:02:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain


Drive:WDC WD1003FZEX-00MK2A0
I have got this in logs:

ata1.00: failed command: READ FPDMA QUEUED
ata1.00: cmd 60/a0:a0:f0:c0:c5/00:00:04:00:00/40 tag 20 ncq 81920 in res 41/40:00:88:c1:c5/00:00:04:00:00/00 Emask 0x409 (media error)
ata1.00: status: { DRDY ERR }
ata1.00: error: { UNC }
ata1.00: configured for UDMA/133
sd 0:0:0:0: [sda] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:0:0: [sda] Sense Key : Medium Error[current] [descriptor]
sd 0:0:0:0: [sda] Add. Sense: Unrecovered readerror - auto reallocate failed
sd 0:0:0:0: [sda] CDB: Read(10) 28 00 04 c5 c0 f0 00 00 a0 00
blk_update_request: I/O error, dev sda, sector 80069000
ata1: EH complete

I can reproduce this easily
#xfs_io -c "pread $((80069000/2))k 4k" -d  /dev/sda
pread64: Input/output error
##Got EIO
##Smartctl also detect this
#smartctl -t short /dev/sda
#smartctl -l selftest /dev/sda
....
Short offline       Completed: read failure       90%      4682 80069000

But once I rewrite this block, problem goes away.
#xfs_io -c "pwrite -S 0x0 $((80069000/2))k 4k" -d  /dev/sda

Now I can read it w/o any errors and smartctl is happy
#smartctl -t short /dev/sda
#smartctl -l selftest /dev/sda
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      4683 -

So my disk is not dead right? Why the hell HDD fail read from very beginning
Is this because HDD firmware detect internal crcXX sum corruption?
How this can happen? Is this because of power failure?
AFAIK standard guarantees that sector will be updated atomically.
But it happens! Please guide me how to fix such problems in general.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJXjz4EAAoJELhyPTmIL6kBnxkH/2CIx9o6tVK6NQjtdJyMF7Sr
8wlBINrbdkSsbwZ2KdN9WYaC464ezKLE4cZQMXeNMMNkErZwD/BMCl7vAWTauSlK
DYz3ADJqfYhf+Z7cqECojg6/1ED2eupHrm76e0I6eNhESC4BA2iukC9peNI6/Pjy
G/cu/5fLpKtLC6Snkqy9gtKYK/imsbc0i6MRw/bXM8zBVvXjXEhvd/fEaVBHYAJ7
/Qfcu3YKCggdpMqIGflZvfifczDY+dEeBDZce35kKPeF6pv+vccqXnV76n+DRRZ6
92QBost7UihcvtuEqommFKJlihqjpCvHu+dOB66b6Lhr6stEFWN0ZZf6EW2O36c=
=pwNH
-----END PGP SIGNATURE-----
--=-=-=--
