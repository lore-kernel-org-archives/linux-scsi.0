From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] BusLogic: add error handling, fix queuecommand, docs.
Date: Wed, 1 Oct 2003 17:37:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031001173750.68a2c6a5.rddunlap@osdl.org>
References: <20031001122316.6f33af9b.rddunlap@osdl.org>
	<20031001214818.GB1045@beaverton.ibm.com>
	<20031001144324.60097c36.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:11725 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262648AbTJBAqD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2003 20:46:03 -0400
In-Reply-To: <20031001144324.60097c36.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: andmike@us.ibm.com
Cc: linux-scsi@vger.kernel.org

On Wed, 1 Oct 2003 14:43:24 -0700 "Randy.Dunlap" <rddunlap@osdl.org> wrote:

| On Wed, 1 Oct 2003 14:48:18 -0700 Mike Anderson <andmike@us.ibm.com> wrote:
| 
| | If the functions are just going to return FAILED you may want to
| | consider leaving them out. Having these functions return fail will cause
| | the output to be noisy. Either with this noisy output or not the
| | recovery will end up at BusLogic_host_reset.
| 
| Yes, I noticed that (later).  I'll be glad to remove them.
| 
| This was the result of cut-and-paste from another driver.

Here's the updated patch...

More comments?

--
~Randy


patch_name:	buslogic_ehupdate_t6b.patch
patch_version:	2003-10-01.17:48:36
author:		Randy.Dunlap <rddunlap@osdl.org>
description:	update BusLogic driver to use current SCSI
		  error handling model;
		modify queuecommand to return 0 or 1 depending for
		  success or failure respectively;
		remove duplicate doc comments -- use
		  Documentation/scsi/BusLogic.txt only;
product:	Linux
product_versions: 2.6.0-test6
diffstat:	=
 Documentation/scsi/BusLogic.txt |    2
 drivers/scsi/BusLogic.c         |  232 ++--------------------------------------
 2 files changed, 18 insertions(+), 216 deletions(-)


diff -Naurp ./drivers/scsi/BusLogic.c~ehupdate ./drivers/scsi/BusLogic.c
--- ./drivers/scsi/BusLogic.c~ehupdate	2003-09-27 17:51:04.000000000 -0700
+++ ./drivers/scsi/BusLogic.c	2003-10-01 17:47:16.000000000 -0700
@@ -3462,6 +3462,18 @@ static boolean BusLogic_WriteOutgoingMai
   return false;
 }
 
