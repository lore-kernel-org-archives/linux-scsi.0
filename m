Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76703C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 07:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5268621744
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 07:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgHEHRx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 03:17:53 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:35755 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbgHEHRu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 03:17:50 -0400
Received: from mail-qk1-f174.google.com ([209.85.222.174]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1M7sYM-1k73Qk3Kmw-00540k; Wed, 05 Aug 2020 09:17:49 +0200
Received: by mail-qk1-f174.google.com with SMTP id j187so40765678qke.11;
        Wed, 05 Aug 2020 00:17:48 -0700 (PDT)
X-Gm-Message-State: AOAM530WfHW5CLKTo4yzxsctC6QH7r7wv8QCakmW3YlJo1SswawijSZk
        gL9qO9i8tQBaUEUtV0Q2+/7pX9BJSz5f8WdIZJQ=
X-Google-Smtp-Source: ABdhPJwc875ta9ExZX1/DvTUle7thiMXYwYloLV2Wm+kT3X53apLGCRcK45f+YRn0Oge+DYC3vh8PRvw9l2wpIgcNzM=
X-Received: by 2002:a37:6351:: with SMTP id x78mr1971924qkb.394.1596611867220;
 Wed, 05 Aug 2020 00:17:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200730220750.18158-1-samuel@sholland.org> <CAK8P3a2p7dWhhCqAYF_Zos-X-zBK+id-xO5hPu2fRTbNyPo9Xg@mail.gmail.com>
 <29ea8d0f-bcab-9ffd-0e2f-f022911f4bf2@sholland.org> <CAK8P3a0xSyyaLHziuv4JKimUggF96frwLPKmjQ4G9VBWRW2EMg@mail.gmail.com>
 <0bd43d61-4d9a-40cb-27c6-18aaf7f58b48@sholland.org>
In-Reply-To: <0bd43d61-4d9a-40cb-27c6-18aaf7f58b48@sholland.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 5 Aug 2020 09:17:31 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3bPb+-i2YbHmn84MEuCe4xG_BKP15vNO1B1kTkYZ+=pg@mail.gmail.com>
Message-ID: <CAK8P3a3bPb+-i2YbHmn84MEuCe4xG_BKP15vNO1B1kTkYZ+=pg@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: 3w-9xxx: Fix endianness issues found by sparse
To:     Samuel Holland <samuel@sholland.org>
Cc:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:sEjRjQxm9xe+XM3h7HubnfCYIZJq2EXLky7dI8JeDP3M7YTvX9J
 C/ih5HqEv1L0Uo5TfklkVi3joITnvMp333UU8vtykpYsRQy23jOh+Os86cMVO+hk3hr4gBW
 XQQxLZmmjfpa3w4RnBpX9Ik9UBLm+Qn04ZtjTjjcZX6/TW7/Lu1k1ZZ4FF/g3l/GM/a1QTB
 +Csbf1YFThT5RvGt9PPaQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:fQj30KgxVak=:ZGrI8ZUqpNLw6CyceElaEI
 pYwgZQlt5P8rnBDmJ1IoTVgNG7I0qA2zYy7tB4pxKs+0Weqh2/0W14iPMgxaNKzubgWVqYxap
 Re8DVWb7O/e2no1ql8mzPyNghsvP2eckx9epOgKR72cr62LJfxm/4EJSrsrMcq1MXcXNEyp/Z
 iyS64Irfcnt/ecFmbTyBXRrn3FOASnBc99me18kx2XMme67oD4EjpPnOwEZCR06xB7WmpnBDQ
 1A1yTUWzvF7sBIVZvp6Myz5jZo4YGE7RorYfPdi8R3Gkn1d+r4WOO/QpLxWAWi6EVRQryLQhx
 vyt85V1Ffx6VndRoCMiBXpGVWV4dm2RudZyvKSLT4UU61aNZ55f0WKKLOYTxdUGzL8JGotgJt
 VueqDVM3+fBKVUt5OcCpgu5qIEz3P+y8/VklDh2y0xroq6is3q1KuIB4JfefYzFcSztKeKb6J
 F1LN8YZoxVTZsVmIVMwT4ErWcXsvAzJKTE2P/YEbCGBwUEtBcmS/YcvTphfu4kODVgU1V5ypH
 hmxEGhcbq5eGc0zFu0LoYXm9k9ogDej5ubqrQQVB2qZ8JUGCpZDXMyW45Mx9InU77eXE0q2mA
 pgPsgNdc5HFXvXZtOUogfUH6hz11mrsxI5/pztJG5w4/P7hy9/1kI3lqrHdNsUc5HtwV3sgyE
 Tc86gPpiCrjTPO+F4fVyK6394cM/OrdTTEtLlpgpNvI/5zRKX669aK9UJS95g0r+H2pYyUZH6
 sfk6bBuwLxfvogoHytUNYOD6D2kgfW+PlTD23dO0ZzLaOifcAR43jl18bTJ5INbp+/FcOIDMm
 t9dC/XTvPhESq1JgiAxggkFgQph9YyByVWQ2AoMueLbAF5OYipXoTXZZ6Ta7apqFsa8WNqR
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 5, 2020 at 3:44 AM Samuel Holland <samuel@sholland.org> wrote:
> On 8/3/20 9:02 AM, Arnd Bergmann wrote:
> > On Mon, Aug 3, 2020 at 5:42 AM Samuel Holland <samuel@sholland.org> wrote:
> >> All of the command structures are packed, due to the "#pragma pack(1)" earlier
> >> in the file. So alignment is not an issue. This dma_addr_t member _is_ the
> >> explicit padding to make sizeof(TW_Command) -
> >> sizeof(TW_Command.byte8_offset.{io,param}.sgl) equal TW_COMMAND_SIZE * 4. And
> >> indeed the structure is expected to be a different size depending on
> >> sizeof(dma_addr_t).
> >
> > Ah, so only the first few members are accessed by hardware and the
> > last union is only accessed by the OS then? In that case I suppose it is
> > all fine, but I would also suggest removing the "#pragma packed"
> > to get somewhat more efficient access on systems that have  problems
> > with misaligned accesses.
>
> I don't know what part the hardware accesses; everything I know about the
> hardware comes from reading the driver.

I see now from your explanation below that this is a hardware-defined
structure. I was confused by how it can be either 32 or 64 bits wide but
found the

tw_initconnect->features |= sizeof(dma_addr_t) > 4 ? 1 : 0;

line now that tells the hardware about which format is used.

> The problem with removing the "#pragma pack(1)" is that the structure is
> inherently misaligned: byte8_offset.io.sgl starts at offset 12, but it may begin
> with a __le64.

I think a fairly clean way to handle this would be to remove the pragma
and instead define a local type like

#if IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT)
typedef  __le64 twa_address_t __packed;
#else
typedef __le32 twa_addr_t;
#endif

The problem with marking the entire structure as packed, rather than
just individual members is that you end up with very inefficient bytewise
access on some architectures (especially those without cache-coherent
DMA or hardware unaligned access in the CPU), so I would recommend
avoiding that in portable driver code.

      Arnd
