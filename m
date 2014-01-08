From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Wed, 08 Jan 2014 15:20:58 -0500
Message-ID: <52CDB32A.6000702@ubuntu.com>
References: <Pine.LNX.4.44L0.1401081220170.1659-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:56302 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaAHUVG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2014 15:21:06 -0500
In-Reply-To: <Pine.LNX.4.44L0.1401081220170.1659-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/8/2014 12:46 PM, Alan Stern wrote:
> I/O _was_ done.  To spin up the disk requires sending it a START 
> command.  That's I/O.

Yes, currently, but that's exactly what I'm trying to get rid of.

> In essence, you want your disk's state to move directly from
> unpowered (system asleep) to runtime-suspended with no intermediate
> active -- but only if the disk doesn't spin up all by itself.
> 
> One problem: How can the kernel tell whether the disk has spun up
> by itself?  I don't think it can be done at the SCSI level.  Can it
> be done at the ATA level (and without using the SCSI stack, as that
> would require the disk to go out of runtime suspend and spin up
> anyway)?

You issue a REQUEST SENSE command and that returns status indicating
whether the drive is stopped, or in standby.  See my patches.  One of
them fixes the scsi-ata translation to issue the ATA CHECK power
command to see if the drive is suspended, as SAT-3 calls for.

> Actually, it does have a reason.  Namely, you told it earlier to
> assume the disk will be needed again if it was used within the last
> 5 minutes.  At the time of the system resume, the disk was last
> used 3 minutes ago (not counting the time the system was asleep).

You're looking at it backwards.  You aren't telling it to assume the
disk will be needed again if it was used within the last 5 minutes;
you are telling it that it can assume it *won't* be needed again soon
if not used in the last 5 minutes, and therefore, it is ok to shut it
down.

Also the act of suspending the system is a pretty clear breaking point
in general activity.  You normally stop your work and quiesce the
system before you suspend it.  If I finish my work and copy it to my
backup drive, then suspend the system, and my wife comes by an hour
later to browse the web, she's not going to be touching my backup disk.

> Are you assuming these disks were all runtime-active before the
> system sleep?  If so, the kernel is justified in assuming that you
> will be touching them all soon.

No it isn't.  Absence of evidence is not evidence of absence.  I
listed several use cases where the drive won't be runtime suspended
before the system suspend, yet will not be accessed any time soon
after resume.

> Not the ones that crash when they receive it.  But this point is
> moot since manage_start_stop doesn't do what you want anyway.

Any that crash when they get it either are already unusable or have a
quirk registered to inhibit the command, which would still apply.

> No, it doesn't.  They don't spin, so they can't be configured
> either to spin up or not to spin up after power-on.

Which means we shouldn't be setting the runtime status to suspended
after system resume... that's the second case.

> What is PuiS?

Power up in Standby.

> In the end, it sounds like what you want can be done fairly easily.
>  But only if the kernel has a reliable way to tell whether or not a
> disk is spinning (or is spinning up).

That's why my patches are attempting to do: use REQUEST SENSE to ask
the disk if it is spinning up or not.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSzbMqAAoJEI5FoCIzSKrwCYwIAKMwlRovIdfO6rSgZL7pufFG
LOV/9apHzqldPPLJ5BPk0A69Ok/TimrQax06HTPyGJ1/MmOrEcjJzb482mJ4ixpx
b7DP3De+RCEUifrfIlI/U+fWLHpw4DOYToSy5ZjNZbF/cDz43k85arAwRK/Bkb++
C2F+YfeQyLcR0KjToj8MK9evlGY6oKfEYx9QCjBEgiaXRjIHfu0AuLn7y7AATK6n
pFBzgq4cNSalob9I4WdwejzJz/RzqQFujtknB+nAaKhESqLCoclJLSzwNQyuxcRz
qT3DckTyTBF7vGmYayaeERnukqWnDEBAQOc8qtOxx2rbYpivNHiqIc8sfrRoaJc=
=2kXd
-----END PGP SIGNATURE-----
