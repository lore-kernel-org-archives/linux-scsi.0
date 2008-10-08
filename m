From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: LSISAS1068 ioerr_cnt 0x1 on clean boot up
Date: Wed, 08 Oct 2008 12:52:53 +0200
Message-ID: <48EC9105.2070604@interlog.com>
References: <20081007014608.GA28229@apaithan-desktop.sanmateo.corp.akamai.com> <6A4D764DC1BDE14495DA8DC60A3D69531E967A073C@hkgmail01.lsi.com> <20081007233700.GA6439@apaithan-desktop.sanmateo.corp.akamai.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:38987 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbYJHKxE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2008 06:53:04 -0400
In-Reply-To: <20081007233700.GA6439@apaithan-desktop.sanmateo.corp.akamai.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

Abhijit Paithankar wrote:
> Hi Sathya,
> 
> Doesn't the bus get reset upon power on? Is that a valid reason to bump
> up ioerr_cnt?

This is not so simple. Either end of a SAS connection (i.e. host or
target) can instigate a hard reset **. Then both ends go into a
little dance together and certain states are reset to their
default values. This is the reason a Unit Attention (UA) is sent
to the host by the target.

IMO it is not an error for the host to receive such UAs just
after power up, and soon thereafter. It is potentially an error
to have such UAs while a partition on a LU within a target is
mounted. But the SCSI subsystem is not aware of mounts. Perhaps
there should be a separate counter (i.e. other than ioerr_cnt) for
UAs associated with hard resets.


** In some situations a SAS expander between the host and target
    may also originate a hard reset (e.g. when the expander is
    instructed to via SMP)

    BTW the term "bus reset" is deprecated (at least it dies with
    the SCSI parallel interface) and replaced by the term "hard
    reset". Further in the SAS world there is a "link reset" which
    resets a point to point (phy to phy) link without upsetting
    higher layers. However SATA disks don't differentiate between
    "link resets" and "hard resets", leading to more SATA disk
    resets than would be the case if a SAS disk was in that
    location.

Doug Gilbert


