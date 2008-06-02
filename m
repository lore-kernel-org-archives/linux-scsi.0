From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 10846] New: Slow write on LSISAS1068E (SAS6/iR) on kernel
	>= 2.6.22
Date: Mon, 02 Jun 2008 10:11:03 -0500
Message-ID: <1212419463.3369.10.camel@localhost.localdomain>
References: <bug-10846-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33680 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbYFBPLI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2008 11:11:08 -0400
In-Reply-To: <bug-10846-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

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


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
