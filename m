Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8349CC433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 07:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62CFC61582
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 07:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhC3Hb1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 03:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhC3Ha7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Mar 2021 03:30:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C77E61953;
        Tue, 30 Mar 2021 07:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617089459;
        bh=89DgxQC8PTyukm1mDqpIejFWerzPhaf6+PaOBTtGORk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ugJCV1z8a13ckwEFFHho9/CI3tgJfQQoIpMtiiRRsMgxlj5IznPzdRTzXSB4/NXv3
         4hln6kdANarsJhcWaWmR7DFSKrMP12h6YI06empfG+U5dVuCzX/xt+sQDmXucJkxZk
         cYSQneGIMMAe4yg2sW6XpD9iXLvIGKlx2pGO18/R6IKzUPyRAU7zJ2+6ZMZt5eS4n9
         u3isJL/kTza4kV2GQhIFJwtqssdzRf8m8zh7KXKagda8eMPu4br1WCDZ0TkJ88FgQU
         LxOtqzZr5bvLj4yapYhVWSGd17sdgtwRND+0DUi2jMogQ5jU4/VkJJ4NGwiRKGowMW
         RLvOt+Iw3d/NA==
Received: by mail-ot1-f43.google.com with SMTP id s11-20020a056830124bb029021bb3524ebeso14793319otp.0;
        Tue, 30 Mar 2021 00:30:59 -0700 (PDT)
X-Gm-Message-State: AOAM532XDgmRf/u1m4JVxQH+NUW5P8dHGI5l+TgGpFdu4cYCuZhTnfEp
        UV7ME+j1TwgfCYLUf2AE5rHO1drox+FiWfKbxLQ=
X-Google-Smtp-Source: ABdhPJzB47EpuCrG2DPxUtcQLUjtwGSd7CDmaA1KZ8sXWWUdsAzjcJih0N/gxHCPpyQDUvPO55djW23VdIEwumFBnsk=
X-Received: by 2002:a9d:316:: with SMTP id 22mr26071919otv.210.1617089458397;
 Tue, 30 Mar 2021 00:30:58 -0700 (PDT)
MIME-Version: 1.0
References: <yq1wntpgxxr.fsf@ca-mkp.ca.oracle.com> <20210330071958.3788214-1-slyfox@gentoo.org>
In-Reply-To: <20210330071958.3788214-1-slyfox@gentoo.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 30 Mar 2021 09:30:44 +0200
X-Gmail-Original-Message-ID: <CAK8P3a32frskYgoXi2ncOcLfhqcMDssSBp79p7WSRg3VPhmSdA@mail.gmail.com>
Message-ID: <CAK8P3a32frskYgoXi2ncOcLfhqcMDssSBp79p7WSRg3VPhmSdA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] hpsa: use __packed on individual structs, not header-wide
To:     Sergei Trofimovich <slyfox@gentoo.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Don Brace <don.brace@microchip.com>,
        linux-ia64@vger.kernel.org, storagedev@microchip.com,
        linux-scsi <linux-scsi@vger.kernel.org>, jszczype@redhat.com,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>, thenzl@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 30, 2021 at 9:22 AM Sergei Trofimovich <slyfox@gentoo.org> wrote:
>
> Some of the structs contain `atomic_t` values and are not intended to be
> sent to IO controller as is.
>
> The change adds __packed to every struct and union in the file.
> Follow-up commits will fix `atomic_t` problems.
>
> The commit is a no-op at least on ia64:
>     $ diff -u <(objdump -d -r old.o) <(objdump -d -r new.o)

This looks better to me, but I think it still has the same potential bug in
the CommandList definition. Moving from #pragma to annotating the
misaligned structures as __packed is more of a cleanup that could
be done separately from the bugfix, but it does make it a little more
robust.

>  #define HPSA_INQUIRY 0x12
>  struct InquiryData {
>         u8 data_byte[36];
> -};
> +} __packed;

Marking this one and a few others as __packed is a bit silly, but
also obviously harmless, and closer to the original version, so that's
ok.

> @@ -451,7 +452,7 @@ struct CommandList {
>         bool retry_pending;
>         struct hpsa_scsi_dev_t *device;
>         atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */
> -} __aligned(COMMANDLIST_ALIGNMENT);
> +} __packed __aligned(COMMANDLIST_ALIGNMENT);

You are still marking CommandList as __packed here, which is
what caused the original problem. Please don't mark this one
as __packed at all. If there are individual members that you want
to be misaligned inside of the structure, you could mark those
explicitly.

      Arnd
