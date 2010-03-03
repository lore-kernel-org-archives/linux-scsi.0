From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Wed, 3 Mar 2010 09:37:40 GMT
Message-ID: <201003030937.o239beZF006261@demeter.kernel.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33912 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab0CCJhl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 04:37:41 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o239bera006262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 3 Mar 2010 09:37:40 GMT
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646


Bernd Zeimetz <bzed@debian.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bzed@debian.org




--- Comment #32 from Bernd Zeimetz <bzed@debian.org>  2010-03-03 09:37:28 ---
IBM x3950 machines crash badly enough due to this bug that they reboot
instantly after loading the qla2xxx module.

Feb 24 10:33:51 dbsrv01 kernel: [   64.184483] qla2xxx 0000:02:01.0: Performing
ISP error recovery - ha= ffff81086b4e85f8.
Feb 24 10:33:51 dbsrv01 kernel: [   64.324785] scsi(1): **** Load RISC code
****
Feb 24 10:33:52 dbsrv01 kernel: [   64.366386] scsi(1): Verifying Checksum of
loaded RISC code.
Feb 24 10:33:52 dbsrv01 kernel: [   64.605869] scsi(1): Checksum OK, start
firmware.
Feb 24 10:33:52 dbsrv01 kernel: [   65.357677] scsi(1): Issue init firmware.
Feb 24 10:33:55 dbsrv01 kernel: [   71.130990] scsi(2): Loop Down - aborting
the queues before time expire
Feb 24 10:33:56 dbsrv01 kernel: [   73.202082] qla2x00_mailbox_command(2):
timeout calling abort_isp
Feb 24 10:33:56 dbsrv01 kernel: [   73.238667] qla2x00_mailbox_command(2):
timeout calling abort_isp
Feb 24 10:33:56 dbsrv01 kernel: [   73.281349] qla2xxx 0000:10:01.0: Mailbox
command timeout occured. Issuing ISP abort.
Feb 24 10:33:56 dbsrv01 kernel: [   73.333347] qla2xxx 0000:10:01.0: Performing
ISP error recovery - ha= ffff81105ccf05f8.
Feb 24 10:34:12 dbsrv01 kernel: [   95.516679] qla2xxx 0000:02:01.0: Cable is
unplugged...
Feb 24 10:34:12 dbsrv01 kernel: [   95.516679] scsi(1): fw_state=4 curr
time=ffff208e.
Feb 24 10:34:12 dbsrv01 kernel: [   95.516679] scsi(1): Firmware ready ****
FAILED ****.
Feb 24 10:34:12 dbsrv01 kernel: [   95.516679] qla2x00_restart_isp(): Configure
loop done, status = 0x0
Feb 24 10:34:13 dbsrv01 kernel: [   95.516679] qla2xxx 0000:02:01.0: ISP System
Error - mbx1=65h mbx2=2h mbx3=8080h.
Feb 24 10:34:13 dbsrv01 kernel: [   95.516679] qla2xxx 0000:02:01.0: Firmware
dump saved to temp buffer (1/ffffc20007f84000).
Feb 24 10:34:13 dbsrv01 kernel: [   95.516679] qla2x00_abort_isp(1): exiting.
Feb 24 10:34:13 dbsrv01 kernel: [   95.516679] qla2x00_mailbox_command(1):
finished abort_isp
Feb 24 10:34:13 dbsrv01 kernel: [   95.516679] qla2x00_mailbox_command(1):
finished abort_isp
Feb 24 10:34:13 dbsrv01 kernel: [   95.545239] qla2x00_mailbox_command(1): ****
FAILED. mbx0=69, mbx1=8023, mbx2=ffff, cmd=69 ****
Feb 24 10:34:13 dbsrv01 kernel: [   95.613508] qla2x00_get_firmware_state(1):
failed=100.
Feb 24 10:34:13 dbsrv01 kernel: [   95.620441] scsi(1): fw_state=8023 curr
time=ffff2118.
Feb 24 10:34:13 dbsrv01 kernel: [   95.625500] scsi(1): Firmware ready ****
FAILED ****.
Feb 24 10:34:13 dbsrv01 kernel: [   95.687879] scsi(1): qla2x00_loop_resync -
end
Feb 24 10:34:13 dbsrv01 kernel: [   96.232463] scsi(1): dpc: sched
qla2x00_abort_isp ha = ffff81086b4e85f8
Feb 24 10:34:13 dbsrv01 kernel: [   96.232463] qla2xxx 0000:02:01.0: Performing
ISP error recovery - ha= ffff81086b4e85f8.
Feb 24 10:34:13 dbsrv01 kernel: [   96.236463] Calgary: DMA error on Calgary
PHB 0x2, 0x02010000@CSR 0x00008000@PLSSR


Running the kernel with pci=nomsi seems to work, although we didn't test it
under load yet. The issue is still happening in Debian's 2.6.32, but
interestingly not in the Kernels from Redhat, I guess they still ship this
patch:
http://launchpadlibrarian.net/17517188/linux-2.6-scsi-qla2xxx-disable-msi-x-by-default.patch
Its a bit disappointing that this bug is still not handled by upstream properly
- its pretty much impossible to use recent, non-patched Kernels on a lot of
larger IBM machines together with QLogic hardware.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
