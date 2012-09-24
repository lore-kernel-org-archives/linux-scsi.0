From: Lars Randers <lars@nstec.dk>
Subject: Re: [scsi] mpt-fusion: No SES device support?
Date: Mon, 24 Sep 2012 18:13:09 +0200
Message-ID: <CAO5z_vLbtohqMxjEu6VLpQmT8iX_UmJ9kv=rCKgCas3Kuk0W_g@mail.gmail.com>
References: <CAO5z_vJq+LgaE9noZxvxX8Gu_J_+5=ECBuY5OiQ_687cnrq9cw@mail.gmail.com>
	<50607999.9080700@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41051 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab2IXQNL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2012 12:13:11 -0400
Received: by lbbgj3 with SMTP id gj3so6977987lbb.19
        for <linux-scsi@vger.kernel.org>; Mon, 24 Sep 2012 09:13:09 -0700 (PDT)
In-Reply-To: <50607999.9080700@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Peter M. Petrakis" <peter.petrakis@canonical.com>
Cc: linux-scsi@vger.kernel.org

2012/9/24 Peter M. Petrakis <peter.petrakis@canonical.com>:
>
Hi Peter,
thank you for taking the time to look into this.

Sadly I can't run MegaCLI, that utility is for the LSISAS2008+ family
of controllers i believe.

The MPT bios is definately exporting the SES device,
because Windows can see it just fine on the tgt:lun address,
or am I making a false asumption here?

lsscsi -g emits:
[0:0:0:0]    disk    ATA      ST980813ASG      3.AA  /dev/sda   /dev/sg0
[6:0:0:0]    disk    IBM-ESXS ST973401SS       B51D  /dev/sdb   /dev/sg1
[10:0:0:0]   disk    Kingston DataTraveler G2  PMAP  /dev/sdc   /dev/sg2

... so as I expected, I only get /dev/sg<x> devices for the raw disks.

Here's the INQ on the disk:

[root@nas ~]# sg_inq -v /dev/sg1
    inquiry cdb: 12 00 00 00 24 00
standard INQUIRY:
    inquiry cdb: 12 00 00 00 a4 00
  PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=1  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  BQue=0
  EncServ=0  MultiP=1 (VS=0)  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=1  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=164 (0xa4)   Peripheral device type: disk
 Vendor identification: IBM-ESXS
 Product identification: ST973401SS
 Product revision level: B51D
    inquiry cdb: 12 01 00 00 fc 00
    inquiry: pass-through requested 252 bytes but got 18 bytes
    inquiry cdb: 12 01 80 00 fc 00
    inquiry: pass-through requested 252 bytes but got 24 bytes
 Unit serial number: 3LB0A88L00007625PXP4

... and as you specculated, the EncServ is 0, but isn't that right
since the device is indeed a disk?

I don't know if I'm reading your output correctly, but do you get a
/dev/sg<x> wich is not a disk?

I'm afraid that as long as we can't get the mptsas.ko to register the
SES device with sg,
sg_ses will indeed not have anything to work with. That seems to be
the challenge...

