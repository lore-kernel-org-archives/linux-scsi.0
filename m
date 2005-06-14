From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/11]  qla2xxx: Add ISP24xx support.
Date: Mon, 13 Jun 2005 22:31:36 -0700 (PDT)
Message-ID: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:41878 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261172AbVFNFbh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 01:31:37 -0400
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

        ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.01.00b4k/

There are a set of patches present within the scsi-rc-fixes-2.6 tree
which should be carried over to scsi-misc-2.6 before applying:

	[PATCH] qla2xxx: Pull-down scsi-host-addition to follow board initialization.
	http://marc.theaimsgroup.com/?l=linux-scsi&m=111836291000433&q=raw

	Re: [dm-devel] further testing w/ multipath ... and bugs
	http://marc.theaimsgroup.com/?l=linux-scsi&m=111868700022257&q=raw


Regards,
Andrew Vasquez
QLogic Corporation


commit 8f70eac0a59dff15bf39da7af4fe7e5aba274ca5
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Mon Jun 13 15:15:19 2005 -0700

    Firmware updates.
    
    Resync with latest 21xx firmware      -- 1.19.25.
    Resync with latest 22xx firmware      -- 2.02.08.
    Resync with latest 23xx/63xx firmware -- 3.03.15.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit c82a228a4898ce097072deca69e3632824667a5c
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Mon Jun 13 15:05:45 2005 -0700

    Code scrubbing.
    
    Remove trailing whitespace from driver files.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 911d04533e45895584fbaaa85a54ce5710d264f1
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Mon Jun 13 15:04:57 2005 -0700

    NVRAM id-list updates.
    
    Resync with latest NVRAM subsystem ID list.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 4871198c793d20789a89d7cf8ff61b99f259570e
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Mon Jun 13 15:04:25 2005 -0700

    Final glue-code for ISP24xx.
    
    Add appropriate glue-code for ISP24xx support within
    OS and initialization sections of driver.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 6aba66c726c715fced8740684bfd1ba57651d015
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Mon Jun 13 15:04:02 2005 -0700

    ISP24xx ISR routines.
    
    Add appropriate glue-code for ISP24xx support -- this
    included generalizing some of the core handling
    routines (qla2x00_async_event() [pull-up retrieval of
    mailbox values] and qla2x00_status_entry()].  Fixup
    2100/2300 ISRs to handle the new conventions.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit a732ee4e5aba74cc97c0607e0e0a3827d1c3793d
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Mon Jun 13 15:03:48 2005 -0700

    Add ISP24xx IOCB manipulation routines.
    
    Add appropriate glue-code for ISP24xx support while
    manipulting IOCB packets.  Add an ISP24xx specific
    'start_scsi' routine due to command-type-7 layout
    changes.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit a3885ff384e4cdf03203fc9ea42a54763a0b39f8
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Mon Jun 13 15:03:35 2005 -0700

    Add ISP24xx flash-manipulation routines.
    
    Add read/write flash manipulation routines for the ISP24xx.
    Update sysfs NVRAM objects to use generalized accessor
    functions.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit d5f1f079921b48f94606053f246b8d16b39f3f74
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Mon Jun 13 15:03:20 2005 -0700

    Add MBX command routines for ISP24xx support.
    
    Generalize several routines [qla2x00_load_ram_ext(),
    qla2x00_execute_fw(), qla2x00_verify_checksum()] to handle
    larger addressing space.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit b01fb29c828317b98912a32ee51a144789c765ff
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Mon Jun 13 15:02:50 2005 -0700

    Generalize SNS generic-services routines.
    
    Consolidate completion-status checking while adding support
    for the ISP24xx.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 388467c29a156056c5fe5e2bdcd68b22fb876b54
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Mon Jun 13 15:02:37 2005 -0700

    Add ISP24xx diagnostic routines.
    
    Add function and structure definitions for the ISP24xx
    diagnostic firmware dump routines.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit d6adba67d6a4f2fd751e3bb100dec5e0efdb7324
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Mon Jun 13 15:02:18 2005 -0700

    Add ISP24xx definitions.
    
    Add requisite structure definitions and #define's for ISP24xx
    support.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

-- 
Andrew Vasquez
