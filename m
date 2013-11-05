From: Phillip Susi <psusi@ubuntu.com>
Subject: Disk wakeup on resume
Date: Mon, 04 Nov 2013 21:37:13 -0500
Message-ID: <527859D9.3030607@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:59461 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3KEChP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2013 21:37:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I can not figure out what is waking up disks on resume from suspend.
I thought it was sd.c, and setting manage_start_stop = 0 should stop
that.  It does stop the message printed saying it is being started,
yet the disk is still started, and this makes the resume take nearly
10 seconds.  So it seems sd_resume()'s attempt to start the disk is
pointless and redundant, and something else is starting up the disk.
Oddly, if I unbind the sd driver ( echo 1 >
/sys/block/sdx/device/delete ), then after a resume the disk remains
off ( and spins up again on rescan ).

I don't see why the kernel needs to delay completing the resume until
after the disks have spun up when they will automatically spin up when
accessed, which may be never ( thus they should be left spun down ),
but I can not find the culprit causing this.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSeFnWAAoJEJrBOlT6nu758QwIAJAhlQ5o6qDG9fm98w0j7MY9
OYp/NTd/nO4LGPGaTob/JCyuMDPMtXCOdueLxStlqnBLnPgfANZWD+VSSbsm/uae
pzvjihe6uU+mTCbPW0MNPEiFpH2mfVY8NMhrAEI/n0j9fjgd7E33NI2fedymEDPk
LcgdOtdQP3VSMMs6pjPRpkpVBJG1g3Y6XPLV8IFj8RPz6lUj3k5qj45lsgf//Am8
5vD8SRoZZd7bZghqOCeUU2I/1kntKI5qz4cDUQq6wTVwqAuhLbpjFMOk5lX3gg/h
Q25FGU6Rc8nMyLw4eLbRA8Tvh2aLX5anPkdJqkb132ulbmqP7b8hjUZ4qtNQ/wA=
=JmIT
-----END PGP SIGNATURE-----
