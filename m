From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Tue, 23 Dec 2008 20:19:29 -0800 (PST)
Message-ID: <20081224041929.95F09108043@picon.linux-foundation.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772AbYLXETc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2008 23:19:32 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBO4JTeq016971
	for <linux-scsi@vger.kernel.org>; Tue, 23 Dec 2008 20:19:30 -0800
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





------- Comment #17 from anonymous@kernel-bugs.osdl.org  2008-12-23 20:19 -------
Reply-To: fujita.tomonori@lab.ntt.co.jp

On Tue, 23 Dec 2008 18:56:21 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12207
> 
> 
> 
> 
> 
> ------- Comment #16 from stern@rowland.harvard.edu  2008-12-23 18:56 -------
> USB is working fine, and the patch you proposed should take care of tape
> devices okay.  However the block layer still limits max_sectors to
> BLK_DEF_MAX_SECTORS (see the code for blk_queue_max_sectors), which is defined
> as 1024.  Thus there's no way to request a transfer of more than 512 KB, unless
> st.c does some fancy footwork.

st uses pc requests thus max_hw_sectors matters. st.c can use large
block sizes without any fancy footwork.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
