Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDAA279DCC
	for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2026 21:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777237612; cv=pass; b=EHNriQWJ99dIxwShHOxWHi3MAi7j6pg1LoUh835HExvFt9zfh3dfK0q5nYmdyPNlN2i+QnDYYjOIR3AbiFEMHCdHcbfbZbYaerJoY4ss0SjoIoZEXdX9PAVje1ZkJdGp4q8c9YAM/iZv3imnbCVgos5sd0F7mi5wqvGqi8Lf1/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777237612; c=relaxed/simple;
	bh=EPuNdkhaV15xMCGIxBBJeyGOyEjyGMHa2wTzi3R01ag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Szhf0GZhzHbdc2T1EJUQ80v0T+GtdpWtp0ZVPz1jv+CBKshtZDDMjN6Wr9b7iv6IQ23eL4vsWghL2xBCgw4Op2gWGjBhE1wKrAc49nYxR+S5vQKr2zhEaVbBy49jEDz6EPRcH5x6CPH9Me77aeH6AzQRMCu+lyUQn9CKlCnzEVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b82JYB00; arc=pass smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b82JYB00"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40427db1300so7141759fac.0
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2026 14:06:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777237610; cv=none;
        d=google.com; s=arc-20240605;
        b=L4nry9iBzBMgLxc9qa/L/cSNkCdWbTt7uXFuE8jLhdrzK05nLO4OnBhH7BhB4O/WeS
         NnlL62J7+7JqtuQOQpXy/MQnPYkMf26L5NL3gE4vn7vDqj3ECICetKlvCM4VbpbFWbG/
         QSi4qMdHzN29C3RhQ5w1jrbDkDh/mZL6eb1zxeFLWjYO6zmZPKp/F2JZeuTPpaHI7ZU2
         7xedjJBAGbXH1w4w+78hkeeY2HcHRBlqzjxnPlazzwHzbuKRz4lVF70CBIp6F88Cu+OO
         jXh4Pq3JZgWnmb/wXiGCCEEhIOuw4aBcb00zVhue1Zvr9obViLAgy+EpQksBqa1jYGXp
         EvFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Q98Neb0Cp98rQk5Ag0+/e7d3yb11iyMjXveTzQWbQ2Y=;
        fh=Ahvb6pE9W+MJldgERV4TOzSo0ZapV3Q4mGlwIMDAbMo=;
        b=ByrjNM/9XHj1AEGnOIxioDN5oXqFJ3nzQf86/aSgSZkYIDsWLLjQb6geBigUgq3wWv
         He4z9/HyLuEbIODpZRUhIgILnx2X1tu0Br5wKcb3AVOENusoPbwIaiJCT8POk8AHD22l
         MJUk5iK/srKgvdDGjDMoKOcbHCkgbh2j6herLbE8U+ec6Pd11jR+MlaNWztXCIZGSH+n
         xkR1egQQRNR2bAITI4AmDenxEJrJNydERV68YCyPd9ey07qYnchQha+MMTzPyHgddedp
         rtFseYCgIeqkny1zROd38NAE5Quiq8XEryWTrOFfJObOQZ0+ssEBH6pkyrUgfNQxFT+X
         eqWA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777237610; x=1777842410; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q98Neb0Cp98rQk5Ag0+/e7d3yb11iyMjXveTzQWbQ2Y=;
        b=b82JYB00LTYC0mDeWQEDBOr/W53+fJKk0lJ/T4YTbJUi5ES5ESCbNdpLrrMNwQT1F8
         Acop6xyJ7WUavjRX9hWeqGk7Hf4ndfqWCXBB+AF6pTSbOMXkxBZZWduwAtpQafgHKn5c
         cy2j9sJym+etEBy5/Gk1BZoS8MpplzE6SQxJqrON2EU6xuKyu65Jjy3FW4KMHaPacf4a
         t5XKU3v8+MhfdL2y92spXJjw47xCrLzA5YENxV0LLpxdxNdASitm+V9hnww+hH5cemSX
         WRxYEcU/XEjyz2W7d3bxchD5fxTpwhS3t3n2dTc5IXrzSOSIaazKsOJw2se/NVIQ2hWQ
         7mOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777237610; x=1777842410;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q98Neb0Cp98rQk5Ag0+/e7d3yb11iyMjXveTzQWbQ2Y=;
        b=dSJeWqSjma1VsgesyieO4w56xe94YKoaoeXv2f9ZtiCrb4hpgH+aPrXraXsDEIcF7k
         fdnGOtNxLahhXppSR0sRNAkknUwGOnDPDmMhQmjAKeqX2KG5zzYzsIp5QsuEhTQl0+gB
         XfTp09SRmzBL/bUEHRv/HvGGS12uB9wFzr0FRQ1MnwDFMpUl31YaQAasGf/cXbgpX3Hu
         k2nSgFX4aWdWmL7+BlKimdaNKOowYwn0jrZze/9mWoRRHxx6qg/aKNo7TwAR4LD32OvW
         hxhK97qQtOmahd4wszoBNsV5VUbnOXtFobiSomKKw1mWBPVhUrcsjuQENMvLzogg3fgn
         CnuA==
