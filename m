Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0171C4741F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 09:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C04C2071E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 09:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgI3JRK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 05:17:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:53082 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbgI3JRK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Sep 2020 05:17:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E5C7BAD29;
        Wed, 30 Sep 2020 09:17:08 +0000 (UTC)
Subject: Re: [PATCH v2 1/8] scsi: Added a new definition in scsi_cmnd.h
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
 <1601268657-940-2-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <917b5adb-7484-05c4-540b-b9cbec5f08c2@suse.de>
Date:   Wed, 30 Sep 2020 11:17:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1601268657-940-2-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/20 6:50 AM, Muneendra wrote:
> Added a new definition SCMD_NORETRIES_ABORT in scsi_cmnd.h
> 
> The SCMD_NORETRIES_ABORT defines the third bit postion
> in scmd->state
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v2:
> Modified the commit log
> ---
>   include/scsi/scsi_cmnd.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index e76bac4d14c5..e1883fee7659 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -64,6 +64,9 @@ struct scsi_pointer {
>   /* for scmd->state */
>   #define SCMD_STATE_COMPLETE	0
>   #define SCMD_STATE_INFLIGHT	1
> +#define SCMD_NORETRIES_ABORT	2 /* If this bit is set then there won't be any
> +				   * retries of scmd on abort success
> +				   */
>   
>   struct scsi_cmnd {
>   	struct scsi_request req;
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
