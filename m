Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE41C6FD1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 15:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjCOPzg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 11:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjCOPzH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 11:55:07 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139B2848C2
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 08:54:35 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id p20so20488550plw.13
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 08:54:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678895626;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qu4WhA26wSXYFRb+Ufj6UBCCb/2XdBSZ2P72TmRQ4u4=;
        b=Je+yOCRmI6Aq/h1JJcZ0rRLBwsPy1Cudl3RrZxJ252+scFQVkQ5T2lc8YaiQIAyj/L
         9tITVlMDKsBua2BkofSeuhFIHWS4QNv9WV0xY2BbsT0lFAnZvzH1pw8KZlSi5A1S5GZg
         7KuoH4sgRwyuL5zZ2Hfuqh50C5/ehCsHIzGHc14FZYRsfs5U/3Bc92CO9cmarMLzdMgW
         Q+4wtD/i6jioSFT+K/4ExmRbJ/QodkkOV2AOj8/cIMYJncZfWE3uLNRy5gLx39Vy8yvj
         v6sZzCoMtwKV3AsppIGG4lt2y8nFlz7otBnZMq0Xg1k5YKC95Qj9BlfUIUHt+uhfL9Bu
         E33Q==
X-Gm-Message-State: AO0yUKV/FhPg/uLlLJf+27bvi0NZSOh5tuzs7OFLmDgFvYNE0rNRqVgH
        Qf3nESqI1eVKSIeFwrwXJ9s=
X-Google-Smtp-Source: AK7set/txq87u+/Ko5rJajFpLIFhgC6xCJYtDOugFYEKgFiowmfjZ9es3dNY+JMiq9LGRklFiZQSUA==
X-Received: by 2002:a05:6a20:e688:b0:c7:6cb7:cfbf with SMTP id mz8-20020a056a20e68800b000c76cb7cfbfmr280965pzb.10.1678895625807;
        Wed, 15 Mar 2023 08:53:45 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:558a:e74:a7b9:2212? ([2620:15c:211:201:558a:e74:a7b9:2212])
        by smtp.gmail.com with ESMTPSA id i17-20020aa787d1000000b005897f5436c0sm3721158pfo.118.2023.03.15.08.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 08:53:45 -0700 (PDT)
Message-ID: <09ed808a-b697-37fc-8bec-c4da6be1382c@acm.org>
Date:   Wed, 15 Mar 2023 08:53:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/2] scsi: ufs: core: Disable the reset settle delay
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
References: <20230314205822.313447-1-bvanassche@acm.org>
 <DM6PR04MB6575689FC234B87CD997F474FCBF9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575689FC234B87CD997F474FCBF9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/15/23 06:43, Avri Altman wrote:
>> Neither UFS host controllers nor UFS devices require a ten second delay
>> after a host reset or after a bus reset. Hence this patch.
>
> Bus reset handler is not implemented for ufs.

Hi Avri,

Do you perhaps want me to remove the reference to "bus reset" from the 
patch description?

Thanks,

Bart.

