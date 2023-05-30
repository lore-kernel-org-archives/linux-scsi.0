Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F275BC77B7E
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 00:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjE3AXw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 20:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjE3AXv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 20:23:51 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF955D9
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 17:23:49 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f4b384c09fso4360662e87.3
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 17:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685406228; x=1687998228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3IMGc8yMr/kl/aiHeadEyKKD1nyc7eKuSSziUK3NCfg=;
        b=UctOk5ux3ps/bRxyOyemot6kNI+AQOKK7oxZuYojsax4Mgr5xQRUKgaSuVT5SdwcA3
         JXfgVAx33BgCXvZ/f0cH0DglG61WVxs4/2DWfJ4a2ij54I4fvYPD3ogpY6/6XqlCIzlp
         Xi2p78zxIXV7UkhqYvJcOs2PuHU1WbbAV+s/t5NIj3v5DcE768TwDHnjdLpOb1fQ6nUX
         WGlSwlfRATPoQKyhPrF9OetChMCXwot85b9fjrYNEdoImAzFn+93Ojkn/v743196iQra
         0f9d3Qul5h1EKT5nB9VJshnz9fp83LQSdTRWJortbgEOSXJWDHMJgGq4TQwGdvsA7dIb
         mCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685406228; x=1687998228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3IMGc8yMr/kl/aiHeadEyKKD1nyc7eKuSSziUK3NCfg=;
        b=UWjHKr6XlXRM3t60Y6moR8MTo42rrwTMWz6FyOWQeYYkFDtYGPXRWDI2PyTebG2eI1
         Wp3E/yr3M/yuZJeF6p+q+JiL/qqzCyiK7VuTFtwfDPybivtjWIH/HD7VimbG+jPyMpJ2
         owgWonywx66IBdzbYGYy5wbcqTtfZ+SzJEV45FG6b0mgzfpnVt4C2GM/Dn73Cmd7hjZT
         KqBcxN0a9TZgyyBn973XxTWOWtHBy5BlNhw4geDbSmIFjA/JEmMhIW2YUvkXOxey1aZE
         X/mRoFZ3AUQkDJQa2qwFYu+IKLGT4KI3sKmp3JJRuLQ+mYz1uLUsYUPC5I9ylF2JtZyD
         Qpfg==
X-Gm-Message-State: AC+VfDzSNUhA0GNItSqZ4A+yBovoIQKtP4eo9Zw/qbVUrehK2zkxAd4v
        V/GdqCdZ+aaZOORrZHuNOYUrMfZBNg9pjMJjhw==
X-Google-Smtp-Source: ACHHUZ4ugHnUCb/jyTTxlgIOEF3nw7gnNiv5cXiIs4wGzsND6tqIZf0PT4SZaDnp51WLgmeawaBOuaxTtFDMNc3fQJI=
X-Received: by 2002:ac2:52b2:0:b0:4f3:93d6:f969 with SMTP id
 r18-20020ac252b2000000b004f393d6f969mr63161lfm.59.1685406227695; Mon, 29 May
 2023 17:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1685396241.git.quic_nguyenb@quicinc.com>
In-Reply-To: <cover.1685396241.git.quic_nguyenb@quicinc.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Tue, 30 May 2023 08:23:35 +0800
Message-ID: <CAGaU9a_fNjpnguLi-=CbakyA35T4SYjNzgH3-94d-GEMN-fxLw@mail.gmail.com>
Subject: Re: [PATCH v7 0/7] ufs: core: mcq: Add ufshcd_abort() and error
 handler support in MCQ mode
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc:     quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        bvanassche@acm.org, mani@kernel.org, stanley.chu@mediatek.com,
        adrian.hunter@intel.com, beanhuo@micron.com, avri.altman@wdc.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bao,

