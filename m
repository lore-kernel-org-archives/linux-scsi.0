Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71268C7EE37
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 19:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbjEVTkH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 15:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235149AbjEVTj5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 15:39:57 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278B7192
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 12:39:51 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1afbc02c602so7556335ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 12:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684784390; x=1687376390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kXaL9dlHiKAWAhbj1etQPCvf7dMzBz97/ah3yQwMB6g=;
        b=gpoq1bHzwlKS0iPW5k3t8e7bBhtTtRx0pYG/1AYIumv9bP7LU7vzTmv5vFfXH1drXd
         FdbjXVUfztD3qECHwfpWjSZLWiQONT4xGMAkugw9xTAzr1R+a3U5KuknPl9d5CFJidqr
         3IhLk1mlMqjJUkJkGq6L0ayNJXNAP3JA3bfdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684784390; x=1687376390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kXaL9dlHiKAWAhbj1etQPCvf7dMzBz97/ah3yQwMB6g=;
        b=FSk9/UYtaDXzqCbZJRk6GobAo6eHFcxs5jzCrpoFOBM4QwEOyREVctP+dxlYFLoERc
         uz1rcE8bSfVornQWhB7zjWdHm7iVj4fxs9/P8vT78nCzZoR6R5mpSyu003KM0jnF6ORC
         h0i/K7YjdpffZYYi2qsQCTSutRRYX3rnhNAcUT5P/Et0+7NPbQ/8RtEPDBLdaljscteA
         DUL3I+9RSiAGVIp4pgvthzFu2TSOwcrpQpe+mq7Box88F5eJNAcL9Zuf0YT+Z0QRU6Pd
         CGtD/LMEBv8IlMwv0HcV6O4cSIgErJu/9vBryRpuR8HiRjrvIrfavAZEU6sjeXZSbGyD
         zJUQ==
X-Gm-Message-State: AC+VfDxBEiUjUClORVqw8ehk2jfxEqwffzq//5vzMSbR3GWkglxIEOQ7
        brSKHA75MigtqNHZuKUqX49bdg==
X-Google-Smtp-Source: ACHHUZ5VIiMuHu+1y0eouyzj3q+4VKQ8xUtRKBhL4r1JwoLQxR5w8tpqBRw8gj/5ob3Z7R875tYTXg==
X-Received: by 2002:a17:903:452:b0:1af:cbdb:9772 with SMTP id iw18-20020a170903045200b001afcbdb9772mr34695plb.18.1684784390635;
        Mon, 22 May 2023 12:39:50 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id bh12-20020a170902a98c00b001a6388ce38bsm5183579plb.240.2023.05.22.12.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 12:39:49 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, azeemshaikh38@gmail.com
Cc:     Kees Cook <keescook@chromium.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jejb@linux.ibm.com, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: bnx2i: Replace all non-returning strlcpy with strscpy
Date:   Mon, 22 May 2023 12:39:39 -0700
Message-Id: <168478437625.244538.13691044123707581954.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517143130.1519941-1-azeemshaikh38@gmail.com>
References: <20230517143130.1519941-1-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 May 2023 14:31:30 +0000, Azeem Shaikh wrote:
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

[1/1] scsi: bnx2i: Replace all non-returning strlcpy with strscpy
      https://git.kernel.org/kees/c/91f1887a1420

-- 
Kees Cook

