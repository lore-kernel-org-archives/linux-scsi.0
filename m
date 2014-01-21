From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Tue, 21 Jan 2014 09:37:00 -0500
Message-ID: <52DE860C.6010502@ubuntu.com>
References: <CAPcyv4i2+GAEV7NNx6MkOOcZSCxhOWB3sCO1eCuH40Z2fhpw3g@mail.gmail.com>	<Pine.LNX.4.44L0.1401180906330.19470-100000@netrider.rowland.org> <CAPcyv4iZ4Qfzd2tZUOSbz9bGUqfzOD3zamFw6gip4ceB3=SK+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:50757 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbaAUOhD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2014 09:37:03 -0500
In-Reply-To: <CAPcyv4iZ4Qfzd2tZUOSbz9bGUqfzOD3zamFw6gip4ceB3=SK+Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/21/2014 5:12 AM, Dan Williams wrote:
> The need is to avoid tying rpm and dpm ops together in surprising
> new ways that require userspace to change if it wants to keep the
> default behavior of hiding resume latency as much as possible.  A
> lazy_resume knob vs changing the default let's the few setups that
> care set the power-up in standby mode.  It should also "perform"
> better given it does not require the disk to be runtime suspended
> prior to system suspend, it will unconditionally resume on demand.

The more I think about it the more I agree that the new knob is
needed.  If the user wants runtime pm but without the lazy system
resume, switching off runtime pm prior to suspend would needlessly
force the disk to spin up if it is already in standby, then right back
down again.  At least, that's how rpm is currently implemented, which
is something else I found odd about it.  Why can't you disable auto
suspend, but still be able to manually suspend or leave an already
suspended device asleep?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS3oYMAAoJEI5FoCIzSKrw0bIH/2G6HN7iVOEO8ZkK7vNiogIG
1mQWSl+swYBQwz+ix+WLo6zerlFSSxmh+FfJ/+sm96F0CZhOZrmQzvUbIiqgp8Hk
yqtJ8lYeCXywjwzVsBgPELMExsA2ITHWDMqdvHIJ1cNHh4ynIFB6cOsfgrR8Jfli
1gML5JHAZr6eVpQJZ/wwsJsQrNh5KNfkQLE7ylVkB/BUqhoCSJz1+dF/fZ5uUJk2
eztq9qRglozXz+FyB7hq1oBdqDLira9F35NuboB9zaoOg9z/omdHwUPCmeBklxRv
5rchgjOcZZyC7Y7qrXy0PPsdIS92sh+WTHBKgRwwYLDOUsS23ZZkXZL5PXd/1rc=
=efPy
-----END PGP SIGNATURE-----
