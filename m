Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.0 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A111C07E99
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 16:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6231461450
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 16:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhGHQsr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jul 2021 12:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhGHQsr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2021 12:48:47 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEDFC061574
        for <linux-scsi@vger.kernel.org>; Thu,  8 Jul 2021 09:46:04 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id r135so10055951ybc.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Jul 2021 09:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C8aJuBtMFzTRHA7lVP8ggKa6+OtDRqlwkTJ4zp7YVbA=;
        b=m2cxjbPU1NSMTUyOORYLxJ0yJPmYYSMS6OxzDvZTtFbsnMH+Ot23bNJpv/3h/PvsAQ
         wuwOcPYtcx6bb3PqzxripTgjY7O8QhK6TnU4eirzRoxxY9lkHe9/yd7KWl8PkzQz4bg1
         WyDnUViuKF6FwO293DmW0zD8F2DYITDltL2xKkvQ7lNXVnP3u8sYNKCEp2/32TqTsKdb
         K6yPK3jse7H4m6YIYrN/UQk8SN8WuncPaGo+YjCoRqzPcDReF1P19QMIngBA0daWQgBp
         LhXNeajwwiA8v21pGlYcMVWqSVLUjINqCp5UndIBta85cMU7iLxVbyfw6CQIfAX8owma
         hISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C8aJuBtMFzTRHA7lVP8ggKa6+OtDRqlwkTJ4zp7YVbA=;
        b=Y+cbcGws/znV8O3WkZf4Hslk9qGpsG3+X/aFlYoTETDP7yDFen6lAD6swT+7yJwBJO
         lMFyiYLxs0DBeUu13t1fMzUrA1eu/i/ism6rdZS8uqgbZXXKyaVm2+fBuxFCDFWXqeDg
         w4wYXoH+3niDOOEz4cQoarf22XZS6uNHJTXr203SiOFv8Vf2iKwJBbpZQtRUuFdT9kvE
         GBHcLV1UzMZdNcLMG2hAZXd8M+RGdegGve+fDXu9ktMlgY55luFZKYsL1DVnEY6IWpyR
         N+K0SpUzwC+rn4vLdcu+R68KdNqMypIqhYXpiutuqAix/FmWfGvj/CcttuhhQn/RIRc5
         AacA==
X-Gm-Message-State: AOAM532gAgrrP82c7BJ0khuETB5CHH6gEH1AJQ5yX/6iOLJk1vr5T5TG
        97AyX6aW6pZlB6siEEk4XgMuUk65Mg8l0YCKuYZA9Q==
X-Google-Smtp-Source: ABdhPJwB3mFvuPjBuouBnVJ2WKh37PWsmDCUs7owmMr3YwI4DjL6FalRU/lXkkhreClSaM5YzUR6kZbEGVtXz4mx4b8=
X-Received: by 2002:a25:b3c8:: with SMTP id x8mr41042585ybf.466.1625762763268;
 Thu, 08 Jul 2021 09:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210707172948.1025-1-adrian.hunter@intel.com>
 <20210707172948.1025-3-adrian.hunter@intel.com> <YOXm4FuL/CW4lYDZ@kroah.com>
 <66130101-b0c5-a9a3-318a-468c6f3b380f@intel.com> <CAJZ5v0hfEE=ney1tH5MtQm0KWs4U2yzy_DqAAW7hTyxxx2-cNg@mail.gmail.com>
 <c3ec3ca2-220f-9e5a-e2ce-b1c2be86c97c@intel.com>
In-Reply-To: <c3ec3ca2-220f-9e5a-e2ce-b1c2be86c97c@intel.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 8 Jul 2021 09:45:27 -0700
Message-ID: <CAGETcx_D9KvxEK689ggF6xViiC_yXaCWdL0KoW8uJwiNPhxy8w@mail.gmail.com>
Subject: Re: [PATCH RFC 2/2] scsi: ufshcd: Fix device links when BOOT WLUN
 fails to probe
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 8, 2021 at 7:17 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> On 8/07/21 3:31 pm, Rafael J. Wysocki wrote:
> > On Wed, Jul 7, 2021 at 7:49 PM Adrian Hunter <adrian.hunter@intel.com> wrote:
> >>
> >> On 7/07/21 8:39 pm, Greg Kroah-Hartman wrote:
> >>> On Wed, Jul 07, 2021 at 08:29:48PM +0300, Adrian Hunter wrote:
> >>>> If a LUN fails to probe (e.g. absent BOOT WLUN), the device will not have
> >>>> been registered but can still have a device link holding a reference to the
> >>>> device. The unwanted device link will prevent runtime suspend indefinitely,
> >>>> and cause some warnings if the supplier is ever deleted (e.g. by unbinding
> >>>> the UFS host controller). Fix by explicitly deleting the device link when
> >>>> SCSI destroys the SCSI device.
> >>>>
> >>>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> >>>> ---
> >>>>  drivers/scsi/ufs/ufshcd.c | 7 +++++++
> >>>>  1 file changed, 7 insertions(+)
> >>>>
> >>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> >>>> index 708b3b62fc4d..483aa74fe2c8 100644
> >>>> --- a/drivers/scsi/ufs/ufshcd.c
> >>>> +++ b/drivers/scsi/ufs/ufshcd.c
> >>>> @@ -5029,6 +5029,13 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
> >>>>              spin_lock_irqsave(hba->host->host_lock, flags);
> >>>>              hba->sdev_ufs_device = NULL;
> >>>>              spin_unlock_irqrestore(hba->host->host_lock, flags);
> >>>> +    } else {
> >>>> +            /*
> >>>> +             * If a LUN fails to probe (e.g. absent BOOT WLUN), the device
> >>>> +             * will not have been registered but can still have a device
> >>>> +             * link holding a reference to the device.
> >>>> +             */
> >>>> +            device_links_scrap(&sdev->sdev_gendev);
> >>>
> >>> What created that link?  And why did it do that before probe happened
> >>> successfully?
> >>
> >> The same driver created the link.
> >>
> >> The documentation seems to say it is allowed to, if it is the consumer.
> >> From Documentation/driver-api/device_link.rst
> >>
> >>   Usage
> >>   =====
> >>
> >>   The earliest point in time when device links can be added is after
> >>   :c:func:`device_add()` has been called for the supplier and
> >>   :c:func:`device_initialize()` has been called for the consumer.
> >
> > Yes, this is allowed, but if you've added device links to a device
> > object that is not going to be registered after all, you are
> > responsible for doing the cleanup.
> >
> > Why can't you call device_link_del() directly on those links?
> >
> > Or device_link_remove() if you don't want to deal with link pointers?
> >
>
> Those only work for DL_FLAG_STATELESS device links, but we use only
> DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE flags.

Is there a reason you can't use DL_FLAG_STATELESS? It doesn't preclude
you from using RPM_ACTIVE as far as I can tell.

-Saravana


-Saravana
