From: Erich Weiler <weiler@soe.ucsc.edu>
Subject: SCSI disk IO problem with JBOD
Date: Tue, 31 Jul 2012 21:00:47 -0700
Message-ID: <5018A9EF.2080003@soe.ucsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50681 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2HAEAt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2012 00:00:49 -0400
Received: by pbbrp8 with SMTP id rp8so396731pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2012 21:00:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi Y'all,

First let me apologize if this is the wrong venue to post this question. 
  If it is not, please point me to the correct spot if possible!

We have a Dell R610 server running CentOS 6.3 (kernel 
2.6.32-279.2.1.el6.x86_64).  We installed a LSI 9201-16e SAS HBA in it, 
upgraded to the latest firmware (9116 chipset).  Then we attached a LSI 
DE2660 JBOD array to it, with 60 hard drives.

At first boot, it got past grub to the initrd stage and crashed hard.  A 
bunch of add_disk exceptions or something.  If we unplugged the array, 
it boots fine.

So then I had the idea to compile the RDAC driver and create a new 
initrd that preloads the RDAC driver:

mkinitrd /boot/initrd-$(uname -r)-scsi_dh.img $(uname -r) 
--preload=scsi_dh_rdac

Then I booted with that.  It actually did not crash this time, but did 
spew a *ton* of SCSI errors on boot, like these (from dmesg):

