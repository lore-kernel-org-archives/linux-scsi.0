From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: iscsi_trx going into D state
Date: Tue, 18 Oct 2016 00:52:29 -0700
Message-ID: <1476777149.8490.61.camel@haakon3.risingtidesystems.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
         <880e374c-cf8b-f276-e930-57b09fe1a686@suse.com>
         <CAANLjFobXiBO2tXxTBB-8BQjM8FC0wmxdxQvEd6Rp=1LZkrvpA@mail.gmail.com>
         <CAANLjFoh+C8QE=qcPKqUUG3SnH2EMmS7DWZ5D4AD7yWMxoK0Zw@mail.gmail.com>
         <4fc72e32-26fb-96bd-8a0d-814eef712b43@suse.com>
         <CAANLjFpx1MRNiu2388pY+U0O5z9gw+OJBtpOof47Lb_DxaJSBQ@mail.gmail.com>
         <1476774332.8490.43.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43645 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751779AbcJRHwb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2016 03:52:31 -0400
In-Reply-To: <1476774332.8490.43.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: Zhu Lingshan <lszhu@suse.com>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2016-10-18 at 00:05 -0700, Nicholas A. Bellinger wrote:
> Hello Robert, Zhu & Co,
> 
> Thanks for your detailed bug report.  Comments inline below.
> 
> On Mon, 2016-10-17 at 22:42 -0600, Robert LeBlanc wrote:
> > Sorry I forget that Android has an aversion to plain text emails.
> > 
> > If we can provide any information to help, let us know. We are willing
> > to patch in more debug statements or whatever you think might help.
> > Today has been a difficult day. Thanks for looking into it, I tried
> > looking at it, but it is way over my head.
> > 
> > ----------------
> > Robert LeBlanc
> > PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> > 
> > 
> > On Mon, Oct 17, 2016 at 9:06 PM, Zhu Lingshan <lszhu@suse.com> wrote:
> > > Hi Robert,
> > >
> > > I think the reason why you can not logout the targets is that iscsi_np in D
> > > status. I think the patches fixed something, but it seems to be more than
> > > one code path can trigger these similar issues. as you can see, there are
> > > several call stacks, I am still working on it. Actually in my environment I
> > > see there is another call stack not listed in your mail....
> > >
> > > Thanks,
> > > BR
> > > Zhu Lingshan
> > >
> > >
> > > On 10/18/2016 03:11 AM, Robert LeBlanc wrote:
> > >>
> > >> Sorry hit send too soon.
> > >>
> > >> In addition, on the client we see:
> > >> # ps -aux | grep D | grep kworker
> > >> root      5583  0.0  0.0      0     0 ?        D    11:55   0:03
> > >> [kworker/11:0]
> > >> root      7721  0.1  0.0      0     0 ?        D    12:00   0:04
> > >> [kworker/4:25]
> > >> root     10877  0.0  0.0      0     0 ?        D    09:27   0:00
> > >> [kworker/22:1]
> > >> root     11246  0.0  0.0      0     0 ?        D    10:28   0:00
> > >> [kworker/30:2]
> > >> root     14034  0.0  0.0      0     0 ?        D    12:20   0:02
> > >> [kworker/19:15]
> > >> root     14048  0.0  0.0      0     0 ?        D    12:20   0:00
> > >> [kworker/16:0]
> > >> root     15871  0.0  0.0      0     0 ?        D    12:25   0:00
> > >> [kworker/13:0]
> > >> root     17442  0.0  0.0      0     0 ?        D    12:28   0:00
> > >> [kworker/9:1]
> > >> root     17816  0.0  0.0      0     0 ?        D    12:30   0:00
> > >> [kworker/11:1]
> > >> root     18744  0.0  0.0      0     0 ?        D    12:32   0:00
> > >> [kworker/10:2]
> > >> root     19060  0.0  0.0      0     0 ?        D    12:32   0:00
> > >> [kworker/29:0]
> > >> root     21748  0.0  0.0      0     0 ?        D    12:40   0:00
> > >> [kworker/21:0]
> > >> root     21967  0.0  0.0      0     0 ?        D    12:40   0:00
> > >> [kworker/22:0]
> > >> root     21978  0.0  0.0      0     0 ?        D    12:40   0:00
> > >> [kworker/22:2]
> > >> root     22024  0.0  0.0      0     0 ?        D    12:40   0:00
> > >> [kworker/22:4]
> > >> root     22035  0.0  0.0      0     0 ?        D    12:40   0:00
> > >> [kworker/22:5]
> > >> root     22060  0.0  0.0      0     0 ?        D    12:40   0:00
> > >> [kworker/16:1]
> > >> root     22282  0.0  0.0      0     0 ?        D    12:41   0:00
> > >> [kworker/26:0]
> > >> root     22362  0.0  0.0      0     0 ?        D    12:42   0:00
> > >> [kworker/18:9]
> > >> root     22426  0.0  0.0      0     0 ?        D    12:42   0:00
> > >> [kworker/16:3]
> > >> root     23298  0.0  0.0      0     0 ?        D    12:43   0:00
> > >> [kworker/12:1]
> > >> root     23302  0.0  0.0      0     0 ?        D    12:43   0:00
> > >> [kworker/12:5]
> > >> root     24264  0.0  0.0      0     0 ?        D    12:46   0:00
> > >> [kworker/30:1]
> > >> root     24271  0.0  0.0      0     0 ?        D    12:46   0:00
> > >> [kworker/14:8]
> > >> root     24441  0.0  0.0      0     0 ?        D    12:47   0:00
> > >> [kworker/9:7]
> > >> root     24443  0.0  0.0      0     0 ?        D    12:47   0:00
> > >> [kworker/9:9]
> > >> root     25005  0.0  0.0      0     0 ?        D    12:48   0:00
> > >> [kworker/30:3]
> > >> root     25158  0.0  0.0      0     0 ?        D    12:49   0:00
> > >> [kworker/9:12]
> > >> root     26382  0.0  0.0      0     0 ?        D    12:52   0:00
> > >> [kworker/13:2]
> > >> root     26453  0.0  0.0      0     0 ?        D    12:52   0:00
> > >> [kworker/21:2]
> > >> root     26724  0.0  0.0      0     0 ?        D    12:53   0:00
> > >> [kworker/19:1]
> > >> root     28400  0.0  0.0      0     0 ?        D    05:20   0:00
> > >> [kworker/25:1]
> > >> root     29552  0.0  0.0      0     0 ?        D    11:40   0:00
> > >> [kworker/17:1]
> > >> root     29811  0.0  0.0      0     0 ?        D    11:40   0:00
> > >> [kworker/7:10]
> > >> root     31903  0.0  0.0      0     0 ?        D    11:43   0:00
> > >> [kworker/26:1]
> > >>
> > >> And all of the processes have this stack:
> > >> [<ffffffffa0727ed5>] iser_release_work+0x25/0x60 [ib_iser]
> > >> [<ffffffff8109633f>] process_one_work+0x14f/0x400
> > >> [<ffffffff81096bb4>] worker_thread+0x114/0x470
> > >> [<ffffffff8109c6f8>] kthread+0xd8/0xf0
> > >> [<ffffffff8172004f>] ret_from_fork+0x3f/0x70
> > >> [<ffffffffffffffff>] 0xffffffffffffffff
> > >>
> > >> We are not able to log out of the sessions in all cases. And have to
> > >> restart the box.
> > >>
> > >> iscsiadm -m session will show messages like:
> > >> iscsiadm: could not read session targetname: 5
> > >> iscsiadm: could not find session info for session100
> > >> iscsiadm: could not read session targetname: 5
> > >> iscsiadm: could not find session info for session101
> > >> iscsiadm: could not read session targetname: 5
> > >> iscsiadm: could not find session info for session103
> > >> ...
> > >>
> > >> I can't find any way to force iscsiadm to clean up these sessions
> > >> possibly due to tasks in D state.
> > >> ----------------
> > >> Robert LeBlanc
> > >> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> > >>
> > >>
> > >> On Mon, Oct 17, 2016 at 10:32 AM, Robert LeBlanc <robert@leblancnet.us>
> > >> wrote:
> > >>>
> > >>> Some more info as we hit this this morning. We have volumes mirrored
> > >>> between two targets and we had one target on the kernel with the three
> > >>> patches mentioned in this thread [0][1][2] and the other was on a
> > >>> kernel without the patches. We decided that after a week and a half we
> > >>> wanted to get both targets on the same kernel so we rebooted the
> > >>> non-patched target. Within an hour we saw iSCSI in D state with the
> > >>> same stack trace so it seems that we are not hitting any of the
> > >>> WARN_ON lines. We are getting both iscsi_trx and iscsi_np both in D
> > >>> state, this time we have two iscsi_trx processes in D state. I don't
> > >>> know if stale sessions on the clients could be contributing to this
> > >>> issue (the target trying to close non-existent sessions??). This is on
> > >>> 4.4.23. Any more debug info we can throw at this problem to help?
> > >>>
> > >>> Thank you,
> > >>> Robert LeBlanc
> > >>>
> > >>> # ps aux | grep D | grep iscsi
> > >>> root     16525  0.0  0.0      0     0 ?        D    08:50   0:00
> > >>> [iscsi_np]
> > >>> root     16614  0.0  0.0      0     0 ?        D    08:50   0:00
> > >>> [iscsi_trx]
> > >>> root     16674  0.0  0.0      0     0 ?        D    08:50   0:00
> > >>> [iscsi_trx]
> > >>>
> > >>> # for i in 16525 16614 16674; do echo $i; cat /proc/$i/stack; done
> > >>> 16525
> > >>> [<ffffffff814f0d5f>] iscsit_stop_session+0x19f/0x1d0
> > >>> [<ffffffff814e2516>] iscsi_check_for_session_reinstatement+0x1e6/0x270
> > >>> [<ffffffff814e4ed0>] iscsi_target_check_for_existing_instances+0x30/0x40
> > >>> [<ffffffff814e5020>] iscsi_target_do_login+0x140/0x640
> > >>> [<ffffffff814e63bc>] iscsi_target_start_negotiation+0x1c/0xb0
> > >>> [<ffffffff814e410b>] iscsi_target_login_thread+0xa9b/0xfc0
> > >>> [<ffffffff8109c748>] kthread+0xd8/0xf0
> > >>> [<ffffffff8172018f>] ret_from_fork+0x3f/0x70
> > >>> [<ffffffffffffffff>] 0xffffffffffffffff
> > >>> 16614
> > >>> [<ffffffff814cca79>] target_wait_for_sess_cmds+0x49/0x1a0
> > >>> [<ffffffffa064692b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
> > >>> [<ffffffff814f0ef2>] iscsit_close_connection+0x162/0x870
> > >>> [<ffffffff814df9bf>] iscsit_take_action_for_connection_exit+0x7f/0x100
> > >>> [<ffffffff814f00a0>] iscsi_target_rx_thread+0x5a0/0xe80
> > >>> [<ffffffff8109c748>] kthread+0xd8/0xf0
> > >>> [<ffffffff8172018f>] ret_from_fork+0x3f/0x70
> > >>> [<ffffffffffffffff>] 0xffffffffffffffff
> > >>> 16674
> > >>> [<ffffffff814cca79>] target_wait_for_sess_cmds+0x49/0x1a0
> > >>> [<ffffffffa064692b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
> > >>> [<ffffffff814f0ef2>] iscsit_close_connection+0x162/0x870
> > >>> [<ffffffff814df9bf>] iscsit_take_action_for_connection_exit+0x7f/0x100
> > >>> [<ffffffff814f00a0>] iscsi_target_rx_thread+0x5a0/0xe80
> > >>> [<ffffffff8109c748>] kthread+0xd8/0xf0
> > >>> [<ffffffff8172018f>] ret_from_fork+0x3f/0x70
> > >>> [<ffffffffffffffff>] 0xffffffffffffffff
> > >>>
> > >>>
> > >>> [0] https://www.spinics.net/lists/target-devel/msg13463.html
> > >>> [1] http://marc.info/?l=linux-scsi&m=147282568910535&w=2
> > >>> [2] http://www.spinics.net/lists/linux-scsi/msg100221.html
> 
> The call chain above is iscsi session reinstatement driven by
> open-iscsi/iser resulting in target-core to sleep indefinitely, waiting
> for outstanding target-core backend driver se_cmd I/O to complete in
> order to make forward progress.
> 
> Note, there is a v4.1+ se_cmd->cmd_kref reference leak bug for
> TMR ABORT_TASK during simultaneous target back-end I/O completion
> timeouts here:
> 
> http://www.spinics.net/lists/target-devel/msg13530.html
> 
> If you are actively observing TMR ABORT_TASK preceding the hung task
> timeout warnings above with v4.4.y + v4.2.y iser-target exports, then
> it's likely the same bug.  Please apply the patch on your v4.x setup to
> verify.
> 
> If no TMR ABORT_TASK timeouts + session reinstatements are occurring on
> your iser-target setup, then it is a separate bug.
> 

To clarify a bit more..

Using a v4.1.26+ kernel with traditional iscsi-target exports and patch
in place, I can confirm iscsi-target is able to successfully invoke
configfs network portal group delete via syscall:

   rmdir /sys/kernel/config/target/iscsi/$IQN/$TPGT/np/$IPv4:$PORT

after TMR ABORT_TASKs due to backend I/O timeout + iscsi session
reinstatement scenario have occurred. 

