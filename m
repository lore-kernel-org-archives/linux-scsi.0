From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Thu, 09 Jan 2014 14:20:44 -0500
Message-ID: <52CEF68C.40703@ubuntu.com>
References: <Pine.LNX.4.44L0.1401071015120.1296-100000@iolanthe.rowland.org> <52CC1FF2.1020301@ubuntu.com> <52CEEAA1.2010904@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52CEEAA1.2010904@interlog.com>
Sender: linux-ide-owner@vger.kernel.org
To: dgilbert@interlog.com, Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/9/2014 1:29 PM, Douglas Gilbert wrote:
> When REQUEST SENSE had its original semantics, TEST UNIT READY was
> the only game in town for monitoring power management. From my
> reading of spc4r36n.pdf section  5.1.2 "Important commands for all
> SCSI device servers" TEST UNIT READY should be called before
> REQUEST SENSE during device initialization (including resume). If
> the responses to TEST UNIT READY and REQUEST SENSE contradict then
> the former is correct.

I don't see language there remotely like that.  How did you arrive at
this conclusion?

> There are SCSI devices out caught in that transition. For example
> with sg_format I monitor progress with either TEST UNIT READY or
> REQUEST SENSE, defaulting to the former. [Progress indication is
> another new role for REQUEST SENSE.]
> 
> Note that the billion or so USB keys out there that say that they
> comply with SCSI-2 should respond to a REQUEST SENSE with its
> original semantics.

Then they will return 0/0/0, so we will assume they are up and
running, which is correct.  SPC-2 is coming up on 13 years old and
listed this usage for REQUEST SENSE.  Are there any actual disk drives
out there ( and still in use ) that return 0/0/0 when in the stopped
state?  I can't imagine there would be.

> The ATA REQUEST SENSE DATA EXT command refers to the SPC-4 
> "standard" (not yet it ain't) which is naturally the new SCSI
> semantics of REQUEST SENSE. I believe the ATA REQUEST SENSE DATA
> EXT command is a relatively new ATA command so it does not carry
> the historical baggage of its SCSI counterpart.

It is also only for ATAPI devices.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSzvaMAAoJEI5FoCIzSKrwcxIH/3Y7DdnXr6Fj9MiWs/Hn2kte
EZVkHbj5jN4/OdKj3gnR3BK8gjrA7AEtbD3J6g7zJSj50UM1EA5RqMYAutZQkvYk
UsKNuV+qIcN3OpSltAGK5TQPGUo2M9apcYuy9NKTZEaWI9dXejGJ/2GitxYXO35H
drsTNlzEErnQvJwBhEYq6+rtferv7/vdZOljSGM1pP48gK0IWz+r2cwXxojkUvk1
lsiU97BxHCVNJc7kHmKVzBw0JV4R2mrtI/I/bE/VZzeljvjA9fNoXqdQxFU1RPDT
PNLHBecjgbDlc70l1CNKNc4ApqBDSYg9SwBtG1nCa36MLgLoN1ZDEatzqT9IdYw=
=qsZP
-----END PGP SIGNATURE-----
