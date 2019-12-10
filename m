Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14AE6C2D0C5
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 10:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E986320836
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 10:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfLJKvX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 05:51:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:48660 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726574AbfLJKvX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Dec 2019 05:51:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9272CACA4;
        Tue, 10 Dec 2019 10:51:21 +0000 (UTC)
Message-ID: <fdff60ffaacad1b3a850942f61bdd92ab5bc6d12.camel@suse.de>
Subject: Re: [PATCH 3/4] qla2xxx: Fix point-to-point mode for qla25xx and
 older
From:   Martin Wilck <mwilck@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Date:   Tue, 10 Dec 2019 11:52:11 +0100
In-Reply-To: <20191209180223.194959-4-bvanassche@acm.org>
References: <20191209180223.194959-1-bvanassche@acm.org>
         <20191209180223.194959-4-bvanassche@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Bart,

On Mon, 2019-12-09 at 10:02 -0800, Bart Van Assche wrote:
> Restore point-to-point for qla25xx and older. Although this patch
> initializes
> a field (s_id) that has been marked as "reserved" in the firmware
> manual, it
> works fine on my setup.
> 
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Fixes: 0aabb6b699f7 ("scsi: qla2xxx: Fix Nport ID display value")
> Fixes: edd05de19759 ("scsi: qla2xxx: Changes to support N2N logins")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_iocb.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)

Having followed the discussion between you and Roman, I guess this is
ok. However I'd like to understand better in what ways the N2N topology
was broken for you. After all, this patch affects only the LOGO
payload. Was it a logout / relogin issue? Were wrong ports being logged
out?

Regards,
Martin


