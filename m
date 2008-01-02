From: Bernd Schubert <bs@q-leap.de>
Subject: reproducible DV to the wrong device (fusion)
Date: Wed, 2 Jan 2008 19:54:09 +0100
Message-ID: <200801021954.10073.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:37139 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbYABSyL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jan 2008 13:54:11 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, "Moore, Eric" <Eric.Moore@lsi.com>

(Sorry sent again, since I used the wrong lsi developer list. Also forgot to 
say this is with 2.6.22).

Hi,

I complained about this before, but always got ignored. Please not this time. 
I can presently reliably reproduce it as often as I want. 
Pretty please, I can't keep this state forever, since the system is presently 
going into production.

As far as I can remotely see, IOC0 and IOC1 are on the same dualport LSI22320 
card. The device on IOC0 is probably not properly connected, probably a cable 
problem. When I just tried to add the device on IOC0, the device on IOC1 got 
a domain validation command. Presently both devices are idle otherwise.

On IOC0 there is 2:0:4:0 and on IOC1 there is 3:0:13:0 and 3:0:14:0.

pfs1n14-m:~# /tmp/scsiadd -a 2 0 4 0


[ 2595.405276] scsi 2:0:4:0: Activating scsi error recovery
[ 2595.405711] mptbase: ioc0: LogInfo(0x11010400): F/W: bug! MID not found
[ 2595.417828] Starting device recovery 5
[ 2595.668030] mptbase: ioc0: LogInfo(0x11010400): F/W: bug! MID not found
[ 2595.675024] scsi 2:0:4:0: Sending BDR 0xffff810128195920
[ 2595.680618] scsi 2:0:4:0: trying device reset
[ 2595.685230] mptscsih: ioc0: attempting target reset! (sc=ffff810128cbc500)
[ 2595.692280] scsi 2:0:4:0: CDB: Inquiry: 12 00 00 00 24 00
[ 2596.826218] mptbase: ioc0: LogInfo(0x11010400): F/W: bug! MID not found
[ 2597.089427] mptscsih: ioc0: Issue of TaskMgmt failed!
[ 2597.094766] mptscsih: ioc0: target reset: FAILED (sc=ffff810128cbc500)
[ 2597.101605] Sending BRST chan: 0
[ 2597.104982] scsi 2:0:4:0: trying bus reset
[ 2597.109306] mptscsih: ioc0: attempting bus reset! (sc=ffff810128cbc500)
[ 2597.116271] scsi 2:0:4:0: CDB: Inquiry: 12 00 00 00 24 00
[ 2598.511931] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff810128cbc500)
[ 2608.513834] scsi 2:0:4:0: trying host reset
[ 2608.514187] mptbase: ioc0: LogInfo(0x11010400): F/W: bug! MID not found
[ 2608.525197] mptscsih: ioc0: Attempting host reset! (sc=ffff810128cbc500)
[ 2608.532246] mptbase: Initiating ioc0 recovery
[ 2620.952389]  target2:0:4: asynchronous
[ 2620.956405]  target3:0:12: Beginning Domain Validation
[ 2620.987547]  target3:0:12: Ending Domain Validation
[ 2620.992714]  target3:0:12: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS PCOMP 
(6.25 ns, offset 127)
[ 2621.001863]  target3:0:13: Beginning Domain Validation
[ 2621.032982]  target3:0:13: Ending Domain Validation
[ 2621.037978]  target3:0:13: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS PCOMP 
(6.25 ns, offset 127)
[ 2630.946215] scsi 2:0:4:0: scsi: Device offlined - not ready after error 
recovery
[ 2630.946608] mptbase: ioc0: LogInfo(0x11010400): F/W: bug! MID not found


I already tried "echo -1 >/proc/sys/dev/scsi/logging_level", but this doesn't 
reveal anything.


Please, we really need to fix this, as this is really troublesome in 
production situation. Some hints for further debugging should be suffienct 
for now.


Thanks,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
