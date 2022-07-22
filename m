Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C782CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jul 2022 17:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbiGVRdz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jul 2022 13:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235065AbiGVRdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2022 13:33:53 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3303788CE4
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 10:33:53 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id c139so5033888pfc.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 10:33:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LsNJ0WhmOReguy+4H0FMoDzLavslkh2zlIo4DGoPRPI=;
        b=21odKPB7ulEB3st3MQ8N6CeMr7tvAejiVQcZ9ErSF7lOCCLDSnFUWDTBBPPe/SvOwm
         Xm23VduSpKkLbZpdc2Pz/ieZaybtFaFIP5eFxQw8/+6W7xzH8Kp0fzyb1DpKVb9ZTRyS
         QPd6HkyLp2cxGG2SC7PkD6bijiGJjr2QMHPYsVElAc2QmJxWZUPHUyxOhJgATEjn6Mks
         VeaB/oIMkt0xTzaGd+VdrF4zhFkgAjHNdN8xx0mzqhYukQmc2LkzakT8B5jBq8/QOEk/
         TRh18QzfsxP8z7YmHAnii1hrI/LsbwW+LudviWB5RH84Xq2TYr7JyKFWeO7DJGGXHa7K
         pN1g==
X-Gm-Message-State: AJIora9eOHwmmfBgtiYG1PoHhP1sF9iVnkWlPnAda+R50vJXVg2b4/Cs
        PcCkEFcY3/Fc24po9mL8NJI=
X-Google-Smtp-Source: AGRyM1thBaovh3zAkOVWcFZVcfAT3eLLX0m9cVuCtw0mvKFai9lsgF3fitRT5K6ibXENPhPMQD0gdg==
X-Received: by 2002:a63:f143:0:b0:41a:3744:8639 with SMTP id o3-20020a63f143000000b0041a37448639mr746470pgk.254.1658511232508;
        Fri, 22 Jul 2022 10:33:52 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9cf6:7e29:d977:6fc7? ([2620:15c:211:201:9cf6:7e29:d977:6fc7])
        by smtp.gmail.com with ESMTPSA id s18-20020a170902ea1200b0016bf9437766sm4035990plg.261.2022.07.22.10.33.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 10:33:51 -0700 (PDT)
Message-ID: <69a25298-5c2b-6efc-2a5a-9a2409d69b4b@acm.org>
Date:   Fri, 22 Jul 2022 10:33:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] scsi: ufs: Increase the maximum data buffer size
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
References: <20220720170323.1599006-1-bvanassche@acm.org>
 <DM6PR04MB6575FA4433A6743D5940DAB7FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
 <DM6PR04MB6575D4AE8FC800F0A7429AA8FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575D4AE8FC800F0A7429AA8FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/22/22 03:19, Avri Altman wrote:
>>> Note: the maximum data buffer size supported by the UFSHCI specification
>>> is 65535 * 256 MiB or about 16 TiB.
 >
> Can you help me find this limit in UFSHCI?

 From the UFSHCI 3.0 specification:
* PRDT length is a sixteen bit field so the maximum value is 65535 
(entries).
* The maximum length of a single descriptor is 256 KiB. See also the DBC 
(Data Byte Count) field.

So the maximum amount of data that can be transferred at once is 65535 * 
256 KiB or about 16 GiB (and not what I wrote in my previous message).

Thanks,

Bart.
