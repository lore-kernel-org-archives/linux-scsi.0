Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CBEC64EC4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 06:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCJGJO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 01:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCJGJL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 01:09:11 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDFA10286C
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 22:09:09 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id p6so4568592plf.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 22:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678428549;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:cc:references:to:subject:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y/IZ6WB6TNn5D0vZ7j9+HvhZ/9SlIQgxNI1z3mLRbqA=;
        b=DOOArH86qcla0LR6zOUr1yl/Tod89QhcwmA2yGbuK97clXEEYDgm94fR0N5LhvuAum
         02Sh4zTvc7M6ClzHkrKLKtXcXKGs0aU3YOhi34qO/xuKBUo17iXTdHP8Q7x3Mf6pSF7A
         5nG6z7RF8uBIosaoTLHUguSWTqP+NSzKNdGCY29GjSI6U1zjkLVqGsbxaghAyt7MxjiP
         rlPkY66/IKJHhwKrwQgDS6t+OGm3y6o67pQ1dalSDPOgnuWHjxc2uwZk1katucNHuYmY
         a2vykrDfkIK4aVqHStdRAHLESQUYK5/yk9IWP5itD3A0NqoIAGWcovIME1RNyIwNr3sP
         +M7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678428549;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:cc:references:to:subject:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y/IZ6WB6TNn5D0vZ7j9+HvhZ/9SlIQgxNI1z3mLRbqA=;
        b=CEN52fKwqIzVd+pfwePbOpxDpxIIHorTqs4HlkZInlvTTsRY8XI4MY5SdLmclHqx1F
         37+Fd/KL+m6vjbW+gyuiQDuBPbgZrR2ZG7X4Av/0WKOZOxwr9uGngGgiaePKPVS2lI/M
         xg0plekmjy+JBl4wW+th83pTpa6XzIc0OTKI/hWJgq9oTOjPzXCLQba+GEMQFKYtGO0K
         e7MySuF/+gXuT+0kpbdxmfF1vqi1ByHjdpJO1ymemfx/yl3DQ+m8BlwfxFXmIOCe1/ql
         gNqhk8GTS6pJMcsTLPa/ti0FV0n5gk2qKeIRNXyUpNCyoFlun0LFRDgjaE6zNIzJfjYe
         3b9A==
X-Gm-Message-State: AO0yUKUGOqDS3TBJYbbuEvkzSJZSiTEc9Uokmlw3QzgSmu9efMAdQp/z
        INXBwLWutnUj1ufd1qAgkWC5HAcbSq4=
X-Google-Smtp-Source: AK7set/HtSHgn5fWkFcUAecer5I9q9Q6Y3RU6+PM8luNVlKdA2J8VHv67HdG6XPspOkz8C9MLc1J0A==
X-Received: by 2002:a17:902:efce:b0:192:4f85:b91d with SMTP id ja14-20020a170902efce00b001924f85b91dmr21360086plb.46.1678428549191;
        Thu, 09 Mar 2023 22:09:09 -0800 (PST)
Received: from [10.1.1.24] (222-152-221-232-adsl.sparkbb.co.nz. [222.152.221.232])
        by smtp.gmail.com with ESMTPSA id f3-20020a17090274c300b0019ca7b7a684sm589433plt.161.2023.03.09.22.09.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Mar 2023 22:09:08 -0800 (PST)
Subject: Re: [PATCH v2 51/82] scsi: mac_scsi: Declare SCSI host template const
To:     Finn Thain <fthain@linux-m68k.org>,
        Bart Van Assche <bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
 <20230309192614.2240602-52-bvanassche@acm.org>
 <ad89ffce-8cb0-a7b1-887c-2c513e7ea5b2@linux-m68k.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <e03dcd85-15cd-5cd7-7845-89086748d613@gmail.com>
Date:   Fri, 10 Mar 2023 19:09:03 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <ad89ffce-8cb0-a7b1-887c-2c513e7ea5b2@linux-m68k.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

Am 10.03.2023 um 17:46 schrieb Finn Thain:
> On Thu, 9 Mar 2023, Bart Van Assche wrote:
>
>> Make it explicit that the SCSI host template is not modified.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>  drivers/scsi/mac_scsi.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
>> index 2e511697fce3..1d13f1ebc094 100644
>> --- a/drivers/scsi/mac_scsi.c
>> +++ b/drivers/scsi/mac_scsi.c
>> @@ -422,7 +422,7 @@ static int macscsi_dma_residual(struct NCR5380_hostdata *hostdata)
>>  #define DRV_MODULE_NAME         "mac_scsi"
>>  #define PFX                     DRV_MODULE_NAME ": "
>>
>> -static struct scsi_host_template mac_scsi_template = {
>> +struct scsi_host_template mac_scsi_template = {
>>  	.module			= THIS_MODULE,
>>  	.proc_name		= DRV_MODULE_NAME,
>>  	.name			= "Macintosh NCR5380 SCSI",
>>
>
> I think something went wrong there. No change is needed for
> mac_scsi_template as it can't be made const.

I concur - and hope there wasn't a similar patch to atari_scsi.c (that 
one's host template is also modified during probe).

Cheers,

	Michael

