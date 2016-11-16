From: brace77070@gmail.com
Subject: Re: "hpsa: Change SAS transport devices to bus 0." commit breaks
 hpacucli on old controller firmware
Date: Wed, 16 Nov 2016 10:09:51 -0600
Message-ID: <0dda89dd-ba20-6fbb-d4dd-1bb6601a4108@gmail.com>
References: <1477592113.812104.769415169.23FCE36A@webmail.messagingengine.com>
 <b73337d1-fd89-9310-5998-f62388028ef5@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b73337d1-fd89-9310-5998-f62388028ef5@microsemi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Suter <jack@suter.io>
Cc: iss_storagedev@hp.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, scott.teel@microsemi.com, kevin.barnett@microsemi.com, thenzl@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 10/31/2016 02:06 PM, Don Brace wrote:
> On 10/27/2016 01:15 PM, Jack Suter wrote:
>> Hi there,
>>
>> Commit "hpsa: Change SAS transport devices to bus 0."
>> (09371d623c9c3dc6ed7f53ec8ab01d25f0c6c697) breaks the hpacucli utility
>> for some HP Smart Array controllers with old firmware.
>>
>> Specifically, I have a P410 connected to an HP DL180 G6 running firmware
>> version 1.66. Yes, the firmware is old, but it works. On the 4.4 series
>> kernels and earlier, hpacucli works with no trouble. On 4.5 and later,
>> the hpsa driver reports errors  in the kernel log, and hpacucli reports
>> "Error: No controllers detected."
>>
>> Oct 27 15:50:30 hostname kernel: [   32.189495] hpsa 0000:06:00.0: scsi
>> 0:0:0:0: added RAID              HP       P410 controller
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:30 hostname kernel: [   32.190054] hpsa 0000:06:00.0:
>> addition failed -19, device not added.
>>
>> Reverting the above commit resolves both the hpsa errors and the
>> hpacucli error when tested with kernel 4.7.9.
>>
>> In addition to this troublesome server, I have a handful of servers with
>> P410 controllers and firmware versions ranging from 3.52 to 6.60. All of
>> them work with the 09371d62 commit in place, which leads me to believe
>> it is just this old 1.66 firmware that is incompatible.
>>
>> While a firmware upgrade seems like the simple solution, I think this
>> should be considered a bug/regression due to it breaking functionality
>> that previously worked. It appears others may have run into this issue
>> too:
>> http://superuser.com/questions/1093124/coreos-hp410-raid1-device-not-added-19 
>>
>>
>> Some dmesg output (grep -e hpsa -e sg) is below from both a 4.4.2 kernel
>> (working) and 4.5.7 kernel (broken). Note the change in SCSI address
>> from 0:3:0:0 to 0:0:0:0.
>>
>> Please let me know if you need me to do any testing to help resolve
>> this.
>>
>> Jack Suter
> I discussed this with the ssacli developers and they do not look
> at the bus, but I see "device not added" messages that
> should not be there. I'll attack your issue from that
> perspective.
>
> Thanks,
> Don Brace

The root cause is that this older firmware is not scsi revision 5 and 
thus we add the
controller at the end of the list, not at the beginning.

         if (is_scsi_rev_5(h))
                 raid_ctlr_position = 0;
         else
                 raid_ctlr_position = nphysicals + nlogicals;

So the first logical volume gets BTL 0:0:0 and then we attempt to add in 
the controller
using the same BTL values at the end of the list. Thus you get the 
"device not added" messages.

The change to bus 0 was because the SAS transport is using bus 0 and 
there was a
discrepancy in what the driver was putting the controller on and what 
the SAS
transport was actually using.

I'll work on a patch to resolve this for you.


Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation

