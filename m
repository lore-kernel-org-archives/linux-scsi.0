Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B4DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 22:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240912AbiA0WrU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 17:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbiA0WrT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2022 17:47:19 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0966CC06173B
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 14:47:19 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id p27so8221406lfa.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 14:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GjHUuqQH8JVxmocQ1vB3QRAgmIYi4so6JV2ldg8Qna8=;
        b=tadvaPckx4r3MPOgnSQQCqX7CvRLyV49Z6VolacjjfmiCOPeMZNvw/n3MyV2J+nRdu
         hMXdCaid7H5hlc0Se9aJsF8ROOHdIJ1XtdnlVlLwUlLFslhG32442znXy7GsdRNBG05q
         NkbmMprA2XtecU08TnZU6hhN0raXXZSkTZzlC5cbu3Fg/fP5I0V8h0j8yVze6x36dRHH
         ELWjlXaFxOffOQ2VNsqRJQRt8Ga8MPGoY92HJ2tCyEjrVR6ZU5RjcGeLVXiPpOKggzwP
         XZPtEcWl+4I5Vpyn0UdyIBugStlAinGUVY4DOSCqcQqp73W6Bxf1CUt0bX7qwxWNA5WA
         ElqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GjHUuqQH8JVxmocQ1vB3QRAgmIYi4so6JV2ldg8Qna8=;
        b=ycxfxRnpUh8Y4FOF6ATthLQlSZzc+v4QaXgbbYowXR6z5K4z2GiAvS0cFsXyiIacXK
         CUQXuIXvb+WlApPaNhVVCRQ+MzIiwFrdnIMYD/XiaHABZgH0gNymBRwZGLD2PDZ2aORW
         VgOuOrVWwqz1qU5JkUt95z078050ES+ityDy5KalXSdiBUyegHB3TaWd4KYurqnyHh72
         fxpZPP9kPoQSPVIsMoQJpfy+g9rPvQQJlbWp/2ZyW+VgpIO0xRbTioQkBghAKe8i65Sd
         sY2NgfTM/FJZOR8slt1R/ppmCGSzmPYijNEZvCXYDuK+oTiGyQ838z4KuDbtZZUVyEoU
         epEQ==
X-Gm-Message-State: AOAM531YpCAHBqMwVqYzMNODroNmg7gv08LxMPPMndN9AowAE7jUj6mN
        vBa45VfgbdYMJwZrDBpo87A7rrXnvOLxLJXpxJGdqg==
X-Google-Smtp-Source: ABdhPJwf2eU9dQWZaPtXNpqaSJbqd37RRf00Y7CUNwXuSZNS1ndxY7n2prmgDhYz8lI31KJtbbC8HikIkG5PJzgQRC8=
X-Received: by 2002:ac2:5510:: with SMTP id j16mr4239686lfk.240.1643323636985;
 Thu, 27 Jan 2022 14:47:16 -0800 (PST)
MIME-Version: 1.0
References: <20220127151945.1244439-1-trix@redhat.com> <953eb015-4b78-f7b-5dc1-6491c6bf27e@linux-m68k.org>
In-Reply-To: <953eb015-4b78-f7b-5dc1-6491c6bf27e@linux-m68k.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 27 Jan 2022 14:47:04 -0800
Message-ID: <CAKwvOdnWHVV+3s8SO=Q8FfZ7hVekRVDL5q+7CwAk_z44xaex8w@mail.gmail.com>
Subject: Re: [PATCH] scsi: megaraid: cleanup formatting of megaraid
To:     Finn Thain <fthain@linux-m68k.org>, Miguel Ojeda <ojeda@kernel.org>
Cc:     Tom Rix <trix@redhat.com>, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com, nathan@kernel.org,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+ Miguel (the clang-format maintainer), Joe (checkpatch maintainer)
These criticisms are worth reviewing.

