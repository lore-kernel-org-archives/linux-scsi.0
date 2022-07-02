Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C037FC433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Jul 2022 16:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbiGBQTG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jul 2022 12:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbiGBQTF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jul 2022 12:19:05 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D58ADFED
        for <linux-scsi@vger.kernel.org>; Sat,  2 Jul 2022 09:19:04 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id y14-20020a17090a644e00b001ef775f7118so972139pjm.2
        for <linux-scsi@vger.kernel.org>; Sat, 02 Jul 2022 09:19:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pMiv/rX5w9AJIoN2mfAiPetJHiwOk97AF3ZnsA2GUQk=;
        b=ox+/yWKqmEBRuMOJYlZnzCwbvgeQTMYxA9j5PQ81C8+RortmgUQ7hSUr7MiSxtNxEi
         mrIKWc3mMeEEzrZMVq26mOmAQR4kNWHIdhDGcNGxq0B4BKJwPL6rMsa98tcbu6Imn4nf
         0inqXMululkgUSex24Rnr13ujRh151TGe1HwB9aO21/aYawU1RPfhk+NXX2bgY+vvz5D
         OROJSTqrXhllW2YKcRg/JQqehdT3LsDrCgZZQ/3AHgzVtpihVNPMYudQ2G1o+lC6fVL8
         JHBOQzrl0+6VXesLguV5VWidrvnP84tMZaBW7b+FjLrgQqmRbEfDPLwF/hwrnI05iBTQ
         0tFw==
X-Gm-Message-State: AJIora93eaNl2hFtkcUAY/NBdBcB3J2FgGjYbcnVcXmH5p/aiTGBdk6T
        Fkm9P33Kq7JfNyuIVCHgBpU=
X-Google-Smtp-Source: AGRyM1uRTqP6PnvczL+CN8+KCNgL5Hd396nAVrkk3ZlWJPlqYHsxIIIYaw5JEMUv/oh5KWBklmHnuA==
X-Received: by 2002:a17:903:1cf:b0:16a:605a:d58a with SMTP id e15-20020a17090301cf00b0016a605ad58amr25350304plh.37.1656778743423;
        Sat, 02 Jul 2022 09:19:03 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id y27-20020a634b1b000000b0040cff9def93sm17184844pga.66.2022.07.02.09.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Jul 2022 09:19:02 -0700 (PDT)
Message-ID: <238400ab-db9c-5263-f15a-ec8b35e41af6@acm.org>
Date:   Sat, 2 Jul 2022 09:19:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 1/4] scsi: qla2xxx: Remove unused del_sess_list field
Content-Language: en-US
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <b4a96c07-76ef-c7ac-6a73-a64bba32d26f@I-love.SAKURA.ne.jp>
 <46629616-be04-9a53-b9d8-b2b947adf9d0@I-love.SAKURA.ne.jp>
 <a7f24b44-c4da-9e8f-e1ff-eafa9304e13c@I-love.SAKURA.ne.jp>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a7f24b44-c4da-9e8f-e1ff-eafa9304e13c@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/1/22 22:00, Tetsuo Handa wrote:
> "struct qla_tgt"->del_sess_list is no longer used since commit
> 726b85487067d7f5 ("qla2xxx: Add framework for async fabric discovery").

Please post a new version of a patch series as a new e-mail thread 
instead of as a reply to a previous thread.

Thanks,

Bart.
