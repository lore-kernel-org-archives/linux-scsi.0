From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16558] New: iSCSI Connection / Stability Problems
Date: Tue, 10 Aug 2010 23:31:19 GMT
Message-ID: <bug-16558-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58522 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab0HJXbW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2010 19:31:22 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7ANVKdH020458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2010 23:31:20 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16558

           Summary: iSCSI Connection / Stability Problems
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.32-02063215
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: peepstein@gmail.com
        Regression: No


Created an attachment (id=27400)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=27400)
Output of lspci -vv and dmesg

Hi All,  I am using the Atto Xtend SAN Initiator on a couple of Mac OS X
computers (one desktop, one laptop).  I've also tried using the globalSAN
initiator on the laptop and with both initiators I've had the same problem.

The target is running on a fresh Ubuntu Server 10.04.1 install, and I have the
problem regardless of whether I run the Ubuntu kernel (2.6.32-24-server) or the
mainline kernel from the Ubuntu Mainline package (2.6.32-02063215).

The server hardware is a new build of new components and I am trying to rule
out flaky hardware as well so if you see anything that might indicate that
please let me know.

I have the same problem regardless of whether I use my PCI Intel Gigabit NIC or
the PCI-Express built-in Realtek NIC. I've also installed and tried with the
latest drivers downloaded from the Realtek site.

I've tried with both the standalone iscsi-target 1.4.20.2 kernel module and
with the tgt userspace iSCSI tool without the iscsi-target module-- so using
whatever kernel hooks exist for iSCSI that, I believe, have been in the kernel
since 2.6.20 (according to stgt.sourceforge.net).

Along with the symptom of losing my iSCSI connection, of course, I see this
sort of thing in my kern.log:

Aug  7 10:37:21 robot kernel: [49647.372558] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(200) exp_cmd_sn(202) max_cmd_sn(0)
Aug  7 10:37:21 robot kernel: [49647.383599] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(201) exp_cmd_sn(202) max_cmd_sn(0)
Aug  7 15:36:15 robot kernel: [67173.945360] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(1863) exp_cmd_sn(1864) max_cmd_sn(0)
Aug  7 15:36:18 robot kernel: [67176.440027] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(21064) exp_cmd_sn(21066) max_cmd_sn(0)
Aug  7 15:36:18 robot kernel: [67176.441095] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(21065) exp_cmd_sn(21066) max_cmd_sn(0)
Aug  7 16:27:53 robot kernel: [70272.008883] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(2817) exp_cmd_sn(2818) max_cmd_sn(0)
Aug  7 16:30:44 robot kernel: [70443.114556] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(2855) exp_cmd_sn(2856) max_cmd_sn(0)
Aug  7 19:36:57 robot kernel: [81616.310002] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(38980) exp_cmd_sn(38993) max_cmd_sn(0)
Aug  7 19:36:57 robot kernel: [81616.320817] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(38981) exp_cmd_sn(38993) max_cmd_sn(0)
Aug  7 19:36:57 robot kernel: [81616.332909] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(38982) exp_cmd_sn(38993) max_cmd_sn(0)
Aug  7 19:36:57 robot kernel: [81616.343656] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(38983) exp_cmd_sn(38993) max_cmd_sn(0)
Aug  7 19:36:58 robot kernel: [81616.352255] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(38984) exp_cmd_sn(38993) max_cmd_sn(0)
Aug  7 19:36:58 robot kernel: [81616.373330] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(38985) exp_cmd_sn(38993) max_cmd_sn(0)
Aug  7 19:36:58 robot kernel: [81616.382273] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(38986) exp_cmd_sn(38993) max_cmd_sn(0)
Aug  7 19:36:58 robot kernel: [81616.382273] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(38987) exp_cmd_sn(38993) max_cmd_sn(0)
Aug  7 19:36:58 robot kernel: [81616.382273] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(38988) exp_cmd_sn(38993) max_cmd_sn(0)
Aug  7 19:36:58 robot kernel: [81616.382273] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(38989) exp_cmd_sn(38993) max_cmd_sn(0)
Aug  7 19:36:58 robot kernel: [81616.382273] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(38990) exp_cmd_sn(38993) max_cmd_sn(0)
Aug  7 19:36:58 robot kernel: [81616.382273] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(38991) exp_cmd_sn(38993) max_cmd_sn(0)
Aug  7 19:36:58 robot kernel: [81616.382273] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(38992) exp_cmd_sn(38993) max_cmd_sn(0)
Aug  7 19:39:05 robot kernel: [81744.120085] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(71184) exp_cmd_sn(71185) max_cmd_sn(0)
Aug  7 20:00:13 robot kernel: [83011.830886] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(1) exp_cmd_sn(0) max_cmd_sn(0)
Aug  7 20:03:19 robot kernel: [83197.481900] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(85037) exp_cmd_sn(85038) max_cmd_sn(0)
Aug  7 20:03:47 robot kernel: [83225.874178] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(85047) exp_cmd_sn(85048) max_cmd_sn(0)
Aug  7 20:03:47 robot kernel: [83225.874199] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(85047) exp_cmd_sn(85048) max_cmd_sn(0)
Aug  7 20:04:04 robot kernel: [83243.068396] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(85052) exp_cmd_sn(85053) max_cmd_sn(0)
Aug  7 20:04:04 robot kernel: [83243.068396] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(85052) exp_cmd_sn(85053) max_cmd_sn(0)
Aug  7 20:09:27 robot kernel: [83565.852475] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(85159) exp_cmd_sn(85160) max_cmd_sn(0)
Aug  7 20:14:30 robot kernel: [83868.657851] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(85265) exp_cmd_sn(85266) max_cmd_sn(0)
Aug  7 20:16:29 robot kernel: [83987.606834] iscsi_trgt: check_cmd_sn(549)
sequence error: cmd_sn(85305) exp_cmd_sn(85306) max_cmd_sn(0)



