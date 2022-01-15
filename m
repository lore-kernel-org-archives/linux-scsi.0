Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB3AC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Jan 2022 12:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiAOMRB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 Jan 2022 07:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiAOMRA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Jan 2022 07:17:00 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B494C061574
        for <linux-scsi@vger.kernel.org>; Sat, 15 Jan 2022 04:17:00 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id x11so13564291lfa.2
        for <linux-scsi@vger.kernel.org>; Sat, 15 Jan 2022 04:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WQtdnNcald62hz/hbvCJAXG0reAaFE2AXgSCwQ50ox0=;
        b=PWXFCBfYkJFGgH8hNiHrdRgHXFFwVS0CKM4FWUihJ/8RF4aduarsmSN8gu/z1HC4Ep
         1rELyGKY385abMdVYMQbTDPA8rD4QFVPYtYx0tTda1SCkz/2nBJLx2eChTrMXuzyEZZE
         GNiYSd73TR7YR3ddW7Zr9yPb6fDr3xTTcPZ1eBbf2bEWqWLSvgcCzfXOAl72HfbIj746
         TIyCb+WcecQAyF89h9/uba/08fu5k+tCyT6QKPkTroZZsn5TiaxQETh4lcoqh1sMxtlw
         urSDqFMFYwbl+5kSO7jBQCExkTpuMZVjoIzZjdkodZE4FHSXYA0y2cg0rwGZjATwSnh0
         r89g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WQtdnNcald62hz/hbvCJAXG0reAaFE2AXgSCwQ50ox0=;
        b=hMm/VFabRh0QZ8JDLVY2IWJDFa9eQtaBhcyq1yvg2HMbihKYtB5mVPqk3coMCgpo0X
         opldNJcK+4He98kC8MgDRlnCRJ5p63h9q14j//HxlGMdZC/X0NOcrgozOlsWTaAV2ArT
         ojaihE4dDTvHzfQl5g6/LLyarQOXbrlNLpJ+ejZTtvu0wr96K6FCwuNJYu6u+qdr2oUk
         9ca4T9Erkl9y8hEOutDTeHaxnbSevXAWNzx+cA1lmPPxR0sj7t+OKIbIyrbkHdkCOjUM
         7V6Hl2sUNRVLaqDc6ULw/X3WS5TCtmROPbyj0XCevF740S4GR7VFRS4SYHm0eGbw8MVY
         F9Eg==
X-Gm-Message-State: AOAM532QIumhd/LQTlLG3ggbOa6JAtc0V22W1eQm6YhnkwsA/S2uQib2
        RSrXASCueS9VdA844JZKEFMRwD+pHOMwjuAxnHH+g4fO
X-Google-Smtp-Source: ABdhPJwoKjRp0jDMVULecPR0XktoR0qM+TEWEYriHAZSMndbB/x0FZpJzh/cu1unarA2zSh0Wb+wEsY5bAqhTcSDEtk=
X-Received: by 2002:a05:651c:1a21:: with SMTP id by33mr1626123ljb.191.1642249018019;
 Sat, 15 Jan 2022 04:16:58 -0800 (PST)
MIME-Version: 1.0
References: <bug-215447-11613@https.bugzilla.kernel.org/> <bug-215447-11613-0W09B9Q7hY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215447-11613-0W09B9Q7hY@https.bugzilla.kernel.org/>
From:   Christopher Horler <cshorler@googlemail.com>
Date:   Sat, 15 Jan 2022 12:16:46 +0000
Message-ID: <CAAeT8m85f_WMV-Ozp9zNcP-BM8NHENpaKemjZUaOmcj6c7WEOQ@mail.gmail.com>
Subject: Re: [Bug 215447] sr_mod scsi_mode_sense() failure -> "scsi-1 drive"
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Is anyone able to comment on the sr_mod / cdrom / mptsas issue I'm
experiencing (see details in bug)?
I fixed my issue with a one line patch, but I'd like to know if it's
correct and what I should do to have it integrated upstream.

Thanks, Chris

On Sat, 15 Jan 2022 at 11:42, <bugzilla-daemon@bugzilla.kernel.org> wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=215447
>
> --- Comment #4 from Chris Horler (cshorler@googlemail.com) ---
> self-ping my list-email
>
> --
> You may reply to this email to add a comment.
>
> You are receiving this mail because:
> You are watching the assignee of the bug.
