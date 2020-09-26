Return-Path: <SRS0=SrIF=DD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3880C4741F
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 14:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A09A3208A9
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 14:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RiKSMVrS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgIZOSB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Sep 2020 10:18:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726244AbgIZOSB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 26 Sep 2020 10:18:01 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601129880;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M3C2rzUfmTv9LIjiD5/Deh9yM3/rtsekjDrjAJPBZpA=;
        b=RiKSMVrSdCcm5pvQvfuDsqvtdMVcLByu+X3AvB1J61FTDWVH78sLGi5O/Py/9ptBCaK9R+
        odu6pUPfDICbujjVun3wE4WKkAJ44OExZfvFGBAtCCrPB8TwhJlcwVs7hdkCCu9HljaQKw
        8vzepTu9gdIZvmFdVvY6lbEgCFuo4zo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-xQIMg37GPWmWL8qEVtf6DQ-1; Sat, 26 Sep 2020 10:17:56 -0400
X-MC-Unique: xQIMg37GPWmWL8qEVtf6DQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B07FC801AC3;
        Sat, 26 Sep 2020 14:17:55 +0000 (UTC)
Received: from [10.10.110.11] (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B291D55787;
        Sat, 26 Sep 2020 14:17:54 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [v5 07/12] libata: Make ata_scsi_durable_name static
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-8-tasleson@redhat.com>
 <ec0479bf-e5ac-58f1-248a-2d4c29ae3efa@gmail.com>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <b95e0b6f-dcc1-8032-ebcd-29ae594fcbaf@redhat.com>
Date:   Sat, 26 Sep 2020 09:17:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <ec0479bf-e5ac-58f1-248a-2d4c29ae3efa@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/26/20 3:40 AM, Sergei Shtylyov wrote:
> Hello!
> 
> On 25.09.2020 19:19, Tony Asleson wrote:
> 
>> Signed-off-by: Tony Asleson <tasleson@redhat.com>
>> Signed-off-by: kernel test robot <lkp@intel.com>
>> ---
>>   drivers/ata/libata-scsi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 194dac7dbdca..13a58ed7184c 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -1086,7 +1086,7 @@ int ata_scsi_dev_config(struct scsi_device
>> *sdev, struct ata_device *dev)
>>       return 0;
>>   }
>>   -int ata_scsi_durable_name(const struct device *dev, char *buf,
>> size_t len)
>> +static int ata_scsi_durable_name(const struct device *dev, char *buf,
>> size_t len)
> 
>    Why not do it in patch #6 -- when introducing the function?

This issue was found by the intel kernel test robot in v4 patch series.
I thought it was better to have a separate commit with the correction
that matched it's signed off.  Maybe that's not the correct approach?


