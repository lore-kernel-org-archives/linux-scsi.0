From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16547] mptscsih: ioc0: attempting task abort, raid array LUNs
 not detected properly on some boots
Date: Mon, 9 Aug 2010 09:46:45 GMT
Message-ID: <201008090946.o799kj54025071@demeter.kernel.org>
References: <bug-16547-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55167 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab0HIJqq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2010 05:46:46 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o799kjsu025072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2010 09:46:45 GMT
In-Reply-To: <bug-16547-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16547





--- Comment #3 from Martin Steigerwald <ms@teamix.de>  2010-08-09 09:45:32 ---
Some additional information on the MPT driver version and controller:

backend01:~# grep -r "" /proc/mpt/*
/proc/mpt/ioc0/summary:ioc0: LSIFC949E A1, FwRev=01030e00h, Ports=1, MaxQ=1023,
LanAddr=00:06:[...], IRQ=33
/proc/mpt/ioc0/info:ioc0:
/proc/mpt/ioc0/info:  ProductID = 0x1005 (LSIFC949E A1)
/proc/mpt/ioc0/info:  FWVersion = 0x01030e00 (fw_size=190556)
/proc/mpt/ioc0/info:  MsgVersion = 0x0105
/proc/mpt/ioc0/info:  FirstWhoInit = 0x00
/proc/mpt/ioc0/info:  EventState = 0x00
/proc/mpt/ioc0/info:  CurrentHostMfaHighAddr = 0x00000004
/proc/mpt/ioc0/info:  CurrentSenseBufferHighAddr = 0x00000004
/proc/mpt/ioc0/info:  MaxChainDepth = 0x3e frames
/proc/mpt/ioc0/info:  MinBlockSize = 0x20 bytes
/proc/mpt/ioc0/info:  RequestFrames @ 0xffff88043c102800 (Dma @
0x000000043c102800)
/proc/mpt/ioc0/info:    {CurReqSz=128} x {CurReqDepth=1023} = 130944 bytes ^=
0x20000
/proc/mpt/ioc0/info:    {MaxReqSz=128}   {MaxReqDepth=1023}
/proc/mpt/ioc0/info:  Frames   @ 0xffff88043c100000 (Dma @ 0x000000043c100000)
/proc/mpt/ioc0/info:    {CurRepSz=80} x {CurRepDepth=128} = 10240 bytes ^=
0x2880
/proc/mpt/ioc0/info:    {MaxRepSz=0}   {MaxRepDepth=1023}
/proc/mpt/ioc0/info:  MaxDevices = 255
/proc/mpt/ioc0/info:  MaxBuses = 2
/proc/mpt/ioc0/info:  PortNumber = 1 (of 1)
/proc/mpt/ioc0/info:    LanAddr = 00:06:[...]
/proc/mpt/ioc0/info:    WWN = 2000[...]
/proc/mpt/ioc1/summary:ioc1: LSIFC949E A1, FwRev=01030e00h, Ports=1, MaxQ=1023,
LanAddr=00:06:2B:11:3B:79, IRQ=31
/proc/mpt/ioc1/info:ioc1:
/proc/mpt/ioc1/info:  ProductID = 0x1005 (LSIFC949E A1)
/proc/mpt/ioc1/info:  FWVersion = 0x01030e00 (fw_size=190556)
/proc/mpt/ioc1/info:  MsgVersion = 0x0105
/proc/mpt/ioc1/info:  FirstWhoInit = 0x00
/proc/mpt/ioc1/info:  EventState = 0x00
/proc/mpt/ioc1/info:  CurrentHostMfaHighAddr = 0x00000004
/proc/mpt/ioc1/info:  CurrentSenseBufferHighAddr = 0x00000004
/proc/mpt/ioc1/info:  MaxChainDepth = 0x3e frames
/proc/mpt/ioc1/info:  MinBlockSize = 0x20 bytes
/proc/mpt/ioc1/info:  RequestFrames @ 0xffff88043c202800 (Dma @
0x000000043c202800)
/proc/mpt/ioc1/info:    {CurReqSz=128} x {CurReqDepth=1023} = 130944 bytes ^=
0x20000
/proc/mpt/ioc1/info:    {MaxReqSz=128}   {MaxReqDepth=1023}
/proc/mpt/ioc1/info:  Frames   @ 0xffff88043c200000 (Dma @ 0x000000043c200000)
/proc/mpt/ioc1/info:    {CurRepSz=80} x {CurRepDepth=128} = 10240 bytes ^=
0x2880
/proc/mpt/ioc1/info:    {MaxRepSz=0}   {MaxRepDepth=1023}
/proc/mpt/ioc1/info:  MaxDevices = 255
/proc/mpt/ioc1/info:  MaxBuses = 2
/proc/mpt/ioc1/info:  PortNumber = 1 (of 1)
/proc/mpt/ioc1/info:    LanAddr = 00:06:[...]
/proc/mpt/ioc1/info:    WWN = 2000[...]
/proc/mpt/summary:ioc0: LSIFC949E A1, FwRev=01030e00h, Ports=1, MaxQ=1023,
LanAddr=00:06:2B:11:3B:78, IRQ=33
/proc/mpt/summary:ioc1: LSIFC949E A1, FwRev=01030e00h, Ports=1, MaxQ=1023,
LanAddr=00:06:2B:11:3B:79, IRQ=31
/proc/mpt/version:mptlinux-3.04.12
/proc/mpt/version:  Fusion MPT base driver
/proc/mpt/version:  Fusion MPT FC host driver

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug.
You are watching the assignee of the bug.
