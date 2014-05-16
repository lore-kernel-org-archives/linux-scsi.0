From: Nicolas Sylvain <nsylvain@gmail.com>
Subject: Re: Hot Swap Problems with LSI HBA and LSI Backplane -- reproducable
 and very frustrating
Date: Thu, 15 May 2014 19:57:01 -0700
Message-ID: <CA+kKMHQ9892HJJ8E0by58v4UaU_RPA3yavDQ7WVEdvoJYO+z-A@mail.gmail.com>
References: <523A23D3.6030608@nathanshearer.ca> <CAC9+an+YaZ3hn+eTyk0mApgj7m30yTYEKeif=aEUrF49dinh7w@mail.gmail.com>
 <523BE569.4020706@nathanshearer.ca> <537244D8.7020008@nathanshearer.ca>
 <CA+kKMHTQWpEqE5yNTxACZVVzupH0ghvV-1uXdvTUdQvRf7MhLg@mail.gmail.com> <53728E6E.8080204@nathanshearer.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:53370 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbaEPC5W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 May 2014 22:57:22 -0400
Received: by mail-ve0-f172.google.com with SMTP id oz11so2434043veb.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 May 2014 19:57:21 -0700 (PDT)
In-Reply-To: <53728E6E.8080204@nathanshearer.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nathan Shearer <mail@nathanshearer.ca>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

I think I might have found a fix, although I've done only limited testing.

I've flashed the firmware of the card with the latest firmware
available on the LSI website (P19)
http://www.lsi.com/products/host-bus-adapters/pages/lsi-sas-9207-8i.aspx#tab/tab4

I've also switched to using the mpt2sas drivers that LSI ships on that
same page. (version P19 as well).   To do this I had to downgrade my
Precise kernel to 3.2.0-23.

Now, instead of the hang and the failure in _transport_set_identify,
I get this:


May 15 22:15:40 localhost kernel: [ 1756.660716] mpt2sas0: detecting:
handle(0x000b), sas_address(0x500056b37789abe2), phy(2)
May 15 22:15:40 localhost kernel: [ 1756.660732] mpt2sas0:
REPORT_LUNS: handle(0x000b), retries(0)
May 15 22:15:45 localhost kernel: [ 1761.646947] mpt2sas0:
_scsi_send_scsi_io: timeout
May 15 22:15:45 localhost kernel: [ 1761.647092] mf:
May 15 22:15:45 localhost kernel: [ 1761.647093]        0000000b
00000000 00000000 aa500060 00600000 00000018 00000000 000007f8
May 15 22:15:45 localhost kernel: [ 1761.647102]        00000000
0000000c 00000000 00000000 00000000 00000000 00000000 02000000
May 15 22:15:45 localhost kernel: [ 1761.647111]        000000a0
00000000 0000f807 00000000 00000000 00000000 00000000 00000000
May 15 22:15:45 localhost kernel: [ 1761.647118]        d30007f8
aea5a000 0000000f 00000000
May 15 22:15:45 localhost kernel: [ 1761.647125] mpt2sas0: issue
target reset: handle(0x000b)
May 15 22:15:46 localhost kernel: [ 1762.392176] mpt2sas0:
log_info(0x31130000): originator(PL), code(0x13), sub_code(0x0000)
May 15 22:15:46 localhost kernel: [ 1762.392239] mpt2sas0: target
reset completed: handle(0x000b)
May 15 22:15:46 localhost kernel: [ 1762.392244] mpt2sas0: issue
retry: handle (0x000b)
May 15 22:15:47 localhost kernel: [ 1763.140170] mpt2sas0:
TEST_UNIT_READY: handle(0x000b), lun(0)
May 15 22:15:47 localhost kernel: [ 1763.397483] mpt2sas0: detecting:
handle(0x000b), sas_address(0x500056b37789abe2), phy(2)
May 15 22:15:47 localhost kernel: [ 1763.397500] mpt2sas0:
REPORT_LUNS: handle(0x000b), retries(0)
May 15 22:15:47 localhost kernel: [ 1763.397660] mpt2sas0:
TEST_UNIT_READY: handle(0x000b), lun(0)
May 15 22:15:48 localhost kernel: [ 1764.138375] scsi 0:0:3:0:
Direct-Access     ATA      Crucial_CT960M50 MU02 PQ: 0 ANSI: 6
May 15 22:15:48 localhost kernel: [ 1764.387903] scsi 0:0:3:0: SATA:
handle(0x000b), sas_addr(0x500056b37789abe2), phy(2),
device_name(0x500a07510946b590)
May 15 22:15:48 localhost kernel: [ 1764.387910] scsi 0:0:3:0: SATA:
enclosure_logical_id(0x500056b36789abff), slot(6)
May 15 22:15:48 localhost kernel: [ 1764.388381] scsi 0:0:3:0:
atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
May 15 22:15:48 localhost kernel: [ 1764.388388] scsi 0:0:3:0:
serial_number(        13290946B590)
May 15 22:15:48 localhost kernel: [ 1764.388394] scsi 0:0:3:0:
qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7),
cmd_que(1)
May 15 22:15:48 localhost kernel: [ 1764.388669] sd 0:0:3:0: Attached
scsi generic sg1 type 0
May 15 22:15:48 localhost kernel: [ 1764.886735] sd 0:0:3:0: [sdb]
1875385008 512-byte logical blocks: (960 GB/894 GiB)

