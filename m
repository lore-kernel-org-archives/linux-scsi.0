From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121531] New: Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Wed, 06 Jul 2016 15:43:09 +0000
Message-ID: <bug-121531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46002 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbcGFPnP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jul 2016 11:43:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C79902014A
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2016 15:43:13 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0DC7B20142
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2016 15:43:10 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=121531

            Bug ID: 121531
           Summary: Adaptec 7805H SAS HBA (pm80xx): hangs when writing
                    >80MB at once
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.16.0-4-amd64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: martin.von.wittich@iserv.eu
        Regression: No

Created attachment 222171
  --> https://bugzilla.kernel.org/attachment.cgi?id=222171&action=edit
dd loop output, writing 64 - 128 MB to a disk

One of our customers attempted to install our Debian 8-based distribution on a
Fujitsu PRIMERGY TX150 S8 server with an Adaptec 7805H SAS HBA. Unfortunately,
the system tended to lock up during use; almost all services stopped
responding, but it was still possible to run simple commands via SSH, e.g. "ssh
server 'cat /proc/loadavg'" or "ssh server dmesg". Everything that required
write access (like actually logging in via SSH, or using the web interface)
just seemed to hang. Load average was extremely high (>100) and dmesg reported
a lot of sas/pm80xx errors:

[11748.246360] sas: trying to find task 0xffff88082fcc7d40
[11748.246362] sas: sas_scsi_find_task: aborting task 0xffff88082fcc7d40
[11748.246572] pm80xx mpi_ssp_completion 1514:sas IO status 0x1
[11748.246574] pm80xx mpi_ssp_completion 1523:SAS Address of IO Failure
Drive:5000c50062c1b09d
[11748.246576] sas: task done but aborted
[11748.246581] sas: sas_scsi_find_task: task 0xffff88082fcc7d40 is done
[11748.246583] sas: sas_eh_handle_sas_errors: task 0xffff88082fcc7d40 is done
[11748.246585] sas: trying to find task 0xffff88082fcc7c00
[11748.246587] sas: sas_scsi_find_task: aborting task 0xffff88082fcc7c00
[11748.246829] pm80xx mpi_ssp_completion 1514:sas IO status 0x1
[11748.246831] pm80xx mpi_ssp_completion 1523:SAS Address of IO Failure
Drive:5000c50062c1b09d
[11748.246832] sas: task done but aborted
[11748.246837] sas: sas_scsi_find_task: task 0xffff88082fcc7c00 is done
[11748.246839] sas: sas_eh_handle_sas_errors: task 0xffff88082fcc7c00 is done
[11748.246841] sas: trying to find task 0xffff88082fcc7ac0
[11748.246844] sas: sas_scsi_find_task: aborting task 0xffff88082fcc7ac0
[11748.247055] pm80xx mpi_ssp_completion 1514:sas IO status 0x1
[11748.247057] pm80xx mpi_ssp_completion 1523:SAS Address of IO Failure
Drive:5000c50062c1b09d
[11748.247059] sas: task done but aborted
[11748.247064] sas: sas_scsi_find_task: task 0xffff88082fcc7ac0 is done
[11748.247067] sas: sas_eh_handle_sas_errors: task 0xffff88082fcc7ac0 is done
[11748.247069] sas: trying to find task 0xffff88082fcc7840
[11748.247070] sas: sas_scsi_find_task: aborting task 0xffff88082fcc7840
[11748.247366] pm80xx mpi_ssp_completion 1514:sas IO status 0x1
[11748.247368] pm80xx mpi_ssp_completion 1523:SAS Address of IO Failure
Drive:5000c50062c1b09d
[11748.247370] sas: task done but aborted
[11748.247375] sas: sas_scsi_find_task: task 0xffff88082fcc7840 is done
[11748.247377] sas: sas_eh_handle_sas_errors: task 0xffff88082fcc7840 is done
[11748.247379] sas: trying to find task 0xffff88082ff72e00
[11748.247380] sas: sas_scsi_find_task: aborting task 0xffff88082ff72e00
[11748.247591] pm80xx mpi_ssp_completion 1514:sas IO status 0x1
[11748.247593] pm80xx mpi_ssp_completion 1523:SAS Address of IO Failure
Drive:5000c50062c1b09d
[11748.247595] sas: task done but aborted
[11748.247600] sas: sas_scsi_find_task: task 0xffff88082ff72e00 is done
[11748.247601] sas: sas_eh_handle_sas_errors: task 0xffff88082ff72e00 is done
[11748.247603] sas: trying to find task 0xffff88082ff72400
[11748.247605] sas: sas_scsi_find_task: aborting task 0xffff88082ff72400

