Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DB2C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 18:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiKISyF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 13:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiKISyC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 13:54:02 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9162E1085
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 10:54:01 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id d20so16871537plr.10
        for <linux-scsi@vger.kernel.org>; Wed, 09 Nov 2022 10:54:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yDNUN1BT9SvmfJBSBG5b91t2Itipdats2JuwG/j8AJQ=;
        b=ITqB7MhdFR4fdDuRoD++zsu6hoHZMWokF5PI2HMHpJsa8QZYBRPCbelz+uaFeakyhy
         QnuVxgWVEe6ehpXVce6yjqE2liMrI1vKWketc9RwsT+yPRY5wY1CPzfUzGpUvVMBXGLi
         t8PuH35bE0KBfDQYGhn4EXsnfpp81xkr8ix27xJk6hsIuYm+IjCV4EfFDf/iR/m/L50q
         ejh3gL/vgPvyIby+tkWXsAXOz93n5o52W3sIN5UGbOmmEESIQWiBOi8ZJMATjCAfB2SY
         8XZcLSWX1ob+dPLcAFe5iuJPl1wVa0HKp1AmrwFqs9FSFrt7bP4up6wrHS9jucyTyXg0
         bovQ==
X-Gm-Message-State: ACrzQf3T5yi4C3sCVOYjtiiYPUw3QjreQdoYOSIGN5TIgxfrzGrWIrbC
        sUKIBT8U0aMjpMlMI1YyBHI=
X-Google-Smtp-Source: AMsMyM7cdb5Yn/efWbBlJvM0UuG1Jn7YiH/cS4rD6tUzDSXdSupNZFpZ8Uuv3ptNRkq8vnSoSFmUhg==
X-Received: by 2002:a17:90a:4ece:b0:213:1130:ca9c with SMTP id v14-20020a17090a4ece00b002131130ca9cmr77945466pjl.17.1668020041033;
        Wed, 09 Nov 2022 10:54:01 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:68b6:5dae:a00c:c3b? ([2620:15c:211:201:68b6:5dae:a00c:c3b])
        by smtp.gmail.com with ESMTPSA id t13-20020a170902e84d00b0017849a2b56asm9551711plg.46.2022.11.09.10.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 10:53:59 -0800 (PST)
Message-ID: <ea816e0c-4a13-d1e5-be4b-3dac4c8b57e2@acm.org>
Date:   Wed, 9 Nov 2022 10:53:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v6 30/35] scsi: sd: Have sd_pr_command retry UAs
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-31-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221104231927.9613-31-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/22 16:19, Mike Christie wrote:
> It's common to get a UA when doing PR commands. It could be due to a
> target restarting, transport level relogin or other PR commands like a
> release causing it. The upper layers don't get the sense and in some cases
> have no idea if it's a SCSI device, so this has the sd layer retry.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


