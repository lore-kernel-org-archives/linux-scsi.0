From: "Paul" <paul@kbs.net.au>
Subject: Re: Adaptec SCSI oddity
Date: Tue, 7 Dec 2004 13:32:02 +1100
Message-ID: <068d01c4dc04$ef190230$540a020a@internal.kbs.net.au>
References: <20041207022348.GB1536@frodo>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 147.32.220.203.comindico.com.au ([203.220.32.147]:21448 "EHLO
	relay01.mail-hub.kbs.net.au") by vger.kernel.org with ESMTP
	id S261737AbULGCcK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Dec 2004 21:32:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nathan Scott <nathans@sgi.com>, linux-scsi@vger.kernel.org



Hi Nathan,

I have seen this problem before with an adaptec U320 controller. The problem
was caused by using a Ultra160 cable on a Ultra320 controller and disk. The
kernel driver for some reason reacted really strange.
The fix I found was to go into the scsi BIOS and set the bus speed from 320
(or it might be max/auto) to 160 and it worked fine. Of course this means
you'll be in Ultra160 mode. Onec the kernel booted (somtimes 10 mintues
later) disk access worked, just very slow, like you reported 3mb/sec tops.

Regards,
Paul

----- Original Message ----- 
From: "Nathan Scott" <nathans@sgi.com>
To: <linux-scsi@vger.kernel.org>
Sent: Tuesday, December 07, 2004 1:23 PM
Subject: Adaptec SCSI oddity


