Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E66F1C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 19:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE122206F6
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 19:26:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Uf8WjI/A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgHETZ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 15:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728715AbgHERPB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 13:15:01 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08307C061757
        for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2020 10:15:01 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id j7so23880277oij.9
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2020 10:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=jWQQ0cQXaDFSwdvPuv1NHdKGXywtUA2kO7hM0wR/9SI=;
        b=Uf8WjI/AL0juCYG3MrhkVy1QGS7Yeq11AIhtf9OD3jjDIw/LrH6sMOKctAmvMyPQkk
         m5Z+OH4gvZfUvpzfaoDMxN2y7JWSX5JlJ4rTVzfvk9DCrh0LvOx0svQrIsMLTw3QioEi
         zNBBavkTkluAKNfqrCJjB5ZO0BypJ6dYyYJUw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=jWQQ0cQXaDFSwdvPuv1NHdKGXywtUA2kO7hM0wR/9SI=;
        b=MJNHkYrKLYJuJX10a6QL/B7np+SEf1STl7zxTXHRnNIDqDRFu0rwAeVmX/zXvFtPPM
         rrQwxU/nBbOiWGBJ5GHufCulXAkpbU89lsYo952WmEOKtcKDVJpsLy9vjQ55f1u8QwMs
         P/dpI6mnvO9+75k7q3fAKmtm71KnfnyYjiuoBMcex4IPyNprHzpWjXEPPPblZumAR9NB
         h9CsgTSSnWSk2JcD+6mlYrTFforn4QVnuRsun35AGNpC2jRRFvsu2yzV0iR20E799YLT
         V2t+02FX7K8Q4m3myyALJbN5MwUU0g+YFGkBUvgtIukab1EbsfNuHWQTheAmGyXvoStM
         sWWQ==
X-Gm-Message-State: AOAM5326zdwGuTI1KStnAhAjDSrar6SL6tI+yhArSGWi9kjx7S9Hx3fA
        5a/j2/gX/tqARFCENvRq3HZyZnmB3Q2+76jQAO5xiQ==
X-Google-Smtp-Source: ABdhPJzLZdo8qY74/MuhM/+FSNWx/NNtopPEtpMZtcAHj+8nS6gaQUzZcd/IdoV0AZ96iiYdKi1Rm1aHAQIJkKQ5bdE=
X-Received: by 2002:a54:478f:: with SMTP id o15mr3658717oic.77.1596647700338;
 Wed, 05 Aug 2020 10:15:00 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-2-git-send-email-muneendra.kumar@broadcom.com>
 <20200804113130.qfi5agzilso3mlbp@beryllium.lan> <20200804142123.GA4819@mtj.thefacebook.com>
 <b35e0e83-eb6c-4282-5142-22d9a996d260@broadcom.com> <CACVXFVPVM-xU0d2nETztPrS_EpacMy8A4x8FbShhLYt2iV_ouw@mail.gmail.com>
 <227c7f27-c6c7-5db1-59ac-2dd428f5a42a@suse.de> <20200805143913.GC4819@mtj.thefacebook.com>
In-Reply-To: <20200805143913.GC4819@mtj.thefacebook.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
thread-index: AQIDyhmBPqdmqCKUdNTZliBUbPkt/AIVs741AOV8stoBvB2xRwGs7Aj/AfU+Z6cCXn8lCgHQWH25qGqsWhA=
Date:   Wed, 5 Aug 2020 22:44:56 +0530
Message-ID: <c40bc34840566366177a84b0d8b7ae90@mail.gmail.com>
Subject: RE: [RFC 01/16] blkcg:Introduce blkio.app_identifier knob to blkio controller
To:     Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.de>
Cc:     Ming Lei <tom.leiming@gmail.com>,
        James Smart <james.smart@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ewan Milne <emilne@redhat.com>, mkumar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Tejun,
Our main requirement is to track the bio requests coming from different VM
/container applications  at the blk device layer(fc,scsi,nvme).
By the time IO request comes to the blk device layer, the context of the
application is lost and we can't track whose IO this belongs.

In our approach we used the block cgroup to achieve this requirement.
Since Requests also have access to the block cgroup via
bio->bi_blkg->blkcg, and from there we can get the VM UUID.
Therefore we added the VM UUID(app_identifier) to struct blkcg and define
the accessors in blkcg_files and blkcg_legacy_files.

Could you please let me know is there any another way where we can get the
VM UUID info with the help of blkcg.

Regards,
Muneendra.






-----Original Message-----
From: Tejun Heo [mailto:htejun@gmail.com] On Behalf Of Tejun Heo
Sent: Wednesday, August 5, 2020 8:09 PM
To: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <tom.leiming@gmail.com>; James Smart
<james.smart@broadcom.com>; Daniel Wagner <dwagner@suse.de>; Muneendra
<muneendra.kumar@broadcom.com>; linux-block <linux-block@vger.kernel.org>;
Linux SCSI List <linux-scsi@vger.kernel.org>; Paolo Bonzini
<pbonzini@redhat.com>; Ewan Milne <emilne@redhat.com>; mkumar@redhat.com
Subject: Re: [RFC 01/16] blkcg:Introduce blkio.app_identifier knob to
blkio controller

Hello,

On Wed, Aug 05, 2020 at 08:33:19AM +0200, Hannes Reinecke wrote:
> None of these are guaranteed to be either present or unique.
> It's not uncommon to have VMs with more than one MAC address, and any
> other unique identifier like system UUID is not required to be present.

I have a really hard time seeing how this fits into block cgroup
interface.
The last time we did something similar (tagging from cgroup interface
side) was for netcls and it ended poorly. There are basic problems with
e.g.
delegation as these things are at odds with everything else sharing the
interface.

My not-too-well informed suggestions are either building mapping somewhere
in the stack or at least implement the interface where it fits better so
that people who don't need app_identifier don't see them and preferably
can disable them. I don't mind cgroup data structs carrying extra bits for
stuff which want to make use of the cgroup tree but I'm a pretty firm nack
on the proposed interface.

Thanks.

--
tejun
