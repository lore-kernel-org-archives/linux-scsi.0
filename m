From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH/RESEND v2 0/2] SATA disk resume time optimization
Date: Wed, 06 Nov 2013 20:53:11 -0500
Message-ID: <527AF287.7020700@ubuntu.com>
References: <20131017193331.GA11747@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:61657 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab3KGBxO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2013 20:53:14 -0500
In-Reply-To: <20131017193331.GA11747@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: tj@kernel.org, JBottomley@parallels.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 10/17/2013 03:33 PM, Todd E Brandt wrote:
> The essential issue behind hard disks' lengthy resume time is the
> ata port driver blocking until the ATA port hardware is finished
> coming online. So the kernel isn't really doing anything during all
> those seconds that the disks are resuming, it's just blocking until
> the hardware says it's ready to accept commands. Applying this
> patch set

I have been working in a similar direction and have patches to follow.
 Instead of backgrounding the start in sd_resume, I have removed it
entirely, and background the resume at the ata port layer, as well as
avoid resuming Power on in Standby disks entirely.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSevKEAAoJEJrBOlT6nu75FFkIAL8mwXOuuNvY5GoppHVMcweC
EOBz6t2Xmc/TsGYr9u4kRVXbf3G0trSM9dj/XSJ6p+Dj/su/vJ69yKxp7sUPidgz
zqjfKlG+myMQIaAO+tPGXvMcmT74BXjgjobZw2lUyLyRPLD9elDGmrDA5ZXZ+hiz
hzSx4gOC57j+sK/pmoZ7U/CWeWYEYQ+J9xBXm0hzbBbSTjpzVsR0T+7xU+WVkeX0
Ox++FFBZp2b1xJgaREurRv1mORx/GJ+PfSETb49P5BWaWW+QVwOEhWOX/JQNc/Pp
ANJmttP4WPvlRV0X3hD6FvAYSnu1qbwwGOiP/j5g7mklyfm5alA0jcuahc1w5tI=
=9KhA
-----END PGP SIGNATURE-----
