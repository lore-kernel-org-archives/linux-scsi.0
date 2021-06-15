Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50458C49EA2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 17:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36CCE610A3
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 17:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhFORNq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 13:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhFORNp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2021 13:13:45 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77668C061574;
        Tue, 15 Jun 2021 10:11:39 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id v6so11796599qta.9;
        Tue, 15 Jun 2021 10:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=CL0lPV57QQHAIoWqPYdz9D7HX33G5wLB3yUQQff9WgA=;
        b=EhgLWtbsLi5myM7N6WT7QIQ8Lr3UIMJgrryRXwjPULCxmVSm54tBdbZvhRcZqD8q/t
         vALCfWUHDIrihBZkCtyCihFWQ3K1glynJRiZ9T728HE4lne9+v9Bc6pE0ZcyLj/fTpHB
         Z8amHIA8JQCYN8TJpjMS8SYI2p78vlwRbpUH1Fw4Py0dsVctnysgeok9+ae+mMQweHG3
         QX3RGjhN76udUHYVVNQlUf+bRFPBwdWcQBLs3+FH6jHsMxiuowBXgJQcfms/MNrCRxQV
         lxb1ey0DUolGC6hK318lx3EnmhT2hYdhZsijDuvnSDyoO9iDhhgN9k18fnXJf/jzoWMA
         SBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=CL0lPV57QQHAIoWqPYdz9D7HX33G5wLB3yUQQff9WgA=;
        b=O08sV53BKFhMWrTHgWTKD8FglvAPYaMf5jt03AknYmu+pAI6gJizVkPIezvzohp5eI
         5p56OclvdFybv4/5x5vZD5x3ptFUyWUf+djSDS5y4OY29qhz/dYCwvR3UqFBYFEr3p2+
         14/L2jQvyjbZPCJzj/i9Y3gBwaQxOMzn9XoIseYokt5oQkh2PjztXAX6bGG4DlwR/k2T
         Wig5Ri4Jds9ZZw0kDx1YVIi8RSPkiEoFqlTfxe+AzAZ0FEHEJESXO/62jVuuQdNsNmYK
         KTxdH5vxtFjvQPij/LHzGNwmPFd2i6KVSlK3kBmHM/gSLjVSCJE2QtXb1TGdioaoY5w0
         Fdsg==
X-Gm-Message-State: AOAM530fWq92ChmO5uemqCSvZZhQUNUTrRWmn32s05LFZj+Mr3zfe5tg
        4ZQAkjGISA8csbdF8aoNJ2w=
X-Google-Smtp-Source: ABdhPJxayfWzxz+qB4dToDDc+nMn15PJJw+LBedHSGIvCcEQmO+DY2E1QRIgLKljXIPFOl3lTC9Lag==
X-Received: by 2002:ac8:7950:: with SMTP id r16mr609893qtt.137.1623777098552;
        Tue, 15 Jun 2021 10:11:38 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id s69sm10922199qke.115.2021.06.15.10.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 10:11:37 -0700 (PDT)
Sender: Mike Snitzer <snitzer@gmail.com>
Date:   Tue, 15 Jun 2021 13:11:37 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Martin Wilck <mwilck@suse.com>
Cc:     Alasdair G Kergon <agk@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        dm-devel@redhat.com, Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/2]  dm: dm_blk_ioctl(): implement failover for SG_IO
 on dm-multipath
Message-ID: <YMjfSVASeTE0Sy9H@redhat.com>
References: <20210611202509.5426-1-mwilck@suse.com>
 <YMdyh62mR/lEifMR@redhat.com>
 <44fc94278e0c4b15a611a6887c668f41c262e001.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44fc94278e0c4b15a611a6887c668f41c262e001.camel@suse.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 15 2021 at  6:54P -0400,
Martin Wilck <mwilck@suse.com> wrote:

> Hi Mike,
> 
> On Mo, 2021-06-14 at 11:15 -0400, Mike Snitzer wrote:
> > 
> > This work offers a proof-of-concept but it needs further refinement
> > for sure.
> 
> Thanks for looking into it again. I need some more guidance from your
> part in order to be able to resubmit the set in a form that you
> consider ready for merging.
> 
> > The proposed open-coded SCSI code (in patch 2's drivers/md/dm-
> > scsi_ioctl.c) 
> > is well beyond what I'm willing to take in DM.
> 
> I'm not sure what code you're referring to. Is it the processing of the
> bytes of the SCSI result code? If yes, please note that I had changed
> that to open-coded form in response to Bart's review of my v2
> submission. If it's something else, please point it out to me.
> 
> To minimize the special-casing for this code path, Hannes suggested to
> use a target-specific unprepare_ioctl() callback to to tell the generic
> dm code whether a given ioctl could be retried. The logic that I've put
> into dm-scsi_ioctl.c could then be moved into the unprepare_ioctl()
> callback of dm-mpath. dm_blk_ioctl() would need to check the callback's
> return value and possibly retry the ioctl. Would hat appeal to you?
> 
> >   If this type of
> > functionality is still needed (for kvm's SCSI passthru snafu) then
> > more work is needed to negotiate proper interfaces with the SCSI
> > subsystem (added linux-scsi to cc, odd they weren't engaged on this).
> 
> Not cc'ing linux-scsi was my oversight, sorry about that. 
> 
> But I don't quite understand what interfaces you have in mind. SCSI
> needs to expose the SG_IO interface to dm, which it does; I just needed
> to export sg_io() to get access to the sg_io_hdr fields. The question
> whether a given IO can be retried is decided on the dm (-mpath) layer,
> based on blk_status_t; no additional interface on the SCSI side is
> necessary for that.
> 
> > Does it make sense to extend the SCSI device handler interface to add
> > the required enablement? (I think it'd have to if this line of work
> > is
> > to ultimately get upstream).
> 
> My current code uses the device handler indirectly for activating paths
> during priority group switching, via the dm-mpath prepare_ioctl()
> method and __pg_init_all_paths(). This is what I intended - to use
> exactly the same logic for SG_IO which is used for regular read/write
> IO on the block device. What additional functionality for the device
> handler do you have in mind?
> 
> Regards and thanks,
> Martin

I just replied to patch 2 with detailed suggestions.

Thanks,
Mike
