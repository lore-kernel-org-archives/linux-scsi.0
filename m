From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: [PATCH 5/24][RFC] dpt_i2o: Use new scsi_eh_cpy_sense()
Date: Tue, 5 Feb 2008 05:51:28 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F4397D6404@ADPE2K703.adaptec.com>
References: 47A72A7F.1050301@panasas.com
 <1202140722-4650-1-git-send-email-bharrosh@panasas.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F439766174@ADPE2K703.adaptec.com>
 <47A823A2.6090200@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:57850 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbYBENva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 08:51:30 -0500
In-Reply-To: <47A823A2.6090200@panasas.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

I do not think the midlayer needs to be fixed. I think this was a bug/feature that presented itself in the 2.2 tree when we were developing this driver in 1996...

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Boaz Harrosh [mailto:bharrosh@panasas.com]
> Sent: Tuesday, February 05, 2008 3:52 AM
> To: Salyzyn, Mark
> Cc: James Bottomley; FUJITA Tomonori; Christoph Hellwig; Jens
> Axboe; Jeff Garzik; linux-scsi; Andrew Morton
> Subject: Re: [PATCH 5/24][RFC] dpt_i2o: Use new scsi_eh_cpy_sense()
>
> On Mon, Feb 04 2008 at 20:32 +0200, "Salyzyn, Mark"
> <Mark_Salyzyn@adaptec.com> wrote:
> > ACK with condition that community accepts the RFC's entire premise.
> >
> > The removed code that shunted the REQUEST_SENSE was based
> on the assumption
> > that the sense data in the current scsi command packet was
> left over from the
> > previous command's execution with a check condition as the
> scsi command packet
> > is reused to issue the REQUEST_SENSE. For a new, or second
> from the target's point
> > of view, request sense to the target issued by these older
> kernels would always
> > return an erased sense. The dpt_i2o driver does not itself
> maintain the sense history,
> > nor does the Firmware. This behavior, I believe, is not the
> case for current kernels so
> > the code fragment made little sense (pun not intended). If
> my historical knowledge is
> > correct, this (now removed) workaround makes no more sense
> because the scsi layer correctly
> > manages adapters that produce auto-request sense and does
> not ever turn around the command
> > and send a second request for sense information.
>
> > Given this understanding, I have no problem with the
> removed fragment of REQUEST_SENSE shunting.
> > However, I do urge some target error recovery testing, tape
> drives being the likely type of target
> > affected by this change. I have no such hardware to confirm...
> > Sincerely -- Mark Salyzyn
>
> I have removed this test because the midlayer does a
> scsi_eh_reset_sense() just before
> the new invocation of a command. So even if the second bad
> REQUEST_SENSE comes this
> will not filter it out anymore. If such a thing still
> happens? A driver state machine
> must be used to filter it out, or of course midlayer should be fixed.
>
> Boaz
>
