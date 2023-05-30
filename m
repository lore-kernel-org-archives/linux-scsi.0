Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47EFFC7EE23
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 23:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbjE3XR7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 19:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbjE3XRy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 19:17:54 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7378F1A1
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 16:17:43 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b04782fe07so18071035ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 16:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1685488663; x=1688080663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5kMrqqORy60OYsKh+0hdgGppzkT4bCtjtqNCdTA8b/A=;
        b=h8gfttxwxyKja7yeHzvx8964FyoRcUtxJzUEEAWz3kHP6Z29hGrpBAwjV5rQT68jH8
         M7VC5TOW9EMruuJHT4rx/fIsHAQSSbWc0OYBrV/DAZq+XaOLnZl8wTBSRM6/mvWhaJY6
         4Y6XF2p5clZBwlQtdEsC5rRjCvi+PLSMz4qVY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685488663; x=1688080663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5kMrqqORy60OYsKh+0hdgGppzkT4bCtjtqNCdTA8b/A=;
        b=bSP7/1Q3mmQgVkkw3ndw8zkvdH8sJwy4TW9eIEwMd8gNNh1aEO7HdRFyQuNKIiD75o
         ggfnGvxMvQPFTch24Hb5nKW1QBGWhehFh3hbqK1yeXhWzECQNElKQSIKRnI5gqDXLqFZ
         QQcwU2wbUENCd3Xx9yPWSs4f+eUU+E5wWeWDxF6ogfstdEEZvIQURuOpYlcX17/IzCCZ
         7iqG7BPaBUkdCkUOrVTrY0girAOVvSn136jBVHIZFhzG5KGRWmlpHA4SzP45ItrEmGs7
         iohaTXxE5DfkVLgFwmGV1n7U6hKgqb2/BeqqkG1K6Nw8r8+EAOJRbuxZhoAfvgxUo5P4
         VwJQ==
X-Gm-Message-State: AC+VfDxxhxHEnE/sJMPxd/U5+z2MRMwBgWtN6av6b68P1ede1zJCG0Mb
        sC2gxVCRlWWmlIZceUhbItdu6g==
X-Google-Smtp-Source: ACHHUZ5jiwQCWBkrZz3K8KqplAJMedpRiKJUVLueKQvFurMiNQqwvdcBK+jbpJ5mg02xOxUhtSPJoQ==
X-Received: by 2002:a17:902:db0f:b0:1ac:750e:33ef with SMTP id m15-20020a170902db0f00b001ac750e33efmr4403319plx.3.1685488662885;
        Tue, 30 May 2023 16:17:42 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902bd4b00b001ab2b415bdbsm10835231plx.45.2023.05.30.16.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 16:17:42 -0700 (PDT)
Date:   Tue, 30 May 2023 16:17:41 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Azeem Shaikh <azeemshaikh38@gmail.com>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        linux-hardening@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: message: fusion: Replace all non-returning strlcpy
 with strscpy
Message-ID: <202305301617.F508DC762@keescook>
References: <20230530160248.411637-1-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530160248.411637-1-azeemshaikh38@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 30, 2023 at 04:02:48PM +0000, Azeem Shaikh wrote:
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
