From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Is this a termination problem?
Date: Fri, 12 Apr 2002 03:07:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CB63355.F90055C@fl.priv.at>
Reply-To: linux-scsi@vger.kernel.org, Friedrich Lobenstock <fl@fl.priv.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

I'm having trouble with a remote server. Can someone tell if the
message below comes from a scsi termination problem?

Apr 12 02:48:27 backup kernel: (scsi1:0:3:-1) Unexpected busfree, LASTPHASE = 0xa0, SEQADDR = 0x162
Apr 12 02:48:28 backup kernel: st0: Error with sense data: Current st09:00: sns = 70  5
Apr 12 02:48:28 backup kernel: ASC=20 ASCQ= 0
Apr 12 02:48:28 backup kernel: Raw sense data:0x70 0x00 0x05 0x00 0x00 0x00 0x00 0x0e 0x00 0x00 0x00 0x00 0x20 0x00 0x00 0x00 0x2c 0x01 0x00 0x00 0x00 0x00

This is with the old aic7xxx driver, but with the newer (Adaptec) aic7xxx
driver I get similar messages:

Apr 11 08:59:40 backup kernel: (scsi1:A:3:0): Unexpected busfree in Message-out phase
Apr 11 08:59:40 backup kernel: SEQADDR == 0x168
Apr 11 08:59:40 backup kernel: st0: Error 70000 (sugg. bt 0x0, driver bt 0x0, host bt 0x7).
Apr 11 08:59:40 backup kernel: st0: Error with sense data: Current st09:00: sns = 70  5
Apr 11 08:59:40 backup kernel: ASC=20 ASCQ= 0
Apr 11 08:59:40 backup kernel: Raw sense data:0x70 0x00 0x05 0x00 0x00 0x00 0x00 0x0e 0x00 0x00 0x00 0x00 0x20 0x00 0x00 0x00 0x2c 0x01 0x00 0x00 0x00 0x00


The setup:
backup:~ # uname -a
Linux backup 2.4.16-4GB #1 Fri Mar 22 15:38:04 GMT 2002 i686 unknown

backup:~ # cat /etc/SuSE-release
SuSE Linux 7.3 (i386)
VERSION = 7.3

backup:~ # cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: 3ware    Model: 3w-xxxx          Rev: 1.0
  Type:   Direct-Access                    ANSI SCSI revision: ffffffff
Host: scsi1 Channel: 00 Id: 03 Lun: 00
  Vendor: HP       Model: Ultrium 1-SCSI   Rev: E15D
  Type:   Sequential-Access                ANSI SCSI revision: 03

backup:~ # cat /proc/scsi/aic7xxx/1
Adaptec AIC7xxx driver version: 5.2.4/5.2.0
Compile Options:
  TCQ Enabled By Default : Enabled
  AIC7XXX_PROC_STATS     : Enabled

Adapter Configuration:
           SCSI Adapter: Adaptec AIC-7892 Ultra 160/m SCSI host adapter
                           Ultra-160/m LVD/SE Wide Controller at PCI 0/9/0
    PCI MMAPed I/O Base: 0xdffee000
 Adapter SEEPROM Config: SEEPROM found and used.
      Adaptec SCSI BIOS: Enabled
                    IRQ: 11
                   SCBs: Active 0, Max Active 1,
                         Allocated 31, HW 32, Page 255
             Interrupts: 159823
      BIOS Control Word: 0x08f4
   Adapter Control Word: 0x7c5d
   Extended Translation: Enabled
Disconnect Enable Flags: 0xffff
     Ultra Enable Flags: 0x0000
 Tag Queue Enable Flags: 0x0000
Ordered Queue Tag Flags: 0x0000
Default Tag Queue Depth: 24
    Tagged Queue By Device array for aic7xxx host instance 0:
      {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    Actual queue depth per device for aic7xxx host instance 0:
      {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}

Statistics:

(scsi1:0:3:0)
  Device using Wide/Sync transfers at 80.0 MByte/sec, offset 15
  Transinfo settings: current(10/15/1/0), goal(9/127/1/0), user(9/127/1/2)
  Total transfers 159701 (2 reads and 159699 writes)
             < 2K      2K+     4K+     8K+    16K+    32K+    64K+   128K+
   Reads:       0       0       0       1       0       1       0       0
  Writes:       0       0       0   79866      11   79822       0       0


PS: As I'm not on this list please CC me on any replies. THX.

-- 
MfG / Regards
Friedrich Lobenstock
