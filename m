Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C47C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 14:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A20EC22473
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 14:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388415AbhAKO2p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 09:28:45 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:39148 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388407AbhAKO2o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 09:28:44 -0500
Date:   Mon, 11 Jan 2021 15:28:01 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610375282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TbHwjxpm0OAB9IE8m+yCnugikWKJO/7SN4oci24CZzA=;
        b=pTGTtyYByQoRXxw2LquHwaJ6bBrRC8i7eLHYqe9lUU1pLcuHzfKHiwOw4i61HoN8OSaaKZ
        1Wg+ALQsuy5yz21WxhRr1OK2DuHyQXaBs/bpIPCWZVOqjJwpCFfIQ1ONiipBXaW1KwaNki
        KBgO4nlru23cVpafQAsf3cTEDYIr4HWLxzPtIFjP6wACjnPShc1S8ka9wRReqWBVRcuOy8
        yG/6Fmi3vp3qKIrSmuyW63ZClAdIMOb+8Z/xVIjl23a4fIUJrE0j5alJc8NqBNP93Gfydw
        vFbX0IprGf/or0XM6yLOcEiMGvDhj7TsJLZpSTbliQUl5g++w+ywGJR0kq7Kjw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610375282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TbHwjxpm0OAB9IE8m+yCnugikWKJO/7SN4oci24CZzA=;
        b=WUSj/a4cFlkXdCJVuR8D3NORinyQLS4uDy/oLBs3OJT4SIcTshiG6lg7fetGH7ajKf6mAp
        +x+ib9VtZO2AuGCA==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     John Garry <john.garry@huawei.com>
Cc:     Jason Yan <yanaijie@huawei.com>, Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Subject: Re: [PATCH 00/11] scsi: libsas: Remove in_interrupt() check
Message-ID: <X/xgcXies+pfUNLJ@lx-t490>
References: <X/xV/uR77a9JLZ4v@lx-t490>
 <ccddbd5e-ec63-934e-c15a-7263aeaa24ce@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccddbd5e-ec63-934e-c15a-7263aeaa24ce@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 11, 2021 at 01:59:25PM +0000, John Garry wrote:
...
> To me, what you're doing seems fine.
>
...
>
> Just one other thing to mention:
> I have a patch to remove the indirection in libsas notifiers:
> https://github.com/hisilicon/kernel-dev/commit/87fcd7e113dc05b7933260e7fa4588dc3730cc2a
>
> I was going to send it today. Hopefully, if community has no problem with
> it, you can make your changes with that in mind.
>

Perfect. I'll rebase on top of it if everything is OK there.

I'll also append some patches to the series, removing the _gfp() suffix,
per your request earlier:

  https://lkml.kernel.org/r/68957d37-c789-0f0e-f5d1-85fef7f39f4f@huawei.com

Thanks!

--
Ahmed S. Darwish
Linutronix GmbH