+/* Error Handling (EH) support */
+
+static int BusLogic_host_reset(Scsi_Cmnd *SCpnt)
+{
+	BusLogic_HostAdapter_T *HostAdapter =
+		(BusLogic_HostAdapter_T *) SCpnt->device->host->hostdata;
+
+	/* printk("BusLogic_host_reset\n"); */
+	HostAdapter->HostAdapterExternalReset = 1;
+	BusLogic_ResetHostAdapter(HostAdapter, NULL, 0);
+	return SUCCESS;
+}
 
 /*
   BusLogic_QueueCommand creates a CCB for Command and places it into an
@@ -3513,7 +3525,7 @@ int BusLogic_QueueCommand(SCSI_Command_T
 	{
 	  Command->result = DID_ERROR << 16;
 	  CompletionRoutine(Command);
-	  return 0;
+	  return 1;
 	}
     }
   /*
@@ -3679,6 +3691,7 @@ int BusLogic_QueueCommand(SCSI_Command_T
 	      BusLogic_DeallocateCCB(CCB);
 	      Command->result = DID_ERROR << 16;
 	      Command->scsi_done(Command);
+	      return 1;
 	    }
 	}
     }
@@ -4589,220 +4602,8 @@ static boolean BusLogic_ParseKeyword(cha
   adapters whereas the remaining options apply individually only to the
   selected host adapter.
 
-  The BusLogic Driver Probing Options comprise the following:
-
-  IO:<integer>
-
-    The "IO:" option specifies an ISA I/O Address to be probed for a non-PCI
-    MultiMaster Host Adapter.  If neither "IO:" nor "NoProbeISA" options are
-    specified, then the standard list of BusLogic MultiMaster ISA I/O Addresses
-    will be probed (0x330, 0x334, 0x230, 0x234, 0x130, and 0x134).  Multiple
-    "IO:" options may be specified to precisely determine the I/O Addresses to
-    be probed, but the probe order will always follow the standard list.
-
-  NoProbe
-
-    The "NoProbe" option disables all probing and therefore no BusLogic Host
-    Adapters will be detected.
-
-  NoProbeISA
-
-    The "NoProbeISA" option disables probing of the standard BusLogic ISA I/O
-    Addresses and therefore only PCI MultiMaster and FlashPoint Host Adapters
-    will be detected.
-
-  NoProbePCI
-
-    The "NoProbePCI" options disables the interrogation of PCI Configuration
-    Space and therefore only ISA Multimaster Host Adapters will be detected, as
-    well as PCI Multimaster Host Adapters that have their ISA Compatible I/O
-    Port set to "Primary" or "Alternate".
-
-  NoSortPCI
-
-    The "NoSortPCI" option forces PCI MultiMaster Host Adapters to be
-    enumerated in the order provided by the PCI BIOS, ignoring any setting of
-    the AutoSCSI "Use Bus And Device # For PCI Scanning Seq." option.
-
-  MultiMasterFirst
-
-    The "MultiMasterFirst" option forces MultiMaster Host Adapters to be probed
-    before FlashPoint Host Adapters.  By default, if both FlashPoint and PCI
-    MultiMaster Host Adapters are present, this driver will probe for
-    FlashPoint Host Adapters first unless the BIOS primary disk is controlled
-    by the first PCI MultiMaster Host Adapter, in which case MultiMaster Host
-    Adapters will be probed first.
-
-  FlashPointFirst
-
-    The "FlashPointFirst" option forces FlashPoint Host Adapters to be probed
-    before MultiMaster Host Adapters.
-
-  The BusLogic Driver Tagged Queuing Options allow for explicitly specifying
-  the Queue Depth and whether Tagged Queuing is permitted for each Target
-  Device (assuming that the Target Device supports Tagged Queuing).  The Queue
-  Depth is the number of SCSI Commands that are allowed to be concurrently
-  presented for execution (either to the Host Adapter or Target Device).  Note
-  that explicitly enabling Tagged Queuing may lead to problems; the option to
-  enable or disable Tagged Queuing is provided primarily to allow disabling
-  Tagged Queuing on Target Devices that do not implement it correctly.  The
-  following options are available:
-
-  QueueDepth:<integer>
-
-    The "QueueDepth:" or QD:" option specifies the Queue Depth to use for all
-    Target Devices that support Tagged Queuing, as well as the maximum Queue
-    Depth for devices that do not support Tagged Queuing.  If no Queue Depth
-    option is provided, the Queue Depth will be determined automatically based
-    on the Host Adapter's Total Queue Depth and the number, type, speed, and
-    capabilities of the detected Target Devices.  For Host Adapters that
-    require ISA Bounce Buffers, the Queue Depth is automatically set by default
-    to BusLogic_TaggedQueueDepthBB or BusLogic_UntaggedQueueDepthBB to avoid
-    excessive preallocation of DMA Bounce Buffer memory.  Target Devices that
-    do not support Tagged Queuing always have their Queue Depth set to
-    BusLogic_UntaggedQueueDepth or BusLogic_UntaggedQueueDepthBB, unless a
-    lower Queue Depth option is provided.  A Queue Depth of 1 automatically
-    disables Tagged Queuing.
-
-  QueueDepth:[<integer>,<integer>...]
-
-    The "QueueDepth:[...]" or "QD:[...]" option specifies the Queue Depth
-    individually for each Target Device.  If an <integer> is omitted, the
-    associated Target Device will have its Queue Depth selected automatically.
-
-  TaggedQueuing:Default
-
-    The "TaggedQueuing:Default" or "TQ:Default" option permits Tagged Queuing
-    based on the firmware version of the BusLogic Host Adapter and based on
-    whether the Queue Depth allows queuing multiple commands.
-
-  TaggedQueuing:Enable
-
-    The "TaggedQueuing:Enable" or "TQ:Enable" option enables Tagged Queuing for
-    all Target Devices on this Host Adapter, overriding any limitation that
-    would otherwise be imposed based on the Host Adapter firmware version.
-
-  TaggedQueuing:Disable
-
-    The "TaggedQueuing:Disable" or "TQ:Disable" option disables Tagged Queuing
-    for all Target Devices on this Host Adapter.
-
-  TaggedQueuing:<Target-Spec>
-
-    The "TaggedQueuing:<Target-Spec>" or "TQ:<Target-Spec>" option controls
-    Tagged Queuing individually for each Target Device.  <Target-Spec> is a
-    sequence of "Y", "N", and "X" characters.  "Y" enables Tagged Queuing, "N"
-    disables Tagged Queuing, and "X" accepts the default based on the firmware
-    version.  The first character refers to Target Device 0, the second to
-    Target Device 1, and so on; if the sequence of "Y", "N", and "X" characters
-    does not cover all the Target Devices, unspecified characters are assumed
-    to be "X".
-
-  The BusLogic Driver Error Recovery Option allows for explicitly specifying
-  the Error Recovery action to be performed when BusLogic_ResetCommand is
-  called due to a SCSI Command failing to complete successfully.  The following
-  options are available:
-
-  ErrorRecovery:Default
-
-    The "ErrorRecovery:Default" or "ER:Default" option selects between the Hard
-    Reset and Bus Device Reset options based on the recommendation of the SCSI
-    Subsystem.
-
-  ErrorRecovery:HardReset
-
-    The "ErrorRecovery:HardReset" or "ER:HardReset" option will initiate a Host
-    Adapter Hard Reset which also causes a SCSI Bus Reset.
-
-  ErrorRecovery:BusDeviceReset
-
-    The "ErrorRecovery:BusDeviceReset" or "ER:BusDeviceReset" option will send
-    a Bus Device Reset message to the individual Target Device causing the
-    error.  If Error Recovery is again initiated for this Target Device and no
-    SCSI Command to this Target Device has completed successfully since the Bus
-    Device Reset message was sent, then a Hard Reset will be attempted.
-
-  ErrorRecovery:None
-
-    The "ErrorRecovery:None" or "ER:None" option suppresses Error Recovery.
-    This option should only be selected if a SCSI Bus Reset or Bus Device Reset
-    will cause the Target Device or a critical operation to suffer a complete
-    and unrecoverable failure.
-
-  ErrorRecovery:<Target-Spec>
-
-    The "ErrorRecovery:<Target-Spec>" or "ER:<Target-Spec>" option controls
-    Error Recovery individually for each Target Device.  <Target-Spec> is a
-    sequence of "D", "H", "B", and "N" characters.  "D" selects Default, "H"
-    selects Hard Reset, "B" selects Bus Device Reset, and "N" selects None.
-    The first character refers to Target Device 0, the second to Target Device
-    1, and so on; if the sequence of "D", "H", "B", and "N" characters does not
-    cover all the possible Target Devices, unspecified characters are assumed
-    to be "D".
-
-  The BusLogic Driver Miscellaneous Options comprise the following:
-
-  BusSettleTime:<seconds>
-
-    The "BusSettleTime:" or "BST:" option specifies the Bus Settle Time in
-    seconds.  The Bus Settle Time is the amount of time to wait between a Host
-    Adapter Hard Reset which initiates a SCSI Bus Reset and issuing any SCSI
-    Commands.  If unspecified, it defaults to BusLogic_DefaultBusSettleTime.
-
-  InhibitTargetInquiry
-
-    The "InhibitTargetInquiry" option inhibits the execution of an Inquire
-    Target Devices or Inquire Installed Devices command on MultiMaster Host
-    Adapters.  This may be necessary with some older Target Devices that do not
-    respond correctly when Logical Units above 0 are addressed.
-
-  The BusLogic Driver Debugging Options comprise the following:
-
-  TraceProbe
-
-    The "TraceProbe" option enables tracing of Host Adapter Probing.
-
-  TraceHardwareReset
-
-    The "TraceHardwareReset" option enables tracing of Host Adapter Hardware
-    Reset.
-
-  TraceConfiguration
-
-    The "TraceConfiguration" option enables tracing of Host Adapter
-    Configuration.
-
-  TraceErrors
-
-    The "TraceErrors" option enables tracing of SCSI Commands that return an
-    error from the Target Device.  The CDB and Sense Data will be printed for
-    each SCSI Command that fails.
-
-  Debug
-
-    The "Debug" option enables all debugging options.
-
-  The following examples demonstrate setting the Queue Depth for Target Devices
-  1 and 2 on the first host adapter to 7 and 15, the Queue Depth for all Target
-  Devices on the second host adapter to 31, and the Bus Settle Time on the
-  second host adapter to 30 seconds.
-
-  Linux Kernel Command Line:
-
-    linux BusLogic=QueueDepth:[,7,15];QueueDepth:31,BusSettleTime:30
-
-  LILO Linux Boot Loader (in /etc/lilo.conf):
-
-    append = "BusLogic=QueueDepth:[,7,15];QueueDepth:31,BusSettleTime:30"
-
-  INSMOD Loadable Kernel Module Installation Facility:
-
-    insmod BusLogic.o \
-	'BusLogic="QueueDepth:[,7,15];QueueDepth:31,BusSettleTime:30"'
-
-  NOTE: Module Utilities 2.1.71 or later is required for correct parsing
-	of driver options containing commas.
-
+  The BusLogic Driver Probing Options are described in
+  <file:Documentation/scsi/BusLogic.txt>.
 */
 
 static int __init BusLogic_ParseDriverOptions(char *OptionsString)
