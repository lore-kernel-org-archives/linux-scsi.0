Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEAFC38A2A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 09:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E3DB207DD
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 09:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgEGJuH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 05:50:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:58666 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgEGJuG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 May 2020 05:50:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 251D8AFF2;
        Thu,  7 May 2020 09:50:08 +0000 (UTC)
Subject: Re: [PATCH 6/9] lpfc: Remove unnecessary lockdep_assert_held calls
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
 <20200501214310.91713-7-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <3a8c4d8d-5040-f9b2-d1d7-f51d2f42f4ca@suse.de>
Date:   Thu, 7 May 2020 11:50:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501214310.91713-7-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 11:43 PM, James Smart wrote:
> In an audit of lockdep calls in the driver, there are multiple lockdep
> checks in successive calling layers. E.g. a routine checks, and then
> calls a lower routine that also checks, and so on. Calling sequences
> result in many redundant checks.
> 
> Refine the code to remove lower-level lockdep checks.
> Update comments on the lock, correcting a few places where lock object
> in comment was incorrect.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_hbadisc.c |  8 +++-----
>   drivers/scsi/lpfc/lpfc_sli.c     | 33 +++++++++++++++-----------------
>   2 files changed, 18 insertions(+), 23 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
