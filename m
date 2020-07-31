Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701F9C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 07:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 571352074B
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 07:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731629AbgGaHaP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 03:30:15 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:54457 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731419AbgGaHaP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 03:30:15 -0400
Received: from mail-qk1-f178.google.com ([209.85.222.178]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N6sON-1kq7sg1l9T-018LK4; Fri, 31 Jul 2020 09:30:13 +0200
Received: by mail-qk1-f178.google.com with SMTP id l64so21176050qkb.8;
        Fri, 31 Jul 2020 00:30:13 -0700 (PDT)
X-Gm-Message-State: AOAM533PrN993TFqvhtwk5J+I28IYacPXSwaiL83CQBSBliam5+84n27
        ee5sgKqPhiIhCftz35ljzQrv+dEDV0iIWJA8u1U=
X-Google-Smtp-Source: ABdhPJzoW96uYym0s5KepIaMCCY1U73XkYCDF3vhHq9A4TOTTXYoaFKvabbNt051rlUR2tmmstdsexhMSvy1+ac0WDk=
X-Received: by 2002:a05:620a:2444:: with SMTP id h4mr2879846qkn.352.1596180612166;
 Fri, 31 Jul 2020 00:30:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200730220750.18158-1-samuel@sholland.org>
In-Reply-To: <20200730220750.18158-1-samuel@sholland.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 31 Jul 2020 09:29:56 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2p7dWhhCqAYF_Zos-X-zBK+id-xO5hPu2fRTbNyPo9Xg@mail.gmail.com>
Message-ID: <CAK8P3a2p7dWhhCqAYF_Zos-X-zBK+id-xO5hPu2fRTbNyPo9Xg@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: 3w-9xxx: Fix endianness issues found by sparse
To:     Samuel Holland <samuel@sholland.org>
Cc:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:q3SP/zAIqz2Dr3ckUjBhaEfFeDJrrI09igpldt9SLGsSSL3y48P
 4DisfxfWuudRDJ1dRWPCT/VnuY+3dyZAAyLyf0upp/GZuumu3e4t0hnr/1Y+DR3ZofkHisb
 6obK++rCh6GNf1cDxcvDCHgb6enHYMFu/+yLgOYWtvSXpNT4Ykv8uw4t0nFCOUw473+KmkG
 +jMR9nbOYucxdekqdiT7w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:C77VMKFR0Uo=:PTaxzpKSGnGYH5Ea1k8fof
 dc4m2J/cSkjhklFzzCMhm41SllQdHlqRqXTIbjLST75CKahYYh40+bpD4btQ9KZcY5bwfEkh1
 WT084sjIAnAmrexnWbMKLsd+JAj7Iqzeimm9boGhayHdm6GjghlBYpvzFHW7jcKayY/ghurQ2
 ROtuaGMtVceFoBUzTjrZfjjlZrtgo9gzo5G4zCjhvugIBwQHQMPV/4Yj8wvRCXp6Q8InfvRHM
 SS+T4vuScNUhd4iNEKJ4lgd5pJeu8qG/LcaUvXE+hRR2gpai1U+bX8zPf4R7WafyOozoFb/Ls
 Ksxc+l8ef1SzbRKxHxyqh1cXsaSjFSHrpRXtdwaD1teFx5Y2xXCzGlrat4U+bOjLFBwidMRaa
 +HuolWNLQjTtOZsldkcI78hGBzydHetYf6f4E0cGJ/lPmk+k0V64H6zTHpQ3T03kW5taaz+OP
 zgcKQ6eaq3hRmnhwVrD1WuPKNezEmF9lCRsoMXV9Nel+Wf33KTSzAqdExRdnMCSaoTAB+t2Y5
 Jb5D5JdryIhZGfkkwwZYNQT+n72BYHTaKsltcOv2ZJaPq5SilmHWbux9MSWlsHNmglTomWoVH
 nxNLZsdKUM5Yo/M2Wk7NqeOPH47NROTONBbZp24Df5/L0FdeKjZ1cFKnpy647Ib3meC+a2Zhl
 3oRGd5V/5BiqCKyc3MQ7uU2b3+eC0D8PmMA5pJiehZ4oBUGX921pGXTpdVzTDAvWbsS4ZN/AJ
 JoIiHkJu0zE1xhsG629KZCFzpO2SWWrcpoNAngSVIxTqu+ECRbdoR5VYSvFlYqZ7EsStZp+Uw
 2s7fqEUIysOOZB/mblS2lmGMNkBzvBZfKjZFC9AByvlYuXk6Ug54jx4EXY9wzXDL/qm/m4K
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 31, 2020 at 12:07 AM Samuel Holland <samuel@sholland.org> wrote:
>
> The main issue observed was at the call to scsi_set_resid, where the
> byteswapped parameter would eventually trigger the alignment check at
> drivers/scsi/sd.c:2009. At that point, the kernel would continuously
> complain about an "Unaligned partial completion", and no further I/O
> could occur.
>
> This gets the controller working on big endian powerpc64.
>
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
>
> Changes since v1:
>  - Include changes to use __le?? types in command structures
>  - Use an object literal for the intermediate "schedulertime" value
>  - Use local "error" variable to avoid repeated byte swapping
>  - Create a local "length" variable to avoid very long lines
>  - Move byte swapping to TW_REQ_LUN_IN/TW_LUN_OUT to avoid long lines
>

Looks much better, thanks for the update. I see one more issue here
>  /* Command Packet */
>  typedef struct TW_Command {
> -       unsigned char opcode__sgloffset;
> -       unsigned char size;
> -       unsigned char request_id;
> -       unsigned char unit__hostid;
> +       u8      opcode__sgloffset;
> +       u8      size;
> +       u8      request_id;
> +       u8      unit__hostid;
>         /* Second DWORD */
> -       unsigned char status;
> -       unsigned char flags;
> +       u8      status;
> +       u8      flags;
>         union {
> -               unsigned short block_count;
> -               unsigned short parameter_count;
> +               __le16  block_count;
> +               __le16  parameter_count;
>         } byte6_offset;
>         union {
>                 struct {
> -                       u32 lba;
> -                       TW_SG_Entry sgl[TW_ESCALADE_MAX_SGL_LENGTH];
> -                       dma_addr_t padding;
> +                       __le32          lba;
> +                       TW_SG_Entry     sgl[TW_ESCALADE_MAX_SGL_LENGTH];
> +                       dma_addr_t      padding;


The use of dma_addr_t here seems odd, since this is neither endian-safe nor
fixed-length. I see you replaced the dma_addr_t in TW_SG_Entry with
a variable-length fixed-endian word. I guess there is a chance that this is
correct, but it is really confusing. On top of that, it seems that there is
implied padding in the structure when built with a 64-bit dma_addr_t
on most architectures but not on x86-32 (which uses 32-bit alignment for
64-bit integers). I don't know what the hardware definition is for TW_Command,
but ideally this would be expressed using only fixed-endian fixed-length
members and explicit padding.

    Arnd
