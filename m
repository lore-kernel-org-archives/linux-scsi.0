From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Commit "arm: convert drivers to scsi proc_ops" breaks linux-next
Date: Mon, 26 Mar 2012 22:51:00 -0400
Message-ID: <20120327025100.GD26825@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-next-owner@vger.kernel.org
To: adobriyan@gmail.com
Cc: JBottomley@parallels.com, linux-next@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Alexey,

This error showed up in linux-next today:

 CC      drivers/scsi/arm/powertec.o
drivers/scsi/arm/powertec.c: In function 'powertecscsi_proc_show':
drivers/scsi/arm/powertec.c:199: error: dereferencing pointer to incomplete type
drivers/scsi/arm/powertec.c:202: error: implicit declaration of function 'seq_printf'
drivers/scsi/arm/powertec.c: In function 'powertecscsi_proc_open':
drivers/scsi/arm/powertec.c:214: error: implicit declaration of function 'single_open'
drivers/scsi/arm/powertec.c: At top level:
drivers/scsi/arm/powertec.c:250: error: 'seq_read' undeclared here (not in a function)
drivers/scsi/arm/powertec.c:251: error: 'seq_lseek' undeclared here (not in a function)
drivers/scsi/arm/powertec.c:252: error: 'single_release' undeclared here (not in a function)

and a bisect leads to this:

--------------
commit bb6c20445c1bdd1c49ac5e76801211116694e3b9
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Feb 22 22:46:23 2012 +0300

    [SCSI] arm: convert drivers to scsi proc_ops
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: James Bottomley <JBottomley@Parallels.com>
--------------

I'm not sure why "new" commits are only showing up in linux-next with
just days left in the merge window, but can you have a look ASAP?

THanks,
Paul.

----------

git bisect start
# bad: [88b5d261d52f81806577e939c1744395b9f4edf9] Add linux-next specific files for 20120326
git bisect bad 88b5d261d52f81806577e939c1744395b9f4edf9
# good: [c16fa4f2ad19908a47c63d8fa436a1178438c7e7] Linux 3.3
git bisect good c16fa4f2ad19908a47c63d8fa436a1178438c7e7
# good: [f37ab0fba271e43edab0e3ae9fe644fcda455402] Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging
git bisect good f37ab0fba271e43edab0e3ae9fe644fcda455402
# bad: [03797c27f6c50cd92e396cc31271bd73224239e0] Merge remote-tracking branch 'sound/for-next'
git bisect bad 03797c27f6c50cd92e396cc31271bd73224239e0
# bad: [9f9aa50fe5d555b356bfc34f135bc66d611fe573] Merge remote-tracking branch 'scsi/master'
git bisect bad 9f9aa50fe5d555b356bfc34f135bc66d611fe573
# good: [0cd69e8184c4242ca15494829d675606183e8c78] Merge remote-tracking branch 'arm/for-next'
git bisect good 0cd69e8184c4242ca15494829d675606183e8c78
# good: [8e52333b697339063e338b80560dec7e4396ce42] Merge remote-tracking branch 'fuse/for-next'
git bisect good 8e52333b697339063e338b80560dec7e4396ce42
# good: [21ea2bf9d8a875d79cbf1d70625a4a3cacfa9a64] Merge branch 'kbuild/kconfig' into kbuild/for-next
git bisect good 21ea2bf9d8a875d79cbf1d70625a4a3cacfa9a64
# good: [cf53892ca8c08d2ca7a553258d204c588d37ac87] Merge remote-tracking branch 'infiniband/for-next'
git bisect good cf53892ca8c08d2ca7a553258d204c588d37ac87
# bad: [7ef79ae61a1f5dbfcfda4b4fb01434692e283e3b] [SCSI] vmw_pvscsi: Try setting host->max_id as suggested by the device.
git bisect bad 7ef79ae61a1f5dbfcfda4b4fb01434692e283e3b
# bad: [104c4fe25dc9bde823ba4591e910a77071b98ab5] [SCSI] remove scsi_host_template::proc_info
git bisect bad 104c4fe25dc9bde823ba4591e910a77071b98ab5
# good: [2f97c74b58d2c2b3e0fd67ea1188f73b17f22c93] [SCSI] aha1740: convert to scsi proc_ops
git bisect good 2f97c74b58d2c2b3e0fd67ea1188f73b17f22c93
# good: [6852cc964c8a068d2a9ebe8b9dc922f6c0e29feb] [SCSI] usbstorage: convert to scsi proc_ops
git bisect good 6852cc964c8a068d2a9ebe8b9dc922f6c0e29feb
# good: [d11ea639a11b70ba8f88676af8df329481a701db] [SCSI] eata: convert to scsi proc_ops
git bisect good d11ea639a11b70ba8f88676af8df329481a701db
# good: [64d7ba67031f12b44a99978a2b108ed7d2f074dc] [SCSI] NCR5380: convert to scsi proc_ops
git bisect good 64d7ba67031f12b44a99978a2b108ed7d2f074dc
# bad: [d089e2cb5dffc1160b19a4e48d68cc583cf249ba] [SCSI] wd33c93: convert to scsi proc_ops
git bisect bad d089e2cb5dffc1160b19a4e48d68cc583cf249ba
# bad: [bb6c20445c1bdd1c49ac5e76801211116694e3b9] [SCSI] arm: convert drivers to scsi proc_ops
git bisect bad bb6c20445c1bdd1c49ac5e76801211116694e3b9
