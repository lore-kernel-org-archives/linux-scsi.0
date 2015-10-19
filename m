From: Chris Boot <bootc@bootc.net>
Subject: qla2xxx firmware crashes in target mode
Date: Mon, 19 Oct 2015 09:19:55 +0100
Message-ID: <5624A7AB.7070907@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi folks,

So this is a bit of a strange situation I'm in, where my *target*
qla2xxx firmware appears to get stuck when the *initiator* kernel is 4.1+.

The target is an Intel system with a QLE2464 running kernel 4.2.1 (from
Debian) and using fw=7.03.00. The initiator is another Intel system with
a QLE2460 and using fw=7.03.00. They are connected by direct fibre link,
there are no switches / fabric involved.

The initiator and target are both stable when the initiator is running
kernel 4.0 or lower. When the initiator is running a 4.1 or 4.2 kernel,
the *target* firmware becomes unstable and the initiator times out IOs
and generally becomes very unhappy.

When booting a 4.1+ kernel on the initiator, everything appears to work
well for a little while (up to an hour or so) before the issue manifests
itself. At some point I see the "ISP System Error" message and IO locks
up. To get out of this situation I need to reboot the initiator; the
target appears to recover by itself.

Do you know about this issue? I can debug further (e.g. try to bisect
it?) if required but no point if you know about it already.

dmesg from the target end (I haven't been able to capture the initiator
end):

[484701.194971] qla2xxx [0000:05:00.0]-5003:9: ISP System Error -
mbx1=c19h mbx2=10h mbx3=0h mbx7=0h.
[484701.222021] qla2xxx [0000:05:00.0]-d001:9: Firmware dump saved to
temp buffer (9/ffffc90002b84000), dump status flags (0x3f).
[484701.222082] qla2xxx [0000:05:00.0]-00af:9: Performing ISP error
recovery - ha=ffff8800ab7c4000.
[484702.063799] qla2xxx [0000:05:00.0]-500a:9: LOOP UP detected (4 Gbps).
[484702.112814] qla2xxx [0000:05:00.0]-0121:9: Failed to enable
receiving of RSCN requests: 0x2.
[484702.743687] qla2xxx [0000:05:00.0]-5003:9: ISP System Error -
mbx1=c19h mbx2=10h mbx3=0h mbx7=0h.
[484702.754050] qla2xxx [0000:05:00.0]-d007:9: Firmware has been
previously dumped (ffffc90002b84000) -- ignoring request.
[484703.619362] qla2xxx [0000:05:00.0]-00af:9: Performing ISP error
recovery - ha=ffff8800ab7c4000.
[484704.459181] qla2xxx [0000:05:00.0]-500a:9: LOOP UP detected (4 Gbps).
[484704.508170] qla2xxx [0000:05:00.0]-0121:9: Failed to enable
receiving of RSCN requests: 0x2.
[484704.854664] qla2xxx [0000:05:00.0]-5003:9: ISP System Error -
mbx1=c19h mbx2=10h mbx3=0h mbx7=0h.
[484704.865014] qla2xxx [0000:05:00.0]-d007:9: Firmware has been
previously dumped (ffffc90002b84000) -- ignoring request.
[484734.867554] qla2xxx [0000:05:00.0]-d007:9: Firmware has been
previously dumped (ffffc90002b84000) -- ignoring request.
[484764.883993] qla2xxx [0000:05:00.0]-d007:9: Firmware has been
previously dumped (ffffc90002b84000) -- ignoring request.
[484794.900464] qla2xxx [0000:05:00.0]-d007:9: Firmware has been
previously dumped (ffffc90002b84000) -- ignoring request.
[484824.916954] qla2xxx [0000:05:00.0]-d007:9: Firmware has been
previously dumped (ffffc90002b84000) -- ignoring request.
[484854.933415] qla2xxx [0000:05:00.0]-d007:9: Firmware has been
previously dumped (ffffc90002b84000) -- ignoring request.
[484884.953887] qla2xxx [0000:05:00.0]-d007:9: Firmware has been
previously dumped (ffffc90002b84000) -- ignoring request.
[484914.974377] qla2xxx [0000:05:00.0]-d007:9: Firmware has been
previously dumped (ffffc90002b84000) -- ignoring request.
[484918.761483] INFO: task kworker/2:17:36759 blocked for more than 120
seconds.
[484918.778839]       Not tainted 4.2.0-0.bpo.1-amd64 #1
[484918.793941] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[484918.812578] kworker/2:17    D ffff88042e855840     0 36759      2
0x00000000
[484918.812597] Workqueue: qla_tgt_wq qlt_create_sess_from_atio [qla2xxx]
[484918.812607]  ffff880108076500 0000000000000046 ffff88009e473d80
ffff880107cef040
[484918.812613]  0000000000000286 ffff88009e474000 ffff880426a5f9a4
ffff880108076500
[484918.812624]  00000000ffffffff ffff880426a5f9a8 0000000000000296
ffffffff8154f26f
[484918.812626] Call Trace:
[484918.812632]  [<ffffffff8154f26f>] ? schedule+0x2f/0x70
[484918.812635]  [<ffffffff8154f51e>] ? schedule_preempt_disabled+0xe/0x20
[484918.812643]  [<ffffffff81550de5>] ? __mutex_lock_slowpath+0x85/0x100
[484918.812649]  [<ffffffff81550e7b>] ? mutex_lock+0x1b/0x30
[484918.812659]  [<ffffffffa0357d5a>] ?
qlt_create_sess_from_atio+0x12a/0x1c0 [qla2xxx]
[484918.812668]  [<ffffffff810866da>] ? process_one_work+0x14a/0x3d0
[484918.812671]  [<ffffffff810870c5>] ? worker_thread+0x65/0x470
[484918.812675]  [<ffffffff81087060>] ? rescuer_thread+0x2f0/0x2f0
[484918.812677]  [<ffffffff8108c543>] ? kthread+0xd3/0xf0
[484918.812680]  [<ffffffff8108c470>] ? kthread_create_on_node+0x170/0x170
[484918.812684]  [<ffffffff8155309f>] ? ret_from_fork+0x3f/0x70
[484918.812687]  [<ffffffff8108c470>] ? kthread_create_on_node+0x170/0x170
[484944.994831] qla2xxx [0000:05:00.0]-d007:9: Firmware has been
previously dumped (ffffc90002b84000) -- ignoring request.
[484975.019311] qla2xxx [0000:05:00.0]-d007:9: Firmware has been
previously dumped (ffffc90002b84000) -- ignoring request.
[484975.559187] qla2xxx [0000:05:00.0]-00af:9: Performing ISP error
recovery - ha=ffff8800ab7c4000.
[484976.430963] qla2xxx [0000:05:00.0]-500a:9: LOOP UP detected (4 Gbps).
[484976.448002] qla2xxx [0000:05:00.0]-0121:9: Failed to enable
receiving of RSCN requests: 0x2.

HTH,
Chris

-- 
Chris Boot
bootc@bootc.net
