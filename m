Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3D1C10DCE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 06:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B33CF20768
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 06:41:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Z5QxTJS7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCRGlm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 02:41:42 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36617 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgCRGlm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 02:41:42 -0400
Received: by mail-oi1-f195.google.com with SMTP id k18so24648704oib.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2020 23:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hM0cpXp7RSKNn1lZVtejbipEk/jiFWNrNvwo++TDYOo=;
        b=Z5QxTJS7anNzaITsd+QcGv7EiJD1BqTar8NM5zTYDnngRB3NdZePyzWf+FEnamM1Qz
         baEp2FDaUDFVEiNnjLZ5SmpW86e8lfYcavpCiIvockHYpEt666YmvpA6TiJY4Fk/F9Jg
         7C7hOdqyzsCnxHze7gsInIxlK0oJY5iIz/0L0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hM0cpXp7RSKNn1lZVtejbipEk/jiFWNrNvwo++TDYOo=;
        b=Is9I8pEv6p6pbT1d4WS5u3xKr/ma/qIysCTAGWsQ7NtJ3/oBZGLx0hEy/TgQtGk7W8
         m6fAge1bvYd09yEjhYyrMCsllYKMJYzVYH6A41H2d7hv/pmt9ygJ8zQMG8Hfe+wUL/xL
         WuyrIns/4ppk40VAqXVzYpSeOaXT7v3NdRRvyRi7cNS376u74YJ4+P7qUEbwBvL8ciGa
         LYnFLTpfi+0YeYHxJHrgJu4W1k7RxsVrhKsFRcyfUhs8drrjhiZdSjg0zkkWizWbyIJQ
         JubVLzIlZQ/VlaGSYE/mhViCV1g/X3u8Cw/CnYoAb6vwVbjd4NuM8EBjnkZ1F6qJQWp4
         iW4g==
X-Gm-Message-State: ANhLgQ02lwCOAy+trdP1UKTW9SaAMRNcqJD44TQNxcYVGQwSxv/nimMg
        UVyCnXbebd8nSXVVQ6SDdOHhLnzw5PT035d0DyLt9Q==
X-Google-Smtp-Source: ADFU+vtwJS/04e/sPRotCIfgO5c8RWhXtXX4RMO+Aniq2R5Pxlfx07gegMaHzJ0Nd4Oydw5aCjPc3VkCtiMQTmvFn2Q=
X-Received: by 2002:aca:ab4b:: with SMTP id u72mr2136672oie.26.1584513701482;
 Tue, 17 Mar 2020 23:41:41 -0700 (PDT)
MIME-Version: 1.0
References: <1584001735-22719-1-git-send-email-sreekanth.reddy@broadcom.com> <20200317223026.0B8E020752@mail.kernel.org>
In-Reply-To: <20200317223026.0B8E020752@mail.kernel.org>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Wed, 18 Mar 2020 12:11:29 +0530
Message-ID: <CAK=zhgoabpaMCfJ6WOqzwnzRhDNwHwL=se=bj7_vAz0NKr1UJw@mail.gmail.com>
Subject: Re: [PATCH v1] mpt3sas: Fix kernel panic observed on soft HBA unplug
To:     Sasha Levin <sashal@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 18, 2020 at 4:00 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.5.9, v5.4.25, v4.19.109, v4.14.173, v4.9.216, v4.4.216.
>
> v5.5.9: Build OK!
> v5.4.25: Build OK!
> v4.19.109: Build OK!
> v4.14.173: Build OK!
> v4.9.216: Failed to apply! Possible dependencies:
>     c666d3be99c0 ("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")
>
> v4.4.216: Failed to apply! Possible dependencies:
>     96902835e7e2 ("mpt3sas: Eliminate conditional locking in mpt3sas_scsih_issue_tm()")
>     98c56ad32c33 ("mpt3sas: Eliminate dead sleep_flag code")
>     c666d3be99c0 ("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

This fix patch is applicable only for below stable kernels,
v5.5.9, v5.4.25, v4.19.109, v4.14.173

Please let me know if I need to resend this patch by specifying the
list of stable kernels on those this patch is applicable?

Thanks,
Sreekanth

>
> --
> Thanks
> Sasha
