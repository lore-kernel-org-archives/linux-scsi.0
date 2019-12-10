Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E43AC2D0BF
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 20:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF9252073D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 20:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLJU2q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 15:28:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:37336 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725999AbfLJU2q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Dec 2019 15:28:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C324BAC9A;
        Tue, 10 Dec 2019 20:28:44 +0000 (UTC)
Message-ID: <1755e03c0aba7c684bdf387780bc526ddcc2647c.camel@suse.de>
Subject: Re: [PATCH 2/4] qla2xxx: Simplify the code for aborting SCSI
 commands
From:   Martin Wilck <mwilck@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Cc:     linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Date:   Tue, 10 Dec 2019 21:29:35 +0100
In-Reply-To: <658d52fb-c614-9ee5-f95f-81509a9de771@acm.org>
References: <20191209180223.194959-1-bvanassche@acm.org>
         <20191209180223.194959-3-bvanassche@acm.org>
         <f7a05e5696b1942b3303e20fe0e6891bc9a61090.camel@suse.de>
         <658d52fb-c614-9ee5-f95f-81509a9de771@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2019-12-10 at 12:57 -0500, Bart Van Assche wrote:
> On 12/10/19 6:47 AM, Martin Wilck wrote:
> > blk_mq_request_started() returns true for requests in
> > MQ_RQ_COMPLETE
> > state. Is this really an equivalent condition?
> > 
> > That said, the condition in the current code is sort of strange, as
> > it's equivalent to !(sp->completed && sp->aborted). I'm wondering
> > what
> > it means if a command is both completed and aborted. Naïvely
> > thinking
> > (and inferring from the current code) this condition could never be
> > met, and thus its negation would hold for every command. Perhaps
> > Quinn
> > meant "!(sp->completed || sp->aborted)" ?
> 
> Hi Martin,
> 
> The only caller of qla2x00_abort_srb() is qla2x00_abort_all_cmds().
> That
> function should only be called after completion interrupts have been
> disabled. In other words, I don't think that we have to worry about
> blk_mq_request_started() encountering the MQ_RQ_COMPLETE state. No
> request should have that state when qla2x00_abort_all_cmds() is
> called.

I thought avoiding a race between completion and abort was the whole
point of f45bca8c5052 ("scsi: qla2xxx: Fix double scsi_done for abort
path"), which introduced the code that you're now changing. But I must
be overlooking something then, as Himanshu has acked this.

Martin



