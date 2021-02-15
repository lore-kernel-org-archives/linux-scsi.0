Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E39C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 16:36:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D26964DF4
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 16:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhBOQgd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Feb 2021 11:36:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45804 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231390AbhBOQeX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Feb 2021 11:34:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613406761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nsu0NYWpkITZ0mX1F4Fx9TaG3DZpEqtAizAdVndPsGU=;
        b=MKqyqvCB2iyVAxiKoqBMo1ZlnUn8dg2Au49w6rOIBx/Z4dxTO2OqDxETnmXT6Z7/7BcB2z
        Z19M2rNyDdTkv8UEbIno3FXwJAG5gm2VfPhK5pG8y3EfFLZeMTnvdLHW5uyru96cvjA70B
        mOhHYvJkYttUShrQylcCQhxzgoCuQzQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-D-g70TlpNNqzIKyszh2tEQ-1; Mon, 15 Feb 2021 11:32:40 -0500
X-MC-Unique: D-g70TlpNNqzIKyszh2tEQ-1
Received: by mail-qt1-f199.google.com with SMTP id p20so5509511qtn.23
        for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2021 08:32:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nsu0NYWpkITZ0mX1F4Fx9TaG3DZpEqtAizAdVndPsGU=;
        b=KbNVg7QIwaP1Hst/+sXygD90RzadoQH5KnxAwqsexF6UPSnv2ux7jWao4x1F0DQ8Xl
         IL52zQuOp2RKrbMHK9YUaqAUqZ0iiKy87JT4hT13O5DqHQBUPZoC4EBrAMHB5HS3nRR1
         avwELFKRfrQZchBJFAnfRjwpw3ObMtLoJ+g9bCMadcjRTB4lUz6CaESe1hGsqH89AKI9
         E+63zTFvY0F8ErHxpYHOfugf4/8UTrDBRdfSu9eGI6rOlEBBOVCYr92t/3Dvx6srAZ3U
         f2DxxTlxneTpTMWlblocT0vCZx5wqcTWma+1HEaLKD7GVQ9faPMBHh52endanqHENkD4
         BItA==
X-Gm-Message-State: AOAM531JMA3umRP7Af5O7fk90mVkiPifl8Q2PhqKN88WaNo9oHehiviM
        vmbfoYIWWXcfKh58XOoDfu/oI+JppQmxseBjiRfQx8moQVvdoD/2Jp2aVTgRdnxSbGtzYtCyWr8
        RCYDpaI/zy5JB7x4S2xRiPA==
X-Received: by 2002:ac8:5a96:: with SMTP id c22mr14701087qtc.303.1613406759927;
        Mon, 15 Feb 2021 08:32:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwPO+Vyn4WpwxEWv+KOmiND7zS5wjzEqyCbDe2ayTRCcVWkJbUnKFLfGMB1WrJJU7FL5bPg4A==
X-Received: by 2002:ac8:5a96:: with SMTP id c22mr14701067qtc.303.1613406759625;
        Mon, 15 Feb 2021 08:32:39 -0800 (PST)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
        by smtp.gmail.com with ESMTPSA id 18sm10984888qtw.70.2021.02.15.08.32.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Feb 2021 08:32:39 -0800 (PST)
Message-ID: <9b418dff52ac32a2b092e5596506ba7f5a2ad614.camel@redhat.com>
Subject: Re: PATCH 00/25 V4] target: fix cmd plugging and submission
From:   Laurence Oberman <loberman@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Date:   Mon, 15 Feb 2021 11:32:37 -0500
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-02-12 at 01:26 -0600, Mike Christie wrote:
> The following patches were made over Martin's 5.12 branches
> to handle conflicts with the in_interrupt changes.
> 
> The patches fix the following issues:
> 
> 1. target_core_iblock plugs and unplugs the queue for every
> command. To handle this issue and handle an issue that
> vhost-scsi and loop were avoiding by adding their own workqueue,
> I added a new submission workqueue to LIO. Drivers can pass cmds
> to it, and we can then submit batches of cmds.
> 
> 2. vhost-scsi and loop on the submission side were doing a work
> per cmd but because we can block in the block layer on resources
> like tags we can end up creating lots of threads that will fight
> each other. In this patchset I just use a cmd list per device to
> avoid abusing the workueue layer and to better batch the cmds
> to the lower layers.
> 
> The combined patchset fixes a major perf issue we've been hitting
> with vhost-scsi where IOPs were stuck at 230K when running:
> 
>     fio --filename=/dev/sda  --direct=1 --rw=randrw --bs=4k
>     --ioengine=libaio --iodepth=128  --numjobs=8 --time_based
>     --group_reporting --runtime=60
> 
> The patches in this set get me to 350K when using devices that
> have native IOPs of around 400-500K. 
> 
> 3. Fix target_submit* error handling. While handling Christoph's
> comment to kill target_submit_cmd_map_sgls I hit several bugs that
> are now also fixed up.
> 
> V4:
> - Fixed the target_submit error handling.
> - Dropped get_cdb callback.
> - Fixed kernel robot errors for incorrect return values and unused
> variables.
> - Used flush instead of cancel to fix bug in tmr code.
> - Fixed race in tcmu.
> - Made completion affinity handling a configfs setting
> - Dropped patch that added the per device work lists. It really
> helped
> a lot for higher perf initiators and tcm loop but only gave around a
> 5%
> boost to other drivers. So I dropped it for now to see if there is
> something more generic we can do.
> 
> V3:
> - Fix rc type in target_submit so its a sense_reason_t
> - Add BUG_ON if caller uses target_queue_cmd_submit but hasn't
> implemented get_cdb.
> - Drop unused variables in loop.
> - Fix race in tcmu plug check
> - Add comment about how plug check works in iblock
> - Do a flush when handling TMRs instead of cancel
> 
> V2:
> - Fix up container_of use coding style
> - Handle offlist review comment from Laurence where with the
> original code and my patches we can hit a bug where the cmd
> times out, LIO starts up the TMR code, but it misses the cmd
> because it's on the workqueue.
> - Made the work per device work instead of session to handle
> the previous issue and so if one dev hits some issue it sleeps on,
> it won't block other devices.
> 
> 
> 

Hello Mike
Against linux-next with some manual fixups (as expected) 

The original issue I reported for tcm_loop seems to be resolved with
this series of patches as well as the stall if memory became low.
I also rans some additional tcm_core tests on a target server with
tcm_qla2xxx as it uses some of the tcm_core changes.
Its not exhaustive
for all changes but covers most.

Tested-by:Laurence Oberman <loberman@redhat.com>


