Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633A6C2D0DB
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 10:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B51424125
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 10:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgAWKjC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 05:39:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:33622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbgAWKjC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 05:39:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 39059AFA8;
        Thu, 23 Jan 2020 10:39:01 +0000 (UTC)
Date:   Thu, 23 Jan 2020 11:39:00 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v2 5/6] qla2xxx: Convert MAKE_HANDLE() from a define into
 an inline function
Message-ID: <20200123103900.lgfr23w7p7fgcshr@beryllium.lan>
References: <20200123042345.23886-1-bvanassche@acm.org>
 <20200123042345.23886-6-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123042345.23886-6-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 22, 2020 at 08:23:44PM -0800, Bart Van Assche wrote:
> This patch allows sparse to verify the endianness of the arguments passed
> to MAKE_HANDLE().
> 
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_def.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index b04d334933ef..968f19995063 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -119,7 +119,10 @@ typedef struct {
>  #define LSD(x)	((uint32_t)((uint64_t)(x)))
>  #define MSD(x)	((uint32_t)((((uint64_t)(x)) >> 16) >> 16))
>  
> -#define MAKE_HANDLE(x, y) ((uint32_t)((((uint32_t)(x)) << 16) | (uint32_t)(y)))
> +static inline uint32_t MAKE_HANDLE(uint16_t x, uint16_t y)
> +{
> +	return ((uint32_t)x << 16) | y;
> +}

s/MAKE_HANDLE/make_handle/ ?
