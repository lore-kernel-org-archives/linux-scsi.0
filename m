From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: block layer runtime pm and udisks
Date: Thu, 10 Oct 2013 09:52:57 +0800
Message-ID: <52560879.8000001@intel.com>
References: <1364010148-8584-1-git-send-email-aaron.lu@intel.com> <5256058F.3010802@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <5256058F.3010802@ubuntu.com>
Sender: linux-pm-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, Oliver Neukum <oneukum@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 10/10/2013 09:40 AM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> I have been trying out the new block layer runtime pm, and run into a
> problem: udisks keeps waking up the disk.  Every 10 minutes it tries
> to poll the SMART status of the drive, but it does first issue an ata
> CHECK POWER command to see if it is in standby, and skips the check to
> avoid waking the disk.  The problem with runtime pm is that *any*
> request brings the drive out of suspend, and the suspend wake path
> forces the drive to spin up by issuing a verify command on sector 0.
> 
> Is there a reason that the wakeup path forces the drive to spin up, or
> could this be removed and rely on the drive waking up automatically if
> the request requires it?
> 
> Or would it be possible to notice that the command being sent is a
> check power command, and fake the reply instead of resuming the device?
> 
> Or does udisks just need to check the runtime pm status before trying
> the check power command?

I think the udisks can be modified to check if the drive is runtime
suspended and if so, avoid poll the SMART status.

Thanks,
Aaron

> 
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.14 (GNU/Linux)
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iQEcBAEBCgAGBQJSVgWPAAoJEJrBOlT6nu75k/cH+gMAb9YtMS21rEt94umJpBYj
> BcNoyGoK39tAKZHW7pXfP2hRIm1+kPTPi44Wp7kQHu7m6BSp4YetmDkqjNv+6yAy
> 8SUvPcqRsJVbF1oBXN09phBEnk/JfxqID7n6hB1lT6NqYV72VVVUEUOlnSnpHtDJ
> gszV+TLH37uhd5/KiDFja3J2bJC0R/klzDF1x1clc53tGJd1NZ+h9tZZBLszIdnS
> EnjukLA02Q7ooq+445WyWth2cypTXKfRbigZW+FfCI3hfAKOShVevodlGmmrQb7Z
> 0xzhSoO5JTpNqJPLaNL3+JZFdXwANd+7PuO9v2XVKKUkydQ9+Vl4CfydSFhqo5U=
> =iuSZ
> -----END PGP SIGNATURE-----
> 

