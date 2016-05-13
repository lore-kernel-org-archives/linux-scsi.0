From: Mike Christie <mchristi@redhat.com>
Subject: Re: [Bug 118081] New: open-iscsi Ping timeout erro
Date: Fri, 13 May 2016 11:19:56 -0500
Message-ID: <5735FEAC.9030209@redhat.com>
References: <bug-118081-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbcEMQUD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2016 12:20:03 -0400
In-Reply-To: <bug-118081-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, liuzhengyuang521@gmail.com, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On 05/11/2016 10:34 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=118081
> 
>             Bug ID: 118081
>            Summary: open-iscsi Ping timeout erro
>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 4.4.7
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: scsi_drivers-other@kernel-bugs.osdl.org
>           Reporter: liuzhengyuang521@gmail.com
>         Regression: No
> 
> Hi everyone:
> I create a target using fileio as the backend storage on ARM64 server. The
> initiator reported some errors showed bellow  while perform iozone test.
> 
> [178444.145679]  connection14:0: ping timeout of 5 secs expired, recv timeout
> 5, last rx 4339462894, last ping 4339464146, now 4339465400
> [178444.145706]  connection14:0: detected conn error (1011)
> [178469.674313]  connection14:0: detected conn error (1020)
> [178504.420979]  connection14:0: ping timeout of 5 secs expired, recv timeout
> 5, last rx 4339477953, last ping 4339479204, now 4339480456
> [178504.421001]  connection14:0: detected conn error (1011)
> [178532.064262]  connection14:0: detected conn error (1020)
> [178564.584087]  connection14:0: ping timeout of 5 secs expired, recv timeout
> 5, last rx 4339492980, last ping 4339494232, now 4339495484
> ..............................
> 
> I try to trace the function call of target iscsi. Then, I found the  receiving 
> thread of target iscsi blocked at fd_execute_sync_cache -> vfs_fsync_range.
> Further, vfs_fsync_range may takes more than 10 seconds to return,while
> initiator Ping timeout would happened after 5 seconds.   vfs_fsync_range was
> call with the form vfs_fsync_range(fd_dev->fd_file, 0, LLONG_MAX, 1) every
> times  which means sync all device cache. 
> So, is this a bug?
> How  does Initiator send sync_cache scsi command? 
> Does it need to sync all device cache at once?
> Any reply would be thankful.
> 

The upper layers like the FS or application determine when to send a
sync cache. They send down a request and the iscsi layer just sends it
to the target.

You are using LIO right? It looks like we end up syncing the entire
device sometimes. I think for iscsi pings/Nops that have the immediate
bit set, the target would want to reply to them right away. They should
not be getting stuck behind these type of commands.

Nick, what do you think?

