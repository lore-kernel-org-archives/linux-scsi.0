From: Andrew Morton <akpm@digeo.com>
Subject: aic7xxx woes in 2.5
Date: Sat, 14 Dec 2002 20:31:22 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DFC059A.9AA3F75F@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id UAA24902
	for <linux-scsi@vger.kernel.org>; Sat, 14 Dec 2002 20:31:22 -0800 (PST)
Received: from digeo-e2k04.digeo.com ([192.168.2.24])
 by digeo-nav01.digeo.com (NAVGW 2.5.2.12) with SMTP id M2002121420331927623
 for <linux-scsi@vger.kernel.org>; Sat, 14 Dec 2002 20:33:19 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


For about six months in the 2.5 series, using aic7xxx, about every fourth boot
one of my disks tends to get:

(scsi1:A:4:0): parity-error detected in Data-in phase: SEQADDR(0x1ae) SCSIRATE(0x88)
scsi1:0:4:0: Attempting to queue an ABORT message

This is invariably fatal.  The box locks and the NMI watchdog
kicks it over.   The call trace is:

(gdb) bt
#0  0xc01d3288 in rep_nop () at include/asm/processor.h:468
#1  0xc01d325d in __delay (loops=98000) at arch/i386/lib/delay.c:63
#2  0xc01d32ad in __const_udelay (xloops=858800) at arch/i386/lib/delay.c:74
#3  0xc01d327c in __udelay (usecs=200) at arch/i386/lib/delay.c:79
#4  0xc0231d7f in ahc_delay (usec=200) at drivers/scsi/aic7xxx/aic7xxx_osm.h:607
#5  0xc022b81e in ahc_clear_critical_section (ahc=0xc3e03000) at drivers/scsi/aic7xxx/aic7xxx_core.c:1392                      #6  0xc0235272 in ahc_linux_queue_recovery_cmd (cmd=0xc1766c00, flag=SCB_ABORT) at drivers/scsi/aic7xxx/aic7xxx_linux.c:2490
#7  0xc023569a in ahc_linux_abort (cmd=0xc1766c00) at drivers/scsi/aic7xxx/aic7xxx_linux.c:2667                                #8  0xc022592b in scsi_try_to_abort_cmd (scmd=0xc1766c00) at drivers/scsi/scsi_error.c:820
#9  0xc0225a0c in scsi_eh_abort_cmd (sc_todo=0xc1766c00, shost=0xc17de63c) at drivers/scsi/scsi_error.c:902                    #10 0xc022614e in scsi_unjam_host (shost=0xc17de63c) at drivers/scsi/scsi_error.c:1532
#11 0xc0226286 in scsi_error_handler (data=0xc17de63c) at drivers/scsi/scsi_error.c:1659                                       

It would seem that the machine locked up in ahc_clear_critical_section():

                do {
                        ahc_delay(200);
                } while (!ahc_is_paused(ahc));

The parity error is intermittent.  But when it happens, the lockup
always happens.

This never happens in 2.4 kernels.

It seems to happen a little more frequently on uniprocessor builds.

So relevant questions would be:

1) Why does only 2.5 get the parity error?

2) Why does the recovery lock up?

3) Does anyone have a diff for Justin's new driver?


lspci:

00:0a.0 SCSI storage controller: Adaptec AIC-7880U (rev 01)
03:04.0 SCSI storage controller: Adaptec 7892A (rev 02)

2.4.19-pre4's dmesg:


scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.5
        <Adaptec 29160 Ultra160 SCSI adapter>
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.5
        <Adaptec aic7880 Ultra SCSI adapter>
        aic7880: Ultra Wide Channel A, SCSI Id=7, 16/253 SCBs

  Vendor: QUANTUM   Model: ATLAS IV 9 SCA    Rev: 0B0B
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: QUANTUM   Model: ATLAS 10K 9SCA    Rev: UC81
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST19101W          Rev: 0014
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: QUANTUM   Model: QM39100TD-SCA     Rev: N1B0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: FUJITSU   Model: MAF3364L SUN36G   Rev: 1213
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ESG-SHV   Model: SCA HSBP M4       Rev: 0.63
  Type:   Processor                          ANSI SCSI revision: 02
