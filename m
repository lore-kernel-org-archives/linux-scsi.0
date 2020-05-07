Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6C4C38A2A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 09:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7AE9207DD
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 09:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgEGJtZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 05:49:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:58452 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgEGJtZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 May 2020 05:49:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D7B52AFF2;
        Thu,  7 May 2020 09:49:26 +0000 (UTC)
Subject: Re: [PATCH 5/9] lpfc: Change default queue allocation for reduced
 memory consumption
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
 <20200501214310.91713-6-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9e20e9e8-5437-d57c-7242-7b39c455d1b1@suse.de>
Date:   Thu, 7 May 2020 11:49:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501214310.91713-6-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 11:43 PM, James Smart wrote:
> By default, the driver attempts to allocate a hdwq per logical cpu in
> order to provide good cpu affinity. Some systems have extremely high cpu
> counts and this can significantly raise memory consumption.
> 
> In testing on x86 platforms (non-AMD) it is found that sharing of a hdwq
> by a physical cpu and it's HT cpu can occur with little performance
> degredation. By sharing the hdwq count can be halved, significantly
> reducing the memory overhead.
> 
> Change the default behavior of the driver on non-AMD x86 platforms to
> share a hdwq by the cpu and its HT cpu.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc.h      |  23 ++++++--
>   drivers/scsi/lpfc/lpfc_attr.c | 106 +++++++++++++++++++++++++++-------
>   drivers/scsi/lpfc/lpfc_init.c |  82 +++++++++++---------------
>   drivers/scsi/lpfc/lpfc_sli4.h |   2 +-
>   4 files changed, 137 insertions(+), 76 deletions(-)
> I do assume that you've checked that this matches with blk-mq queue 
layout, right?

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
