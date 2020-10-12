Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7D7C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 23:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5594D20878
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 23:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389470AbgJLX7W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 19:59:22 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:55864 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388709AbgJLX7W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 19:59:22 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 6BAB0272DB;
        Mon, 12 Oct 2020 19:59:18 -0400 (EDT)
Date:   Tue, 13 Oct 2020 10:59:18 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Daniel Wagner <dwagner@suse.de>
cc:     Nilesh Javali <njavali@marvell.com>, Arun Easi <aeasi@marvell.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] qla2xxx: Return EBUSY on fcport deletion
In-Reply-To: <20201012173524.46544-1-dwagner@suse.de>
Message-ID: <alpine.LNX.2.23.453.2010131058220.10@nippy.intranet>
References: <20201012173524.46544-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Mon, 12 Oct 2020, Daniel Wagner wrote:

> When the fcport is about to be deleted we should return EBUSY instead
> of ENODEV. Only for EBUSY the request will be requeued in a multipath
> setup.
> 
> Also in case we have a valid qpair but the firmware has not yet
> started return EBUSY to avoid dropping the request.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> 
> v3: simplify test logic as suggested by Arun.

Not exactly a "simplification": there was a change of behaviour between v2 
and v3. It seems the commit log no longer reflects the code.

> v2: rebased on mkp/staging
> 
>  drivers/scsi/qla2xxx/qla_nvme.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index 2cd9bd288910..1fa457a5736e 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -555,10 +555,12 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
>  
>  	fcport = qla_rport->fcport;
>  
> -	if (!qpair || !fcport || (qpair && !qpair->fw_started) ||
> -	    (fcport && fcport->deleted))
> +	if (!qpair || !fcport)
>  		return -ENODEV;
>  
> +	if (!qpair->fw_started || fcport->deleted)
> +		return -EBUSY;
> +
>  	vha = fcport->vha;
>  
>  	if (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))
> 
