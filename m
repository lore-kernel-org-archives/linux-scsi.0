From: Jonathan Nieder <jrnieder@gmail.com>
Subject: megaraid_sas: which patches are needed for 2.6.32.y?
Date: Sun, 24 Jun 2012 10:13:18 -0500
Message-ID: <20120624151318.GA18451@burratino>
References: <FB09F9AF3FE25444B277AA82BB35EE175F0260C0@LCHQEX03.lancope.local>
 <20120328192623.GB8982@burratino>
 <FB09F9AF3FE25444B277AA82BB35EE175F02612C@LCHQEX03.lancope.local>
 <FB09F9AF3FE25444B277AA82BB35EE175F028482@LCHQEX03.lancope.local>
 <20120329165806.GC3147@burratino>
 <FB09F9AF3FE25444B277AA82BB35EE175F0284E2@LCHQEX03.lancope.local>
 <20120329194751.GG3147@burratino>
 <20120609164753.GA18761@burratino>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41648 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2FXPN1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jun 2012 11:13:27 -0400
Received: by obbuo13 with SMTP id uo13so5053708obb.19
        for <linux-scsi@vger.kernel.org>; Sun, 24 Jun 2012 08:13:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120609164753.GA18761@burratino>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: Buford Peek <BPeek@lancope.com>, 666108@bugs.debian.org, Gator_Yin@Dell.com, linux-scsi@vger.kernel.org

Hi again,

Jonathan Nieder wrote[0]:

> I am working on improving support for newer megaraid controllers in
> Debian squeeze's 2.6.32.y-based kernel.
>
> On top of what's in 2.6.32.y, Debian squeeze currently has the
> following patches applied:
[
 list at [1] below
]
> When Buford Peek needed support for a Dell PERC H710P I provided him
> with the following as a quick set of patches to test:
[
 list at [2]
]
> The result seemed to work ok. :)  But it left out at least one
> important fix:
>
>   f575c5d3ebdc Fix instance access in megasas_reset_timer
>
> It also is not particularly minimal.
>
> After applying all of the above, the following commits still remain
> unapplied:
[
 list at [3]
]
> Questions:
>
> 1) Are any of these important fixes that should be applied to 2.6.32.y
>    so everyone who uses a 2.6.32-based kernel can start benefitting
>    from them?

No reply.  Is this the right address to reach the megaraid_sas
maintainers?  Would you be interested in making sure the
2.6.32.y-based kernels used by various Linux distributors have
up-to-date hardware support and fixes?  What can I do to help make
that happen?

Thanks,
Jonathan

[0] http://bugs.debian.org/666108
[1] Patches on top of 2.6.32.y used to add support for the 9240 family
and similar devices:

>   c35188377f12 Add poll mechanism to megaraid sas driver
>   72c4fd36dc7f add sysfs for AEN polling
>   879111224d07 Add new megaraid SAS 2 controller support to the driver
>   7bebf5c79cb6 allocate the application cmds to sas2 controller
>   0c79e681eef1 Fix the fix for fw hang caused by megaraid sas application

[2] Patches used to add Dell PERC H710P support:

>   81e403ce3c6a infrastructure to get PDs from FW
>   7e8a75f4dfbf Add the support for updating the OS after adding/removing
>                the devices from FW
>   bdc6fb8d69fa add the logical drive list to driver
>   c978684254d1 driver fixed the device update issue
>   f4c9a1317d32 add the IEEE SGE support to SAS2 controller
>   39a985547cbf Add Online Controller Reset to MegaRAID SAS drive
>   0d49016bbab4 Rename megaraid_sas.c to megaraid_sas_base.c
>   80d9da98b403 Add MSI-X support and msix_disable module parameter
>   aeab3fd7b865 make driver PCI legacy I/O port free driver
>   b6d5d8808b4c Use lowest memory bar for SR-IOV VF support
>   cd50ba8ede5c Add struct megasas_instance_template changes
>   9c915a8c99bc Add 9565/9285 specific code

[3] Patches in 3.0.y absent from the above two lists:

>   8d5682532133 tape drive support fix
>   044833b572b9 report system PDs to OS
>   7218df69e360 use the firmware boot timeout when waiting for commands
>   a0b7736828f7 Update version number and documentation
>   780a3762fb92 Zero pad_0 in mfi structure
>   63bad45db1d4 version and documentation update
>   837f5fe89c84 support devices update flag
>   1fd106851698 Add input parameter for max_sectors
>   707e09bd867c Add three times Online controller reset
>   e340c3537239 Version and documentation update
>   3f1530c1e1f7 Update GPL headers.
>   eb1b12377376 Fix failure gotos
>   53ef2bbd2068 Add missing check_and_restore_queue_depth call
>   0a77066acc78 Enable MSI-X before calling megasas_init_fw
>   e1419191d8d3 Call tasklet_schedule for MSI-X
>   66192dfe1e74 Fix probe_one to clear MSI-X flags in kdump
>   f51244058963 Fix megasas_build_dcdb_fusion to not filter by TYPE_DISK
>   eaa3c240de25 Fix megasas_build_dcdb_fusion to use correct LUN field
>   4c598b23807a Add CFG_CLEARED AEN
>   f86c5424b027 Fix tasklet_init call
>   1ac515ef3f2f Fix fault state handling
>   42a8d2b34d10 Fix max_sectors for IEEE SGL
>   ebf054b00b0a Fix iMR OCR support to work correctly
>   00fa2b191b4b Version and Changelog update
>   3f1abce4aba4 Remove MSI-X black list, use MFI_REG_STATE instead
>   70d031f36fa5 Remove un-used function
>   7e70e7336515 Check MFI_REG_STATE.fault.resetAdapter
>   46fd256e0558 Disable interrupts/free_irq() in megasas_shutdown()
>   541f90b7c6df Fix bug where AENs could be lost in probe() and resume()
>   495c5609700e Convert 6,10,12 byte CDB's for FastPath IO
>   3cc6851f9a35 Add 1078 OCR support
>   4f788dce0baf Version and Changelog update
