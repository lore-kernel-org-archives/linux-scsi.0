Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A675C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 14:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242164AbhK3O3c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 09:29:32 -0500
Received: from mail-pj1-f49.google.com ([209.85.216.49]:43842 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242153AbhK3O3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 09:29:31 -0500
Received: by mail-pj1-f49.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso17373977pjb.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 06:26:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0rB8s+VVUZvPJ26Tk4n1MQpLZPMTESs2WgtZWF3mlRU=;
        b=71puSKASxUpwiFz67/HL8AXJfrpQr1DBqWPM1R5PZZO2MtLXoSh07ajzvXmC0LskZ1
         O+AKS9hkVElBqYa+pzjHKUpC4c3ppP9CwNxXAjtfg+L/LOTj+NIVch8rfD5tzeaJzXSP
         ik1STQNrWoz86vSuvg5pF/T65pir3YLEtRkrVoEMX2oDq25FhZkvL5wE03/fbH6EIOoG
         RdkX6dG+JZgnd+7F+AcirZnN93qtth0kn47cdMRLcvs3mbLsQKrJFB3pJi2WwLqC5ESH
         vWD3OPddTetl1OyMWq1X44DLjZz1xWJRtNfS7PpZernsfN4ehdEJmqAljufJjSc7p0LI
         QDgA==
X-Gm-Message-State: AOAM533fAmaXEpmG4GJZsD9+NE5/8XfIqm24iGOc7p6Hq9NqF1gDqNuY
        a00HS3sM4w1pu3pSsUCL7EUDZe1cXLU=
X-Google-Smtp-Source: ABdhPJyW1I1+1BCROri5YDujF0ifwSarlOKu8pTrXqHhJJHGroAtk2FCq2Xcjsz5RYHzNb+x5g47ZQ==
X-Received: by 2002:a17:90a:49c2:: with SMTP id l2mr6477010pjm.23.1638282372171;
        Tue, 30 Nov 2021 06:26:12 -0800 (PST)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i185sm20604259pfg.80.2021.11.30.06.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 06:26:11 -0800 (PST)
Subject: Re: [PATCH v2 19/20] scsi: ufs: Implement polling support
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-20-bvanassche@acm.org>
 <e0dc15c742c2f626a7149c3c44d53493fe1a9a44.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <deeb660e-d1ef-7a54-6221-45cfebd87881@acm.org>
Date:   Tue, 30 Nov 2021 06:26:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <e0dc15c742c2f626a7149c3c44d53493fe1a9a44.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/21 12:43 AM, Bean Huo wrote:
> On Fri, 2021-11-19 at 11:57 -0800, Bart Van Assche wrote:
>> On my test setup this patch increases IOPS from 2736 to 22000 (8x)
>> for the
>> following test:
>>
>> for hipri in 0 1; do
>>      fio --ioengine=io_uring --iodepth=1 --rw=randread \
>>      --runtime=60 --time_based=1 --direct=1 --name=qd1 \
>>      --filename=/dev/block/sda --ioscheduler=none --gtod_reduce=1 \
>>      --norandommap --hipri=$hipri
>> done
> 
> For 4KB random read, direct IO, and iodepth=1, we did not see an
> improvement in IOPS due to this patch. Maybe the test case above is not
> sufficient.

Hi Bean,

Which test has been run? Polling is only enabled if --hipri=1 is specified
to fio and --ioengine=io_uring is the only I/O engine on Android that supports
that flag.

Thanks,

Bart.
