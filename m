From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: buggy scsi_register behaviour in 2.5.51
Date: Tue, 17 Dec 2002 14:27:10 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DFE998E.1080103@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040902040901040805090509"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: wrlk@riede.org

This is a multi-part message in MIME format.
--------------040902040901040805090509
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Willem,
Can't fix all those problems but I did notice that
idescsi_release() was missing a call to scsi_unregister().
With this patch the ide-scsi entry remains dangling in
sysfs (ide problem??) but the scsi host gets cleaned up
after rmmod.

The attachment is against lk 2.5.52 . The ide-scsi
driver in lk 2.5.52 needs cleaning up in several
areas. If no-one else wants to attack it then I
will.

Doug Gilbert


Willem Riede wrote:
 > I was investigating why I get
 >
 > Dec 14 14:50:55 fallguy kernel: Badness in kobject_register at lib/kobject.c:113
 > Dec 14 14:50:55 fallguy kernel: Call Trace:
 > Dec 14 14:50:55 fallguy kernel:  [<c01c7c88>] kobject_register+0x58/0x70
 > Dec 14 14:50:55 fallguy kernel:  [<c01db442>] bus_add_driver+0x82/0xd0
 > Dec 14 14:50:55 fallguy kernel:  [<c022bd00>] ide_drive_remove+0x0/0x30
 > Dec 14 14:50:55 fallguy kernel:  [<c022bdec>] ide_register_driver+0xbc/0xf0
 > Dec 14 14:50:55 fallguy kernel:  [<c0133f6a>] sys_init_module+0x1ba/0x1d0
 > Dec 14 14:50:55 fallguy kernel:  [<c010b643>] syscall_call+0x7/0xb
 >
 > when re-insmod-ing ide-scsi, and the "badness" is in sysfs create_dir,
 > appearently because the ide-scsi directory is not removed when ide-scsi
 > is unloaded so the create fails because it already exists.
 >
 > But that's not the only thing going wrong when repeatedly (un)loading.
 > See below for some really horrible effects:
 >
 > [root@fallguy linux-2.5.51]# insmod drivers/scsi/ide-scsi.ko
 > [root@fallguy linux-2.5.51]# cat /proc/scsi/scsi
 > Attached devices:
 > Host: scsi0 Channel: 00 Id: 03 Lun: 00
 >   Vendor: OnStream Model: SC-30            Rev: 1.09
 >   Type:   Sequential-Access                ANSI SCSI revision: 02
 > Host: scsi0 Channel: 00 Id: 06 Lun: 00
 >   Vendor: MATSHITA Model: CD-R   CW-7502   Rev: 4.17
 >   Type:   CD-ROM                           ANSI SCSI revision: 02
 > Host: scsi1 Channel: 00 Id: 00 Lun: 00
 >   Vendor: IBM      Model: DNES-318350W     Rev: SA30
 >   Type:   Direct-Access                    ANSI SCSI revision: 03
 > Host: scsi1 Channel: 00 Id: 01 Lun: 00
 >   Vendor: IBM      Model: DGHS09U          Rev: 0350
 >   Type:   Direct-Access                    ANSI SCSI revision: 03
 > Host: scsi3 Channel: 00 Id: 00 Lun: 00
 >   Vendor: CONNER   Model: CTT8000-A        Rev: 2.08
 >   Type:   Sequential-Access                ANSI SCSI revision: 02
 > Host: scsi3 Channel: 00 Id: 01 Lun: 00
 >   Vendor: OnStream Model: DI-30            Rev: 1.09
 >   Type:   Sequential-Access                ANSI SCSI revision: 02
 > Host: scsi3 Channel: 00 Id: 02 Lun: 00
 >   Vendor: OnStream Model: ADR Series       Rev: 5.05
 >   Type:   Sequential-Access                ANSI SCSI revision: 02
 > [root@fallguy linux-2.5.51]# ls -l /sysfs/bus/ide/drivers/ide-scsi
 > total 0
 > [root@fallguy linux-2.5.51]# ls -ld /sysfs/bus/ide/drivers/ide-scsi
 > drwxr-xr-x    2 root     root            0 Dec 15 15:54 
/sysfs/bus/ide/drivers/ide-scsi
 > [root@fallguy linux-2.5.51]# rmmod ide_scsi
 > [root@fallguy linux-2.5.51]# ls -ld /sysfs/bus/ide/drivers/ide-scsi
 > drwxr-xr-x    2 root     root            0 Dec 15 15:54 
