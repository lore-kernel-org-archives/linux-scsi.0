Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98279C77B73
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 19:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbjEVTps (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 15:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbjEVTpr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 15:45:47 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DEECF
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 12:45:45 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-19674cab442so4896981fac.3
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 12:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684784744; x=1687376744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jNAaP6+XJai6xtjlcDTjy2E1GXqny00MK+4AdCDW8Kw=;
        b=DLqbWreBhVkCJiiJkvsOkHF49qc5AOlzR848e2BZJfl5KOrNWtcKN0zZaK8usqjzLT
         C7hTUFpnArYccMdkjalMHpC7FCTbWyRe9h6y687XE4XxYV56HiZ1uo9ycIeuleLOT7pn
         QTTtv9AtaHrTpND9AOV6CzQGD+7wg5vRa1ifU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684784744; x=1687376744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jNAaP6+XJai6xtjlcDTjy2E1GXqny00MK+4AdCDW8Kw=;
        b=CeriY1+89bEPeCHDSO84T2QApSDKM8esTdio9TKRV8wCdhZ/FR3dmCFGBF3TZDAvBZ
         2ISnzw7kCB5Wbdh0H4HUqvETr5sgWnNh9g2zTcIXLoKcilbEFFsEb32Zmh6vZYqsbR1J
         9egUKe6OuiznxluuUbVMwlcJM7g2ioOs7CB7266BfsEqq5m8YuJKSrcpYHtCu4btBfvw
         C1mUXB967ZIAAH3Gk+znx0wymjjVF7yJTdfFGmYD/pM1+uFRg/2T3PD9+BKrh8Mu/oNJ
         MU30Yn5+mPRclfq6QcHo2UqGrG25oznKiL9vELE709z2lelBYUWxl+mEcRvfUeUoSxUa
         xDUQ==
X-Gm-Message-State: AC+VfDwd4EwX4GD/6mg73Ga+XnyOOJ3M0k4dDRda8/yiAKt63x1Zz0oT
        qeSUVYC66se94mvj/PwPhCYQVTF8IRmw4wiELNA=
X-Google-Smtp-Source: ACHHUZ7XSGaVK8OAFHtgEWwhmN/dPCgY/hsNSkZ6wHyqo93wCVtLQOXdhbv7Nf33xNA7cZ9ma8oqXA==
X-Received: by 2002:a17:90a:70ce:b0:255:4f4c:368 with SMTP id a14-20020a17090a70ce00b002554f4c0368mr5138998pjm.27.1684784390970;
        Mon, 22 May 2023 12:39:50 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id r13-20020a17090a940d00b0025352448ba9sm6234829pjo.0.2023.05.22.12.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 12:39:49 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     azeemshaikh38@gmail.com, tyreld@linux.ibm.com
Cc:     Kees Cook <keescook@chromium.org>, mpe@ellerman.id.au,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        christophe.leroy@csgroup.eu, npiggin@gmail.com,
        linux-kernel@vger.kernel.org, jejb@linux.ibm.com,
        linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] scsi: ibmvscsi: Replace all non-returning strlcpy with strscpy
Date:   Mon, 22 May 2023 12:39:40 -0700
Message-Id: <168478437624.244538.16463667694387498508.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517143409.1520298-1-azeemshaikh38@gmail.com>
References: <20230517143409.1520298-1-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 May 2023 14:34:09 +0000, Azeem Shaikh wrote:
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

[1/1] scsi: ibmvscsi: Replace all non-returning strlcpy with strscpy
      https://git.kernel.org/kees/c/015f6618194e

-- 
Kees Cook

