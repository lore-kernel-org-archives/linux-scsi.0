From: Andrew R Reid <andrew@cpplating.com.au>
Subject: Problems with DLT tape drive.
Date: Mon, 27 May 2002 12:11:59 +1000 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <acs51r$dha$2@main.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-tape@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

I hope that I have come to the right place.  I have spent the whole
weekend trying to fix a problem with a DLT Tape drive that I have bought
second hand.

I keep on getting the following message when I try to back up to it.

tar: Removing leading `/' from member names
tar: /dev/st0: Cannot write: Input/output error
tar: Error is not recoverable: exiting now

This error occurs at a random time into the backup.  It ssems not to
matter if I have compression turned on or off on the tape drive and
doesn't seem to matter if the data is easily compressible or not.

The kernel reports the following.

May 27 11:44:42 cpserver kernel: (scsi2:0:4:0) Data overrun detected in Data-Out phase, tag 0;
May 27 11:44:42 cpserver kernel:   Have seen Data Phase. Length=10240, NumSGs=1.
May 27 11:44:42 cpserver kernel:   Raw SCSI Command: 0x0a 00 00 28 00 00 
May 27 11:44:42 cpserver kernel: st0: Error 27070000 (sugg. bt 0x20, driver bt 0x27, host bt 0x7).

I have the following scsi controlers on my system.

Intel Lancewood onboard #1

Adaptec AIC7xxx driver version: 5.1.33/3.2.4
Compile Options:
  TCQ Enabled By Default : Disabled
  AIC7XXX_PROC_STATS     : Enabled
  AIC7XXX_RESET_DELAY    : 5

Adapter Configuration:
           SCSI Adapter: Adaptec AIC-7896/7 Ultra2 SCSI host adapter
                           Ultra-2 LVD/SE Wide Controller Channel A at PCI 0/12/0
    PCI MMAPed I/O Base: 0xf4120000
 Adapter SEEPROM Config: SEEPROM found and used.
      Adaptec SCSI BIOS: Enabled
                    IRQ: 19
                   SCBs: Active 0, Max Active 1,
                         Allocated 15, HW 32, Page 255
             Interrupts: 155498
      BIOS Control Word: 0x18a6
   Adapter Control Word: 0x1c5e
   Extended Translation: Enabled
Disconnect Enable Flags: 0xffff
     Ultra Enable Flags: 0x0000
 Tag Queue Enable Flags: 0x0000
Ordered Queue Tag Flags: 0x0000
Default Tag Queue Depth: 8
    Tagged Queue By Device array for aic7xxx host instance 0:
      {255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255}
    Actual queue depth per device for aic7xxx host instance 0:
      {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}

Statistics:

(scsi0:0:0:0)
  Device using Wide/Sync transfers at 80.0 MByte/sec, offset 31
  Transinfo settings: current(10/31/1/0), goal(10/127/1/0), user(10/127/1/0)
  Total transfers 155444 (90680 reads and 64764 writes)
             < 2K      2K+     4K+     8K+    16K+    32K+    64K+   128K+
   Reads:   15458     606   63034    7441    1711     943    1487       0
  Writes:   24033   13752   19188    5631    1040     398     722       0

Intel Lancewood Onboard #2

Adaptec AIC7xxx driver version: 5.1.33/3.2.4
Compile Options:
  TCQ Enabled By Default : Disabled
  AIC7XXX_PROC_STATS     : Enabled
  AIC7XXX_RESET_DELAY    : 5

Adapter Configuration:
           SCSI Adapter: Adaptec AIC-7896/7 Ultra2 SCSI host adapter
                           Ultra-2 LVD/SE Wide Controller Channel B at PCI 0/12/1
    PCI MMAPed I/O Base: 0xf4121000
 Adapter SEEPROM Config: SEEPROM found and used.
      Adaptec SCSI BIOS: Enabled
                    IRQ: 19
                   SCBs: Active 0, Max Active 1,
                         Allocated 15, HW 32, Page 255
             Interrupts: 30
      BIOS Control Word: 0x18a6
   Adapter Control Word: 0x1c5e
   Extended Translation: Enabled
Disconnect Enable Flags: 0xffff
     Ultra Enable Flags: 0x0000
 Tag Queue Enable Flags: 0x0000
Ordered Queue Tag Flags: 0x0000
Default Tag Queue Depth: 8
    Tagged Queue By Device array for aic7xxx host instance 1:
      {255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255}
    Actual queue depth per device for aic7xxx host instance 1:
      {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}

Statistics:

Adaptec 2930U

Adaptec AIC7xxx driver version: 5.1.33/3.2.4
Compile Options:
  TCQ Enabled By Default : Disabled
  AIC7XXX_PROC_STATS     : Enabled
  AIC7XXX_RESET_DELAY    : 5

Adapter Configuration:
           SCSI Adapter: Adaptec AIC-7860 Ultra SCSI host adapter
                           Ultra Narrow Controller at PCI 0/13/0
    PCI MMAPed I/O Base: 0xf4122000
 Adapter SEEPROM Config: SEEPROM found and used.
      Adaptec SCSI BIOS: Enabled
                    IRQ: 17
                   SCBs: Active 0, Max Active 1,
                         Allocated 15, HW 3, Page 255
             Interrupts: 4505
      BIOS Control Word: 0x10b6
   Adapter Control Word: 0x0057
   Extended Translation: Enabled
Disconnect Enable Flags: 0x00ff
     Ultra Enable Flags: 0x0000
 Tag Queue Enable Flags: 0x0000
Ordered Queue Tag Flags: 0x0000
Default Tag Queue Depth: 8
    Tagged Queue By Device array for aic7xxx host instance 2:
      {255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255}
    Actual queue depth per device for aic7xxx host instance 2:
      {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}

Statistics:

(scsi2:0:4:0)
  Device using Narrow/Sync transfers at 5.0 MByte/sec, offset 15
  Transinfo settings: current(50/15/0/0), goal(12/15/0/0), user(12/15/0/0)
  Total transfers 4293 (2 reads and 4291 writes)
             < 2K      2K+     4K+     8K+    16K+    32K+    64K+   128K+
   Reads:       0       0       0       2       0       0       0       0
  Writes:       0       0       0    4291       0       0       0       0


(scsi2:0:5:0)
  Device using Narrow/Async transfers.
  Transinfo settings: current(0/0/0/0), goal(255/0/0/0), user(12/15/0/0)
  Total transfers 109 (90 reads and 19 writes)
             < 2K      2K+     4K+     8K+    16K+    32K+    64K+   128K+
   Reads:      90       0       0       0       0       0       0       0
  Writes:      14       5       0       0       0       0       0       0


(scsi2:0:6:0)
  Device using Narrow/Async transfers.
  Transinfo settings: current(0/0/0/0), goal(255/0/0/0), user(12/15/0/0)
  Total transfers 0 (0 reads and 0 writes)
             < 2K      2K+     4K+     8K+    16K+    32K+    64K+   128K+
   Reads:       0       0       0       0       0       0       0       0
  Writes:       0       0       0       0       0       0       0       0

The devices I have attached are as follows.

Attached devices: 
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM      Model: DNES-309170W     Rev: SA30
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 04 Lun: 00
  Vendor: DEC      Model: DLT2000          Rev: 8528
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi2 Channel: 00 Id: 05 Lun: 00
  Vendor: IOMEGA   Model: ZIP 100          Rev: J.02
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi2 Channel: 00 Id: 06 Lun: 00
  Vendor: AGFA     Model: SnapScan         Rev: 1.10
  Type:   Scanner                          ANSI SCSI revision: 02

I am running Debian GNU/Linux kernel 2.2.19 which I believe is the latest
2.2 stable kernel.

I have aic7xxx compiled into the running kernel, while st.o is inserted as
a module.

I have tried the buffer_kbs=128 option, as suggested in various HOWTOs and
have played with the other options for this module, but to no avail.  I
don't really know what these options do, even after reading
/usr/src/linux/drivers/scsi/README.st.

I know I may be a little slow, but please bear with me.

As you can see I have a iomega zip and a Agfa snapscan connected to the
same scsi bus.  I have a micro 50 to centronics 50 pin cable from the
host adaptor to the DLT drive.  I have a 50 pin centronics to DB25 cable
from the DLT drive to the zip drive and a db25-db25 cable from there to
the scanner.  The scanner is terminated with a db25 passive terminator.

After reading a SCSI FAQ, I have a feeling that mixing 25 pin devices with
50 pin devices may not be a good idea, but this is the only option I have
at present without playing around a good deal to use the second host
adaptor on the mainboard.

I have had no problems untill I installed the DLT drive.  I have had
confirmation the the DLT drive was working up until the time I purchased
it.  It was in operation in a large government department.

I am using a new tape.  I cleaned the heads prior to using it.

Your feedback on this issue is very much appreciated.

Thank you to the community involved with producing the aic7xxx and
the st drivers.  Also to the folk who have written the mt software.  I
know many who use this software with great success.

Regards,

Andrew Reid			C.P.Plating
Technical Sales Manager		P O Box 1335	   --------- /---    /---\
C. P. Plating Pty Ltd		222a Macathur Ave   ------- /       /    /
Mob:    +61 4 1474 9943		EAGLE FARM 4009      ----- /       /----/
Direct: +61 7 3260 3260		AUSTRALIA	      --- /       /
e-mail: andrew@cpplating.com.au	Phn: +61 7 3268 3044   - |---- o /   o
				Fax: +61 7 3268 3433

