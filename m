Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7E2C433E1
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 14:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5EB8207FC
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 14:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgHCODF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 10:03:05 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:49529 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbgHCODF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 10:03:05 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MMFdY-1kLv9c1CsA-00JG6n; Mon, 03 Aug 2020 16:03:02 +0200
Received: by mail-qt1-f182.google.com with SMTP id o22so27993378qtt.13;
        Mon, 03 Aug 2020 07:03:02 -0700 (PDT)
X-Gm-Message-State: AOAM531H4Ztsp4lmZHE0hVpE09LjIihZ4anNdOXHKtYz1TkLDiSuprzP
        Ahwx6nVPpRdzpnzSaHzBySk7+DaSeMqeLeCkz9I=
X-Google-Smtp-Source: ABdhPJw2zR5rbY5JLrLg+SOnCxoaIDNRbKJLo+/dAo2RT/k0sLgir+vyUo3XbpuGMFZC+KhJcR2YgXGxdxfhSfDd7eY=
X-Received: by 2002:aed:2946:: with SMTP id s64mr16834134qtd.204.1596463380844;
 Mon, 03 Aug 2020 07:03:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200730220750.18158-1-samuel@sholland.org> <CAK8P3a2p7dWhhCqAYF_Zos-X-zBK+id-xO5hPu2fRTbNyPo9Xg@mail.gmail.com>
 <29ea8d0f-bcab-9ffd-0e2f-f022911f4bf2@sholland.org>
In-Reply-To: <29ea8d0f-bcab-9ffd-0e2f-f022911f4bf2@sholland.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 3 Aug 2020 16:02:44 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0xSyyaLHziuv4JKimUggF96frwLPKmjQ4G9VBWRW2EMg@mail.gmail.com>
Message-ID: <CAK8P3a0xSyyaLHziuv4JKimUggF96frwLPKmjQ4G9VBWRW2EMg@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: 3w-9xxx: Fix endianness issues found by sparse
To:     Samuel Holland <samuel@sholland.org>
Cc:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:e64ezUisEuE9nycpbx8ic+jqdEuyHo7xZIKF0JrUSXVeVXoMr45
 NxBTI57MF/dEAoJzYSTYmaYXGRGjlXqbukQZmMLBWl/GwgoUqih9hkWgnI2cK2jCsBb226b
 vX6Euowe8U9ORfwoHT3sQglECKF9zPsJlbju7ApGrltWdaJ9ND8iNY//NyEOBL82SzYkqbm
 R5MM8KuJMcKWB+Cqr3lyw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:4RmXT1mnDr4=:ch8gWzoUYWnwqpm8+VTY7E
 7+zkybGCsDxcgLCQTB1DEl29/K77JSKezwUBB2iXnZx0W0kV2djkaIqnhu1YYj2kRbkEyw/3i
 ZrRakLKIVlxWIDND2CXciBMdoHN+R9xzgjyL+dmEG5gXEAaT96IprTMa0rU1HHi8SFxso2lpI
 v2vJCmHfbmX22RAQW7aqE757bshw+JS/y+qf99J6FaYI6KXh/lkP0WcmRjSKEWeDk31Eq7XBV
 VjJh5qUiPFGpzBJ3qAd+EQIjG4m4sbLVSq3HetAKTUrxn3sCspTsb/R42wF6JWUbcR8M5BjqZ
 oomSkisD+OsIkrtH843OT30Qde280uRH3bEoTPzgb7h218/KKEJQRX0mzKSDKH/FsA8BoW1a8
 xQnCGPEgaKcRSuW501XBukP7w4j0PxBIVSwkYouRvbsB3UC0R5evOFzdjj0IZtw+Ws5e1ppD7
 hURU7doOFii2GeLXTMtpv0Rx5wMETqo98O/8j4Y9o/SRiYgl45T/51ACobVilcyka7b5HszGa
 C2p46YumFEPPcPb+bVzFhHnm8H6NawNecpWeBANOOYMxmqxz5wyHqS6M8PnNDlQIJfp51/wha
 J2HTjHfyfmcSZFQyUK9Jcy4ZwHwHZPrzsLQA+LSx4lOa5BIlZtzOiycVwcV1PfkNwNVnOWQbP
 3Yxs1QJHVxfJZB+WTxDwCwm61+cI4mHvmmAYuQrBLh1xS4+DroPGgbGxjqJAPN0qIYBPurP2D
 Y2LfL0heWgGd+inq7izXYY8rOXF0k99sLqywHsbxYPqtFL3gqBkznbIMlyjSMHhJRXGUO//iE
 NViQHsdkJyDbG7WNVIRRLdvP4UfP7DggJ0lPLBpNyVXPklC9mOhyt/rzFh8ntp2K5QcZHxPUr
 S0jpJT6d4MXWahOf1W1G7lCrh30xX6DLHsCpomOVljS2mHRx0MXBq445hR06G7Fa+AjGeajht
 GW0//Dwf2lu+cCNp8by/UULkG9gm1pFojKAT4B80p/J6vgDDelIf5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 3, 2020 at 5:42 AM Samuel Holland <samuel@sholland.org> wrote:
