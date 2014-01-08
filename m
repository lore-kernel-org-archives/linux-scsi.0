From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Wed, 08 Jan 2014 00:24:42 -0500
Message-ID: <52CCE11A.3040609@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com> <52CA1191.8060804@ubuntu.com> <52CA5CF4.2080708@codeaurora.org> <52CA744F.2080609@intel.com> <52CAC067.20601@ubuntu.com> <52CBB188.2080707@intel.com> <52CC1422.1020101@ubuntu.com> <52CCA3CF.5050308@intel.com> <52CCA6E3.2090400@ubuntu.com> <52CCAAA7.4070104@intel.com> <52CCAF8C.7040407@ubuntu.com> <52CCB3E8.5010101@intel.com> <52CCB5C4.7020206@ubuntu.com> <52CCB99A.4090201@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52CCB99A.4090201@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/07/2014 09:36 PM, Aaron Lu wrote:
> I think the host controller can decide not to power all its ports,
> only when a specific reg in the port's memory range is set, it will
> give power to that port and thus spin up the drive. Makes sense?

The port doesn't supply power to the drive, it gets it straight from
the system PSU.

> Oh, of course, my stupid :-) Then I suddenly think my patches can
> kind of work - let's say we have done the hdparm setting thing
> before suspend and the disk will be spun up in standby mode next
> time it is powered. Then during system resume phase, remove the
> pm_request_resume call in both SCSI and ATA's system resume
> callback, - if the disk is powered, it will be in standby mode and
> its runtime status is RPM_SUSPENDED, match its real status(sort
> of); - if the disk is not powered due to some host feature or
> whatever, it will be in unpowered mode and its runtime status is
> RPM_SUSPENDED, still match its real status.

Right, but if the disk is a run of the mill ATA disk not configured
for power up in standby, then you end up with runtime pm saying that
it is suspended, when in fact, it spun up on its own and is sitting
there waiting for commands.

The PuiS setting isn't something we can or want to twiggle on our own
during suspend, that's an admin decision that they set more or less
permanently either with hdparm or the hardware jumper.  We just need
to detect what the drive has done and update the runtime pm status to
match.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSzOEaAAoJEI5FoCIzSKrwIVoH/1sszQsK1buyg9hDvemd84m6
EMkMUsab4qYZlxGcQpnUUlJbQpGKnhDXjxBstjD8zfnC6WQfOCySTqkqBzZqEXzE
QEt5IV7mWn43tGbu4pyYlw4SrEOmOmmYJxl5yh033MAPNsP/rhToXZoEPOTRCro4
GdkZpxx0A9Y/rnzLN29RoFw41T5G4aG0O7FyTuZGPW/uWhhdUqxpUQt7ACCD+fdD
GaHWf2WInU7vSrDcg6daxvarqQ8GJavc1rafM45EkGMCzGwRhvIR+PCBk8E9t1qA
eB/1b9q8DiBJVCiMxcZVOLY8PY0bm1eBRRqhMef0l7Ppvl8N23f84o7tcN57lWY=
=RCPv
-----END PGP SIGNATURE-----
