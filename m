Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A6AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jul 2022 17:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbiGVRZ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jul 2022 13:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbiGVRZ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2022 13:25:57 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B9F6FA1A
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 10:25:56 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id h132so4935339pgc.10
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 10:25:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vNtC/Amka/A4EmQjT716Q+s18p5c+y4mC2kaY9unNRk=;
        b=sZiHrMrsuzSzZFEwrDEA4TOewileG3KwtuTgCdY99A0lw5q5SNjzP1lr3pctdAxsyx
         p76jBrgBsKKJ5MjBO31rSRHUcTJeiIYXhZqixf52TiMEDR7HXe6yghqMepWz97b3swGF
         RMKwU/LFuK0KUUE1I/IZiTyKKUqLuPI8c3RrVV3JvYc19xSNrdENPyplw1gRP9Su1D9q
         bAXJM3gTll6TzhLKCiQDgtCU6sEYSF5eoKH9Yw46B/0eX2g0BmtghchHsr1FqX+rNdpW
         sOijCPMPXWVXAKshNSOFChD/cmoNCUUeDQzkov5ieyveEhTAU7pFS6A2DHGIkpznK7BY
         26PQ==
X-Gm-Message-State: AJIora+/rCQttD1J6Ju33HS2MjfGpJl4VxSVrMaQznr8I43vXprPF8q1
        URxGJJjpJfHefSkQ24wIo+c=
X-Google-Smtp-Source: AGRyM1tN5x5eru0NF8xcUbh2Tbt9/OkF7O1xYMxLaO3ZbKqUPQVKKdsF/GFVdIG7SdRp3rEDO++cmA==
X-Received: by 2002:a63:3f0d:0:b0:41a:63d7:792b with SMTP id m13-20020a633f0d000000b0041a63d7792bmr720354pga.370.1658510755560;
        Fri, 22 Jul 2022 10:25:55 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9cf6:7e29:d977:6fc7? ([2620:15c:211:201:9cf6:7e29:d977:6fc7])
        by smtp.gmail.com with ESMTPSA id p1-20020a654bc1000000b004148cbdd4e5sm3681126pgr.57.2022.07.22.10.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 10:25:54 -0700 (PDT)
Message-ID: <fccd4287-2919-69de-c2ee-bedc46a19848@acm.org>
Date:   Fri, 22 Jul 2022 10:25:52 -0700
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
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575FA4433A6743D5940DAB7FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/22/22 01:30, Avri Altman wrote:
>> Measurements have shown that for some UFS devices the maximum
>> sequential
>> I/O throughput is achieved with a transfer size above 512 KiB. Hence
>> increase the maximum size of the data buffer associated with a single
>> request from SCSI_DEFAULT_MAX_SECTORS (1024) * 512 bytes = 512 KiB
>> into
>> 1 GiB.
 >
> Did you choose 1GB to align with BLK_DEF_MAX_SECTORS?

No particular reason.

> Can you share those performance measurements?
> For some reason, I always thought that SR performance is saturated somewhere around 1MB.

That's also what I see on my test setup (I only tried one UFS brand - 
results may differ for other UFS device brands):

$ i=12; while ((i<=30)); do ./fio --rw=read --ioengine=psync --direct=1 
--ioscheduler=none --size=100% --time_based=1 --runtime=30 
--filename=/dev/block/sda --name=ufs --gtod_reduce=1 --bs=$((1<<i)); 
((i++)); done 2>&1 | grep read:
   read: IOPS=3714, BW=14.5MiB/s (15.2MB/s)(435MiB/30017msec)
   read: IOPS=2659, BW=20.8MiB/s (21.8MB/s)(623MiB/30003msec)
   read: IOPS=2488, BW=38.9MiB/s (40.8MB/s)(1167MiB/30016msec)
   read: IOPS=2102, BW=65.7MiB/s (68.9MB/s)(1972MiB/30006msec)
   read: IOPS=1635, BW=102MiB/s (107MB/s)(3068MiB/30019msec)
   read: IOPS=1630, BW=204MiB/s (214MB/s)(6120MiB/30035msec)
   read: IOPS=1228, BW=307MiB/s (322MB/s)(9232MiB/30061msec)
   read: IOPS=752, BW=376MiB/s (395MB/s)(11.0GiB/30008msec)
   read: IOPS=472, BW=473MiB/s (496MB/s)(13.9GiB/30043msec)
   read: IOPS=107, BW=216MiB/s (226MB/s)(6524MiB/30249msec)
   read: IOPS=66, BW=267MiB/s (280MB/s)(8184MiB/30666msec)
   read: IOPS=38, BW=305MiB/s (319MB/s)(9200MiB/30210msec)
   read: IOPS=18, BW=292MiB/s (306MB/s)(9184MiB/31454msec)
   read: IOPS=9, BW=302MiB/s (316MB/s)(9.94GiB/33731msec)
   read: IOPS=5, BW=326MiB/s (342MB/s)(11.9GiB/37278msec)
   read: IOPS=2, BW=277MiB/s (290MB/s)(15.8GiB/58277msec)
   read: IOPS=1, BW=302MiB/s (316MB/s)(15.5GiB/52626msec)
   read: IOPS=0, BW=284MiB/s (298MB/s)(31.0GiB/111736msec)

Bart.
