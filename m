From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 07 Jan 2014 09:50:10 -0500
Message-ID: <52CC1422.1020101@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com> <52CA1191.8060804@ubuntu.com> <52CA5CF4.2080708@codeaurora.org> <52CA744F.2080609@intel.com> <52CAC067.20601@ubuntu.com> <52CBB188.2080707@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52CBB188.2080707@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/7/2014 2:49 AM, Aaron Lu wrote:
> We can modify the device's system resume callback. To better
> illustrate the idea, I just made two patches to do this and I did
> some quick tests and didn't find anything wrong.

That misses one key aspect I was trying to capture: it always leaves
the disk runtime suspended after a resume.  If the disk spins up on
its own, as most ata disks do, then the runtime status doesn't
correctly reflect the actual state of the disk.  This means that
applications that delay activities due to the runtime pm status to
avoid waking a disk won't run, and any runtime autosuspend won't kick
in to actually put the disk back to sleep.

To do that, you need to be able to issue a REQUEST SENSE and
conditionally resume the device.  Of course, you can't do that unless
you first get it into a transitional state, but you can't just request
a resume and then conditionally fail it.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSzBQiAAoJEI5FoCIzSKrwH9UH/3Z3TfKKKYhNsjr26YsKOge2
EQzbcFCg4H5irnKL/olR5fnRKpZYi1Er2ydV6zsHdcCJLFQoqvzVE4ZInl42STI0
IWQ65n5q+U1OaZY+ttGkOBjixi5VIlkb9izZVbzBTi4n5cLEDwyQsE4Rgd9STwjm
gPkNrmGNGPUoY+4O6bLHu0/WvwTX3L/OgxcSsQd1gsdCX3qZzB+UIzfM31W9/4Yl
3sP/tN8mBYcpqR9jIpw2u7m0XEe9Wc71Nepdv2+6sT5uZJ5knTY6epH5Of4FJsyp
CxslFXf6Jb2FZaey8EJB1ocABnePYluQNHrpdRO4gjY+Au/mtzk15tJjoYx3WXg=
=VlKV
-----END PGP SIGNATURE-----
