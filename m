From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101891] mvsas prep failed, NULL pointer dereference in
 mvs_slot_task_free+0x5/0x1f0 [mvsas]
Date: Thu, 20 Aug 2015 13:45:51 +0000
Message-ID: <bug-101891-11613-dKeKYCvRwW@https.bugzilla.kernel.org/>
References: <bug-101891-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40200 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbbHTNpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2015 09:45:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 70BFA20595
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 13:45:53 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D846120585
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 13:45:51 +0000 (UTC)
In-Reply-To: <bug-101891-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D101891

--- Comment #7 from D=C4=81vis <davispuh@gmail.com> ---
(In reply to Turbo Fredriksson from comment #6)
> Forgive an ignoramus, but those last lines doesn't look to good
>=20
>     kernel: ata11.00: device reported invalid CHS sector 0
>=20
> I have a problem that is very much like yours, but my stack traces ar=
e
> different so I'm unsure if we have the same problem. I'm going to reb=
uild my
> kernel as well with your fix and see if it helps me as well.

My fix is only for "NULL pointer dereference in mvs_slot_task_free" in =
mvsas
driver. If you use hardware with different driver then this fix won't c=
hange
anything for you. And even if you've such hardware and use this driver =
then you
might have hit different bug, you really should have posted stack trace=
, logs,
etc...

As for those other messages, I've no clue what they actually mean. But =
as I
understand under heavy I/O load pci_pool_alloc fails, so those tasks ar=
e
aborted and that probably prevents kernel from accessing disks and disk=
 reset
is issued. Then it can access all disks again and everything keeps work=
ing.

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
