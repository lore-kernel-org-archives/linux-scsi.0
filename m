From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: [PATCH] qla2xxx data transfer residuals
Date: Fri, 7 May 2004 11:01:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <04May7.110118edt.332525@cyborg.cybernetics.com>
References: <B179AE41C1147041AA1121F44614F0B0DD011B@AVEXCH02.qlogic.org>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:10512 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S263584AbUEGPBU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 11:01:20 -0400
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DD011B@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Vasquez' <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

> On Wednesday, May 05, 2004 11:19 AM, Tony Battersby wrote:
> >
> > The first section of the patch changes the 'resid' variable to be
> > signed, since the residual is negative in the case of overflow.
> >
>
> The pkt->residual_length's value is retrieved from the FCP_RESID field
> of the FCP_RSP IU for a given command.  According to FCP3 (9.4.8), by
> definition, this value will always be positive.  Now, propagating this
> information up to the mid-layer via cmd->resid may require some
> negation in the case of an overflow -- but even then, that may not be
> necessary since the driver returns DID_ERROR in case of an overrun.

I don't have the specification to which you refer, but I actually did
observe a negative value in pkt->residual_length for overflow:

Target device: tape drive
Command: READ(6): 08 00 00 00 20 00
Actual block size on tape: 16 bytes (0x10)
The target should transfer 16 bytes of data, end the command with CHECK
CONDITION, and set ILI in the sense data.
The driver was told to expect to transfer 12 bytes (to force an
overflow).
The result was: comp_status == CS_COMPLETE, scsi_status = 0x0602,
CMD_XFRLEN == 12, le32_to_cpu(pkt->residual_length) == 4294967292.  So
pkt->residual_length is clearly negative in this case.  With my patch
applied, the userspace program that sent the command gets a residual
of -4, which I believe is correct.

A different path is taken (comp_status == 7, which goes down to the
default case in the switch statement) when the target returns GOOD
status with a DATA IN overflow rather than CHECK CONDITION.  In this
case, pkt->residual_length is positive.

Maybe this is an anomaly of the SCSI->FC bridge that I am using?  I
don't have a FC analyzer, so I'm not sure.

However, it doesn't matter to me if the value is signed vs. unsigned,
because it doesn't make an actual functional difference.  I just thought
that it should be signed because I saw a signed result.

> > The next section of the patch is the most important part.  It adds a
> > check for data underrun/overrun for comp_status == CS_COMPLETE and
> > sets Scsi_Cmnd::resid if detected.  This code is triggered when a
> > data transfer command ends with CHECK CONDITION status.  I am not
> > sure why comp_status == CS_COMPLETE rather than CS_DATA_UNDERRUN if
> > there was an underrun with CHECK CONDITION, but evidently that is
> > the case.
> >
>
> I've spoken with our firmware folks, if in fact this particular
> sequence of events occurs (underrun with a check-condition), the
> firmware will report the completion-status as an CS_DATA_UNDERRUN.
> How did you verify that the command-handling completion-path went down
> the CS_COMPLETE case?

I added various printk() statements to the different completion paths
and observed the output when sending different types of commands using
the SCSI generic driver.  I'm not sure what the firmware is doing, but
the driver sees CS_COMPLETE in this case.  Maybe the command with the
underrun returns CS_DATA_UNDERRUN, but the followup request sense resets
it back to CS_COMPLETE?  I don't know much about fibre channel, so that
is only a guess.

> > The rest of the patch applies to the comp_status == CS_DATA_UNDERRUN
> > case.  It moves the setting of Scsi_Cmnd::resid to cover all status
> > values rather than just lscsi_status == 0.  However, in my testing I
> > have never seen the case where comp_status == CS_DATA_UNDERRUN &&
> > lscsi_status != 0, so this part of the patch does not make an actual
> > difference in my testing.  Is this dead code, am I just not knowing
> > how to trigger it, or does it apply only to adapters other than the
> > QLA2200?
> >
> > Next point: there is code in the driver (in the same case of the
> > switch statement) that checks for comp_status == CS_DATA_UNDERRUN &&
> > !(scsi_status & SS_RESIDUAL_UNDER).  I have never seen this happen,
> > and I am not sure if the pkt->residual_length is valid in this case
> > or not.
>
> You'll typically only see this happen when the firmware detects that a
> data-frame has been lost during the transfer.
>
> > on the original code.  Also, CMD_RESID_LEN(cp) and Scsi_Cmnd::resid
> > were set in different places in the original code, which didn't make
> > sense to me.  The patch always sets them together.  Is that correct?
> >
>
> The third and forth hunk of the patch looks fine with me, I'm not
> entirely convinced we need the second hunk.

I have a userspace program that I am using to test.  It's the second
hunk of the patch that makes it work.  I'll send the program to you
privately in a separate message.

Anthony J. Battersby
Cybernetics

