Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 341D9C7EE33
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 19:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbjEVTkK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 15:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235134AbjEVTjz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 15:39:55 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5870111A
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 12:39:50 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-64d3fdcadb8so2290745b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 12:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684784389; x=1687376389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H5RqcsZrHQ+sjRlKQFXMF6X3aaR4SZn4pKZGgKU1YWg=;
        b=R31XgMZUzGR6DdVrmbq8rfIYc7SyOMXqcY0H7pvGchQt1B4VQC4D7lXyV+gm6ZUtxW
         01HtBFXbSkM9NyGXFvOS6DtSfjwr9fPnJ6nEAa0ZvZ1vfTzDpQRHpecl78vUq0HCssYL
         6QxuF3n/ucpgcH4XjhN3wiiYtJW0l0l0wBoao=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684784389; x=1687376389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H5RqcsZrHQ+sjRlKQFXMF6X3aaR4SZn4pKZGgKU1YWg=;
        b=N+r2o/qfAb9BwP1tA9ZLiaY73uoSyH0E4ZmwgcIm5s+A5Rxss7r7NxR3B4hXmTOYV9
         oY56RV6mjj1VdXNf9L4VBaSJJ8+DSXCM5uPB6w8ZngyqU4QtwVyuxQ8FQOPITge4p/Of
         SEi9XiaV1lXBBf0mijbMFYFjUovMfSaoI4nDltYaoXs8PbMdcnvlGd310BEYGMS0oOxa
         xF7OxFYJEqmreT2PT9yz1YlRRx3RZFCqkZynnGZrOZCMTgAjNRUhzHMZWNKUtkQF7Ehm
         EIVLcO7PGb1sxp132bDjShFT2oNtFCQSW823yMhkqQJGn4CskjFeOOZRC7roaywWaXLO
         eXMQ==
X-Gm-Message-State: AC+VfDzEBQRzGTPdYjlmYoQcddcXYb2VjjEH/eZIqLKWx3WYSfp4b6uJ
        bsbqTB8o5Q0USuniE6C4dliKug==
X-Google-Smtp-Source: ACHHUZ5Feu4PuUW4w9WTgTQrMG+v/QmFNOiL5RD1syYCI0wPs30vDwADkA8yVxZQTalAjCJLq+cnJQ==
X-Received: by 2002:a05:6a00:2e01:b0:64d:3fb3:9ed9 with SMTP id fc1-20020a056a002e0100b0064d3fb39ed9mr13637170pfb.23.1684784389535;
        Mon, 22 May 2023 12:39:49 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a19-20020aa78653000000b0064d74808738sm1625690pfo.214.2023.05.22.12.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 12:39:47 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     azeemshaikh38@gmail.com, Adam Radford <aradford@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jejb@linux.ibm.com, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: 3w-9xxx: Replace all non-returning strlcpy with strscpy
Date:   Mon, 22 May 2023 12:39:37 -0700
Message-Id: <168478437626.244538.8257051598276343700.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517142955.1519572-1-azeemshaikh38@gmail.com>
References: <20230517142955.1519572-1-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 May 2023 14:29:55 +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> No return values were used, so direct replacement is safe.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] scsi: 3w-9xxx: Replace all non-returning strlcpy with strscpy
      https://git.kernel.org/kees/c/fa36c95739ab

-- 
Kees Cook

