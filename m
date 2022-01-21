Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C7EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jan 2022 19:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiAUTRp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jan 2022 14:17:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229919AbiAUTRo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Jan 2022 14:17:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642792663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YOj++iJ/HGUrHN1qyNsjXqMeoxD3tF2rjHsxObyBvWY=;
        b=LQu60CQLzyYuhMtLwRJQyLUN3GUiNqSkMJ0B3eBgcsarlu+Yb/7CMbGoUsJ5IS0+onGuJB
        0xnu2hQWVHoB1UF9CjuWbbsEObduEtsQhSQOkrPUO33ie2f7XpXyHghR3tbzt4GqNyYbbb
        hrgNmaZbnDVWCKun99yFQaTMPspXKhA=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-qu8fUe1VNZGMndDAZDVZhg-1; Fri, 21 Jan 2022 14:17:42 -0500
X-MC-Unique: qu8fUe1VNZGMndDAZDVZhg-1
Received: by mail-vk1-f199.google.com with SMTP id z84-20020a1f9757000000b0031ba7827bcaso1713272vkd.6
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jan 2022 11:17:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YOj++iJ/HGUrHN1qyNsjXqMeoxD3tF2rjHsxObyBvWY=;
        b=sK6sN4dXcbL1b1HY8f2UUa2IQhULNxGtvUC/dHDRAU1A5tGRz/uyaasKJeHGLnagOV
         VD6UOEAm8kZfiVIby3dBscNUOEAZuJnCzRE/4Vn6EGFFDt9vhvTKDVPQGG1HXigNkmsD
         qp6gW0s8G3dL/x2JgJ9s3K/TN4kUuUaphmo2l7w6zzyLmN7gQ0Qfm/i+71z8ESk+ejH/
         ZrRHfogwbg8d1K8TrnQSW9kqXTZLhWLMPRyPV4LliMkRbyFYPd5TmKfdbh8R07ujoOoD
         aQuaEz+/IZiFDdykWHtBijOJvie9aZZpRPmTdn0SoBMTEvo+qk24YCHf6IyIzualPXRM
         Wu2Q==
X-Gm-Message-State: AOAM532Q3Y/dEYceGKAtfRWD/xoMDxOssMu7JHRYtiw9Hs8jEbKruH0I
        PsDsep/zN+vSZTuF04ot3ys/gsthzJDpxndrcyflbsi3iAboatU6fAZeS+1hgd9KGfRRtEomohY
        6Ab3u2nzIpwICCF705Pur5DiNfXv1cBq5LRKMKA==
X-Received: by 2002:a05:6122:1348:: with SMTP id f8mr2322890vkp.23.1642792662066;
        Fri, 21 Jan 2022 11:17:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykEsKbULoVd5Ke+OEuF4VtG56SfdNa/ozztrTlxlyuCz4eYdlIgn+IpivjO4HHfL8n90uq/qId2SfIEZWlka8=
X-Received: by 2002:a05:6122:1348:: with SMTP id f8mr2322875vkp.23.1642792661776;
 Fri, 21 Jan 2022 11:17:41 -0800 (PST)
MIME-Version: 1.0
References: <20220121164938.18190-1-jpittman@redhat.com> <b4faa458-5f0c-cc19-05f4-22305b4942d1@linux.ibm.com>
In-Reply-To: <b4faa458-5f0c-cc19-05f4-22305b4942d1@linux.ibm.com>
From:   John Pittman <jpittman@redhat.com>
Date:   Fri, 21 Jan 2022 14:17:31 -0500
Message-ID: <CA+RJvhzVLXGLE0SDYO8mEYR4GEXwPJNkzbVJCJF2KcV3td+vAQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: print actual pointer addresses if using scsi debug logging
To:     Steffen Maier <maier@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, dgilbert <dgilbert@interlog.com>,
        David Jeffery <djeffery@redhat.com>,
        Laurence Oberman <loberman@redhat.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks for looking Steffen.  I failed to notice the no_hash_pointers
option.  I do think it would be a reasonable convenience for debug
scsi logging to print the actual address without having to go through
the trouble of rebooting enabling the no_hash_pointers parameter then
rebooting again to disable afterward.  Perhaps the system is a
production box that can't be rebooted. Maybe an additional sysctl to
enable no_hash_pointers would be reasonable?  That way it could be
changed online?  Thanks again.

