Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D717C531DC
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 19:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354540AbjHQTSj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 15:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354712AbjHQTSc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 15:18:32 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D379612C;
        Thu, 17 Aug 2023 12:18:31 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5650ef42f6dso160447a12.0;
        Thu, 17 Aug 2023 12:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692299911; x=1692904711;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=crgFssP+dgAE/VAXEdtqDf4iWzJYECfSs/yCysvL40I=;
        b=BKrImhn2+xnCdpVk0FLdxKDeBGW/NLBnU9whQVug/AWFgKscLvjQoBQViG0STAGGCm
         54Wav1qwUGnA8c+ca/n2CRn6VBhJy50rBosjINuHTbQaOISqh57eMyY7hJgNYBi1QHhF
         GoH1CjSSyRQsmSDXIuyH0BwUSTqFGpzM0WtwMXTYg75CFaoqgpPj+i5bRc6A8tqG9sKq
         6CpJRD8TS1utowSlWZSiR86nQdl3XzLu9L+nGrrsktLcT4Y/8VC3eYA0zV+yA3A8H0/D
         jwDteQPCAaosC+UPLr7C4v9V+4XfbRAFsUzNIRqhi9cpz//WKGGb3efhuT4z+dddMYLl
         hN7w==
X-Gm-Message-State: AOJu0YwwjEcPBLi0OpvSvyLtTOACNn1p3+dde9G9d0l89HymW/Fx1H/M
        ai+GX05Vyjhsv7tkC2LgUfA=
X-Google-Smtp-Source: AGHT+IEdEW2oJeY+qHBwdj6sFtPsAs7cF+cOYDV/uoUUuTk/GQy9rBhx3zlNSzLiWKQ6azda4AH+ng==
X-Received: by 2002:a17:90a:73c7:b0:262:ece1:5fd0 with SMTP id n7-20020a17090a73c700b00262ece15fd0mr356202pjk.12.1692299911035;
        Thu, 17 Aug 2023 12:18:31 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:dfd:6f25:f7be:a9ca? ([2620:15c:211:201:dfd:6f25:f7be:a9ca])
        by smtp.gmail.com with ESMTPSA id x14-20020a17090a6b4e00b00268320ab9f2sm1620299pjl.6.2023.08.17.12.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Aug 2023 12:18:30 -0700 (PDT)
Message-ID: <f87c30ad-be65-dd87-1901-5f5c5bf798f4@acm.org>
Date:   Thu, 17 Aug 2023 12:18:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v9 16/17] scsi: ufs: Forbid auto-hibernation without I/O
 scheduler
Content-Language: en-US
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        zhanghui <zhanghui31@xiaomi.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-17-bvanassche@acm.org>
 <2a2bdb27-86a5-fcba-051d-4b37d7c4edbd@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2a2bdb27-86a5-fcba-051d-4b37d7c4edbd@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 11:50, Bao D. Nguyen wrote:
> On 8/16/2023 12:53 PM, Bart Van Assche wrote:
>> +/**
>> + * ufshcd_auto_hibern8_update() - Modify the auto-hibernation control register
>> + * @hba: per-adapter instance
>> + * @ahit: New auto-hibernate settings. Includes the scale and the value of the
>> + * auto-hibernation timer. See also the UFSHCI_AHIBERN8_TIMER_MASK and
>> + * UFSHCI_AHIBERN8_SCALE_MASK constants.
>> + *
>> + * Note: enabling auto-hibernation if a zoned logical unit is present without
>> + * attaching the mq-deadline scheduler first to the zoned logical unit may cause
>> + * unaligned write errors for the zoned logical unit.
>> + */
>
> Please improve this "Note:". It seems like a run-on sentence and not very clear.

There are no grammatical errors in that note. Anyway, I will make the note
more clear.

Thanks,

Bart.

