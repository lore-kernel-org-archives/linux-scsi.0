From: Tore Anderson <tore@linpro.no>
Subject: Disabling dev_loss_tmo?
Date: Tue, 13 Nov 2007 10:11:55 +0100
Message-ID: <47396A5B.5040001@linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.linpro.no ([213.236.139.167]:35929 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbXKMJiU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Nov 2007 04:38:20 -0500
Received: from localhost (mailhub.linpro.no [213.236.139.167])
	by mailhub.linpro.no (Postfix) with ESMTP id EF7272011AF
	for <linux-scsi@vger.kernel.org>; Tue, 13 Nov 2007 10:11:55 +0100 (CET)
Received: from mailhub.linpro.no ([213.236.139.167])
	by localhost (mailhub.linpro.no [213.236.139.167]) (amavisd-new, port 10024)
	with ESMTP id N+VF9QBVn0WM for <linux-scsi@vger.kernel.org>;
	Tue, 13 Nov 2007 10:11:55 +0100 (CET)
Received: from ox.linpro.no (ox.linpro.no [87.238.45.114])
	by mailhub.linpro.no (Postfix) with ESMTP
	for <linux-scsi@vger.kernel.org>; Tue, 13 Nov 2007 10:11:55 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi.  Recent kernels will remove the block devices if a FC rport is lost=
,
which causes a number of problems when dm-multipath is used:

1) Multipathd will receive an event notifying it of the removed rport,
and will respond by removing the path.  This causes a suspend which
flushes outstanding I/O, and in a all-paths-down scenario this will
cause I/O errors to propagate up to the file system layer - even if
queue_if_no_path is in use.  This is fixed in newer versions of
multipath-tools, but old versions are still shipped by the various
server distros.

http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/4005

2) Multipathd will often keep open the device as it's being removed,
resulting in an error message when attempting to re-register the
recently revived rport:

=C2=ABobject_add failed for H:B:T:L with -EEXIST, don't try to register
things with the same name in the same directory=C2=BB

The newly added path will therefore not make it back into the
dm-multipath map (and won't be available as a block device either).

http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/4240/foc=
us=3D4255

3) Even when the -EEXIST error doesn't show up, udev/multipath/somethin=
g
seems to get it wrong sometimes. Either the revived path is added to th=
e
wrong (a new) priority group, or it's not added at all.  Most of the
time it works fine, but it's can't be relied upon in my experience.
Haven't been able to track this one down, unfortunately.

Anyway.  I believe all of these problems would be possible to avoid if =
I
could simply make it so that block devices would never be removed due t=
o
rports becoming unavailable.  dm-multipath would fail the path anyway,
and multipathd would just keep on testing its availability and would
re-instate when/if it came back online.  If it didn't, it would of
course hang around as harmless junk - but fibre channel SANs are usuall=
y
quite stable anyway, and the admin will always have the possibility of
removing the block device manually if it bugs him.  In any case it woul=
d
be better than the loss of reliability I experience now.

So what I suggest is a way of disabling dev_loss_tmo (or setting it to
unlimited).  Think that's doable for a kernel newbie like me, or are
there any takers?

Regards
--=20
Tore Anderson
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