scsi0:A:0:0: Tagged Queuing enabled.  Depth 253
scsi0:A:1:0: Tagged Queuing enabled.  Depth 253
scsi0:A:2:0: Tagged Queuing enabled.  Depth 253
scsi0:A:4:0: Tagged Queuing enabled.  Depth 253
scsi0:A:5:0: Tagged Queuing enabled.  Depth 253
  Vendor: QUANTUM   Model: ATLAS 10K 9SCA    Rev: UC81
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: QUANTUM   Model: ATLAS 10K 9SCA    Rev: UCH0
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: QUANTUM   Model: ATLAS 10K 9SCA    Rev: UC81
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: QUANTUM   Model: ATLAS 10K 9SCA    Rev: UCP0
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: FUJITSU   Model: MAF3364L SUN36G   Rev: 1213
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ESG-SHV   Model: SCA HSBP M4       Rev: 0.63
  Type:   Processor                          ANSI SCSI revision: 02
scsi1:A:0:0: Tagged Queuing enabled.  Depth 253
scsi1:A:1:0: Tagged Queuing enabled.  Depth 253
scsi1:A:2:0: Tagged Queuing enabled.  Depth 253
scsi1:A:4:0: Tagged Queuing enabled.  Depth 253
scsi1:A:5:0: Tagged Queuing enabled.  Depth 253
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi0, channel 0, id 1, lun 0
Attached scsi disk sdc at scsi0, channel 0, id 2, lun 0
Attached scsi disk sdd at scsi0, channel 0, id 4, lun 0
Attached scsi disk sde at scsi0, channel 0, id 5, lun 0
Attached scsi disk sdf at scsi1, channel 0, id 0, lun 0
Attached scsi disk sdg at scsi1, channel 0, id 1, lun 0
Attached scsi disk sdh at scsi1, channel 0, id 2, lun 0
Attached scsi disk sdi at scsi1, channel 0, id 4, lun 0
Attached scsi disk sdj at scsi1, channel 0, id 5, lun 0
(scsi0:A:0): 40.000MB/s transfers (20.000MHz, offset 31, 16bit)
SCSI device sda: 17942584 512-byte hdwr sectors (9187 MB)
 sda: sda1
(scsi0:A:1): 40.000MB/s transfers (20.000MHz, offset 31, 16bit)
SCSI device sdb: 17938986 512-byte hdwr sectors (9185 MB)
 sdb: sdb1
(scsi0:A:2): 40.000MB/s transfers (20.000MHz, offset 15, 16bit)
SCSI device sdc: 17783240 512-byte hdwr sectors (9105 MB)
 sdc: sdc1
(scsi0:A:4): 40.000MB/s transfers (20.000MHz, offset 31, 16bit)
SCSI device sdd: 17783249 512-byte hdwr sectors (9105 MB)
 sdd: sdd1 < sdd5 >
(scsi0:A:5): 40.000MB/s transfers (20.000MHz, offset 63, 16bit)
SCSI device sde: 71132959 512-byte hdwr sectors (36420 MB)
 sde: sde1 < sde5 sde6 sde7 >
(scsi1:A:0): 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
SCSI device sdf: 17938986 512-byte hdwr sectors (9185 MB)
 sdf: sdf1
(scsi1:A:1): 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
SCSI device sdg: 17938986 512-byte hdwr sectors (9185 MB)
 sdg: sdg1
(scsi1:A:2): 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
SCSI device sdh: 17938986 512-byte hdwr sectors (9185 MB)
 sdh: sdh1
(scsi1:A:4): 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
SCSI device sdi: 17938986 512-byte hdwr sectors (9185 MB)
 sdi: sdi1 < sdi5 sdi6 >
(scsi1:A:5): 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
SCSI device sdj: 71132959 512-byte hdwr sectors (36420 MB)
 sdj: sdj1 < sdj5 sdj6 >
Attached scsi generic sg5 at scsi0, channel 0, id 6, lun 0,  type 3
Attached scsi generic sg11 at scsi1, channel 0, id 6, lun 0,  type 3
