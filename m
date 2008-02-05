From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 5/24][RFC] dpt_i2o: Use new scsi_eh_cpy_sense()
Date: Tue, 05 Feb 2008 10:51:46 +0200
Message-ID: <47A823A2.6090200@panasas.com>
References: 47A72A7F.1050301@panasas.com <1202140722-4650-1-git-send-email-bharrosh@panasas.com> <532ABFBDAAC3A34EB12EBA6CEC2838F439766174@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:39263 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbYBEIwv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 03:52:51 -0500
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F439766174@ADPE2K703.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Mon, Feb 04 2008 at 20:32 +0200, "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com> wrote:
> ACK with condition that community accepts the RFC's entire premise.
> 
> The removed code that shunted the REQUEST_SENSE was based on the assumption 
> that the sense data in the current scsi command packet was left over from the 
> previous command's execution with a check condition as the scsi command packet 
> is reused to issue the REQUEST_SENSE. For a new, or second from the target's point 
> of view, request sense to the target issued by these older kernels would always 
> return an erased sense. The dpt_i2o driver does not itself maintain the sense history, 
> nor does the Firmware. This behavior, I believe, is not the case for current kernels so 
> the code fragment made little sense (pun not intended). If my historical knowledge is 
> correct, this (now removed) workaround makes no more sense because the scsi layer correctly 
> manages adapters that produce auto-request sense and does not ever turn around the command 
> and send a second request for sense information.

> Given this understanding, I have no problem with the removed fragment of REQUEST_SENSE shunting. 
> However, I do urge some target error recovery testing, tape drives being the likely type of target 
> affected by this change. I have no such hardware to confirm...
> Sincerely -- Mark Salyzyn

I have removed this test because the midlayer does a scsi_eh_reset_sense() just before
the new invocation of a command. So even if the second bad REQUEST_SENSE comes this
will not filter it out anymore. If such a thing still happens? A driver state machine
must be used to filter it out, or of course midlayer should be fixed.

Boaz
