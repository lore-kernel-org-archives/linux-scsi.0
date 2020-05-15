Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980F5C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 06:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 724792065F
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 06:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgEOGiL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 02:38:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:33960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbgEOGiL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 May 2020 02:38:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E5561B19D;
        Fri, 15 May 2020 06:38:11 +0000 (UTC)
Subject: Re: [PATCH v6 03/15] qla2xxx: Simplify the functions for dumping
 firmware
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200514213516.25461-1-bvanassche@acm.org>
 <20200514213516.25461-4-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <de66ff0c-e5eb-346c-ee46-a7ed245f7a9f@suse.de>
Date:   Fri, 15 May 2020 08:38:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514213516.25461-4-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/14/20 11:35 PM, Bart Van Assche wrote:
> Instead of passing an argument to the firmware dumping functions that
> tells these functions whether or not to obtain the hardware lock, obtain
> that lock before calling these functions. This patch fixes the following
> recently introduced C=2 build error:
> 
>    CHECK   drivers/scsi/qla2xxx/qla_tmpl.c
> drivers/scsi/qla2xxx/qla_tmpl.c:1133:1: error: Expected ; at end of statement
> drivers/scsi/qla2xxx/qla_tmpl.c:1133:1: error: got }
> drivers/scsi/qla2xxx/qla_tmpl.h:247:0: error: Expected } at end of function
> drivers/scsi/qla2xxx/qla_tmpl.h:247:0: error: got end-of-input
> 
> Cc: Arun Easi <aeasi@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Fixes: cbb01c2f2f63 ("scsi: qla2xxx: Fix MPI failure AEN (8200) handling")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_bsg.c    |   4 +-
>   drivers/scsi/qla2xxx/qla_dbg.c    | 153 ++++++++----------------------
>   drivers/scsi/qla2xxx/qla_def.h    |   2 +-
>   drivers/scsi/qla2xxx/qla_gbl.h    |  21 ++--
>   drivers/scsi/qla2xxx/qla_isr.c    |  12 +--
>   drivers/scsi/qla2xxx/qla_mbx.c    |   6 +-
>   drivers/scsi/qla2xxx/qla_nx.c     |   2 +-
>   drivers/scsi/qla2xxx/qla_nx2.c    |   2 +-
>   drivers/scsi/qla2xxx/qla_os.c     |   2 +-
>   drivers/scsi/qla2xxx/qla_target.c |   4 +-
>   drivers/scsi/qla2xxx/qla_tmpl.c   |  19 +---
>   11 files changed, 71 insertions(+), 156 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
