Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F28C76196
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Mar 2023 19:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbjCaTkm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Mar 2023 15:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCaTkl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2023 15:40:41 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE042031B
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 12:40:40 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id ew6so93851247edb.7
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 12:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680291638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RtTQ0TelFNvhr4v7pTDd7Onq7BMotPFdtCiDNz4aL30=;
        b=EFy78E2prR8ZYhcuKqdYGs40YHr2i3GiKZosRe1Fv99wvNvLdWbV0A9hrU07K6msOw
         wWxrTr9gldFZck9SiBs7jbQWVc+cgwKsI5dlR5V/yUb5L2lPe/A93vGaCPulcGqiHfvR
         VM8pUB8UbXmz8GYtM6xm1cZAlLVNXXwddMLSZD4WOwqnzYZHuFgj5C/hGse076z2eZ/u
         dZOoTWJCiqt4fai4IbAAo8b8JVInVTju4UrzJENeAwFdstYIDkPlrbI9rDLnJkT3hszR
         7w/iIBvz508lW6ULw8Zd3ey+LqrqQf9tb0Pfp+qzRz8W0vmoD2MjJwTujTw14TKVFNR6
         tm8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680291638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RtTQ0TelFNvhr4v7pTDd7Onq7BMotPFdtCiDNz4aL30=;
        b=MjcKZmaTQwrj91vM9ewRTe/fQNs5bv40eQP34uk+kNzZWMqZEtSWGqUYSdLEQ2xbFW
         224/jRFc3VLm3ZQKE/J0lbI4ftkD5tlBPEf2K/4RJSPHJSnPvFuRCcJZa13HpqYNlnoH
         Lm+HTybIWqBmrWikGkf8EjiiOMYo/AcDJROwJnRIoR3kLs6WVa+Qp9OmHNZytJwrw6Z5
         f5C3fpajsxoyJ6PasUOL0b/Q3TqWoC31ciEC3buCa5noVWZbmMiealhqHI+/6PRVsRCN
         RNGWM69JZtbimRC13Dj+RY1KvUGAnG4guh51g9cnP4PFMca9GcX6j1sDfYQI4UetFecq
         WGUw==
X-Gm-Message-State: AAQBX9cznoZ/yO7OwS0iz2biioCSGkMibKD/o8Wib1ilyXlV7KAYg2TZ
        ORs7WBxIb+KeAPj4Rf/soeSQfoYSA7c329miSbNX
X-Google-Smtp-Source: AKy350b3mO4IJPWsNH8c3fw7cF8cRUVt6va8TDdBGqfTrjVXbCCAEOg2A7LUxUP5vXb7R8jRxuAKEsuyPPjUS3Jx1pQ=
X-Received: by 2002:a50:8712:0:b0:4fa:123:3b32 with SMTP id
 i18-20020a508712000000b004fa01233b32mr14378356edb.7.1680291638380; Fri, 31
 Mar 2023 12:40:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230331162617.1858394-1-trix@redhat.com>
In-Reply-To: <20230331162617.1858394-1-trix@redhat.com>
From:   Bill Wendling <morbo@google.com>
Date:   Fri, 31 Mar 2023 12:40:22 -0700
Message-ID: <CAGG=3QUYibiR2FLkLWBzr-j9X9nXLJVvmi5WqF=WmRZfgW3tRw@mail.gmail.com>
Subject: Re: [PATCH] scsi: message: fusion: remove unused timeleft variable
To:     Tom Rix <trix@redhat.com>
Cc:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, nathan@kernel.org,
        ndesaulniers@google.com, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 31, 2023 at 9:26=E2=80=AFAM Tom Rix <trix@redhat.com> wrote:
>
> clang with W=3D1 reports
> drivers/message/fusion/mptsas.c:4796:17: error: variable
>   'timeleft' set but not used [-Werror,-Wunused-but-set-variable]
>         unsigned long    timeleft;
>                          ^
> This variable is not used so remove it.
>
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/message/fusion/mptsas.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mpt=
sas.c
> index 86f16f3ea478..d458665e2fc9 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -4793,7 +4793,6 @@ mptsas_issue_tm(MPT_ADAPTER *ioc, u8 type, u8 chann=
el, u8 id, u64 lun,
>         MPT_FRAME_HDR   *mf;
>         SCSITaskMgmt_t  *pScsiTm;
>         int              retval;
> -       unsigned long    timeleft;
>
>         *issue_reset =3D 0;
>         mf =3D mpt_get_msg_frame(mptsasDeviceResetCtx, ioc);
> @@ -4829,8 +4828,6 @@ mptsas_issue_tm(MPT_ADAPTER *ioc, u8 type, u8 chann=
el, u8 id, u64 lun,
>         mpt_put_msg_frame_hi_pri(mptsasDeviceResetCtx, ioc, mf);
>
>         /* Now wait for the command to complete */
> -       timeleft =3D wait_for_completion_timeout(&ioc->taskmgmt_cmds.done=
,
> -           timeout*HZ);

It looks bad to remove the call to wait_for_completion_timeout(). Is
it truly not needed? If it's needed, the "timeleft" should be checked
or a comment left to explain why it's not checked.

-bw

>         if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) =
{
>                 retval =3D -1; /* return failure */
>                 dtmprintk(ioc, printk(MYIOC_s_ERR_FMT
> --
> 2.27.0
>
>
