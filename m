From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Tue, 12 May 2009 09:03:31 GMT
Message-ID: <200905120903.n4C93VIc026067@demeter.kernel.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58745 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbZELJDa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2009 05:03:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4C93VOC026068
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2009 09:03:31 GMT
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646


Ronan Guilfoyle <ronan.guilfoyle@modeva.ie> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ronan.guilfoyle@modeva.ie




--- Comment #26 from Ronan Guilfoyle <ronan.guilfoyle@modeva.ie>  2009-05-12 09:03:28 ---
I had a similar crash last night.
I'm running Ubuntu 8.04, 2.6.24-23-server.

This is an IBM HS21 (Type 8853), with Q-Logic FC adapter.

The system runs MySQL in a heartbeat controlled failover pair with databases on
the SAN.

This error caused a failover but not all of the MySQL transactions were written
to disk.  The backup came up fine but with out of date data causing the slave
to fail because it could not read the correct log position.

I'd appreciate any help with (or links to) replacing integrated qla2xxx drivers
with official rpm ones.

Thanks,
Ronan Guilfoyle

Syslog below,  

May 11 20:17:01 DB1 /USR/SBIN/CRON[7036]: (root) CMD (   cd / && run-parts
--report /etc/cron.hourly)
May 11 20:22:35 DB1 kernel: [3036897.727183] APIC error on CPU1: 00(40)
May 11 20:23:48 DB1 kernel: [3036970.605923] qla2xxx 0000:08:01.1: Mailbox
command timeout occured. Issuing ISP abort.
May 11 20:23:48 DB1 kernel: [3036970.605930] qla2xxx 0000:08:01.1: Performing
ISP error recovery - ha= ffff810222830460.
May 11 20:23:50 DB1 kernel: [3036972.456812] qla2xxx 0000:08:01.1: LOOP UP
detected (4 Gbps).
May 11 20:23:50 DB1 kernel: [3036972.716091] qla2xxx 0000:08:01.1: SNS scan
failed -- assuming zero-entry result...
May 11 20:23:50 DB1 kernel: [3036972.756011] APIC error on CPU6: 00(40)
May 11 20:23:50 DB1 kernel: [3036972.775938] qla2xxx 0000:08:01.1:
scsi(1:1:10): Abort command issued -- 0 5fe51b 2002.
May 11 20:24:23 DB1 kernel: [3037005.515447]  rport-1:0-0: blocked FC remote
port time out: saving binding
May 11 20:24:23 DB1 kernel: [3037005.515512]  rport-1:0-1: blocked FC remote
port time out: saving binding
May 11 20:24:23 DB1 kernel: [3037006.019805] qla2xxx 0000:08:01.1:
scsi(1:1:10): DEVICE RESET ISSUED.
May 11 20:24:53 DB1 kernel: [3037035.942217] qla2xxx 0000:08:01.1: Mailbox
command timeout occured. Issuing ISP abort.
May 11 20:24:53 DB1 kernel: [3037035.942223] qla2xxx 0000:08:01.1: Performing
ISP error recovery - ha= ffff810222830460.
May 11 20:24:55 DB1 kernel: [3037037.801242] qla2xxx 0000:08:01.1: LOOP UP
detected (4 Gbps).
May 11 20:28:30 DB1 syslogd 1.5.0#1ubuntu1: restart.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
