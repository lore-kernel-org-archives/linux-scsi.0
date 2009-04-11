From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive
 gives EBUSY
Date: Sat, 11 Apr 2009 06:12:01 GMT
Message-ID: <200904110612.n3B6C1N1030176@demeter.kernel.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43691 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbZDKGME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2009 02:12:04 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3B6C1dt030177
	for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2009 06:12:01 GMT
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D12207





--- Comment #31 from Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>  2009=
-04-11 06:11:59 ---
On Sat, 11 Apr 2009, bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=3D12207
>=20
>=20
>=20
>=20
>=20
> --- Comment #30 from Alan Stern <stern@rowland.harvard.edu>  2009-04-=
11 02:38:27 ---
> On Fri, 10 Apr 2009 bugzilla-daemon@bugzilla.kernel.org wrote:
>=20
> > Maybe you should check your facts before telling others where to lo=
ok.=20
> > max_sectors_kb etc. exist only for block devices (in the Unix sense=
).=20
> > Tapes are character devices.
>=20
> There's no need to be rude.  Besides, how would you suggest I check m=
y=20
> facts (bearing in mind that I don't have access to any SCSI or USB ta=
pe=20
> drives)?
>=20
I am sorry. My words were inappropriate. But even without a tape drive =
it=20
is possible to read the code.

> As the author of st.c, you certainly are the authority on how this
> works.  And it's definitely true that tapes are char devices.
>=20
> But isn't it also true that SCSI tapes, like all SCSI devices, have
> their device queue set up by scsi_alloc_queue(), which calls
> blk_init_queue(), which registers the queue's kobject using
> blk_queue_ktype, whose default attributes include both
> queue_max_sectors_entry.attr and queue_max_hw_sectors_entry.attr?  An=
d
> doesn't this mean that SCSI tapes _do_ have max_sectors_kb etc. =20
> attributes?
>=20
Yes, SCSI uses the (Linux) block layer and the attributes do exist with=
in=20
the kernel. They just are not visible in sysfs for character devices. L=
ast=20
night I read the code to find out why. Your analysis is correct but it=20
only shows that the kobject exists. The kobject is added to sysfs using=
=20
kobject_add() in blk_register_queue() called by add_disk(), which is on=
ly=20
called by disk drivers.

Whether character devices should add the kobject somewhere in sysfs is=20
getting beyond the original topic in this bugzilla entry. This is a mor=
e=20
general problem because there is no /sys/char directory. My current=20
opinion is that it would be nice to see these attributes somewhere, but=
=20
probably not worth the trouble.

Kai

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
