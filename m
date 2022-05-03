Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6EF5C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 00:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiECATY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 20:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiECATV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 20:19:21 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F486344F6
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 17:15:50 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id a11so13531049pff.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 May 2022 17:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uSPqb+z89QQ2S36jFP59MxksXJ0KM6ez8eSZnSI+ei8=;
        b=H1GAb0tM6sUMCSiHhAYwhyJ5SqzXF7WZrlpc+UoVr9GNIGBKr+byg6jVgpCKVp+Rl+
         9c1k7mjHiG/MUC0OVgwNxxfq+vpils7Q79r6Pb2VwF8flmhgQgzde0eprj1iKjZPaAl2
         ck3w6vlVwrRO8kK1cxi1kCPotE+POYjdC0rNzzR3MvqdO3XVzJGas+EraS4ZYAXlG9I2
         y5uhbY7iYPiVVMuOWN7q2FZiUg6ON4DhWtV8VS/u0DuCt9EYjpGFGSlVebP/cD0GP3wn
         b8Z2oXt+bBI24QIK82XaUsqWOWI+CPrVWyBZNhQQoQM+ALpbUwTlPQQqLRfD5mlmOa/a
         HQHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uSPqb+z89QQ2S36jFP59MxksXJ0KM6ez8eSZnSI+ei8=;
        b=u14iVOf4TZpXKUnPqXdV9yqEhZ9K64xRwVh1b8g1enR7OKcSy/O8E1qOWUp0fCPJe1
         zwI3uwrBKQZ3y9mOFIvF5WHuNo8mSz7ejZEmAA/qjmxMlXeQNc4ivWwE9E297Mr8yt6K
         sqnpTaW9mxJuv878WMCsA7czUlniaxhRSB+g5YE+g1LQAJR6qRM3LnJ4m7zHJwGnwEc3
         Xz7DwxY3/4LxQLQQKBA8eoRT7+riJwkLIRLSu+p26ZzGr51qk6YU9BxGESOHtjhWxdek
         kdLNdH6oxAgm8SD1ALE/jRgDkJDlgtEW7/fp/UoqHNUjPkTlWc6kMIe8iTKZBRIXlU0e
         Jh0g==
X-Gm-Message-State: AOAM5306rOTE6In4XpBn9n3Xua4D5OKrMgv5ohQJtiEpWfLnIRY3gMS7
        r5Uf5MX92tvXhBgCy7tO24FYoQ==
X-Google-Smtp-Source: ABdhPJy7JNuOUsAEyFdbfrltm/33RcFMupJCS91zJEmcTCtVrbretmo2xPaN8nxWkXj2q93Mq7b4Eg==
X-Received: by 2002:a63:6d0c:0:b0:3c1:7361:b25b with SMTP id i12-20020a636d0c000000b003c17361b25bmr11696958pgc.449.1651536949069;
        Mon, 02 May 2022 17:15:49 -0700 (PDT)
Received: from google.com ([2620:15c:2c5:11:bb0:cf90:6ae6:c153])
        by smtp.gmail.com with ESMTPSA id w13-20020aa7858d000000b0050dc762814bsm5258223pfn.37.2022.05.02.17.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 17:15:48 -0700 (PDT)
Date:   Mon, 2 May 2022 17:15:43 -0700
From:   Igor Pylypiv <ipylypiv@google.com>
To:     John Garry <john.garry@huawei.com>, Ajish.Koshy@microchip.com
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jolly Shah <jollys@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org, Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH] scsi: pm80xx: Remove pm8001_tag_init()
Message-ID: <YnB0L+eoMM9RKzyi@google.com>
References: <20220428000326.3622230-1-ipylypiv@google.com>
 <0cb8d2e1-b2b3-04ac-9151-9b211d893cfd@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cb8d2e1-b2b3-04ac-9151-9b211d893cfd@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 29, 2022 at 10:06:06AM +0100, John Garry wrote:
