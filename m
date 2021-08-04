Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD875C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 15:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE0CB60EE9
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 15:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbhHDPJP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 11:09:15 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:58360
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236354AbhHDPJP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2021 11:09:15 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 328733F0FC;
        Wed,  4 Aug 2021 15:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628089741;
        bh=w8XV7w2n45SjiUVSnEHbqA1jcvtFXp2hov1ShVkQg8k=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=mEpAuy/XwuGuC/10SZHxdMskcUYTphpV64DVRbuPq9jaJxYtLMDKASnjL5ZZBdCqj
         JaRhDqdHHEpqNrpROK/mHJfPzKFqrvOxzflTAFkLSCkkEV1v4UEu8gjXAY7p8xORwN
         EyEIMT+n9nlKJIEjCNyd2YdomxXlcg8TRo41vCGex0HtJsUYOHpBhAaRd4mOFPZGgQ
         SDZIAyu3gD+kRAFfxc0gOt8QDtzuY8vH+HzbfSXQaULg9ArCnXVKoerQbkNrtWLgTg
         x4IhH0B6sMO7vimpxOkMu2hyPQoHBj2Fl/nCVk9iV43FSshKw8IROAM3wWiJ2M4VRK
         MUhxYutDRsq8A==
Subject: Re: [PATCH][next[next]] scsi: qla2xxx: Remove redundant
 initialization of variable num_cnt
To:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210804131344.112635-1-colin.king@canonical.com>
 <7ac5f319-fd4c-f2e0-e318-71a4d7661693@oracle.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <80e9bea5-2e4e-0d8a-5123-0ed7f72916be@canonical.com>
Date:   Wed, 4 Aug 2021 16:09:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <7ac5f319-fd4c-f2e0-e318-71a4d7661693@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/08/2021 16:08, Himanshu Madhani wrote:
> 
> 
> On 8/4/21 8:13 AM, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The variable num_cnt is being initialized with a value that is never
>> read, it is being updated later on. The assignment is redundant and
>> can be removed.
>>
>> Addresses-Coverity: ("Unused value")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>   drivers/scsi/qla2xxx/qla_edif.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_edif.c
>> b/drivers/scsi/qla2xxx/qla_edif.c
>> index fde410989c03..2db954a7aaf1 100644
>> --- a/drivers/scsi/qla2xxx/qla_edif.c
>> +++ b/drivers/scsi/qla2xxx/qla_edif.c
>> @@ -875,7 +875,7 @@ static int
>>   qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
>>   {
>>       int32_t            rval = 0;
>> -    int32_t            num_cnt = 1;
>> +    int32_t            num_cnt;
>>       struct fc_bsg_reply    *bsg_reply = bsg_job->reply;
>>       struct app_pinfo_req    app_req;
>>       struct app_pinfo_reply    *app_reply;
>>
> 
> Looks Good.
> 
> (I am curious if that extra "next" in patch subject was a typo or some
> workflow added that)

It was an accidental double paste. My bad.

> 
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> 

