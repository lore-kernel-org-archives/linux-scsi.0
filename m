Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FAB7C77B7A
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 22:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbjE3Wov (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 18:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjE3Wou (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 18:44:50 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A489106
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 15:44:47 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-2563ca70f64so2940081a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 15:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1685486686; x=1688078686;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Lpvk61m8kV2Aob9IF7acV7Nqq1ETfXj91v2zUEXV06I=;
        b=FyuD76bD6Wx498UScEb7wg6Rz8mBirQ2uKMnwVjGlWl+JnnfoMVLYTLTLb6Dz7eCCx
         9sg+TmgYzSf87RA5ZS9sdKb8F3kyfoDx2e0u0CYpJVOUANBRnVDrnYwILvBO14qAm2XC
         0OdiEZ2im2nHX8lMWTLHHqtRq9xra53m1vgBI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685486686; x=1688078686;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lpvk61m8kV2Aob9IF7acV7Nqq1ETfXj91v2zUEXV06I=;
        b=Z+3Oj7vKUKUd1fuSmDs1cxM6gVN/laWuKWx2UBLYxUsmS3BdeYA2mnwODfue+TUna6
         Nr6BazeW8w/3TkGnZ55BdJDqedhmRt3PDl+UsqhuhaRvE4N1LJS8cSEUEq7c0tkNGLQw
         icNdCsWGe5qwEWbzCsu8OR/68+mIGLffggyyBxugCYGsMUhAReJ3JI4MRMCZh3rGow5i
         9WO/ZbnrR6pLSRmceHyFkeFFo7z6VJGtWkOch8FSwlFUL6+yIRAWqcgp8ZdAh5pjcjeG
         0zMs6jFBL6vBr9B43Ty/V7/JKFvGTFUW2q3cjP5LKjfE+xvdK/6Ffw4PCm1bv+AGfqCl
         GWuw==
X-Gm-Message-State: AC+VfDwLRQGVxK15bbXh6AxOWTExCYmx2qHI0nuQ7OQcu2w/frsJj+6T
        0C43uda5Aw3f+Hfuf1ds6QfR2Q==
X-Google-Smtp-Source: ACHHUZ4eSr7YyjxG6IwmG9+W0DZTBBwsbnm9MEeWUHeWyz1UYQNtYfRsgqJaKxB95SIn6RfICpOaSw==
X-Received: by 2002:a17:90a:f2c3:b0:256:7e70:309c with SMTP id gt3-20020a17090af2c300b002567e70309cmr3803420pjb.44.1685486686640;
        Tue, 30 May 2023 15:44:46 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x2-20020a17090aa38200b0025069c8a151sm9285560pjp.53.2023.05.30.15.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 15:44:46 -0700 (PDT)
Date:   Tue, 30 May 2023 15:44:45 -0700
From:   Kees Cook <keescook@chromium.org>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: lpfc: Avoid -Wstringop-overflow warning
Message-ID: <202305301529.1EEA11B@keescook>
References: <ZHZq7AV9Q2WG1xRB@work>
 <fe0739cbe279cf9db2ebff1146e7ae540cc1ad6c.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fe0739cbe279cf9db2ebff1146e7ae540cc1ad6c.camel@linux.ibm.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 30, 2023 at 05:36:06PM -0400, James Bottomley wrote:
> On Tue, 2023-05-30 at 15:30 -0600, Gustavo A. R. Silva wrote:
> > Avoid confusing the compiler about possible negative sizes.
> > Use size_t instead of int for variables size and copied.
> > 
> > Address the following warning found with GCC-13:
> > In function ‘lpfc_debugfs_ras_log_data’,
> >     inlined from ‘lpfc_debugfs_ras_log_open’ at
> > drivers/scsi/lpfc/lpfc_debugfs.c:2271:15:
> > drivers/scsi/lpfc/lpfc_debugfs.c:2210:25: warning: ‘memcpy’ specified
> > bound between 18446744071562067968 and 18446744073709551615 exceeds
> > maximum object size 9223372036854775807 [-Wstringop-overflow=]
> >  2210 |                         memcpy(buffer + copied, dmabuf->virt,
> >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >  2211 |                                size - copied - 1);
> >       |                                ~~~~~~~~~~~~~~~~~~
> > 
> 
> This looks like a compiler bug to me and your workaround would have us
> using unsigned types everywhere for sizes, which seems wrong.  There
> are calls which return size or error for which we have ssize_t and that
> type has to be usable in things like memcpy, so the compiler must be
> fixed or the warning disabled.

The compiler is (correctly) noticing that the calculation involving
"size" (from which "copied" is set) could go negative.

The "unsigned types everywhere" is a slippery slope argument that
doesn't apply: this is fixing a specific case of a helper taking a
size that is never expected to go negative in multiple places
(open-coded multiplication, vmalloc, lpfc_debugfs_ras_log_data, etc). It
should be bounds checked at the least...


struct lpfc_hba {
	...
	uint32_t cfg_ras_fwlog_buffsize;
	...
};

lpfc_debugfs_ras_log_open():
	...
        struct lpfc_hba *phba = inode->i_private;
        int size;
	...
	size = LPFC_RAS_MIN_BUFF_POST_SIZE * phba->cfg_ras_fwlog_buffsize;
        debug->buffer = vmalloc(size);
	...
        debug->len = lpfc_debugfs_ras_log_data(phba, debug->buffer, size);
	...

lpfc_debugfs_ras_log_data():
	...
                if ((copied + LPFC_RAS_MAX_ENTRY_SIZE) >= (size - 1)) {
                        memcpy(buffer + copied, dmabuf->virt,
                               size - copied - 1);

Honestly, the "if" above is the weirdest part, and perhaps that should
just be adjusted instead:

	if (size <= LPFC_RAS_MAX_ENTRY_SIZE)
		return -ENOMEM;
	...
		if (size - copied <= LPFC_RAS_MAX_ENTRY_SIZE) {
			memcpy(..., size - copied - 1);
                        copied += size - copied - 1;
                        break;
		}
		...
        }
        return copied;



-- 
Kees Cook
