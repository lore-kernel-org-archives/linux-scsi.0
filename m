Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A25BC11D00
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 08:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29B2124672
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 08:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgBTIV5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Feb 2020 03:21:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:57440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbgBTIV5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Feb 2020 03:21:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1F6F7AC8F;
        Thu, 20 Feb 2020 08:21:56 +0000 (UTC)
Date:   Thu, 20 Feb 2020 09:21:55 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v3 4/5] qla2xxx: Convert MAKE_HANDLE() from a define into
 an inline function
Message-ID: <20200220082155.c2dwknz2hcvwhwcg@beryllium.lan>
References: <20200220043441.20504-1-bvanassche@acm.org>
 <20200220043441.20504-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220043441.20504-5-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Wed, Feb 19, 2020 at 08:34:40PM -0800, Bart Van Assche wrote:
> -#define MAKE_HANDLE(x, y) ((uint32_t)((((uint32_t)(x)) << 16) | (uint32_t)(y)))
> +static inline uint32_t make_handle(uint16_t x, uint16_t y)
> +{
> +	return ((uint32_t)x << 16) | y;
> +}
>  
>  /*
>   * I/O register
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 47bf60a9490a..1816660768da 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -530,7 +530,7 @@ __qla2x00_marker(struct scsi_qla_host *vha, struct qla_qpair *qpair,
>  			int_to_scsilun(lun, (struct scsi_lun *)&mrk24->lun);
>  			host_to_fcp_swap(mrk24->lun, sizeof(mrk24->lun));
>  			mrk24->vp_index = vha->vp_idx;
> -			mrk24->handle = MAKE_HANDLE(req->id, mrk24->handle);
> +			mrk24->handle = make_handle(req->id, mrk24->handle);

The type of mrk24->handle is uint32_t and make_handle() is using type
uint16_t. Shouldn't the argument type for the y argument be uint32_t
as well?

Thanks,
Daniel
