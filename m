From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: scsi_debug issues
Date: Fri, 15 Oct 2004 12:01:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041015190154.GA3073@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:20216 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S268279AbUJOTBd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2004 15:01:33 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

Hi,

At the recommendation of Pat Mansfield, I'm posting this issue to
linux-scsi. I have run into a big problem with the scsi_debug driver
which is causing my machine to hang.

I was finally able to get a large number (10000) of scsi_debug disks via
modprobe (no partitioning, no mounting, no fs), so I decided to go ahead
and try to continue the experiment. I found that I was not able to ls in
a mounted directory from one of the scsi_debug disks. In the chance that
it was somehow due to the high number of disks present, I tried just

  modprobe scsi_debug

so that I would only get one disk. I then ran these commands [0]. I did
not set the SCSI logging on until the last moment, after I synced the
existent SCSI disks in the machine (there are two actual SCSI disks)
[1]. I found that the ls command never fails to hang (although sometimes
it will not hang immediately, I have to

  cd lost+found

first. Interestingly, if the machine does not have highmem (i.e. less
than 896 MB of RAM) or the kernel is booted with mem=800 (or some other
number less than 896), the problem dissappears. I had to put the check
in my patch in for the NULL dereference, as it would cause a
segmentation fault otherwise. I'm guessing that is where the problem may
be, as the NULL-check was not there before (an assumption that it
(scatg2virt) would always work?).

I'm more than happy to run further tests, post further output, apply
patches, etc. or anything else to resolve this bug. Please CC me on
reply, as I'm not subscribed to linux-scsi, thanks.

-Nish

[0] commands run to produce hang:

/etc/init.d/klogd stop
/etc/init.d/sysklogd stop
modprobe scsi_debug
fdisk /dev/sdc (primary partition, default values selected)
mkfs /dev/sdc1
mount /dev/sdc1 /home/test1
cd /home/test1
sync
echo 0xfffffff > /proc/sys/dev/scsi/logging_level
ls

[1] hw/sw description

2-way 700MHz with 2GB RAM
2.6.9-rc3 kernel with patch[3] applied

[2] output of serial console from modprobe onwards:

scsi2 : scsi_debug, version 1.73 [20040518], dev_size_mb=8, opts=0x0
 Vendor: Linux     Model: scsi_debug        Rev: 0004
 Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdc: 16384 512-byte hdwr sectors (8 MB)
SCSI device sdc: drive cache: write back
 sdc:scatg2virt(&sgpnt[0] [==c2268b60]) returned f7531000
 unknown partition table
Attached scsi disk sdc at scsi2, channel 0, id 0, lun 0
Attached scsi generic sg3 at scsi2, channel 0, id 0, lun 0,  type 0
scatg2virt(&sgpnt[0] [==c23d6b80]) returned f7532000
SCSI device sdc: 16384 512-byte hdwr sectors (8 MB)
SCSI device sdc: drive cache: write back
 sdc:scatg2virt(&sgpnt[0] [==c2268960]) returned f767c000
 sdc1
SCSI device sdc: 16384 512-byte hdwr sectors (8 MB)
SCSI device sdc: drive cache: write back
 sdc:scatg2virt(&sgpnt[0] [==f76efd60]) returned f7515000
 sdc1
scatg2virt(&sgpnt[0] [==f76efe60]) returned f7667000
scatg2virt(&sgpnt[0] [==c23d6b80]) returned f767d000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f76c6000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f74bb000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f74b7000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f7ec9000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f75eb000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f7452000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f74cd000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f7ff8000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f7e72000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f766d000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f74e4000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f7689000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f76ab000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f7586000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f7632000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f7554000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f745f000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f7408000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f74ba000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f7589000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f7400000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f76b4000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f76b6000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f765c000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f765e000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f765f000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f7674000
scatg2virt(&sgpnt[0] [==f76efe60]) returned f7675000
scatg2virt(&sgpnt[0] [==c23d6a80]) returned f7516000
scatg2virt(&sgpnt[0] [==c2268960]) returned f751b400
scatg2virt(&sgpnt[0] [==c2268960]) returned f751b800
scatg2virt(&sgpnt[0] [==c2268960]) returned f7661400
sd_init_command: disk=sdc, block=554, count=2
sdc : block=554
sdc : reading 2/2 512 byte blocks.
scsi_add_timer: scmd: f76e2e00, time: 30000, (c023dc50)
scsi <2:0:0:0> send 0xf76e2e00                  scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
buffer = 0xf76efd60, bufflen = 1024, done = 0xc0264770, queuecommand 0xf88c4030
scatg2virt(&sgpnt[0] [==f76efd60]) returned NULL
Invalid memory access in resp_read...
leaving scsi_dispatch_cmnd()
scsi_delete_timer: scmd: f76e2e00, rtn: 1
scsi <2:0:0:0> done 0xf76e2e00 RETRY      70000 scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
scsi host busy 1 failed 0
Inserting command f76e2e00 into mlqueue
scsi_delete_timer: scmd: f76e2e00, rtn: 0
scsi_add_timer: scmd: f76e2e00, time: 30000, (c023dc50)
scsi <2:0:0:0> send 0xf76e2e00                  scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
buffer = 0xf76efd60, bufflen = 1024, done = 0xc0264770, queuecommand 0xf88c4030
scatg2virt(&sgpnt[0] [==f76efd60]) returned NULL
Invalid memory access in resp_read...
leaving scsi_dispatch_cmnd()
scsi_delete_timer: scmd: f76e2e00, rtn: 1
scsi <2:0:0:0> done 0xf76e2e00 RETRY      70000 scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
scsi host busy 1 failed 0
Inserting command f76e2e00 into mlqueue
scsi_delete_timer: scmd: f76e2e00, rtn: 0
scsi_add_timer: scmd: f76e2e00, time: 30000, (c023dc50)
scsi <2:0:0:0> send 0xf76e2e00                  scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
buffer = 0xf76efd60, bufflen = 1024, done = 0xc0264770, queuecommand 0xf88c4030
scatg2virt(&sgpnt[0] [==f76efd60]) returned NULL
Invalid memory access in resp_read...
leaving scsi_dispatch_cmnd()
scsi_delete_timer: scmd: f76e2e00, rtn: 1
scsi <2:0:0:0> done 0xf76e2e00 RETRY      70000 scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
scsi host busy 1 failed 0
Inserting command f76e2e00 into mlqueue
scsi_delete_timer: scmd: f76e2e00, rtn: 0
scsi_add_timer: scmd: f76e2e00, time: 30000, (c023dc50)
scsi <2:0:0:0> send 0xf76e2e00                  scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
buffer = 0xf76efd60, bufflen = 1024, done = 0xc0264770, queuecommand 0xf88c4030
scatg2virt(&sgpnt[0] [==f76efd60]) returned NULL
Invalid memory access in resp_read...
leaving scsi_dispatch_cmnd()
scsi_delete_timer: scmd: f76e2e00, rtn: 1
scsi <2:0:0:0> done 0xf76e2e00 RETRY      70000 scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
scsi host busy 1 failed 0
Inserting command f76e2e00 into mlqueue
scsi_delete_timer: scmd: f76e2e00, rtn: 0
scsi_add_timer: scmd: f76e2e00, time: 30000, (c023dc50)
scsi <2:0:0:0> send 0xf76e2e00                  scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
buffer = 0xf76efd60, bufflen = 1024, done = 0xc0264770, queuecommand 0xf88c4030
scatg2virt(&sgpnt[0] [==f76efd60]) returned NULL
Invalid memory access in resp_read...
leaving scsi_dispatch_cmnd()
scsi_delete_timer: scmd: f76e2e00, rtn: 1
scsi <2:0:0:0> done 0xf76e2e00 SUCCESS    70000 scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
scsi host busy 1 failed 0
Notifying upper driver of completion for device 0 70000
sd_rw_intr: sdc: res=0x70000
sd_rw_intr: sb[0,2,asc,ascq]=0,0,0,0
2 sectors total, 0 bytes done.
use_sg is 1
SCSI error : <2 0 0 0> return code = 0x70000
end_request: I/O error, dev sdc, sector 554
sd_init_command: disk=sdc, block=554, count=2
sdc : block=554
sdc : reading 2/2 512 byte blocks.
scsi_add_timer: scmd: f76e2e00, time: 30000, (c023dc50)
scsi <2:0:0:0> send 0xf76e2e00                  scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
buffer = 0xf76efd60, bufflen = 1024, done = 0xc0264770, queuecommand 0xf88c4030
scatg2virt(&sgpnt[0] [==f76efd60]) returned NULL
Invalid memory access in resp_read...
leaving scsi_dispatch_cmnd()
scsi_delete_timer: scmd: f76e2e00, rtn: 1
scsi <2:0:0:0> done 0xf76e2e00 RETRY      70000 scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
scsi host busy 1 failed 0
Inserting command f76e2e00 into mlqueue
scsi_delete_timer: scmd: f76e2e00, rtn: 0
scsi_add_timer: scmd: f76e2e00, time: 30000, (c023dc50)
scsi <2:0:0:0> send 0xf76e2e00                  scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
buffer = 0xf76efd60, bufflen = 1024, done = 0xc0264770, queuecommand 0xf88c4030
scatg2virt(&sgpnt[0] [==f76efd60]) returned NULL
Invalid memory access in resp_read...
leaving scsi_dispatch_cmnd()
scsi_delete_timer: scmd: f76e2e00, rtn: 1
scsi <2:0:0:0> done 0xf76e2e00 RETRY      70000 scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
scsi host busy 1 failed 0
Inserting command f76e2e00 into mlqueue
scsi_delete_timer: scmd: f76e2e00, rtn: 0
scsi_add_timer: scmd: f76e2e00, time: 30000, (c023dc50)
scsi <2:0:0:0> send 0xf76e2e00                  scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
buffer = 0xf76efd60, bufflen = 1024, done = 0xc0264770, queuecommand 0xf88c4030
scatg2virt(&sgpnt[0] [==f76efd60]) returned NULL
Invalid memory access in resp_read...
leaving scsi_dispatch_cmnd()
scsi_delete_timer: scmd: f76e2e00, rtn: 1
scsi <2:0:0:0> done 0xf76e2e00 RETRY      70000 scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
scsi host busy 1 failed 0
Inserting command f76e2e00 into mlqueue
scsi_delete_timer: scmd: f76e2e00, rtn: 0
scsi_add_timer: scmd: f76e2e00, time: 30000, (c023dc50)
scsi <2:0:0:0> send 0xf76e2e00                  scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
buffer = 0xf76efd60, bufflen = 1024, done = 0xc0264770, queuecommand 0xf88c4030
scatg2virt(&sgpnt[0] [==f76efd60]) returned NULL
Invalid memory access in resp_read...
leaving scsi_dispatch_cmnd()
scsi_delete_timer: scmd: f76e2e00, rtn: 1
scsi <2:0:0:0> done 0xf76e2e00 RETRY      70000 scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
scsi host busy 1 failed 0
Inserting command f76e2e00 into mlqueue
scsi_delete_timer: scmd: f76e2e00, rtn: 0
scsi_add_timer: scmd: f76e2e00, time: 30000, (c023dc50)
scsi <2:0:0:0> send 0xf76e2e00                  scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
buffer = 0xf76efd60, bufflen = 1024, done = 0xc0264770, queuecommand 0xf88c4030
scatg2virt(&sgpnt[0] [==f76efd60]) returned NULL
Invalid memory access in resp_read...
leaving scsi_dispatch_cmnd()
scsi_delete_timer: scmd: f76e2e00, rtn: 1
scsi <2:0:0:0> done 0xf76e2e00 SUCCESS    70000 scsi2 : destination target 0, lun 0
        command = 0x28 00 00 00 02 2a 00 00 02 00 
scsi host busy 1 failed 0
Notifying upper driver of completion for device 0 70000
sd_rw_intr: sdc: res=0x70000
sd_rw_intr: sb[0,2,asc,ascq]=0,0,0,0
2 sectors total, 0 bytes done.
use_sg is 1
SCSI error : <2 0 0 0> return code = 0x70000
end_request: I/O error, dev sdc, sector 554
sd_init_command: disk=sdc, block=34, count=2
sdc : block=34
sdc : writing 2/2 512 byte blocks.
scsi_add_timer: scmd: f76e2ca0, time: 30000, (c023dc50)
scsi <2:0:0:0> send 0xf76e2ca0                  scsi2 : destination target 0, lun 0
        command = 0x2a 00 00 00 00 22 00 00 02 00 
buffer = 0xf76ef060, bufflen = 1024, done = 0xc0264770, queuecommand 0xf88c4030
sd_init_command: disk=sda, block=7575, count=80
sda : block=7575
sda : writing 80/80 512 byte blocks.
scsi_add_timer: scmd: f76e2880, time: 30000, (c023dc50)
scsi <0:0:0:0> send 0xf76e2880                  scsi0 : destination target 0, lun 0
        command = 0x2a 00 00 00 1d 97 00 00 50 00 
buffer = 0xc23d6180, bufflen = 40960, done = 0xc0264770, queuecommand 0xc025b350
leaving scsi_dispatch_cmnd()
scsi_delete_timer: scmd: f76e2880, rtn: 1
scsi <0:0:0:0> done 0xf76e2880 SUCCESS        0 scsi0 : destination target 0, lun 0
        command = 0x2a 00 00 00 1d 97 00 00 50 00 
scsi host busy 1 failed 0
Notifying upper driver of completion for device 0 0
sd_rw_intr: sda: res=0x0
80 sectors total, 40960 bytes done.
use_sg is 9
sd_init_command: disk=sda, block=7655, count=8
sda : block=7655
sda : writing 8/8 512 byte blocks.
scsi_add_timer: scmd: f76e2880, time: 30000, (c023dc50)
scsi <0:0:0:0> send 0xf76e2880                  scsi0 : destination target 0, lun 0
        command = 0x2a 00 00 00 1d e7 00 00 08 00 
buffer = 0xc2268ce0, bufflen = 4096, done = 0xc0264770, queuecommand 0xc025b350
leaving scsi_dispatch_cmnd()
scsi_delete_timer: scmd: f76e2880, rtn: 1
scsi <0:0:0:0> done 0xf76e2880 SUCCESS        0 scsi0 : destination target 0, lun 0
        command = 0x2a 00 00 00 1d e7 00 00 08 00 
scsi host busy 1 failed 0
Notifying upper driver of completion for device 0 0
sd_rw_intr: sda: res=0x0
8 sectors total, 4096 bytes done.
use_sg is 1

[3] patch applied:

--- 2.6.9-rc3-vanilla/drivers/scsi/scsi_debug.c	2004-10-15 11:09:50.000000000 -0700
+++ 2.6.9-rc3/drivers/scsi/scsi_debug.c	2004-10-15 11:18:42.000000000 -0700
@@ -423,6 +423,10 @@ int scsi_debug_queuecommand(struct scsi_
 			num = cmd[4];
 		}
 		errsts = resp_read(SCpnt, upper_blk, block, num, devip);
+		if (errsts == (DID_ERROR << 16)) {
+			printk ("Invalid memory access in resp_read...\n");
+			break;
+		}
 		if (inj_recovered && (0 == errsts)) {
 			mk_sense_buffer(devip, RECOVERED_ERROR,
 					THRESHHOLD_EXCEEDED, 0, 18);
@@ -801,6 +805,12 @@ static int resp_read(struct scsi_cmnd * 
 		sgcount = 0;
 		sgpnt = (struct scatterlist *) buff;
 		buff = scatg2virt(&sgpnt[sgcount]);
+		printk("scatg2virt(&sgpnt[0] [==%p]) returned ", &sgpnt[sgcount]);
+		if (buff == NULL) {
+			printk("NULL\n");
+			return (DID_ERROR << 16);
+		}
+		printk("%p\n", buff);
 		bufflen = sgpnt[sgcount].length;
 	}
 	do {
@@ -1243,6 +1253,10 @@ static int schedule_resp(struct scsi_cmn
 			printk(KERN_INFO "scsi_debug: ... <%u %u %u %u> "
 			       "non-zero result=0x%x\n", sdp->host->host_no,
 			       sdp->channel, sdp->id, sdp->lun, scsi_result);
+			if (scsi_result == (DID_ERROR << 16)) {
+				printk("scsi_debug: WARNING: DID_ERROR "
+						"returned!\n");
+			}
 		}
 	}
 	if (cmnd && devip) {