On Thu, Jan 27, 2022 at 2:38 PM Finn Thain <fthain@linux-m68k.org> wrote:
>
>
> On Thu, 27 Jan 2022, trix@redhat.com wrote:
>
> > From: Tom Rix <trix@redhat.com>
> >
> > checkpatch reports several hundred formatting errors. Run these files
> > through clang-format and knock off some of them.
> >
>
> That method seems like a good recipe for endless churn unless checkpatch
> and clang-format really agree about these style rules.
>
> Why use checkpatch to assess code style, if we could simply diff the
> existing source with the output from clang-format... but it seems that
> clang-format harms readability, makes indentation errors and uses
> inconsistent style rules. Some examples:
>
> >  static unsigned short int max_sectors_per_io = MAX_SECTORS_PER_IO;
> >  module_param(max_sectors_per_io, ushort, 0);
> > -MODULE_PARM_DESC(max_sectors_per_io, "Maximum number of sectors per I/O request (default=MAX_SECTORS_PER_IO=128)");
> > -
> > +MODULE_PARM_DESC(
> > +     max_sectors_per_io,
> > +     "Maximum number of sectors per I/O request (default=MAX_SECTORS_PER_IO=128)");
> >
> >  static unsigned short int max_mbox_busy_wait = MBOX_BUSY_WAIT;
> >  module_param(max_mbox_busy_wait, ushort, 0);
> > -MODULE_PARM_DESC(max_mbox_busy_wait, "Maximum wait for mailbox in microseconds if busy (default=MBOX_BUSY_WAIT=10)");
> > +MODULE_PARM_DESC(
> > +     max_mbox_busy_wait,
> > +     "Maximum wait for mailbox in microseconds if busy (default=MBOX_BUSY_WAIT=10)");
> >
>
> This code is longer for no real improvement.
>
> >
> >  /*
> >   * The File Operations structure for the serial/ioctl interface of the driver
> >   */
> >  static const struct file_operations megadev_fops = {
> > -     .owner          = THIS_MODULE,
> > -     .unlocked_ioctl = megadev_unlocked_ioctl,
> > -     .open           = megadev_open,
> > -     .llseek         = noop_llseek,
> > +     .owner = THIS_MODULE,
> > +     .unlocked_ioctl = megadev_unlocked_ioctl,
> > +     .open = megadev_open,
> > +     .llseek = noop_llseek,
> >  };
> >
> >  /*
>
> Readability loss.
>
> > -             prod_info_dma_handle = dma_map_single(&adapter->dev->dev,
> > -                                                   (void *)&adapter->product_info,
> > -                                                   sizeof(mega_product_info),
> > -                                                   DMA_FROM_DEVICE);
> > +             prod_info_dma_handle = dma_map_single(
> > +                     &adapter->dev->dev, (void *)&adapter->product_info,
> > +                     sizeof(mega_product_info), DMA_FROM_DEVICE);
> >
>
> Note the orphaned first parameter and odd indentation.
>
> >
> >  static DEF_SCSI_QCMD(megaraid_queue)
> >
> > -/**
> > +     /**
> >   * mega_allocate_scb()
> >   * @adapter: pointer to our soft state
> >   * @cmd: scsi command from the mid-layer
>
> Indentation error.
>
> > @@ -418,15 +409,14 @@ static DEF_SCSI_QCMD(megaraid_queue)
> >   * Allocate a SCB structure. This is the central structure for controller
> >   * commands.
> >   */
> > -static inline scb_t *
> > -mega_allocate_scb(adapter_t *adapter, struct scsi_cmnd *cmd)
> > +     static inline scb_t *mega_allocate_scb(adapter_t *adapter,
> > +                                            struct scsi_cmnd *cmd)
> >  {
> >       struct list_head *head = &adapter->free_list;
>
> Same.
>
> > @@ -586,26 +568,25 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
> >
> >               ldrv_num = mega_get_ldrv_num(adapter, cmd, channel);
> >
> > -
> >               max_ldrv_num = (adapter->flag & BOARD_40LD) ?
> > -                     MAX_LOGICAL_DRIVES_40LD : MAX_LOGICAL_DRIVES_8LD;
> > +                                    MAX_LOGICAL_DRIVES_40LD :
> > +                                          MAX_LOGICAL_DRIVES_8LD;
> >
>
> Churn, if not readability loss. Note the indentation change here is
> inconsistent with the indentation change noted above.
>
> >                        * 6-byte READ(0x08) or WRITE(0x0A) cdb
> >                        */
> > -                     if( cmd->cmd_len == 6 ) {
> > -                             mbox->m_out.numsectors = (u32) cmd->cmnd[4];
> > -                             mbox->m_out.lba =
> > -                                     ((u32)cmd->cmnd[1] << 16) |
> > -                                     ((u32)cmd->cmnd[2] << 8) |
> > -                                     (u32)cmd->cmnd[3];
> > +                     if (cmd->cmd_len == 6) {
> > +                             mbox->m_out.numsectors = (u32)cmd->cmnd[4];
> > +                             mbox->m_out.lba = ((u32)cmd->cmnd[1] << 16) |
> > +                                               ((u32)cmd->cmnd[2] << 8) |
> > +                                               (u32)cmd->cmnd[3];
> >
> >                               mbox->m_out.lba &= 0x1FFFFF;
> >
>
> Here, the orphaned term is moved up, next to the =. And yet,
>
> >
> >                       /* Calculate Scatter-Gather info */
> > -                     mbox->m_out.numsgelements = mega_build_sglist(adapter, scb,
> > -                                     (u32 *)&mbox->m_out.xferaddr, &seg);
> > +                     mbox->m_out.numsgelements =
> > +                             mega_build_sglist(adapter, scb,
> > +                                               (u32 *)&mbox->m_out.xferaddr,
> > +                                               &seg);
> >
> >                       return scb;
> >
>
> ... here the first term is moved down and orphaned, which is another
> inconsistency.



-- 
Thanks,
~Nick Desaulniers