@@ -5126,6 +4927,7 @@ static SCSI_Host_Template_T driver_templ
 	.queuecommand		= BusLogic_QueueCommand,
 	.slave_configure	= BusLogic_SlaveConfigure,
 	.bios_param		= BusLogic_BIOSDiskParameters,
+	.eh_host_reset_handler	= BusLogic_host_reset,
 	.unchecked_isa_dma	= 1,
 	.max_sectors		= 128,
 	.use_clustering		= ENABLE_CLUSTERING,
diff -Naurp ./drivers/scsi/BusLogic.h~ehupdate ./drivers/scsi/BusLogic.h
diff -Naurp ./Documentation/scsi/BusLogic.txt~ehupdate ./Documentation/scsi/BusLogic.txt
--- ./Documentation/scsi/BusLogic.txt~ehupdate	2003-09-27 17:50:15.000000000 -0700
+++ ./Documentation/scsi/BusLogic.txt	2003-10-01 12:15:33.000000000 -0700
@@ -577,7 +577,7 @@ LILO Linux Boot Loader (in /etc/lilo.con
 INSMOD Loadable Kernel Module Installation Facility:
 
   insmod BusLogic.o \
-      'BusLogic_Options="QueueDepth:[,7,15];QueueDepth:31,BusSettleTime:30"'
+      'BusLogic="QueueDepth:[,7,15];QueueDepth:31,BusSettleTime:30"'
 
 NOTE: Module Utilities 2.1.71 or later is required for correct parsing
       of driver options containing commas.
