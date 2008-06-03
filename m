From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10846] Slow write on LSISAS1068E (SAS6/iR) on kernel >= 2.6.22
Date: Tue,  3 Jun 2008 07:12:14 -0700 (PDT)
Message-ID: <20080603141214.2AC4211D10A@picon.linux-foundation.org>
References: <bug-10846-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736AbYFCOMQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2008 10:12:16 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m53ECEGS014880
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jun 2008 07:12:15 -0700
In-Reply-To: <bug-10846-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D10846





------- Comment #4 from anonymous@kernel-bugs.osdl.org  2008-06-03 07:1=
2 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Tue, 2008-06-03 at 00:00 -0700, bugme-daemon@bugzilla.kernel.org=20
> Sure there's write cache enabled and your remark make sense. That's t=
he first
> thing I noticed when changing kernel.
> We went from 2.8.18
> SCSI device sda: drive cache: write through
> SCSI device sda: 285155328 512-byte hdwr sectors (146000 MB)
>=20
> testing with kernels 2.6.22 or 2.6.24, we noticed a change about the =
write
> cache, just changing the kernel on the same hardware.
> [  115.986031] sd 4:1:0:0: [sdb] Write cache: disabled, read cache: e=
nabled,
> doesn't support DPO or FUA
> [  115.986494] sd 4:1:0:0: [sdb] 285155328 512-byte hardware sectors =
(146000
> MB)

The cache lines are actually saying the same thing, just in a different
way.  Write through means write cache disabled, read cache enabled (i.e=
=2E
writes have to be acknowledged only when they're on the platter not in
the cache).  The text of the cache identification was changed because
the term 'write through' was though to be unclear.

> So we got a utility lsiutil to change the settings in the firmware ab=
out write
> cache, and we saw then write cache: enabled, but the speed stayed slo=
w.
> We also took a driver from lsi
>=20
> About your remarks, I tested again using dd with a larger file (when =
untaring
> the kernel there's also a difference but it is less basic than dd)
> The way dd reports its speed  may be not very accurate I agree, but i=
t does not
> change from a kernel point of view.
>=20
> Linux debian-test.pr.univmed.fr 2.6.21.7
> debian-test:~# dd if=3D/dev/zero of=3D/root/test.cdrom  bs=3D10k coun=
t=3D100000
> 100000+0 enregistrements lus
> 100000+0 enregistrements =C3=A9crits
> 1024000000 octets (1,0 GB) copi=C3=A9s, 5,39271 seconde, 190 MB/s
> debian-test:~# dd if=3D/dev/zero of=3D/root/test.cdrom  bs=3D10k coun=
t=3D100000
> 100000+0 enregistrements lus
> 100000+0 enregistrements =C3=A9crits
> 1024000000 octets (1,0 GB) copi=C3=A9s, 5,45364 seconde, 188 MB/s
> debian-test:~# dd if=3D/dev/zero of=3D/root/test.cdrom  bs=3D10k coun=
t=3D200000
> 200000+0 enregistrements lus
> 200000+0 enregistrements =C3=A9crits
> 2048000000 octets (2,0 GB) copi=C3=A9s, 23,0492 seconde, 88,9 MB/s
> debian-test:~# dd if=3D/dev/zero of=3D/root/test.cdrom  bs=3D10k coun=
t=3D200000
> 200000+0 enregistrements lus
> 200000+0 enregistrements =C3=A9crits
> 2048000000 octets (2,0 GB) copi=C3=A9s, 22,5306 seconde, 90,9 MB/s

That's basically showing the OS effect of streaming writes caches, I
think.  You probably see the cache part of top rising rapidly.  Once yo=
u
overpower the OS cache, you'll eventually get the platter speed.

> I reboot and change kernel:
> debian-test:~# uname -a
> Linux debian-test.pr.univmed.fr 2.6.22.19 #1 SMP Fri May 30 19:53:56 =
CEST 2008
> i686 GNU/Linux
> debian-test:~# dd if=3D/dev/zero of=3D/root/test.cdrom  bs=3D10k coun=
t=3D100000
> 100000+0 enregistrements lus
> 100000+0 enregistrements =C3=A9crits
> 1024000000 octets (1,0 GB) copi=C3=A9s, 13,9614 seconde, 73,3 MB/s
> debian-test:~# dd if=3D/dev/zero of=3D/root/test.cdrom  bs=3D10k coun=
t=3D100000
> 100000+0 enregistrements lus
> 100000+0 enregistrements =C3=A9crits
> 1024000000 octets (1,0 GB) copi=C3=A9s, 13,9406 seconde, 73,5 MB/s
> debian-test:~# dd if=3D/dev/zero of=3D/root/test.cdrom  bs=3D10k coun=
t=3D200000
> 200000+0 enregistrements lus
> 200000+0 enregistrements =C3=A9crits
> 2048000000 octets (2,0 GB) copi=C3=A9s, 29,3472 seconde, 69,8 MB/s
> debian-test:~# dd if=3D/dev/zero of=3D/root/test.cdrom  bs=3D10k coun=
t=3D200000
> 200000+0 enregistrements lus
> 200000+0 enregistrements =C3=A9crits
> 2048000000 octets (2,0 GB) copi=C3=A9s, 29,1689 seconde, 70,2 MB/s
> debian-test:~#

Within error bars, those are all really the same.  What it looks to me
like is that the mm layer is better at managing streaming writes.

> (I believe that, if I take a bigger file, we will get the same speed,=
 the
> difference is due to the first data going to write cache)
>=20
> What can we see:
> 1. having a larger file make the write cache less efficient (normal)
> 2. It seems that the write caching is no more working from 2.6.22 on =
our
> hardware (new blade servers from Dell m600). Even using firmware util=
ities
> didn't improve the speed. LSI firmware does not activate write cache =
and their
> BIOS has no setup for that. Switching from 2.6.18 to 2.6.22 makes the=
 kernel=20
> no more doing write cache. Changing in the firmware activate somethin=
g.. just
> in dmesg, we see it: enabled again, but in fact there's no speed diff=
erence.
>=20
> My subject should have  been: no more write caching

Not really ... your disk has a 16MB on disk cache ... that's not the
cause of the differences; it's the way the OS is caching data ... to se=
e
the effect you're seeing, you need gigabytes of cache.  An OSs job is t=
o
allocate spare memory for cache efficiently, and caching streaming
transactions is a complete waste of time (and further it's dangerous
because you get a huge data build up it can take minutes to clear, and
thus get lost on a crash), so it looks like 2.6.22 and beyond just got
better at recognising streaming transactions.

James


--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
