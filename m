From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 07 Jan 2014 11:37:51 -0500
Message-ID: <52CC2D5F.6030905@ubuntu.com>
References: <Pine.LNX.4.44L0.1401071057130.1296-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1401071057130.1296-100000@iolanthe.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/7/2014 11:08 AM, Alan Stern wrote:
> Okay, that's a different matter.  There's a much simpler way to 
> accomplish this.  The patch below will avoid spinning up drives
> that were already in runtime suspend when the system sleep started.
>  (If a drive wasn't in runtime suspend then presumably it was used
>  recently; therefore it's likely to be used again in the near
> future and so it _should_ be spun up.)

This is a poor assumption.  You may not be using autosuspend at all,
or with a rather long timeout, so it is fairly normal to not be
runtime suspended at suspend time, and yet not likely to access the
disk for some time after resume.  It also still suffers from the issue
of claiming the device is runtime suspended while the disk has in
fact, spun up of its own accord.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSzC1fAAoJEI5FoCIzSKrwO5oIAJaROYiUSrapbSo40/YLLuPH
Y+5ECV7JW1hVSK7n3MyYls5YS6DiBQpjlhZ0h7XXoRWzUuT8GtU69wufjgln9IkZ
0zTDj7idDBzbBVBzdhLRsposIWWldsnpfYqvOPZsCd/xQe/jhnamKfBCSr4gYHy0
/FklPdPa2HXwApTNEz2fpleNiqdl6lbDEUkqI/sWkbjKrGVb57CAu8MaruPd2Frh
lkE3Dw7OfgQcngU8pU6kj4otRaBMEoEfIN7gMQ2CNont5JICDf4CvrZXawvKD3/1
Vg72E7DEUkNOCorqGywPcbV8838joEefmcsBc73w7Cn0rZC/5OmgrPyIUfgaS9k=
=bu2W
-----END PGP SIGNATURE-----
