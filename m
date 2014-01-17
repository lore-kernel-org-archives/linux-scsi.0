From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 15:55:30 -0500
Message-ID: <52D998C2.7080302@ubuntu.com>
References: <CAA9_cmcHpWOk_GoAZ_6k_0VDNGdac+BmHB1GxaTNkWNVjcztJQ@mail.gmail.com> <Pine.LNX.4.44L0.1401171513500.6173-100000@netrider.rowland.org> <20140117202433.GB23024@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:64589 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaAQUzc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 15:55:32 -0500
In-Reply-To: <20140117202433.GB23024@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>
Cc: Dan Williams <dan.j.williams@intel.com>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/17/2014 3:24 PM, Tejun Heo wrote:
> Isn't immediate spin-up trivial to implement from anywhere?  I'm
> not sure whether we'll end up defaulting to the lazy behavior or
> not but if we do requiring userland to echo something to sysfs to
> configure immediate spin-up feels a bit silly when userland might
> as well just issue a dummy command to force spinup.

Or have your user space pm scripts disable runtime pm on the disk
before suspend.  Or just don't enable PuiS if you have an ATA disk.

> And, yes, I agree with Dan that avoiding spinup of harddrives on 
> system resume seems a bit niche in its usefulness.  suspend/resume 
> cycle at the very least generates logs which most likely will be 
> committed to the drive sooner or later.

Preferably later, after the disk must be woken anyway for some reads :)

> What kind of use cases are we expecting for the lazy behavior?

Not all systems only have a single drive.  There may be a tendency for
IO to the drive with the root fs on it after a resume, but multi drive
systems often end up not touching the other disks so they go back into
suspend shortly after resume, so the start/stop cycle was just
needless wear and tear on the drive.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS2ZjCAAoJEI5FoCIzSKrwavMH+weGHd6Jjj4Z5Q7LMQMDaM6G
eYn/Rfbia0Adk9VTdte7/5cOJDB2iSA9tv3G3KBODdMOyIVUViRgUtG3/Zh2t22z
5qq+F4Yj1V5cjEvFnNvYFA/RfW3W8yACYNR+KgJ6d88q1ZSoQ1R0KuhnHa4YA8Cf
hN0lIdaYeIDdqXX7IvcMJb/9xlYVUuzgezvf4gdamQFvJDg4AspIuYXZMIhxy3Al
TAX/yM0oHLrLA/4dJcTzoKkkUkx456oxa2i8DauM1gNWbuKEWSgG4hBG3ME2e6tU
9QbYLGOfg3naXcXEvNM1CL8xebh7V0mK4u4LXe/yePwyJNN9gIEDNmYX5xixeJQ=
=5Qzv
-----END PGP SIGNATURE-----
