From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Mon, 30 Aug 2010 15:18:34 GMT
Message-ID: <201008301518.o7UFIYj2029110@demeter1.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54526 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab0H3PSe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2010 11:18:34 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7UFIY8M029112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2010 15:18:34 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #41 from kdesai <kashyap.desai@lsi.com>  2010-08-30 15:18:21 ---
(In reply to comment #40)
> descriptions for attachments in #38 and #39 are reversed

I have taken a deep look of all the available logs for below configuration.

kernel 5.5 2.6.18-194.8.1.el5
MPT2BIOS-7.05.01.00 (2010.02.09)
SAS2008-IT 5.00.00.00
LSI driver mpt2sas-05.00.00.00


Things are different in this case. It is not the same issue which is related to
"smartd" mentioned in this bugzilla.

I have seen some kind of hotplug action in this case. (or may be some
connection issue which has created Hotplug kind of situation)

1. See below snippet of (https://bugzilla.kernel.org/attachment.cgi?id=28191)
--
Aug 27 14:23:34 X kernel: mpt2sas0: Device Status Change
Aug 27 14:23:34 X kernel:     handle(0x000f), sas
address(0x4433221107000000)<6>mpt2sas0: SAS Topology Change List
Aug 27 14:23:34 X kernel: sd 0:0:7:0: device_blocked, handle(0x000f)
Aug 27 14:24:02 X kernel: mpt2sas0: attempting task abort!
scmd(ffff81005a235cc0)
Aug 27 14:24:02 X kernel: sd 0:0:7:0: 
Aug 27 14:24:02 X kernel:         comma

---

Driver has received Hotplug action "device delay removal" (this is relavent to
LSI controllers Device missing delay parameters) 
Check "/sys/class/scsi_host/host6/device_delay"

2. Very soon I have seen Some of the Task abort followed by Device delete event
See below snippet.

--ug 27 14:24:02 X kernel: mpt2sas0: attempting task abort!
scmd(ffff81005a235cc0)
Aug 27 14:24:02 X kernel: sd 0:0:7:0: 
Aug 27 14:24:02 X kernel:         command: Write(10): 2a 00 11 51 68 0f 00 04
00 00
Aug 27 14:24:02 X kernel: mpt2sas0: Device Status Change
Aug 27 14:24:02 X kernel: mpt2sas0: task abort: SUCCESS scmd(ffff81005a235cc0)
Aug 27 14:24:02 X kernel: 
Aug 27 14:24:02 X kernel: mpt2sas0: updating handles for
sas_host(0x5003048573212988)
Aug 27 14:24:02 X kernel:     handle(0x000f), sas
address(0x4433221107000000)<6>
Aug 27 14:24:02 X kernel: mpt2sas0: Discovery: (stop)
Aug 27 14:24:02 X kernel: mpt2sas0: Discovery: (start)
Aug 27 14:24:02 X kernel: mpt2sas0: SAS Topology Change List
Aug 27 14:24:02 X kernel: mpt2sas0: tr_send:handle(0x000f), (open), smid(439),
cb(7)
Aug 27 14:24:02 X kernel: mpt2sas0: Discovery: (stop)
Aug 27 14:24:02 X kernel: mpt2sas0: updating handles for
sas_host(0x5003048573212988)
Aug 27 14:24:02 X kernel: mpt2sas0: tr_complete:handle(0x000f), (open)
smid(439), ioc_status(0x0000), loginfo(0x00000000), completed(0)
Aug 27 14:24:02 X kernel: mpt2sas0: sc_send:handle(0x000f), (open), smid(540),
cb(5)
Aug 27 14:24:02 X kernel: mpt2sas0: sc_complete:handle(0x000f), (open)
smid(540), ioc_status(0x0000), loginfo(0x00000000)
Aug 27 14:24:02 X kernel: mpt2sas0: _scsih_remove_device: enter:
handle(0x000f), sas_addr(0x4433221107000000)
Aug 27 14:24:02 X kernel: sd 0:0:7:0: device_unblocked, handle(0x000f)
Aug 27 14:24:02 X kernel: mpt2sas0: removing handle(0x000f),
sas_addr(0x4433221107000000)
Aug 27 14:24:02 X kernel: mpt2sas0: _scsih_remove_device: exit: handle(0x000f),
sas_addr(0x4433221107000000)


---

3. Now Driver immediately receive Device ADD. (see below snippet)
--
Aug 27 14:24:02 X kernel: mpt2sas0: Discovery: (stop)
Aug 27 14:24:02 X kernel: mpt2sas0: REPORT_LUNS: handle(0x000f), retries(0)
Aug 27 14:24:02 X kernel: mpt2sas0:     ioc_status(0x0045),
loginfo(0x00000000), rc(ready)
Aug 27 14:24:02 X kernel: mpt2sas0: TEST_UNIT_READY: handle(0x000f), lun(0)
Aug 27 14:24:02 X kernel: mpt2sas0:     ioc_status(0x0000),
loginfo(0x00000000), rc(retry_ua)
Aug 27 14:24:02 X kernel: mpt2sas0:     [sense_key,asc,ascq]: [0x06,0x29,0x00]
Aug 27 14:24:02 X kernel: mpt2sas0: TEST_UNIT_READY: handle(0x000f), lun(0)
Aug 27 14:24:02 X kernel: mpt2sas0: attempting task abort!
scmd(ffff81005a235cc0)
Aug 27 14:24:02 X kernel: scsi 0:0:7:0: 
Aug 27 14:24:02 X kernel:         command: Test Unit Ready: 00 00 00 00 00 00
Aug 27 14:24:02 X kernel: mpt2sas0: device been deleted! scmd(ffff81005a235cc0)
--

4. At the end HBA reset is executed which is removing device "scsi 0:0:7:0".
It means device is not actually available in firmware table. (this can be
confirm if we have lsiutil option 8 and 16 )

In summary, this can be a completely different issue. Can we move this issue to
new bugzilla, so that I can have a fresh look on it ?

Thanks, Kashyap

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
