Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28868C43603
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 20:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9A5F2073C
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 20:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfLDUfn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 15:35:43 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:43519 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbfLDUfm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2019 15:35:42 -0500
Received: from mail-qk1-f182.google.com ([209.85.222.182]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N2EHo-1hch5n0cYQ-013dj9; Wed, 04 Dec 2019 21:35:41 +0100
Received: by mail-qk1-f182.google.com with SMTP id i18so1231914qkl.11;
        Wed, 04 Dec 2019 12:35:40 -0800 (PST)
X-Gm-Message-State: APjAAAUz8RBNWgAbBR4bROYRtkWdNsF82wAkpISUc/+PBLGm7r+mdkbf
        7IlbKsVuR23aq1hK7ngHj22rSQ6Hd8Ac2HD6ZK4=
X-Google-Smtp-Source: APXvYqw6M/g0CPWesRHrPGU+zE/15A9t17Oj+Hu81iV2LHH+Duq5/OwGbIcxSl2FqLLZDExbVJXGh7MGT09Hi3oK7kk=
X-Received: by 2002:a37:b283:: with SMTP id b125mr5144606qkf.352.1575491739885;
 Wed, 04 Dec 2019 12:35:39 -0800 (PST)
MIME-Version: 1.0
References: <CAK8P3a33oETbN-60VjpNNeuW1U1Wzb4juVzdiw1ESdses6m3bw@mail.gmail.com>
 <20191204140812.2761761-1-arnd@arndb.de> <CAHk-=wjBbi2xJZw+7Wqtt3W_mOUSPU2N4w-OES9WUUyXt-DnCg@mail.gmail.com>
In-Reply-To: <CAHk-=wjBbi2xJZw+7Wqtt3W_mOUSPU2N4w-OES9WUUyXt-DnCg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 4 Dec 2019 21:35:23 +0100
X-Gmail-Original-Message-ID: <CAK8P3a35t7Of657kmhxF3m8MpJR8ZgiG01kNsXpXyuHmBtSorg@mail.gmail.com>
Message-ID: <CAK8P3a35t7Of657kmhxF3m8MpJR8ZgiG01kNsXpXyuHmBtSorg@mail.gmail.com>
Subject: Re: [PATCH] scsi: sg: fix v3 compat read/write interface
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Doug Gilbert <dgilbert@interlog.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:nU/jsU50QmsmrwE+cDu59svXaj4VdS+ib9ULTOsTDTJIoUCNJ7r
 NNT6hsQmz2tTkJC0/BmEfUOkd7XBoRya9ClFLfxXoAc6CjoIIXBns5DsOPs3TobX5eesU5H
 o86eZgDoW+48ebO0C77JgUiirv9lBOCaU5pRmPfhdLBBwaB/ase35ZOeze4/eF9qheDFOOm
 3QUDcm2U/Xm5lPCj5JZxA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ay91KUtXt0c=:Crv8EZJuMvM5iO9hJGJflI
 p1Pbd5+jjoE8FU/eCNlMdAw5HLsX5X0kxvBt9VU+Nqj1U35h3/c6W2AJaeI+906zfl4q9ziM2
 UocOoiJRLSg1Cv811rX/7uA3kkFIyazNqHDg2BkTJsvialzoDYrYj+LOPfIJiIARqrF58gxS5
 XCXvhBy+w6xTFv1fCKyBJa4VeqzkCt17A2az4G99Uo5Y5Vi/J6Fzxy1u7Rter+HXG+52tpKt4
 d0fYHzHmIRgjrNLxhOAToVKSfds1GnkGiudT3WOj561UWHHHU3mGrQkTBCPQ8vTo3pEQanZBp
 uhi6lq67Lei4IqKIUnzJAYvgbhnQOTfU8rWpHKlf5GVhYmWD0uWpIBENBRu1CvEn4hPfG+uD3
 TnhCrxCmJ8U6q4PnIBLRtRMQpl42DXRIRdj3oqaF2VMonWBw42ZV+E9G46Bt8bUZHLHaSy/v+
 YUyWT8096zmehlEu8tQjAv4wDExGbhwCMCM+1zHKYJbklZvb5NluybmwBUSHHZmIVoufdhVh3
 RpVFU6b71Ve1Hn19LVpKG/A2d34ijqjX4LG7mF2DMzmIBjkfNpzX+daWxMUSvVgwzz6kD+/d6
 PtTdkYRhGbV7C9rO+s1mX/qsBYIwjclGtiknGmgHyWgEUtGRGJ7m4Qa1sqdAsssDCEzM6GORD
 VhbzZtdwL72BesfmwMAaMRLLIN4ievprFkCuL3q0QpUx12MjcFAJGzEHyUiI/WLv+TNo6h4GZ
 e+tQdpU+bNRvEHatqxJdlDsIMR6yO4OxvU0Tr4ENXH1wLOFIEZUNA0irdrHZ9tu4bSyXL3fJx
 NuuWDnEseff5QKfBoGpFW9klJgW5JPQQYQXKEZixEBpBhrJAePN1nItgknNb4HcH5rrWHCvNx
 3xgO4RqVQGc1Ih3rkGng==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 4, 2019 at 7:33 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Dec 4, 2019 at 6:08 AM Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > To address both of these, move the definition of compat_sg_io_hdr
> > into a scsi/sg.h to make it visible to sg.c and rewrite the logic
> > for reading req_pack_id as well as the size check to a simpler
> > version that gets the expected results.
>
> I think the patch is a good thing, except for this part:
>
> > @@ -575,6 +561,14 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
> >         int err = 0, err2;
> >         int len;
> >
> > +#ifdef CONFIG_COMPAT
> > +       if (in_compat_syscall()) {
> > +               if (count < sizeof(struct compat_sg_io_hdr)) {
> > +                       err = -EINVAL;
> > +                       goto err_out;
> > +               }
> > +       } else
> > +#endif
> >         if (count < SZ_SG_IO_HDR) {
> >                 err = -EINVAL;
> >                 goto err_out;
>
> Yes, yes, I know we do things like that in some other places too, but
> I really detest this kind of ifdeffery.
>
> That
>
>          } else
>   #endif
>          if (count < SZ_SG_IO_HDR) {
>
> is just evil. Please don't add things like this where the #ifdef
> section has subtle semantic continuations outside of it. If somebody
> adds a statement in between there, it now acts completely wrong.
>
> I think you can remove the #ifdef entirely. If CONFIG_COMPAT isn't
> set, I think in_compat_syscall() just turns to 0, and the code gets
> optimized away.
>
> Hmm?

It almost works, but the part of the y2038 work that made all the
compat infrastructure visible on all architectures with or without
CONFIG_COMPAT never made it in after we decided to separate
the _time32 namespace from the compat_ namespace entirely.

It actually works on architectures that don't override asm/compat.h,
and on those that have CONFIG_COMPAT enabled, but for example
on arm64 with CONFIG_COMPAT=n I run into a build error because
asm-generic/compat.h is not included here, and getting that to
work reliably needed some rearranging of other files.

I could

a) dig out my old patches that did this right, so we can kill off
most of these #ifdefs in compat code throughout the kernel
(probably not this merge window),

b) change compat_sg_io_hdr to use plain types (u32, s32, ...), or