>
> On 09/22/2012 03:54 PM, Lars Randers wrote:
>>
>> I can't get the SES device on my MPT controller to show up in Linux as
>> a sg device.
>>
>> The controller is a re-flashed IBM BR10i (LSISAS1068E), running the
>> latest firmware and it is connected
>> to the SES capable backplane via i2c on the SFF-8087 sidebands.
>>
>> Bios post as follows:
>>
>> SLOT  ID   LUN  VENDOR                    PRODUCT
>> REVISION                SIZE \ NV
>> --------- ----- ------- ---------------------------------
>> ------------------------------  ---------------------------
>> ----------------
>>      8       0    0    IBM                            SAS SES-2 DEVICE
>> 01.0
>>      8       1    0    IBM-ESXS                   ST973401SS
>>   B51D                       68 GB
>>      8       2    0    IBM-ESXS                   ST973401SS
>>   B51D                       68 GB
>>      8                  LSILogic                      SAS1068E-IT
>>        1.33.00.00               NV 2D:03
>>
>>
>> Windows 7 reports the device present in device manager.
>>
>> Here's a snip from messages:
>>
>> Sep 22 21:31:15 nas kernel: Fusion MPT base driver 3.04.20
>> Sep 22 21:31:15 nas kernel: Copyright (c) 1999-2008 LSI Corporation
>> Sep 22 21:31:15 nas kernel: Fusion MPT SAS Host driver 3.04.20
>> Sep 22 21:31:15 nas kernel: ACPI: PCI Interrupt Link [APC5] enabled at IRQ
>> 16
>> Sep 22 21:31:15 nas kernel: mptsas 0000:01:00.0: PCI INT A ->
>> Link[APC5] -> GSI 16 (level, low) -> IRQ 16
>> Sep 22 21:31:15 nas kernel: mptbase: ioc0: Initiating bringup
>> Sep 22 21:31:15 nas kernel: ioc0: LSISAS1068E B3: Capabilities={Initiator}
>> Sep 22 21:31:15 nas kernel: scsi7 : ioc0: LSISAS1068E B3,
>> FwRev=01210000h, Ports=1, MaxQ=483, IRQ=16
>> Sep 22 21:31:15 nas kernel: mptsas: ioc0: attaching ssp device:
>> fw_channel 0, fw_id 1, phy 1, sas_addr 0x5000c500002b0f59
>> Sep 22 21:31:15 nas kernel: scsi 7:0:0:0: Direct-Access     IBM-ESXS
>> ST973401SS       B51D PQ: 0 ANSI: 5
>> Sep 22 21:31:15 nas kernel: mptsas: ioc0: attaching ssp device:
>> fw_channel 0, fw_id 2, phy 2, sas_addr 0x5000c500002b0d95
>> Sep 22 21:31:15 nas kernel: scsi 7:0:1:0: Direct-Access     IBM-ESXS
>> ST973401SS       B51D PQ: 0 ANSI: 5
>> Sep 22 21:31:15 nas kernel: sd 7:0:1:0: [sdd] 143374000 512-byte
>> logical blocks: (73.4 GB/68.3 GiB)
>> Sep 22 21:31:15 nas kernel: sd 7:0:0:0: [sdc] 143374000 512-byte
>> logical blocks: (73.4 GB/68.3 GiB)
>> Sep 22 21:31:15 nas kernel: sd 7:0:1:0: [sdd] Write Protect is off
>> Sep 22 21:31:15 nas kernel: sd 7:0:0:0: [sdc] Write Protect is off
>> Sep 22 21:31:15 nas kernel: sd 7:0:1:0: [sdd] Write cache: disabled,
>> read cache: enabled, supports DPO and FUA
>> Sep 22 21:31:15 nas kernel: sd 7:0:0:0: [sdc] Write cache: disabled,
>> read cache: enabled, supports DPO and FUA
>> Sep 22 21:31:15 nas kernel: sd 7:0:1:0: [sdd] Attached SCSI disk
>> Sep 22 21:31:15 nas kernel: sd 7:0:0:0: [sdc] Attached SCSI disk
>> Sep 22 21:31:15 nas kernel: sd 7:0:0:0: Attached scsi generic sg2 type 0
>> Sep 22 21:31:15 nas kernel: sd 7:0:1:0: Attached scsi generic sg3 type 0
>>
>> Looking at mptsas.c with my limited knowledge of the mpt complex, I
>> can't really spot any probes for anything but
>> resources connected directly to the PHY's and ofc the adding of the
>> raid volume if the firmware is running as IR.
>>
>> Is there anyone here who wants to help me get the raw SES device to
>> show up as a /dev/sg<x>
>> so I can use the sg_ses (sg3_utils) commands to control the leds and
>> get environmental readouts?
>
>
> It's there, but for some reason, the LSI controller fails to discovery it.
> Comparing on an IBM branded LSI raid controller.
>
> root@ubuntu:/tmp/dist# lsscsi -g
> [0:0:0:0]    cd/dvd  HL-DT-ST DVD-ROM DH10N    0M10  /dev/sr0  /dev/sg0
> [4:2:0:0]    disk    IBM      ServeRAID M5014  2.0.  /dev/sda  /dev/sg1
> root@ubuntu:/tmp/dist# sg_ses -v /dev/sg1
>     inquiry cdb: 12 00 00 00 24 00
>   IBM  ServeRAID M5014  2.0.
>     disk device (not an enclosure)
>     Receive diagnostic results cmd: 1c 01 00 10 00 00
> Supported diagnostic pages:
>   <unknown> [0x5b]
>
>
>
> Though when I use the proprietary MegaCLI util... [1]
>
> root@ubuntu:/tmp/dist# ./MegaCli64 -PDList -a0
>                                      Adapter #0
>
> Enclosure Device ID: 252
> Slot Number: 0
> Drive's postion: DiskGroup: 0, Span: 0, Arm: 0
> Enclosure position: N/A
> Device Id: 9
> WWN:
> Sequence Number: 2
> Media Error Count: 0
> Other Error Count: 0
> Predictive Failure Count: 0
> Last Predictive Failure Event Seq Number: 0
> PD Type: SAS
>
> Raw Size: 279.396 GB [0x22ecb25c Sectors]
> Non Coerced Size: 278.896 GB [0x22dcb25c Sectors]
> Coerced Size: 278.464 GB [0x22cee000 Sectors]
> Firmware state: Online, Spun Up
> Device Firmware Level: SB19
> Shield Counter: 0
> Successful diagnostics completion on :  N/A
> SAS Address(0): 0x500000e1167824b2
> SAS Address(1): 0x0
> Connected Port Number: 0(path0)
> Inquiry Data: IBM-ESXSMBD2300RC       SB19D0008ALKSB19SB19SB19
> IBM FRU/CRU: 42D0628
> FDE Capable: Not Capable
> FDE Enable: Disable
> Secured: Unsecured
> Locked: Unlocked
> Needs EKM Attention: No
> Foreign State: None
> Device Speed: 6.0Gb/s
> Link Speed: 6.0Gb/s
> Media Type: Hard Disk Device
> Drive Temperature :25C (77.00 F)
> PI Eligibility:  No
> Drive is formatted for PI information:  No
> PI: No PI
> Port-0 :
> Port status: Active
> Port's Linkspeed: 6.0Gb/s
> Port-1 :
> Port status: Active
> Port's Linkspeed: Unknown
> Drive has flagged a S.M.A.R.T alert : No
>
>
>
>
> Exit Code: 0x00
>
>
> Slot number, connected port, looks like SES to me.
>
> Even better.
>
> root@ubuntu:/tmp/dist# ./MegaCli64 -EncInfo -a0
>                                          Number of enclosures on adapter 0
> -- 1
>
>     Enclosure 0:
>     Device ID                     : 252
>     Number of Slots               : 8
>     Number of Power Supplies      : 0
>     Number of Fans                : 0
>     Number of Temperature Sensors : 0
>     Number of Alarms              : 0
>     Number of SIM Modules         : 1
>     Number of Physical Drives     : 1
>     Status                        : Normal
>     Position                      : 1
>     Connector Name                : Unavailable
>     Enclosure type                : SGPIO
>     FRU Part Number               : N/A
>     Enclosure Serial Number       : N/A
>     ESM Serial Number             : N/A
>     Enclosure Zoning Mode         : N/A
>     Partner Device Id             : Unavailable
>
>     Inquiry data                  :
>         Vendor Identification     : LSI
>         Product Identification    : SGPIO
>         Product Revision Level    : N/A
>         Vendor Specific           :
>
>
> Exit Code: 0x00
>
>
>
>>
>> I'll apply any patch you can come up with for the sake of getting
>> support into the kernel.
>
>
> Using the sg_ses man page for reference.
>
> "The DEVICE should be a SES device which may be a dedicated enclosure
> services processor (INQUIRY peripheral device type 0xd) or attached to
> another type of SCSI device (e.g. a disk) in which case the EncServ bit set
> in its INQUIRY response."
>
> I believe your BIOS POST, there appears to be a dedicated device there. Just
> like mine, if you were to perform inquiry, EncServ is probably zero. So the
> SES tools literally have nothing to work with.
>
> root@ubuntu:/tmp/dist# sg_inq /dev/sg1
> standard INQUIRY:
>   PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
>   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
>   SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  BQue=0
>        EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
> #should be 1?-^
>   [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
>   [SPI: Clocking=0x0  QAS=0  IUS=0]
>     length=96 (0x60)   Peripheral device type: disk
>  Vendor identification: IBM
>  Product identification: ServeRAID M5014
>  Product revision level: 2.0.
>  Unit serial number: 003f6fc57f48ff1015204d4202b00506
>
> I would need to take a closer look to understand what's going on. There is
> clearly a lot of enclosure centric logic in mptsas.c, it could be that it's
> deliberately not exposing it to the OS so that their proprietary tool can
> have
> exclusive access. It would be appreciated if someone from LSI shed some
> light on the situation, save us all some time.
>
> I suspect that if you plug a non-raid SAS controller (adaptec) that
> the ses enclosure will be presented correctly to the OS.
>
> Peter
>
> 1. http://artipc10.vub.ac.be/wordpress/2011/09/12/megacli-useful-commands/
>
>>
>> TIA,
>> Lars Randers.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
