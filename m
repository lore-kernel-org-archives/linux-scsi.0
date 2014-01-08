From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 07 Jan 2014 20:53:16 -0500
Message-ID: <52CCAF8C.7040407@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com> <52CA1191.8060804@ubuntu.com> <52CA5CF4.2080708@codeaurora.org> <52CA744F.2080609@intel.com> <52CAC067.20601@ubuntu.com> <52CBB188.2080707@intel.com> <52CC1422.1020101@ubuntu.com> <52CCA3CF.5050308@intel.com> <52CCA6E3.2090400@ubuntu.com> <52CCAAA7.4070104@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <52CCAAA7.4070104@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/07/2014 08:32 PM, Aaron Lu wrote:
> The ATA and SCSI devices are all resumed in my patches, notice
> there is a single pm_request_resume call in both ATA and SCSI's
> system resume callback, so the runtime status and the disk's state
> is synced. The pm_request_resume call is asynchronous to the system
> resume, so it doesn't block system resume.
> 
> But I see your point, my patch will not achieve that, it can only
> speed up S3 for a typical PC with a traditional disk. I can omit
> the pm_request_resume call in the system resume callback, but then
> if the disk is spun up by itself, then the runtime status indeed
> doesn't reflect the actual state. I suppose for SATA controllers
> that support Staggered Spin-up wouldn't do this?

Ahh, yes, the point of my patches was to avoid waking a disk at all if
possible, and avoid blocking on it otherwise.  Todd Brandt's patches
just backgrounded the resume.

As far as I can tell, the AHCI staggered spinup feature is only a hint
to the libata driver that it should not probe all disks in parallel.
The way to get an ATA disk to not spin itself up is by enabling the
Power on in Standby feature, either through hdparm, or via a jumper,
and it seems WD drives only support the jumper method.  Once enabled,
a drive may chose to automatically spin up when given a command that
requires it to be spinning, or it can opt to require an explicit SET
FEATURES command to spin up.  libata issues an IDENTIFY DEVICE on
resume to find out of the drive requires this command, and issues it
if so.  One of the other patches in my set fixes libata to avoid doing
this in the suspend path, and defer it to the first time a command is
issued.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSzK+MAAoJEI5FoCIzSKrwE5gH/3zpkOR1u+W1/kw3GFLO1YHH
kA2g9VlBMoisiUGLltAuvZYN8zALhWvH3QrTIAvAxq/DjlRQ5ZyBSi3g56swsrHg
ILdx3XW9wuPLSxpWLaiZ/sowTvmrWKSYbyUpxdkDJizCXkg5R3J4LuQ3OpLSSLRh
a6IYMas6l74+xq3wp/eHTE7ofAeoN/jJmT4slUFbzgILMKKEZJQ3wLdjM2uy1d2l
ip3anDOKXHqjrTW4QSkj8piMpR4LBsEpWpMPW9fjYhQe54Hpqv4hwn6vuXEg9SKu
TrwjiH2qb4Ro9twQMUrfF2/r4Ov9swPI1r4EL/bvJ7lJSJ+9c5fRIvObg5Hdaa8=
=woDI
-----END PGP SIGNATURE-----
