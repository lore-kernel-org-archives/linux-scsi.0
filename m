From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 07 Jan 2014 18:47:57 -0500
Message-ID: <52CC922D.9070208@ubuntu.com>
References: <Pine.LNX.4.44L0.1401071352080.1296-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1401071352080.1296-100000@iolanthe.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/07/2014 02:18 PM, Alan Stern wrote:
> I don't know how you manually spin down your disk, but one
> reasonable way to do it is to set the autosuspend timeout to 0.  If
> you use this approach and apply my patch, the disk should remain
> spun down when the system resumes.

The traditional method before the recently added block pm feature was
with hdparm -y.

> Right.  If you hadn't put the whole system to sleep, the disk
> would have gone into runtime suspend 2 minutes later (assuming you
> didn't use it in the meantime).  Whereas since you did put the
> whole system to sleep, the disk will go into runtime suspend 5
> minutes after the system wakes up -- not 2 minutes later.  I.e.,
> the timer has been reset from 2 minutes back to 5.

What resets the timer?  It should only be reset when IO is done.  And
yes, it is exactly that wakeup and turn around and suspend again that
I'm trying to avoid; it puts unnecessary wear and tear on the disk.

> How is the kernel supposed to know that you finished using the
> disk before suspending the system?  After all, by setting the
> autosuspend timeout to 5 minutes, you have already told the kernel
> to keep the disk spun up if it has been used any time in the last 5
> minutes, and you used it only 3 minutes ago.  As far as the kernel
> can tell, you still want the disk to be spun up and ready for use.
> That remains true at the time of the system resume.

That's the whole point: it doesn't know.  What it does know is that
the disk is spun down on resume, and it has no reason to believe that
you will need it again soon.  This is especially true given that your
typical single ATA disk system will spin up the drive on its own
anyhow, so on systems with multiple scsi or ATA disks that explicitly
have been set to power up in standby, it is at least an even bet that
you won't be touching them all soon.

> You're forgetting that the same sd driver manages other types of 
> devices than disk drives.  Card readers and USB flash drives have
> no heads to retract and no spinning platters.  They don't need
> START STOP commands (in fact, some of them probably would crash if
> they received such a command).

They are irrelevant since they ignore the command anyhow.

> Irrelevant, unless you are also claiming that all ATA disks always
> get powered on whenever the system resumes, something which is not
> at all evident to me.  Particularly if the disk was in runtime
> suspend before the system went to sleep.

I'm saying that most do.  It doesn't require 100% to be relevant.
There will also be plenty of disks at least for some time that are
still using the internal standby timer rather than runtime pm.

> Now I'm really getting confused.  Here, you are saying that ATA
> disks will always spin up, all by themselves, whenever the system
> resumes, and there's nothing the kernel can do to prevent it.  But
> earlier you wrote:

No, I'm saying some ( most in fact ) do, and some do not.  Both cases
need to be handled.  Runtime pm must not indicate the disk is
suspended when it spins up on its own after power on, which ATA disks
do by default.  Oddly, the SCSI standard says that SCSI disks can be
configured behave this way as well rather than requiring an explicit
start command, though it doesn't say how and I've not heard of a way
to do this.  I suppose this also applies to the USB flash drives and
SD card readers you mentioned that are managed by sd.

> Isn't this a contradiction?  Or are you making a distinction
> between ATA and non-ATA disks?

What?  I have some disk drives that I rarely access.  I simply don't
want them starting up and spinning back down every time I resume.  In
my case they are ATA with PuiS enabled, but it applies to SCSI the
same way.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSzJItAAoJEI5FoCIzSKrwhCQIAIclA7u+FJ1PSZRYWcvFQg0B
n/WIupSCAXfiSo4uVZpC9m4W8TR9CawEorIPZGE+G/Hv+zRz3YKqA3OOuOQc1S5i
5IK019yY4EsOHsUK8RlBsgKu1bW0SdFsa73COzqT65bxNqUb5PUK5ed/Z1Kg7cTn
QM7jCMYz0wE7cqAQQ8eV56Y1Nolb6T3WmqKqoGl+qJj+IvebCuJ9vsYXf7MhSd9b
yb2Iq/ThR81vm68c6+KOFQkOkL3zPZ6QWCh5Xj4mRkvXtsd7htNKpxTkM7OC6azF
Z0I5xreArN9SQ8GLHtzB2Lrs+SzlMSvIE1HKQdieBcy//LImk8DajbddupJy7Bk=
=dYPC
-----END PGP SIGNATURE-----
