From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: LSI SAS HBA hard resets
Date: Fri, 02 Apr 2010 11:36:03 +1300
Message-ID: <4BB51FD3.2030801@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sauce.co.nz ([210.48.49.72]:50534 "EHLO smtp.sauce.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab0DAWmq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2010 18:42:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have just seen the same thing an hour into an md array check (echo 
check > /sys/block/md8/md/sync_action) on a Supermicro X8DT3-LN4F, with 
an LSISAS3442E attached to a Vitesse expander with 16 x WD1002FBYS-0 in 
an md RAID6.

Kernel 2.6.30.8-64.fc11.x86_64

SAS3442E B3 fw=01.29.00.00 BIOS=06.1c.00.00 Driver 3.04.07

truncated dmesg output:

md: data-check of RAID array md8
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 
KB/sec) for data-check.
md: using 128k window, over a total of 976591104 blocks.
mptbase: ioc0: LogInfo(0x31110b00): Originator={PL}, Code={Reset}, 
SubCode(0x0b00)
mptbase: ioc0: LogInfo(0x31110b00): Originator={PL}, Code={Reset}, 
SubCode(0x0b00)
mptbase: ioc0: LogInfo(0x31110b00): Originator={PL}, Code={Reset}, 
SubCode(0x0b00)
...
...
...
mptbase: ioc0: WARNING - IOC is in FAULT state (7810h)!!!
mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - IOC is in FAULT state!!!
mptbase: ioc0: WARNING -            FAULT code = 7810h
sd 6:0:3:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 10, 
sc=ffff8801bb1b2000, mf = ffff880338842b80, idx=7
sd 6:0:7:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 14, 
sc=ffff8801bb1b2d00, mf = ffff880338843300, idx=16
sd 6:0:4:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 11, 
sc=ffff8802d9afe300, mf = ffff880338843580, idx=1b
sd 6:0:7:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 14, 
sc=ffff88009c0b9d00, mf = ffff880338843780, idx=1f
sd 6:0:9:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 16, 
sc=ffff880250b67200, mf = ffff880338843a80, idx=25
sd 6:0:3:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 10, 
sc=ffff88014a7fb700, mf = ffff880338843d00, idx=2a
...
...
...
mptbase: ioc0: Recovered from IOC FAULT
mptbase: ioc0: WARNING - mpt_fault_reset_work: HardReset: success
end_request: I/O error, dev sdl, sector 1953182527
md: super_written gets error=-5, uptodate=0
raid5: Disk failure on sdl1, disabling device.
raid5: Operation continuing on 15 devices.
end_request: I/O error, dev sdq, sector 1953182527
md: super_written gets error=-5, uptodate=0
raid5: Disk failure on sdq1, disabling device.
raid5: Operation continuing on 14 devices.
end_request: I/O error, dev sdi, sector 1953182527
md: super_written gets error=-5, uptodate=0
raid5: Disk failure on sdi1, disabling device.
raid5: Operation continuing on 13 devices.
end_request: I/O error, dev sde, sector 1953182527
md: super_written gets error=-5, uptodate=0
raid5: Disk failure on sde1, disabling device.
raid5: Operation continuing on 12 devices.
end_request: I/O error, dev sdo, sector 1953182527
md: super_written gets error=-5, uptodate=0
raid5: Disk failure on sdo1, disabling device.
raid5: Operation continuing on 11 devices.
end_request: I/O error, dev sdn, sector 1953182527
md: super_written gets error=-5, uptodate=0
raid5: Disk failure on sdn1, disabling device.
raid5: Operation continuing on 10 devices.
end_request: I/O error, dev sdr, sector 1953182527
md: super_written gets error=-5, uptodate=0
raid5: Disk failure on sdr1, disabling device.
raid5: Operation continuing on 9 devices.
md: md8: data-check done.
Device md8, XFS metadata write error block 0x4937f0fe8 in md8

Major disruption as md array members are failed out.

This is the second time in couple of months this has happened - the 
first was not doing anarray check.

An almost guaranteed way to do a similar thing is to use smartd/smartctl 
(smartmontools) to access individual devices in the array.

Regards,

Richard


