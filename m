From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/17]  qla2xxx: Add ISP24xx support.
Date: Wed,  6 Jul 2005 10:29:55 -0700 (PDT)
Message-ID: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:8014 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262414AbVGFRaD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2005 13:30:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

James,

What follows is a series of patches (against the latest scsi-misc-2.6
git tree) to add support for a new familiy of 4Gb ISP chips.  The
firmware images to support these new ISPs will reside on the boards
themselves and therefore not require a large firmware-blob be compiled
into the driver.

A summary of the patches can be found towards the end of this message.

With the exception of the rather large firmware image update (direct
pointer to bzip'd patch listed), subsequent messages will contain
inlined patches.

All patches can be found at the following URL:

	ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.01.00b5k/

Hopefully this patch-set addresses the issues voiced against the
earlier 4gb submission.


Regards,
Andrew Vasquez
QLogic Corporation



commit cb2ccfbc4f91e62e69d2f84992a45a557c02230d
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Wed Jul 6 09:25:46 2005 -0700

    Update version number to 8.01.00b5-k.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 900dd480ecb76a28cf910f53d1757264b6911c0b
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Wed Jul 6 09:16:53 2005 -0700

    Correct maximum supported lun and target-id definitions.

    The driver uses command-IOCBs which support a maximum lun
    value of 0xffff -- correct #define to reflect the change.
    Also, remove superfluous MAX_TARGET definition.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit e18ad1fc29d37527f1a6425f7b7122957c4ed5d7
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Wed Jul 6 08:11:05 2005 -0700

    Update copyright banner.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 2e043de4bf0f528bb650e6b6d4011c9edc084639
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Wed Jul 6 08:04:31 2005 -0700

    Firmware updates.

    Resync with latest 21xx firmware      -- 1.19.25.
    Resync with latest 22xx firmware      -- 2.02.08.
    Resync with latest 23xx/63xx firmware -- 3.03.15.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 590ae1880589da532026c35812c9931dd34996c0
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Wed Jul 6 08:02:11 2005 -0700

    Code scrubbing.

     - Remove trailing whitespace from driver files.
     - Remove unused #defines and inlines.
     - Standardize on C comments (// -> /* */)

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 1012645cc42fff24d030366fd5a0c4944def6c8f
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Wed Jul 6 07:42:39 2005 -0700

    NVRAM id-list updates.

    Resync with latest NVRAM subsystem ID list.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 0b1a41ae2af18d81cd1dc9ea8bce669097f5411a
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Wed Jul 6 07:13:54 2005 -0700

    Add OS initialization codes for ISP24xx recognition.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 0fa8d6c80a75c92805ff55eb87287fd53dd239bc
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Wed Jul 6 07:12:14 2005 -0700

    Add ISP24xx initialization routines.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit ba7eb57c9c230482353fded648e9e88bc3d146d3
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Wed Jul 6 07:10:42 2005 -0700

    Add ISP24xx ISR routines.

    Add appropriate glue-code for ISP24xx support -- this
    included generalizing some of the core handling
    routines (qla2x00_async_event() [pull-up retrieval of
    mailbox values] and qla2x00_status_entry()].  Fixup
    2100/2300 ISRs to handle the new conventions.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit ea9b892ded10bf99b1e155426ddce745cb865d1f
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Wed Jul 6 07:10:16 2005 -0700

    Add ISP24xx IOCB manipulation routines.

    Add appropriate glue-code for ISP24xx support while
    manipulting IOCB packets.  Add an ISP24xx specific
    'start_scsi' routine due to command-type-7 layout
    changes.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit a5cc5a472bddbd65222ae021adad6cbfdce259fb
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Wed Jul 6 07:09:23 2005 -0700

    Add ISP24xx flash-manipulation routines.

    Add read/write flash manipulation routines for the ISP24xx.
    Update sysfs NVRAM objects to use generalized accessor
    functions.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit ec7266d75bdacf5afc0f07a2ceacde8ea6a69d1d
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Wed Jul 6 07:08:56 2005 -0700

    Add MBX command routines for ISP24xx support.

    Generalize several routines [qla2x00_load_ram_ext(),
    qla2x00_execute_fw(), qla2x00_verify_checksum()] to handle
    larger addressing space.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit da11a5f4bce50e1db314b57ba5871e6efa538f33
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Wed Jul 6 07:06:53 2005 -0700

    Generalize SNS generic-services routines.

    Consolidate completion-status checking while adding support
    for the ISP24xx.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 0bd26ce5768df74af2a01f14d40bfc3767d3508c
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Tue Jul 5 11:28:37 2005 -0700

    Add ISP24xx diagnostic routines.

    Add function and structure definitions for the ISP24xx
    diagnostic firmware dump routines.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 27bc708984e326687ad90e9defb83e5720818de3
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Tue Jul 5 11:28:17 2005 -0700

    Add ISP24xx definitions.

    Add requisite structure definitions and #define's for ISP24xx
    support.  Also drop volatile modifiers from device_reg_* register
    layouts as the members are never really accessed, only their
    offsets within the layout are used during reads and writes.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit a74cc9d57ef985838b6fb9d07c3983e221d364d5
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Tue Jul 5 11:27:33 2005 -0700

    Add pci ids for new ISP types.

    Move old definitions in local qla_def.h file to pci_ids.h as
    well.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit cbb4eeb0e8f2b44b671834ce8ba67fec8b624cff
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Tue Jul 5 11:27:03 2005 -0700

    Factor-out ISP specific functions to method-based call tables.

    In anticipation of ISP24xx/ISP25xx support, factor-out ISP
    specific functions into a method-based call table.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>



-- 
Andrew Vasquez
