Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C444C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 18:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239995AbhKVSQk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 13:16:40 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:36675 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbhKVSQi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 13:16:38 -0500
Received: by mail-pl1-f180.google.com with SMTP id u11so14820794plf.3
        for <linux-scsi@vger.kernel.org>; Mon, 22 Nov 2021 10:13:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aGXcIKf1tNGFp5+tNiX6B+yjR/XUilzqARZjz5EnS0A=;
        b=5ed7V8bY8GLP4nvH03oQdJWM0WZRpixFrdvL+0n32X/ZpQbf1KgJYMumQf4OnvQ9zZ
         d/UgObSWbaku+gbtNsDgY+wSaSZasFql+NOfNGNo7unFdo6ZzqOdgIrAkWlWo/930geG
         VxaIpY3m6lv4lNPK+h58fKBpAMsw0uFLBJixn12RmuJUXBJD1QQq5MfdCXz6uSFlO/9C
         4qbeTaTSvpmsfPkRlKBjDK+TOUNnMVeuAEkjFRN/l+FtCNhDRA97HfORZhTTYjbW8vKO
         AvZNJLQbWgiWf+Sz2P6GvzbYEuJI3J/DiO9t71xPi3TrXIDXiKvuaTzmPDoRpgg2A1ci
         S46g==
X-Gm-Message-State: AOAM530kErh/BvIPgcxKhA3SR0n0e4L/Ni8NRMCz2iUCJ3vV62jpW4N4
        gquQcWk2YrqVLiMFiSIti+4=
X-Google-Smtp-Source: ABdhPJy45YWvy+ocbsIlyHWGTziGCwqE4qentQD5wV4FptU1pWPkulC8Zbd71Ws2H6K6HYcf7Es9DA==
X-Received: by 2002:a17:90b:1293:: with SMTP id fw19mr34068427pjb.155.1637604811849;
        Mon, 22 Nov 2021 10:13:31 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3432:c377:2744:1125])
        by smtp.gmail.com with ESMTPSA id m127sm6925057pgm.64.2021.11.22.10.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 10:13:31 -0800 (PST)
Subject: Re: [PATCH v2 18/20] scsi: ufs: Optimize the command queueing code
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-19-bvanassche@acm.org>
 <a2599b2c-208c-3333-61f0-d61a269b53d4@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f6eb1b4c-ef73-7e34-cecd-fa0c9ce07a2f@acm.org>
Date:   Mon, 22 Nov 2021 10:13:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a2599b2c-208c-3333-61f0-d61a269b53d4@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/21 9:46 AM, Asutosh Das (asd) wrote:
> On 11/19/2021 11:57 AM, Bart Van Assche wrote:
>> +    blk_freeze_queue_start(hba->tmf_queue);
>> +    blk_freeze_queue_start(hba->cmd_queue);
>> +    shost_for_each_device(sdev, hba->host)
>> +        blk_freeze_queue_start(sdev->request_queue);
>
> This would still issue the requests present in the queue before freezing 
> and that's a concern.

Isn't that exactly what the existing code is doing since the existing 
code waits until both doorbell registers are zero? See also 
ufshcd_wait_for_doorbell_clr().

Thanks,

Bart.
