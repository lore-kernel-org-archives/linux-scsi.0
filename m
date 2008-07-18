From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11117] New: aic94xx doesn't sustain the load when more than 2 SAS drives are connected and actively used
Date: Fri, 18 Jul 2008 08:37:42 -0700 (PDT)
Message-ID: <bug-11117-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755101AbYGRPiF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2008 11:38:05 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6IFbhjK012526
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2008 08:37:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11117

           Summary: aic94xx doesn't sustain the load when more than 2 SAS
                    drives are connected and actively used
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.23.1, 2.6.25
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: AIC94XX
        AssignedTo: scsi_drivers-aic94xx@kernel-bugs.osdl.org
        ReportedBy: michael.gleibman@coradiant.com


Latest working kernel version: NA
Earliest failing kernel version: 2.6.23.1
Distribution: Gentoo, customized; vanilla kernels
Hardware Environment: SuperMicro X7DB3 motherboard with integrated AIC 9410
controllers, 4 SAS drives connected 
Software Environment: aic94xx SAS/SATA driver version 1.0.3
Problem Description:

When more than 2 SAS drives are connected and system becomes loaded, aic94xx
logs a lot of messages similar to the following:

aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x6
sas: command 0xffff8101d39733c0, task 0xffff8105e9e51240, timed out:
EH_NOT_HANDLED
sas: command 0xffff8104db3d1e40, task 0xffff8105ed10a6c0, timed out:
EH_NOT_HANDLED
sas: command 0xffff81060f001380, task 0xffff81046fc0e3c0, timed out:
EH_NOT_HANDLED
sas: command 0xffff8102710e6200, task 0xffff810587fb2980, timed out:
EH_NOT_HANDLED
sas: command 0xffff8101df43f0c0, task 0xffff810235fcf9c0, timed out:
EH_NOT_HANDLED
sas: command 0xffff810182974380, task 0xffff810020939b40, timed out:
EH_NOT_HANDLED
sas: command 0xffff810591dd93c0, task 0xffff8105aab7ee00, timed out:
EH_NOT_HANDLED
sas: command 0xffff8104fa24b540, task 0xffff8105e9e51840, timed out:
EH_NOT_HANDLED
sas: command 0xffff8103a400d540, task 0xffff8102c7927e40, timed out:
EH_NOT_HANDLED
sas: command 0xffff8105f8d29cc0, task 0xffff8102c3582980, timed out:
EH_NOT_HANDLED
sas: command 0xffff8105c684c980, task 0xffff8105aebd5240, timed out:
EH_NOT_HANDLED
sas: command 0xffff8104fa24b240, task 0xffff8103140edcc0, timed out:
EH_NOT_HANDLED
sas: command 0xffff81058572cb00, task 0xffff8105aab7e980, timed out:
EH_NOT_HANDLED
sas: command 0xffff8105f08d6500, task 0xffff8100266169c0, timed out:
EH_NOT_HANDLED
sas: command 0xffff810182974500, task 0xffff8103140ed3c0, timed out:
EH_NOT_HANDLED
sas: command 0xffff810302b9a080, task 0xffff8101ca94e800, timed out:
EH_NOT_HANDLED
sas: command 0xffff81058572c080, task 0xffff8105aab7eb00, timed out:
EH_NOT_HANDLED
sas: command 0xffff8105bc7df980, task 0xffff810026616540, timed out:
EH_NOT_HANDLED
sas: Enter sas_scsi_recover_host
sas: trying to find task 0xffff8105e9e51240
sas: sas_scsi_find_task: aborting task 0xffff8105e9e51240
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff8105e9e51240 done with opcode 0x23 resp 0x0 stat 0x8d but
aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: task 0xffff8105ed10a6c0 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff81046fc0e3c0 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff810587fb2980 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff810235fcf9c0 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff810020939b40 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff8105aab7ee00 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff8105e9e51840 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff8102c7927e40 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff8102c3582980 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff8105aebd5240 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff8103140edcc0 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff8105aab7e980 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff8100266169c0 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff8103140ed3c0 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff8101ca94e800 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff8105aab7eb00 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: task 0xffff810026616540 done with opcode 0x0 resp 0x0 stat 0x0 but
aborted by upper layer!
aic94xx: came back from clear nexus
aic94xx: task 0xffff8105e9e51240 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff8105e9e51240 is done
sas: sas_eh_handle_sas_errors: task 0xffff8105e9e51240 is done
sas: trying to find task 0xffff8105ed10a6c0
sas: sas_scsi_find_task: aborting task 0xffff8105ed10a6c0
aic94xx: asd_abort_task: task 0xffff8105ed10a6c0 done
aic94xx: task 0xffff8105ed10a6c0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff8105ed10a6c0 is done
sas: sas_eh_handle_sas_errors: task 0xffff8105ed10a6c0 is done
...
...
EXT2-fs error (device sda9): read_block_bitmap: Cannot read block bitmap -
block_group = 0, block_bitmap = 19
sd 2:0:0:0: rejecting I/O to offline device

It seems to closely resemble the problem earlier reported by Patrick
LeBoutillier: http://lkml.org/lkml/2008/6/25/305

The system would eventually freeze during stress tests.
Here's what I've tried:

- I've tried to spread the drives over 2 ports (2 drives on each port) - same
thing
- Leaving only 2 drives connected, unplugging the other 2 - the system passes
the stress tests well
- Adaptec sequencer firmware versions 1.1 (V32A4, V30) same story
- latest Adaptec bios - same thing
- plugged in an external ASC48300 controller with the same AIC-9410 chip,
connected the drives to it - the same problem as before
- plugged in an external LSI MegaRaid 8208ELP controller to the same system and
connected the same 4 drives to it - system passes all the load tests just fine
- reproduced the same behavior on another similar system, same motherboard,
different drives
- the current workaround, as suggested by Patrick, setting the PHY rate to 1.5
Gbps in Adaptec controller BIOS seems to cure the problem for both onboard and
PCI controllers at cost of some performance degradation; system is able to pass
the stress tests without errors, but the drives are a bit (~10%) slower. 

Steps to reproduce:

Plug 4 SAS drives to a system with aic9410 controller and load kernel 2.6.23.1
or 2.6.25 with aic94xx driver configured; apply some kind of stress test to all
the drives simultaneously (I used a homebrew intensive disk load test utility,
but earlier we used dd if=/dev/sd* of=/dev/null bs=16384 in parallel to create
enough load to reproduce the errors)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