> On 28/04/2022 01:03, Igor Pylypiv wrote:
> > In commit 5a141315ed7c ("scsi: pm80xx: Increase the number of outstanding
> > I/O supported to 1024") the pm8001_ha->tags allocation was moved into
> > pm8001_init_ccb_tag(). This changed the execution order of allocation.
> > pm8001_tag_init() used to be called after the pm8001_ha->tags allocation
> > and now it is called before the allocation.
> > 
> > Before:
> > 
> > pm8001_pci_probe()
> > `--> pm8001_pci_alloc()
> >       `--> pm8001_alloc()
> >            `--> pm8001_ha->tags = kzalloc(...)
> >            `--> pm8001_tag_init(pm8001_ha); // OK: tags are allocated
> > 
> > After:
> > 
> > pm8001_pci_probe()
> > `--> pm8001_pci_alloc()
> > |    `--> pm8001_alloc()
> > |         `--> pm8001_tag_init(pm8001_ha); // NOK: tags are not allocated
> > |
> > `--> pm8001_init_ccb_tag()
> >       `-->  pm8001_ha->tags = kzalloc(...) // today it is bitmap_zalloc()
> > 
> > Since pm8001_ha->tags_num is zero when pm8001_tag_init() is called it does
> > nothing. Tags memory is allocated with bitmap_zalloc() so there is no need
> > to manually clear each bit with pm8001_tag_free().
> 
> Your change looks ok. But please note the following discussed in the
> following link, there was/is a bug in the lateness in which the tags are
> allocated:
> 
> https://lore.kernel.org/linux-scsi/PH0PR11MB5112D8C17D9EA268C197893FEC579@PH0PR11MB5112.namprd11.prod.outlook.com/

Thanks for pointing out the discussion, John. My patch should still
apply because clearing bits is redundant for memory allocated with
bitmap_zalloc().

> 
> I don't think that it has been fixed yet...

Adding Ajish to comment on the patch readiness for the tags allocation
lateness issue.

Thanks,
Igor

> 
> Thanks,
> John
> 
> > 
> > Fixes: 5a141315ed7c ("scsi: pm80xx: Increase the number of outstanding
> > I/O supported to 1024")
> > Reviewed-by: Changyuan Lyu <changyuanl@google.com>
> > Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> > ---
> >   drivers/scsi/pm8001/pm8001_init.c | 2 --
> >   drivers/scsi/pm8001/pm8001_sas.c  | 7 -------
> >   drivers/scsi/pm8001/pm8001_sas.h  | 1 -
> >   3 files changed, 10 deletions(-)
> > 
> > diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> > index 9b04f1a6a67d..7040cecd861b 100644
> > --- a/drivers/scsi/pm8001/pm8001_init.c
> > +++ b/drivers/scsi/pm8001/pm8001_init.c
> > @@ -420,8 +420,6 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
> >   		atomic_set(&pm8001_ha->devices[i].running_req, 0);
> >   	}
> >   	pm8001_ha->flags = PM8001F_INIT_TIME;
> > -	/* Initialize tags */
> > -	pm8001_tag_init(pm8001_ha);
> >   	return 0;
> >   err_out_nodev:
> > diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> > index 3a863d776724..dc689055341b 100644
> > --- a/drivers/scsi/pm8001/pm8001_sas.c
> > +++ b/drivers/scsi/pm8001/pm8001_sas.c
> > @@ -92,13 +92,6 @@ int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out)
> >   	return 0;
> >   }
> > -void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha)
> > -{
> > -	int i;
> > -	for (i = 0; i < pm8001_ha->tags_num; ++i)
> > -		pm8001_tag_free(pm8001_ha, i);
> > -}
> > -
> >   /**
> >    * pm8001_mem_alloc - allocate memory for pm8001.
> >    * @pdev: pci device.
> > diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> > index 060ab680a7ed..ba959f986c1e 100644
> > --- a/drivers/scsi/pm8001/pm8001_sas.h
> > +++ b/drivers/scsi/pm8001/pm8001_sas.h
> > @@ -633,7 +633,6 @@ extern struct workqueue_struct *pm8001_wq;
> >   /******************** function prototype *********************/
> >   int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out);
> > -void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha);
> >   u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag);
> >   void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
> >   			  struct pm8001_ccb_info *ccb);
> 