/sysfs/bus/ide/drivers/ide-scsi
 >
 >         ^^ the directory is still there ! ^^
 >
 > [root@fallguy linux-2.5.51]# cat /proc/scsi/scsi
 > Attached devices:
 > Host: scsi0 Channel: 00 Id: 03 Lun: 00
 >   Vendor: OnStream Model: SC-30            Rev: 1.09
 >   Type:   Sequential-Access                ANSI SCSI revision: 02
 > Host: scsi0 Channel: 00 Id: 06 Lun: 00
 >   Vendor: MATSHITA Model: CD-R   CW-7502   Rev: 4.17
 >   Type:   CD-ROM                           ANSI SCSI revision: 02
 > Host: scsi1 Channel: 00 Id: 00 Lun: 00
 >   Vendor: IBM      Model: DNES-318350W     Rev: SA30
 >   Type:   Direct-Access                    ANSI SCSI revision: 03
 > Host: scsi1 Channel: 00 Id: 01 Lun: 00
 >   Vendor: IBM      Model: DGHS09U          Rev: 0350
 >   Type:   Direct-Access                    ANSI SCSI revision: 03
 > [root@fallguy linux-2.5.51]# insmod drivers/scsi/ide-scsi.ko
 > [root@fallguy linux-2.5.51]# ls -ld /sysfs/bus/ide/drivers/ide-scsi
 > drwxr-xr-x    2 root     root            0 Dec 15 15:54 
/sysfs/bus/ide/drivers/ide-scsi
 > [root@fallguy linux-2.5.51]# cat /proc/scsi/scsi
 > Attached devices:
 > Host: scsi0 Channel: 00 Id: 03 Lun: 00
 >   Vendor: OnStream Model: SC-30            Rev: 1.09
 >   Type:   Sequential-Access                ANSI SCSI revision: 02
 > Host: scsi0 Channel: 00 Id: 06 Lun: 00
 >   Vendor: MATSHITA Model: CD-R   CW-7502   Rev: 4.17
 >   Type:   CD-ROM                           ANSI SCSI revision: 02
 > Host: scsi1 Channel: 00 Id: 00 Lun: 00
 >   Vendor: IBM      Model: DNES-318350W     Rev: SA30
 >   Type:   Direct-Access                    ANSI SCSI revision: 03
 > Host: scsi1 Channel: 00 Id: 01 Lun: 00
 >   Vendor: IBM      Model: DGHS09U          Rev: 0350
 >   Type:   Direct-Access                    ANSI SCSI revision: 03
 > Host: scsi3 Channel: 00 Id: 00 Lun: 00
 >   Vendor: OnStream Model: ADR Series       Rev: 5.05
 >   Type:   Sequential-Access                ANSI SCSI revision: 02
 > Host: scsi3 Channel: 00 Id: 01 Lun: 00
 >   Vendor: OnStream Model: DI-30            Rev: 1.09
 >   Type:   Sequential-Access                ANSI SCSI revision: 02
 > Host: scsi3 Channel: 00 Id: 02 Lun: 00
 >   Vendor: CONNER   Model: CTT8000-A        Rev: 2.08
 >   Type:   Sequential-Access                ANSI SCSI revision: 02
 > Host: scsi4 Channel: 00 Id: 00 Lun: 00
 >   Vendor: OnStream Model: ADR Series       Rev: 5.05
 >   Type:   Sequential-Access                ANSI SCSI revision: 02
 > Host: scsi4 Channel: 00 Id: 01 Lun: 00
 >   Vendor: OnStream Model: DI-30            Rev: 1.09
 >   Type:   Sequential-Access                ANSI SCSI revision: 02
 > Host: scsi4 Channel: 00 Id: 02 Lun: 00
 >   Vendor: CONNER   Model: CTT8000-A        Rev: 2.08
 >   Type:   Sequential-Access                ANSI SCSI revision: 02
 >
 > ide-scsi has now been assigned both scsi3 and scsi4?? Its devices appear twice!
 >
 > Clearly not correct. I'll work on fixing this, but first I have a question.
 >
 > Reading the source (hosts.c), it appears that a host adapter will only get
 > the same number as it had before, if it has been specified in the module
 > parameter "scsihosts".
 >
 > Is it a concious design decision to not try and re-assign the same number as
 > before if an adapter not in "scsihosts" gets (un)loaded repeatedly?
 >
 > I think a fix for this would be different if I would try to reassign the
 > same number than if the intention is to keep assigning new numbers.
 >
 > Thanks for your advise. Willem Riede.
 >
 > -
 > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
 > the body of a message to majordomo@vger.kernel.org
 > More majordomo info at  http://vger.kernel.org/majordomo-info.html
 >

--------------040902040901040805090509
Content-Type: text/plain;
 name="ide-scsi_2552x.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ide-scsi_2552x.diff"

--- linux/drivers/scsi/ide-scsi.c	2002-12-10 17:38:29.000000000 +1100
+++ linux/drivers/scsi/ide-scsi.c2552x	2002-12-17 13:06:39.000000000 +1100
@@ -658,6 +658,7 @@
 		if (drive)
 			DRIVER(drive)->busy--;
 	}
+	scsi_unregister(host);
 	return 0;
 }
 

--------------040902040901040805090509--

