Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0784C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 18:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 858196507D
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 18:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240006AbhCPS3M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 14:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236941AbhCPS2k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Mar 2021 14:28:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93A7965144;
        Tue, 16 Mar 2021 18:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615919319;
        bh=o5TDeYcIZfv3w4lnvrTEouEqZDlTghi/yYioRz16sfs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YDMonfeho2P2kYrP1Eouqage1A0JdVUoHkwxBzlILGtvAfJnUe2bImP8a6dwiV3+r
         qPUBCgpD1rPL1gHhwqpXdBrKWh0yH9WJvAMWpGwv06HgZQQSaZ6F3x36BNWvV3doZJ
         0KL3Sl5/s0PuvZro2WswQXfgXjRBJtG0JsJaGD7ySV/cCJ41/TSqI3hwAYg/5SqTWN
         nga/E/y0OHnVKuP9nFJ6+0XGlBIau8fw4fi4qOO17BgEGqYaHK/PNSDG2ZJUc8pt+f
         hn+vhm5e8suCzAkC5uAEbqKsF2oyiOKyp9izJAzLDY6agFrCxwGZv4mY0XsiGfnetr
         b+9t50q48YT5A==
Received: by mail-ot1-f49.google.com with SMTP id t23-20020a0568301e37b02901b65ab30024so7373297otr.4;
        Tue, 16 Mar 2021 11:28:39 -0700 (PDT)
X-Gm-Message-State: AOAM533GuKr8BHO38lZ2todszRmeC/E/OpdI6v4sjDOFYRppBB8IyE+W
        QAPdNDYKRPQPchzvu/rT1jk3UsECA9tTm2ClirE=
X-Google-Smtp-Source: ABdhPJynsQBaQFgKvT0WbhJ3BjrEydngPdSBWCACEfjcFzWuldKaclgxe6MaGLPLuzRp2PL/b2TMxUBPvs0LYZwI1T0=
X-Received: by 2002:a9d:6341:: with SMTP id y1mr116073otk.210.1615919318766;
 Tue, 16 Mar 2021 11:28:38 -0700 (PDT)
MIME-Version: 1.0
References: <5532f9ab-7555-d51b-f4d5-f9b72a61f248@redhat.com>
 <20210312222718.4117508-1-slyfox@gentoo.org> <SN6PR11MB2848561E3D85A8F55EB86977E16B9@SN6PR11MB2848.namprd11.prod.outlook.com>
In-Reply-To: <SN6PR11MB2848561E3D85A8F55EB86977E16B9@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 16 Mar 2021 19:28:22 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3JYmhbN3TXB2cWGfXGKgsUa9Hg=ZvWckTaL_31OMgbtQ@mail.gmail.com>
Message-ID: <CAK8P3a3JYmhbN3TXB2cWGfXGKgsUa9Hg=ZvWckTaL_31OMgbtQ@mail.gmail.com>
Subject: Re: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
To:     Don.Brace@microchip.com
Cc:     Sergei Trofimovich <slyfox@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-ia64@vger.kernel.org, storagedev@microchip.com,
        linux-scsi <linux-scsi@vger.kernel.org>, jszczype@redhat.com,
        Scott.Benesh@microchip.com, Scott.Teel@microchip.com,
        thenzl@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 16, 2021 at 6:12 PM <Don.Brace@microchip.com> wrote:

>  drivers/scsi/hpsa_cmd.h | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h index d126bb877250..617bdae9a7de 100644
> --- a/drivers/scsi/hpsa_cmd.h
> +++ b/drivers/scsi/hpsa_cmd.h
> @@ -20,6 +20,9 @@
>  #ifndef HPSA_CMD_H
>  #define HPSA_CMD_H
>
> +#include <linux/build_bug.h> /* static_assert */ #include
> +<linux/stddef.h> /* offsetof */
> +
>  /* general boundary defintions */
>  #define SENSEINFOBYTES          32 /* may vary between hbas */
>  #define SG_ENTRIES_IN_CMD      32 /* Max SG entries excluding chain blocks */
> @@ -448,11 +451,20 @@ struct CommandList {
>          */
>         struct hpsa_scsi_dev_t *phys_disk;
>
> -       bool retry_pending;
> +       int retry_pending;
>         struct hpsa_scsi_dev_t *device;
>         atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */  } __aligned(COMMANDLIST_ALIGNMENT);
>
> +/*
> + * Make sure our embedded atomic variable is aligned. Otherwise we
> +break atomic
> + * operations on architectures that don't support unaligned atomics like IA64.
> + *
> + * Ideally this header should be cleaned up to only mark individual
> +structs as
> + * packed.
> + */
> +static_assert(offsetof(struct CommandList, refcount) %
> +__alignof__(atomic_t) == 0);
> +

Actually that still feels wrong: the annotation of the struct is to pack
every member, which causes the access to be done in byte units
on architectures that do not have hardware unaligned load/store
instructions, at least for things like atomic_read() that does not
go through a cmpxchg() or ll/sc cycle.

This change may fix itanium, but it's still not correct. Other
architectures would have already been broken before the recent
change, but that's not a reason against fixing them now.

I'd recommend marking the entire structure as having default
alignment, by adding the appropriate pragmas before and after it.

         Arnd
