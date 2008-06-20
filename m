From: Richard Scobie <richard@sauce.co.nz>
Subject: smartd failure on MPT SAS and 2.6.25.6-55.fc9.x86_64
Date: Sat, 21 Jun 2008 10:52:07 +1200
Message-ID: <485C3497.2080100@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sauce.co.nz ([210.48.49.72]:32909 "EHLO smtp.sauce.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbYFTWlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2008 18:41:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Just updated from 2.6.25.4-30.fc9.x86_64 to 2.6.25.6-55.fc9.x86_64 and a 
previously working smartd setup (smartmontools-5.38-2.fc9.x86_64) to 
drives behind an LSISAS1068E, now causes controller resets:

mptscsih: ioc0: attempting task abort! (sc=ffff81023d0c6b40)
sd 4:0:0:0: [sdc] CDB: ATA command pass through(16): 85 08 0e 00 00 00 
01 00 00 00 00 00 00 00 ec 00
mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed}, 
SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=ffff81023d0c6b40)
mptscsih: ioc0: attempting task abort! (sc=ffff81023d0c6b40)
sd 4:0:0:0: [sdc] CDB: Test Unit Ready: 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31130000): Originator={PL}, Code={IO Not Yet 
Executed}, SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=ffff81023d0c6b40)
mptscsih: ioc0: attempting target reset! (sc=ffff81023d0c6b40)
sd 4:0:0:0: [sdc] CDB: ATA command pass through(16): 85 08 0e 00 00 00 
01 00 00 00 00 00 00 00 ec 00
mptscsih: ioc0: target reset: SUCCESS (sc=ffff81023d0c6b40)
mptscsih: ioc0: attempting task abort! (sc=ffff81023d0c6b40)
sd 4:0:0:0: [sdc] CDB: Test Unit Ready: 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31130000): Originator={PL}, Code={IO Not Yet 
Executed}, SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=ffff81023d0c6b40)
mptscsih: ioc0: attempting bus reset! (sc=ffff81023d0c6b40)
sd 4:0:0:0: [sdc] CDB: ATA command pass through(16): 85 08 0e 00 00 00 
01 00 00 00 00 00 00 00 ec 00
mptscsih: ioc0: bus reset: SUCCESS (sc=ffff81023d0c6b40)
mptscsih: ioc0: attempting task abort! (sc=ffff81023d0c6b40)
sd 4:0:0:0: [sdc] CDB: Test Unit Ready: 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31130000): Originator={PL}, Code={IO Not Yet 
Executed}, SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=ffff81023d0c6b40)
mptscsih: ioc0: attempting host reset! (sc=ffff81023d0c6b40)
mptbase: ioc0: Initiating recovery
mptscsih: ioc0: host reset: SUCCESS (sc=ffff81023d0c6b40)
sd 4:0:0:0: Device offlined - not ready after error recovery
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO


smartd.conf

/dev/sdc -d sat,16 -a -I 194 -s L/../../1/01

Regards,

Richard

