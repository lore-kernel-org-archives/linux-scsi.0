From: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Subject: aha2940 on 2.6.9
Date: Wed, 17 Nov 2004 14:23:25 +0900 (JST)
Message-ID: <20041117.142325.74756248.chamas@h4.dion.ne.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hfep02.dion.ne.jp ([203.181.105.68]:61717 "EHLO
	hfep02.dion.ne.jp") by vger.kernel.org with ESMTP id S262171AbUKQFX2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 00:23:28 -0500
Received: from localhost ([222.7.43.38]) by hfep02.dion.ne.jp with ESMTP
          id <20041117052326168.MAAO@hfep02.dion.ne.jp>
          for <linux-scsi@vger.kernel.org>; Wed, 17 Nov 2004 14:23:26 +0900
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 Hello, I'm using kernel-2.6 with aha2940.
until 2.6.8.1 it works fine but since 2.6.9, I've been getting message:

  Nov 17 13:45:48 plath kernel: FAILED
  Nov 17 13:45:48 plath kernel:   status = 1, message = 00, host = 0, driver = 08
  Nov 17 13:45:48 plath kernel:   Current sd: sense = 70  5
  Nov 17 13:45:48 plath kernel: ASC=20 ASCQ= 0
  Nov 17 13:45:48 plath kernel: Raw sense data:0x70 0x00 0x05 0x00 0x00 0x00 0x00 0x0a 0x00 0x00 0x00 0x00 0x20 0x00 0x00 0x00 0x00 0x00 

These messages are logged by 2.6.10-rc2.
I feel sorry for I don't know what I shoud suggest to fix this.
So if another informations needed, please teach me.

/proc/scsi/aic7xxx/0:
  Adaptec AIC7xxx driver version: 6.2.36
  Adaptec 2940 SCSI adapter
  aic7870: Single Channel A, SCSI Id=7, 16/253 SCBs
  Allocated SCBs: 4, SG List Length: 128

  Serial EEPROM:
  0x0218 0x0218 0x0218 0x0218 0x0218 0x0218 0x0218 0x0218 
  0x0238 0x0238 0x0238 0x0238 0x0238 0x0238 0x0238 0x0238 
  0x18b6 0x005d 0x2807 0x0008 0xff00 0xffff 0xffff 0xffff 
  0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x00ff 0x6398 

  Target 0 Negotiation Settings
          User: 10.000MB/s transfers (10.000MHz, offset 127)
          Goal: 10.000MB/s transfers (10.000MHz, offset 15)
          Curr: 10.000MB/s transfers (10.000MHz, offset 15)
          Channel A Target 0 Lun 0 Settings
                  Commands Queued 2796
                  Commands Active 0
                  Command Openings 1
                  Max Tagged Openings 0
                  Device Queue Frozen Count 0
  Target 1 Negotiation Settings
          User: 10.000MB/s transfers (10.000MHz, offset 127)
  Target 2 Negotiation Settings
          User: 10.000MB/s transfers (10.000MHz, offset 127)
  Target 3 Negotiation Settings
          User: 10.000MB/s transfers (10.000MHz, offset 127)
  Target 4 Negotiation Settings
          User: 10.000MB/s transfers (10.000MHz, offset 127)
  Target 5 Negotiation Settings
          User: 10.000MB/s transfers (10.000MHz, offset 127)
  Target 6 Negotiation Settings
          User: 10.000MB/s transfers (10.000MHz, offset 127)
  Target 7 Negotiation Settings
          User: 10.000MB/s transfers (10.000MHz, offset 127)

in dmesg:
  Nov 17 13:26:58 plath kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
  Nov 17 13:26:58 plath kernel:         <Adaptec 2940 SCSI adapter>
  Nov 17 13:26:58 plath kernel:         aic7870: Single Channel A, SCSI Id=7, 16/253 SCBs
  Nov 17 13:26:58 plath kernel: 
  Nov 17 13:26:58 plath kernel: (scsi0:A:0): 10.000MB/s transfers (10.000MHz, offset 15)
  Nov 17 13:26:58 plath kernel:   Vendor: I-O DATA  Model: HDVS-UM20G        Rev: 201F
  Nov 17 13:26:58 plath kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
  Nov 17 13:26:58 plath kernel: SCSI device sda: 40031712 512-byte hdwr sectors (20496 MB)
  Nov 17 13:26:58 plath kernel: SCSI device sda: drive cache: write back
  Nov 17 13:26:58 plath kernel:  sda: sda1 sda2 < sda5 sda6 sda7 sda8 > sda3 sda4
  Nov 17 13:26:58 plath kernel: Attached scsi disk sda at scsi0, channel 0, id 0, lun 0

  ----

  Nov 17 14:00:01 plath kernel: (scsi0:A:0:0): SCB 3: requests Check Status
  Nov 17 14:00:01 plath kernel: (scsi0:A:0:0): Sending Sense
  Nov 17 14:00:01 plath kernel: (scsi0:A:0:0): Sending SDTR period 19, offset f
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x80
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x1
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x3
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x1
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x19
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0xf
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_OUT PHASEMIS in Message-in phase
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x1
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x3
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x1
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x19
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0xf
  Nov 17 14:00:01 plath kernel: (scsi0:A:0:0): Received SDTR period 19, offset f
  Nov 17 14:00:01 plath kernel: ^IFiltered to period 19, offset f
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_IN PHASEMIS in Command phase
  Nov 17 14:00:01 plath kernel: (scsi0:A:0:0): Handled Sense Residual of 14 bytes
  Nov 17 14:00:01 plath kernel: Copied 18 bytes of sense data:
  Nov 17 14:00:01 plath kernel: 0x70 0x0 0x5 0x0 0x0 0x0 0x0 0xa 0x0 0x0 0x0 0x0 0x20 0x0 0x0 0x0 
  Nov 17 14:00:01 plath kernel: 0x0 0x0 
  Nov 17 14:00:01 plath kernel: (scsi0:A:0:0): SCB 2: requests Check Status
  Nov 17 14:00:01 plath kernel: (scsi0:A:0:0): Sending Sense
  Nov 17 14:00:01 plath kernel: (scsi0:A:0:0): Sending SDTR period 19, offset f
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x80
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x1
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x3
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x1
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x19
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0xf
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_OUT PHASEMIS in Message-in phase
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x1
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x3
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x1
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x19
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0xf
  Nov 17 14:00:01 plath kernel: (scsi0:A:0:0): Received SDTR period 19, offset f
  Nov 17 14:00:01 plath kernel: ^IFiltered to period 19, offset f
  Nov 17 14:00:01 plath kernel: scsi0:A:0:0: INITIATOR_MSG_IN PHASEMIS in Command phase
  Nov 17 14:00:01 plath kernel: (scsi0:A:0:0): Handled Sense Residual of 14 bytes
  Nov 17 14:00:01 plath kernel: Copied 18 bytes of sense data:
  Nov 17 14:00:01 plath kernel: 0x70 0x0 0x5 0x0 0x0 0x0 0x0 0xa 0x0 0x0 0x0 0x0 0x20 0x0 0x0 0x0 
  Nov 17 14:00:01 plath kernel: 0x0 0x0 
  Nov 17 14:00:01 plath kernel: FAILED
  Nov 17 14:00:01 plath kernel:   status = 1, message = 00, host = 0, driver = 08
  Nov 17 14:00:01 plath kernel:   Current sd: sense = 70  5
  Nov 17 14:00:01 plath kernel: ASC=20 ASCQ= 0
  Nov 17 14:00:01 plath kernel: Raw sense data:0x70 0x00 0x05 0x00 0x00 0x00 0x00 0x0a 0x00 0x00 0x00 0x00 0x20 0x00 0x00 0x00 0x00 0x00 