Aug  9 21:07:23 robot kernel: [ 1007.350013] iscsi_trgt: scsi_cmnd_start(949)
1002 0
Aug  9 21:07:23 robot kernel: [ 1007.350013] iscsi_trgt: cmnd_skip_pdu(459)
1002 1c 0 0
Aug  9 21:07:38 robot kernel: [ 1022.050061] iscsi_trgt: scsi_cmnd_start(949)
1002 0
Aug  9 21:07:38 robot kernel: [ 1022.050061] iscsi_trgt: cmnd_skip_pdu(459)
1002 1c 0 0
Aug  9 21:07:46 robot kernel: [ 1030.450119] iscsi_trgt: scsi_cmnd_start(949)
1002 0
Aug  9 21:07:46 robot kernel: [ 1030.450119] iscsi_trgt: cmnd_skip_pdu(459)
1002 1c 0 0
Aug  9 21:08:07 robot kernel: [ 1051.320081] iscsi_trgt: scsi_cmnd_start(949)
1002 0
Aug  9 21:08:07 robot kernel: [ 1051.320081] iscsi_trgt: cmnd_skip_pdu(459)
1002 1c 0 0
Aug  9 21:08:21 robot kernel: [ 1065.170089] iscsi_trgt: scsi_cmnd_start(949)
1002 0
Aug  9 21:08:21 robot kernel: [ 1065.170089] iscsi_trgt: cmnd_skip_pdu(459)
1002 1c 0 0
Aug  9 21:08:26 robot kernel: [ 1069.730090] iscsi_trgt: scsi_cmnd_start(949)
1002 0
Aug  9 21:08:26 robot kernel: [ 1069.730090] iscsi_trgt: cmnd_skip_pdu(459)
1002 1c 0 0
Aug  9 21:08:51 robot kernel: [ 1095.600121] iscsi_trgt: scsi_cmnd_start(949)
1002 0
Aug  9 21:08:51 robot kernel: [ 1095.600121] iscsi_trgt: cmnd_skip_pdu(459)
1002 1c 0 0

Aug  9 21:10:27 robot kernel: [ 1191.160556] iscsi_trgt: scsi_cmnd_start(1045)
Unsupported 5a
Aug  9 21:10:27 robot kernel: [ 1191.160556] iscsi_trgt: cmnd_skip_pdu(459)
101f 1c 5a 0
Aug  9 21:14:57 robot kernel: [ 1461.144821] iscsi_trgt: scsi_cmnd_start(1045)
Unsupported 5a
Aug  9 21:14:57 robot kernel: [ 1461.144821] iscsi_trgt: cmnd_skip_pdu(459)
101f 1c 5a 0
Aug  9 21:19:25 robot kernel: [ 1729.057073] iscsi_trgt: cmnd_rx_start(1849) 1
117a -7
Aug  9 21:19:25 robot kernel: [ 1729.070381] iscsi_trgt: cmnd_skip_pdu(459)
117a 1 2a 8192


I've had quite a few other problems surrounding my server, but they all relate
to iSCSI usage (that is the only use of the server).

I've had to be booting with notsc hpet=disable and clocksource=acpi_pm because
of other errors and wonkyness I've had related to timing.  I've also had some
weirdness related to a Promise SATA 300TX4 PCI card, so I've removed it from
the system for now.

Let me know if you think I should create a kernel bug as well at the kernel
bugzilla.

Helpful output attached.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
