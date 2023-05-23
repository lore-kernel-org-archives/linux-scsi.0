Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6FAC77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 17:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbjEWRcT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 13:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236726AbjEWRcS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 13:32:18 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCB6E64
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 10:31:47 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64d30ab1ef2so14884b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 10:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684863105; x=1687455105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BsLdbOtWZqGDDhIfd5JSowpIYslTFlwc+eis5/CXhg4=;
        b=mjGZ222BMeABgspQ4C00XVzXG5HI5E5DX4AnVojL6fCi7mMtye2/kuf3yZCxyLNWpm
         8CewfWrrxrGpy8G5PCFtQRWfGQlLIpI7Oj5oZQwhtD140OXGZvb0tfuU0UiufDzMtL4T
         9J58eSM5hSaBbQnFUcCeZcWoIZa6L/1wBYE3w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684863105; x=1687455105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BsLdbOtWZqGDDhIfd5JSowpIYslTFlwc+eis5/CXhg4=;
        b=agccpk3XBP2KIVqF+AQ4apiJXX7YoyWYY+0pm+71hgCBupfTQAyNqHkg9Eo/VjOLWF
         2uX8U81nkJtStm/KeO5hk84ks5GoRj6mFv3iG651HEkK+36UKZuWbqy9G0tTf4pf/xJD
         3ONXnAJV2KQiRPUenyoT+PK7gAyx9sAtNT1bUzJFuATkW3sNmFRXZGB7XYZkN9oFiDNF
         lGrPPXEuaUl6gNjByJHTjbYFQP5unLet7xrBavfJ9avLGsS9Xdw00Eo5fVlusaWom+Z2
         SDnr0ftR+Y0JduX05BHp+yoT++7XXlKeCZP60P37KchtTNgrMuGtyhFlhgDNZjWM3fIE
         sbOA==
X-Gm-Message-State: AC+VfDzSaUqS/hUacxuYrlj5oYPPOJdL15z+lBAb6+n49AHGe58OTiUd
        ycYh7EP7O3wuGHT4w5Pbk6RiPCAcxsKbYXmoGv0=
X-Google-Smtp-Source: ACHHUZ4yKB8IpGx14IYy5bz+N/arqjLssi9jJEin6ZmCQLH3NCJpVHrJTIVD/nZQfE595frik+Pj5A==
X-Received: by 2002:a05:6a20:1590:b0:102:8f0a:5acf with SMTP id h16-20020a056a20159000b001028f0a5acfmr16420291pzj.62.1684863105011;
        Tue, 23 May 2023 10:31:45 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id g13-20020aa7874d000000b0063f2a5a59d1sm6064087pfo.190.2023.05.23.10.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 10:31:44 -0700 (PDT)
Date:   Tue, 23 May 2023 10:31:44 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/2][next] scsi: lpfc: Replace one-element array with
 flexible-array member
Message-ID: <202305231031.C9E6124@keescook>
References: <cover.1684358315.git.gustavoars@kernel.org>
 <6c6dcab88524c14c47fd06b9332bd96162656db5.1684358315.git.gustavoars@kernel.org>
 <yq11qj8nhy7.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq11qj8nhy7.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 22, 2023 at 06:02:21PM -0400, Martin K. Petersen wrote:
> 
> Gustavo,
> 
> > One-element arrays are deprecated, and we are replacing them with flexible
> > array members instead. So, replace one-element arrays with flexible-array
> > members in a couple of structures, and refactor the rest of the code,
> > accordingly.
> >
> > This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> > routines on memcpy() and help us make progress towards globally
> > enabling -fstrict-flex-arrays=3 [1].
> >
> > This results in no differences in binary output.
> 
> Applied to 6.5/scsi-staging, thanks!

Martin, I think this patch is not right -- can you drop this from
staging for the moment?

-- 
Kees Cook
