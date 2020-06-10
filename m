Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B723C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 11:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F3F12074B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 11:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgFJL1s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 07:27:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:46456 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728486AbgFJL1r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jun 2020 07:27:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 12A2CAE63;
        Wed, 10 Jun 2020 11:27:50 +0000 (UTC)
Date:   Wed, 10 Jun 2020 13:27:45 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v2] qla2xxx: Fix the ARM build
Message-ID: <20200610112745.qh7ahl7nff2xwzhm@beryllium.lan>
References: <20200610024215.27997-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610024215.27997-1-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 42dbf90d4651..de9c1604c575 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -46,7 +46,7 @@ typedef struct {
>  	uint8_t al_pa;
>  	uint8_t area;
>  	uint8_t domain;
> -} le_id_t;
> +} __packed le_id_t;

Now I am totally confused. le_id_t (and why does be_id_t not need it?) are
not used inside either of the reported data structure (cmd_entry_t,
ms_iocb_entry_t, request_t, struct ctio_crc2_to_fw, struct ctio7_to_24xx,
struct ctio_to_2xxx) which the bot reports. I must oversee something.

Besides this, my small test report 3 bytes size for le_id_t on all
architectures too. I'll try to see what the compiler generates
from the kernel source (takes a while because I am running it
natively...)
