Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B04EE4997
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 20:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240448AbjHRUsQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 16:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244381AbjHRUrx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 16:47:53 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C017273C
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2023 13:47:52 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1bdc243d62bso10353965ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2023 13:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692391671; x=1692996471;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h8bmW2KCgpvkZ7Hk4b8f0neVrARYqRfK1zzHVJtSN4o=;
        b=UB98qiPYoYbTC8hTTkNPV/LQ5lUkjlTQ//OwVFrlo+GcKj6nbVsp6/DN01h+dgthIq
         yJW/LViat8t9VHIBN/QSbajltyl3GyXZC4IgEjpHcQeOlZ5ROQfxtUPYHdUoBdw8DZ93
         RE5rQNbSFmrRqh9sYXM0IzmHU7b6QpwYiMr3IsGRA/vAEEpHZZv1CMWoHMrNAF2xtV9h
         cX0A4n+Pa68ftdJ6l8V6dHsSxkchITds8js7ik5VNNmUEHAWFSevunI8VTfgVo5o6sFg
         NRkPHUyrF/YoZWfKHLfaQn1wevGHRUclPd1BNoo1kBVX68VBIywfhIaLBkscZp/yuyAQ
         kGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692391671; x=1692996471;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h8bmW2KCgpvkZ7Hk4b8f0neVrARYqRfK1zzHVJtSN4o=;
        b=KuqFyhDGCKtT7EaCd3VuUNVFlccxDpmpWIoKr60JD59swk9FleorgWQCk+nAPOLodU
         OE5AmGW2VfdW3WCgQ3D5HP6luGkjPNE81PBYJw8rInmWg1sKUDzMiaAG0CvCB+yZBlVB
         fpt+aGnFxIfrhhe5ZQJYDvogKElYB8ay1xRZwiOhuWvaPAEX19qy7GOFwnEgvMYfr9qK
         /qZgauWlz6xvWahgBENRb5lHTOaUusysHCbUCE7vUJC4sst28gk2MG1EzNRDB/6laR7x
         F3uAj+9pOt3rfh+iplj9jZZK3XcbGFyb7zsX1RQRjRm2/HbfPdsm3nmXwOXkItzROvGa
         xqjw==
X-Gm-Message-State: AOJu0Yz0JWXAHq6Io1BuWrWqBvuVZvMOEr2Z7qCasagrmJ2hynFaxRAv
        /ScMMv8eBlehjTThNj8R6Gesbdmpv8COtsb3aEoDELk1
X-Google-Smtp-Source: AGHT+IE20JKanKHoTmF0G8MovHaQTIIr8DT2OEtOzuQPcz039uI6QI9nrKlH8l5TbZCDVAOF7vjOgA==
X-Received: by 2002:a17:902:ac8e:b0:1bb:79b4:d45e with SMTP id h14-20020a170902ac8e00b001bb79b4d45emr306932plr.69.1692391671456;
        Fri, 18 Aug 2023 13:47:51 -0700 (PDT)
Received: from google.com ([2620:15c:2c5:13:4f6e:2bd9:cb46:7849])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902bd4b00b001b80d411e5bsm2154347plx.253.2023.08.18.13.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 13:47:50 -0700 (PDT)
Date:   Fri, 18 Aug 2023 13:47:46 -0700
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 1/3] ata: libata: Introduce ata_qc_has_cdl()
Message-ID: <ZN/Y8nkC1HVjJbQ4@google.com>
References: <20230817214137.462044-1-ipylypiv@google.com>
 <f0de3678-ab9f-1e0d-029e-f5859e82160f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0de3678-ab9f-1e0d-029e-f5859e82160f@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 18, 2023 at 08:11:39AM +0900, Damien Le Moal wrote:
> On 2023/08/18 6:41, Igor Pylypiv wrote:
> > Introduce the inline helper function ata_qc_has_cdl() to test if
> > a queued command has a Command Duration Limits descriptor set.
> > 
> > Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> > ---
> >  include/linux/libata.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/include/linux/libata.h b/include/linux/libata.h
> > index 820f7a3a2749..bc7870f1f527 100644
> > --- a/include/linux/libata.h
> > +++ b/include/linux/libata.h
> > @@ -1062,6 +1062,11 @@ static inline bool ata_port_is_frozen(const struct ata_port *ap)
> >  	return ap->pflags & ATA_PFLAG_FROZEN;
> >  }
> >  
> > +static inline bool ata_qc_has_cdl(struct ata_queued_cmd *qc)
> > +{
> > +	return qc->flags & ATA_QCFLAG_HAS_CDL;
> > +}
> 
> This is used in one place only in patch 3, and the only other place we test this
> flag is in ata_build_rw_tf(). So I do not think this is necessary. Let's drop this.

Thanks Damien! I'll drop this patch in v2.
As discussed in PATCH 2/3 we'll check for ATA_QCFLAG_RESULT_TF instead.

> 
> > +
> >  extern int ata_std_prereset(struct ata_link *link, unsigned long deadline);
> >  extern int ata_wait_after_reset(struct ata_link *link, unsigned long deadline,
> >  				int (*check_ready)(struct ata_link *link));
> 
> -- 
> Damien Le Moal
> Western Digital Research
>

Thanks,
Igor
