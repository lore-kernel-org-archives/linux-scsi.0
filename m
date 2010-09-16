From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16547] mptscsih: ioc0: attempting task abort, raid array LUNs
 not detected properly on some boots
Date: Thu, 16 Sep 2010 06:03:35 GMT
Message-ID: <201009160603.o8G63ZLL004875@demeter2.kernel.org>
References: <bug-16547-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:36768 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0IPHCh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2010 03:02:37 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o8G63ZLT004876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 16 Sep 2010 06:03:35 GMT
In-Reply-To: <bug-16547-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16547


kdesai <kashyap.desai@lsi.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kashyap.desai@lsi.com




--- Comment #5 from kdesai <kashyap.desai@lsi.com>  2010-09-16 06:03:33 ---
(In reply to comment #3)
> Some additional information on the MPT driver version and controller:
> 
> backend01:~# grep -r "" /proc/mpt/*
> /proc/mpt/ioc0/summary:ioc0: LSIFC949E A1, FwRev=01030e00h, Ports=1, MaxQ=1023,
> LanAddr=00:06:[...], IRQ=33
> /proc/mpt/ioc0/info:ioc0:
> /proc/mpt/ioc0/info:  ProductID = 0x1005 (LSIFC949E A1)
> /proc/mpt/ioc0/info:  FWVersion = 0x01030e00 (fw_size=190556)
> /proc/mpt/ioc0/info:  MsgVersion = 0x0105
> /proc/mpt/ioc0/info:  FirstWhoInit = 0x00
> /proc/mpt/ioc0/info:  EventState = 0x00
> /proc/mpt/ioc0/info:  CurrentHostMfaHighAddr = 0x00000004
> /proc/mpt/ioc0/info:  CurrentSenseBufferHighAddr = 0x00000004
> /proc/mpt/ioc0/info:  MaxChainDepth = 0x3e frames
> /proc/mpt/ioc0/info:  MinBlockSize = 0x20 bytes
> /proc/mpt/ioc0/info:  RequestFrames @ 0xffff88043c102800 (Dma @
> 0x000000043c102800)
> /proc/mpt/ioc0/info:    {CurReqSz=128} x {CurReqDepth=1023} = 130944 bytes ^=
> 0x20000
> /proc/mpt/ioc0/info:    {MaxReqSz=128}   {MaxReqDepth=1023}
> /proc/mpt/ioc0/info:  Frames   @ 0xffff88043c100000 (Dma @ 0x000000043c100000)
> /proc/mpt/ioc0/info:    {CurRepSz=80} x {CurRepDepth=128} = 10240 bytes ^=
> 0x2880
> /proc/mpt/ioc0/info:    {MaxRepSz=0}   {MaxRepDepth=1023}
> /proc/mpt/ioc0/info:  MaxDevices = 255
> /proc/mpt/ioc0/info:  MaxBuses = 2
> /proc/mpt/ioc0/info:  PortNumber = 1 (of 1)
> /proc/mpt/ioc0/info:    LanAddr = 00:06:[...]
> /proc/mpt/ioc0/info:    WWN = 2000[...]
> /proc/mpt/ioc1/summary:ioc1: LSIFC949E A1, FwRev=01030e00h, Ports=1, MaxQ=1023,
> LanAddr=00:06:2B:11:3B:79, IRQ=31
> /proc/mpt/ioc1/info:ioc1:
> /proc/mpt/ioc1/info:  ProductID = 0x1005 (LSIFC949E A1)
> /proc/mpt/ioc1/info:  FWVersion = 0x01030e00 (fw_size=190556)
> /proc/mpt/ioc1/info:  MsgVersion = 0x0105
> /proc/mpt/ioc1/info:  FirstWhoInit = 0x00
> /proc/mpt/ioc1/info:  EventState = 0x00
> /proc/mpt/ioc1/info:  CurrentHostMfaHighAddr = 0x00000004
> /proc/mpt/ioc1/info:  CurrentSenseBufferHighAddr = 0x00000004
> /proc/mpt/ioc1/info:  MaxChainDepth = 0x3e frames
> /proc/mpt/ioc1/info:  MinBlockSize = 0x20 bytes
> /proc/mpt/ioc1/info:  RequestFrames @ 0xffff88043c202800 (Dma @
> 0x000000043c202800)
> /proc/mpt/ioc1/info:    {CurReqSz=128} x {CurReqDepth=1023} = 130944 bytes ^=
> 0x20000
> /proc/mpt/ioc1/info:    {MaxReqSz=128}   {MaxReqDepth=1023}
> /proc/mpt/ioc1/info:  Frames   @ 0xffff88043c200000 (Dma @ 0x000000043c200000)
> /proc/mpt/ioc1/info:    {CurRepSz=80} x {CurRepDepth=128} = 10240 bytes ^=
> 0x2880
> /proc/mpt/ioc1/info:    {MaxRepSz=0}   {MaxRepDepth=1023}
> /proc/mpt/ioc1/info:  MaxDevices = 255
> /proc/mpt/ioc1/info:  MaxBuses = 2
> /proc/mpt/ioc1/info:  PortNumber = 1 (of 1)
> /proc/mpt/ioc1/info:    LanAddr = 00:06:[...]
> /proc/mpt/ioc1/info:    WWN = 2000[...]
> /proc/mpt/summary:ioc0: LSIFC949E A1, FwRev=01030e00h, Ports=1, MaxQ=1023,
> LanAddr=00:06:2B:11:3B:78, IRQ=33
> /proc/mpt/summary:ioc1: LSIFC949E A1, FwRev=01030e00h, Ports=1, MaxQ=1023,
> LanAddr=00:06:2B:11:3B:79, IRQ=31
> /proc/mpt/version:mptlinux-3.04.12
> /proc/mpt/version:  Fusion MPT base driver
> /proc/mpt/version:  Fusion MPT FC host driver




Your bug is completely different issue. Whatever you are point to redhat
bugzilla is with respect to SAS controller.

In your case it is FC controller.

You have mentioned that 
"Latest kernel known to work: 2.6.26 from Debian Backports"

Can you provide me driver version where things are working fine. In case of
some working kernel is there, I would like to simply upgrade MPTFUSION driver
(do not upgrade a whole kernel). This way I would like to change only one
component of the system at a time...

This will help to understand where things are broken.

FYI,
MPTFC drive is highly in mentionation mode. There are very very minimal changes
happened to MPTFC driver since 2008.

Last change went to upstream for MPTFC is 

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=03cb3829e0e5650518ce37e2b4420a35e034dc9e


Thanks, Kashyap

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug.
You are watching the assignee of the bug.
