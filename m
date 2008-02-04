From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/24][RFC] scsi_eh: Define  new API for sense handling
Date: Mon, 04 Feb 2008 11:33:28 -0600
Message-ID: <1202146408.3096.56.camel@localhost.localdomain>
References: 47A72A7F.1050301@panasas.com  <1202139034-4508-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39600 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657AbYBDRdd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:33:33 -0500
In-Reply-To: <1202139034-4508-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Mon, 2008-02-04 at 17:30 +0200, Boaz Harrosh wrote:
> This patch defines a new API for sense handling. All drivers will
>   be converted to this API, before the sense handling implementation will
>   change. API is as follows:
> 
>     void scsi_eh_cpy_sense(struct scsi_cmnd *cmd, void* sense,
>         						 unsigned sense_bytes);
>         To be used by drivers, when they have sense-bits
>         and wants to send them to upper layer. Max size
>         need not be a concern, If upper layer does not have
>         enough space it will be automatically truncated.
> 
>     u8 *scsi_make_sense(struct scsi_cmnd *cmd);
>         To be used by drivers, and scsi-midlayer. Returns a DMA-able
>         sense buffer. Must be returned by scsi_return_sense(). It should
>         never fail if .pre_allocate_sense && .sense_buffsize in host
>         template where properly set.
>         the buffer is of shost->sense_buffsize long.
> 
>     void *scsi_return_sense(struct scsi_cmnd *cmd, u8 *sb);
>         Frees and returns the sense to the upper layer,
>         copying only what's necessary.
> 
>     void scsi_eh_reset_sense(struct scsi_cmnd *cmd)
>         Should not be used or necessary.
> 
>     const u8 *scsi_sense(struct scsi_cmnd *cmd)
>         Used by ULDs and for inspecting the returned sense, can not
>         be modified. It is only valid after a call to
>         scsi_eh_cpy_sense() or a call to scsi_return_sense(). Before
>         that it will/should return an empty buffer.
> 
>     New members at scsi host template:
>         .sense_buffsize - if a driver calls scsi_make_sense() or
>                   scsi_eh_prep_cmnd(), This value should be none
>                   zero indicating the max sense size, the driver
>                   supports. In most cases it should be
>                   SCSI_SENSE_BUFFERSIZE.
>                   If this value is zero the driver will only call
>                   scsi_eh_cpy_sense().
> 
>         .pre_allocate_sense - if a Driver calls scsi_make_sense()
>                       in .queuecommand for every cmnd, this
>                       should be set to true. In which case
>                       scsi_make_sense() will not fail because
>                       midlayer will fail the command allocation.
>                       If the drivers calls scsi_eh_prep_cmnd()
>                       then sense_buffsize is not Zero but this
>                       here is set to false.

My initial reaction to this is that you're doing too many contortions to
ensure something we don't particularly care about:  whether we can
allocate a sense buffer atomically or not.

What all this code should be doing is simply allocating the sense buffer
in scsi_eh_prep_cmnd() using tomo's existing slab (and GFP_ATOMIC) if
that fails, we need a return from scsi_eh_prep_cmnd() telling us.  At
that point, the driver should abandon the auto request sense attempt and
instead just return the CC/UA without the DRIVER_SENSE bit set which
will trigger the eh to collect the sense for us.

Ideally, doing it this way might mean we could even dump the
sense_buffer pointer from the command (although I don't see that as
necessary).

This solves the 99% case without getting into preallocation contortions.

James


