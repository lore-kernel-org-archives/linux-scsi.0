Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03BAE936E7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243986AbjJDVND (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbjJDVNC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:13:02 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427899E
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 14:12:59 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-690d8c05784so218956b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 04 Oct 2023 14:12:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696453979; x=1697058779;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FNqLHrCM9vV4AN/avGLI0IbgA7F72WC/eClKQOyUUFQ=;
        b=iemCHotiQ92gzAzEWX66qmVBT6hrYE7x4Zqr1jYMZM1aHwj9pOiu84q66d9xiro2LO
         9GE15CCGPx/iY5gzCMjhr/8PHGffBjvxvJNKv8xfsvKnACqblOFOfv3obHe+cirAuX+T
         O0EjoFytISoxM347UDM1lWjr81E+xLgdnChcOrQi34RYZ+9NmleicuYIzxHnfuLCQP7b
         Sz8cH6Jj5qR2LlIdma/u0C78Awo2xZAENgq4ZkGUPpGwUH+j1Dr84hkVGp+QTmf6hYa0
         P+2wWazMIopqIECzyGY5vidSXuUj08iJVKv3AoF8QvE7vpwWs2Jj4LDb4O/+wy2x+KrM
         0N1Q==
X-Gm-Message-State: AOJu0Yz2DmV+sQcTFFG4w1dTlTYcWuaWKc94LRkmqxA+b0+AbloBYSOe
        AgkCAMTxfvV72B9fCyMNRak=
X-Google-Smtp-Source: AGHT+IFD3Xlo5ygeJd9ICJyAIRmSItBZuIRiXXxKKwuGiE+bSpOvcEguSlzfoyi2N4eWbPyaeg0qmA==
X-Received: by 2002:a05:6a00:16c9:b0:68e:2f6e:b4c0 with SMTP id l9-20020a056a0016c900b0068e2f6eb4c0mr3863506pfc.28.1696453978480;
        Wed, 04 Oct 2023 14:12:58 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:969d:167a:787c:a6c7? ([2620:15c:211:201:969d:167a:787c:a6c7])
        by smtp.gmail.com with ESMTPSA id j4-20020aa78004000000b0068be348e35fsm3665294pfi.166.2023.10.04.14.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Oct 2023 14:12:58 -0700 (PDT)
Message-ID: <0119a007-ea79-4ec6-b7ef-5cab86a2f80c@acm.org>
Date:   Wed, 4 Oct 2023 14:12:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/12] scsi: rdac: Fix sshdr use
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        john.g.garry@oracle.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20231004210013.5601-1-michael.christie@oracle.com>
 <20231004210013.5601-6-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231004210013.5601-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/4/23 14:00, Mike Christie wrote:
> If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
> shouldn't access the sshdr. If it returns 0, then the cmd executed
> successfully, so there is no need to check the sshdr. This has us access
> the sshdr when we get a return value > 0.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

