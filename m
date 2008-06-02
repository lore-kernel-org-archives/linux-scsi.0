From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10846] Slow write on LSISAS1068E (SAS6/iR) on kernel >= 2.6.22
Date: Mon,  2 Jun 2008 08:11:46 -0700 (PDT)
Message-ID: <20080602151146.6F0CB11D108@picon.linux-foundation.org>
References: <bug-10846-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900AbYFBPMQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2008 11:12:16 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m52FBkRG025915
	for <linux-scsi@vger.kernel.org>; Mon, 2 Jun 2008 08:11:47 -0700
In-Reply-To: <bug-10846-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D10846





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2008-06-02 08:1=
1 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Mon, 2008-06-02 at 07:57 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> Very easy: We also check for an untar of the kernel (5x slower)
> debian-test:~# dd if=3D/dev/zero of=3D/root/test.cdrom bs=3D10k count=
=3D60000
> 60000+0 enregistrements lus
> 60000+0 enregistrements =C3=A9crits
> 614400000 octets (614 MB) copi=C3=A9s, 1,17602 seconde, 522 MB/s
> debian-test:~# uname -a
> Linux debian-test.pr.univmed.fr 2.6.19.7 #1 SMP Fri May 30 15:55:50
> CEST 2008
> i686 GNU/Linux
>=20
> debian:~# dd if=3D/dev/zero of=3Dtest.cdrom  bs=3D10k count=3D60000
> 60000+0 records in
> 60000+0 records out
> 614400000 bytes (614 MB) copied, 7.51225 seconds, 81.8 MB/s
> debian:~# uname -a
> Linux debian 2.6.22-4-vserver-686 #1 SMP Tue Feb 12 22:02:04 UTC 2008
> i686
> GNU/Linux

What exactly is test.cdrom on?  A single disk?  If so, then your first
result is definitely bogus.  The maximum bandwidth of a single SAS link
is 300 MB/s, so it looks like the kernel is either caching the write or
has timing issues.  For a direct to platter speed, the data sheet for
your drive gives 55-89MB/s, so I'd say 81.8 is well within the range.

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