> Also, following your suggestion, I tried with different disks and all of
> them show the 0x1 count on the controller while it is 0x0 on others.
> 
> I have also tried the LSI53C1030 (FwRev=01032700h) controller and the
> result is the same. ioerr_cnt is still 0x1.
> 
> However, when I attach any of those SATA disks to, say, an ICH
> controller, the ioerr_cnt stays at 0x0.
> 
> Thanks!
> Abhijit
> 
> 
> * Prakash, Sathya (Sathya.Prakash@lsi.com) wrote:
>> Hi Abhijit,
>> I think the reason might be the following failures happen once for each drive. Can you get a drive which is not showing the error, use it and check the ioerr_cnt.
>>
>> [   11.925857] mptscsih: ioc0:  fw_channel = 0, fw_id = 23
>> [   11.925858] mptscsih: ioc0:  request_len = 64, underflow = 0, resid = 64
>> [   11.925860] mptscsih: ioc0:  tag = 188, transfer_count = 0, sc->result = 00000002
>> [   11.925863] mptscsih: ioc0:  iocstatus = success (0x0000), scsi_status = check condition (0x02), scsi_state = (0x01)
>> [   11.925866] mptscsih: ioc0:  [sense_key,asc,ascq]: [0x06,0x29,0x00]
>>
>> The sense key, asc, ascq of 06/29/00 is indicating that there is UNIT_ATTENTION due ti POWER ON, RESET, OR BUS DEVICE RESET OCCURRED.
>>
>> So please check with different set of harddrives/controllers.
>>
>> Thanks
>> Sathya
>> -----Original Message-----
>> From: Abhijit Paithankar [mailto:apaithan@akamai.com]
>> Sent: Tuesday, October 07, 2008 7:16 AM
>> To: linux-scsi@vger.kernel.org; Prakash, Sathya; Moore, Eric
>> Subject: LSISAS1068 ioerr_cnt 0x1 on clean boot up
>>
>> Hi,
>>
>> On a freshly booted machine with LSISAS1068 controller attached to SATA disks, the ioerr_cnt in /sys/block/<disk>/device/ is 0x1.
>>
>> The machine also has 2 other SATA disks attached directly to the on-board ServerWorks controller and the ioerr_cnt for those disks is 0x0; which is what is expected.
>>
>> There does not seem to be any problem with the machine and I think this is just a false alarm. I am able to reproduce this on any other machine with the same SAS controller.
>>
>> I have not tested with any SAS controller other than LSISAS1068.
>>
>> I just want to emphasise that the hardware is not broken.
>>
>> I have pasted the relevant parts from dmesg which has some debug logs.
>>
>> My question is: Is this a known problem?
>>
>> While this is not egregious, it does confuse the users/applications that monitor that counter.
>>
>> Thanks!
>> Abhijit
>>
>> ---- More Info ----
>>
>> root@172.24.196.34:~# uname -a
>> Linux 2.6.26.5 #3 SMP Mon Oct 6 17:40:07 PDT 2008 i686 GNU/Linux root@172.24.196.34:~# cat /proc/mpt/ioc0/summary
>> ioc0: LSISAS1068 B0, FwRev=010b0000h, Ports=1, MaxQ=511, IRQ=223 root@172.24.196.34:~# cat /proc/scsi/scsi Attached devices:
>> Host: scsi2 Channel: 00 Id: 00 Lun: 00
>>   Vendor: ATA      Model: WDC WD2500YD-01N Rev: 10.0
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>> Host: scsi3 Channel: 00 Id: 00 Lun: 00
>>   Vendor: ATA      Model: WDC WD2500YD-01N Rev: 10.0
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>> Host: scsi4 Channel: 00 Id: 00 Lun: 00
>>   Vendor: ATA      Model: WDC WD5000KS-00M Rev: 2E07
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>> Host: scsi4 Channel: 00 Id: 01 Lun: 00
>>   Vendor: ATA      Model: WDC WD5000KS-00M Rev: 2E07
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>> Host: scsi4 Channel: 00 Id: 02 Lun: 00
>>   Vendor: ATA      Model: WDC WD5000KS-00M Rev: 2E07
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>> Host: scsi4 Channel: 00 Id: 03 Lun: 00
>>   Vendor: ATA      Model: WDC WD5000KS-00M Rev: 2E07
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>> Host: scsi4 Channel: 00 Id: 04 Lun: 00
>>   Vendor: ATA      Model: WDC WD5000KS-00M Rev: 2E07
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>> Host: scsi4 Channel: 00 Id: 05 Lun: 00
>>   Vendor: ATA      Model: WDC WD5000KS-00M Rev: 2E07
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>> Host: scsi4 Channel: 00 Id: 06 Lun: 00
>>   Vendor: ATA      Model: WDC WD5000KS-00M Rev: 2E07
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>> Host: scsi4 Channel: 00 Id: 07 Lun: 00
>>   Vendor: ATA      Model: WDC WD5000KS-00M Rev: 2E07
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>> root@172.24.196.34:~# cat /sys/block/sd{a,b,c,d,e,f,g,h,i,j}/device/ioerr_cnt
>> 0x0
>> 0x0
>> 0x1
>> 0x1
>> 0x1
>> 0x1
>> 0x1
>> 0x1
>> 0x1
>> 0x1
>> root@172.24.196.34:~# dmesg
>> node: 172.24.196.34
>> --snip--
>> [    3.937448] libata version 3.00 loaded.
>> [    3.938449] sata_svw 0000:01:0e.0: version 2.3
>> [    3.938449] ACPI: PCI Interrupt 0000:01:0e.0[A] -> GSI 11 (level, low) -> IRQ 11
>> [    3.938449] scsi0 : sata_svw
>> [    3.938449] scsi1 : sata_svw
>> [    3.938449] scsi2 : sata_svw
>> [    3.938449] scsi3 : sata_svw
>> [    3.938449] ata1: SATA max UDMA/133 mmio m8192@0xfcafe000 port 0xfcafe000 irq 11
>> [    3.938449] ata2: SATA max UDMA/133 mmio m8192@0xfcafe000 port 0xfcafe100 irq 11
>> [    3.938449] ata3: SATA max UDMA/133 mmio m8192@0xfcafe000 port 0xfcafe200 irq 11
>> [    3.938449] ata4: SATA max UDMA/133 mmio m8192@0xfcafe000 port 0xfcafe300 irq 11
>> [    4.252893] ata1: SATA link down (SStatus 4 SControl 300)
>> [    4.568160] ata2: SATA link down (SStatus 4 SControl 300)
>> [    4.872744] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    4.875844] ata3.00: ATA-7: WDC WD2500YD-01NVB1, 10.02E01, max UDMA/133
>> [    4.875846] ata3.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/1)
>> [    4.878836] ata3.00: configured for UDMA/133
>> [    5.183485] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    5.186579] ata4.00: ATA-7: WDC WD2500YD-01NVB1, 10.02E01, max UDMA/133
>> [    5.186581] ata4.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/1)
>> [    5.189576] ata4.00: configured for UDMA/133
>> [    5.189576] scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500YD-01N 10.0 PQ: 0 ANSI: 5
>> [    5.190064] sd 2:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
>> [    5.190064] sd 2:0:0:0: [sda] Write Protect is off
>> [    5.190064] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> [    5.190064] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    5.190064] sd 2:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
>> [    5.190064] sd 2:0:0:0: [sda] Write Protect is off
>> [    5.190064] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> [    5.190064] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    5.190064]  sda: sda1 sda2 sda3
>> [    5.203206] sd 2:0:0:0: [sda] Attached SCSI disk
>> [    5.203206] sd 2:0:0:0: Attached scsi generic sg0 type 0
>> [    5.203206] scsi 3:0:0:0: Direct-Access     ATA      WDC WD2500YD-01N 10.0 PQ: 0 ANSI: 5
>> [    5.203224] sd 3:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
>> [    5.203224] sd 3:0:0:0: [sdb] Write Protect is off
>> [    5.203224] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>> [    5.203224] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    5.203224] sd 3:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
>> [    5.203224] sd 3:0:0:0: [sdb] Write Protect is off
>> [    5.203224] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>> [    5.203224] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    5.203224]  sdb: sdb1 sdb2
>> [    5.219144] sd 3:0:0:0: [sdb] Attached SCSI disk
>> [    5.219144] sd 3:0:0:0: Attached scsi generic sg1 type 0
>> [    5.219144] ACPI: PCI Interrupt 0000:01:0e.1[A] -> GSI 11 (level, low) -> IRQ 11
>> [    5.219144] modprobe used greatest stack depth: 5260 bytes left
>> [    5.223143] Fusion MPT base driver 3.04.06
>> [    5.223143] Copyright (c) 1999-2007 LSI Corporation
>> [    5.231375] Fusion MPT SAS Host driver 3.04.06
>> [    5.231375] ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 20 (level, low) -> IRQ 20
>> [    5.231375] mptbase: ioc0: Initiating bringup
>> [    5.506672] ioc0: LSISAS1068 B0: Capabilities={Initiator}
>> [    5.506705] mptbase: ioc0: PCI-MSI enabled
>> [   11.887067] scsi4 : ioc0: LSISAS1068 B0, FwRev=010b0000h, Ports=1, MaxQ=511, IRQ=223
>> [   11.925533] scsi 4:0:0:0: Direct-Access     ATA      WDC WD5000KS-00M 2E07 PQ: 0 ANSI: 5
>> [   11.925851] scsi 4:0:0:0: CDB: cdb[0]=0x1a: 1a 00 19 00 40 00
>> [   11.925857] mptscsih: ioc0:  fw_channel = 0, fw_id = 23
>> [   11.925858] mptscsih: ioc0:  request_len = 64, underflow = 0, resid = 64
>> [   11.925860] mptscsih: ioc0:  tag = 188, transfer_count = 0, sc->result = 00000002
>> [   11.925863] mptscsih: ioc0:  iocstatus = success (0x0000), scsi_status = check condition (0x02), scsi_state = (0x01)
>> [   11.925866] mptscsih: ioc0:  [sense_key,asc,ascq]: [0x06,0x29,0x00]
>> [   11.926546] sd 4:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
>> [   11.927635] sd 4:0:0:0: [sdc] Write Protect is off
>> [   11.927637] sd 4:0:0:0: [sdc] Mode Sense: 67 00 00 08
>> [   11.929830] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   11.930655] sd 4:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
>> [   11.931747] sd 4:0:0:0: [sdc] Write Protect is off
>> [   11.931749] sd 4:0:0:0: [sdc] Mode Sense: 67 00 00 08
>> [   11.933920] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   11.933924]  sdc: sdc1 sdc2 sdc3
>> [   11.952064] sd 4:0:0:0: [sdc] Attached SCSI disk
>> [   11.952064] sd 4:0:0:0: Attached scsi generic sg2 type 0
>> [   11.955063] scsi 4:0:1:0: Direct-Access     ATA      WDC WD5000KS-00M 2E07 PQ: 0 ANSI: 5
>> [   11.955599] scsi 4:0:1:0: CDB: cdb[0]=0x1a: 1a 00 19 00 40 00
>> [   11.955599] mptscsih: ioc0:  fw_channel = 0, fw_id = 26
>> [   11.955599] mptscsih: ioc0:  request_len = 64, underflow = 0, resid = 64
>> [   11.955599] mptscsih: ioc0:  tag = 203, transfer_count = 0, sc->result = 00000002
>> [   11.955599] mptscsih: ioc0:  iocstatus = success (0x0000), scsi_status = check condition (0x02), scsi_state = (0x01)
>> [   11.955599] mptscsih: ioc0:  [sense_key,asc,ascq]: [0x06,0x29,0x00]
>> [   11.956122] sd 4:0:1:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
>> [   11.957320] sd 4:0:1:0: [sdd] Write Protect is off
>> [   11.957322] sd 4:0:1:0: [sdd] Mode Sense: 67 00 00 08
>> [   11.959697] sd 4:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   11.960041] sd 4:0:1:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
>> [   11.961136] sd 4:0:1:0: [sdd] Write Protect is off
>> [   11.961138] sd 4:0:1:0: [sdd] Mode Sense: 67 00 00 08
>> [   11.963300] sd 4:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   11.963302]  sdd: sdd1 sdd2
>> [   11.979616] sd 4:0:1:0: [sdd] Attached SCSI disk
>> [   11.979616] sd 4:0:1:0: Attached scsi generic sg3 type 0
>> [   11.981992] scsi 4:0:2:0: Direct-Access     ATA      WDC WD5000KS-00M 2E07 PQ: 0 ANSI: 5
>> [   11.982308] scsi 4:0:2:0: CDB: cdb[0]=0x1a: 1a 00 19 00 40 00
>> [   11.982313] mptscsih: ioc0:  fw_channel = 0, fw_id = 20
>> [   11.982314] mptscsih: ioc0:  request_len = 64, underflow = 0, resid = 64
>> [   11.982316] mptscsih: ioc0:  tag = 218, transfer_count = 0, sc->result = 00000002
>> [   11.982319] mptscsih: ioc0:  iocstatus = success (0x0000), scsi_status = check condition (0x02), scsi_state = (0x01)
>> [   11.982321] mptscsih: ioc0:  [sense_key,asc,ascq]: [0x06,0x29,0x00]
>> [   11.983026] sd 4:0:2:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
>> [   11.984116] sd 4:0:2:0: [sde] Write Protect is off
>> [   11.984118] sd 4:0:2:0: [sde] Mode Sense: 67 00 00 08
>> [   11.986614] sd 4:0:2:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   11.986948] sd 4:0:2:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
>> [   11.988125] sd 4:0:2:0: [sde] Write Protect is off
>> [   11.988127] sd 4:0:2:0: [sde] Mode Sense: 67 00 00 08
>> [   11.990471] sd 4:0:2:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   11.990473]  sde: sde1 sde2
>> [   12.007692] sd 4:0:2:0: [sde] Attached SCSI disk
>> [   12.007692] sd 4:0:2:0: Attached scsi generic sg4 type 0
>> [   12.009935] scsi 4:0:3:0: Direct-Access     ATA      WDC WD5000KS-00M 2E07 PQ: 0 ANSI: 5
>> [   12.010252] scsi 4:0:3:0: CDB: cdb[0]=0x1a: 1a 00 19 00 40 00
>> [   12.010256] mptscsih: ioc0:  fw_channel = 0, fw_id = 19
>> [   12.010258] mptscsih: ioc0:  request_len = 64, underflow = 0, resid = 64
>> [   12.010260] mptscsih: ioc0:  tag = 233, transfer_count = 0, sc->result = 00000002
>> [   12.010262] mptscsih: ioc0:  iocstatus = success (0x0000), scsi_status = check condition (0x02), scsi_state = (0x01)
>> [   12.010264] mptscsih: ioc0:  [sense_key,asc,ascq]: [0x06,0x29,0x00]
>> [   12.011143] sd 4:0:3:0: [sdf] 976773168 512-byte hardware sectors (500108 MB)
>> [   12.012232] sd 4:0:3:0: [sdf] Write Protect is off
>> [   12.012234] sd 4:0:3:0: [sdf] Mode Sense: 67 00 00 08
>> [   12.014408] sd 4:0:3:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   12.014957] sd 4:0:3:0: [sdf] 976773168 512-byte hardware sectors (500108 MB)
>> [   12.016045] sd 4:0:3:0: [sdf] Write Protect is off
>> [   12.016047] sd 4:0:3:0: [sdf] Mode Sense: 67 00 00 08
>> [   12.018218] sd 4:0:3:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   12.018220]  sdf: sdf1 sdf2
>> [   12.032695] sd 4:0:3:0: [sdf] Attached SCSI disk
>> [   12.032695] sd 4:0:3:0: Attached scsi generic sg5 type 0
>> [   12.036315] scsi 4:0:4:0: Direct-Access     ATA      WDC WD5000KS-00M 2E07 PQ: 0 ANSI: 5
>> [   12.036632] scsi 4:0:4:0: CDB: cdb[0]=0x1a: 1a 00 19 00 40 00
>> [   12.036636] mptscsih: ioc0:  fw_channel = 0, fw_id = 21
>> [   12.036638] mptscsih: ioc0:  request_len = 64, underflow = 0, resid = 64
>> [   12.036640] mptscsih: ioc0:  tag = 248, transfer_count = 0, sc->result = 00000002
>> [   12.036642] mptscsih: ioc0:  iocstatus = success (0x0000), scsi_status = check condition (0x02), scsi_state = (0x01)
>> [   12.036645] mptscsih: ioc0:  [sense_key,asc,ascq]: [0x06,0x29,0x00]
>> [   12.037173] sd 4:0:4:0: [sdg] 976773168 512-byte hardware sectors (500108 MB)
>> [   12.038242] sd 4:0:4:0: [sdg] Write Protect is off
>> [   12.038244] sd 4:0:4:0: [sdg] Mode Sense: 67 00 00 08
>> [   12.040407] sd 4:0:4:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   12.040942] sd 4:0:4:0: [sdg] 976773168 512-byte hardware sectors (500108 MB)
>> [   12.042016] sd 4:0:4:0: [sdg] Write Protect is off
>> [   12.042018] sd 4:0:4:0: [sdg] Mode Sense: 67 00 00 08
>> [   12.044170] sd 4:0:4:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   12.044172]  sdg: sdg1 sdg2
>> [   12.059692] sd 4:0:4:0: [sdg] Attached SCSI disk
>> [   12.059692] sd 4:0:4:0: Attached scsi generic sg6 type 0
>> [   12.062691] scsi 4:0:5:0: Direct-Access     ATA      WDC WD5000KS-00M 2E07 PQ: 0 ANSI: 5
>> [   12.063246] scsi 4:0:5:0: CDB: cdb[0]=0x1a: 1a 00 19 00 40 00
>> [   12.063246] mptscsih: ioc0:  fw_channel = 0, fw_id = 25
>> [   12.063246] mptscsih: ioc0:  request_len = 64, underflow = 0, resid = 64
>> [   12.063246] mptscsih: ioc0:  tag = 263, transfer_count = 0, sc->result = 00000002
>> [   12.063246] mptscsih: ioc0:  iocstatus = success (0x0000), scsi_status = check condition (0x02), scsi_state = (0x01)
>> [   12.063246] mptscsih: ioc0:  [sense_key,asc,ascq]: [0x06,0x29,0x00]
>> [   12.063934] sd 4:0:5:0: [sdh] 976773168 512-byte hardware sectors (500108 MB)
>> [   12.064980] sd 4:0:5:0: [sdh] Write Protect is off
>> [   12.064980] sd 4:0:5:0: [sdh] Mode Sense: 67 00 00 08
>> [   12.067671] sd 4:0:5:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   12.068354] sd 4:0:5:0: [sdh] 976773168 512-byte hardware sectors (500108 MB)
>> [   12.069352] sd 4:0:5:0: [sdh] Write Protect is off
>> [   12.069352] sd 4:0:5:0: [sdh] Mode Sense: 67 00 00 08
>> [   12.071602] sd 4:0:5:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   12.071604]  sdh: sdh1 sdh2
>> [   12.091294] sd 4:0:5:0: [sdh] Attached SCSI disk
>> [   12.091294] sd 4:0:5:0: Attached scsi generic sg7 type 0
>> [   12.093626] scsi 4:0:6:0: Direct-Access     ATA      WDC WD5000KS-00M 2E07 PQ: 0 ANSI: 5
>> [   12.093942] scsi 4:0:6:0: CDB: cdb[0]=0x1a: 1a 00 19 00 40 00
>> [   12.093947] mptscsih: ioc0:  fw_channel = 0, fw_id = 22
>> [   12.093948] mptscsih: ioc0:  request_len = 64, underflow = 0, resid = 64
>> [   12.093950] mptscsih: ioc0:  tag = 278, transfer_count = 0, sc->result = 00000002
>> [   12.093953] mptscsih: ioc0:  iocstatus = success (0x0000), scsi_status = check condition (0x02), scsi_state = (0x01)
>> [   12.093955] mptscsih: ioc0:  [sense_key,asc,ascq]: [0x06,0x29,0x00]
>> [   12.094641] sd 4:0:6:0: [sdi] 976773168 512-byte hardware sectors (500108 MB)
>> [   12.095713] sd 4:0:6:0: [sdi] Write Protect is off
>> [   12.095715] sd 4:0:6:0: [sdi] Mode Sense: 67 00 00 08
>> [   12.097879] sd 4:0:6:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   12.098419] sd 4:0:6:0: [sdi] 976773168 512-byte hardware sectors (500108 MB)
>> [   12.099398] sd 4:0:6:0: [sdi] Write Protect is off
>> [   12.099398] sd 4:0:6:0: [sdi] Mode Sense: 67 00 00 08
>> [   12.101972] sd 4:0:6:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   12.101974]  sdi: sdi1 sdi2
>> [   12.120285] sd 4:0:6:0: [sdi] Attached SCSI disk
>> [   12.120285] sd 4:0:6:0: Attached scsi generic sg8 type 0
>> [   12.123507] scsi 4:0:7:0: Direct-Access     ATA      WDC WD5000KS-00M 2E07 PQ: 0 ANSI: 5
>> [   12.123823] scsi 4:0:7:0: CDB: cdb[0]=0x1a: 1a 00 19 00 40 00
>> [   12.123827] mptscsih: ioc0:  fw_channel = 0, fw_id = 18
>> [   12.123829] mptscsih: ioc0:  request_len = 64, underflow = 0, resid = 64
>> [   12.123831] mptscsih: ioc0:  tag = 293, transfer_count = 0, sc->result = 00000002
>> [   12.123834] mptscsih: ioc0:  iocstatus = success (0x0000), scsi_status = check condition (0x02), scsi_state = (0x01)
>> [   12.123836] mptscsih: ioc0:  [sense_key,asc,ascq]: [0x06,0x29,0x00]
>> [   12.124689] sd 4:0:7:0: [sdj] 976773168 512-byte hardware sectors (500108 MB)
>> [   12.125762] sd 4:0:7:0: [sdj] Write Protect is off
>> [   12.125764] sd 4:0:7:0: [sdj] Mode Sense: 67 00 00 08
>> [   12.127926] sd 4:0:7:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   12.128455] sd 4:0:7:0: [sdj] 976773168 512-byte hardware sectors (500108 MB)
>> [   12.129522] sd 4:0:7:0: [sdj] Write Protect is off
>> [   12.129524] sd 4:0:7:0: [sdj] Mode Sense: 67 00 00 08
>> [   12.131723] sd 4:0:7:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   12.131725]  sdj: sdj1
>> [   12.145182] sd 4:0:7:0: [sdj] Attached SCSI disk
>> [   12.145182] sd 4:0:7:0: Attached scsi generic sg9 type 0
>>
>> --snip--
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

