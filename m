From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: aic94xx: failing under heavy load
Date: Wed, 9 Jul 2008 17:52:19 -0700
Message-ID: <20080709175219.287a3282.akpm@linux-foundation.org>
References: <b217a64f0806251044v53ea1765qa6a8f31371f42018@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbYGJBDV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2008 21:03:21 -0400
In-Reply-To: <b217a64f0806251044v53ea1765qa6a8f31371f42018@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick LeBoutillier <patrick.leboutillier@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi@vger.kernel.org

(cc's added)

On Wed, 25 Jun 2008 13:44:33 -0400 "Patrick LeBoutillier" <patrick.leboutillier@gmail.com> wrote:

> Hi,
> 
> I'm using the aic94xx driver with a AIC-9410W controller (w/6 Seagate
> Cheetah SAS drives) and am getting the following errors under heavy
> load:
> 
> kernel: aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x10
> kernel: sas: command 0xffff81083c893700, task 0xffff81083c4459c0,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff8108381b8580, task 0xffff81083d054200,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff81083e64c080, task 0xffff81083c42a240,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff81083c4f5e40, task 0xffff810836417540,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff8108381b8bc0, task 0xffff81083d054980,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff8108381b8d00, task 0xffff81083c42a840,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff81083c4f5580, task 0xffff81083d054500,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff8108381b8800, task 0xffff810838808080,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff8108381b8a80, task 0xffff81083d054e00,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff81083c893200, task 0xffff810838808c80,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff81083c4d16c0, task 0xffff81083d054680,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff81083c70d5c0, task 0xffff8108376d3b40,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff81083c4d1580, task 0xffff81083c42a9c0,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff81083e64c940, task 0xffff8108376d3cc0,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff81083c8830c0, task 0xffff810836424e00,
> timed out: EH_NOT_HANDLED
> kernel: sas: command 0xffff81083c4d1e40, task 0xffff8108364170c0,
> timed out: EH_NOT_HANDLED
> kernel: sas: Enter sas_scsi_recover_host
> kernel: sas: trying to find task 0xffff81083c4459c0
> kernel: sas: sas_scsi_find_task: aborting task 0xffff81083c4459c0
> kernel: aic94xx: tmf tasklet complete
> kernel: aic94xx: tmf resp tasklet
> kernel: aic94xx: tmf came back
> kernel: aic94xx: task not done, clearing nexus
> kernel: aic94xx: asd_clear_nexus_tag: PRE
> kernel: aic94xx: asd_clear_nexus_tag: POST
> kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
> kernel: aic94xx: task 0xffff81083c4459c0 done with opcode 0x23 resp
> 0x0 stat 0x8d but aborted by upper layer!
> kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
> kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
> kernel: aic94xx: task 0xffff81083d054200 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: task 0xffff81083c42a240 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: task 0xffff810836417540 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: task 0xffff81083d054980 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: task 0xffff81083c42a840 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: task 0xffff81083d054500 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: task 0xffff810838808080 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: task 0xffff81083d054e00 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: task 0xffff810838808c80 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: task 0xffff81083d054680 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: task 0xffff8108376d3b40 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: task 0xffff81083c42a9c0 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: task 0xffff8108376d3cc0 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: task 0xffff810836424e00 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: task 0xffff8108364170c0 done with opcode 0x0 resp 0x0
> stat 0x0 but aborted by upper layer!
> kernel: aic94xx: came back from clear nexus
> kernel: aic94xx: task 0xffff81083c4459c0 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff81083c4459c0 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083c4459c0 is done
> kernel: sas: trying to find task 0xffff81083d054200
> kernel: sas: sas_scsi_find_task: aborting task 0xffff81083d054200
> kernel: aic94xx: asd_abort_task: task 0xffff81083d054200 done
> kernel: aic94xx: task 0xffff81083d054200 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff81083d054200 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083d054200 is done
> kernel: sas: trying to find task 0xffff81083c42a240
> kernel: sas: sas_scsi_find_task: aborting task 0xffff81083c42a240
> kernel: aic94xx: asd_abort_task: task 0xffff81083c42a240 done
> kernel: aic94xx: task 0xffff81083c42a240 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff81083c42a240 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083c42a240 is done
> kernel: sas: trying to find task 0xffff810836417540
> kernel: sas: sas_scsi_find_task: aborting task 0xffff810836417540
> kernel: aic94xx: asd_abort_task: task 0xffff810836417540 done
> kernel: aic94xx: task 0xffff810836417540 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff810836417540 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff810836417540 is done
> kernel: sas: trying to find task 0xffff81083d054980
> kernel: sas: sas_scsi_find_task: aborting task 0xffff81083d054980
> kernel: aic94xx: asd_abort_task: task 0xffff81083d054980 done
> kernel: aic94xx: task 0xffff81083d054980 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff81083d054980 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083d054980 is done
> kernel: sas: trying to find task 0xffff81083c42a840
> kernel: sas: sas_scsi_find_task: aborting task 0xffff81083c42a840
> kernel: aic94xx: asd_abort_task: task 0xffff81083c42a840 done
> kernel: aic94xx: task 0xffff81083c42a840 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff81083c42a840 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083c42a840 is done
> kernel: sas: trying to find task 0xffff81083d054500
> kernel: sas: sas_scsi_find_task: aborting task 0xffff81083d054500
> kernel: aic94xx: asd_abort_task: task 0xffff81083d054500 done
> kernel: aic94xx: task 0xffff81083d054500 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff81083d054500 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083d054500 is done
> kernel: sas: trying to find task 0xffff810838808080
> kernel: sas: sas_scsi_find_task: aborting task 0xffff810838808080
> kernel: aic94xx: asd_abort_task: task 0xffff810838808080 done
> kernel: aic94xx: task 0xffff810838808080 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff810838808080 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff810838808080 is done
> kernel: sas: trying to find task 0xffff81083d054e00
> kernel: sas: sas_scsi_find_task: aborting task 0xffff81083d054e00
> kernel: aic94xx: asd_abort_task: task 0xffff81083d054e00 done
> kernel: aic94xx: task 0xffff81083d054e00 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff81083d054e00 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083d054e00 is done
> kernel: sas: trying to find task 0xffff810838808c80
> kernel: sas: sas_scsi_find_task: aborting task 0xffff810838808c80
> kernel: aic94xx: asd_abort_task: task 0xffff810838808c80 done
> kernel: aic94xx: task 0xffff810838808c80 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff810838808c80 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff810838808c80 is done
> kernel: sas: trying to find task 0xffff81083d054680
> kernel: sas: sas_scsi_find_task: aborting task 0xffff81083d054680
> kernel: aic94xx: asd_abort_task: task 0xffff81083d054680 done
> kernel: aic94xx: task 0xffff81083d054680 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff81083d054680 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083d054680 is done
> kernel: sas: trying to find task 0xffff8108376d3b40
> kernel: sas: sas_scsi_find_task: aborting task 0xffff8108376d3b40
> kernel: aic94xx: asd_abort_task: task 0xffff8108376d3b40 done
> kernel: aic94xx: task 0xffff8108376d3b40 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff8108376d3b40 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff8108376d3b40 is done
> kernel: sas: trying to find task 0xffff81083c42a9c0
> kernel: sas: sas_scsi_find_task: aborting task 0xffff81083c42a9c0
> kernel: aic94xx: asd_abort_task: task 0xffff81083c42a9c0 done
> kernel: aic94xx: task 0xffff81083c42a9c0 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff81083c42a9c0 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083c42a9c0 is done
> kernel: sas: trying to find task 0xffff8108376d3cc0
> kernel: sas: sas_scsi_find_task: aborting task 0xffff8108376d3cc0
> kernel: aic94xx: asd_abort_task: task 0xffff8108376d3cc0 done
> kernel: aic94xx: task 0xffff8108376d3cc0 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff8108376d3cc0 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff8108376d3cc0 is done
> kernel: sas: trying to find task 0xffff810836424e00
> kernel: sas: sas_scsi_find_task: aborting task 0xffff810836424e00
> kernel: aic94xx: asd_abort_task: task 0xffff810836424e00 done
> kernel: aic94xx: task 0xffff810836424e00 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff810836424e00 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff810836424e00 is done
> kernel: sas: trying to find task 0xffff8108364170c0
> kernel: sas: sas_scsi_find_task: aborting task 0xffff8108364170c0
> kernel: aic94xx: asd_abort_task: task 0xffff8108364170c0 done
> kernel: aic94xx: task 0xffff8108364170c0 aborted, res: 0x0
> kernel: sas: sas_scsi_find_task: task 0xffff8108364170c0 is done
> kernel: sas: sas_eh_handle_sas_errors: task 0xffff8108364170c0 is done
> kernel: sas: --- Exit sas_scsi_recover_host
> 
> 
> I am running kernel 2.6.25.8.
> Controller firmware (/lib/firmware/aic94xx-seq.fw) is V30.
> 
> I have seen a few threads in the mailing list regarding similar errors
> but none seem to lead to any kind of solution.
> 
> Does anyone have any leads I can follow? I'll be happy to try out
> patches if anybody has anything.
> 
> 
> Thanks a lot,
> 
> Patrick

