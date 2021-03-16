Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA072C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 08:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5C6A64FEA
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 08:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbhCPIZv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 04:25:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:49622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234698AbhCPIZb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Mar 2021 04:25:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F3304AC1F;
        Tue, 16 Mar 2021 08:25:29 +0000 (UTC)
Date:   Tue, 16 Mar 2021 09:25:29 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH 1/7] Revert "qla2xxx: Make sure that aborted commands are
 freed"
Message-ID: <20210316082529.h3veoudiptaxcdwg@beryllium.lan>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316035655.2835-2-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 15, 2021 at 08:56:49PM -0700, Bart Van Assche wrote:
> Calling vha->hw->tgt.tgt_ops->free_cmd() from qlt_xmit_response() is wrong
> since the command for which a response is sent must remain valid until the
> SCSI target core calls .release_cmd().

The commit message from 0dcec41acb85 ("scsi: qla2xxx: Make sure that
aborted commands are freed") says 'avoids that the code for removing a
session hangs due to commands that do not make progress'.

As this patch reverts the change, is the problem mentioned gone? Did
some other change fix it? Just wondering.
