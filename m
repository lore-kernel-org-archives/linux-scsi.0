From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16547] mptscsih: ioc0: attempting task abort, raid array LUNs
 not detected properly on some boots
Date: Thu, 16 Sep 2010 06:05:27 GMT
Message-ID: <201009160605.o8G65RAX005340@demeter2.kernel.org>
References: <bug-16547-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:36768 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0IPHCg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2010 03:02:36 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o8G65RoO005341
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 16 Sep 2010 06:05:27 GMT
In-Reply-To: <bug-16547-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16547





--- Comment #6 from kdesai <kashyap.desai@lsi.com>  2010-09-16 06:05:26 ---
(In reply to comment #4)
> I'm also have something like that:
> [ 4499.860030] mptscsih: ioc0: attempting task abort! (sc=ffff88007a588200)
> [ 4499.860036] sd 4:0:0:0: [sda] CDB: Write(10): 2a 00 0f dc f8 9f 00 04 00 00
> [ 4499.894551] mptbase: ioc0: LogInfo(0x31120403): Originator={PL},
> Code={Abort}, SubCode(0x0403) cb_idx mptbase_reply
> [ 4501.256258] mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO
> Executed}, SubCode(0x0000) cb_idx mptscsih_io_done
> [ 4501.268298] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88007a588200)
> [ 4503.256426] mptbase: ioc0: LogInfo(0x31120403): Originator={PL},
> Code={Abort}, SubCode(0x0403) cb_idx mptscsih_io_done
> [ 4503.256439] mptscsih: ioc0: attempting task abort! (sc=ffff88007ab5cc00)
> [ 4503.256443] sd 4:0:0:0: [sda] CDB: Write(10): 2a 00 0f dc fc 9f 00 04 00 00
> [ 4503.256455] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88007ab5cc00)
> [ 4503.506394] mptscsih: ioc0: attempting task abort! (sc=ffff88007a588000)
> [ 4503.506399] sd 4:0:0:0: [sda] CDB: Write(10): 2a 00 0f dd 00 9f 00 04 00 00
> [ 4503.506412] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88007a588000)
> ... and so on.
> Happens when heavy disk write operations ongoing.
> Identically on ubuntu's stock 2.6.32-24 and also on custom built 2.6.35.4 and
> 2.6.36-rc3 kernels.
> 
> cat /proc/mpt/version
> mptlinux-3.04.17
>   Fusion MPT base driver
>   Fusion MPT SAS host driver
> 
> cat /proc/mpt/summary
> ioc0: LSISAS1064E B2, FwRev=01140000h, Ports=1, MaxQ=511, IRQ=17
> 
> cat /proc/mpt/ioc0/info
> ioc0:
>   ProductID = 0x2204 (LSISAS1064E B2)
>   FWVersion = 0x01140000
>   MsgVersion = 0x0105
>   FirstWhoInit = 0x00
>   EventState = 0x00
>   CurrentHostMfaHighAddr = 0x00000000
>   CurrentSenseBufferHighAddr = 0x00000000
>   MaxChainDepth = 0x60 frames
>   MinBlockSize = 0x20 bytes
>   RequestFrames @ 0xffff88007a502800 (Dma @ 0x000000007a502800)
>     {CurReqSz=128} x {CurReqDepth=511} = 65408 bytes ^= 0x10000
>     {MaxReqSz=128}   {MaxReqDepth=511}
>   Frames   @ 0xffff88007a500000 (Dma @ 0x000000007a500000)
>     {CurRepSz=80} x {CurRepDepth=128} = 10240 bytes ^= 0x2880
>     {MaxRepSz=0}   {MaxRepDepth=511}
>   MaxDevices = 173
>   MaxBuses = 1
>   PortNumber = 1 (of 1)

your bug is not similar to first reported bug. Please open new bugzilla.

since your product is LSI SAS controller and first bug has been reported for
LSI FC controller.
thanks, Kashyap

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug.
You are watching the assignee of the bug.
