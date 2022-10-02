Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B67C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Oct 2022 04:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiJBEOp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Oct 2022 00:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJBEOo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Oct 2022 00:14:44 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AF61147F
        for <linux-scsi@vger.kernel.org>; Sat,  1 Oct 2022 21:14:41 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id c11so12317379wrp.11
        for <linux-scsi@vger.kernel.org>; Sat, 01 Oct 2022 21:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=xhWDVjIWcb0O3KXIeVKabzOofst4Rlo9p33agfkMikY=;
        b=jpE8sw4uNbPwY5HkQQZjst9r6z1+OLngU09uJMnbs16nADGMkGe8foq+thOCnHC/N4
         p0m4yAD6oGKHUbJbc9Mo99aCpR5gGijScclPabFY6ocrJvnk3OZSMGObURUjTqx4NbKJ
         Gi4CK3fTzZuK4R6c5hIDMiEZZx8/k4pQmVa5MwUBqrHYIOs2LclAZ3UhJw5Sy4qpud4I
         4/cXPL2F11+rBU0sSLjOdq3BOs1a7cT1ajKGvloymkmkgnpPUptqZvXyRp7BhMani230
         v3kvjjp3XZFA87pIfKjDre9aCK3mrQpPMXPclpuKyXtOSVQwt3W0FFxgATsDmuuwJHG5
         kKsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=xhWDVjIWcb0O3KXIeVKabzOofst4Rlo9p33agfkMikY=;
        b=fWe0R+0j91vzcaT1X3b4hBhlq+WgStkrmXZzMUC/CBHdsSlmxoOXzk4XmpSEuykSYo
         wIR29pHyQw/9wWqNXrh/4uagib4b84Cx1LjvzcPxUwxFnO28dufSaezeF8AGI6b4IX4V
         0gn0x+6y9g+W9vCfTcp5pTrKSPaOnPqPfASlbxkzuj/yio/aDD+7fwO5jaongcrn7I1M
         01JVGqARkY13JCGHanZt1ZGskfE7E24u3gvd4JhdjEAAoBrJTgNwaVe6ZivSGM58ZMAD
         3S64vG0fAV1M7HubCe/K5ZPXueteXhEqL/YxSuf4NtxM8bIo31q6tBx9zvOpe9ujzzr4
         lm2A==
X-Gm-Message-State: ACrzQf0PZ98kgI7GK3xzthTR8QWDVkHhoyun6lqp1JqJ68tAnYdoHCJl
        1PiMdQID8bH+G5N/rkFYh+DY6/IendyJ1t9bO/8lGCjCrB8=
X-Google-Smtp-Source: AMsMyM4OFUWxOoiYKh5R6oXc4GbSZmO4T/I1YJRZCZuA8y8KoK2DtmY7h/zPMrhv2NZEddeFT+B4AmblRGg6Y0JHQuo=
X-Received: by 2002:a5d:6e92:0:b0:22c:c09c:8f23 with SMTP id
 k18-20020a5d6e92000000b0022cc09c8f23mr9604798wrz.389.1664684080386; Sat, 01
 Oct 2022 21:14:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAPm50aJ_aW4RmL3_n=5CpGL9D3dXENenFuo5QG0Q2DJO9Gv_1w@mail.gmail.com>
 <yq135c7lwlu.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq135c7lwlu.fsf@ca-mkp.ca.oracle.com>
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Sun, 2 Oct 2022 12:14:28 +0800
Message-ID: <CAPm50a+wLmqB0ocCQC-2RVfQqWRzv+AMxJ4grFfSei2C2JdY3w@mail.gmail.com>
Subject: Re: [PATCH ] scsi/ipr: keep the order of locks
To:     brking@us.ibm.com
Cc:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Oct 1, 2022 at 5:33 PM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> > As shown above, there are two lock acquisition order changes.  At the
> > same time, when ipr_device_reset is executed, the lock hrrq->_lock
> > does not need to be held.
>
> Please make sure to copy the driver maintainer when submitting patches:
>
> $ ./scripts/get_maintainer.pl drivers/scsi/ipr.c | head -1
> Brian King <brking@us.ibm.com> (supporter:IBM Power Linux RAID adapter)
>
> --
> Martin K. Petersen      Oracle Linux Engineering