>
> On 7/31/20 2:29 AM, Arnd Bergmann wrote:
> > On Fri, Jul 31, 2020 at 12:07 AM Samuel Holland <samuel@sholland.org> wrote:
> >>
> >> The main issue observed was at the call to scsi_set_resid, where the
> >> byteswapped parameter would eventually trigger the alignment check at
> >> drivers/scsi/sd.c:2009. At that point, the kernel would continuously
> >> complain about an "Unaligned partial completion", and no further I/O
> >> could occur.
> >>
> >> This gets the controller working on big endian powerpc64.
> >>
> >> Signed-off-by: Samuel Holland <samuel@sholland.org>
> >> ---
> >>
> >> Changes since v1:
> >>  - Include changes to use __le?? types in command structures
> >>  - Use an object literal for the intermediate "schedulertime" value
> >>  - Use local "error" variable to avoid repeated byte swapping
> >>  - Create a local "length" variable to avoid very long lines
> >>  - Move byte swapping to TW_REQ_LUN_IN/TW_LUN_OUT to avoid long lines
> >>
> >
> > Looks much better, thanks for the update. I see one more issue here
> >>  /* Command Packet */
> >>  typedef struct TW_Command {
> >> -       unsigned char opcode__sgloffset;
> >> -       unsigned char size;
> >> -       unsigned char request_id;
> >> -       unsigned char unit__hostid;
> >> +       u8      opcode__sgloffset;
> >> +       u8      size;
> >> +       u8      request_id;
> >> +       u8      unit__hostid;
> >>         /* Second DWORD */
> >> -       unsigned char status;
> >> -       unsigned char flags;
> >> +       u8      status;
> >> +       u8      flags;
> >>         union {
> >> -               unsigned short block_count;
> >> -               unsigned short parameter_count;
> >> +               __le16  block_count;
> >> +               __le16  parameter_count;
> >>         } byte6_offset;
> >>         union {
> >>                 struct {
> >> -                       u32 lba;
> >> -                       TW_SG_Entry sgl[TW_ESCALADE_MAX_SGL_LENGTH];
> >> -                       dma_addr_t padding;
> >> +                       __le32          lba;
> >> +                       TW_SG_Entry     sgl[TW_ESCALADE_MAX_SGL_LENGTH];
> >> +                       dma_addr_t      padding;
> >
> >
> > The use of dma_addr_t here seems odd, since this is neither endian-safe nor
> > fixed-length. I see you replaced the dma_addr_t in TW_SG_Entry with
> > a variable-length fixed-endian word. I guess there is a chance that this is
> > correct, but it is really confusing. On top of that, it seems that there is
> > implied padding in the structure when built with a 64-bit dma_addr_t
> > on most architectures but not on x86-32 (which uses 32-bit alignment for
> > 64-bit integers). I don't know what the hardware definition is for TW_Command,
> > but ideally this would be expressed using only fixed-endian fixed-length
> > members and explicit padding.
>
> All of the command structures are packed, due to the "#pragma pack(1)" earlier
> in the file. So alignment is not an issue. This dma_addr_t member _is_ the
> explicit padding to make sizeof(TW_Command) -
> sizeof(TW_Command.byte8_offset.{io,param}.sgl) equal TW_COMMAND_SIZE * 4. And
> indeed the structure is expected to be a different size depending on
> sizeof(dma_addr_t).

Ah, so only the first few members are accessed by hardware and the
last union is only accessed by the OS then? In that case I suppose it is
all fine, but I would also suggest removing the "#pragma packed"
to get somewhat more efficient access on systems that have  problems
with misaligned accesses.

      Arnd
