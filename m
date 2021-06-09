Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB077C48BCF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 18:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BACEE61040
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 18:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhFISih (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 14:38:37 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:45958 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229472AbhFISih (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 14:38:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 85AD91280BFB;
        Wed,  9 Jun 2021 11:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1623263802;
        bh=8E8YKM08zSHfgTf3XjWtoAyBeXxzwQfdx7IcdysE4Ak=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Ij+9FJMYjcHbTV812FtaOf0Wz75pVsyP6BuDpTFhtbzHHhLVxkRIOhx81nENT6Hx7
         18Enbes52dfELuBVNm7FpkbD+e1BUlJQhxeMwPAcHS17XtxjCOVglUpXRmSrunGOV0
         SgNwLQSZCnvqBc8YHwA9/E3nDyXs2q+VX89crh08=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Jze5ftrexVPf; Wed,  9 Jun 2021 11:36:42 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 215791280BF7;
        Wed,  9 Jun 2021 11:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1623263802;
        bh=8E8YKM08zSHfgTf3XjWtoAyBeXxzwQfdx7IcdysE4Ak=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Ij+9FJMYjcHbTV812FtaOf0Wz75pVsyP6BuDpTFhtbzHHhLVxkRIOhx81nENT6Hx7
         18Enbes52dfELuBVNm7FpkbD+e1BUlJQhxeMwPAcHS17XtxjCOVglUpXRmSrunGOV0
         SgNwLQSZCnvqBc8YHwA9/E3nDyXs2q+VX89crh08=
Message-ID: <485837f392401bf35fb7fc8231d7a051f47b53d7.camel@HansenPartnership.com>
Subject: Re: [LSF/MM/BPF TOPIC] block namespaces
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Hannes Reinecke <hare@suse.de>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux NVMe Mailinglist <linux-nvme@lists.infradead.org>
Date:   Wed, 09 Jun 2021 11:36:41 -0700
In-Reply-To: <a189ec50-4c11-9ee9-0b9e-b492507adc1e@suse.de>
References: <a189ec50-4c11-9ee9-0b9e-b492507adc1e@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-05-27 at 10:01 +0200, Hannes Reinecke wrote:
> Hi all,
> 
> I guess it's time to tick off yet another item on my long-term to-do
> list:
> 
> Block namespaces
> ----------------
> 
> Idea is similar to what network already does: allowing each user
> namespace to have a different 'view' on the existing block devices.
> EG if the admin creates a ramdisk in one namespace this device should
> not be visible to other namespaces.
> But for me the most important use-case would be qemu; currently the
> devices need to be set up in the host, even though the host has no
> business touching it as they really belong to the qemu instance. This
> is causing quite some irritation eg when this device has LVM or MD
> metadata and udev is trying to activate it on the host.

I suppose the first question is "why block only?"  There are several
existing device namespace proposals which would be more generic.

> Overall plan is to restrict views of '/dev', '/sys/dev/block' and
> '/sys/block' to only present the devices 'visible' for this
> namespace.

We actually already have a devices cgroup that does some of this:

https://www.kernel.org/doc/Documentation/cgroup-v1/devices.txt

However, visibility isn't the only problem, for direct passthrough
there's also uevent handling and people have even asked about module
loading.

>  Initially the drivers would keep their global enumeration, but plan
> is to make the drivers namespace-aware, too, such that each namespace
> could have its own driver-specific device enumeration.

I really wouldn't do this.  Namespace/Cgroup separation should be kept
as high as possible.  If it leaks into the drivers it will become
unmaintainable.  Why do you think you need the drivers to be aware?  If
it's just enumeration, that should all be doable with the visibility
driver unless you want to do things like compact numbering?

> Goal of this topic is to get a consensus on whether block namespaces
> are a feature which would find interest, and also to discuss some
> design details here:
> - Only in certain cases can a namespace be assigned (eg by calling
> 'modprobe', starting iscsiadm, or calling nvme-cli); how do we handle
> devices for which no namespace can be identified?
> - Shall we allow for different device enumeration per namespace?
> - Into which level should we go with hiding sysfs structures?
>   Is blanking out the higher-level interfaces in /dev and /sys/block
>   enough?

First question is does the device cgroup do enough for you and if not
what's missing?

James


