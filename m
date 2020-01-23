Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30635C2D0DB
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 10:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C79424125
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 10:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgAWKRd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 05:17:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:46516 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgAWKRd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 05:17:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C2949AF6E;
        Thu, 23 Jan 2020 10:17:31 +0000 (UTC)
Date:   Thu, 23 Jan 2020 11:17:30 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 2/6] qla2xxx: Simplify the code for aborting SCSI
 commands
Message-ID: <20200123101730.tqvkhgq42dvmq2tr@beryllium.lan>
References: <20200123042345.23886-1-bvanassche@acm.org>
 <20200123042345.23886-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123042345.23886-3-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 22, 2020 at 08:23:41PM -0800, Bart Van Assche wrote:
> Since the SCSI core does not reuse the tag of the SCSI command that is
> being aborted by .eh_abort() before .eh_abort() has finished it is not
> necessary to check from inside that callback whether or not the SCSI command
> has already completed. Instead, rely on the firmware to return an error code
> when attempting to abort a command that has already completed. Additionally,
> rely on the firmware to return an error code when attempting to abort an
> already aborted command.
> 
> In qla2x00_abort_srb(), use blk_mq_request_started() instead of
> sp->completed and sp->aborted.
> 
> This patch eliminates several race conditions triggered by the removed member
> variables.

I can only guess here what the races are but I agree removing the
logic here and relying on the SCSI layer to handle it correctly makes
sense. 

> Acked-by: Himanshu Madhani <hmadhani@marvell.com>
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Daniel Wagner <dwagner@suse.de>

> +/*
> + * The caller must ensure that no completion interrupts will happen
> + * while this function is in progress.
> + */

So could we add something like WARN_ON(irqs_disabled())?