On Fri, Jan 21, 2022 at 1:24 PM Steffen Maier <maier@linux.ibm.com> wrote:
>
> On 1/21/22 17:49, John Pittman wrote:
> > Since commit ad67b74d2469 ("printk: hash addresses printed with
> > %p"), any addresses printed with an unadorned %p will be hashed.
> > However, when scsi debug logging is enabled, in general, the
> > user needs the actual address for use with address tracking or
> > vmcore analysis.  Print the actual address for pointers when
> > using the SCSI_LOG_* macros.
>
> While scsi_logging_level defaults to 0, i.e. all disabled, and it requires root
> privileges to increase it, I wonder how unconditionally unmodified addresses
> for scsi logging would relate to KASLR.
>
> Why not have the root user use no_hash_pointers with the existing plain
> pointers %p when setting scsi_logging_level?
> That way, it would be a clear and deliberate unhashing choice to be done by
> higher powers.
> Is it because changing no_hash_pointers does not seem dynamic as opposed to
> changing scsi_logging_level? I could not find such info in the patch description.
> Or would you delegate user access control to unmodified addresses in scsi
> logging kernel messages to
> https://www.kernel.org/doc/html/latest/admin-guide/sysctl/kernel.html#dmesg-restrict
> ?
>
> While still not being unambiguous, I often try to use the CDB for correlation
> of scsi logs with pending (request) objects in a crash dump. Would that be an
> alternative to pointers? AFAIK, with scsi_cmnd being re-used, the pointers are
>   not unique for a particular request as time progresses.
> Enabling SCSI tracepoints on top can also be useful.
>
> References
>
> https://www.kernel.org/doc/html/latest/core-api/printk-formats.html#plain-pointers
> "If not possible, and the aim of printing the address is to provide more
> information for debugging, use %p and boot the kernel with the no_hash_pointers
> parameter during debugging, which will print all %p addresses unmodified."
>
> https://www.kernel.org/doc/html/latest/core-api/printk-formats.html#unmodified-addresses
> "Before using %px, consider if using %p is sufficient together with enabling
> the no_hash_pointers kernel parameter during debugging sessions"
>
> >
> > Signed-off-by: John Pittman <jpittman@redhat.com>
> > Collab-from: David Jeffery <djeffery@redhat.com>
> > ---
> >   drivers/scsi/scsi.c     | 2 +-
> >   drivers/scsi/scsi_lib.c | 2 +-
> >   drivers/scsi/sg.c       | 8 ++++----
> >   drivers/scsi/sr.c       | 2 +-
> >   4 files changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > index 211aace69c22..0f558135637c 100644
> > --- a/drivers/scsi/scsi.c
> > +++ b/drivers/scsi/scsi.c
> > @@ -106,7 +106,7 @@ void scsi_log_send(struct scsi_cmnd *cmd)
> >                                      SCSI_LOG_MLQUEUE_BITS);
> >               if (level > 1) {
> >                       scmd_printk(KERN_INFO, cmd,
> > -                                 "Send: scmd 0x%p\n", cmd);
> > +                                 "Send: scmd 0x%px\n", cmd);
> >                       scsi_print_command(cmd);
> >               }
> >       }
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 35e381f6d371..a25ab894383b 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -148,7 +148,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
> >       struct scsi_device *device = cmd->device;
> >
> >       SCSI_LOG_MLQUEUE(1, scmd_printk(KERN_INFO, cmd,
> > -             "Inserting command %p into mlqueue\n", cmd));
> > +             "Inserting command %px into mlqueue\n", cmd));
> >
> >       scsi_set_blocked(cmd, reason);
> >
> > diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> > index ad12b3261845..2b11dc84d04b 100644
> > --- a/drivers/scsi/sg.c
> > +++ b/drivers/scsi/sg.c
> > @@ -1274,7 +1274,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
> >               return -ENXIO;
> >       req_sz = vma->vm_end - vma->vm_start;
> >       SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
> > -                                   "sg_mmap starting, vm_start=%p, len=%d\n",
> > +                                   "sg_mmap starting, vm_start=%px, len=%d\n",
> >                                     (void *) vma->vm_start, (int) req_sz));
> >       if (vma->vm_pgoff)
> >               return -EINVAL; /* want no offset */
> > @@ -1944,7 +1944,7 @@ sg_remove_scat(Sg_fd * sfp, Sg_scatter_hold * schp)
> >                       for (k = 0; k < schp->k_use_sg && schp->pages[k]; k++) {
> >                               SCSI_LOG_TIMEOUT(5,
> >                                       sg_printk(KERN_INFO, sfp->parentdp,
> > -                                     "sg_remove_scat: k=%d, pg=0x%p\n",
> > +                                     "sg_remove_scat: k=%d, pg=0x%px\n",
> >                                       k, schp->pages[k]));
> >                               __free_pages(schp->pages[k], schp->page_order);
> >                       }
> > @@ -2156,7 +2156,7 @@ sg_add_sfp(Sg_device * sdp)
> >       list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
> >       write_unlock_irqrestore(&sdp->sfd_lock, iflags);
> >       SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
> > -                                   "sg_add_sfp: sfp=0x%p\n", sfp));
> > +                                   "sg_add_sfp: sfp=0x%px\n", sfp));
> >       if (unlikely(sg_big_buff != def_reserved_size))
> >               sg_big_buff = def_reserved_size;
> >
> > @@ -2200,7 +2200,7 @@ sg_remove_sfp_usercontext(struct work_struct *work)
> >       }
> >
> >       SCSI_LOG_TIMEOUT(6, sg_printk(KERN_INFO, sdp,
> > -                     "sg_remove_sfp: sfp=0x%p\n", sfp));
> > +                     "sg_remove_sfp: sfp=0x%px\n", sfp));
> >       kfree(sfp);
> >
> >       scsi_device_put(sdp->device);
> > diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> > index f925b1f1f9ad..3b942c99a783 100644
> > --- a/drivers/scsi/sr.c
> > +++ b/drivers/scsi/sr.c
> > @@ -411,7 +411,7 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
> >               SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
> >                       "Finishing %u sectors\n", blk_rq_sectors(rq)));
> >               SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
> > -                     "Retry with 0x%p\n", SCpnt));
> > +                     "Retry with 0x%px\n", SCpnt));
> >               goto out;
> >       }
> >
>
>
> --
> Mit freundlichen Gruessen / Kind regards
> Steffen Maier
>
> Linux on IBM Z and LinuxONE
>
> https://www.ibm.com/privacy/us/en/
> IBM Deutschland Research & Development GmbH
> Vorsitzender des Aufsichtsrats: Gregor Pillen
> Geschaeftsfuehrung: David Faller, Dirk Wittkopp
> Sitz der Gesellschaft: Boeblingen
> Registergericht: Amtsgericht Stuttgart, HRB 243294
>

