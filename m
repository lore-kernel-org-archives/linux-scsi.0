Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53861C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 01:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiCFBp5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Mar 2022 20:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiCFBp5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2022 20:45:57 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7466BDC2;
        Sat,  5 Mar 2022 17:45:06 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id 9so10921916pll.6;
        Sat, 05 Mar 2022 17:45:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qPgxnrcXNBbutHphQw0gpUwLmFmnRfgwTdDxK2Jj3E0=;
        b=DvoNYr7EH8uiB1Sncx22bfLdNJq1yqjHHeEulyPi4lh7jWlLusB2EQZT2GkoPE8P3v
         JOAZRNpajDgIlpjPsxYROUkkg+ZpI0HsOO+r6s4WMrI09R81aFRJ5fXpxyoOUdpaE1RL
         00+MPR4g5rfbhrMp6fg83ezbXSTG8X+6U92yveEVac2padgYwCtvE534u86M4C8lW2Lm
         608uTsRxHa9NXtOlevTZvRmWiCfQC/JMR4de3noVs46CNqS+lxdkUsgxLgFUy+Nu1fnJ
         u6VxmquCGqRsNHPXMpyRvOuKerc3wWCjTWwBXNo7x2TPCkLtZE2Lo61pcoqH9sdqn8J6
         4stw==
X-Gm-Message-State: AOAM530Adm7TW+K56St7EPMzyr/rxn/ot9i8cBlCJlzSKv1efuhFMjhe
        pbltLf5ePzSY98njt4jRIvY=
X-Google-Smtp-Source: ABdhPJyzFS+YAEToFz+OX5j78Dp8Du4e0wMsvdoOXxd1mI8aMBW1Cd/7HGn/RzLKwVQu5KGAubRCuQ==
X-Received: by 2002:a17:902:8a8a:b0:14d:bd69:e797 with SMTP id p10-20020a1709028a8a00b0014dbd69e797mr5695918plo.49.1646531105653;
        Sat, 05 Mar 2022 17:45:05 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6664d26eesm10534172pfk.88.2022.03.05.17.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 17:45:05 -0800 (PST)
Message-ID: <9d968060-96ed-8530-c1a9-d779bc900e97@acm.org>
Date:   Sat, 5 Mar 2022 17:45:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 06/14] sd: delay calling free_opal_dev
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-7-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220304160331.399757-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/22 08:03, Christoph Hellwig wrote:
> Call free_opal_dev from scsi_disk_release as the opal_dev field is access
> from the ioctl handler, which isn't synchronized vs sd_release and thus
> can be accesses during or after sd_release was called.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
