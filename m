Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E3CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 08:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69C6320738
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 08:13:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DLNnplMZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390329AbgFXINg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 04:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390322AbgFXINf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 04:13:35 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7EBC061573
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2020 01:13:35 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id l6so1070228qkc.6
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2020 01:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YiwAw5rf1diC6i54PRBuyM8/xbCVl7h6LSmw94lDr8M=;
        b=DLNnplMZTclq3Qu41yzxfjHqZxOrk1DU+y+luEo+7KmlVHvLHuvdtKEvab9Yn8iIf9
         h7k2rv2GRt+e0qBArwvSGj9sTnX37oqP7KFHi1MJAFHqrF3q7NMt62BE+LPptI0PU3yz
         47Gd6tdJZ/LyEtctL/O7p0BQ/cqnmm4TQB1Xs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=YiwAw5rf1diC6i54PRBuyM8/xbCVl7h6LSmw94lDr8M=;
        b=dlRn0CY8/ZJEYuxzfgPLpqNkj/UStQcdvfU4FA/N0NoIX93VUG9aBfRhS8aVBDD0W3
         R6/EOPolaJexddKgVU5bLqKPEqbn0v41djq6iyIYVT8QBt/YGdMVK9gmZaEFs9GjUXOo
         5DqTQWfJHw3yiL2WTmeel/jUYLI/yfFsoOHHlBdgQ7DuGK84fF081wsjanKJoRrCzoh+
         1o9qPQ1pIpMgRRV3OaM/2XBbnkdxBPl/bqmzbjOk/SrF03HpSx5EvMSvAqnCIR8La+EO
         U6tDfWgefuYvPpZR1PDFOjl6Ga74i9GZ9JnuTLJzT6CE9HnlhWBKzABOa4zI0tusOVQv
         TXbw==
X-Gm-Message-State: AOAM531THXFAfsGsFnt2PKE9YNC/nTsCth+R+1cS8P+4Ssh0iYAQTB5M
        9HCPVpiXX0ONsLC30xhzG+uLlMi2YRHN2UumYGl+QA==
X-Google-Smtp-Source: ABdhPJxkQXodkQPbyTvdNGDhaEwudHE8iAT5slMQ6pIZ5w/cSLJ1YyE1BC7yCMb/u68Ecxgl2kE45xoOkKLgQB+5NU4=
X-Received: by 2002:a37:494c:: with SMTP id w73mr22819291qka.27.1592986414110;
 Wed, 24 Jun 2020 01:13:34 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-3-git-send-email-john.garry@huawei.com>
 <20200611025759.GA453671@T590> <6ef76cdf-2fb3-0ce8-5b5a-0d7af0145901@huawei.com>
 <8ef58912-d480-a7e1-f04c-da9bd85ea0ae@huawei.com> <eaf188d5-dac0-da44-1c83-31ff2860d8fa@suse.de>
In-Reply-To: <eaf188d5-dac0-da44-1c83-31ff2860d8fa@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQBVjmvxAE7FMYb7GtMRWGcwtMcECgJRJzAeAmYD0J0CUmtFnQMQPP3WAliipVSrhUrmoA==
Date:   Wed, 24 Jun 2020 13:43:32 +0530
Message-ID: <e42da0e714c808c80e9a055f3f065e44@mail.gmail.com>
Subject: RE: [PATCH RFC v7 02/12] blk-mq: rename blk_mq_update_tag_set_depth()
To:     Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>
> On 6/23/20 1:25 PM, John Garry wrote:
> > On 11/06/2020 09:26, John Garry wrote:
> >> On 11/06/2020 03:57, Ming Lei wrote:
> >>> On Thu, Jun 11, 2020 at 01:29:09AM +0800, John Garry wrote:
> >>>> From: Hannes Reinecke <hare@suse.de>
> >>>>
> >>>> The function does not set the depth, but rather transitions from
> >>>> shared to non-shared queues and vice versa.
> >>>> So rename it to blk_mq_update_tag_set_shared() to better reflect
> >>>> its purpose.
> >>>
> >>> It is fine to rename it for me, however:
> >>>
> >>> This patch claims to rename blk_mq_update_tag_set_shared(), but also
> >>> change blk_mq_init_bitmap_tags's signature.
> >>
> >> I was going to update the commit message here, but forgot again...
> >>
> >>>
> >>> So suggest to split this patch into two or add comment log on
> >>> changing blk_mq_init_bitmap_tags().
> >>
> >> I think I'll just split into 2x commits.
> >
> > Hi Hannes,
> >
> > Do you have any issue with splitting the undocumented changes into
> > another patch as so:
> >
> No, that's perfectly fine.
>
> Kashyap, I've also attached an updated patch for the elevator_count patch=
;
> if
> you agree John can include it in the next version.

Hannes - Patch looks good.   Header does not include problem statement. How
about adding below in header ?

High CPU utilization on "native_queued_spin_lock_slowpath" due to lock
contention is possible in mq-deadline and bfq io scheduler when nr_hw_queue=
s
is more than one.
It is because kblockd work queue can submit IO from all online CPUs (throug=
h
blk_mq_run_hw_queues) even though only one hctx has pending commands.
Elevator callback "has_work" for mq-deadline and bfq scheduler consider
pending work if there are any IOs on request queue and it does not account
hctx context.

I have not seen performance drop after this patch, but I will continue
further testing.

John - One more thing, I am working on megaraid_sas driver to provide both
host_tagset =3D 1 and 0 option through module parameter.

Kashyap

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke            Teamlead Storage & Networking
> hare@suse.de                               +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg HRB 3680=
9
> (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer
