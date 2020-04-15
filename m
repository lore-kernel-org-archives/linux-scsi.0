Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242FBC38A29
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 12:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 086CA206D5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 12:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370411AbgDOMuW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:50:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:33558 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S370405AbgDOMuU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 08:50:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1CCCDAF21;
        Wed, 15 Apr 2020 12:50:18 +0000 (UTC)
Subject: Re: [PATCH v3 10/31] elx: libefc: FC Domain state machine interfaces
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-11-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <237d9a7a-1898-3218-8df5-e855bab213dd@suse.de>
Date:   Wed, 15 Apr 2020 14:50:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-11-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/20 5:32 AM, James Smart wrote:
> This patch continues the libefc library population.
> 
> This patch adds library interface definitions for:
> - FC Domain registration, allocation and deallocation sequence
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>    Acquire efc->lock in efc_domain_cb to protect all the domain state
>      transitions.
>    Removed efc_assert and used WARN_ON.
>    Note: Re: Locking:
>      efc->lock is a global per port lock which is used to synchronize and
>      serialize all the state machine event processing. As there is a
>      single EQ all the events are serialized. This lock will protect the
>      sport list, sport, node list, node, and vport list. All the libefc
>      APIs called by the driver will take this lock internally.
>   Note: Re: "It would even simplify the code, as several cases can be
>        collapsed into one ..."
>      The Hardware events cannot be collapsed as each events is different
>      from State Machine events. The code present looks more readable than
>      a mapping array in this case.
> ---
>   drivers/scsi/elx/libefc/efc_domain.c | 1109 ++++++++++++++++++++++++++++++++++
>   drivers/scsi/elx/libefc/efc_domain.h |   52 ++
>   2 files changed, 1161 insertions(+)
>   create mode 100644 drivers/scsi/elx/libefc/efc_domain.c
>   create mode 100644 drivers/scsi/elx/libefc/efc_domain.h
>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
