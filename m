From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: block layer runtime pm and udisks
Date: Wed, 09 Oct 2013 21:40:31 -0400
Message-ID: <5256058F.3010802@ubuntu.com>
References: <1364010148-8584-1-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1364010148-8584-1-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>, Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, Oliver Neukum <oneukum@suse.de>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I have been trying out the new block layer runtime pm, and run into a
problem: udisks keeps waking up the disk.  Every 10 minutes it tries
to poll the SMART status of the drive, but it does first issue an ata
CHECK POWER command to see if it is in standby, and skips the check to
avoid waking the disk.  The problem with runtime pm is that *any*
request brings the drive out of suspend, and the suspend wake path
forces the drive to spin up by issuing a verify command on sector 0.

Is there a reason that the wakeup path forces the drive to spin up, or
could this be removed and rely on the drive waking up automatically if
the request requires it?

Or would it be possible to notice that the command being sent is a
check power command, and fake the reply instead of resuming the device?

Or does udisks just need to check the runtime pm status before trying
the check power command?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSVgWPAAoJEJrBOlT6nu75k/cH+gMAb9YtMS21rEt94umJpBYj
BcNoyGoK39tAKZHW7pXfP2hRIm1+kPTPi44Wp7kQHu7m6BSp4YetmDkqjNv+6yAy
8SUvPcqRsJVbF1oBXN09phBEnk/JfxqID7n6hB1lT6NqYV72VVVUEUOlnSnpHtDJ
gszV+TLH37uhd5/KiDFja3J2bJC0R/klzDF1x1clc53tGJd1NZ+h9tZZBLszIdnS
EnjukLA02Q7ooq+445WyWth2cypTXKfRbigZW+FfCI3hfAKOShVevodlGmmrQb7Z
0xzhSoO5JTpNqJPLaNL3+JZFdXwANd+7PuO9v2XVKKUkydQ9+Vl4CfydSFhqo5U=
=iuSZ
-----END PGP SIGNATURE-----
