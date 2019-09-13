Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA9CC49ED7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 20:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1712A206A4
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 20:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388202AbfIMUgI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 16:36:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:50208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388167AbfIMUgI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Sep 2019 16:36:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0B6E6AF77;
        Fri, 13 Sep 2019 20:36:07 +0000 (UTC)
Message-ID: <bcab32ef2d17d7d14c3a5d41ee711e21ab749ab3.camel@suse.de>
Subject: Re: [PATCH 2/6] qla2xxx: Fix flash read for Qlogic ISPs
From:   Martin Wilck <mwilck@suse.de>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 13 Sep 2019 22:36:43 +0200
In-Reply-To: <20190830222402.23688-3-hmadhani@marvell.com>
References: <20190830222402.23688-1-hmadhani@marvell.com>
         <20190830222402.23688-3-hmadhani@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2019-08-30 at 15:23 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Use adapter specific callback to read flash instead of ISP
> adapter specific.
> 
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_init.c | 4 ++--
>  drivers/scsi/qla2xxx/qla_nx.c   | 1 +
>  drivers/scsi/qla2xxx/qla_sup.c  | 8 ++++----
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 

Tested-by: Martin Wilck <mwilck@suse.com>

I believe this patch should be tagged with

Fixes: 5fa8774c7f38 (scsi: qla2xxx: Add 28xx flash primary/secondary status/image mechanism)

I just bisected the FW initialization problems on my 8200 series CNA to
that commit, and I can confirm that this patch fixes it.


