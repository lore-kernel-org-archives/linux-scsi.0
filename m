Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF93EE3F3F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 23:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237864AbjILXG7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 19:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237755AbjILXG6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 19:06:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9796F10CC
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 16:06:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD57C433C8;
        Tue, 12 Sep 2023 23:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694560014;
        bh=karEv52LuaCk0/IeSYy+XGm5KshMp1qhw4G+CZRL0gA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=FhFJ+hX3vko+Tr5VeVBIxA7oevmuAaxDFOCD/WAnTxdfvV7DHbN5tpKZNJYcXMS+V
         y0OJ5lRzT6XbuGmRUOXbI5qKaGytJ9ZH5WxuEx0F5s9iP9n/MnyYIFEPwsGYyrSFep
         XzdRZQJ8KkSeSbsyOGqQIS7Rl4a9areDMx7VEsq4U95KuQ767tXRd+W4luD632198s
         Zkv5qihBXLaKRRQWuTkeK9miWL487wmxeXrR7VFfFCU3kWqFi2sS8kLVaXbDaCvOSt
         vPb0UYRJPIITGHVOnCDQ3/5oGoZvEE6kvV773YuE+W1L3+stKWYPQsklTh6HNaLDSS
         ILvXjeB5ClZTg==
Message-ID: <b046ee25-012c-fc8e-d250-e273ea48b482@kernel.org>
Date:   Wed, 13 Sep 2023 08:06:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 0/3] Minor cleanups
Content-Language: en-US
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
References: <20230912085338.434381-1-dlemoal@kernel.org>
 <9bc71fff-cd72-423d-a98f-81d81e4c5292@wdc.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <9bc71fff-cd72-423d-a98f-81d81e4c5292@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/23 22:43, Johannes Thumshirn wrote:
> On 12.09.23 10:53, Damien Le Moal wrote:
>> 3 patches to cleanup libsas functions declarations. No functional
>> changes.
>>
>> Changes from v1:
>>   * Added sas_init_dev() declaration change to patch 1
>>   * Added John's review tag
>>
>> Damien Le Moal (3):
>>    scsi: libsas: Move local functions declarations to sas_internal.h
>>    scsi: libsas: Declare sas_set_phy_speed() static
>>    scsi: libsas: Declare sas_discover_end_dev() static
>>
>>   drivers/scsi/libsas/sas_discover.c |  2 +-
>>   drivers/scsi/libsas/sas_init.c     |  4 ++--
>>   drivers/scsi/libsas/sas_internal.h | 12 ++++++++++++
>>   include/scsi/libsas.h              | 17 -----------------
>>   4 files changed, 15 insertions(+), 20 deletions(-)
>>
> 
> When applying the patches checkpatch.pl spits out this warning:
> 
> Applying: scsi: libsas: Move local functions declarations to sas_internal.h
> WARNING:FUNCTION_ARGUMENTS: function definition argument 'struct 
> asd_sas_port *' should also have an identifier name
> #16: FILE: drivers/scsi/libsas/sas_internal.h:49:
> +void sas_discover_event(struct asd_sas_port *, enum discover_event ev);
> 
> total: 0 errors, 1 warnings, 46 lines checked
> 
> Other than the above nit:
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Thanks. Sent v3 to fix that, and also a repeated word in the commit message of
patch 3 that checkpatch complains about.

-- 
Damien Le Moal
Western Digital Research

