From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Wed, 08 Jan 2014 16:50:46 -0500
Message-ID: <52CDC836.4000201@ubuntu.com>
References: <Pine.LNX.4.44L0.1401081547490.1659-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1401081547490.1659-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/8/2014 4:21 PM, Alan Stern wrote:
> I never saw your patches.  Where were they posted?

Higher up in this thread on linux-ide and linux-scsi.  Subject was Let
sleeping disks lie.

> If you issue the REQUEST SENSE command in the usual way (going
> through the SCSI and block layers), and the disk is already in
> runtime suspend, it won't do what you want.  The block layer won't
> deliver requests until the device leaves the RPM_SUSPENDED state.
> In addition, when it receives the command the block layer will
> submit a deferred runtime-resume request, which rather defeats the
> whole purpose.

Right, which is why I left the device in the active state and used the
pre/post_suspend functions to change the queue into the RPM_SUSPENDING
state, then either complete the transition to RPM_SUSPENDED, or bail
out and go back to RPM_ACTIVE.

> What happens with non-ATA disks?

Same thing: they return a sense status that either says they are
suspended, stopped, or normal.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSzcg2AAoJEI5FoCIzSKrw7wcIAJLiliMYnoHLm/dGWHhhfcnb
ELJLLAhhWsOIQmHiV1svdy0F7EuKi3KF9qJ9JwCaAspO0w8q24UGhvQW20uSH9Md
JliKhn6eBY/NFTctaVP2tnOcc4vevCndJfEScBlWxI82MWMC1TV3lA7xPtcJ5ocX
LMBLPXpr0qypisgmu/tAnwTPQVyU4WUkgMmG9us4w3BgCkvI/oXf4oDKFkCNgUye
FX16NTZPR6iaIK+YJMG3uKCSD4CQjTnKJNXGR89XKJG+Z9v04jyQgWs7kgvqCov9
F5j+yueyMVlveGPHmNwhElHEPT2UWSoyQbonuOrYQZ+Db+xJBOxzoY8Jgq9lWVI=
=+vwf
-----END PGP SIGNATURE-----
