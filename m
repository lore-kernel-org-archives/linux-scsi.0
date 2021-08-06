Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812B9C4320E
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 14:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66FB860F14
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 14:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbhHFOeO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 10:34:14 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:24349 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239972AbhHFOeK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 10:34:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628260435; x=1659796435;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=xfPISnz+lDrC+RzZtNwvQ0ZeCU/HWjMV/n+gpksdiUQ=;
  b=e8tdrGzfpukXFG3ocHtQVSEDOKQBj9hddeRYJccyAe4xrqYA4G6ib0Za
   GqibDastFEPstZeoMnmtqRBAGCmvzxTAVEY6LWVyKN3fA1V663A28FcyS
   3U+LPFJIHtQ8wszHtEIbGGmPWC4DRj1muzhmOr+hdZWVWVFKmqMCTkqMx
   T5fzxbBOB0Q9xVGQBO3Dw6F27x/406/vVJhFBtKurt+Wl77ADV/Gtir0F
   B5Sv5MzR1g8k5OWhI8aozYvcXBA0CrrxVSD9kiLP5P4EUIvUj8Z7/2iF6
   9f4l5dVcmjLeuFJ2NjIDLnFg213i6QESQ5mA58xX0UHlI4sh6Gp2cdTN+
   A==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="175719438"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 22:33:54 +0800
IronPort-SDR: d5bwVF9BhhY4i6CUBM6lF7crxZNb8CxIW6d2JxN/iRjPBScUOawGLTw7YMTNzwwiBzC+DobL5k
 Sy7Qu8cDUtGmaK4HTnOMu7qXKBVedVII3g38CKkv5UWaZ/vXszdS9f91BS9w3bboASUo74+tcj
 sQJk+YcpOW2aYjDqsTdtToyDkkb0hemBKHIXPARVGM1DzZaIqQUD0qJIIBJcjVx4COsBFVXHkT
 izK9WyTB2xmcEPpRNRhAJbBFeM1akdWJ/AeApY51ZMDdFJRbLgTQz7N0DTWJWgvBd1TPLs9yuT
 XkxBmYZtKcvoVfQYs1PU5sN7
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 07:11:22 -0700
IronPort-SDR: 1vYBdPIsfi++GtVO6eS8fmsrt8hI62wPc4kQiTQ7+Ky4+d4KVanUeAB6XGWHtE4SSsGoX5bqvn
 FzDGfCLp5uEGTJzBtnvVJob9xSc+g4GUoBRgmtynblQishRCfT4sETqCcgd4a7C/8hRcg/q3pW
 rc2K2Aks9yIDXhQB9zGc5c7OXuJDsoZQMoBjZR1EKTywVYI5TL8bhvCfu93U/hSfMnEMyfk/sn
 7yv+aH7jAHyVlMSBCwsdxXdZr6d+kl/YAuUdB7bn5koI16ROGjkGPjSxnB6F8TMGCNBHbCHNG1
 730=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 07:33:55 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Gh7Jf0fFyz1RvlN
        for <linux-scsi@vger.kernel.org>; Fri,  6 Aug 2021 07:33:53 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-language
        :content-type:in-reply-to:mime-version:user-agent:date
        :message-id:organization:from:references:to:subject; s=dkim; t=
        1628260433; x=1630852434; bh=xfPISnz+lDrC+RzZtNwvQ0ZeCU/HWjMV/n+
        gpksdiUQ=; b=p6/ogsj1ytgEyeCtVw9Ds5t0qwjXAocD/Z1bU5tpIv/lwjgYaYi
        Rz2J9v6QjQYFPJZB+jSP4pr6X8TZWU/v/OGJP6YkpzKOoeQoM9y2L8he73sMKBxu
        Huy8eyc4PifgRewedPTojrkFz5ILHGMy1bAkERQ1LsyvWYk2kPJZ6zovVZ6yHHtj
        +FwwVgdqDEUCuUCGb5xdGOQLmRt9IYt4hEsZETqykiWkCQWHGF7vHPWY+YVDQ0lw
        sxOXN1Ao/4cw8pn1DboBDDyhCAtnTUUlGk7MYwwaZ6kC1nifNn7BIUcHF4zNA67w
        mM05GDZSK/EiPaixaSZNLRS98n5YiGky/hA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6t_2VCOmB5A3 for <linux-scsi@vger.kernel.org>;
        Fri,  6 Aug 2021 07:33:53 -0700 (PDT)
Received: from [10.225.48.54] (unknown [10.225.48.54])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Gh7Jb6qldz1RvlC;
        Fri,  6 Aug 2021 07:33:51 -0700 (PDT)
Subject: Re: [PATCH v2 2/9] libata: fix ata_host_start()
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
 <20210806074252.398482-3-damien.lemoal@wdc.com>
 <1dca71ad49be897f9544d0de59204e42a5b56a50.camel@HansenPartnership.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
Message-ID: <5ff8b910-7fef-fa5b-a6b5-8094e3e73ae0@opensource.wdc.com>
Date:   Fri, 6 Aug 2021 23:33:50 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1dca71ad49be897f9544d0de59204e42a5b56a50.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/06 23:31, James Bottomley wrote:
> On Fri, 2021-08-06 at 16:42 +0900, Damien Le Moal wrote:
>> The loop on entry of ata_host_start() may not initialize host->ops to
>> a non NULL value. The test on the host_stop field of host->ops must
>> then be preceded by a check that host->ops is not NULL.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>> ---
>>  drivers/ata/libata-core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index ea8b91297f12..fe49197caf99 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -5573,7 +5573,7 @@ int ata_host_start(struct ata_host *host)
>>  			have_stop = 1;
>>  	}
>>  
>> -	if (host->ops->host_stop)
>> +	if (host->ops && host->ops->host_stop)
> 
> since have_stop was already set by the port ops, surely this entire if
> is redundant?

Will check.

> 
> James
> 
> 


-- 
Damien Le Moal
Western Digital Research
