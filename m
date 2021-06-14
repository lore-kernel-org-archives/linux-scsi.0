Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79924C4743C
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 15:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D55F6124B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 15:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhFNPSY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 11:18:24 -0400
Received: from mail-qv1-f43.google.com ([209.85.219.43]:44778 "EHLO
        mail-qv1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbhFNPSY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 11:18:24 -0400
Received: by mail-qv1-f43.google.com with SMTP id w4so13155527qvr.11;
        Mon, 14 Jun 2021 08:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZGk/FA6XxJotBQ1URjiWbasLNGa5cJUSnfXjO2+742k=;
        b=BvG3N2hWKfrbgmuKiiDk7L2rr3e8aWfowRKTO1haLAduE0GZMA2D87fOWLcnf0ipqE
         NgC8s+fLo0CFjLmvHBHSrVoasepVt30b2hW54PXIIiCYk7uAVxp1C1PLwIUebSnRi0WY
         F2ysUqAgq/TnDy0fKk8Xsj7FcOxDAdZBzOVJKsQqbzjk9VuewA86Kcxh3zIVJDxMr5Hc
         SgqgzZ4ryo7wETctpy35AS8j5YR5KHioAGxncsgxCRdgsVsrMR1GTCd6pvtG3o825AC2
         CwyS5OEhYUOB78j4Jga/6CY91YsMQCUerVqCu/O0qjr7PCqYISjoHCg51Q/fyZwse8Ge
         sI/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ZGk/FA6XxJotBQ1URjiWbasLNGa5cJUSnfXjO2+742k=;
        b=HLyp/+eppAyKQaz/LtiqCw0ozEqkTbhXdpURy34Q+OBz+8X/F/epRRlf5l5hyKt28r
         4r9AtuA7Ua8x/iPe0JMr2ITiWoHC/FjGRjoxk+U1MjrDFVsLeIF1ui2gU5CCiPhRnD35
         ydSiuul+sll0em91Pr9msoyGOqlzT0uhfp7CRcoC3fm9kKn7YkV1Aq4xgrBrvVo5p7zV
         PCyUx8eKlcgxuQHAS33sm8Hnmy3btyESHfFQbLRVmsltnP0V/4iFRjmWhzwaUgu74zHP
         r3EBhhmKu2azMPu9aUkuhuFRgta3f7Pg6X5UIVQ+dtgLaCCBjDW6pgmI0F6WgcOQpMMI
         W5JQ==
X-Gm-Message-State: AOAM531vNzefqS6UbhUA5VNimH7udwYS6js6uwdAhqNUTSqAQg3HHTSE
        uwPcV4WgST3dMXNRE+qUp6U=
X-Google-Smtp-Source: ABdhPJyAqNDr60raHRfjT+q3Sts7H3aWjsFFkX73RBcG/iIK+h5Cc6F9UIoka2tDB7DvrS5FNqdIhg==
X-Received: by 2002:ad4:4146:: with SMTP id z6mr16633948qvp.36.1623683721047;
        Mon, 14 Jun 2021 08:15:21 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id h5sm10542086qkg.122.2021.06.14.08.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 08:15:20 -0700 (PDT)
Sender: Mike Snitzer <snitzer@gmail.com>
Date:   Mon, 14 Jun 2021 11:15:19 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     mwilck@suse.com
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
Message-ID: <YMdyh62mR/lEifMR@redhat.com>
References: <20210611202509.5426-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611202509.5426-1-mwilck@suse.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 11 2021 at  4:25P -0400,
mwilck@suse.com <mwilck@suse.com> wrote:

> From: Martin Wilck <mwilck@suse.com>
> 
> Hello Mike,
> 
> here is v3 of my attempt to add retry logic to SG_IO on dm-multipath devices.
> Sorry that it took such a long time.
> 
> Regards
> Martin
> 
> Changes v2->v3:
> 
>  - un-inlined scsi_result_to_blk_status again, and move the helper
>    __scsi_result_to_blk_status to block/scsi_ioctl.c instead
>    (Bart v. Assche)
>  - open-coded the status/msg/host/driver-byte -> result conversion
>    where the standard SCSI helpers aren't usable (Bart v. Assche)

This work offers a proof-of-concept but it needs further refinement
for sure.

The proposed open-coded SCSI code (in patch 2's drivers/md/dm-scsi_ioctl.c) 
is well beyond what I'm willing to take in DM.  If this type of
functionality is still needed (for kvm's SCSI passthru snafu) then
more work is needed to negotiate proper interfaces with the SCSI
subsystem (added linux-scsi to cc, odd they weren't engaged on this).

Does it make sense to extend the SCSI device handler interface to add
the required enablement? (I think it'd have to if this line of work is
to ultimately get upstream).

Mike

  
> Changes v1->v2:
> 
>  - applied modifications from Mike Snitzer
>  - moved SG_IO dependent code to a separate file, no scsi includes in
>    dm.c any more
>  - made the new code depend on a configuration option 
>  - separated out scsi changes, made scsi_result_to_blk_status()
>    inline to avoid dependency of dm_mod from scsi_mod (Paolo Bonzini)
> 
> Martin Wilck (2):
>   scsi: export __scsi_result_to_blk_status() in scsi_ioctl.c
>   dm: add CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO on dm-multipath
> 
>  block/scsi_ioctl.c         |  52 ++++++++++++++-
>  drivers/md/Kconfig         |  11 ++++
>  drivers/md/Makefile        |   4 ++
>  drivers/md/dm-core.h       |   5 ++
>  drivers/md/dm-rq.h         |  11 ++++
>  drivers/md/dm-scsi_ioctl.c | 127 +++++++++++++++++++++++++++++++++++++
>  drivers/md/dm.c            |  20 +++++-
>  drivers/scsi/scsi_lib.c    |  29 +--------
>  include/linux/blkdev.h     |   3 +
>  9 files changed, 229 insertions(+), 33 deletions(-)
>  create mode 100644 drivers/md/dm-scsi_ioctl.c
> 
> -- 
> 2.31.1
> 