So there seem to be a new 5-second timeout, followed by a reset, and
then the disk is correctly detected.

Next I'll try to use this driver with a newer version of the kernel,
and will do more testing to see if this fix really works reliably.

I assume this version of the driver will eventually be merged into the
normal kernel?

Nicolas

On Tue, May 13, 2014 at 2:28 PM, Nathan Shearer <mail@nathanshearer.ca> wrote:
> On 13/05/2014 11:50 AM, Nicolas Sylvain wrote:
>>
>> Thanks for all the info! It's definitely very helpful.
>>
>> I'm using the LSI SAS9207-8i as well.   I've tested 3 drives, and only
>> 1 causes the problem:
>>
>> Intel SSD 520 Series 480GB SSDSC2CW480A3 -> works
>> Hitachi 2TB HUA722020ALA331 -> works
>> Crucial M200 SSD 960GB CT960M500SSD1 -> failed
>>
>> The server is a Dell R720XD with 12 3.5inch hotswap bays.  I'm unsure
>> what exact backplane it's using, but I'll be talking to Dell about
>> this.
>>
>> The behavior I'm seeing is very similar to yours:
>>
>> I can hotswap the Intel or Hitachi drives without problem.  However,
>> when I insert and remove the Crucial disk, there is about a 50% chance
>> that the bay is going to be wedged.   When it happens, This bay is no
>> longer able to recognize Crucial disks.  Soft-rebooting does not seem
>> to fix the problem.   Hotswap events for any of the other bays/drives
>> are also not working until I actually remove the Crucial drive from
>> the wedged bay.  The mtp2sas driver seems to be hung.
>>
>> When inserting a drive in a bay that is wedged, I sometimes see:
>>
>> mpt2sas0: device is not present handle(0x000b), no sas_device!!!
>>
>>
>> When removing a drive that was inserted in a wedged bay, I see
>> messages like those:
>>
>> May 10 00:11:14 localhost kernel: [ 8211.861607] mpt2sas0:
>> handle(0x000c), ioc_status(0x0022)
>> May 10 00:11:14 localhost kernel: [ 8211.861610] failure at
>>
>> /build/buildd/linux-3.2.0/drivers/scsi/mpt2sas/mpt2sas_transport.c:162/_transport_set_identify()!
>> May 10 00:11:14 localhost kernel: [ 8211.867179] mpt2sas0:
>> handle(0x0011), ioc_status(0x0022)
>> May 10 00:11:14 localhost kernel: [ 8211.867182] failure at
>>
>> /build/buildd/linux-3.2.0/drivers/scsi/mpt2sas/mpt2sas_transport.c:162/_transport_set_identify()!
>> May 10 00:11:14 localhost kernel: [ 8211.867805] mpt2sas0: failure at
>>
>> /build/buildd/linux-3.2.0/drivers/scsi/mpt2sas/mpt2sas_scsih.c:5157/_scsih_add_device()!
>> May 10 00:11:14 localhost kernel: [ 8211.876189] mpt2sas0:
>> handle(0x0011), ioc_status(0x0022)
>> May 10 00:11:14 localhost kernel: [ 8211.876190] failure at
>>
>> /build/buildd/linux-3.2.0/drivers/scsi/mpt2sas/mpt2sas_transport.c:162/_transport_set_identify()!
>> May 10 00:11:14 localhost kernel: [ 8211.876797] mpt2sas0: failure at
>>
>> /build/buildd/linux-3.2.0/drivers/scsi/mpt2sas/mpt2sas_scsih.c:5157/_scsih_add_device()!
>> May 10 00:11:14 localhost kernel: [ 8211.881823] mpt2sas0:
>> handle(0x0012), ioc_status(0x0022)
>> May 10 00:11:14 localhost kernel: [ 8211.881825] failure at
>>
>> /build/buildd/linux-3.2.0/drivers/scsi/mpt2sas/mpt2sas_transport.c:162/_transport_set_identify()!
>> May 10 00:11:14 localhost kernel: [ 8211.882288] mpt2sas0: failure at
>>
>> /build/buildd/linux-3.2.0/drivers/scsi/mpt2sas/mpt2sas_scsih.c:5157/_scsih_add_device()!
>>
>> One thing that might be different from your problem, is that I
>> actually have a workaround to fix the wedged bays : Insert a Intel or
>> Hitachi drive.   Those get detected correctly, no matter if the bay is
>> wedged for Crucial disks or not.
>>
>> I only have done limited testing, but I'll be following up with Dell
>> on this and let you know if I get to try your backplane solution.
>>
>> Thanks
>>
>> Nicolas
>>
>> On Tue, May 13, 2014 at 9:14 AM, Nathan Shearer <mail@nathanshearer.ca>
>> wrote:
>>>
>>> Hi Nicolas,
>>>
>>> I just wanted to be sure that you are experiencing the same problem. In
>>> my final setup I wanted to use a Supermicro SuperChassis 826E2-R800LPB with
>>> a LSI SAS9207-8i and a mixture of hard drives.
>>>
>>> I included the linux-scsi mailing list for future reference, but I'm
>>> afraid I have bad news. I contacted Supermicro and LSI regarding this issue
>>> and after a lot of back-and-forth and testing on my part this is what I
>>> determined:
>>>
>>> Supermicro Case Number: SM1309158401
>>> LSI Case Number: P00078977
>>> Seagate Case Number: 03671535
>>> The LSI SAS9207-8i uses the LSI SAS2308 controller, is SAS 2.1 compliant,
>>> and has the same problem
>>> The Supermicro AOC-USAS2-L8i uses the LSI SAS2008 controller, is SAS 2.0
>>> compliant, and has the same problem
>>> The Supermicro AOC-USAS-L8i uses the LSI SAS1068E controller, is SAS 1.0
>>> compliant, and works perfectly
>>>
>>> Note that this card does not support hard drives with >2TB of space
>>> All drives work (including the ones affected on the newer controller),
>>> but they have exactly 2^32 bytes of usable space
>>>
>>> Supermicro SuperChassis 826E2-R800LPB uses the BPN-SAS-826EL2 backplane
>>> (SAS 1.0)
>>> The BPN-SAS-826EL2 uses the LSI SASx28 expander chipset (SAS 1.0)
>>> LSI has discontinued support for the LSI SASx28 over 2 years ago!
>>> Supermicro refused to provide support or a new firmware for the backplane
>>> or LSI SASx28 expander. They told me to contact Supermicro for a new
>>> backplane firmware or a new backplane.
>>> I forwarded my entire e-mail chain from LSI to Supermicro and Supermicro
>>> said that LSI discontinued support over 2 years ago and that there is no
>>> newer firmware.
>>> To solve the issue, You need to replace the SAS1 backplane
>>> (BPN-SAS-826EL2) with a SAS2 packplane: BPN-SAS2-826EL2
>>>
>>> I did not try this -- I can't guarantee that it will work
>>>
>>> I believe it is a problem with the SAS1 backplane and SAS2 controller
>>> card. Why only certain drives are affected, I'm not sure. My guess is it's a
>>> power-saving feature that is causing them to not spin up properly, then the
>>> controller/backplane disables the drive bay permanently for some reason. It
>>> is something related to mixing the SAS2 controller with the SAS1 backplane.
>>> A SAS2 backplane might fix the issue.
>>>
>>> I am still using the Supermicro SuperChassis 826E2-R800LPB with the
>>> BPN-SAS-826EL2 backplane with the LSI SASx28 expander chipset, all with a
>>> LSI SAS9207-8i controller. In my particular situation we decided to just go
>>> with drives that work from the compatibility list -- which is very
>>> expensive, but I needed the guarantee that they would work.
>>>
>>> With that configuration, I did some testing with various drives and this
>>> is what I found:
>>>
>>> Western Digital WD2003FYYS-02W0B0 works
>>> Western Digital WD20EARS-00S8B1 works
>>> Western Digital WD3000BLFS-01YBU4 works
>>> Western Digital WD3000HLFS-01G6U1 works
>>> Western Digital WD30EFRX-68AX9N0 works (but had some odd "task abort"
>>> kernel messages)
>>> Western Digital WD740ADFD-00NLR5 works
>>> Seagate ST3000DM001 failed
>>> Seagate ST3500641AS works
>>> Seagate ST4000DM000-1F2168 failed
>>> Seagate ST91000640NS works
>>>
>>> I also tried these drives on my HighPoint RocketRaid 2740 (direct
>>> attached SAS 2.0) without the backplane and all the drives worked perfectly.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> It's interesting that it happens when your SSD drive is inserted, and that
> you are able to bring the drive bay back to life by inserting a different
> drive. In my scenario it's permanently disabled. I did come across an
> interesting way to work around the problem -- but it's totally impractical:
>
> For this test I used a molex to sata power cable to spin up the drive prior
> to hot-inserting it into the backplane. I used a SATA extension cable to
> connect the drive to the backplane bays for each hot insert:
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 6. It spun up and was
> detected and worked.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 6. It spun up and was
> detected and worked. Tested twice for good measure.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 7. It spun up and was
> detected and worked.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 7. It spun up and was
> detected and worked. Tested twice for good measure.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 8. It spun up and was
> detected and worked.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 8. It spun up and was
> detected and worked. Tested twice for good measure.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 9. It spun up and was
> detected and worked.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 9. It spun up and was
> detected and worked. Tested twice for good measure.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 10. It spun up and
> was detected and worked.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 10. It spun up and
> was detected and worked. Tested twice for good measure.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 11. It spun up and
> was detected and worked.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 11. It spun up and
> was detected and worked. Tested twice for good measure.
> I continued with the system still powered on, but now I actually inserted
> the drive into the Bay without the extension cable so the backplane could
> spinup the drive:
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 6. It spun up and was
> detected and worked.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 7. It spun up and was
> detected and worked.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 8. It spun up and was
> detected and worked.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 9. It did not spin up
> and did not work.
> I connected the Seagate ST3000DM001-9YN1CC4B to the molex-to-sata cable so
> it could spin up:
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 9. It spun up and was
> detected and worked.
>     Hot inserted a Seagate ST3000DM001-9YN1CC4B in Bay 9. It spun up and was
> detected and worked. Tested twice for good measure.
> I connected the Seagate ST3000DM001-9YN1CC4B to the Bay 9 in the backplane
> with the SATA extension cable *without power*.
> I then connected power to the drive with the molex-to-sata adapter. The
> drive spun up but *was not detected*
> I then removed the cable from Bay 9 and disconnected the Seagate
> ST3000DM001-9YN1CC4B completely and inserted a Western Digital
> WD2003FYYS-02W0B0 in Bay 9. It did not spin up and did not work.
>
> I powered off the server and unplugged it and let it sit for ~30 minutes to
> restore functionality to Bay 9.
