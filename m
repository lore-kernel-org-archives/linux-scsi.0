From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: requeuing a Scsi_Cmnd?
Date: Thu, 30 Oct 2003 15:48:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10310301544250.23682-100000@master.linux-ide.org>
References: <3EC03A69.1060302@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astound-64-85-224-253.ca.astound.net ([64.85.224.253]:14853
	"EHLO master.linux-ide.org") by vger.kernel.org with ESMTP
	id S262913AbTJ3Xs2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 18:48:28 -0500
In-Reply-To: <3EC03A69.1060302@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Luben Tuikov <tluben@rogers.com>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


Jeff,

If the goal is to add a queue depth to hba's w/o a qdma ring, you need a
whole pile of tasklets and thread queues.

If you have a hba with qdma ring(s) then it is just like standard scsi.

Cheers,

Andre Hedrick
LAD Storage Consulting Group

On Mon, 12 May 2003, Jeff Garzik wrote:

> Luben Tuikov wrote:
> > James Bottomley wrote:
> > 
> >> On Sun, 2003-05-11 at 15:25, Jeff Garzik wrote:
> >>
> >>> This question applies to 2.4 as well as 2.5 (I believe the strategies 
> >>> are different for the two?)
> >>>
> >>> Suppose I am passed several Scsi_Cmnd structures via ->queuecommand. 
> >>> TCQ depth is >1.  An event causes the entire queue to be aborted, but 
> >>> I know that the majority of the queue was actually ok.  So, my LLD 
> >>> would need to requeue and resend most of the recently-aborted 
> >>> Scsi_Cmnds.
> >>
> >>
> >>
> >> You keep finding these unhandled condidions, sigh.  The correct thing to
> >> do (since this is a situation identical to QErr set) is to return a
> >> check condition to the failing command and to return a status of TASK
> >> ABORTED for all the others (SPC3).  Of course, the SCSI-2 behaviour was
> >> just to expect all tasks to be silently aborted on QErr=1.  Neither of
> >> these, of course, is coded into the mid-layer.
> > 
> > 
> > Iff TAS is set and if TST is 001, and there is more than one initiator
> > whose task are being nuked, then this is correct.
> > 
> > Jeff didn't give much information, but it sounds like ABORT/CLEAR TASK SET.
> > Anyway, no point in speculating.
> 
> 
> I'm working on a SCSI low-level driver that drives SATA host 
> controllers.  For ATAPI, it's mainly a passthru.  The headache comes in 
> the translation of SCSI->ATA, and in the error handling.  The SCSI->ATA 
> translator can be effectively considered a SCSI simulator (or at least 
> that's how I look at it), so like iSCSI I'm creating a software target, 
> and I want my target to be compliant to spec.  (Which spec, you ask? 
> Well, initially SCSI-2, but long term James has convinced me SCSI-3)
> 
> So for my specific example, I'm passed a bunch of Scsi_Cmnds.  I queue 
> them.  And then according to spec, an error on the active command will 
> cause the entire queue to abort.  Clearly, I do not want to error-out 
> the other probably-valid commands, only the specific one that caused the 
> error.  So, the remaining ones need to be retried.
> 
> 	Jeff
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

