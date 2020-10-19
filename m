Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6EAC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 14:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD1A22363
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 14:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603118601;
	bh=b3BMq8SxIpc/13gdWrygJuyzVCVoSXos+yiY0Km84wQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Q5xMr1JN8egJGt0YLnGK0LLGQVExe1zWZVEd8qGS7Cp9ZUOrGNz2Zzvlxv/DVwuwV
	 bNBCx6utq1BcQrWAK2kJjmp09hEe42Ux50M9te2vQDnflSs2XaFvZyfKQKCjK57yFA
	 akFVmGxCkIc5tSO5+0HZsV0tmgVkWCF7hPSq8fiE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbgJSOnU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 10:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbgJSOnU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 10:43:20 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2BBC0613CE;
        Mon, 19 Oct 2020 07:43:19 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id y20so13271985iod.5;
        Mon, 19 Oct 2020 07:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UCIZcpV4okvtyvYLzB1AmMBudnMlsV1FmyZ7pm2zTZM=;
        b=hEOb/ar311KnaDTM2UMZcagpOXRn4M9EnHw6EnMBRarVUEBULXRiZBorpjbqcHGTn9
         rduZHFGftKVr+E2mK9daTTm8SYZzi/6ukVR1Yla5A/UzIRPZDRmfuaohch8WTR41/hhM
         UOl/4AXIf0VwfqoZyk/qlVCjQnHOTZAowabUKBQ5yR5d6CHb9St4aNXOfMuZN/cYuMNH
         3bYZncmF1jzG2se0rPWF24LzaIVleRK41PuaP8elAUcvxCRLtGB/SFiVb+bw4GPZQ4BG
         IHoWi000w7FZzHuBwRGw3tFMH7wQzGCXAbrrWSzy1RdxHCCltlG8P1gNjXnRJDI7RY2R
         7Wgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=UCIZcpV4okvtyvYLzB1AmMBudnMlsV1FmyZ7pm2zTZM=;
        b=WrbSlqtyN+aDJqm4sSNZ6/vNzVvP2Lq60abc72ryd2mUSVlXr8yKeItCl2jBVZoUDH
         t1PvYRNj2C2USws8kGyOYrsMsbMLq8yVPBdufawNFrB/o3/+7ZP5W4AoVDG9ysZbZ/xM
         dGNaMp/fE9ADzGP2ri9Osur1WgHdONed/LkOK6tG0qgB3JmOl6yAeTgaajc4uyPDzMox
         ldzBFFEEJJc6zRM5tFpej8gDiRz4nzperf7/zQC3L505y0bMsugTqwxgOAc1iUrzStAn
         GkLJ7LdXTLA4bQEyNiEdOd5wNNZj1qO5sRy3zR6AlFyRNkYq+HRI1bh1kG2PbmSKrPjI
         CMnA==
X-Gm-Message-State: AOAM530icDONLHXZM9j3ue2JmxtVKFGj4ZRljLhYkgooPz7iL6KahY2/
        ++lCfFewMZqMFa3+bkoPw398A2oNhvK09g==
X-Google-Smtp-Source: ABdhPJwauXxkY1ronpAbuNbxWn5kAEPQu5M79XYCEJ2roZD7e5xU0VmJkeLiK1igK8SkXTpa+ubLxQ==
X-Received: by 2002:a02:cb0c:: with SMTP id j12mr238199jap.54.1603118598865;
        Mon, 19 Oct 2020 07:43:18 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:b34d])
        by smtp.gmail.com with ESMTPSA id n77sm12450163ild.10.2020.10.19.07.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 07:43:18 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 19 Oct 2020 10:43:16 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Muneendra <muneendra.kumar@broadcom.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com, pbonzini@redhat.com
Subject: Re: [RFC v2 01/18] cgroup: Added cgroup_get_from_kernfs_id
Message-ID: <20201019144316.GB4418@mtj.thefacebook.com>
References: <1603093393-12875-1-git-send-email-muneendra.kumar@broadcom.com>
 <1603093393-12875-2-git-send-email-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603093393-12875-2-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 19, 2020 at 01:12:56PM +0530, Muneendra wrote:
> Added a new function cgroup_get_from_kernfs_id  to retrieve the cgroup
> associated with cgroup id.
> It takes cgroupid as an argument and returns cgrp and on failure
> it returns NULL.
> Exported the same as this can be used by blk-cgorup.c
> 
> Added function declaration of cgroup_get_from_kernfs_id in cgorup.h
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
