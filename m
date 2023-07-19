Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70438C001DE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jul 2023 18:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjGSSrO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 14:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjGSSrM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 14:47:12 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284151FED
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 11:47:10 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-66869feb7d1so4935356b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 11:47:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689792429; x=1692384429;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dsKGM9A6zy61sOSsWS/NI7SjppQmENqm/UMQUtjASz4=;
        b=MHHGqrn0Oqb1aYsz/QcwnL+nF8FW7bBVUKr4/4TIPEzb4xxUW8AUatA7rs2GKw0Bb1
         759ckHHVKjXx40B6M9BOYfYJEon1y1YoPyPSYjNbzUHi3cbJ3LW3T1GFx+nPhV74HGTM
         e+l7JMsZL7wTCRk/5WK8Tiq8ldizS8CK1Nr07qos/qZwBky2gEIrb8j7GlUyRY39ugle
         IK5B63GaJASPb6Gx2DihSHAmB9BcDgGQSxH4mD5N0SbnE8Cm8Rk0ODdzE/ocqEo/RNUT
         sH1qdrqfLTwEgdU58AuUHhGBE/UtiH8BkoeY/ziiQAUJBzGEMv/Xq9xqPRPdUg3ejLjS
         4upQ==
X-Gm-Message-State: ABy/qLY5u0dVeDi6C4C+3YU2+fFWsROy/Oz2qhz5zo/tdc+9ZHtL+2Yl
        5IzaWabCTDbGwY/tfamrlAWVRQTSaWY=
X-Google-Smtp-Source: APBJJlGvxa4VS8jYfspm29jx+B9Q6ZoOjGEkclv2YN+owssPjMuxJZeyXt0EsfBo2LEcKM2DNXJ8EA==
X-Received: by 2002:a05:6a20:4294:b0:134:1854:c136 with SMTP id o20-20020a056a20429400b001341854c136mr456678pzj.0.1689792429417;
        Wed, 19 Jul 2023 11:47:09 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a2ab:183f:c76c:d30d? ([2620:15c:211:201:a2ab:183f:c76c:d30d])
        by smtp.gmail.com with ESMTPSA id q18-20020a62e112000000b00682af82a9desm3711569pfh.98.2023.07.19.11.47.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 11:47:08 -0700 (PDT)
Message-ID: <9e3ac9a0-01af-b6c9-6cba-4acbc6072fd1@acm.org>
Date:   Wed, 19 Jul 2023 11:47:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v10 09/33] scsi: sd: Fix sshdr use in sd_spinup_disk
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-10-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230714213419.95492-10-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/23 14:33, Mike Christie wrote:
> If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
> shouldn't access the sshdr. If it returns 0, then the cmd executed
> successfully, so there is no need to check the sshdr. This has us access
> the sshdr when get a return value > 0.
             ^^^^^^^^
Is there perhaps a word missing here?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

