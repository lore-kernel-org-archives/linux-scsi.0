Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05E4C77B7D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 19:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjEQTNo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 15:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjEQTNj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 15:13:39 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95F3AD27
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 12:13:34 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1ae4c5e1388so12838745ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 12:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684350814; x=1686942814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/1LoPTJbncGj0zRlQjVQv3mXnAMywvSaO6mLN0ylsDA=;
        b=lzIhsYITQfnlvkxnxaTLqpMZDUwTS8G8kKF8F549pn5Veo9fN0ljeVbZH/2hili2zP
         VDCZgc0qG1i7EHVLCRzwIlpFEX6MKfZ4glGslTOLBrY/R7scFgR4yxgzAtgxv3PZx36I
         UQJb9eVcN6zf+G6ZnK4le7uqSGLx+KvUGEJqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684350814; x=1686942814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/1LoPTJbncGj0zRlQjVQv3mXnAMywvSaO6mLN0ylsDA=;
        b=OYuwq29ZMjXJtUA82lUKR9u8YrOD5/UbXHZ21DVYF8I0rUpoaNefqxWv7F4piM06vX
         6q9B8H4T/8jz59nwFtmc8JWCIG6AFDOaGos6nD68Q/fqKxZ7m+tfp9QfTW2QacS/Wv56
         YS1b2RfypFSgc3qbIj+w89hU/cEXNu4blieqH5Qls4BXLcV0yw0GErhpuHw5C6cck7Zz
         8yn6d3Lu48t/uthi1y3i/Uy4kO9GRL08L15iL1JcZPTVjxn9YHdszVv+WmTOEmI+j06B
         VIWVzJ0C8zi7Hj48CCyJrXfwHL3u/cdaXX5n2tJZ3TjTdgwMyB7OlVy37qS+TieBlU4Y
         uIVw==
X-Gm-Message-State: AC+VfDwbC6pYl1/YgGD8MnbmKYAo7O0gKL0vhz2QA2XE88n3rdr226A8
        mikIVabK2EL/HC3gB6uMUOZ+1g==
X-Google-Smtp-Source: ACHHUZ4JPsHm4F2JyvSlEeT7wms9HdBEUFjbBD3IpAsMfcJwtkQsjelIUPjNuG827RbZkDbKc67HDQ==
X-Received: by 2002:a17:903:41ca:b0:1aa:d545:462e with SMTP id u10-20020a17090341ca00b001aad545462emr56626362ple.13.1684350814555;
        Wed, 17 May 2023 12:13:34 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id iz3-20020a170902ef8300b001ac444fd07fsm14196116plb.100.2023.05.17.12.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 12:13:34 -0700 (PDT)
Date:   Wed, 17 May 2023 12:13:33 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Azeem Shaikh <azeemshaikh38@gmail.com>
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aacraid: Replace all non-returning strlcpy with
 strscpy
Message-ID: <202305171213.4BE193E@keescook>
References: <20230517143049.1519806-1-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517143049.1519806-1-azeemshaikh38@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 17, 2023 at 02:30:49PM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> No return values were used, so direct replacement is safe.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
