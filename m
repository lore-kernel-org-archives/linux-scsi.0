Return-Path: <SRS0=fvsq=YM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C88ACA9EAC
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Oct 2019 15:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A1CD21925
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Oct 2019 15:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfJSPyx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Oct 2019 11:54:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:59270 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725924AbfJSPyx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 19 Oct 2019 11:54:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A5A8FB20F;
        Sat, 19 Oct 2019 15:54:51 +0000 (UTC)
Subject: Re: [PATCH] scsi_dh_alua: Do not run STPG for implicit ALUA
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20191018135537.69462-1-hare@suse.de> <yq1mudxhgoj.fsf@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <56d6b9ca-06d1-4784-fc5b-8c2b53ecc090@suse.de>
Date:   Sat, 19 Oct 2019 17:54:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <yq1mudxhgoj.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/18/19 11:44 PM, Martin K. Petersen wrote:
> 
> Hannes,
> 
>> If a target only supports implicit ALUA sending a SET TARGET PORT
>> GROUPS command is not only pointless, but might actually cause issues.
> 
> We already have a conditional in alua_stpg():
> 
>          if (!(pg->tpgs & TPGS_MODE_EXPLICIT)) {
>                  /* Only implicit ALUA supported, retry */
>                  return SCSI_DH_RETRY;
>          }
> 
>> @@ -832,6 +832,10 @@ static void alua_rtpg_work(struct work_struct *work)
>>   		if (err != SCSI_DH_OK)
>>   			pg->flags &= ~ALUA_PG_RUN_STPG;
>>   	}
>> +	/* Do not run STPG if only implicit ALUA is supported */
>> +	if (scsi_device_tpgs(sdev) == TPGS_MODE_IMPLICIT)
>> +		pg->flags &= ~ALUA_PG_RUN_STPG;
>> +
>>   	if (pg->flags & ALUA_PG_RUN_STPG) {
>>   		pg->flags &= ~ALUA_PG_RUN_STPG;
>>   		spin_unlock_irqrestore(&pg->lock, flags);
> 
> Instead of checking for EXPLICIT one place and checking for !IMPLICIT
> another, can we consolidate the two and maybe do:
> 
>    	if (pg->flags & ALUA_PG_RUN_STPG &&
>              scsi_device_tpgs(sdev) == TPGS_MODE_EXPLICIT) {
>          	[...]
> 
> and then remove the redundant check in alua_stpg()?
> 
Good point.
Will be resending the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
