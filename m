Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65845C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 20:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DDC26120E
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 20:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236393AbhIPUXt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 16:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235327AbhIPUXt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2021 16:23:49 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFE1C061756;
        Thu, 16 Sep 2021 13:22:28 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id m26so7051918pff.3;
        Thu, 16 Sep 2021 13:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iACvzPK6OroFikcY25Ht5Qs4ftTKJPsGbbfw6prQ/i8=;
        b=Aq6lt52RElO6ibmbp/DLACboTwyxv68MSJksctAUdU8ztkEyg3ehQq0cKTKBbATsbY
         APevVOPu8zlkLnEYcTKLwrxZ6fw2oebm2hIUkCe7NI/vWVr2+qQUSIduYbdWC16wuIe4
         QUUpKtRCOvSHEGfHtjdCffxe94sj2UBtEfnEUVtqAIgdw0Gv0BKBxYppjYC7XwaNmdMH
         eaHnFSKzTo7tK+ulCTBzCvh+y/etvBdqdljkUB8z5yqEl86OklNypoEasMxysbEmgt1F
         T7fEqcgZ79C7WCrBwImVK/aQL6NZbpHUFZrm5eX3S+cg+ntaHMOxyk2EDJFreabWzYJ3
         YREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iACvzPK6OroFikcY25Ht5Qs4ftTKJPsGbbfw6prQ/i8=;
        b=W5Phqe3LuG/h4DEbbmIlyuB3rTD60dcxfAID2glAuL451SeabNkD8Ca0wi5jpLPAuV
         efPtrD4z2eH9JdFRmyQ8YFeuK7tvD7xb/KtrZAckY8BSGCkZp7uQmIyAMbCkmOKiWHCl
         muRskFxX8rJnYimXdUZUnsrSkM+QHNrK3v7GYrvYUvwA2U5HyWpJbknsaJi4A2GXIgkg
         nEaJBKrWWx4QBGrwJCdv1rTWqNl7R+1uagtc7Gmx38PVC/yBK4ON5BLKSLxUV8oJ74fg
         yFOyDYclbZfyefHoRISd68BUroU0/u9PURsyCDlqnS7i9Tv9PA+ZfD0axFdawicy1oLi
         /0WA==
X-Gm-Message-State: AOAM533+J8JJBNrd13dy+brP0vPcT70xll7++MNZU0iVPpQ8yWxurT14
        IGhlXzyVkVsRDL6GDap6if4=
X-Google-Smtp-Source: ABdhPJzWlJtgMkQAucsO/Lq/KodpzJNSJ9DNimrYEH50HlFSNGxh+D2WiHaPY1ud7wzo4JK81U4g/Q==
X-Received: by 2002:a65:5948:: with SMTP id g8mr6488907pgu.51.1631823747795;
        Thu, 16 Sep 2021 13:22:27 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j20sm4172032pgb.2.2021.09.16.13.22.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 13:22:27 -0700 (PDT)
Message-ID: <c3c47ed4-b56d-3f45-1d9b-67ae283d1c74@gmail.com>
Date:   Thu, 16 Sep 2021 13:22:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] scsi: lpfc: use correct scnprintf() limit
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        James Smart <james.smart@broadcom.com>
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20210916132331.GE25094@kili>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20210916132331.GE25094@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/16/2021 6:23 AM, Dan Carpenter wrote:
> The limit should be "PAGE_SIZE - len" instead of "PAGE_SIZE".
> We're not going to hit the limit so this fix will not affect runtime.
> 
> Fixes: 5b9e70b22cc5 ("scsi: lpfc: raise sg count for nvme to use available sg resources")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/scsi/lpfc/lpfc_attr.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 

looks good. Thank you

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james