>>
>> Kernel 4.4.2
>> Oct 27 15:28:07 hostname kernel: [    1.461160] hpsa 0000:06:00.0: can't
>> disable ASPM; OS doesn't have ASPM control
>> Oct 27 15:28:07 hostname kernel: [    1.461632] hpsa 0000:06:00.0: MSI-X
>> capable controller
>> Oct 27 15:28:07 hostname kernel: [    1.463363] hpsa 0000:06:00.0:
>> Logical aborts not supported
>> Oct 27 15:28:07 hostname kernel: [    1.463619] hpsa 0000:06:00.0: HP
>> SSD Smart Path aborts not supported
>> Oct 27 15:28:07 hostname kernel: [    1.495824] scsi host0: hpsa
>> Oct 27 15:28:07 hostname kernel: [    1.558535] hpsa 0000:06:00.0: scsi
>> 0:0:0:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:28:07 hostname kernel: [    1.558992] hpsa 0000:06:00.0: scsi
>> 0:0:1:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:28:07 hostname kernel: [    1.559441] hpsa 0000:06:00.0: scsi
>> 0:0:2:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:28:07 hostname kernel: [    1.559890] hpsa 0000:06:00.0: scsi
>> 0:0:3:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:28:07 hostname kernel: [    1.560338] hpsa 0000:06:00.0: scsi
>> 0:0:4:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:28:07 hostname kernel: [    1.560786] hpsa 0000:06:00.0: scsi
>> 0:0:5:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:28:07 hostname kernel: [    1.561234] hpsa 0000:06:00.0: scsi
>> 0:0:6:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:28:07 hostname kernel: [    1.561681] hpsa 0000:06:00.0: scsi
>> 0:0:7:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:28:07 hostname kernel: [    1.562131] hpsa 0000:06:00.0: scsi
>> 0:0:8:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:28:07 hostname kernel: [    1.562579] hpsa 0000:06:00.0: scsi
>> 0:0:9:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:28:07 hostname kernel: [    1.563027] hpsa 0000:06:00.0: scsi
>> 0:0:10:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:28:07 hostname kernel: [    1.563476] hpsa 0000:06:00.0: scsi
>> 0:1:0:0: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:28:07 hostname kernel: [    1.563925] hpsa 0000:06:00.0: scsi
>> 0:1:0:1: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:28:07 hostname kernel: [    1.564372] hpsa 0000:06:00.0: scsi
>> 0:1:0:2: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:28:07 hostname kernel: [    1.564820] hpsa 0000:06:00.0: scsi
>> 0:1:0:3: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:28:07 hostname kernel: [    1.565267] hpsa 0000:06:00.0: scsi
>> 0:1:0:4: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:28:07 hostname kernel: [    1.565715] hpsa 0000:06:00.0: scsi
>> 0:1:0:5: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:28:07 hostname kernel: [    1.566163] hpsa 0000:06:00.0: scsi
>> 0:1:0:6: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:28:07 hostname kernel: [    1.566610] hpsa 0000:06:00.0: scsi
>> 0:1:0:7: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:28:07 hostname kernel: [    1.567058] hpsa 0000:06:00.0: scsi
>> 0:1:0:8: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:28:07 hostname kernel: [    1.567505] hpsa 0000:06:00.0: scsi
>> 0:1:0:9: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:28:07 hostname kernel: [    1.567953] hpsa 0000:06:00.0: scsi
>> 0:1:0:10: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:28:07 hostname kernel: [    1.568401] hpsa 0000:06:00.0: scsi
>> 0:1:0:11: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:28:07 hostname kernel: [    1.568851] hpsa 0000:06:00.0: scsi
>> 0:3:0:0: added RAID              HP       P410 controller
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:28:07 hostname kernel: [    1.627430] scsi 0:1:0:0: Attached
>> scsi generic sg0 type 0
>> Oct 27 15:28:07 hostname kernel: [    1.627918] sd 0:1:0:1: Attached
>> scsi generic sg1 type 0
>> Oct 27 15:28:07 hostname kernel: [    1.628320] sd 0:1:0:2: Attached
>> scsi generic sg2 type 0
>> Oct 27 15:28:07 hostname kernel: [    1.628724] sd 0:1:0:3: Attached
>> scsi generic sg3 type 0
>> Oct 27 15:28:07 hostname kernel: [    1.629292] sd 0:1:0:4: Attached
>> scsi generic sg4 type 0
>> Oct 27 15:28:07 hostname kernel: [    1.629780] sd 0:1:0:5: Attached
>> scsi generic sg5 type 0
>> Oct 27 15:28:07 hostname kernel: [    1.630184] sd 0:1:0:6: Attached
>> scsi generic sg6 type 0
>> Oct 27 15:28:07 hostname kernel: [    1.630559] sd 0:1:0:7: Attached
>> scsi generic sg7 type 0
>> Oct 27 15:28:07 hostname kernel: [    1.630957] sd 0:1:0:8: Attached
>> scsi generic sg8 type 0
>> Oct 27 15:28:07 hostname kernel: [    1.631363] sd 0:1:0:9: Attached
>> scsi generic sg9 type 0
>> Oct 27 15:28:07 hostname kernel: [    1.631789] sd 0:1:0:10: Attached
>> scsi generic sg10 type 0
>> Oct 27 15:28:07 hostname kernel: [    1.632281] sd 0:1:0:11: Attached
>> scsi generic sg11 type 0
>> Oct 27 15:28:07 hostname kernel: [    1.633989] scsi 0:3:0:0: Attached
>> scsi generic sg12 type 12
>>
>> Kernel 4.5.7
>> Oct 27 15:50:23 hostname kernel: [    1.489670] hpsa 0000:06:00.0: can't
>> disable ASPM; OS doesn't have ASPM control
>> Oct 27 15:50:23 hostname kernel: [    1.490852] hpsa 0000:06:00.0: MSI-X
>> capable controller
>> Oct 27 15:50:23 hostname kernel: [    1.491935] hpsa 0000:06:00.0:
>> Logical aborts not supported
>> Oct 27 15:50:23 hostname kernel: [    1.492196] hpsa 0000:06:00.0: HP
>> SSD Smart Path aborts not supported
>> Oct 27 15:50:23 hostname kernel: [    1.524433] scsi host0: hpsa
>> Oct 27 15:50:23 hostname kernel: [    1.728848] hpsa 0000:06:00.0: scsi
>> 0:0:0:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:50:23 hostname kernel: [    1.729311] hpsa 0000:06:00.0: scsi
>> 0:0:1:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:50:23 hostname kernel: [    1.729769] hpsa 0000:06:00.0: scsi
>> 0:0:2:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:50:23 hostname kernel: [    1.730225] hpsa 0000:06:00.0: scsi
>> 0:0:3:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:50:23 hostname kernel: [    1.730686] hpsa 0000:06:00.0: scsi
>> 0:0:4:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:50:23 hostname kernel: [    1.731145] hpsa 0000:06:00.0: scsi
>> 0:0:5:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:50:23 hostname kernel: [    1.731604] hpsa 0000:06:00.0: scsi
>> 0:0:6:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:50:23 hostname kernel: [    1.732057] hpsa 0000:06:00.0: scsi
>> 0:0:7:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:50:23 hostname kernel: [    1.732512] hpsa 0000:06:00.0: scsi
>> 0:0:8:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:50:23 hostname kernel: [    1.732967] hpsa 0000:06:00.0: scsi
>> 0:0:9:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:50:23 hostname kernel: [    1.733426] hpsa 0000:06:00.0: scsi
>> 0:0:10:0: masked Direct-Access     ATA      WDC WD2002FAEX-0 PHYS DRV
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:50:23 hostname kernel: [    1.733887] hpsa 0000:06:00.0: scsi
>> 0:0:11:0: masked Enclosure         HP       DL18xG6BP enclosure
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:50:23 hostname kernel: [    1.734345] hpsa 0000:06:00.0: scsi
>> 0:0:12:0: masked Enclosure         PMCSIERA  SRC 8x6G enclosure
>> SSDSmartPathCap- En- Exp=0
>> Oct 27 15:50:23 hostname kernel: [    1.734805] hpsa 0000:06:00.0: scsi
>> 0:1:0:0: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:23 hostname kernel: [    1.735265] hpsa 0000:06:00.0: scsi
>> 0:1:0:1: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:23 hostname kernel: [    1.735721] hpsa 0000:06:00.0: scsi
>> 0:1:0:2: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:23 hostname kernel: [    1.736181] hpsa 0000:06:00.0: scsi
>> 0:1:0:3: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:23 hostname kernel: [    1.736641] hpsa 0000:06:00.0: scsi
>> 0:1:0:4: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:23 hostname kernel: [    1.737100] hpsa 0000:06:00.0: scsi
>> 0:1:0:5: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:23 hostname kernel: [    1.737553] hpsa 0000:06:00.0: scsi
>> 0:1:0:6: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:23 hostname kernel: [    1.738005] hpsa 0000:06:00.0: scsi
>> 0:1:0:7: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:23 hostname kernel: [    1.738458] hpsa 0000:06:00.0: scsi
>> 0:1:0:8: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:23 hostname kernel: [    1.738912] hpsa 0000:06:00.0: scsi
>> 0:1:0:9: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:23 hostname kernel: [    1.739370] hpsa 0000:06:00.0: scsi
>> 0:1:0:10: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:23 hostname kernel: [    1.739830] hpsa 0000:06:00.0: scsi
>> 0:1:0:11: added Direct-Access     HP       LOGICAL VOLUME RAID-0
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:23 hostname kernel: [    1.740292] hpsa 0000:06:00.0: scsi
>> 0:0:0:0: added RAID              HP       P410 controller
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:23 hostname kernel: [    1.930026] hpsa 0000:06:00.0:
>> addition failed -19, device not added.
>> Oct 27 15:50:23 hostname kernel: [    1.941123] scsi 0:1:0:0: Attached
>> scsi generic sg0 type 0
>> Oct 27 15:50:23 hostname kernel: [    1.941569] sd 0:1:0:1: Attached
>> scsi generic sg1 type 0
>> Oct 27 15:50:23 hostname kernel: [    1.942510] sd 0:1:0:2: Attached
>> scsi generic sg2 type 0
>> Oct 27 15:50:23 hostname kernel: [    1.944339] sd 0:1:0:3: Attached
>> scsi generic sg3 type 0
>> Oct 27 15:50:23 hostname kernel: [    1.944786] sd 0:1:0:4: Attached
>> scsi generic sg4 type 0
>> Oct 27 15:50:23 hostname kernel: [    1.945171] sd 0:1:0:5: Attached
>> scsi generic sg5 type 0
>> Oct 27 15:50:23 hostname kernel: [    1.945652] sd 0:1:0:6: Attached
>> scsi generic sg6 type 0
>> Oct 27 15:50:23 hostname kernel: [    1.946056] sd 0:1:0:7: Attached
>> scsi generic sg7 type 0
>> Oct 27 15:50:23 hostname kernel: [    1.946697] sd 0:1:0:8: Attached
>> scsi generic sg8 type 0
>> Oct 27 15:50:23 hostname kernel: [    1.948779] sd 0:1:0:9: Attached
>> scsi generic sg9 type 0
>> Oct 27 15:50:23 hostname kernel: [    1.949196] sd 0:1:0:10: Attached
>> scsi generic sg10 type 0
>> Oct 27 15:50:23 hostname kernel: [    1.949625] sd 0:1:0:11: Attached
>> scsi generic sg11 type 0
>> Oct 27 15:50:30 hostname kernel: [   32.189495] hpsa 0000:06:00.0: scsi
>> 0:0:0:0: added RAID              HP       P410 controller
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:30 hostname kernel: [   32.190054] hpsa 0000:06:00.0:
>> addition failed -19, device not added.
>> Oct 27 15:50:59 hostname kernel: [   62.383385] hpsa 0000:06:00.0: scsi
>> 0:0:0:0: added RAID              HP       P410 controller
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:50:59 hostname kernel: [   62.384008] hpsa 0000:06:00.0:
>> addition failed -19, device not added.
>> Oct 27 15:51:30 hostname kernel: [   92.578794] hpsa 0000:06:00.0: scsi
>> 0:0:0:0: added RAID              HP       P410 controller
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:51:30 hostname kernel: [   92.579423] hpsa 0000:06:00.0:
>> addition failed -19, device not added.
>> Oct 27 15:52:00 hostname kernel: [  122.800316] hpsa 0000:06:00.0: scsi
>> 0:0:0:0: added RAID              HP       P410 controller
>> SSDSmartPathCap- En- Exp=1
>> Oct 27 15:52:00 hostname kernel: [  122.800932] hpsa 0000:06:00.0:
>> addition failed -19, device not added.
>> (repeats every 30 seconds)
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
