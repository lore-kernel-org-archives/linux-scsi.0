From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43359] LVM volumes not detected
Date: Thu, 14 Jun 2012 16:16:35 +0000 (UTC)
Message-ID: <20120614161635.D4CD311FBDE@bugzilla.kernel.org>
References: <bug-43359-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51680 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478Ab2FNQQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2012 12:16:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9D83120427
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jun 2012 16:16:39 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 57E7220449
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jun 2012 16:16:37 +0000 (UTC)
In-Reply-To: <bug-43359-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D43359





--- Comment #5 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org> =
 2012-06-14 16:16:35 ---
Reply-To: muthu.lkml@gmail.com

I am using CentOS 6.x and I hit this bug with 3.5-rc2. I tried to look
in to the boot process and found that the initramfs generated from
3.5.-rc2 is not good for lvm root. It was missing /lib/modules/<uname
-r>/kernel/drivers/md/*". Also /sbin/ doesn't have lvm_scan and was
missing a bunch of other files too.

CCing initramfs folks. Any help?



On Sat, Jun 9, 2012 at 11:12 PM,  <bugzilla-daemon@bugzilla.kernel.org>=
 wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D43359
>
>
>
>
>
> --- Comment #1 from Fran=C3=A7ois Valenduc <francois.valenduc@tvcable=
net.be> =C2=A02012-06-10 06:12:06 ---
> This problem seems impossible to bisect. The first run (794c10fa0fa4d=
) was the
> result of the bisection limited to drivers and fs directories. A seco=
nd run
> where I also added the block directory lead to a commit related to wa=
tchdog,
> which is impossible since I don't use watchdog on my computer.
> A 3rd run on the whole kernel tree leads to this commit:
>
> From 4523e1458566a0e8ecfaff90f380dd23acc44d27 Mon Sep 17 00:00:00 200=
1
> From: Dave Hansen <dave@linux.vnet.ibm.com>
> Date: Wed, 30 May 2012 07:51:07 -0700
> Subject: [PATCH] mm: fix vma_resv_map() NULL pointer
>
> hugetlb_reserve_pages() can be used for either normal file-backed
> hugetlbfs mappings, or MAP_HUGETLB. =C2=A0In the MAP_HUGETLB, semi-an=
onymous
> mode, there is not a VMA around. =C2=A0The new call to resv_map_put()=
 assumed
> that there was, and resulted in a NULL pointer dereference:
>
> This is also strange because I don't use hugetlb. I can revert this c=
ommit but
> it doesn't change anything. Does anybody have an idea on what I could=
 do to
> further investigate this problem.
>
> --
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Dem=
ail
> ------- You are receiving this mail because: -------
> You are the assignee for the bug.--
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