end_request: I/O error, dev sdbh, sector 0
end_request: I/O error, dev dm-57, sector 0
end_request: I/O error, dev dm-58, sector 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:10:0: [sdj] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdj, sector 0
end_request: I/O error, dev dm-59, sector 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:52:0: [sdaz] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdaz, sector 0
end_request: I/O error, dev dm-57, sector 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:60:0: [sdbh] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdbh, sector 0
end_request: I/O error, dev dm-58, sector 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:10:0: [sdj] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 18 00 00 00 18 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdj, sector 24
end_request: I/O error, dev dm-59, sector 24
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:43:0: [sdaq] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 01 5d 50 a3 a8 5d 50 a3 a8 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdaq, sector 5860533160
end_request: I/O error, dev dm-40, sector 5860533160
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:60:0: [sdbh] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 18 00 00 00 18 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdbh, sector 24
sd 0:0:52:0: [sdaz] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 18 00 00 00 18 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdaz, sector 24
end_request: I/O error, dev dm-58, sector 24
end_request: I/O error, dev dm-57, sector 24
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:53:0: [sdba] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 01 5d 50 a3 a8 5d 50 a3 a8 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdba, sector 5860533160
end_request: I/O error, dev dm-28, sector 5860533160
sd 0:0:43:0: [sdaq] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 01 5d 50 a3 a8 5d 50 a3 a8 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdaq, sector 5860533160
end_request: I/O error, dev dm-40, sector 5860533160
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:53:0: [sdba] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 01 5d 50 a3 a8 5d 50 a3 a8 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdba, sector 5860533160
end_request: I/O error, dev dm-28, sector 5860533160
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:53:0: [sdba] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdba, sector 0
end_request: I/O error, dev dm-28, sector 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:53:0: [sdba] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdba, sector 0
end_request: I/O error, dev dm-28, sector 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:53:0: [sdba] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 18 00 00 00 18 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdba, sector 24
end_request: I/O error, dev dm-28, sector 24
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:43:0: [sdaq] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdaq, sector 0
end_request: I/O error, dev dm-40, sector 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:43:0: [sdaq] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdaq, sector 0
end_request: I/O error, dev dm-40, sector 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:43:0: [sdaq] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 18 00 00 00 18 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdaq, sector 24
end_request: I/O error, dev dm-40, sector 24
lo: Disabled Privacy Extensions
bnx2 0000:01:00.0: irq 63 for MSI/MSI-X
bnx2 0000:01:00.0: irq 64 for MSI/MSI-X
bnx2 0000:01:00.0: irq 65 for MSI/MSI-X
bnx2 0000:01:00.0: irq 66 for MSI/MSI-X
bnx2 0000:01:00.0: irq 67 for MSI/MSI-X
bnx2 0000:01:00.0: irq 68 for MSI/MSI-X
bnx2 0000:01:00.0: irq 69 for MSI/MSI-X
bnx2 0000:01:00.0: irq 70 for MSI/MSI-X
bnx2 0000:01:00.0: irq 71 for MSI/MSI-X
bnx2 0000:01:00.0: em1: using MSIX
ADDRCONF(NETDEV_UP): em1: link is not ready
bnx2 0000:01:00.0: em1: NIC Copper Link is Up, 1000 Mbps full duplex
ADDRCONF(NETDEV_CHANGE): em1: link becomes ready
em1: no IPv6 routers present
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 20
__ratelimit: 304 callbacks suppressed
sd 0:0:61:0: [sdbi] Target Data Integrity Failure
sd 0:0:61:0: [sdbi] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:61:0: [sdbi] Sense Key : Aborted Command [current]
sd 0:0:61:0: [sdbi] Add. Sense: Logical block reference tag check failed
__ratelimit: 618 callbacks suppressed
__ratelimit: 370 callbacks suppressed
Buffer I/O error on device dm-56, logical block 0
Buffer I/O error on device dm-56, logical block 1
Buffer I/O error on device dm-56, logical block 2
Buffer I/O error on device dm-56, logical block 3
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
sd 0:0:61:0: [sdbi] Target Data Integrity Failure
sd 0:0:61:0: [sdbi] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:61:0: [sdbi] Sense Key : Aborted Command [current]
sd 0:0:61:0: [sdbi] Add. Sense: Logical block reference tag check failed
Buffer I/O error on device dm-56, logical block 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
sd 0:0:61:0: [sdbi] Target Data Integrity Failure
sd 0:0:61:0: [sdbi] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:61:0: [sdbi] Sense Key : Aborted Command [current]
sd 0:0:61:0: [sdbi] Add. Sense: Logical block reference tag check failed
Buffer I/O error on device dm-56, logical block 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
sd 0:0:61:0: [sdbi] Target Data Integrity Failure
sd 0:0:61:0: [sdbi] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:61:0: [sdbi] Sense Key : Aborted Command [current]
sd 0:0:61:0: [sdbi] Add. Sense: Logical block reference tag check failed
Buffer I/O error on device dm-56, logical block 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
sd 0:0:61:0: [sdbi] Target Data Integrity Failure
sd 0:0:61:0: [sdbi] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:61:0: [sdbi] Sense Key : Aborted Command [current]
sd 0:0:61:0: [sdbi] Add. Sense: Logical block reference tag check failed
Buffer I/O error on device dm-56, logical block 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
sd 0:0:61:0: [sdbi] Target Data Integrity Failure
sd 0:0:61:0: [sdbi] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:61:0: [sdbi] Sense Key : Aborted Command [current]
sd 0:0:61:0: [sdbi] Add. Sense: Logical block reference tag check failed
end_request: I/O error, dev sdbi, sector 0
end_request: I/O error, dev dm-56, sector 0
Buffer I/O error on device dm-56, logical block 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
sd 0:0:61:0: [sdbi] Target Data Integrity Failure
sd 0:0:61:0: [sdbi] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:61:0: [sdbi] Sense Key : Aborted Command [current]
sd 0:0:61:0: [sdbi] Add. Sense: Logical block reference tag check failed
end_request: I/O error, dev sdbi, sector 0
end_request: I/O error, dev dm-56, sector 0
Buffer I/O error on device dm-56, logical block 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
sd 0:0:61:0: [sdbi] Target Data Integrity Failure
sd 0:0:61:0: [sdbi] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:61:0: [sdbi] Sense Key : Aborted Command [current]
sd 0:0:61:0: [sdbi] Add. Sense: Logical block reference tag check failed
end_request: I/O error, dev sdbi, sector 0
end_request: I/O error, dev dm-56, sector 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
sd 0:0:61:0: [sdbi] Target Data Integrity Failure
sd 0:0:61:0: [sdbi] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:61:0: [sdbi] Sense Key : Aborted Command [current]
sd 0:0:61:0: [sdbi] Add. Sense: Logical block reference tag check failed
end_request: I/O error, dev sdbi, sector 0
end_request: I/O error, dev dm-56, sector 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
sd 0:0:61:0: [sdbi] Target Data Integrity Failure
sd 0:0:61:0: [sdbi] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:61:0: [sdbi] Sense Key : Aborted Command [current]
sd 0:0:61:0: [sdbi] Add. Sense: Logical block reference tag check failed
end_request: I/O error, dev sdbi, sector 0
end_request: I/O error, dev dm-56, sector 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 08 00 00 00 08 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdbi, sector 8
end_request: I/O error, dev dm-56, sector 8
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 08 00 00 00 08 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdbi, sector 8
end_request: I/O error, dev dm-56, sector 8
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 08 00 00 00 08 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdbi, sector 8
end_request: I/O error, dev dm-56, sector 8
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 08 00 00 00 08 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdbi, sector 8
end_request: I/O error, dev dm-56, sector 8
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 08 00 00 00 08 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdbi, sector 8
end_request: I/O error, dev dm-56, sector 8
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 08 00 00 00 08 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdbi, sector 8
end_request: I/O error, dev dm-56, sector 8
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 08 00 00 00 08 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdbi, sector 8
end_request: I/O error, dev dm-56, sector 8
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 08 00 00 00 08 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdbi, sector 8
end_request: I/O error, dev dm-56, sector 8
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08
end_request: I/O error, dev sdbi, sector 0
end_request: I/O error, dev dm-56, sector 0
mpt2sas0: log_info(0x3112043b): originator(PL), code(0x12), sub_code(0x043b)
sd 0:0:61:0: [sdbi] CDB: cdb[0]=0x7f, sa=0x9: 7f 00 00 00 00 00 00 18 00 
09 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08

