Return-Path: <SRS0=PQdO=6X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D29C28CBC
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 08:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 059F62184D
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 08:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgEIIAT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 May 2020 04:00:19 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:40861 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgEIIAT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 May 2020 04:00:19 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N63NQ-1j4n6X0rbk-016LE5 for <linux-scsi@vger.kernel.org>; Sat, 09 May
 2020 10:00:17 +0200
Received: by mail-qk1-f169.google.com with SMTP id i14so3224870qka.10
        for <linux-scsi@vger.kernel.org>; Sat, 09 May 2020 01:00:17 -0700 (PDT)
X-Gm-Message-State: AGi0PuaHauoQKNCXUObO7EtIWwldd4Wo+LndMQZEbZH+3DhDrXb/2DpJ
        AEL9jWrT4SWUgnH+v8swyWQFx4hZAe4xWYd+lns=
X-Google-Smtp-Source: APiQypJKEEbI98gJviUJf7rBC8yC0XnuRvIb9OqWuxWwC055X8TYxLMBPUuULAXW1IDyAIJwMgsZ1wjj+TT6g2JO5rU=
X-Received: by 2002:a37:4e08:: with SMTP id c8mr6448672qkb.286.1589011216094;
 Sat, 09 May 2020 01:00:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200507042835.9135-3-bvanassche@acm.org> <202005080353.y49Uwj18%lkp@intel.com>
 <CAKwvOdnuXX2xpsz6fxV-qfvj1AqN3V7qyOwtwtCG4NWq+HzfAw@mail.gmail.com>
 <86bcf088-a35d-0a0f-0ba4-5883b1f2d6cb@acm.org> <CAK8P3a3PA25WUJp73Yea9xq_ca3uXA9Vz2U=UmHiDhg8FmGiNw@mail.gmail.com>
 <040756ba-81ea-64e4-6a11-85608b871b88@acm.org>
In-Reply-To: <040756ba-81ea-64e4-6a11-85608b871b88@acm.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 9 May 2020 09:59:59 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1+jtP9NRj-UCaDHjGSJiqDA4Y=0YTMfvr7zWS+OKRTUw@mail.gmail.com>
Message-ID: <CAK8P3a1+jtP9NRj-UCaDHjGSJiqDA4Y=0YTMfvr7zWS+OKRTUw@mail.gmail.com>
Subject: Re: [PATCH v5 02/11] qla2xxx: Suppress two recently introduced
 compiler warnings
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        kbuild test robot <lkp@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:gD15y5bCws8YA/9J/oU9ifMiw5axZdn8IG7NAGqJFegNU5sOSwx
 GBM/XW9FXWzx7Dnj6dP9J0Vv187FhBokablHF4X+xXNCMcB70HFJJa16LMSJpY3DrROPupb
 5QpIGUvdTUmFO7yKv26bc7twERU4Wkq4lfJCueZzQvqoGhBfn8CP5EhdbYY7p9LWN7lHlmc
 LsE8JkHHjxIHNrC+7ZXlA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:kWWZaqUvPe4=:cmcuXPwuRmlTNMpxskzegT
 pHHDDllILEkId7FXIPN8oDwlvxuoS0kF86d7e38lkiSoDe8yIuSSEhV5kSGD/egurhokNGv17
 5nvuS5g0GLhp/RAstVpiXmu/3SnboI09MyRKcE3IJRDDfxaKo9gxbndnZ8tWzO4WcgOZbdFL1
 oAzepC2zowShHxhABq/j37OxOh8Bb83LCrVIATb3V8+YNZFy/vCX/7PizE4ANHtXPU9ZeCByi
 wpaES7+0TUWuaLkmYMxFHMkuF/u5/3uSLoY9U80cI46FNc7tKEd5QwNKl2p3TN0U1LjyP+L24
 11L3AfVokfsuo7nfEl7vEL/kIUiW366PBgePkCIymfuonm8MmYViYSiADoKm00YhuiWs+pxAE
 M5snVuSgUIMtppvVfed6DI09JDn1ewsJT891AjpOAxGPOrUsH7c3POaLP+17DhzzTjRhNoczt
 pXdVZmWYZbsRbrZe9JQlqb557zOsffy14PPnjbLkkUCiumGJkQjHOT6hIrXhs8vBE8QnPgjWB
 bIs6vgm8MMR2swOBud1F3Qwas10eGM8b6e7h8Qg90+MoNRJyCYHDCkHk5ojoqIZAkKet+RWWR
 3AOfum7ZKts2gEEef3uSoshUMyYoshs71dkodSSO+BE87KyDfwFVF3DcnMU09w0WzU34dxIFH
 fVaFO+zNetlW7cN/VUUa5BN3pIdGlW5rJzgHy91OLcPWpoJGh2I7Bnd1uNinM4VPVOaDxglwW
 badZFqF2odomofMn/0KfKQ4fd2WcE8JGBCcEgpCvn4HC6CNsgriH+d8LJ/XZIz8Z/I/2pAZWB
 IlLUMv6i/YkGQY83uYEK2u+0eQLjjLeBszGcf4zdbCJPOknzCo=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, May 9, 2020 at 12:29 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> >> Thanks for the feedback. I will have a look at _Pragma() and see what
> >> the best way is to suppress this warning.
> >
> > The __diag_ignore() macro in linux/compiler.h should work for this.
>
> Thanks Arnd, that's good to know. Is using __diag_ignore() mandatory in
> this case? The following construct seems to work fine with both gcc and
> clang:
>
>  #define QLA_MSG_MAX 256
>
> +#pragma GCC diagnostic push
> +#ifndef __clang__
> +#pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
> +#endif
> +
>  DECLARE_EVENT_CLASS(qla_log_event,
>         TP_PROTO(const char *buf,
>                 struct va_format *vaf),
> @@ -27,6 +32,8 @@ DECLARE_EVENT_CLASS(qla_log_event,
>         TP_printk("%s %s", __get_str(buf), __get_str(msg))
>  );
>
> +#pragma GCC diagnostic pop
> +
>  DEFINE_EVENT(qla_log_event, ql_dbg_log,
>         TP_PROTO(const char *buf, struct va_format *vaf),
>         TP_ARGS(buf, vaf)

__diag_push(), __diag_ignore(), and __diag_pop() are just
shortcuts for open-coded #pragma plus #ifdef, they do
exactly the same thing here. I think it would be best to be
consistent and use the macros, but it works either way.

I actually have patches to introduce yet another syntax as part
of a larger rework, but that is still WiP.

       Arnd
