Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9653CC64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 09:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EACC20674
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 09:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbgLAJCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 04:02:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:37574 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729292AbgLAJCd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Dec 2020 04:02:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C9F97ACA8;
        Tue,  1 Dec 2020 09:01:51 +0000 (UTC)
Date:   Tue, 1 Dec 2020 10:01:51 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH 05/15] qla2xxx: Don't check for fw_started while posting
 nvme command
Message-ID: <20201201090151.bdyeliawhpps7wd7@beryllium.lan>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-6-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201082730.24158-6-njavali@marvell.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 01, 2020 at 12:27:20AM -0800, Nilesh Javali wrote:
> From: Saurav Kashyap <skashyap@marvell.com>
> 
> NVMe commands can come only after successful addition of rport and nvme
> connect, and rport is only registered after FW started bit is set. Remove the
> redundant check.
> 
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_nvme.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index b7a1dc24db38..d4159d5a4ffd 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -554,19 +554,15 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
>  
>  	fcport = qla_rport->fcport;
>  
> -	if (!qpair || !fcport)
> -		return -ENODEV;
> -
> -	if (!qpair->fw_started || fcport->deleted)
> +	if (unlikely(!qpair || !fcport || fcport->deleted))
>  		return -EBUSY;

This reverts the fix from patch #1 in this series. What's the reasoning
that needs to return EBUSY when !qpair || !fcport is true?
