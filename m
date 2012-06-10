From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43359] LVM volumes not detected
Date: Sun, 10 Jun 2012 06:12:06 +0000 (UTC)
Message-ID: <20120610061206.E0E081205DA@bugzilla.kernel.org>
References: <bug-43359-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33170 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2FJGMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jun 2012 02:12:12 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C21DB2024E
	for <linux-scsi@vger.kernel.org>; Sun, 10 Jun 2012 06:12:09 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id E621C2024A
	for <linux-scsi@vger.kernel.org>; Sun, 10 Jun 2012 06:12:06 +0000 (UTC)
In-Reply-To: <bug-43359-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D43359





--- Comment #1 from Fran=C3=A7ois Valenduc <francois.valenduc@tvcablene=
t.be>  2012-06-10 06:12:06 ---
This problem seems impossible to bisect. The first run (794c10fa0fa4d) =
was the
result of the bisection limited to drivers and fs directories. A second=
 run
where I also added the block directory lead to a commit related to watc=
hdog,
which is impossible since I don't use watchdog on my computer.
A 3rd run on the whole kernel tree leads to this commit:

=46rom 4523e1458566a0e8ecfaff90f380dd23acc44d27 Mon Sep 17 00:00:00 200=
1
=46rom: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 30 May 2012 07:51:07 -0700
Subject: [PATCH] mm: fix vma_resv_map() NULL pointer

hugetlb_reserve_pages() can be used for either normal file-backed
hugetlbfs mappings, or MAP_HUGETLB.  In the MAP_HUGETLB, semi-anonymous
mode, there is not a VMA around.  The new call to resv_map_put() assume=
d
that there was, and resulted in a NULL pointer dereference:

This is also strange because I don't use hugetlb. I can revert this com=
mit but
it doesn't change anything. Does anybody have an idea on what I could d=
o to
further investigate this problem.

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
