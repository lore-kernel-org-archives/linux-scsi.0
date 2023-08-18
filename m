Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A690FC71132
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 00:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356487AbjHRAJM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 20:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356634AbjHRAJF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 20:09:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DA23C15
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 17:08:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2AA462FFF
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2023 00:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC290C433C7;
        Fri, 18 Aug 2023 00:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692317308;
        bh=JMXywPqL5r+3mARNxpzbH8PKm0oXiYzxNXxnXtT6xWY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VMnikuesqEabcgrUlhFFGmPBqUc8jZYMad7LPmSW28qAGsUDoZDUfrcA4tN0ZKEHq
         OBMBWMXfqww9MLJvbBYcxOmIBO47UOhpTpiXNJekepFCh7md7V15uZ+vztATR0U5dh
         j4FuAO0G5dg3pKax3D33faHj6JyCzBoTetmqNDJHbv9or69yhMIRlG50TRpuKy20Cc
         CkZOtzWhD0l/1QpyGASNhNotfXS5Wca9PLbGZ9pAXt2STfswqYYUK4CkXRCSElRxCu
         X+sw75J03160qEAGaXtMViL5H/Dbxzztxupxr6Pi6SejvgbjDrf5apEAx4r+tu96nr
         j6I9eAr7ArU2Q==
Message-ID: <4e139042-948e-1bab-4c43-02a309ccf357@kernel.org>
Date:   Fri, 18 Aug 2023 09:08:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH 2/3] scsi: libsas: Add return_fis_on_success to
 sas_ata_task
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Igor Pylypiv <ipylypiv@google.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
References: <20230817214137.462044-1-ipylypiv@google.com>
 <20230817214137.462044-2-ipylypiv@google.com> <ZN6vB0COt0eJU93A@x1-carbon>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZN6vB0COt0eJU93A@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/08/18 8:36, Niklas Cassel wrote:
> On Thu, Aug 17, 2023 at 02:41:36PM -0700, Igor Pylypiv wrote:
> 
> Hello Igor,
> 
>> For Command Duration Limits policy 0xD (command completes without
>> an error) libata needs FIS in order to detect the ATA_SENSE bit and
>> read the Sense Data for Successful NCQ Commands log (0Fh).
>>
>> Set return_fis_on_success for commands that have a CDL descriptor
>> since any CDL descriptor can be configured with policy 0xD.
>>
>> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
>> ---
>>  drivers/scsi/libsas/sas_ata.c | 3 +++
>>  include/scsi/libsas.h         | 1 +
>>  2 files changed, 4 insertions(+)
>>
>> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
>> index 77714a495cbb..da67c4f671b2 100644
>> --- a/drivers/scsi/libsas/sas_ata.c
>> +++ b/drivers/scsi/libsas/sas_ata.c
>> @@ -207,6 +207,9 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
>>  	task->ata_task.use_ncq = ata_is_ncq(qc->tf.protocol);
>>  	task->ata_task.dma_xfer = ata_is_dma(qc->tf.protocol);
>>  
>> +	/* CDL policy 0xD requires FIS for successful (no error) completions */
>> +	task->ata_task.return_fis_on_success = ata_qc_has_cdl(qc);
> 
> In ata_qc_complete(), for a successful command, we call fill_result_tf()
> if (qc->flags & ATA_QCFLAG_RESULT_TF):
> https://github.com/torvalds/linux/blob/v6.5-rc6/drivers/ata/libata-core.c#L4926
> 
> My point is, I think that you should set
> task->ata_task.return_fis_on_success = ata_qc_wants_result(qc);
> 
> where ata_qc_wants_result()
> returns true if ATA_QCFLAG_RESULT_TF is set.

I do not think we need that helper. Testing the flag directly would be fine.
If you really insist on introducing the helper, then at least go through libata
and replace all direct tests of that flag with the helper. But I do not think it
is worth the churn.

> 
> (ata_set_tf_cdl() will set both ATA_QCFLAG_HAS_CDL and ATA_QCFLAG_RESULT_TF).
> 
> That way, e.g. an internal command (i.e. a command issued by
> ata_exec_internal_sg()), which always has ATA_QCFLAG_RESULT_TF set,
> will always gets an up to date tf status and tf error value back,
> because the SAS HBA will send a FIS back.
> 
> If we don't do this, then libsas will instead fill in the tf status and
> tf error from the last command that returned a FIS (which might be out
> of date).
> 
> 
>> +
>>  	if (qc->scsicmd)
>>  		ASSIGN_SAS_TASK(qc->scsicmd, task);
>>  
>> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
>> index 159823e0afbf..9e2c69c13dd3 100644
>> --- a/include/scsi/libsas.h
>> +++ b/include/scsi/libsas.h
>> @@ -550,6 +550,7 @@ struct sas_ata_task {
>>  	u8     use_ncq:1;
>>  	u8     set_affil_pol:1;
>>  	u8     stp_affil_pol:1;
>> +	u8     return_fis_on_success:1;
>>  
>>  	u8     device_control_reg_update:1;
>>  
>> -- 
>> 2.42.0.rc1.204.g551eb34607-goog
>>
> 
> Considering that libsas return value is defined like this:
> https://github.com/torvalds/linux/blob/v6.5-rc6/include/scsi/libsas.h#L507
> 
> Basically, if you returned a FIS in resp->ending_fis, you should return
> SAS_PROTO_RESPONSE. If you didn't return a FIS for your command, then
> you return SAS_SAM_STAT_GOOD (or if it is an error, a SAS_ error code
> that is not SAS_PROTO_RESPONSE, as you didn't return a FIS).
> 
> Since you have implemented this only for pm80xx, how about adding something
> like this to sas_ata_task_done:
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 77714a495cbb..e1c56c2c00a5 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -114,6 +114,15 @@ static void sas_ata_task_done(struct sas_task *task)
>                 }
>         }
>  
> +       /*
> +        * If a FIS was requested for a good command, and the lldd returned
> +        * SAS_SAM_STAT_GOOD instead of SAS_PROTO_RESPONSE, then the lldd
> +        * has not implemented support for sas_ata_task.return_fis_on_success
> +        * Warn about this once. If we don't return FIS on success, then we
> +        * won't be able to return an up to date TF.status and TF.error.
> +        */
> +       WARN_ON_ONCE(ata_qc_wants_result(qc) && stat->stat == SAS_SAM_STAT_GOOD);
> +
>         if (stat->stat == SAS_PROTO_RESPONSE ||
>             stat->stat == SAS_SAM_STAT_GOOD ||
>             (stat->stat == SAS_SAM_STAT_CHECK_CONDITION &&
> 
> 
> 
> 
> Kind regards,
> Niklas

-- 
Damien Le Moal
Western Digital Research

