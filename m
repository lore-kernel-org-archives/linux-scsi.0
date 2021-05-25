Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6AFEC47086
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 20:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D7FC6124C
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 20:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhEYUFl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 16:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbhEYUFj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 16:05:39 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6613AC061574;
        Tue, 25 May 2021 13:04:08 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w12so29943020edx.1;
        Tue, 25 May 2021 13:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=lX2zjqxT5hxdAGccuWZ0xKO6Pd/AeD1f94jE8ek9eK8=;
        b=rNLAWCOnst8PgwjHJIFDiBKoge8Kv+cXmWBPSHHsZtrWa6pbLRch/LnLWlcdgNuDhc
         fSfD0BFrhuqWN6P0N+Twllqj6nCK5K4Urdc9/76RKqAk2VeNcgwAAUh0yWc6WO8+gO7p
         0f2dEpu098wtCWz7HlWq4mxJp/pnofji7fzNUSi9yrv1KhAPLuQzmr0RVOD6wQ1BY7p6
         ZRTYI/xjDJsZ8Sd820kiILHlCyFw4IopSCkWaKXZaOhLtrctHU+tRl3uIofaedO+kT+T
         h6na0VfjHcoBOD995fJqjqeUdUXEFOw0bEwx2dgc+I2r0qWbX7QOhLeNtJFdGcjOrRav
         ukpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=lX2zjqxT5hxdAGccuWZ0xKO6Pd/AeD1f94jE8ek9eK8=;
        b=JgwkHksL5rC0jwgUXdmJgtrsqqIcekoGo/bHP7bJ1jGiLM4zF91uUI7J3nJot1Qgcr
         e0d94M8OPh0VkWMv6GSnQP+tsH6MJcSEIUDW+p/c7P2AAWp3ygHXJWIs0rRILBW5kf7p
         0bxPuM8s/nXhS+mkZIbT0mf4fRKLGt1cvrkJvwN3r27auMGAEe9u5P3Z7LMktj0761A4
         IggVj6y+r2jtZggwOGvLYRM1UAxzD9+uGMpeldeoEQLgeevNEbgDuDuZNPJs+sPCY9On
         7dbg0jVVf21w/BeXc170/LmVQsfHAmWgrNYHCCt0qrr7dotF3+E1/HW83hIbQihFFEkM
         ApnQ==
X-Gm-Message-State: AOAM530OpT367wKsS0y50GCMR6DvCLghFWlRKa0tuVKYfr9tScr5u4pw
        ihRc0XYT6aTNSYNW2s+vcAc=
X-Google-Smtp-Source: ABdhPJzS1JscP+QnU5AuUejtM1+CkJszDxJaGOV3VCyli5vwxJmLlSY2S0DUgaHStZCpcroweN6Olg==
X-Received: by 2002:a05:6402:1544:: with SMTP id p4mr33830263edx.341.1621973047044;
        Tue, 25 May 2021 13:04:07 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id g23sm9343905ejb.15.2021.05.25.13.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 13:04:06 -0700 (PDT)
Message-ID: <3fc41b0ed354d1a680fb5fbc41a0e09ab847dd32.camel@gmail.com>
Subject: Re: [PATCH v1 3/3] scsi: ufs: Use UPIU query trace in
 devman_upiu_cmd
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 25 May 2021 22:04:06 +0200
In-Reply-To: <74d9b6e5-489d-9267-1c6f-c59f9164136d@acm.org>
References: <20210523211409.210304-1-huobean@gmail.com>
         <20210523211409.210304-4-huobean@gmail.com>
         <74d9b6e5-489d-9267-1c6f-c59f9164136d@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2021-05-23 at 18:32 -0700, Bart Van Assche wrote:
> On 5/23/21 2:14 PM, Bean Huo wrote:
> 
> > +     ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR :
> > UFS_QUERY_COMP,
> > +                                 (struct utp_upiu_req *)lrbp-
> > >ucd_rsp_ptr);
> 
> 
> Why is there a cast in the above code from a response pointer to a
> 
> request pointer type?
> 
> 

Ok, I think it is the same question as one in patch 1/3.

> 
> Thanks,
> 
> 
> 
> Bart.

