Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA31C001DB
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 12:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbjHJM0n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 08:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbjHJM0m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 08:26:42 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AFA212B
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 05:26:42 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3fe5c0e5747so4898835e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 05:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691670400; x=1692275200;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S+bCQqzHYpFPyJKW619q8Rrv9b9HvvBBnqDwxwuq8Jo=;
        b=bi5/wMYJsyLaD+d3xhylkLOiPRkQbsWP0C5hYJ1Nb6b9J1m0BYIVl0GL56zSkepitT
         y+2C9zIk/eGVl0R3jzLyLqCoWEypqkG4xzHqOAVhtHpoBzSLURVZEdniLou8Pk6KqLzC
         NfxyfHpV492VO529lcGLDq6icPR5bdIfev6A3c57VLBuCsI3ceENySQ9To88fCYQcvpb
         c+PXQ/+gU00tJWPOl0Bf/JlNDvRgNFikZP4CtzkJSlLhkde77oI8NFjUoNU+I/zxEMfU
         WNgNeRw+MXrPJFfTJZOt90SnBNKRXRGUV0XM64of+WdRC3M6ydmeZUdjZnW8dL8+EnT8
         8nKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691670400; x=1692275200;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S+bCQqzHYpFPyJKW619q8Rrv9b9HvvBBnqDwxwuq8Jo=;
        b=ORqAOx81HI1tXxz3Eppyrrw+VWiCPdctjUUBo7GIE7DLr3i3b07i/yABRxRNxfvMjH
         xQYP73LxkOA5AUE0KmODhSN1crE/PUHog/fH2UQsQF73VURvX7QXFEml2KDGK7CA/kHL
         +t50/JZhwPboqN2PyLLBXyRuLNqYKhVnIM5h6RmRyiMcTbgz7jL8eIyA8SQqKna9diAL
         yO9BytIYdHXzb2hkAf/KylEKM3Yxmyb1KfiRbzkx9+Tgm1PDsaP8DqclCRxPMUMWZamA
         sgb8n239ztMi08yXwfj2JeDNJhWj66NIhpGsn2OaedvMRmaGaP1eubOgyFqxwdQioAVG
         qVxw==
X-Gm-Message-State: AOJu0Yyz0ZnpbSi0ihbKXHRGcNv1sPm6bk5sEkz1WZepwm43S9s0HRCx
        D2S4CA9viU8xkM7fK/g7n2EkYUq+8BvtsKUKHMo=
X-Google-Smtp-Source: AGHT+IHP03GiGP2V3gyiNR9xR87V0zIQAXDRO6QKl/OiNpXYHWkrucKwnaoa2qPGb1XVhg/m4HJISg==
X-Received: by 2002:a7b:cd15:0:b0:3fe:1587:fdf3 with SMTP id f21-20020a7bcd15000000b003fe1587fdf3mr1587194wmj.14.1691670400629;
        Thu, 10 Aug 2023 05:26:40 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id a19-20020a05600c225300b003fe1cdbc33dsm4920828wmm.9.2023.08.10.05.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 05:26:40 -0700 (PDT)
Date:   Thu, 10 Aug 2023 15:26:38 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     wangzhu <wangzhu9@huawei.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [bug report] scsi: core: Fix possible memory leak if
 device_add() fails
Message-ID: <26b9c8c4-70b8-4517-91b8-9eafa2b81aca@kadam.mountain>
References: <5121c883-ef71-41d9-8153-472cf319a7b8@moroto.mountain>
 <470fb552-7356-4a62-a4bd-545b4f94e040@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470fb552-7356-4a62-a4bd-545b4f94e040@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 10, 2023 at 08:05:21PM +0800, wangzhu wrote:
> Hello Dan Carpenter:
> 
> 
> Sorry for the patch 04b5b5cb0136 I submitted, I thought put_dev(&rc->dev) is
> not the same as kfree(rc).
> 
> Then should I submit a revert patch again, or you can fix it yourself?
> please let me know what I can do.

The original code was buggy and the new code is slightly buggier.

Instead of reverting, lets see if anyone knows the correct way to fix
this.  If no one comments within a week then I agree that reverting is
better than a double free.

regards,
dan carpenter

