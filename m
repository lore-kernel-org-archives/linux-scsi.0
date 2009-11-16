From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Mon, 16 Nov 2009 19:19:35 GMT
Message-ID: <200911161919.nAGJJZ94028105@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49416 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbZKPTTb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2009 14:19:31 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAGJJZmw028106
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2009 19:19:35 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D14563





--- Comment #6 from Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>  2009-=
11-16 19:19:33 ---
On Mon, 9 Nov 2009, bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=3D14563
,,,
> Overview:
>=20
> Performing tape backups using amanda 2.6.0-p2 [using 512kB block size=
] leads to
> spurious 'EIO' errors when writing to the tape; most of the time a ke=
rnel BUG
> is hit shortly thereafter.
>=20

Can you try this with debugging enabled in st? (Edit st.c to
'#define DEBUG 1' and recompile the module.) This might give more=20
information about the source of the EIO and the code path it uses.

=2E..
> Amanda should correctly write to tape during backup as it does using =
kernels <=3D
> 2.6.27.10.
>=20
>=20
> Affected versions:
>=20
> The oldest kernel I tried which DOES exhibit the problem is 2.6.29.4;=
 other
> kernels exhibiting this problem are 2.6.30.3 and 2.6.31.5.
>=20

There were major changes to the code performing the SCSI commands at=20
2.6.29. The changes were mostly done by Fujita Tomonori and I added him=
 to=20
the cc list.

Kai

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
