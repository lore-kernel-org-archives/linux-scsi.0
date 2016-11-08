From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: Ordering problems with 3ware controller
Date: Tue, 8 Nov 2016 12:09:10 +0100
Message-ID: <6963de53-a539-61de-067e-41a800899508@molgen.mpg.de>
References: <a41b4bab-edb7-34ab-eb76-7ff4d6e3f677@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.molgen.mpg.de ([141.14.17.9]:57465 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932614AbcKHLPb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 06:15:31 -0500
In-Reply-To: <a41b4bab-edb7-34ab-eb76-7ff4d6e3f677@molgen.mpg.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adam Radford <linuxraid@lsi.com>, dvteam@molgen.mpg.de

Dear Linux SCSI folks,


On 11/08/16 11:07, Paul Menzel wrote:

> Updating from Linux 4.4.X to Linux 4.8.4, we noticed that the 3ware
> devices under `/dev` – `/dev/twa0`, `/dev/twa1`, … – map to the
> controllers differently.
>
> This unfortunately breaks quite a lot of our scripts, as we depend on
> the fact that the first controller is also in the front.
>
>> $ dmesg | grep 3ware
>> [   14.509238] 3ware 9000 Storage Controller device driver for Linux
>> v2.26.02.014.
>> [   14.824274] scsi host8: 3ware 9000 Storage Controller
>> [   14.824537] 3w-9xxx: scsi8: Found a 3ware 9000 Storage Controller
>> at 0xd0200000, IRQ: 17.
>> [   15.508310] scsi host9: 3ware 9000 Storage Controller
>> [   15.508569] 3w-9xxx: scsi9: Found a 3ware 9000 Storage Controller
>> at 0xda100000, IRQ: 17.
>
> Tracing `twi_cli` it looks like the ordering of the devices in
> `/sys/class/scsi_host` might have changed, as `getdents64` seems to be
> used for the ordering of creating `/dev/twaX`.
>
>> $ find /sys/class/scsi_host/ -ls
>>      6033      0 drwxr-xr-x   2  root     system          0 Nov  8
>> 10:58 /sys/class/scsi_host/
>>     23125      0 lrwxrwxrwx   1  root     system          0 Oct 27
>> 17:41 /sys/class/scsi_host/host0 ->
>> ../../devices/pci0000:00/0000:00:07.0/ata1/host0/scsi_host/host0
>>     29893      0 lrwxrwxrwx   1  root     system          0 Oct 27
>> 18:03 /sys/class/scsi_host/host9 ->
>> ../../devices/pci0000:80/0000:80:0e.0/0000:90:00.0/host9/scsi_host/host9
>>     23878      0 lrwxrwxrwx   1  root     system          0 Oct 27
>> 17:41 /sys/class/scsi_host/host7 ->
>> ../../devices/pci0000:80/0000:80:08.0/ata8/host7/scsi_host/host7
>>     23640      0 lrwxrwxrwx   1  root     system          0 Oct 27
>> 17:41 /sys/class/scsi_host/host5 ->
>> ../../devices/pci0000:80/0000:80:07.0/ata6/host5/scsi_host/host5
>>     23402      0 lrwxrwxrwx   1  root     system          0 Oct 27
>> 17:41 /sys/class/scsi_host/host3 ->
>> ../../devices/pci0000:00/0000:00:08.0/ata4/host3/scsi_host/host3
>>     23164      0 lrwxrwxrwx   1  root     system          0 Oct 27
>> 17:41 /sys/class/scsi_host/host1 ->
>> ../../devices/pci0000:00/0000:00:07.0/ata2/host1/scsi_host/host1
>>     29851      0 lrwxrwxrwx   1  root     system          0 Oct 27
>> 18:03 /sys/class/scsi_host/host8 ->
>> ../../devices/pci0000:00/0000:00:0e.0/0000:05:00.0/host8/scsi_host/host8
>>     23839      0 lrwxrwxrwx   1  root     system          0 Oct 27
>> 17:41 /sys/class/scsi_host/host6 ->
>> ../../devices/pci0000:80/0000:80:08.0/ata7/host6/scsi_host/host6
>>     23601      0 lrwxrwxrwx   1  root     system          0 Oct 27
>> 17:41 /sys/class/scsi_host/host4 ->
>> ../../devices/pci0000:80/0000:80:07.0/ata5/host4/scsi_host/host4
>>     23363      0 lrwxrwxrwx   1  root     system          0 Oct 27
>> 17:41 /sys/class/scsi_host/host2 ->
>> ../../devices/pci0000:00/0000:00:08.0/ata3/host2/scsi_host/host2
>> $ sudo -i tw_cli show
>>
>> Ctl   Model        (V)Ports  Drives   Units   NotOpt  RRate   VRate  BBU
>> ------------------------------------------------------------------------
>> c8    9650SE-8LPML 8         8        1       0       5       1      OK
>> c9    9690SA-8E    0         0        0       0       5       1      OK
>>
>> Enclosure     Slots  Drives  Fans  TSUnits  PSUnits  Alarms
>> --------------------------------------------------------------
>> /c9/e0        16     0       3     1        2        1
>
> So in this case `c8` is mapped to `/dev/twa1`, and `c9` to `/dev/twa0`.
>
> As we do not know of a way, to use `tw_cli` to find the correct mapping,
> or another place, we rely on the implicit ordering, which – according to
> my colleagues – has worked for over 15 years [1].

Here is the excerpt from the manual page for smartctl [2].

 > --- end of manual page excerpt ---
> 3ware,N  -  [FreeBSD  and Linux only] the device consists of one or more ATA disks con‐
> nected to a 3ware RAID controller.  The non-negative integer N (in the range from 0  to
> 127 inclusive) denotes which disk on the controller is monitored.  Use syntax such as:
> smartctl -a -d 3ware,2 /dev/sda
> smartctl -a -d 3ware,0 /dev/twe0
> smartctl -a -d 3ware,1 /dev/twa0
> smartctl -a -d 3ware,1 /dev/twl0
> The  first  two  forms, which refer to devices /dev/sda-z and /dev/twe0-15, may be used
> with 3ware series 6000, 7000, and 8000 series controllers that use the 3x-xxxx  driver.
> Note  that  the /dev/sda-z form is deprecated starting with the Linux 2.6 kernel series
> and may not be supported by the Linux kernel in the near future.  The final form, which
> refers  to devices /dev/twa0-15, must be used with 3ware 9000 series controllers, which
> use the 3w-9xxx driver.
>
> The devices /dev/twl0-15 must be used with the 3ware/LSI 9750 series controllers  which
> use the 3w-sas driver.
>
> Note  that if the special character device nodes /dev/twl?, /dev/twa?  and /dev/twe? do
> not exist, or exist with the incorrect major or minor numbers, smartctl  will  recreate
> them  on  the  fly.   Typically  /dev/twa0  refers to the first 9000-series controller,
> /dev/twa1 refers to the second 9000  series  controller,  and  so  on.   The  /dev/twl0
> devices  refers  to  the  first 9750 series controller, /dev/twl1 resfers to the second
> 9750  series  controller,  and  so  on.   Likewise  /dev/twe0  refers  to   the   first
> 6/7/8000-series  controller, /dev/twe1 refers to the second 6/7/8000 series controller,
> and so on.
>
> Note that for the 6/7/8000 controllers, any of the physical disks  can  be  queried  or
> examined using any of the 3ware's SCSI logical device /dev/sd?  entries.  Thus, if log‐
> ical device /dev/sda is made up of two physical disks (3ware ports zero  and  one)  and
> logical  device  /dev/sdb  is  made up of two other physical disks (3ware ports two and
> three) then you can examine the SMART data on any of  the  four  physical  disks  using
> either SCSI device /dev/sda or /dev/sdb.  If you need to know which logical SCSI device
> a particular physical disk (3ware port) is associated with, use  the  dmesg  or  SYSLOG
> output  to  show which SCSI ID corresponds to a particular 3ware unit, and then use the
> 3ware CLI or 3dm tool to determine which ports (physical disks) correspond to  particu‐
> lar 3ware units.
>
> If the value of N corresponds to a port that does not exist on the 3ware controller, or
> to a port that does not physically have a disk attached to it, the behavior of smartctl
> depends  upon  the  specific controller model, firmware, Linux kernel and platform.  In
> some cases you will get a warning message that the device does  not  exist.   In  other
> cases you will be presented with ´void´ data for a non-existent device.
>
> Note  that  if  the /dev/sd? addressing form is used, then older 3w-xxxx drivers do not
> pass the "Enable Autosave" (´-S on´) and "Enable Automatic Offline" (´-o on´)  commands
> to  the  disk,  and  produce  these  types  of  harmless syslog error messages instead:
> "3w-xxxx: tw_ioctl(): Passthru size (123392) too big".  This can be fixed by  upgrading
> to  version 1.02.00.037 or later of the 3w-xxxx driver, or by applying a patch to older
> versions.  Alternatively, use the character device /dev/twe0-15 interface.
>
> The selective self-test functions (´-t select,A-B´) are only supported using the  char‐
> acter  device  interface  /dev/twl0-15,  /dev/twa0-15  and /dev/twe0-15.  The necessary
> WRITE LOG commands can not be passed through the SCSI interface.
 > --- end of manual page excerpt ---

> Do you know of a way, to either get the mapping “over an API” so we
> don’t have to rely on the implicit ordering?
>
> Otherwise, do you know, why the ordering has changed, and can this be
> reverted?


Kind regards,

Paul Menzel


> [1] https://www.thomas-krenn.com/de/wiki/Smartmontools_mit_3ware_RAID_Controller
>     (German)
[2] https://www.smartmontools.org/browser/trunk/smartmontools/smartctl.8.in
