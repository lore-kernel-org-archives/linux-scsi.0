From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [PATCH] qla2xxx data transfer residuals
Date: Wed, 5 May 2004 15:20:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD011B@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:28560 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S264822AbUEEWVm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 May 2004 18:21:42 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: linux-scsi@vger.kernel.org


On Wednesday, May 05, 2004 11:19 AM, Tony Battersby wrote:
> 
> The first section of the patch changes the 'resid' variable to be
> signed, since the residual is negative in the case of overflow.
> 

The pkt->residual_length's value is retrieved from the FCP_RESID field
of the FCP_RSP IU for a given command.  According to FCP3 (9.4.8), by
definition, this value will always be positive.  Now, propagating this
information up to the mid-layer via cmd->resid may require some
negation in the case of an overflow -- but even then, that may not be
necessary since the driver returns DID_ERROR in case of an overrun.

> The next section of the patch is the most important part.  It adds a
> check for data underrun/overrun for comp_status == CS_COMPLETE and
> sets Scsi_Cmnd::resid if detected.  This code is triggered when a
> data transfer command ends with CHECK CONDITION status.  I am not
> sure why comp_status == CS_COMPLETE rather than CS_DATA_UNDERRUN if
> there was an underrun with CHECK CONDITION, but evidently that is
> the case.
> 

I've spoken with our firmware folks, if in fact this particular
sequence of events occurs (underrun with a check-condition), the
firmware will report the completion-status as an CS_DATA_UNDERRUN.
How did you verify that the command-handling completion-path went down
the CS_COMPLETE case?

> The rest of the patch applies to the comp_status == CS_DATA_UNDERRUN
> case.  It moves the setting of Scsi_Cmnd::resid to cover all status
> values rather than just lscsi_status == 0.  However, in my testing I
> have never seen the case where comp_status == CS_DATA_UNDERRUN &&
> lscsi_status != 0, so this part of the patch does not make an actual
> difference in my testing.  Is this dead code, am I just not knowing
> how to trigger it, or does it apply only to adapters other than the
> QLA2200?
> 
> Next point: there is code in the driver (in the same case of the
> switch statement) that checks for comp_status == CS_DATA_UNDERRUN &&
> !(scsi_status & SS_RESIDUAL_UNDER).  I have never seen this happen,
> and I am not sure if the pkt->residual_length is valid in this case
> or not.

You'll typically only see this happen when the firmware detects that a
data-frame has been lost during the transfer.

> on the original code.  Also, CMD_RESID_LEN(cp) and Scsi_Cmnd::resid
> were set in different places in the original code, which didn't make
> sense to me.  The patch always sets them together.  Is that correct?
> 

The third and forth hunk of the patch looks fine with me, I'm not
entirely convinced we need the second hunk. 

> One final note: a data out overrun causes the offending command to
> hang forever rather than terminating with an error.  You can trigger
> this by sending a data out command (e.g. mode select) to a device
> with a data transfer length that is intentionally less than the
> device will transfer.  A data in overrun (e.g. mode sense with short
> transfer length) does not cause the offending command to hang.
> 

Thanks for the feedback, I'll be sure these changes are added to our
next release of the 2.4 and 2.6 drivers.

Regards,
Andrew Vasquez
