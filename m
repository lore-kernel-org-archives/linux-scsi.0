Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162B2C001B0
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jul 2023 18:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjGSSel (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 14:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjGSSek (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 14:34:40 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A978B6
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 11:34:40 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6686ef86110so4932247b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 11:34:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689791679; x=1692383679;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lTorUEmRSmxnhzmjCr+fPFTWL5iGtxffKxTeaeKS7fw=;
        b=CXwrGQ+JWadbnBLjEaxdoLUU6RlBA1klf5kO/LLmxVWLb3d18Dw9VLvze/TcPB2yx0
         4QVGX87fWTxgjDNWbL3FTNn1nWrJyRftnlEp91NUP4WZ7iuurPa96w70eI8vn/PBAfxl
         EwFK3fRGBhyUJo+ZSX8AM6LxkdTm5csD/bJslzjZ/4yVgw4JGANQsa1nfhqml04BrvZY
         J6qXXpQQzb2eyp4TGc0dUn5rYm5zfC7VYOUe6jHiMEXdq+N3PT5O1p5NqqnszLleErzc
         OT2Y7OzAcE8Thrvy4YsZiGqVLXJ8rMsET2Lat49WqAgVH1oyJU40zThWk0O08sD2cD1t
         Lolw==
X-Gm-Message-State: ABy/qLbuUt4Mu9cShO57pum4Om2jPACnqV2qnx0ZpHOoh0XI8B82rqmy
        ZE1FMgFmbN4SZYcw4RsnmvLiGpLGWZ0=
X-Google-Smtp-Source: APBJJlHsETV7ivkIk1S+lEI6I+ZaDGwUTtjYzZvhUH6aqi98dU4Nd3QVXAx9Zyg42Vf4FGX5PoWdww==
X-Received: by 2002:a05:6a20:2d1:b0:110:9210:f6ac with SMTP id 17-20020a056a2002d100b001109210f6acmr2683693pzb.37.1689791679273;
        Wed, 19 Jul 2023 11:34:39 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a2ab:183f:c76c:d30d? ([2620:15c:211:201:a2ab:183f:c76c:d30d])
        by smtp.gmail.com with ESMTPSA id bf6-20020a170902b90600b001b890b3bbb1sm4315244plb.211.2023.07.19.11.34.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 11:34:38 -0700 (PDT)
Message-ID: <6266f230-677b-c75a-34f6-ba6cdd43fa7b@acm.org>
Date:   Wed, 19 Jul 2023 11:34:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v10 06/33] scsi: sd: Fix sshdr use in read_capacity_16
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-7-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230714213419.95492-7-michael.christie@oracle.com>
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

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

