From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9133] aacraid driver fails with Dell PowerEdge Expandable RAID Controller 3/Di
Date: Fri, 10 Oct 2008 03:11:29 -0700 (PDT)
Message-ID: <20081010101129.B7F13108059@picon.linux-foundation.org>
References: <bug-9133-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751414AbYJJKL7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2008 06:11:59 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9AABTR8026113
	for <linux-scsi@vger.kernel.org>; Fri, 10 Oct 2008 03:11:30 -0700
In-Reply-To: <bug-9133-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9133


martin.wilck@fujitsu-siemens.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |martin.wilck@fujitsu-
                   |                            |siemens.com




------- Comment #9 from martin.wilck@fujitsu-siemens.com  2008-10-10 03:11 -------
(I am copying this from https://bugzilla.redhat.com/show_bug.cgi?id=457552)

Thie discussion here resulted in the following patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=94cf6ba11b

Unless overridden by module dac_mode=0, aac_scsi_32_64 is used for
aac_adapter_scsi() on 64bit-DMA-capable systems for all contollers with
AAC_QUIRK_SCSI_32 and AAC_OPT_SGMAP_HOST64 set.

aac_scsi_32_64() always returns FAILED on 64bit DMA-capable systems if the
adapter has the AAC_OPT_SGMAP_HOST64 flag set , and  if the physical memory is
>4GB.

Thus, on every system with 64bit DMA and >4GB memory, aac_adapter_scsi() will
always fail (!) for each controller with AC_QUIRK_SCSI_32 and
AAC_OPT_SGMAP_HOST64. In practice, that means to me that AC_QUIRK_SCSI_32
implies that you can't use >4GB memory (that agrees with the findings in
comment #17).

Perhaps the Perc 3/Di has this limitation, but the 2120S and 2200S certainly
don't. In the above-mentioned Red Hat bugzilla, the patch was modified by
removing 2120S and 2200S from the list of controllers with AC_QUIRK_SCSI_32.
Most probably, that isn't even sufficient. I would suggest to remove
AC_QUIRK_SCSI_32 for all controllers except the Perc 3/Di.

Mark, how did you generate the list of controllers that you assigned
AC_QUIRK_SCSI_32 to? Why did you include 2120S and 2200s?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