X-Forwarded-Encrypted: i=1; AFNElJ8HV3QYPfmZZ3WIykxvx8wRsU/mvS/mdW+Q4GuHk8wsOIaJ413/ONyLnU1zCq2URF9pyhE1lzXRNHUp@vger.kernel.org
X-Gm-Message-State: AOJu0YxfrokrmfSEYBysvaPDEFJK18r2M1kRul5BwP3zj+FE9RNSITlO
	GdVig9M1PV0EMouPlkYKNBHkS+Ftyiut4CRzLgglrUeOV9YUDbKDf4oe8Mh+cG9/+b+wJX6b1VE
	k5nOi133D6qo3TJLx+5Klj9I3C+N2gEw=
X-Gm-Gg: AeBDiesuOM8hELhEB1leiLs0zFpiLw0GUI9cctCozNnNE9DO7gWguBhDWNLPewbTrwe
	tdlvLhoiE5bz5HOHBz78sYIDLIT1/asblGS+T83OaVGzXj8Dq4ISFBokkeVu+lrBaXbsrh4cZCI
	TjTl/UNHRlFTNhkevVkP4YVF6FR3bKfazTyfR8bEzxqm7W2R7x+yf18IcQteYFInDbai+631n84
	2Gkf13lmFHO22jhzavItmZa0LP1gEppyLn/d3Dnyv8KH97hQohSJ+fwD2t50/DvsboQ5ebpDPLO
	XjSZc5Nj9C5ZW+8wNfY+cZhLwEkYw+MpROYZAF58I/n4oixY5tcU42CZGiFYvgLNbpm2c3BdCFE
	Ffira3tmEdMtuy8vYNddIMKe/5GcQI7YdYuE=
X-Received: by 2002:a05:6870:f10d:b0:42c:2421:5781 with SMTP id
 586e51a60fabf-42c242246f7mr16972216fac.28.1777237610203; Sun, 26 Apr 2026
 14:06:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260330133403.796330-1-daan@amutable.com> <20260422113206.246267-1-daan@amutable.com>
 <ae59luYMh6npxD09@equinox>
In-Reply-To: <ae59luYMh6npxD09@equinox>
From: Daan De Meyer <daan.j.demeyer@gmail.com>
Date: Sun, 26 Apr 2026 23:06:39 +0200
X-Gm-Features: AVHnY4Is5SRGs9E1V39rh7RHauHqBvSm5clTEPXBmfOE9Oe8S-tXrLNwNYYlHMA
Message-ID: <CAO8sHc=eJqCKpxUTcGeTm-_KsEVzjULj6KPG-h82Lr0_JUqOng@mail.gmail.com>
Subject: Re: [PATCH v2] cdrom, scsi: sr: propagate read-only status to block
 layer via set_disk_ro()
To: Phillip Potter <phil@philpotter.co.uk>
Cc: martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com, 
	axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Daan De Meyer <daan@amutable.com>
Content-Type: text/plain; charset="UTF-8"

Hi Phil,

Thanks for the review! You can adjust the submission. Yeah I should
probably fix my smtp stuff to use my corporate address. Feel free to
adjust the submission as you suggested.

