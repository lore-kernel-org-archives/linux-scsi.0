From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14214] BUG at drivers/scsi/scsi_lib.c:1108!
Date: Wed, 30 Sep 2009 21:19:33 GMT
Message-ID: <200909302119.n8ULJXKO003868@demeter.kernel.org>
References: <bug-14214-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37766 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZI3VT3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2009 17:19:29 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8ULJXaI003869
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2009 21:19:33 GMT
In-Reply-To: <bug-14214-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14214





--- Comment #2 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-09-30 21:19:32 ---
Reply-To: James.Bottomley@HansenPartnership.com

On Wed, 2009-09-30 at 12:56 -0700, Andrew Morton wrote:
> On Wed, 23 Sep 2009 11:13:26 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=14214
> 
> Post-2.6.31 regression.  This, in scsi_setup_fs_cmnd():
> 
>         /*
>          * Filesystem requests must transfer data.
>          */
>         BUG_ON(!req->nr_phys_segments);

Well, the BUG_ON is correct: there can't be a FS type command with no
data.

This can't be a SCSI issue because the problem was caused before SCSI
was entered.  Looking at the backtrace (all functions listed as
unreliable, sigh) this is either a deadline scheduler problem (less
likely) or an md_raid one (more likely).

Let's start with what was the mdraid configuration and condition of the
filesystem being mounted? I've added linux-raid to the cc list so they
can chime in for more details.

James

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
