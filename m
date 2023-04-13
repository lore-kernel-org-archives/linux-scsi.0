Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8076C77B61
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Apr 2023 07:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjDMHt7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Apr 2023 03:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjDMHtv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2023 03:49:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC649752
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2023 00:49:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B210C63C22
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2023 07:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF85C4339B;
        Thu, 13 Apr 2023 07:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681372163;
        bh=VRMaZtbAhiyqbRhRW0/8AxhfoS98Xb+4pypSA2l7Sao=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bdV1vlrrsECmDKuft0kfCUk2yEZjaLM+pZ5ZJI6kPLmr+Pk84i7HqM8Q1FqBRYdN8
         gnMYDp+VUI5Tz1GZ5YgKsz2CXPlGBv2TC/veinGln+2CDeqIpczo5kB/IyIlC4mrCw
         pr65qytwgCdhVQnO/Ijw5WkM1p80QimOgTR1NVTCR9vtovJMSrQTHkKWvtMMsVO24w
         YfhNnlOsnWIgluzQa3psm3bjdN86EAlidl33YM8Vs2yiJw8fA1tSDLN10MezLhrFB6
         SavrGNsdnUielZPkTuAIOaJDidQjIwaLA/u8ObHYKEoDrF0uzZdffFUSKaJ7ahB9fW
         IMkIOxusa+41w==
Message-ID: <91517007-5a82-4f66-219a-5f1cbedad22f@kernel.org>
Date:   Thu, 13 Apr 2023 16:49:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] ipr: Remove SATA support
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        wenxiong@linux.ibm.com
References: <20230412174015.114764-1-brking@linux.vnet.ibm.com>
 <a4f2f204-d14f-ddd4-eeb9-9d132e090de6@oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <a4f2f204-d14f-ddd4-eeb9-9d132e090de6@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/13/23 16:35, John Garry wrote:
> On 12/04/2023 18:40, Brian King wrote:
>> Linux SATA support in ipr has always been limited to SATA DVDs. The last
>> systems that had the option of including a SATA DVD was Power 8,
>> which have been withdrawn for sometime now, so this support can
>> be removed.
>>
>> Signed-off-by: Brian King<brking@linux.vnet.ibm.com>
>> ---
> 
> Thanks,
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
>> -#endif
>>   	.queuecommand = ipr_queuecommand,
>> -	.dma_need_drain = ata_scsi_dma_need_drain,
> 
> This would only be used by libsas now - maybe we should relocate it 
> there (from libata), but prob better not.

Given that with this patch, all ATA drivers will use ->error_handler, there are
lots of cleanups we can do. Let's work on that once this patch is queued !