Thanks!

Daan

On Sun, 26 Apr 2026 at 23:03, Phillip Potter <phil@philpotter.co.uk> wrote:
>
> On Wed, Apr 22, 2026 at 11:32:06AM +0000, Daan De Meyer wrote:
> >
> >  drivers/cdrom/cdrom.c | 73 ++++++++++++++++++++++++++++---------------
> >  drivers/scsi/sr.c     | 11 ++-----
> >  drivers/scsi/sr.h     |  1 -
> >  include/linux/cdrom.h |  1 +
> >  4 files changed, 51 insertions(+), 35 deletions(-)
> >
> > diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> > index fc049612d6dc..62934cf4b10d 100644
> > --- a/drivers/cdrom/cdrom.c
> > +++ b/drivers/cdrom/cdrom.c
> > @@ -631,6 +631,16 @@ int register_cdrom(struct gendisk *disk, struct cdrom_device_info *cdi)
> >
> >       WARN_ON(!cdo->generic_packet);
> >
> > +     /*
> > +      * Propagate the drive's write support to the block layer so BLKROGET
> > +      * reflects actual write capability. Drivers that use GET CONFIGURATION
> > +      * features (CDC_MRW_W, CDC_RAM) must have called
> > +      * cdrom_probe_write_features() before register_cdrom() so the mask is
> > +      * complete here.
> > +      */
> > +     set_disk_ro(disk, !CDROM_CAN(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM |
> > +                                  CDC_CD_RW));
> > +
> >       cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
> >       mutex_lock(&cdrom_mutex);
> >       list_add(&cdi->list, &cdrom_list);
> > @@ -742,6 +752,44 @@ static int cdrom_is_random_writable(struct cdrom_device_info *cdi, int *write)
> >       return 0;
> >  }
> >
> > +/*
> > + * Probe write-related MMC features via GET CONFIGURATION and update
> > + * cdi->mask accordingly. Drivers that populate cdi->mask from the MODE SENSE
> > + * capabilities page (e.g. sr) should call this after those MODE SENSE bits
> > + * have been set but before register_cdrom(), so that the full set of
> > + * write-capability bits is known by the time register_cdrom() decides on the
> > + * initial read-only state of the disk.
> > + */
> > +void cdrom_probe_write_features(struct cdrom_device_info *cdi)
> > +{
> > +     int mrw, mrw_write, ram_write;
> > +
> > +     mrw = 0;
> > +     if (!cdrom_is_mrw(cdi, &mrw_write))
> > +             mrw = 1;
> > +
> > +     if (CDROM_CAN(CDC_MO_DRIVE))
> > +             ram_write = 1;
> > +     else
> > +             (void) cdrom_is_random_writable(cdi, &ram_write);
> > +
> > +     if (mrw)
> > +             cdi->mask &= ~CDC_MRW;
> > +     else
> > +             cdi->mask |= CDC_MRW;
> > +
> > +     if (mrw_write)
> > +             cdi->mask &= ~CDC_MRW_W;
> > +     else
> > +             cdi->mask |= CDC_MRW_W;
> > +
> > +     if (ram_write)
> > +             cdi->mask &= ~CDC_RAM;
> > +     else
> > +             cdi->mask |= CDC_RAM;
> > +}
> > +EXPORT_SYMBOL(cdrom_probe_write_features);
> > +
> >  static int cdrom_media_erasable(struct cdrom_device_info *cdi)
> >  {
> >       disc_information di;
> > @@ -894,33 +942,8 @@ static int cdrom_is_dvd_rw(struct cdrom_device_info *cdi)
> >   */
> >  static int cdrom_open_write(struct cdrom_device_info *cdi)
> >  {
> > -     int mrw, mrw_write, ram_write;
> >       int ret = 1;
> >
> > -     mrw = 0;
> > -     if (!cdrom_is_mrw(cdi, &mrw_write))
> > -             mrw = 1;
> > -
> > -     if (CDROM_CAN(CDC_MO_DRIVE))
> > -             ram_write = 1;
> > -     else
> > -             (void) cdrom_is_random_writable(cdi, &ram_write);
> > -
> > -     if (mrw)
> > -             cdi->mask &= ~CDC_MRW;
> > -     else
> > -             cdi->mask |= CDC_MRW;
> > -
> > -     if (mrw_write)
> > -             cdi->mask &= ~CDC_MRW_W;
> > -     else
> > -             cdi->mask |= CDC_MRW_W;
> > -
> > -     if (ram_write)
> > -             cdi->mask &= ~CDC_RAM;
> > -     else
> > -             cdi->mask |= CDC_RAM;
> > -
> >       if (CDROM_CAN(CDC_MRW_W))
> >               ret = cdrom_mrw_open_write(cdi);
> >       else if (CDROM_CAN(CDC_DVD_RAM))
> > diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> > index 7adb2573f50d..c36c54ecd354 100644
> > --- a/drivers/scsi/sr.c
> > +++ b/drivers/scsi/sr.c
> > @@ -395,7 +395,7 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
> >
> >       switch (req_op(rq)) {
> >       case REQ_OP_WRITE:
> > -             if (!cd->writeable)
> > +             if (get_disk_ro(cd->disk))
> >                       goto out;
> >               SCpnt->cmnd[0] = WRITE_10;
> >               cd->cdi.media_written = 1;
> > @@ -681,6 +681,7 @@ static int sr_probe(struct scsi_device *sdev)
> >       error = -ENOMEM;
> >       if (get_capabilities(cd))
> >               goto fail_minor;
> > +     cdrom_probe_write_features(&cd->cdi);
> >       sr_vendor_init(cd);
> >
> >       set_capacity(disk, cd->capacity);
> > @@ -899,14 +900,6 @@ static int get_capabilities(struct scsi_cd *cd)
> >       /*else    I don't think it can close its tray
> >               cd->cdi.mask |= CDC_CLOSE_TRAY; */
> >
> > -     /*
> > -      * if DVD-RAM, MRW-W or CD-RW, we are randomly writable
> > -      */
> > -     if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) !=
> > -                     (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) {
> > -             cd->writeable = 1;
> > -     }
> > -
> >       kfree(buffer);
> >       return 0;
> >  }
> > diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
> > index dc899277b3a4..2d92f9cb6fec 100644
> > --- a/drivers/scsi/sr.h
> > +++ b/drivers/scsi/sr.h
> > @@ -35,7 +35,6 @@ typedef struct scsi_cd {
> >       struct scsi_device *device;
> >       unsigned int vendor;    /* vendor code, see sr_vendor.c         */
> >       unsigned long ms_offset;        /* for reading multisession-CD's        */
> > -     unsigned writeable : 1;
> >       unsigned use:1;         /* is this device still supportable     */
> >       unsigned xa_flag:1;     /* CD has XA sectors ? */
> >       unsigned readcd_known:1;        /* drive supports READ_CD (0xbe) */
> > diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
> > index b907e6c2307d..260d7968cf72 100644
> > --- a/include/linux/cdrom.h
> > +++ b/include/linux/cdrom.h
> > @@ -108,6 +108,7 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
> >  extern unsigned int cdrom_check_events(struct cdrom_device_info *cdi,
> >                                      unsigned int clearing);
> >
> > +extern void cdrom_probe_write_features(struct cdrom_device_info *cdi);
> >  extern int register_cdrom(struct gendisk *disk, struct cdrom_device_info *cdi);
> >  extern void unregister_cdrom(struct cdrom_device_info *cdi);
> >
> > --
> > 2.53.0
> >
>
> Hi Daan,
>
> I've looked through the patch and it looks good to me. Looks like a
> decent change. I think in this case too, it's unlikely this historically
> broken behaviour is being relied upon (i.e. it seems unlikely to me that
> fixing it would break anything).
>
> In addition, I've build tested and booted/run some read/write tests with
> your patch which worked fine for me too.
>
> Reviewed-by: Phillip Potter <phil@philpotter.co.uk>
>
> One final question from me though, and a purely procedural one:
> The patch was submitted from your gmail address, but signed off by your
> corporate address. Are you happy for me to adjust the submission so that
> the author appears as your corporate address when sending on for
> inclusion? Let me know, thanks.
>
> Regards,
> Phil
