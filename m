From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Wed, 27 Nov 2013 20:39:41 -0500
Message-ID: <52969EDD.3050200@ubuntu.com>
References: <527AF287.7020700@ubuntu.com>		 <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>		 <527BDA11.6060603@interlog.com> <527C0349.5010301@ubuntu.com>	 <1384626031.3614.7.camel@dabdike.int.hansenpartnership.com>	 <52883CE9.9040102@ubuntu.com> <1384670620.3614.24.camel@dabdike.int.hansenpartnership.com> <5288EBA6.3070609@ubuntu.com> <5289573A.9070307@interlog.com> <52896806.4040907@ubuntu.com> <528A382E.10400@ubuntu.com> <528CC5C8.6080700@start.ca> <528CCBC3.3030002@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:58477 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3K1Bjn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Nov 2013 20:39:43 -0500
In-Reply-To: <528CCBC3.3030002@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <kernel@start.ca>, dgilbert@interlog.com, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 11/20/2013 09:48 AM, Phillip Susi wrote:
> My original idea was actually to just have the system resume force
> the runtime pm status to suspended, then it will take care of
> calling the runtime resume which can easily start the drive, but I
> was hoping to get it working whether or not runtime pm is
> configured.  I may just have to fall back to that.

So the problem with this is that some drives spin up without being
issued the START UNIT command.  ATA disks without PuiS enabled do, and
the SCSI standards indicate that scsi disks can be configured to do so
as well, though the method for configuring that is not defined in the
standard ( do such things actually exist? ).  This would leave the
drive spun up but the kernel thinking it is runtime suspended, which
isn't good either.

I think the way to deal with this is to throw a work queue item in the
system resume method that issues TEST UNIT READY and if the drive
indicates that it is currently active, then force the runtime pm
status back to active.  According to SAT-3, an ata emulation layer
should issue CHECK POWER MODE and return POWER CONDITION CHANGE TO
STANDBY, but libata does not do this; instead it always returns 0/0/0
for the sense status, so this would need fixed as well.

Does this sound like the right idea?  Also, I don't see any of the
ASQ/ASCQ codes defined in the headers.  Am I missing them or are they
just not there?

Also, I'm a bit unclear on whether you actually have to issue TEST
UNIT READY or can just issue REQUEST SENSE to check the power
condition.  The standards seem to indicate the latter, but I'm not
sure if REQUEST SENSE would return the sense status of the previous
command rather than the power status, so you need the TEST UNIT READY
first.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSlp7ZAAoJEI5FoCIzSKrw5PIH/0wGsyAEr9xR6BkN/C7SOSNh
ArhET3A+Af4Zo1HTe9vKDOIsf9OTrjXxWuLYDBoZSCC0GOw3XPYPdnZ1V4xIBtey
0lMSa8VU9KZMZs8KTYNp6LWToBqChBHSFEd9FLwdWnqLKCp/CtOqgeHO1wOyt1LJ
NkYM4Mpsx6dGO7dzCTZ6Q5ogoXtGcokbGvUXbvuR1idNy1dEdBHaGStaVmIXxImd
u2uJI+1ygk9lMvIa66zJK4f5X6OATd3+SkJlJTsAiEayOEqSAxXNh3QmYJzmJdy/
PDVdgjkgavpKDvbJjNBDSF9skbF9z40EK2NQ9R2kvUMHA8ui66/AQfQHAr04aZI=
=kjuO
-----END PGP SIGNATURE-----
