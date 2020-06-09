Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1367C433E1
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 07:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE95207F9
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 07:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgFIHau (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 03:30:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:59942 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726888AbgFIHam (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 Jun 2020 03:30:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 46B11AFED;
        Tue,  9 Jun 2020 07:30:45 +0000 (UTC)
Date:   Tue, 9 Jun 2020 09:30:40 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH] qla2xxx: Fix the ARM build
Message-ID: <20200609073040.wjxzdtv5lcot2ziw@beryllium.lan>
References: <20200609041403.20306-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609041403.20306-1-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Mon, Jun 08, 2020 at 09:14:03PM -0700, Bart Van Assche wrote:
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 42dbf90d4651..edc9c082dc6e 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -46,7 +46,7 @@ typedef struct {
>  	uint8_t al_pa;
>  	uint8_t area;
>  	uint8_t domain;
> -} le_id_t;
> +} __packed le_id_t;
>  
>  #include "qla_bsg.h"
>  #include "qla_dsd.h"
> @@ -1841,8 +1841,8 @@ typedef union {
>  	struct {
>  		uint8_t reserved;
>  		uint8_t standard;
> -	} id;
> -} target_id_t;
> +	} __packed id;
> +} __packed target_id_t;

This is a bit strange. Why is that only these two definitions need this
treatment? With gcc 6.3.0 on Debian stretch, the compiler did the
right thing for x86_64, ARMv7 and ARMv8. In all cases target_id_t is 2 bytes
long.

Or does this happen because target_id_t is embedded into cmd_entry_t?

Here is the test code:

#include <stdio.h>
#include <stdint.h>

typedef union {
	uint16_t	extended;
	struct {
		uint8_t reserved;
		uint8_t standard;
	} id;
} target_id_t;

int main(int argc, char *argv[])
{
	printf("sizeof(target_id_t) = %zu\n", sizeof(target_id_t));
	return 0;
}

The only thing which is different to the above code is the use uint16_t
instead of __le16. But I thought this should make a difference.

Thanks,
Daniel
