Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A467ECAAD5
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 15:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiIFPP7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 11:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232944AbiIFPPi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 11:15:38 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CCE7D79A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Sep 2022 07:28:51 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id o123so11868568vsc.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Sep 2022 07:28:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=uRHNUx4gSoSK/8ZMa9UsDNi3QnbIs3RAldhpW93mcWQ=;
        b=yy61nk9qRg0cLGVxYB1F0MMGbjVzUU0sVgP6NtGL8ofz9nDTaHbF1wcAEBEXBZiorY
         oWzQ8UwDpo3lbjljdDkwj8e2+rqKVhmhnYsjuBQi7egHHoInErSf39NAJRyEISyyrFWI
         odNOElb90PJk+iqM9gxiwUuFlw09TCAjznWqYSN6W6ljMlyqP6QSuwOU1gzBK3rxzSVQ
         xpmOmu5wz2rqb6NaGwxxrwvc41QjHcRq3BFJeCUDMSu/rTHb9QcNCN2zw0a1vu2Xv4Ay
         ji1ktXuO5YiQfEdY1InIKRS4p7IFeHZEI/YVQPhu43tVMsBEnlo1KacD/M03uSfaxkcY
         DkfQ==
X-Gm-Message-State: ACgBeo0wZA3tNYfrKyZvlTgGp8PQmOINUz6C0yh6F/hCUszA3ik3JJ/+
        jyL0tg57ozcMEzLt96kCHYSzJws4DgA=
X-Google-Smtp-Source: AA6agR5nWv6BBBL6BJJCQFH226Pg52utvjFt1KN8vt38xlCzbtQfF1djIr4XZ52uWSVFF8UpuZsizA==
X-Received: by 2002:a17:902:e886:b0:176:a2b7:3977 with SMTP id w6-20020a170902e88600b00176a2b73977mr11771204plg.160.1662473778600;
        Tue, 06 Sep 2022 07:16:18 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id e22-20020aa79816000000b00537e328bc11sm10134478pfl.31.2022.09.06.07.16.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 07:16:17 -0700 (PDT)
Message-ID: <5462c15b-3ae2-21b7-2f1d-79103b196c34@acm.org>
Date:   Tue, 6 Sep 2022 07:16:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v5 2/4] scsi: core: Make sure that hosts outlive targets
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220728221851.1822295-1-bvanassche@acm.org>
 <20220728221851.1822295-3-bvanassche@acm.org>
 <20220905173905.GA3405134@roeck-us.net>
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220905173905.GA3405134@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/5/22 10:40, Guenter Roeck wrote:
> I understand that it looks like the problem is caused by the shutdown
> function in the imx driver calling remove_device, but that is not really
> the problem.

Hi Guenter,

A revert for this patch series has been queued and is expected to be sent
soon to Linus. See also
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=6.0/scsi-fixes

Bart.

