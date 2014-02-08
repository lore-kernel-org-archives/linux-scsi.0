From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into scsi_{host,target}_queue_ready
Date: Sat, 08 Feb 2014 12:00:49 +0100
Message-ID: <52F60E61.5040609@acm.org>
References: <20140205123930.150608699@bombadil.infradead.org>	 <20140205124021.286457268@bombadil.infradead.org>	 <1391705819.22335.8.camel@dabdike> <52F3C21F.70409@acm.org>	 <1391723900.14985.3.camel@haakon3.risingtidesystems.com>	 <52F4B622.1070900@acm.org> <1391801455.1155.26.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:59974 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751063AbaBHLA6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Feb 2014 06:00:58 -0500
In-Reply-To: <1391801455.1155.26.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

On 02/07/14 20:30, Nicholas A. Bellinger wrote:
> All that scsi_debug with NOP'ed REQ_TYPE_FS commands is doing is calling
> scsi_cmd->done() as soon as the descriptor has been dispatched into LLD
> ->queuecommand() code.
> 
> It's useful for determining an absolute performance ceiling between
> scsi_mq vs. scsi_request_fn() based codepaths without involving any
> other LLD specific overheads.

Sorry but I'm not convinced that the scsi_debug driver is well suited
for testing scsi-mq. In source file drivers/scsi/scsi_debug.c of kernel
3.14-rc1 I found the following:

static DEF_SCSI_QCMD(scsi_debug_queuecommand)

>From include/scsi/scsi_host.h:

/*
 * Temporary #define for host lock push down. Can be removed when all
 * drivers have been updated to take advantage of unlocked
 * queuecommand.
 *
 */
#define DEF_SCSI_QCMD(func_name) \
        int func_name(struct Scsi_Host *shost, struct scsi_cmnd *cmd)  \
        {                                                              \
                unsigned long irq_flags;                               \
                int rc;                                                \
                spin_lock_irqsave(shost->host_lock, irq_flags);        \
                scsi_cmd_get_serial(shost, cmd);                       \
                rc = func_name##_lck (cmd, cmd->scsi_done);            \
                spin_unlock_irqrestore(shost->host_lock, irq_flags);   \
                return rc;                                             \
        }

In other words, all scsi_debug_queuecommand() are serialized. I think
for testing the scsi-mq code properly a SCSI LLD driver is needed that
allows concurrent queuecommand() calls.

Bart.

