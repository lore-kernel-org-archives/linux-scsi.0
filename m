Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5331AC4332B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 00:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 157BF64FCE
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 00:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhCKAx4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:53:56 -0500
Received: from gateway22.websitewelcome.com ([192.185.46.187]:32875 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229646AbhCKAxs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Mar 2021 19:53:48 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id AA1F714A8B
        for <linux-scsi@vger.kernel.org>; Wed, 10 Mar 2021 18:06:53 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id K8qrlH7ljkscSK8qrlEOd9; Wed, 10 Mar 2021 18:06:53 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tnn1NfTKvXdkVIEGC71LezrIsubA1kaJf3yIpzYvmrw=; b=e+baLI1+wGugzndicla0y8r6ra
        Bh3nfj10AzCJsqYjoN3r84Wk6xyuLEXoiaw54rMwj7wxfrfvRmaYcpNvCqgxHIPZ6FxplUcaHmrx/
        tUPUTJRLDTRcTWViV6FYLZucybJA1V4fs9ePe8EEAk9yM3n1PMNMpjAxNdyw4gQEnfaSWbfhKOBpl
        1MSEqsPSDcp98MDr9o1ENaAD21P9lG+Q8D/XAx61Lvt6P+ySxUz6QNHU7QEdSRFta8+9ogP95yN1X
        oztU4tiHrCeOShRuorn/P0H2HpoQwJDRD79wzaz8rQFSFQ6gL4DWeVfoVCuva0CsBfQtqw+f2gZjl
        lgm3fhLQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:36282 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lK8qr-004JNM-72; Wed, 10 Mar 2021 18:06:53 -0600
Subject: Re: [PATCH v2][next] scsi: mpt3sas: Replace one-element array with
 flexible-array in struct _MPI2_CONFIG_PAGE_IO_UNIT_3
To:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     James Bottomley <jejb@linux.ibm.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210202235118.GA314410@embeddedor>
 <20210308193237.GA212624@embeddedor>
 <88d9dda39a70df25b48e72247b9752d3dc5e2e8d.camel@linux.ibm.com>
 <20210308204129.GA214076@embeddedor> <202103101058.16ED27BE3@keescook>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <855e73f8-9b84-25b9-01e3-8ce368165b25@embeddedor.com>
Date:   Wed, 10 Mar 2021 18:06:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <202103101058.16ED27BE3@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lK8qr-004JNM-72
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:36282
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 9
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 3/10/21 13:07, Kees Cook wrote:

>> diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
>> index 43a3bf8ff428..d00431f553e1 100644
>> --- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
>> +++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
>> @@ -992,7 +992,7 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_1 {
>>   *one and check the value returned for GPIOCount at runtime.
>>   */
>>  #ifndef MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX
>> -#define MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX    (1)
>> +#define MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX    (36)
>>  #endif
>>
>>  typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_3 {
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
>> index 44f9a05db94e..23fcf29bfd67 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
>> @@ -3203,7 +3203,7 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
>>  {
>>         struct Scsi_Host *shost = class_to_shost(cdev);
>>         struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
>> -       Mpi2IOUnitPage3_t *io_unit_pg3 = NULL;
>> +       Mpi2IOUnitPage3_t io_unit_pg3;
>>         Mpi2ConfigReply_t mpi_reply;
>>         u16 backup_rail_monitor_status = 0;
>>         u16 ioc_status;
>> @@ -3221,16 +3221,10 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
>>                 goto out;
>>
>>         /* allocate upto GPIOVal 36 entries */
>> -       sz = offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);
>> -       io_unit_pg3 = kzalloc(sz, GFP_KERNEL);
>> -       if (!io_unit_pg3) {
>> -               rc = -ENOMEM;
>> -               ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: (%d) bytes\n",
>> -                       __func__, sz);
>> -               goto out;
>> -       }
>> +       sz = sizeof(io_unit_pg3);
>> +       memset(&io_unit_pg3, 0, sz);
> 
> I like this a lot. It makes the code way simpler.
> 
> Putting this on the stack makes it faster, and it's less than 100 bytes,
> which seems entirely reasonable.
> 
>>
>> -       if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, io_unit_pg3, sz) !=
>> +       if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, &io_unit_pg3, sz) !=
> 
> The only thing I can imagine is if this ends up doing DMA, which isn't
> allowed on the stack. However, in looking down through the call path,
> it's _copied_ into DMA memory, so this appears entirely safe.
>  
> Can you send this as a "normal" patch? Feel free to include:
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>

Done: https://lore.kernel.org/lkml/20210310235951.GA108661@embeddedor/

Thanks for the comments!
--
Gustavo
