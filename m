Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554EDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 14:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D79C610CC
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 14:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhKBOEz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 10:04:55 -0400
Received: from mail-ua1-f54.google.com ([209.85.222.54]:33362 "EHLO
        mail-ua1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbhKBOEx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 10:04:53 -0400
Received: by mail-ua1-f54.google.com with SMTP id b17so28030309uas.0;
        Tue, 02 Nov 2021 07:02:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0hNhuZg6Cxc7k0N24ygUKVsmLdEaO62oHzQ30OZqTpE=;
        b=2V6hUMM979WF85WDbbBnLwIzEAWfheMSaNglPLrcnObxdyIiucLoJccbuqMl7VBteO
         U8OX+/dzkIytby7fP0eM8JV71dv1MKmgpx1FGiBn+Z5mumxSubkF2sShSwuEpi5GWbPa
         e6Lbz3XFTL4M9zOZmuiaxBMHVLTOqsgj6Zo1+rvEGcJa+EiH8oq1AKtFDrZlhY01g6FW
         mnEQczOjakL8576wBcYPGwB6Jtg4f1PT/EPhx5JNOsBnbDJq+xk9nGjV4+vej51KzHij
         ueaGzHwJyKLz86+wrK4XIJgvVDobdl/K0hOTV1iUUVcZPFx0OCA7sNlFbF2Qs/sRRO3J
         iQyA==
X-Gm-Message-State: AOAM531buhpOLMIwCK/u6Qqbo2MabhJSMHK9X3K4e4ANJMyenM4EtFs0
        f7EADXtHKRRefGUUDyeVxssO3MGUVi2nNw==
X-Google-Smtp-Source: ABdhPJxEK9LI51bWELabOBYCJnzIef2fBXg+KjRRsBev/Xoodp2x3vbp7O1m2shsCFCtodlNc4vWOA==
X-Received: by 2002:a05:6102:c4b:: with SMTP id y11mr4040039vss.48.1635861737805;
        Tue, 02 Nov 2021 07:02:17 -0700 (PDT)
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com. [209.85.222.54])
        by smtp.gmail.com with ESMTPSA id u204sm415385vsu.6.2021.11.02.07.02.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 07:02:16 -0700 (PDT)
Received: by mail-ua1-f54.google.com with SMTP id az37so9857264uab.13;
        Tue, 02 Nov 2021 07:02:16 -0700 (PDT)
X-Received: by 2002:a67:ee41:: with SMTP id g1mr13720887vsp.41.1635861736345;
 Tue, 02 Nov 2021 07:02:16 -0700 (PDT)
MIME-Version: 1.0
References: <20211027022223.183838-1-damien.lemoal@wdc.com>
 <20211027022223.183838-4-damien.lemoal@wdc.com> <alpine.DEB.2.22.394.2111021130020.2311589@ramsan.of.borg>
 <63c29948-24ac-1cc3-5c1a-1e5b82c9b19f@opensource.wdc.com>
In-Reply-To: <63c29948-24ac-1cc3-5c1a-1e5b82c9b19f@opensource.wdc.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 2 Nov 2021 15:02:05 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVyUDp1YMkq7e7tu30L=7U7-WV-Ota5KdMddUivUzt50Q@mail.gmail.com>
Message-ID: <CAMuHMdVyUDp1YMkq7e7tu30L=7U7-WV-Ota5KdMddUivUzt50Q@mail.gmail.com>
Subject: Re: [PATCH v9 3/5] libata: support concurrent positioning ranges log
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        scsi <linux-scsi@vger.kernel.org>, linux-renesas@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Damien,

On Tue, Nov 2, 2021 at 12:42 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
> On 2021/11/02 19:40, Geert Uytterhoeven wrote:
> > On Wed, 27 Oct 2021, Damien Le Moal wrote:
> >> Add support to discover if an ATA device supports the Concurrent
> >> Positioning Ranges data log (address 0x47), indicating that the device
> >> is capable of seeking to multiple different locations in parallel using
> >> multiple actuators serving different LBA ranges.
> >>
> >> Also add support to translate the concurrent positioning ranges log
> >> into its equivalent Concurrent Positioning Ranges VPD page B9h in
> >> libata-scsi.c.
> >>
> >> The format of the Concurrent Positioning Ranges Log is defined in ACS-5
> >> r9.
> >>
> >> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> >
> > Thanks for your patch, which is now commit fe22e1c2f705676a ("libata:
> > support concurrent positioning ranges log") upstream.
> >
> > During resume from s2ram on Renesas Salvator-XS, I now see more scary
> > messages than before:
> >
> >       ata1: link resume succeeded after 1 retries
> >       ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> >      +ata1.00: qc timeout (cmd 0x2f)
> >      +ata1.00: Read log page 0x00 failed, Emask 0x4
> >      +ata1.00: ATA Identify Device Log not supported
> >      +ata1.00: failed to set xfermode (err_mask=0x40)
> >       ata1: link resume succeeded after 1 retries
> >       ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> >      +ata1.00: ATA Identify Device Log not supported
> >      +ata1.00: ATA Identify Device Log not supported
> >       ata1.00: configured for UDMA/133
> >
> > I guess this is expected?
>
> Nope, it is not. The problem is actually not the concurrent positioning log, or
> any other log, being supported or not.
>
> Notice the qc timeout ? On device scan after coming out of sleep, or even simply
> doing a rmmod ahci+modprobe ahci, the read log commands issued during device
> revalidate timeout fairly easily as they are issued while the drive is not
> necessarilly fully restarted yet. These errors happen fairly easily due to the
> command timeout setting in libata being too short, I think, for the "restart"
> case. On a clean boot, they do not happen as longer timeouts are used in that case.
>
> I identified this problem recently while testing stuff: I was doing rmmod of ata
> modules and then modprobe of newly compiled modules for tests and noticed these
> timeouts. Increasing the timeout values, they disappear. I am however still
> scratching my head about the best way to address this. Still digging about this
> to first make sure this is really about timeouts being set too short.

There's indeed something timing-related going on.  Sometimes I get
during resume (s2idle or s2ram):

    ata1.00: qc timeout (cmd 0x2f)
    ata1.00: Read log page 0x00 failed, Emask 0x4
    ata1.00: ATA Identify Device Log not supported
    ata1.00: failed to set xfermode (err_mask=0x40)
    ata1.00: limiting speed to UDMA/133:PIO3
    ata1: link resume succeeded after 1 retries
    ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
    ata1.00: NODEV after polling detection
    ata1.00: revalidation failed (errno=-2)
    ata1.00: disabled
    ata1: link resume succeeded after 1 retries
    ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
    sd 0:0:0:0: [sda] Start/Stop Unit failed: Result: hostbyte=0x04
driverbyte=DRIVER_OK
    sd 0:0:0:0: [sda] Read Capacity(16) failed: Result: hostbyte=0x04
driverbyte=DRIVER_OK
    sd 0:0:0:0: [sda] Sense not available.
    sd 0:0:0:0: [sda] Read Capacity(10) failed: Result: hostbyte=0x04
driverbyte=DRIVER_OK
    sd 0:0:0:0: [sda] Sense not available.
    sd 0:0:0:0: [sda] 0 512-byte logical blocks: (0 B/0 B)
    sda: detected capacity change from 320173056 to 0

after which the drive is no longer functional...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
