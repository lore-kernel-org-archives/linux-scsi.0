From: Poul Petersen <petersp@roguewave.com>
Subject: RE: What's the "right" qla2100 driver?
Date: Thu, 22 Jan 2004 14:54:36 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F888C30C3021D411B9DA00B0D0209BE8038F9BD4@cvo-exchange.cvo.roguewave.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cvo-ext.roguewave.com ([12.22.36.198]:7280 "EHLO
	cvo-exchange.cvo.roguewave.com") by vger.kernel.org with ESMTP
	id S265119AbUAVWzK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 17:55:10 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> For 2.4, you could try another driver -- 6.06.10 (available at the

	Ah, so there is. I hadn't noticed that! After running the raidstart
resync with this qla2100 driver, disks
started eventualy failing with errors like:

SCSI disk error : host 4 channel 0 id 6 lun 0 return code = 20000
 I/O error: dev 08:71, sector 10072520
SCSI disk error : host 4 channel 0 id 5 lun 0 return code = 20000
 I/O error: dev 08:61, sector 10072520
SCSI disk error : host 4 channel 0 id 4 lun 0 return code = 20000
 I/O error: dev 08:51, sector 10072520
SCSI disk error : host 4 channel 0 id 3 lun 0 return code = 20000
 I/O error: dev 08:41, sector 10072520
SCSI disk error : host 4 channel 0 id 2 lun 0 return code = 20000
 I/O error: dev 08:31, sector 10072520
SCSI disk error : host 4 channel 0 id 1 lun 0 return code = 20000
 I/O error: dev 08:21, sector 10072520
SCSI disk error : host 4 channel 0 id 0 lun 0 return code = 20000
 I/O error: dev 08:11, sector 10072520

	Doesn't it seem odd that these seven disks all failed complaining
about the same sector? All 28 disks eventually failed, some with the same
sector errors. The machine hung when I tried to reboot it. Strange. 

> For 2.6, why don't we start out with the default qla2xxx driver in
> 2.6.2-rc1.  

	I'm getting the same results with this combination as I did with
2.6.1 before. I should point out that I am not waiting for the resink to
start before trying to lay down a file system:

# mkraid /dev/md0
# mkraid /dev/md1

	At this point I waited a few minutes, and both resync's cruised
along. Everything was looking good, so I did a:

# mkfs.ext3 /dev/md0
mke2fs 1.32 (09-Nov-2002)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
26509312 inodes, 53014272 blocks
2650713 blocks (5.00%) reserved for the super user
First data block=0
1618 block groups
32768 blocks per group, 32768 fragments per group
16384 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632,
2654208,
        4096000, 7962624, 11239424, 20480000, 23887872

Writing inode tables:  120/1618

	At this point, the mkfs hung and the resync stopped. The status of
md is:

# cat /proc/mdstat
Personalities : [raid5]
md1 : active raid5 sdab1[13] sdaa1[12] sdz1[11] sdy1[10] sdx1[9] sdw1[8]
sdv1[7] sdu1[6] sdt1[5] sds1[4] sdr1[3] sdq1[2] sdp1[1] sdo1[0]
      212057088 blocks level 5, 64k chunk, algorithm 2 [13/13]
[UUUUUUUUUUUUU]
      [>....................]  resync =  3.6% (645636/17671424)
finish=1271.7min speed=222K/sec
md0 : active raid5 sdn1[13] sdm1[12] sdl1[11] sdk1[10] sdj1[9] sdi1[8]
sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
      212057088 blocks level 5, 64k chunk, algorithm 2 [13/13]
[UUUUUUUUUUUUU]
      [=>...................]  resync =  6.6% (1173248/17671424)
finish=1381.3min speed=198K/sec
unused devices: <none>

	But the "finish" time is the only thing that changes, as it
continually increases. I also see the following in dmesg:

md: using maximum available idle IO bandwith (but not more than 200000
KB/sec) for reconstruction.
md: using 128k window, over a total of 17671424 blocks.
qla2100 0000:01:09.0: qla2xxx_eh_abort scsi(2:0:7:0):
cmd_timeout_in_sec=0x1e.
qla2100 0000:01:09.0: qla2xxx_eh_abort Exiting: status=Failed
qla2100 0000:01:09.0: qla2xxx_eh_abort scsi(2:0:12:0):
cmd_timeout_in_sec=0x1e.
qla2100 0000:01:09.0: qla2xxx_eh_abort Exiting: status=Failed
qla2100 0000:01:09.0: qla2xxx_eh_abort scsi(2:0:12:0):
cmd_timeout_in_sec=0x1e.
qla2100 0000:01:09.0: qla2xxx_eh_abort Exiting: status=Failed
qla2100 0000:01:09.0: qla2xxx_eh_abort scsi(2:0:11:0):
cmd_timeout_in_sec=0x1e.
qla2100 0000:01:09.0: qla2xxx_eh_abort Exiting: status=Failed
qla2100 0000:01:09.0: qla2xxx_eh_abort scsi(2:0:10:0):
cmd_timeout_in_sec=0x1e.
qla2100 0000:01:09.0: qla2xxx_eh_abort Exiting: status=Failed

	Doing a simple collection of these error messages:

# dmesg | grep scsi\( | cut -d: -f6 | sort -un | xargs
0 1 2 3 4 5 6 7 8 9 10 11 12

	So, all 13 disks in the first array (md0) are generating errors. I
decided to try this again (after a reboot), without issuing the mkfs. I let
the sync run and watched dmesg for strange errors. Here is a summary:

md: using 128k window, over a total of 17671424 blocks.
qla2100 0000:01:09.0: qla2xxx_eh_abort scsi(1:0:1:0):
cmd_timeout_in_sec=0x1e.
qla2100 0000:01:09.0: Performing ISP error recovery - ha= cd7b01c0.
qla2100 0000:01:09.0: LIP reset occured (f8ef).
qla2100 0000:01:09.0: LIP occured (f8ef).
qla2100 0000:01:09.0: LOOP UP detected (1 Gbps).
qla2100 0000:01:09.0: qla2xxx_eh_abort: cmd already done sp=00000000
qla2100 0000:01:09.0: qla2xxx_eh_abort: cmd already done sp=00000000
qla2100 0000:01:09.0: qla2xxx_eh_abort: cmd already done sp=00000000
qla2100 0000:01:09.0: qla2xxx_eh_abort: cmd already done sp=00000000

... Repeated ~150 times ...

qla2100 0000:01:09.0: ISP System Error - mbx1=1935h mbx2=0h mbx3=8004h.
qla2100 0000:01:09.0: Failed to dump firmware (256)!!!
qla2100 0000:01:09.0: Performing ISP error recovery - ha= cd7b01c0.
qla2100 0000:01:09.0: LIP reset occured (f8f7).
qla2100 0000:01:09.0: LIP occured (f8f7).
qla2100 0000:01:09.0: LOOP UP detected (1 Gbps).
qla2100 0000:01:09.0: qla2xxx_eh_abort scsi(1:0:23:0):
cmd_timeout_in_sec=0x1e.
qla2100 0000:01:09.0: qla2xxx_eh_abort Exiting: status=Failed
qla2100 0000:01:09.0: qla2xxx_eh_abort scsi(1:0:22:0):
cmd_timeout_in_sec=0x1e.
qla2100 0000:01:09.0: qla2xxx_eh_abort Exiting: status=Failed
qla2100 0000:01:09.0: qla2xxx_eh_abort scsi(1:0:21:0):
cmd_timeout_in_sec=0x1e.
qla2100 0000:01:09.0: qla2xxx_eh_abort Exiting: status=Failed
... Repeated lots ...

	This time it failed all of the disks in md1, plus one from md0:

# dmesg | grep '^qla2100.*scsi(' | cut -d: -f6 | sort -un | xargs
1 4 14 15 16 17 18 19 20 21 22 23 24 25 26

	Thoughts?

Thanks for your help,

-poul

