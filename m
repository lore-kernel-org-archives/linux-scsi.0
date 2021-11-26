Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D374EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 23:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245619AbhKZXUZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 18:20:25 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:46803 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbhKZXSZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 18:18:25 -0500
Received: by mail-pf1-f172.google.com with SMTP id o4so10174874pfp.13
        for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 15:15:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u2NH7rZGqJ6QApdVbz2mUj7GO0HJxfMdGpo49V1qAjo=;
        b=3Fb6Fs7jhqs4M0g6AFgnXXBBLOkkr+WUg+nmyyOO1aIPmw8wyy+er95P/NZtqcdzbp
         omEvOciPsQii9KWEXkOD30IUH/gliJuWbUttARtFugMGIC06PNJoLuow56RS5W3Dzku1
         fmifk84SsZZTgmC4/sXGUZK7xx9IZKnAJTDCGQL1EYPWyIoa6c+WVsTQR44CrTGUNhBA
         OCXFMCAU70Xr6QNAdzmKlm2gt2QfqfTdjPis1CWv87ARs0aNVTB2zUlD+lKWl4yg8NtZ
         sR9oHnNwC2yqP6POzzdxNH7uwwolQhByRDJ/vfzT7O34qiQPA/QxEFQCG6hP7mur8C3A
         Mfrw==
X-Gm-Message-State: AOAM530xnztTcBwqwRJPcXfE9yiRPTDgD1fujnBTCUL1h0mnMMtFdcrg
        yeUIo5BOiD5loJIsSBSFFUw=
X-Google-Smtp-Source: ABdhPJzOcY/EEklLO+bL3QdLVL8MJEvNl2BFxKP1szDDMgKWa3zgzUcRcW3czPNTE6vzOcZcKi7TlA==
X-Received: by 2002:a62:7a54:0:b0:494:6e78:994b with SMTP id v81-20020a627a54000000b004946e78994bmr23970191pfc.5.1637968511597;
        Fri, 26 Nov 2021 15:15:11 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id h22sm5836409pgl.79.2021.11.26.15.15.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 15:15:11 -0800 (PST)
Message-ID: <9ac0278e-bee4-adc5-540b-0e0ba8131d6b@acm.org>
Date:   Fri, 26 Nov 2021 15:15:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 03/15] scsi: implement reserved command handling
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-4-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211125151048.103910-4-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/21 07:10, Hannes Reinecke wrote:
> Quite some drivers are using management commands internally, which
> typically use the same hardware tag pool (ie they are being allocated
> from the same hardware resources) as the 'normal' I/O commands.
> These commands are set aside before allocating the block-mq tag bitmap,
> so they'll never show up as busy in the tag map.
> The block-layer, OTOH, already has 'reserved_tags' to handle precisely
> this situation.
> So this patch adds a new field 'nr_reserved_cmds' to the SCSI host
> template to instruct the block layer to set aside a tag space for these
> management commands by using reserved tags.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
