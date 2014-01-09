From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Thu, 09 Jan 2014 11:34:25 -0500
Message-ID: <52CECF91.10206@ubuntu.com>
References: <Pine.LNX.4.44L0.1401091108490.1493-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:62257 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaAIQe2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2014 11:34:28 -0500
In-Reply-To: <Pine.LNX.4.44L0.1401091108490.1493-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/9/2014 11:14 AM, Alan Stern wrote:
> That's true, but it isn't a problem.  We know that requests with
> REQ_PM are sent only at certain, controlled times.  In particular,
> the only time such a request would be sent while the disk is
> RPM_SUSPENDED is during a system resume.

Yes, but if the disk and port were both already RPM_SUSPENDED when the
system was suspended, and so the port is still RPM_SUSPENDED when the
disk's system resume method is called, then it can't communicate with
the disk.

>> We need to put the device into one of the transitioning states
>> to block other IO, without allowing the port to suspend.
> 
> No, we only need to make sure that the port doesn't go into runtime
>  suspend while we carry out the "is the disk spinning" test.

Well how else do you do that other than with the transition states?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSzs+RAAoJEI5FoCIzSKrw1KoH+gJ4c1iXqOUUqJfF2xoxrF6k
Fv3KyTNMn8Y9RF12o5OlfQHwPkwhplIR7uBd5agnd9cXR2owRVLgAE34/ggEEOOq
NgaRwfNBbD3Q83I/6aEZ7C7A0wbWyrA+w2aaBIe5RzTslH3IYcePZvnKUZuG+/0A
rAR/IVyNL5e6JDPgvSkx7/LmxLVb3M4NkYeCMHvl8Gmg+bvg2S+R3TAcUTvRzRv4
gwtkbYGkyS/NmXc86Vi7Z2pOcIyZT3T0CyzlSqAIjljYSFJbzY+PRP4D4gAOXqyd
vqrg+PtxUYlQ0POdYRo0TtCe2N5nk4RI3jwiyD0U1/GFgcY/uNNJOtPaiQOLxOU=
=cMp1
-----END PGP SIGNATURE-----
