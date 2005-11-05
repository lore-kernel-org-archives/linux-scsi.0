From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: host lock in EH
Date: Sat, 05 Nov 2005 01:26:36 +0100
Message-ID: <436BFC3C.5030209@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:33970 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751299AbVKEA1f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2005 19:27:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux1394-devel@lists.sourceforge.net

Hi all,

some time ago eh_device_reset_handlers of most drivers were changed to=20
grab the host lock.
http://www.kernel.org/git/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;=
a=3Dcommit;h=3D94d0e7b805961c44e4dc486ffc21075084bb7175

Are there general reasons to acquire the host lock in eh_s?

I ask in particular because sbp2's eh_abort_handler actually performs a=
=20
superset of what sbp2's eh_device_reset_handler does,=B9 yet the=20
eh_abort_handler does not grab the host lock.=B2 I.e.,

sbp2scsi_abort()  /* eh_abort_handler */
{
	A;
	B;
	C;
}

sbp2scsi_reset()  /* eh_device_reset_handler */
{
	spin_lock_irqsave(host_lock, flags);
	B;
	spin_unlock_irqrestore(host_lock, flags);
}

So, is it wrong that sbp2scsi_abort doesn't take a lock around B or eve=
n=20
around A...C? Or is it wrong that sbp2scsi_reset takes the lock?

TIA for any clues.


=B9) This seems a bit goofy and may change eventually. I don't think=20
sbp2's eh_s are mature yet.

=B2) sbp2's eh_abort_handler only has a dedicated lock protection furth=
er=20
down in a subroutine which manipulates an sbp2-internal list.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D-=3D =3D-=3D=3D --=3D-=3D
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
