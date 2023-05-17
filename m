Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D98C7EE22
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 23:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjEQXCR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 19:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjEQXCO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 19:02:14 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AEB61AB
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:02:06 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1ae4f28454bso10849495ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684364526; x=1686956526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NCOs9XFCFeYjn/qRnbFLhpqd0QIqRRTHRKO1/+0RAUk=;
        b=hblzA3PbsTRQj6+lS+RlZl1Bd8A+m4ZU2gRkGKogDTW2wJqSkEx6ZBxuNyeQhCXmO/
         7U6aPZGf5+vHz+ckkVvoPkEV42PklylLIZkRyTnzUlpACKLZIomqzSnqlpjZ0O8yve08
         FxK3KLI7abAFw3PZBgAl5IPQmQOw7B7VwPl3Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684364526; x=1686956526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NCOs9XFCFeYjn/qRnbFLhpqd0QIqRRTHRKO1/+0RAUk=;
        b=ADoebxxxo3w8PM70IhIUb6U70/FTTEfynu6pcUdquuqdN+4tBDNrpVGzP6+QNARUX4
         adxvtf+hcpgbn3GM3FME1clZBKAdw7t1BZ/NHAGooF+3IEOHzYH9jXs070nFgmCL5WCH
         hna47etPaaYIMloxCk/zxyJ/HoOtE0X5G8FtaNpVTTv6dfdvhIgPl8OhB1CNAS7xvBKH
         a+abM7SjNgDzguBUeomUbxLXVD2wF8uP08WpEgVdPKZVisJGdKZ0qjsG5xEV05FMxvI4
         NEOutdkeGxkIsrVc+UGNSi//Vg0mQ07ko0DdVtPFWIIeB4AKy/wP9OYRoJKnNmgGhrKK
         rjNA==
X-Gm-Message-State: AC+VfDycrRDtRTSD+QJosp3y83YGx6neSS6vtYZhGns1cfyvoX+S2GmD
        07gcwrb00XP/YPT8Sn/m75TYcg==
X-Google-Smtp-Source: ACHHUZ7Qe0iBjeZmvcgnaHOBEs733JZVei10a9MeOfdNB6l5X05u502QW9KQ28OgeMcXVjjkg2bwog==
X-Received: by 2002:a17:902:ec8a:b0:19f:87b5:1873 with SMTP id x10-20020a170902ec8a00b0019f87b51873mr342789plg.62.1684364526317;
        Wed, 17 May 2023 16:02:06 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id d15-20020a170902728f00b001a69c1c78e7sm18008090pll.71.2023.05.17.16.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 16:02:05 -0700 (PDT)
Date:   Wed, 17 May 2023 16:02:05 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/2][next] scsi: lpfc: Replace one-element array with
 flexible-array member
Message-ID: <202305171602.2C715B078F@keescook>
References: <cover.1684358315.git.gustavoars@kernel.org>
 <6c6dcab88524c14c47fd06b9332bd96162656db5.1684358315.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c6dcab88524c14c47fd06b9332bd96162656db5.1684358315.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 17, 2023 at 03:22:45PM -0600, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element arrays with flexible-array
> members in a couple of structures, and refactor the rest of the code,
> accordingly.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> This results in no differences in binary output.
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/295
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