etc, etc, thousands of times.  Just for fun I then tried to tie it 
together with multipathd, using this config:

defaults {
       udev_dir                /dev
       polling_interval        5
       path_grouping_policy    failover
       getuid_callout          "/lib/udev/scsi_id --whitelisted 
--device=/dev/%n"
       path_checker            directio
       prio                    const
       rr_min_io               1000
       rr_weight               uniform
       failback                manual
       no_path_retry           fail
       user_friendly_names     yes
}

blacklist {
       devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
       devnode "^hd[a-z]
       # Blacklist the root disk (/dev/sda) by wwid - Find the wwid via 
"/lib/udev/scsi_id --page=0x83 --whitelisted --device=/dev/sda"
       wwid "3600508e000000000c3c8e073ff8f3b0c"
       devnode "^dcssblk[0-9]*"
}

devices {
       device {
               vendor                  "*"
               product                 "*"
               getuid_callout          "/lib/udev/scsi_id --whitelisted 
--device=/dev/%n"
               path_selector           "round-robin 0"
               path_grouping_policy    failover
               failback                immediate
               rr_weight               priorities
               no_path_retry           5
               rr_min_io               1000
               path_checker            tur
               prio                    const
       }
}

And it *appears* to work:

# multipath -ll
mpathak (35000c500418ae7db) dm-18 SEAGATE,ST33000651SS
size=2.7T features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=1 status=active
| `- 0:0:24:0  sdx  65:112 active ready running
`-+- policy='round-robin 0' prio=1 status=enabled
   `- 0:0:84:0  sdce 69:32  active ready running
mpathr (35000c500419206c3) dm-3 SEAGATE,ST33000651SS
size=2.7T features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=1 status=active
| `- 0:0:19:0  sds  65:32  active ready running
`-+- policy='round-robin 0' prio=1 status=enabled
   `- 0:0:79:0  sdbz 68:208 active ready running
mpathe (35000c500418b9ca7) dm-15 SEAGATE,ST33000651SS
size=2.7T features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=1 status=active
| `- 0:0:11:0  sdk  8:160  active ready running
`-+- policy='round-robin 0' prio=1 status=enabled
   `- 0:0:71:0  sdbr 68:80  active ready running
mpathbc (35000c500418ac97f) dm-55 SEAGATE,ST33000651SS
size=2.7T features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=1 status=active
| `- 0:0:59:0  sdbg 67:160 active ready running
`-+- policy='round-robin 0' prio=1 status=enabled
   `- 0:0:119:0 sddn 71:80  active ready running
mpathaw (35000cca01a8e7174) dm-32 HITACHI,HUS723030ALS641
size=2.7T features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=1 status=active
| `- 0:0:35:0  sdai 66:32  active ready running
`-+- policy='round-robin 0' prio=1 status=enabled
   `- 0:0:95:0  sdcp 69:208 active ready running

But I cannot write to the disks, I get I/O errors.  When I reboot I 
still get the thousands of SCSI errors on boot from mpt2sas, etc.  I'm 
completely stuck.  Does anyone have any ideas?  Or, is there a better 
place to ask this question?

Many, many thanks!
-erich
