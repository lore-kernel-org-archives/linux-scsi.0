From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93951] New: Multipath hangs if Active Alua path stops
 responding (timeouts)
Date: Fri, 27 Feb 2015 16:48:24 +0000
Message-ID: <bug-93951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49405 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbbB0Qs2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2015 11:48:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 661AE20270
	for <linux-scsi@vger.kernel.org>; Fri, 27 Feb 2015 16:48:27 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 613792025B
	for <linux-scsi@vger.kernel.org>; Fri, 27 Feb 2015 16:48:25 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=93951

            Bug ID: 93951
           Summary: Multipath hangs if Active Alua path stops responding
                    (timeouts)
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.10.0-123.el7.x86_64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: probeless@msn.com
        Regression: No

We are observing multipath hanging if the Active path of an Active/Optimized -
Standby ALUA SAS LUN stops responding to SCSI commands (constant timeouts).

To summarize our setup, the storage device is connected via SAS and supports
ALUA Active/Optimized and Standby states.  A typical user configuration would
have 2 paths to each LUN.  One path would be Active/Optimized and the other
path would be in the Standby state.  

Below is our current multipath.conf settings that was used to collect the
latest set of logs.  Note, some of settings we set in attempt to work around
the issue but did not seem to have any effect.

 devices {
    device {
        vendor XXXXX
        product "XXXXX Vol"
        path_checker tur
        prio alua
        path_grouping_policy group_by_prio
    features "2 pg_init_retries 50"
        hardware_handler "1 alua"
        failback immediate
        rr_weight priorities
    no_path_retry 5
    dev_loss_tmo 60
    path_selector "service-time 0"
    }


When everything is operating nominally, "multipath -ll" shows the expected 2
paths to each LUN, the Active/Optimized path has a priority of 50, and the
Standby path has a priority of 1.  Example:

mpathi (36000d31001108300000000000000003b) dm-9 XXXXX,XXXXX Vol  
size=500G features='3 queue_if_no_path pg_init_retries 50' hwhandler='1 alua'
wp=rw
|-+- policy='service-time 0' prio=50 status=active
| `- 1:0:1:7  sdr 65:16 active ready running
`-+- policy='service-time 0' prio=1 status=enabled
  `- 1:0:0:7  sdh 8:112 active ready running

/var/log/messages shows the path_checker running every ~5 seconds as expected:
Feb 24 13:18:22 localhost multipathd: sdr: path state = running
Feb 24 13:18:22 localhost multipathd: sdr: get_state
Feb 24 13:18:22 localhost multipathd: 65:16: tur checker starting up
Feb 24 13:18:22 localhost multipathd: 65:16: tur checker finished, state up
Feb 24 13:18:22 localhost multipathd: sdr: state = up
Feb 24 13:18:22 localhost multipathd: mpathi: disassemble map [3
queue_if_no_path pg_init_retries 50 1 alua 2 1 service-time 0 1 2 65:16 50 1
service-time 0 1 2 8:112 1 1 ]
Feb 24 13:18:22 localhost multipathd: mpathi: disassemble status [2 0 1 0 2 1 A
0 1 2 65:16 A 0 0 1 E 0 1 2 8:112 A 0 0 1 ]
Feb 24 13:18:22 localhost multipathd: sdr: mask = 0x8
Feb 24 13:18:22 localhost multipathd: sdr: path state = running
Feb 24 13:18:22 localhost multipathd: reported target port group is 61447
Feb 24 13:18:22 localhost multipathd: aas = 00 [active/optimized]
Feb 24 13:18:22 localhost multipathd: sdr: alua prio = 50
....
Feb 24 13:18:22 localhost multipathd: sdh: path state = running
Feb 24 13:18:22 localhost multipathd: sdh: get_state
Feb 24 13:18:22 localhost multipathd: 8:112: tur checker starting up
Feb 24 13:18:22 localhost multipathd: 8:112: tur checker finished, state up
Feb 24 13:18:22 localhost multipathd: sdh: state = up
Feb 24 13:18:22 localhost multipathd: mpathi: disassemble map [3
queue_if_no_path pg_init_retries 50 1 alua 2 1 service-time 0 1 2 65:16 50 1
service-time 0 1 2 8:112 1 1 ]
Feb 24 13:18:22 localhost multipathd: mpathi: disassemble status [2 0 1 0 2 1 A
0 1 2 65:16 A 0 0 1 E 0 1 2 8:112 A 0 0 1 ]
Feb 24 13:18:22 localhost multipathd: sdh: mask = 0x8
Feb 24 13:18:22 localhost multipathd: sdh: path state = running
Feb 24 13:18:22 localhost multipathd: reported target port group is 61461
Feb 24 13:18:22 localhost multipathd: aas = 02 [standby]
Feb 24 13:18:22 localhost multipathd: sdh: alua prio = 1

Now if the Active/Optimized path suddenly stops responding to I/O, causing
timeouts forever, multipath hangs including the path_checker.  The hang is
observed by all multipath and multipathd commands hang, and there are no longer
any path checker logs messages.  The below messages occur over and over again
showing the active path not responding to I/O.

Feb 24 13:39:42 localhost kernel: scsi target1:0:1:
enclosure_logical_id(0x5b083fe0ead0a900), slot(4)
Feb 24 13:39:46 localhost kernel: sd 1:0:1:7: task abort: SUCCESS
scmd(ffff8804661f4540)
Feb 24 13:39:46 localhost kernel: sd 1:0:1:7: attempting task abort!
scmd(ffff8804661f7480)
Feb 24 13:39:46 localhost kernel: sd 1:0:1:7: [sdr] CDB: 
Feb 24 13:39:46 localhost kernel: Write(10): 2a 00 00 01 e1 c0 00 04 00 00
Feb 24 13:39:46 localhost kernel: scsi target1:0:1: handle(0x000a),
sas_address(0x5000d31001108307), phy(4)
Feb 24 13:39:46 localhost kernel: scsi target1:0:1:
enclosure_logical_id(0x5b083fe0ead0a900), slot(4)

The hang seems to occur indefinetly until the devices are offlined through some
other means and multipath then resumes execution.

It is our expectation, the Active/Optimized path would eventually fail and I/O
would then be attempted down the Standby path. Or it is our expectation the
path checker would run, and in this case the TUR would fail to the
Active/Optimized path, and the Standby path would have transitioned to
Active/Optimized=priority 50.  Is this a false expectation and/or why does
multipath hang during this time?

-- 
You are receiving this mail because:
You are the assignee for the bug.
