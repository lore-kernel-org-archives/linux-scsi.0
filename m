Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC8CC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 13:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 609D564FDF
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 13:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhCENc2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 08:32:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230214AbhCENcK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 5 Mar 2021 08:32:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9511E64FE1;
        Fri,  5 Mar 2021 13:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614951129;
        bh=55hgLVLRpKPexGnBCm48Hok+NXMns/a7aBDs5Q2HzgI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oSeA+bg03jj5FJKgyQZeHgtF/vk8ozEXBbVuHNyiRoWHtwsdnHahf5LnKPIkZfeFG
         dzRsqqOktklLQKMs+aiqLZUJucPjeS/UP1X8XRlhlSWiesYUOFxgLUSGsEpkGKqKUU
         GyUUQzxlR7/WORegymL22JHsFIuSbaBIamE1MmTSIVSIdVsD5olQYArmZZ7iSz4Yoy
         dMPpbUDF/nKtgBnWzYPu0A3eVUSJ2XmE7GdEa/oXbz4FsiHwjXp/5piqx5N8NTCPPt
         fdOFk5+GS752l1Xy6Xozz29lYY+vuD2mJ+VSgiQ+cmdR6Jzhh5fdUVjHL0vAioNc9k
         PH6NVrqGw5rzw==
Received: by mail-ot1-f49.google.com with SMTP id w3so1764782oti.8;
        Fri, 05 Mar 2021 05:32:09 -0800 (PST)
X-Gm-Message-State: AOAM531nNYRgjn/6dbh0uweBfPSsHWXVLTKTVw2fS4sBTyP7CMCZFkMB
        H7T+lzq5Z1PtzNk4hmYWPsRZcbzaIkU96woFmDQ=
X-Google-Smtp-Source: ABdhPJzuKOSq+MerxuJ8G6FDLwNzmS/nCm5HmW4JhwLACo+PPdrNvyg3oHdzwvcrJAR6srL3obIemOIjF9OfI8STYzQ=
X-Received: by 2002:a9d:6b8b:: with SMTP id b11mr8029668otq.210.1614951128966;
 Fri, 05 Mar 2021 05:32:08 -0800 (PST)
MIME-Version: 1.0
References: <20210222230519.73f3e239@sf> <cc658b61-530e-90bf-3858-36cc60468a24@kernel.dk>
 <8decdd2e-a380-9951-3ebb-2bc3e48aa1c3@physik.fu-berlin.de>
 <20210223083507.43b5a6dd@sf> <51cbf584-07ef-1e62-7a3b-81494a04faa6@physik.fu-berlin.de>
 <9441757f-d4bc-a5b5-5fb0-967c9aaca693@physik.fu-berlin.de>
 <20210223192743.0198d4a9@sf> <20210302222630.5056f243@sf> <25dfced0-88b2-b5b3-f1b6-8b8a9931bf90@physik.fu-berlin.de>
 <20210303002236.2f4ec01f@sf> <20210303085533.505b1590@sf> <SN6PR11MB284885A5751845EEA290BFCFE1989@SN6PR11MB2848.namprd11.prod.outlook.com>
 <CAMuHMdVLFfSoC-UYW+3sijeZhLf9xt3rqS=7LTYhzX_1RDxpYA@mail.gmail.com>
In-Reply-To: <CAMuHMdVLFfSoC-UYW+3sijeZhLf9xt3rqS=7LTYhzX_1RDxpYA@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 5 Mar 2021 14:31:52 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0EhxvQ3pP6iMwHdR3RwF3CcAaWvfodPnzPip2iW2wBgQ@mail.gmail.com>
Message-ID: <CAK8P3a0EhxvQ3pP6iMwHdR3RwF3CcAaWvfodPnzPip2iW2wBgQ@mail.gmail.com>
Subject: Re: [bisected] 5.12-rc1 hpsa regression: "scsi: hpsa: Correct dev
 cmds outstanding for retried cmds" breaks hpsa P600
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Don.Brace@microchip.com, slyich@gmail.com,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        storagedev@microchip.com, scsi <linux-scsi@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jszczype@redhat.com, Scott.Benesh@microchip.com,
        Scott.Teel@microchip.com, thenzl@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 5, 2021 at 10:24 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Fri, Mar 5, 2021 at 12:26 AM <Don.Brace@microchip.com> wrote:
> > > > On 3/2/21 11:26 PM, Sergei Trofimovich wrote:
> > struct CommandList {
> >         struct CommandListHeader Header;                 /*     0    20 */
> >         struct RequestBlock Request;                     /*    20    20 */
> >         struct ErrDescriptor ErrDesc;                    /*    40    12 */
> >         struct SGDescriptor SG[32];                      /*    52   512 */
> >         /* --- cacheline 8 boundary (512 bytes) was 52 bytes ago --- */
> >         u32                        busaddr;              /*   564     4 */
> >         struct ErrorInfo *         err_info;             /*   568     8 */
> >         /* --- cacheline 9 boundary (576 bytes) --- */
> >         struct ctlr_info *         h;                    /*   576     8 */
> >         int                        cmd_type;             /*   584     4 */
> >         long int                   cmdindex;             /*   588     8 */
> >         struct completion *        waiting;              /*   596     8 */
> >         struct scsi_cmnd *         scsi_cmd;             /*   604     8 */
> >         struct work_struct work;                         /*   612    32 */
> >         /* --- cacheline 10 boundary (640 bytes) was 4 bytes ago --- */
> >         struct hpsa_scsi_dev_t *   phys_disk;            /*   644     8 */
> >         struct hpsa_scsi_dev_t *   device;               /*   652     8 */
> >         bool                       retry_pending;        /*   660     1 */
> >         atomic_t                   refcount;             /*   661     4 */
>
> How come this atomic_t is no longer aligned to its natural alignment?

There is a

#pragma pack(1)

in linux 203 of this file!

It looks like some of the members in struct raid_map_data
and struct CommandListHeader need to be annotated as packed,
but the file accidentally packs everything until the '#pragma pack()'
in line 875, including the kernel-side CommandList data structure
that clearly must not be packed.

        Arnd
