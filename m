From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118081] open-iscsi Ping timeout erro
Date: Tue, 24 May 2016 08:08:34 +0000
Message-ID: <bug-118081-11613-M7MWpylJFW@https.bugzilla.kernel.org/>
References: <bug-118081-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50338 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbcEXIIi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2016 04:08:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CB11120396
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2016 08:08:36 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D8284202EB
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2016 08:08:34 +0000 (UTC)
In-Reply-To: <bug-118081-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=118081

--- Comment #4 from Liu zhengyuan <liuzhengyuang521@gmail.com> ---
Hi, nab:
Did you mean doing iozone test on a local disk LUN not a iscsi LUN from the
word "are you seeing something different wrt iozone on a Linux host..?"?  If
so, I didn`t found any different between this two LUN from application
perspective. As for iscsi LUN, the iozone would abort due to write system call
failure.
(In reply to nab from comment #3)
> Hey Mike & Co,
> 
> Apologies for missing this bug-report.  Comments below.
> 
> (Adding target-devel CC')
> 
> On Fri, 2016-05-13 at 11:19 -0500, Mike Christie wrote:
> > On 05/11/2016 10:34 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=118081
> > > 
> > >             Bug ID: 118081
> > >            Summary: open-iscsi Ping timeout erro
> > >            Product: SCSI Drivers
> > >            Version: 2.5
> > >     Kernel Version: 4.4.7
> > >           Hardware: All
> > >                 OS: Linux
> > >               Tree: Mainline
> > >             Status: NEW
> > >           Severity: normal
> > >           Priority: P1
> > >          Component: Other
> > >           Assignee: scsi_drivers-other@kernel-bugs.osdl.org
> > >           Reporter: liuzhengyuang521@gmail.com
> > >         Regression: No
> > > 
> > > Hi everyone:
> > > I create a target using fileio as the backend storage on ARM64 server. The
> > > initiator reported some errors showed bellow  while perform iozone test.
> > > 
> > > [178444.145679]  connection14:0: ping timeout of 5 secs expired, recv timeout
> > > 5, last rx 4339462894, last ping 4339464146, now 4339465400
> > > [178444.145706]  connection14:0: detected conn error (1011)
> > > [178469.674313]  connection14:0: detected conn error (1020)
> > > [178504.420979]  connection14:0: ping timeout of 5 secs expired, recv timeout
> > > 5, last rx 4339477953, last ping 4339479204, now 4339480456
> > > [178504.421001]  connection14:0: detected conn error (1011)
> > > [178532.064262]  connection14:0: detected conn error (1020)
> > > [178564.584087]  connection14:0: ping timeout of 5 secs expired, recv timeout
> > > 5, last rx 4339492980, last ping 4339494232, now 4339495484
> > > ..............................
> > > 
> > > I try to trace the function call of target iscsi. Then, I found the  receiving 
> > > thread of target iscsi blocked at fd_execute_sync_cache -> vfs_fsync_range.
> > > Further, vfs_fsync_range may takes more than 10 seconds to return,while
> > > initiator Ping timeout would happened after 5 seconds.   vfs_fsync_range was
> > > call with the form vfs_fsync_range(fd_dev->fd_file, 0, LLONG_MAX, 1) every
> > > times  which means sync all device cache. 
> > > So, is this a bug?
> > > How  does Initiator send sync_cache scsi command? 
> > > Does it need to sync all device cache at once?
> > > Any reply would be thankful.
> > > 
> > 
> > The upper layers like the FS or application determine when to send a
> > sync cache. They send down a request and the iscsi layer just sends it
> > to the target.
> > 
> > You are using LIO right? It looks like we end up syncing the entire
> > device sometimes. I think for iscsi pings/Nops that have the immediate
> > bit set, the target would want to reply to them right away. They should
> > not be getting stuck behind these type of commands.
> > 
> > Nick, what do you think?
> > 
> 
> In modern iscsi-target code, the backend sbc_ops->execute_sync_cache()
> call is invoked directly from iscsi_trx kthread process context.
> 
> For FILEIO backends, this can block immediate iscsi commands like NOPs
> on the same connection (eg: socket) processing a SYNCHRONIZE_CACHE CDB
> that is taking a long time to complete.
> 
> Wrt to Liu's follow-up question, an initiator should attempt to retry
> all outstanding commands that did not receive a response once the
> initiator side NopOut timeout has fired.
> 
> So from an application perspective, the initiator NopOut timeout and
> subsequent iscsi session reinstatement should not be propagating up a
> SYNCHRONIZE_CACHE failure unless the default 120 second Linux/iSCSI
> initiator I/O timeout has elapsed.
> 
> Liu, are you seeing something different wrt iozone on a Linux host..?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
