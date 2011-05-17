From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35282] BUG() in 2.6.38.6
Date: Tue, 17 May 2011 20:33:55 GMT
Message-ID: <201105172033.p4HKXt9f002889@demeter1.kernel.org>
References: <bug-35282-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:51578 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab1EQUdz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2011 16:33:55 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p4HKXtSJ002890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 17 May 2011 20:33:55 GMT
In-Reply-To: <bug-35282-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=35282





--- Comment #1 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2011-05-17 20:33:51 ---
Reply-To: James.Bottomley@HansenPartnership.com

On Tue, 2011-05-17 at 19:17 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=35282


> May 15 16:09:32 192.168.42.2 Call Trace:
> May 15 16:09:32 192.168.42.2 <IRQ>
> May 15 16:09:32 192.168.42.2
> May 15 16:09:32 192.168.42.2 [<ffffffff812160eb>] ? __blk_run_queue+0x24/0x7e
> May 15 16:09:32 192.168.42.2 [<ffffffff81216167>] ? blk_run_queue+0x22/0x34
> May 15 16:09:32 192.168.42.2 [<ffffffff812b2fde>] ? scsi_run_queue+0x2ce/0x36d
> May 15 16:09:32 192.168.42.2 [<ffffffff812b39ef>] ? scsi_next_command+0x2d/0x39
> May 15 16:09:32 192.168.42.2 [<ffffffff812b4289>] ?
> scsi_io_completion+0x1ca/0x3fd

This looks like it might be related to the queue guard in
__elv_next_request() again,  could you try this patch:

http://marc.info/?l=linux-scsi&m=130348673628282

Thanks,

James

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
