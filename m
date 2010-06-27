From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16275] Kernel panic when mounting filesystem
Date: Sun, 27 Jun 2010 21:07:01 GMT
Message-ID: <201006272107.o5RL71Vr022017@demeter.kernel.org>
References: <bug-16275-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37146 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab0F0VHD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Jun 2010 17:07:03 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o5RL71I4022022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 27 Jun 2010 21:07:01 GMT
In-Reply-To: <bug-16275-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16275





--- Comment #6 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-06-27 21:06:55 ---
Reply-To: James.Bottomley@suse.de

On Fri, 2010-06-25 at 08:13 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> any news ?
> I can test if someone give - patch that fix this issue.

For those who don't have access to bugzilla, there's a gif image of the
crash:

https://bugzilla.kernel.org/attachment.cgi?id=26910

Unfortunately, the crucial information has scrolled off the top of the
screen, but the presentation is some type of crash in
scsi_setup_fs_cmnd().  Without the missing information, it's hard to
say, but I'd would be a reasonable guess that it's this BUG_ON:

    /*
     * Filesystem requests must transfer data.
     */
    BUG_ON(!req->nr_phys_segments);

Which would point to the filesystem.  First order of business would be
to validate the guess by getting the missing part of the trace, and then
start looking into the relevant filesystem.

James

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
