From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC PATCH 0/19] A kernel-level configfs enabled generic target
 engine for Linux v2.6.32
Date: Sun, 13 Sep 2009 13:10:05 +0300
Message-ID: <4AACC4FD.8050402@panasas.com>
References: <1252720508.2067.196.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:2789 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752452AbZIMKKf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2009 06:10:35 -0400
In-Reply-To: <1252720508.2067.196.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>

On 09/12/2009 04:55 AM, Nicholas A. Bellinger wrote:
> Greetings all,
> 
> This is my humble request for review and inclusion of
> Target_Core_Mod/ConfigFS v3.2 from lio-core-2.6.git code into mainline
> v2.6.32.  With TCM v3.2, the two major SPC-4 SCSI target mode fabric
> features that have now been completed: Persistent Reservation APTPL and
> implict/explict ALUA are the first all optional SPC4 defined feature
> implementation of PR and ALUA in the Linux OSS target theatre using an
> upstream user-driven virtual filesystem directory hierarchy structure
> based on configfs that can be configured in realtime in combination with
> interpreted userspace code.
> 
> Both of these new features are now being used to provide Persistent Reservations
> across target power loss and asymmetric multipath I/O to both Linux and non-Linux
> clients.  There is also an optional ALUA transition delay logic that has been
> included to futher debug and improve existing upstream client side Linux kernel code
> using TCM v3.2. These patches have been diffed against v2.6.31, and tested on x86
> 32-bit HVM, x86_64 KVM, and powerpc.
> 
> There is cleanup work continuing to make the TCM code to use dprintk(),
> and some include cleanups, and other minor fixes.  The code has also
> been run through checkpatch again since the posting in April, and all
> errors have been removed, with the exception of one ConfigFS macro
> define triggering a checkpatch false positive.
> 
> As with the posting of the TCM v3.0 code earlier in April, I have
> decided to break up the submissions into the generic target_core_mod
> piece (this patch series) and then a seperate one that will be appearing
> in the next days for v3.2 of the LIO-Target iSCSI fabric module.
> 
> More Information about Target_Core_Mod/ConfigFS, and PR and ALUA:
> 
> http://www.linux-iscsi.org/index.php/Target_Core_Mod/ConfigFS
> http://www.linux-iscsi.org/index.php/Persistent_Reservations
> http://www.linux-iscsi.org/index.php/ALUA
> 
> The complete v3.x TCM CLI operations set can be found here:
> 
> http://www.linux-iscsi.org/index.php/Lio-utils#v3.1_TCM_CLI_operations
> 
> Instructions and examples for getting setup:
> 
> http://linux-iscsi.org/builds/docs/LIO-3.0-Users_Reference_Manual.pdf
> http://www.linux-iscsi.org/index.php/Howto#Start_target_core_mod
> 
> Constructive comments are welcome,
> 
> --nab
> 
> ==> target_core_alua.patch <==
> [RFC PATCH 1/19] Target_Core_Mod Asymmetric Logical Unit Assignment (ALUA) support
> ==> target_core_configfs.patch <==
> [RFC PATCH 2/19] Target_Core_Mod ConfigFS infrastructure
> ==> target_core_device.patch <==
> [RFC PATCH 3/19] Target_Core_Mod device core infrastructure
> ==> target_core_file.patch <==
> [RFC PATCH 4/19] Target_Core_Mod FILEIO <-> Linux/VFS subsystem
> ==> target_core_hba.patch <==
> [RFC PATCH 5/19] Target_Core_Mod HBA core infrastructure
> ==> target_core_iblock.patch <==
> [RFC PATCH 6/19] Target_Core_Mod IBLOCK <-> Linux/Block subsystem plugin
> ==> target_core_mib.patch <==
> [RFC PATCH 7/19] Target_Core_Mod SCSI MIBs
> ==> target_core_plugin.patch <==
> [RFC PATCH 8/19] Target_Core_Mod Subsystem and SE Object plugin infrastructure
> ==> target_core_pr.patch <==
> [RFC PATCH 9/19] Target_Core_Mod SPC-4 Persistent Reservations
> ==> target_core_pscsi.patch <==
> [RFC PATCH 10/19] Target_Core_Mod PSCSI <-> Linux/SCSI subsystem plugin
> ==> target_core_rd.patch <==
> [RFC PATCH 11/19] Target_Core_Mod RAMDISK_DR and RAMDISK_MCP subsystem plugin
> ==> target_core_scdb.patch <==
> [RFC PATCH 12/19] Target_Core_Mod READ/WRITE command descriptor block generation code
> ==> target_core_seobj.patch <==
> [RFC PATCH 13/19] Target_Core_Mod Storage Engine Object infrastructure
> ==> target_core_tmr.patch <==
> [RFC PATCH 14/19] Target_Core_Mod Task Management infrastructure
> ==> target_core_tpg.patch <==
> [RFC PATCH 15/19] Target_Core_Mod portal group endpoint infrastructure
> ==> target_core_transport.patch <==
> [RFC PATCH 16/19] Target_Core_Mod Generic Transport Core
> ==> target_core_ua.patch <==
> [RFC PATCH 17/19] Target_Core_Mod Unit Attention emulation support
> ==> target_core_base_includes.patch <==
> [RFC PATCH 18/19] Target_Core_Mod base and fabric_module includes
> ==> target_core_misc.patch <==
> [RFC PATCH 19/19] Target_Core_Mod Makefile/Kconfig and div64.c
> 

I would like to see a documentation patch which adds a file under Documentation/
With some abstraction, design, usability, URLs

I promise to read it ;-)

I'm sure you have lots of stuff written laying around. Could you edit them up for
Linux?

Boaz
