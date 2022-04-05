Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A324C4321E
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 01:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445528AbiDFBIn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446086AbiDEPoI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 11:44:08 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F3A197516
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 07:11:02 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id p17so10994034plo.9
        for <linux-scsi@vger.kernel.org>; Tue, 05 Apr 2022 07:11:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AfX80H4reA9xbDm3dOu6K3Kk7MUVC5l2mGgKcs5eH3g=;
        b=cGtNNlUTbMtOIpjW+CZyPESoftErZ6tA5jcOo9qx8Pcpotr9H+E0n1CP5ka8Ah7kB2
         4ZgF7FfJ0kj7pMnLv5Atr6gNPQgU38ulTVlSun2tnD5nzpaaO2OwBX7Rt+jqCphliNar
         1fEbzZee8xTlGfC7Z1T7R16pRvmiaGM8AKCcp1jZbKn37/+t8pAPKWPBRZ3A6stFT739
         Ka2lMTSQvnmWWiaff2bm4Ka0n6W0RqSavSqeU9gdb2jFeXDEVHRwjQgnd1VqF0M8rTG6
         QJg1jAAy89G0UWp3ixbcbY88pKqwrJ+XG6dmPzC4MQP2T6XfOCXWnjgShkRZJULU6O//
         lWCg==
X-Gm-Message-State: AOAM530WIAQyB817RE61dv+NBkyma+ceJdvRkTlpKon4BxwWxKmad9Y+
        zS0JnsRT3iRNH01VIfOIVTM=
X-Google-Smtp-Source: ABdhPJxfCFy3ZYKU8w0it41VJ7Wp/7RC5ld7rt5Ty1Gcsv0RTJDaDupMK8JB1rEJPFXcDvZWByq3tA==
X-Received: by 2002:a17:90a:a82:b0:1c9:ef95:486 with SMTP id 2-20020a17090a0a8200b001c9ef950486mr4362339pjw.93.1649167861869;
        Tue, 05 Apr 2022 07:11:01 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id j18-20020a633c12000000b0038204629cc9sm13251654pga.10.2022.04.05.07.10.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:11:01 -0700 (PDT)
Message-ID: <2e588680-3913-a757-3fb9-70af6af93479@acm.org>
Date:   Tue, 5 Apr 2022 07:10:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 26/29] scsi: ufs: Split the ufshcd.h header file
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Bean Huo <beanhuo@micron.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Ulf Hansson <ulf.hansson@linaro.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-27-bvanassche@acm.org>
 <DM6PR04MB6575D4708E72D3E1BA4FDA1AFCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575D4708E72D3E1BA4FDA1AFCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/4/22 23:39, Avri Altman wrote:
>> diff --git a/drivers/scsi/ufs/ufshcd-priv.h b/drivers/scsi/ufs/ufshcd-priv.h
>> new file mode 100644 index 000000000000..4ceb0c63aa15
>> --- /dev/null
>> +++ b/drivers/scsi/ufs/ufshcd-priv.h
>> @@ -0,0 +1,277 @@
> License identifier & copyright?

I will add the same SPDX identifier as the one that occurs in ufshcd.h.

Thanks,

Bart.


