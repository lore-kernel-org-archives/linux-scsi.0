Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99B7C54EBC
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Jan 2023 12:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbjAKM4D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 07:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239044AbjAKMzi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 07:55:38 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD79B19016;
        Wed, 11 Jan 2023 04:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1673441736;
        bh=15bnm4Ptwx3L0kPhiEQGs6ffDlqS9qM7HUNQGS2ztwU=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=uk7P9Bt9PvhL7DPXUkq53QKSLXXTtHYTgpDJ4nJFcrQBT/D6D2zJJzD+MQyrv7Mdf
         OFuC5ESTJmrGmhTr3JdpXLR8qgtwEQ1dWYh60a5ngU6hNq4Bk8CTJXPYVLN0gDCXm7
         yl6b4jX5kNLjw/2DhvMcmXA34l3fRjNKMpqnxKSM=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 725D21285F58;
        Wed, 11 Jan 2023 07:55:36 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YdYPBYHkeX3w; Wed, 11 Jan 2023 07:55:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1673441736;
        bh=15bnm4Ptwx3L0kPhiEQGs6ffDlqS9qM7HUNQGS2ztwU=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=uk7P9Bt9PvhL7DPXUkq53QKSLXXTtHYTgpDJ4nJFcrQBT/D6D2zJJzD+MQyrv7Mdf
         OFuC5ESTJmrGmhTr3JdpXLR8qgtwEQ1dWYh60a5ngU6hNq4Bk8CTJXPYVLN0gDCXm7
         yl6b4jX5kNLjw/2DhvMcmXA34l3fRjNKMpqnxKSM=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::c14])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id AC4BF1280ECC;
        Wed, 11 Jan 2023 07:55:35 -0500 (EST)
Message-ID: <5230135e68bdf7b3fcbff78e7ffd51beebe509c8.camel@HansenPartnership.com>
Subject: Re: [LSF/MM/BPF TOPIC] Limits of development
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linux-foundation.org,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Date:   Wed, 11 Jan 2023 07:55:34 -0500
In-Reply-To: <06e4d03c-3ecf-7e91-b80e-6600b3618b98@suse.de>
References: <06e4d03c-3ecf-7e91-b80e-6600b3618b98@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-01-11 at 12:49 +0100, Hannes Reinecke wrote:
> Hi all,
> 
> given the recent discussion on the mailing list I would like to
> propose a topic for LSF/MM:
> 
> Limits of development
> 
> In recent times quite some development efforts were left floundering 
> (Non-Po2 zones, NVMe dispersed namespaces), while others (like blk-
> snap) went ahead. And it's hard to figure out why some projects are
> deemed 'good', and others 'bad'.

It's not any form of secret: some ideas are just easier to implement
and lead to useful features and others don't.  It's exactly why we
insist on code based discussions.  It's also why standards that aren't
driven by implementations can be problematic: what sounds good on paper
doesn't necessarily work out well in practice.

> I would like to have a discussion at LSF/MM about what are valid
> reasons for future developments, and maybe even agree on common
> guidelines where developers can refer to when implementing new
> features.

I don't think anyone can give you this.  If it could be achieved then
all the standards bodies that are currently forced to deal with
implementations could happily go back to abstract proposals.

James

