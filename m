Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B8AC35DF8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 06:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D08620CC7
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 06:53:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QSWYzPYT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgBYGx0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Feb 2020 01:53:26 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44418 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729073AbgBYGxZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Feb 2020 01:53:25 -0500
Received: by mail-oi1-f195.google.com with SMTP id d62so11550814oia.11
        for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2020 22:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fSxteq8BvR6bLu5LA6jd2BwkLJks1DyRranxnHnzEYU=;
        b=QSWYzPYTbGtdSQcLlCKj5AEGOQ+3AMV+xZg0/U1875q3JKfM5DYKKf5p6HAK6CwjIP
         AOzaHHJjmake0476dUff+71jZhuvNc745oA0rLIGZ2I2H4J5IKOXbhyQXmahB1wqF2Iv
         U7eNIah3q24sEOYyMKrA6vRUfjNnXNBHWLXsY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fSxteq8BvR6bLu5LA6jd2BwkLJks1DyRranxnHnzEYU=;
        b=eKOZR65C1nXGJKTWUs2jGACM+3YDwKQfQGo0f8eMxg4iY2eJjhSVhzL1Ciig83csGf
         0W1VQyPgThL0gK0zOTURKJr6rCQZzYn2MEHlGLqhyTZeHa+RSIxk2vfPRzJx5UGrWp0g
         HimHOQtOE96hNzPW/K/cizCYaNLgTHa7YNSPgHj48AwXqugvcyOEEyQiaw7p/Ylbg6nM
         AKm1RNX6pwQT/AuFxIDhWSJrs4N8ZAmhVQduk4VB6rB6g+C+ACO2J1WvtLbIw/Ulj56A
         fUzYB3lYG1rBWRN6ogjGYE5EnxkLbZ6rs34/rJFc7wJdZV0LccDGR+I/QXDbqSbKFpQT
         2BCA==
X-Gm-Message-State: APjAAAUXa7UZReoqT1pt7sy9lYXA2pWnKk9P7xvcpLn/6shmvqE2QsEm
        zt0StttCGdCGZQjDa5bB6EzNyhs5WPfVPtzS65rRyA==
X-Google-Smtp-Source: APXvYqzA/xFMqccjb+BVRQhIHMzDqHfwlaweZ5oYatBKG1/zxpMzG0KS3wxN/jHbU7SS9W3Ga5Oz56oRA9wsAEb0Dk0=
X-Received: by 2002:aca:f587:: with SMTP id t129mr2226747oih.143.1582613605142;
 Mon, 24 Feb 2020 22:53:25 -0800 (PST)
MIME-Version: 1.0
References: <1578489498.29952.11.camel@abdul> <1578560245.30409.0.camel@abdul.in.ibm.com>
 <20200109142218.GA16477@infradead.org> <1578980874.11996.3.camel@abdul.in.ibm.com>
 <20200116174443.GA30158@infradead.org> <1579265473.17382.5.camel@abdul> <1582611644.19645.6.camel@abdul.in.ibm.com>
In-Reply-To: <1582611644.19645.6.camel@abdul.in.ibm.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Tue, 25 Feb 2020 12:23:13 +0530
Message-ID: <CAK=zhgpWCz0+xpSGymbQEAbysH_rQf=s8iQ1gn4KwysP3c1Gcw@mail.gmail.com>
Subject: Re: [linux-next/mainline][bisected 3acac06][ppc] Oops when unloading
 mpt3sas driver
To:     Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        sachinp <sachinp@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, jcmvbkbc@gmail.com,
        linux-next <linux-next@vger.kernel.org>,
        Oliver <oohall@gmail.com>,
        "aneesh.kumar" <aneesh.kumar@linux.vnet.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        manvanth <manvanth@linux.vnet.ibm.com>,
        iommu@lists.linux-foundation.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 25, 2020 at 11:51 AM Abdul Haleem
<abdhalee@linux.vnet.ibm.com> wrote:
>
> On Fri, 2020-01-17 at 18:21 +0530, Abdul Haleem wrote:
> > On Thu, 2020-01-16 at 09:44 -0800, Christoph Hellwig wrote:
> > > Hi Abdul,
> > >
> > > I think the problem is that mpt3sas has some convoluted logic to do
> > > some DMA allocations with a 32-bit coherent mask, and then switches
> > > to a 63 or 64 bit mask, which is not supported by the DMA API.
> > >
> > > Can you try the patch below?
> >
> > Thank you Christoph, with the given patch applied the bug is not seen.
> >
> > rmmod of mpt3sas driver is successful, no kernel Oops
> >
> > Reported-and-tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
>
> Hi Christoph,
>
> I see the patch is under discussion, will this be merged upstream any
> time soon ? as boot is broken on our machines with out your patch.
>

Hi Abdul,

We have posted a new set of patches to fix this issue. This patch set
won't change the DMA Mask on the fly and also won't hardcode the DMA
mask to 32 bit.

[PATCH 0/5] mpt3sas: Fix changing coherent mask after allocation.

This patchset will have below patches, Please review and try with this
patch set.

Suganath Prabu S (5):
  mpt3sas: Don't change the dma coherent mask after      allocations
  mpt3sas: Rename function name is_MSB_are_same
  mpt3sas: Code Refactoring.
  mpt3sas: Handle RDPQ DMA allocation in same 4g region
  mpt3sas: Update version to 33.101.00.00

Regards,
Sreekanth

> --
> Regard's
>
> Abdul Haleem
> IBM Linux Technology Centre
>
>
>