c) conditionally define another macro for SZ_COMPAT_SG_IO_HDR
like (pasted into gmail, won't apply)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index af152a7e71c7..039858014e18 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -198,6 +198,11 @@ static void sg_device_destroy(struct kref *kref);

 #define SZ_SG_HEADER sizeof(struct sg_header)
 #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
+#ifdef CONFIG_COMPAT
+#define SZ_COMPAT_SG_IO_HDR SZ_SG_IO_HDR
+#else
+#define SZ_COMPAT_SG_IO_HDR sizeof(struct compat_sg_io_hdr)
+#endif
 #define SZ_SG_IOVEC sizeof(sg_iovec_t)
 #define SZ_SG_REQ_INFO sizeof(sg_req_info_t)

@@ -561,15 +566,12 @@ sg_new_read(Sg_fd * sfp, char __user *buf,
size_t count, Sg_request * srp)
        int err = 0, err2;
        int len;

-#ifdef CONFIG_COMPAT
        if (in_compat_syscall()) {
-               if (count < sizeof(struct compat_sg_io_hdr)) {
+               if (count < SZ_COMPAT_SG_IO_HDR) {
                        err = -EINVAL;
                        goto err_out;
                }
-       } else
-#endif
-       if (count < SZ_SG_IO_HDR) {
+       } else if (count < SZ_SG_IO_HDR) {
                err = -EINVAL;
                goto err_out;
        }

        Arnd
