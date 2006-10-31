From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] 0/3: Fix EH problems in libsas and implement more error
 handling
Date: Tue, 31 Oct 2006 10:10:45 -0800
Message-ID: <454791A5.9000202@us.ibm.com>
References: <45468845.20400@us.ibm.com> <20061031105452.GD28239@rhun.haifa.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1423740AbWJaSLI@vger.kernel.org>
In-Reply-To: <20061031105452.GD28239@rhun.haifa.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Muli Ben-Yehuda wrote:

> I'm still seeing this on my x366 with the V17 sequencer firmware (with
> the old Razor sequencer it happens as well, but rarely).
> 
> aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x6
> aic94xx: tmf tasklet complete
> aic94xx: tmf resp tasklet
> aic94xx: tmf came back
> aic94xx: task not done, clearing nexus
> aic94xx: asd_clear_nexus_tag: PRE
> aic94xx: asd_clear_nexus_tag: POST
> aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
> aic94xx: task 0xffff81015ee59580 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
> aic94xx: asd_clear_nexus_tasklet_complete: here
> aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
> aic94xx: came back from clear nexus
> aic94xx: task 0xffff81015ee59580 aborted, res: 0x0
> sas: command 0xffff8100e2afcb00, task 0xffff81015ee59580, aborted by initiator: EH_NOT_HANDLED
> sas: Enter sas_scsi_recover_host
> sas: going over list...
> sas: trying to find task 0xffff81015ee59580
> sas: sas_scsi_find_task: task 0xffff81015ee59580 already aborted
> sas: sas_scsi_recover_host: task 0xffff81015ee59580 is aborted
> sas: --- Exit sas_scsi_recover_host

Yes, the patch doesn't eliminate these errors; it merely does something
more intelligent with the error code than "Sit around and wait for
everything to time out"... despite the scary error messages, it looks
like it's doing the right thing.  However, it'd be useful to have
timestamps on the printks to know for sure.

> aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x5

Break recv'd... that's a new one.

> sas: DOING DISCOVERY on port 0, pid:1105
> scsi 0:0:0:0: Direct-Access     IBM-ESXS ST936701SS    F  B512 PQ: 0 ANSI: 4

Hrm, you might want to update your disks to the latest firmware levels
(B51C)... be wary that the firmware updates occasionally nuke everything
on the drive. :(

--D
