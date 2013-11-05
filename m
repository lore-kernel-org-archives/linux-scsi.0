From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk wakeup on resume
Date: Tue, 05 Nov 2013 11:23:33 -0500
Message-ID: <52791B85.1090805@ubuntu.com>
References: <527859D9.3030607@ubuntu.com> <52791518.5070705@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:50410 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab3KEQXf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2013 11:23:35 -0500
In-Reply-To: <52791518.5070705@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/5/2013 10:56 AM, Douglas Gilbert wrote:
> I think that you might find that almost any SCSI command
> (translated to its ATA equivalent command) will wake up a SATA
> disk. Perhaps just this sequence: fd = open(<ata_bloc_device>) ;
> close(fd) ; is sufficient.

No, otherwise hdparm, udisks, etc would not be able to issue the CHECK
POWER command without waking the disk.  Most commands do wake the
drive, but as far as I can see, nobody is sending down any, and more
importantly, the wake is happening within the kernel pm resume path,
not by userspace after resume.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSeRuFAAoJEJrBOlT6nu75zOcH/1eKDZW73qiWN5x1mHnkZCx2
+khrRybBM+d6iwsfKODdMPkfXe89QxNxZArPMP60OtCTzfnUuzpK9SfNuzB2CB3p
zKX1H5tOQEowUd9A2DpzJmN89UGi/+ZVDEQBlo6byqXKhd/Gj10TuD8vyaHSSadN
XYYvWIlreayELaI70uQLdntfHufProdoZQ+kB9pQhvvq8IhtcuARjUeaGbnHxznc
UT2SvYeGritndPLzBOAeWw6/WZ/Rvzo5Q9s2nZAWyWnNlrdt95cmLl+56vCP2AJW
b4Tf4TrPGbhB0EPFU+vWy6mT4DFReqDbkMvgsWoOrFF8OPgrUx3l+9gWifejLw8=
=77FK
-----END PGP SIGNATURE-----
