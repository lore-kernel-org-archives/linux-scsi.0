From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] 0/3: Fix EH problems in libsas and implement more error handling
Date: Tue, 31 Oct 2006 13:02:21 -0800 (PST)
Message-ID: <684926.92247.qm@web31807.mail.mud.yahoo.com>
References: <454791A5.9000202@us.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:47502 "HELO
	web31807.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1945977AbWJaVCX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Oct 2006 16:02:23 -0500
In-Reply-To: <454791A5.9000202@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

--- "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> Muli Ben-Yehuda wrote:
> 
> > I'm still seeing this on my x366 with the V17 sequencer firmware (with
> > the old Razor sequencer it happens as well, but rarely).
> > 
> > aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x6
> > aic94xx: tmf tasklet complete
> > aic94xx: tmf resp tasklet
> > aic94xx: tmf came back
> > aic94xx: task not done, clearing nexus
> > aic94xx: asd_clear_nexus_tag: PRE
> > aic94xx: asd_clear_nexus_tag: POST
> > aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
> > aic94xx: task 0xffff81015ee59580 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper
> layer!
> > aic94xx: asd_clear_nexus_tasklet_complete: here
> > aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
> > aic94xx: came back from clear nexus
> > aic94xx: task 0xffff81015ee59580 aborted, res: 0x0
> > sas: command 0xffff8100e2afcb00, task 0xffff81015ee59580, aborted by initiator: EH_NOT_HANDLED
> > sas: Enter sas_scsi_recover_host
> > sas: going over list...
> > sas: trying to find task 0xffff81015ee59580
> > sas: sas_scsi_find_task: task 0xffff81015ee59580 already aborted
> > sas: sas_scsi_recover_host: task 0xffff81015ee59580 is aborted
> > sas: --- Exit sas_scsi_recover_host
> 
> Yes, the patch doesn't eliminate these errors; it merely does something
> more intelligent with the error code than "Sit around and wait for
> everything to time out"... despite the scary error messages, it looks

The code as was submitted last year to this list did _NOT_ "sit around
and wait for everything to time out".

It is unfortunate (but clever tactic by bottomley) that the code was
NOT pulled from my git trees into scsi-misc and then "worked on", but
was instead "worked on" in private and then committed to scsi-misc.
So the code has no git history/revision history before it was "edited by"
by bottomley, as we'd seen with the SAS event processing.

BTW, I do have git trees of the code and an uninterruptible git
history of the code from the very beginning.

I.e. uninterruptible continued git history after initial
posting date of 09/09/2005, 
http://marc.theaimsgroup.com/?l=linux-scsi&m=112629423714248&w=2
The git trees were then hosted by http://linux.adaptec.com/sas/ .

> like it's doing the right thing.  However, it'd be useful to have
> timestamps on the printks to know for sure.
> 
> > aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x5
> 
> Break recv'd... that's a new one.
> 
> > sas: DOING DISCOVERY on port 0, pid:1105
> > scsi 0:0:0:0: Direct-Access     IBM-ESXS ST936701SS    F  B512 PQ: 0 ANSI: 4
> 
> Hrm, you might want to update your disks to the latest firmware levels
> (B51C)... be wary that the firmware updates occasionally nuke everything
> on the drive. :(
> 
> --D
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