At first we believed the underlying cause to be a hardware problem, but the
problem persisted after the HBA and the backplane were replaced (the disks were
ruled out as a possible cause because the selftests reported no errors).

To isolate the issue, I ran the following tests in a live system on the
affected server:

1) "smartctl -t long" on both disks; both reported "Completed", so the disks
seem to be OK.

2) "dd if=/dev/sdX of=/dev/null bs=1M" on both disks; both completed
successfully, with an average speed of ~150 MB/s. Reading seems to be fine too.

3) "dd if=/dev/zero of=/dev/sdX bs=1M" on both disks. It stopped responding,
and dmesg started spewing lots of sas/pm80xx errors. So apparently writing to
the disks causes the problem.

To track it down further, I tried to repeatedly write 64 MB to one disk - this
works without problems:

root@unassigned:~# for i in $(seq 1 8); do dd if=/dev/zero of=/dev/sdc bs=1M
count=64; done
64+0 records in
64+0 records out
67108864 bytes (67 MB) copied, 0.482716 s, 139 MB/s
64+0 records in
64+0 records out
67108864 bytes (67 MB) copied, 0.482339 s, 139 MB/s
64+0 records in
64+0 records out
67108864 bytes (67 MB) copied, 0.474302 s, 141 MB/s
64+0 records in
64+0 records out
67108864 bytes (67 MB) copied, 0.464919 s, 144 MB/s
64+0 records in
64+0 records out
67108864 bytes (67 MB) copied, 0.465673 s, 144 MB/s
64+0 records in
64+0 records out
67108864 bytes (67 MB) copied, 0.465525 s, 144 MB/s
64+0 records in
64+0 records out
67108864 bytes (67 MB) copied, 0.473932 s, 142 MB/s
64+0 records in
64+0 records out
67108864 bytes (67 MB) copied, 0.472965 s, 142 MB/s

Then I tried to write increasing amounts of data to the disk; this reproducibly
slows down at about ~80 MB. A few seconds later, dmesg starts spewing error
messages.

root@unassigned:~# for i in $(seq 64 128); do dd if=/dev/zero of=/dev/sdc bs=1M
count=$i; done
[...]
75+0 records in
75+0 records out
78643200 bytes (79 MB) copied, 0.595394 s, 132 MB/s
76+0 records in
76+0 records out
79691776 bytes (80 MB) copied, 33.6425 s, 2.4 MB/s
77+0 records in
77+0 records out
80740352 bytes (81 MB) copied, 0.631928 s, 128 MB/s
78+0 records in
78+0 records out
81788928 bytes (82 MB) copied, 0.621007 s, 132 MB/s
79+0 records in
79+0 records out
82837504 bytes (83 MB) copied, 0.651981 s, 127 MB/s
80+0 records in
80+0 records out
83886080 bytes (84 MB) copied, 0.674202 s, 124 MB/s
81+0 records in
81+0 records out
84934656 bytes (85 MB) copied, 33.7179 s, 2.5 MB/s
82+0 records in
82+0 records out
[...]

It seems to alternate between ~130 MB/sand 1-3 MB/s, and then completely hangs
after 96 records. See dd-loop.txt for the full output. The errors in dmesg:

[ 2645.124944] sas: Enter sas_scsi_recover_host busy: 146 failed: 146
[ 2645.124963] sas: trying to find task 0xffff88083658b200
[ 2645.124966] sas: sas_scsi_find_task: aborting task 0xffff88083658b200
[ 2647.457375] sas: task done but aborted
[ 2647.457382] sas: task done but aborted
[ 2647.457385] sas: task done but aborted
[ 2647.457833] sas: task done but aborted
[ 2647.457840] sas: task done but aborted
[ 2647.457843] sas: task done but aborted
[ 2647.457851] sas: task done but aborted
[ 2647.457853] sas: task done but aborted
[ 2647.457856] sas: task done but aborted
[ 2647.457860] sas: task done but aborted
[ 2647.457863] sas: task done but aborted 
[ 2647.457865] sas: task done but aborted
[ 2647.457867] sas: task done but aborted
[ 2647.457869] sas: task done but aborted
[ 2647.457872] sas: task done but aborted
[ 2647.457874] sas: task done but aborted 
[ 2647.457876] sas: task done but aborted
[ 2647.457879] sas: task done but aborted 
[ 2647.457881] sas: task done but aborted
[ 2647.457883] sas: task done but aborted 
[ 2647.457885] sas: task done but aborted
[ 2647.458125] pm80xx mpi_ssp_completion 1514:sas IO status 0x1
[ 2647.458130] pm80xx mpi_ssp_completion 1523:SAS Address of IO Failure
Drive:5000c50062c1b09d
[ 2647.458135] sas: task done but aborted 
[ 2647.458156] sas: sas_scsi_find_task: task 0xffff88083658b200 is done
[ 2647.458159] sas: sas_eh_handle_sas_errors: task 0xffff88083658b200 is done
[ 2647.458162] sas: trying to find task 0xffff880837ad30c0
[ 2647.458164] sas: sas_scsi_find_task: aborting task 0xffff880837ad30c0
[ 2647.458166] sas: sas_scsi_find_task: task 0xffff880837ad30c0 is done
[ 2647.458168] sas: sas_eh_handle_sas_errors: task 0xffff880837ad30c0 is done
[ 2647.458170] sas: trying to find task 0xffff880837ad3200
[ 2647.458172] sas: sas_scsi_find_task: aborting task 0xffff880837ad3200
[ 2647.458174] sas: sas_scsi_find_task: task 0xffff880837ad3200 is done
[ 2647.458176] sas: sas_eh_handle_sas_errors: task 0xffff880837ad3200 is done
[ 2647.458178] sas: trying to find task 0xffff880838dcfa80
[ 2647.458179] sas: sas_scsi_find_task: aborting task 0xffff880838dcfa80
[ 2647.458181] sas: sas_scsi_find_task: task 0xffff880838dcfa80 is done
[ 2647.458183] sas: sas_eh_handle_sas_errors: task 0xffff880838dcfa80 is done
[ 2647.458198] sas: trying to find task 0xffff880838d31700
[ 2647.458200] sas: sas_scsi_find_task: aborting task 0xffff880838d31700
[ 2647.458605] pm80xx mpi_ssp_completion 1514:sas IO status 0x1
[ 2647.458611] pm80xx mpi_ssp_completion 1523:SAS Address of IO Failure
Drive:5000c50062c1b09d
[ 2647.458616] sas: task done but aborted
[ 2647.458638] sas: sas_scsi_find_task: task 0xffff880838d31700 is done
[ 2647.458641] sas: sas_eh_handle_sas_errors: task 0xffff880838d31700 is done
[ 2647.458644] sas: trying to find task 0xffff880838ca6e80
[ 2647.458646] sas: sas_scsi_find_task: aborting task 0xffff880838ca6e80
[ 2647.459184] pm80xx mpi_ssp_completion 1514:sas IO status 0x1
[ 2647.459190] pm80xx mpi_ssp_completion 1523:SAS Address of IO Failure
Drive:5000c50062c1b09d
[ 2647.459194] sas: task done but aborted
[ 2647.459217] sas: sas_scsi_find_task: task 0xffff880838ca6e80 is done
[ 2647.459220] sas: sas_eh_handle_sas_errors: task 0xffff880838ca6e80 is done
[ 2647.459222] sas: trying to find task 0xffff88083658b480
[ 2647.459225] sas: sas_scsi_find_task: aborting task 0xffff88083658b480
[...]

To finally rule out a hardware issue, I installed Windows 10 onto one of the
disks and copied the Windows 10 installation image (~ 5 GB) from a USB stick
onto the first disk, then formatted the second disk too and copied the image on
that disk too. That worked without problems, so I'm pretty sure that this has
to be a bug in the Linux driver.

I'll attach full dmesg copies, dmidecode/lspci/smartctl/uname output after
filing this bug.

-- 
You are receiving this mail because:
You are the assignee for the bug.
