From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Sun, 17 Nov 2013 20:06:14 -0500
Message-ID: <52896806.4040907@ubuntu.com>
References: <527AF287.7020700@ubuntu.com>		 <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>		 <527BDA11.6060603@interlog.com> <527C0349.5010301@ubuntu.com>	 <1384626031.3614.7.camel@dabdike.int.hansenpartnership.com>	 <52883CE9.9040102@ubuntu.com> <1384670620.3614.24.camel@dabdike.int.hansenpartnership.com> <5288EBA6.3070609@ubuntu.com> <5289573A.9070307@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <5289573A.9070307@interlog.com>
Sender: linux-ide-owner@vger.kernel.org
To: dgilbert@interlog.com, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 11/17/2013 06:54 PM, Douglas Gilbert wrote:
> Even if the SCSI EH code does spin-up the disk, it is inefficient
> and undesirable to send a device into EH for what is a normal,
> predictable situation (i.e. that a SCSI disk will need a START STOP
> UNIT (start) command as part of a resume operation).

The device doesn't need the START STOP UNIT command as part of the
resume operation; it only needs it prior to other commands.  What is
inefficient is starting up drives that won't be accessed.  I don't see
anything particularly inefficient about issuing the command in the eh
path ( in fact, libata always uses the eh path to handle power
management ).  You can of course, use the manage_start_stop flag to
have the disk start on resume if you really want.

> A big server machine could have thousands of SCSI disks (many
> potentially virtual). Sending them all into EH during a resume
> would be a really good test for EH, but horrible for performance.
> If I was designing the SCSI EH I would probably assume not all
> disks would go into EH at roughly the same time. Also if that many
> devices went into EH on the same controller (HBA) it might be
> reasonable to assume that the controller they share needs
> resetting.

They don't all go into EH during resume; they go into EH when they are
finally accessed, which for many of them is probably not for some
time.  This also sounds like a bit of speculation and/or hand waving.
 Is there really a problem with multiple devices going into EH?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSiWgGAAoJEJrBOlT6nu75klwIAK29G/p+pZhccbfXBnIpvq8m
oIuCOCgMjIbSkJDEo52BiEf6d52tK8aQNTXcHZCC7T2/yvWV55vGHeXbxZ9iospp
IsoJOMLtcM9p5DHZido5RubXrq63cU3yGovGbsp834Ij+d51HB17Dh4Dc1iU/mQV
4X6623hH0ooHWjmtoK6l5rGfKxkPe2ZKP3RAOpW5hiFaGPFWpc375Kukf6Zvw161
mBRfdWtc1SRGme/dcEEggH5t20R0kJteAey4RLF77W8VcooVbE3zCESpVNwqHxYK
6Mc67avVzMyk+Cmb2IN9iMB05oPDIzhKU4kStyYKVGqiS1D2NHUUi56GZTN5Ry0=
=kmdB
-----END PGP SIGNATURE-----