On Tue, May 30, 2023 at 6:14=E2=80=AFAM Bao D. Nguyen <quic_nguyenb@quicinc=
.com> wrote:
>
> This patch series enable support for ufshcd_abort() and error handler in =
MCQ mode.
>
> Bao D. Nguyen (7):
>   ufs: core: Combine 32-bit command_desc_base_addr_lo/hi
>   ufs: core: Update the ufshcd_clear_cmds() functionality
>   ufs: mcq: Add supporting functions for mcq abort
>   ufs: mcq: Add support for clean up mcq resources
>   ufs: mcq: Added ufshcd_mcq_abort()
>   ufs: mcq: Use ufshcd_mcq_poll_cqe_lock() in mcq mode
>   ufs: core: Add error handling for MCQ mode
>
>  drivers/ufs/core/ufs-mcq.c     | 259 +++++++++++++++++++++++++++++++++++=
+++++-
>  drivers/ufs/core/ufshcd-priv.h |  18 ++-
>  drivers/ufs/core/ufshcd.c      | 256 ++++++++++++++++++++++++++++++++---=
-----
>  drivers/ufs/host/ufs-qcom.c    |   2 +-
>  include/ufs/ufshcd.h           |   5 +-
>  include/ufs/ufshci.h           |  23 +++-
>  6 files changed, 501 insertions(+), 62 deletions(-)
> ---
> Changes compared to v6:
> patch #7: Added a new argument force_compl to function ufshcd_mcq_compl_p=
ending_transfer().
>           Added a new function ufshcd_mcq_compl_all_cqes_lock().
>           This change is to handle the case where the ufs host controller=
 has been reset by
>           the ufshcd_hba_stop() in ufshcd_host_reset_and_restore() prior =
to calling
>           ufshcd_complete_requests(). The new logic is added to correctly=
 complete all the
>           commands that have been completed in the Completion Queue, or i=
nform the scsi layer
>           about those commands that are still stuck/pending in the hardwa=
re.
> ---
> v5->v6: Addressed Stanley's comments
> patch #1,2,3,4,6: unchanged.
> patch #5: fixed extra erroneous if() statement introduced in version v5
> patch #7: Change ufshcd_complete_requests() to call a new mcq function
>           ufshcd_mcq_compl_pending_transfer(), leaving ufshcd_transfer_re=
q_compl()
>           to be used in SDB mode only.
>
>           Reset the hwq's head and tail slot variables to default values
>           when the ufs host controller hw has been reset.
> ---
> v4->v5:
> patch #4: fixed uninitialized variable access introduced in patch v3.
> ---
> v3->v4: Mainly addressed Bart's comments
> patch #1: updated the commit message
> patch #2: renamed ufshcd_clear_cmds() into ufshcd_clear_cmd()
> patch #3: removed result arg in ufshcd_mcq_sq_cleanup()
> patch #4: removed check for "!rq" in ufshcd_cmd_inflight()
>           avoided access to door bell register in mcq mode
> patch #5, 6: unchanged
> patch #7: ufshcd_clear_cmds() to ufshcd_clear_cmd()
> ---
> v2->v3:
> patch #1:
>   New patch per Bart's comment. Helps process utp cmd
>   descriptor addr easier.
> patch #2:
>   New patch to address Bart's comment regarding potentialoverflow
>   when mcq queue depth becomes greater than 64.
> patch #3:
>   Address Bart's comments
>   . Replaced ufshcd_mcq_poll_register() with read_poll_timeout()
>   . Replace spin_lock(sq_lock) with mutex(sq_mutex)
>   . Updated ufshcd_mcq_nullify_cmd() and renamed to ufshcd_mcq_nullify_sq=
e()
>   . Minor cosmetic changes
> patch #4:
>   Adress Bart's comments. Added new function ufshcd_cmd_inflight()
>   to replace the usage of lrbp->cmd
> patch #5:
>   Continue replacing lrbp->cmd with ufshcd_cmd_inflight()
> patch #6:
>   No change
> patch #7:
>   Address Stanley Chu's comment about clearing hba->dev_cmd.complete
>   in clear ufshcd_wait_for_dev_cmd()
>   Address Bart's comment.
> ---
> v1->v2:
> patch #1: Addressed Powen's comment. Replaced read_poll_timeout()
> with ufshcd_mcq_poll_register(). The function read_poll_timeout()
> may sleep while the caller is holding a spin_lock(). Poll the registers
> in a tight loop instead.
> --
> 2.7.4
>

Feel free to add below tags to this series,

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Tested-by: Stanley Chu <stanley.chu@mediatek.com>