> Hi there,
>
> Can anyone provide some insight into what's going on here?
> Christoph suggested I ask here;  I've also tried out Linus'
> current -bk tree (2.6.10-rc3) without luck, same problem.
>
> I'm happy to try out patches, etc.
>
> thanks!
>
> ----- Forwarded message from Nathan Scott <nathans@sgi.com> -----
>
> Date: Mon, 6 Dec 2004 13:13:48 +1100
> To: hch@lst.de, jeremy@sgi.com
> User-Agent: Mutt/1.5.3i
> From: Nathan Scott <nathans@sgi.com>
> Subject: SCSI oddity
>
> Hi guys,
>
> We recently got an ia32 machine for XFS performance testing which
> has 2 Adaptec SCSI disk drives.  Not sure exactly which model(s)
> yet.  When I boot sles9-sp1 and/or 2.6.9 vanilla, bootup takes ages
> because of some kind of probing of these devices.  Once that is
> finally done, the drives perform terribly ... I can't get >3MB/s
> out of them.  It seems this probing has something to do with it,
> looks like its trying to select some default parameters?  Have
> you seen anything like this before?  Here's dmesg, proc/scsi, etc
> if it helps.. any tips on how to fix this?
>
> (the user/curr/goal stuff in the /proc dump below seems to show
> the wierdness -- user=320,curr/goal=3.3?  what is that?)
>
> I also have a couple of local IDE disks, and they consistently
> hit around 50-55MB/sec (all measurements here are just raw device
> direct reads, using a 64k buffer size).
>
> thanks!
>
> -- 
> Nathan
>
>
> Loading kernel/dSCSI subsystem initialized
> rivers/scsi/scsi_mod.ko
> Loading kernel/drivers/scsi/sd_mACPI: PCI interrupt 0000:04:04.0[A] -> GSI
50 (level, low) -> IRQ 50
> od.ko
> Loading kernel/drivers/scsi/aic7xxx/aic79xx.ko
> ACPI: PCI interrupt 0000:04:04.1[B] -> GSI 51 (level, low) -> IRQ 51
> scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11
>         <Adaptec AIC7902 Ultra320 SCSI adapter>
>         aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66Mhz, 512
SCBs
>
> (scsi0:A:0): 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> (scsi0:A:0): 160.000MB/s transfers (80.000MHz DT|IU|QAS, 16bit)
> (scsi0:A:0): 160.000MB/s transfers (80.000MHz DT, 16bit)
> (scsi0:A:0): 80.000MB/s transfers (40.000MHz DT, 16bit)
> (scsi0:A:0): 80.000MB/s transfers (40.000MHz, 16bit)
> (scsi0:A:0): 66.006MB/s transfers (33.003MHz DT, 16bit)
> (scsi0:A:0): 66.006MB/s transfers (33.003MHz, 16bit)
> (scsi0:A:0): 40.000MB/s transfers (20.000MHz DT, 16bit)
> (scsi0:A:0): 40.000MB/s transfers (20.000MHz, 16bit)
> (scsi0:A:0): 40.000MB/s transfers (40.000MHz)
> (scsi0:A:0): 38.460MB/s transfers (19.230MHz DT, 16bit)
> (scsi0:A:0): 38.460MB/s transfers (19.230MHz, 16bit)
> (scsi0:A:0): 35.714MB/s transfers (17.857MHz DT, 16bit)
> (scsi0:A:0): 35.714MB/s transfers (17.857MHz, 16bit)
> (scsi0:A:0): 33.332MB/s transfers (16.666MHz DT, 16bit)
> (scsi0:A:0): 33.332MB/s transfers (16.666MHz, 16bit)
> (scsi0:A:0): 33.003MB/s transfers (33.003MHz)
> (scsi0:A:0): 31.250MB/s transfers (15.625MHz DT, 16bit)
> (scsi0:A:0): 31.250MB/s transfers (15.625MHz, 16bit)
> (scsi0:A:0): 29.410MB/s transfers (14.705MHz DT, 16bit)
> (scsi0:A:0): 29.410MB/s transfers (14.705MHz, 16bit)
> (scsi0:A:0): 27.776MB/s transfers (13.888MHz DT, 16bit)
> (scsi0:A:0): 27.776MB/s transfers (13.888MHz, 16bit)
> (scsi0:A:0): 26.314MB/s transfers (13.157MHz DT, 16bit)
> (scsi0:A:0): 26.314MB/s transfers (13.157MHz, 16bit)
> (scsi0:A:0): 25.000MB/s transfers (12.500MHz DT, 16bit)
> (scsi0:A:0): 25.000MB/s transfers (12.500MHz, 16bit)
> (scsi0:A:0): 23.808MB/s transfers (11.904MHz DT, 16bit)
> (scsi0:A:0): 23.808MB/s transfers (11.904MHz, 16bit)
> (scsi0:A:0): 22.726MB/s transfers (11.363MHz DT, 16bit)
> (scsi0:A:0): 22.726MB/s transfers (11.363MHz, 16bit)
> (scsi0:A:0): 21.738MB/s transfers (10.869MHz DT, 16bit)
> (scsi0:A:0): 21.738MB/s transfers (10.869MHz, 16bit)
> (scsi0:A:0): 20.832MB/s transfers (10.416MHz DT, 16bit)
> (scsi0:A:0): 20.832MB/s transfers (10.416MHz, 16bit)
> (scsi0:A:0): 20.000MB/s transfers (10.000MHz DT, 16bit)
> (scsi0:A:0): 20.000MB/s transfers (10.000MHz, 16bit)
> (scsi0:A:0): 20.000MB/s transfers (20.000MHz)
> (scsi0:A:0): 19.230MB/s transfers (9.615MHz, 16bit)
> (scsi0:A:0): 19.230MB/s transfers (19.230MHz)
> (scsi0:A:0): 18.518MB/s transfers (9.259MHz, 16bit)
> (scsi0:A:0): 17.857MB/s transfers (17.857MHz)
> (scsi0:A:0): 17.856MB/s transfers (8.928MHz, 16bit)
> (scsi0:A:0): 17.240MB/s transfers (8.620MHz, 16bit)
> (scsi0:A:0): 16.666MB/s transfers (8.333MHz, 16bit)
> (scsi0:A:0): 16.666MB/s transfers (16.666MHz)
> (scsi0:A:0): 16.128MB/s transfers (8.064MHz, 16bit)
> (scsi0:A:0): 15.625MB/s transfers (15.625MHz)
> (scsi0:A:0): 15.624MB/s transfers (7.812MHz, 16bit)
> (scsi0:A:0): 15.150MB/s transfers (7.575MHz, 16bit)
> (scsi0:A:0): 14.705MB/s transfers (14.705MHz)
> (scsi0:A:0): 14.704MB/s transfers (7.352MHz, 16bit)
> (scsi0:A:0): 14.284MB/s transfers (7.142MHz, 16bit)
> (scsi0:A:0): 13.888MB/s transfers (6.944MHz, 16bit)
> (scsi0:A:0): 13.888MB/s transfers (13.888MHz)
> (scsi0:A:0): 13.512MB/s transfers (6.756MHz, 16bit)
> (scsi0:A:0): 13.157MB/s transfers (13.157MHz)
> (scsi0:A:0): 13.156MB/s transfers (6.578MHz, 16bit)
> (scsi0:A:0): 12.820MB/s transfers (6.410MHz, 16bit)
> (scsi0:A:0): 12.500MB/s transfers (6.250MHz, 16bit)
> (scsi0:A:0): 12.500MB/s transfers (12.500MHz)
> (scsi0:A:0): 12.194MB/s transfers (6.097MHz, 16bit)
> (scsi0:A:0): 11.904MB/s transfers (5.952MHz, 16bit)
> (scsi0:A:0): 11.904MB/s transfers (11.904MHz)
> (scsi0:A:0): 11.626MB/s transfers (5.813MHz, 16bit)
> (scsi0:A:0): 11.363MB/s transfers (11.363MHz)
> (scsi0:A:0): 11.362MB/s transfers (5.681MHz, 16bit)
> (scsi0:A:0): 11.110MB/s transfers (5.555MHz, 16bit)
> (scsi0:A:0): 10.869MB/s transfers (10.869MHz)
> (scsi0:A:0): 10.868MB/s transfers (5.434MHz, 16bit)
> (scsi0:A:0): 10.638MB/s transfers (5.319MHz, 16bit)
> (scsi0:A:0): 10.416MB/s transfers (5.208MHz, 16bit)
> (scsi0:A:0): 10.416MB/s transfers (10.416MHz)
> (scsi0:A:0): 10.204MB/s transfers (5.102MHz, 16bit)
> (scsi0:A:0): 10.000MB/s transfers (5.000MHz, 16bit)
> (scsi0:A:0): 10.000MB/s transfers (10.000MHz)
> (scsi0:A:0): 6.600MB/s transfers (16bit)
> (scsi0:A:0): 9.615MB/s transfers (9.615MHz)
> (scsi0:A:0): 9.259MB/s transfers (9.259MHz)
> (scsi0:A:0): 8.928MB/s transfers (8.928MHz)
> (scsi0:A:0): 8.620MB/s transfers (8.620MHz)
> (scsi0:A:0): 8.333MB/s transfers (8.333MHz)
> (scsi0:A:0): 8.064MB/s transfers (8.064MHz)
> (scsi0:A:0): 7.812MB/s transfers (7.812MHz)
> (scsi0:A:0): 7.575MB/s transfers (7.575MHz)
> (scsi0:A:0): 7.352MB/s transfers (7.352MHz)
> (scsi0:A:0): 7.142MB/s transfers (7.142MHz)
> (scsi0:A:0): 6.944MB/s transfers (6.944MHz)
> (scsi0:A:0): 6.756MB/s transfers (6.756MHz)
> (scsi0:A:0): 6.578MB/s transfers (6.578MHz)
> (scsi0:A:0): 6.410MB/s transfers (6.410MHz)
> (scsi0:A:0): 6.250MB/s transfers (6.250MHz)
> (scsi0:A:0): 6.097MB/s transfers (6.097MHz)
> (scsi0:A:0): 5.952MB/s transfers (5.952MHz)
> (scsi0:A:0): 5.813MB/s transfers (5.813MHz)
> (scsi0:A:0): 5.681MB/s transfers (5.681MHz)
> (scsi0:A:0): 5.555MB/s transfers (5.555MHz)
> (scsi0:A:0): 5.434MB/s transfers (5.434MHz)
> (scsi0:A:0): 5.319MB/s transfers (5.319MHz)
> (scsi0:A:0): 5.208MB/s transfers (5.208MHz)
> (scsi0:A:0): 5.102MB/s transfers (5.102MHz)
> (scsi0:A:0): 5.000MB/s transfers (5.000MHz)
> (scsi0:A:2): 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> (scsi0:A:2): 160.000MB/s transfers (80.000MHz DT|IU|QAS, 16bit)
> (scsi0:A:2): 160.000MB/s transfers (80.000MHz DT, 16bit)
> (scsi0:A:2): 80.000MB/s transfers (40.000MHz DT, 16bit)
> (scsi0:A:2): 80.000MB/s transfers (40.000MHz, 16bit)
> (scsi0:A:2): 66.006MB/s transfers (33.003MHz DT, 16bit)
> (scsi0:A:2): 66.006MB/s transfers (33.003MHz, 16bit)
> (scsi0:A:2): 40.000MB/s transfers (20.000MHz DT, 16bit)
> (scsi0:A:2): 40.000MB/s transfers (20.000MHz, 16bit)
> (scsi0:A:2): 40.000MB/s transfers (40.000MHz)
> (scsi0:A:2): 38.460MB/s transfers (19.230MHz DT, 16bit)
> (scsi0:A:2): 38.460MB/s transfers (19.230MHz, 16bit)
> (scsi0:A:2): 35.714MB/s transfers (17.857MHz DT, 16bit)
> (scsi0:A:2): 35.714MB/s transfers (17.857MHz, 16bit)
> (scsi0:A:2): 33.332MB/s transfers (16.666MHz DT, 16bit)
> (scsi0:A:2): 33.332MB/s transfers (16.666MHz, 16bit)
> (scsi0:A:2): 33.003MB/s transfers (33.003MHz)
> (scsi0:A:2): 31.250MB/s transfers (15.625MHz DT, 16bit)
> (scsi0:A:2): 31.250MB/s transfers (15.625MHz, 16bit)
> (scsi0:A:2): 29.410MB/s transfers (14.705MHz DT, 16bit)
> (scsi0:A:2): 29.410MB/s transfers (14.705MHz, 16bit)
> (scsi0:A:2): 27.776MB/s transfers (13.888MHz DT, 16bit)
> (scsi0:A:2): 27.776MB/s transfers (13.888MHz, 16bit)
> (scsi0:A:2): 26.314MB/s transfers (13.157MHz DT, 16bit)
> (scsi0:A:2): 26.314MB/s transfers (13.157MHz, 16bit)
> (scsi0:A:2): 25.000MB/s transfers (12.500MHz DT, 16bit)
> (scsi0:A:2): 25.000MB/s transfers (12.500MHz, 16bit)
> (scsi0:A:2): 23.808MB/s transfers (11.904MHz DT, 16bit)
> (scsi0:A:2): 23.808MB/s transfers (11.904MHz, 16bit)
> (scsi0:A:2): 22.726MB/s transfers (11.363MHz DT, 16bit)
> (scsi0:A:2): 22.726MB/s transfers (11.363MHz, 16bit)
> (scsi0:A:2): 21.738MB/s transfers (10.869MHz DT, 16bit)
> (scsi0:A:2): 21.738MB/s transfers (10.869MHz, 16bit)
> (scsi0:A:2): 20.832MB/s transfers (10.416MHz DT, 16bit)
> (scsi0:A:2): 20.832MB/s transfers (10.416MHz, 16bit)
> (scsi0:A:2): 20.000MB/s transfers (10.000MHz DT, 16bit)
> (scsi0:A:2): 20.000MB/s transfers (10.000MHz, 16bit)
> (scsi0:A:2): 20.000MB/s transfers (20.000MHz)
> (scsi0:A:2): 19.230MB/s transfers (9.615MHz, 16bit)
> (scsi0:A:2): 19.230MB/s transfers (19.230MHz)
> (scsi0:A:2): 18.518MB/s transfers (9.259MHz, 16bit)
> (scsi0:A:2): 17.857MB/s transfers (17.857MHz)
> (scsi0:A:2): 17.856MB/s transfers (8.928MHz, 16bit)
> (scsi0:A:2): 17.240MB/s transfers (8.620MHz, 16bit)
> (scsi0:A:2): 16.666MB/s transfers (8.333MHz, 16bit)
> (scsi0:A:2): 16.666MB/s transfers (16.666MHz)
> (scsi0:A:2): 16.128MB/s transfers (8.064MHz, 16bit)
> (scsi0:A:2): 15.625MB/s transfers (15.625MHz)
> (scsi0:A:2): 15.624MB/s transfers (7.812MHz, 16bit)
> (scsi0:A:2): 15.150MB/s transfers (7.575MHz, 16bit)
> (scsi0:A:2): 14.705MB/s transfers (14.705MHz)
> (scsi0:A:2): 14.704MB/s transfers (7.352MHz, 16bit)
> (scsi0:A:2): 14.284MB/s transfers (7.142MHz, 16bit)
> (scsi0:A:2): 13.888MB/s transfers (6.944MHz, 16bit)
> (scsi0:A:2): 13.888MB/s transfers (13.888MHz)
> (scsi0:A:2): 13.512MB/s transfers (6.756MHz, 16bit)
> (scsi0:A:2): 13.157MB/s transfers (13.157MHz)
> (scsi0:A:2): 13.156MB/s transfers (6.578MHz, 16bit)
> (scsi0:A:2): 12.820MB/s transfers (6.410MHz, 16bit)
> (scsi0:A:2): 12.500MB/s transfers (6.250MHz, 16bit)
> (scsi0:A:2): 12.500MB/s transfers (12.500MHz)
> (scsi0:A:2): 12.194MB/s transfers (6.097MHz, 16bit)
> (scsi0:A:2): 11.904MB/s transfers (5.952MHz, 16bit)
> (scsi0:A:2): 11.904MB/s transfers (11.904MHz)
> (scsi0:A:2): 11.626MB/s transfers (5.813MHz, 16bit)
> (scsi0:A:2): 11.363MB/s transfers (11.363MHz)
> (scsi0:A:2): 11.362MB/s transfers (5.681MHz, 16bit)
> (scsi0:A:2): 11.110MB/s transfers (5.555MHz, 16bit)
> (scsi0:A:2): 10.869MB/s transfers (10.869MHz)
> (scsi0:A:2): 10.868MB/s transfers (5.434MHz, 16bit)
> (scsi0:A:2): 10.638MB/s transfers (5.319MHz, 16bit)
> (scsi0:A:2): 10.416MB/s transfers (5.208MHz, 16bit)
> (scsi0:A:2): 10.416MB/s transfers (10.416MHz)
> (scsi0:A:2): 10.204MB/s transfers (5.102MHz, 16bit)
> (scsi0:A:2): 10.000MB/s transfers (5.000MHz, 16bit)
> (scsi0:A:2): 10.000MB/s transfers (10.000MHz)
> (scsi0:A:2): 6.600MB/s transfers (16bit)
> (scsi0:A:2): 9.615MB/s transfers (9.615MHz)
> (scsi0:A:2): 9.259MB/s transfers (9.259MHz)
> (scsi0:A:2): 8.928MB/s transfers (8.928MHz)
> (scsi0:A:2): 8.620MB/s transfers (8.620MHz)
> (scsi0:A:2): 8.333MB/s transfers (8.333MHz)
> (scsi0:A:2): 8.064MB/s transfers (8.064MHz)
> (scsi0:A:2): 7.812MB/s transfers (7.812MHz)
> (scsi0:A:2): 7.575MB/s transfers (7.575MHz)
> (scsi0:A:2): 7.352MB/s transfers (7.352MHz)
> (scsi0:A:2): 7.142MB/s transfers (7.142MHz)
> (scsi0:A:2): 6.944MB/s transfers (6.944MHz)
> (scsi0:A:2): 6.756MB/s transfers (6.756MHz)
> (scsi0:A:2): 6.578MB/s transfers (6.578MHz)
> (scsi0:A:2): 6.410MB/s transfers (6.410MHz)
> (scsi0:A:2): 6.250MB/s transfers (6.250MHz)
> (scsi0:A:2): 6.097MB/s transfers (6.097MHz)
> (scsi0:A:2): 5.952MB/s transfers (5.952MHz)
> (scsi0:A:2): 5.813MB/s transfers (5.813MHz)
> (scsi0:A:2): 5.681MB/s transfers (5.681MHz)
> (scsi0:A:2): 5.555MB/s transfers (5.555MHz)
> (scsi0:A:2): 5.434MB/s transfers (5.434MHz)
> (scsi0:A:2): 5.319MB/s transfers (5.319MHz)
> (scsi0:A:2): 5.208MB/s transfers (5.208MHz)
> (scsi0:A:2): 5.102MB/s transfers (5.102MHz)
> (scsi0:A:2): 5.000MB/s transfers (5.000MHz)
>   Vendor: SEAGATE   Model: ST373307LW        Rev: 0007
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> (scsi0:A:0): 3.300MB/s transfers
> scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
> SCSI device sda: 143374744 512-byte hdwr sectors (73408 MB)
> SCSI device sda: drive cache: write back
>  sda: unknown partition table
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
>   Vendor: SEAGATE   Model: ST373307LW        Rev: 0007
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> (scsi0:A:2): 3.300MB/s transfers
> scsi0:A:2:0: Tagged Queuing enabled.  Depth 32
> SCSI device sdb: 143374744 512-byte hdwr sectors (73408 MB)
> SCSI device sdb: drive cache: write back
>  sdb: unknown partition table
> Attached scsi disk sdb at scsi0, channel 0, id 2, lun 0
> scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11
>         <Adaptec AIC7902 Ultra320 SCSI adapter>
>         aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI 33 or 66Mhz, 512
SCBs
>
>
> 12:43 fsgqa@sheila ~ 101> find /proc/scsi/
> /proc/scsi/
> /proc/scsi/sg
> /proc/scsi/sg/version
> /proc/scsi/sg/device_strs
> /proc/scsi/sg/devices
> /proc/scsi/sg/device_hdr
> /proc/scsi/sg/def_reserved_size
> /proc/scsi/sg/debug
> /proc/scsi/sg/allow_dio
> /proc/scsi/aic79xx
> /proc/scsi/aic79xx/1
> /proc/scsi/aic79xx/0
> /proc/scsi/device_info
> /proc/scsi/scsi
> 12:43 fsgqa@sheila ~ 102> cat /proc/scsi/scsi
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: SEAGATE  Model: ST373307LW       Rev: 0007
>   Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 02 Lun: 00
>   Vendor: SEAGATE  Model: ST373307LW       Rev: 0007
>   Type:   Direct-Access                    ANSI SCSI revision: 03
> 12:44 fsgqa@sheila ~ 103> cat /proc/scsi/device_info
> 'Aashima' 'IMAGERY 2400SP' 0x1
> 'CHINON' 'CD-ROM CDS-431' 0x1
> 'CHINON' 'CD-ROM CDS-535' 0x1
> 'DENON' 'DRD-25X' 0x1
> 'HITACHI' 'DK312C' 0x1
> 'HITACHI' 'DK314C' 0x1
> 'IMS' 'CDD521/10' 0x1
> 'MAXTOR' 'XT-3280' 0x1
> 'MAXTOR' 'XT-4380S' 0x1
> 'MAXTOR' 'MXT-1240S' 0x1
> 'MAXTOR' 'XT-4170S' 0x1
> 'MAXTOR' 'XT-8760S' 0x1
> 'MEDIAVIS' 'RENO CD-ROMX2A' 0x1
> 'NEC' 'CD-ROM DRIVE:841' 0x1
> 'PHILIPS' 'PCA80SC' 0x1
> 'RODIME' 'RO3000S' 0x1
> 'SUN' 'SENA' 0x1
> 'SANYO' 'CRD-250S' 0x1
> 'SEAGATE' 'ST157N' 0x1
> 'SEAGATE' 'ST296' 0x1
> 'SEAGATE' 'ST1581' 0x1
> 'SONY' 'CD-ROM CDU-541' 0x1
> 'SONY' 'CD-ROM CDU-55S' 0x1
> 'SONY' 'CD-ROM CDU-561' 0x1
> 'SONY' 'CD-ROM CDU-8012' 0x1
> 'TANDBERG' 'TDC 3600' 0x1
> 'TEAC' 'CD-R55S' 0x1
> 'TEAC' 'CD-ROM' 0x1
> 'TEAC' 'MT-2ST/45S2-27' 0x1
> 'HP' 'C1750A' 0x1
> 'HP' 'C1790A' 0x1
> 'HP' 'C2500A' 0x1
> 'MEDIAVIS' 'CDR-H93MV' 0x1
> 'MICROTEK' 'ScanMaker II' 0x1
> 'MITSUMI' 'CD-R CR-2201CS' 0x1
> 'NEC' 'D3856' 0x1
> 'QUANTUM' 'LPS525S' 0x1
> 'QUANTUM' 'PD1225S' 0x1
> 'QUANTUM' 'FIREBALL ST4.3S' 0x1
> 'RELISYS' 'Scorpio' 0x1
> 'SANKYO' 'CP525' 0x1
> 'TEXEL' 'CD-ROM' 0x1
> 'YAMAHA' 'CDR100' 0x1
> 'YAMAHA' 'CDR102' 0x1
> 'YAMAHA' 'CRW8424S' 0x1
> 'YAMAHA' 'CRW6416S' 0x1
> 'ADAPTEC' 'AACRAID' 0x2
> 'ADAPTEC' 'Adaptec 5400S' 0x2
> 'AFT PRO' '-IX CF' 0x2
> 'BELKIN' 'USB 2 HS-CF' 0x2
> 'CANON' 'IPUBJD' 0x40
> 'CBOX3' 'USB Storage-SMC' 0x2
> 'CMD' 'CRA-7280' 0x40
> 'CNSI' 'G7324' 0x40
> 'CNSi' 'G8324' 0x40
> 'COMPAQ' 'LOGICAL VOLUME' 0x2
> 'COMPAQ' 'CR3500' 0x2
> 'COMPAQ' 'MSA1000' 0x1040
> 'COMPAQ' 'MSA1000 VOLUME' 0x1040
> 'COMPAQ' 'HSV110' 0x21000
> 'DDN' 'SAN DataDirector' 0x40
> 'DEC' 'HSG80' 0x1040
> 'DELL' 'PV660F' 0x40
> 'DELL' 'PV660F   PSEUDO' 0x40
> 'DELL' 'PSEUDO DEVICE .' 0x40
> 'DELL' 'PV530F' 0x40
> 'DELL' 'PERCRAID' 0x2
> 'DGC' 'RAID' 0x40
> 'DGC' 'DISK' 0x40
> 'EMC' 'SYMMETRIX' 0x242
> 'EMULEX' 'MD21/S2     ESDI' 0x10
> 'FSC' 'CentricStor' 0x240
> 'Generic' 'USB SD Reader' 0x2
> 'Generic' 'USB Storage-SMC' 0x2
> 'Generic' 'USB Storage-SMC' 0x2
> 'HITACHI' 'DF400' 0x40
> 'HITACHI' 'DF500' 0x40
> 'HITACHI' 'DF600' 0x40
> 'HP' 'A6189A' 0x240
> 'HP' 'OPEN-' 0x240
> 'HP' 'NetRAID-4M' 0x2
> 'HP' 'HSV100' 0x21000
> 'HP' 'C1557A' 0x2
> 'IBM' 'AuSaV1S2' 0x2
> 'IBM' 'ProFibre 4000R' 0x240
> 'iomega' 'jaz 1GB' 0x21
> 'IOMEGA' 'Io20S         *F' 0x8
> 'INSITE' 'Floptical   F*8I' 0x8
> 'INSITE' 'I325VM' 0x8
> 'iRiver' 'iFP Mass Driver' 0x80400
> 'LASOUND' 'CDX7405' 0x90
> 'MATSHITA' 'PD-1' 0x12
> 'MATSHITA' 'DMC-LC5' 0x80400
> 'MATSHITA' 'DMC-LC40' 0x80400
> 'Medion' 'Flash XL  MMC/SD' 0x2
> 'MegaRAID' 'LD' 0x2
> 'MICROP' '4110' 0x20
> 'MYLEX' 'DACARMRB' 0x20000
> 'nCipher' 'Fastness Crypto' 0x2
> 'NAKAMICH' 'MJ-4.8S' 0x12
> 'NAKAMICH' 'MJ-5.16S' 0x12
> 'NEC' 'PD-1 ODX654P' 0x12
> 'NRC' 'MBR-7' 0x12
> 'NRC' 'MBR-7.4' 0x12
> 'PIONEER' 'CD-ROM DRM-600' 0x12
> 'PIONEER' 'CD-ROM DRM-602X' 0x12
> 'PIONEER' 'CD-ROM DRM-604X' 0x12
> 'REGAL' 'CDC-4X' 0x90
> 'SanDisk' 'ImageMate CF-SD1' 0x2
> 'SGI' 'RAID3' 0x40
> 'SGI' 'RAID5' 0x40
> 'SGI' 'TP9100' 0x20000
> 'SMSC' 'USB 2 HS-CF' 0x40
> 'SONY' 'CD-ROM CDU-8001' 0x4
> 'SONY' 'TSL' 0x2
> 'SUN' 'T300' 0x40
> 'SUN' 'T4' 0x40
> 'TEXEL' 'CD-ROM' 0x4
> 'TOSHIBA' 'CDROM' 0x100
> 'TOSHIBA' 'CD-ROM' 0x100
> 'USB2.0' 'SMARTMEDIA/XD' 0x2
> 'XYRATEX' 'RS' 0x240
> 'Zzyzx' 'RocketStor 500S' 0x40
> 'Zzyzx' 'RocketStor 2000' 0x40
> 12:44 fsgqa@sheila ~ 104> cat /proc/scsi/aic79xx/0
> Adaptec AIC79xx driver version: 1.3.11
> Adaptec AIC7902 Ultra320 SCSI adapter
> aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
> Allocated SCBs: 4, SG List Length: 128
>
> Serial EEPROM:
> 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8
> 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8
> 0x09f4 0x0146 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff
> 0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0400 0xb3c7
>
> Target 0 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
>         Goal: 3.300MB/s transfers
>         Curr: 3.300MB/s transfers
>         Transmission Errors 0
>         Channel A Target 0 Lun 0 Settings
>                 Commands Queued 216
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> Target 1 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> Target 2 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
>         Goal: 3.300MB/s transfers
>         Curr: 3.300MB/s transfers
>         Transmission Errors 0
>         Channel A Target 2 Lun 0 Settings
>                 Commands Queued 220
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> Target 3 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> Target 4 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> Target 5 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> Target 6 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> Target 7 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> Target 8 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> Target 9 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> Target 10 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> Target 11 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> Target 12 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> Target 13 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> Target 14 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> Target 15 Negotiation Settings
>         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> 12:44 fsgqa@sheila ~ 105>
>
>
> ----- End forwarded message -----
>
> -- 
> Nathan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

