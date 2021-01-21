Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEEC7C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 10:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F63B239EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 10:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbhAUKGd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 05:06:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:55640 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728546AbhAUKG2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 05:06:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611223539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x+fMNi7i0ADkZQ1neIgikNKiJTFKRWpEYgnfDwLkIgc=;
        b=RNExLDhhtTSkJiCo2PUMsaG3jmiz7vbehWkxXpYbWSjgmhIsxmQNHbFo8IhItqC7gSVlQ1
        c1ldOZRX7XXrNII3AY61PS4E2DP36qWO/2ZLPWJXXRjPSEOMvU/c/zkbqZVg+okdUJflj2
        jCIKkVIIQIVkpIHi1cAoV31EmuaC9jY=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 21E8FAD11;
        Thu, 21 Jan 2021 10:05:39 +0000 (UTC)
Message-ID: <166f7a2e10f27647aee5d62e31a074af982b52e8.camel@suse.com>
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
From:   Martin Wilck <mwilck@suse.com>
To:     Donald Buczek <buczek@molgen.mpg.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Don Brace <Don.Brace@microchip.com>,
        Kevin Barnett <Kevin.Barnett@microchip.com>,
        John Garry <john.garry@huawei.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Date:   Thu, 21 Jan 2021 11:05:38 +0100
In-Reply-To: <936ea886-e7ae-c3c5-1bab-911754050fff@molgen.mpg.de>
References: <20210120184548.20219-1-mwilck@suse.com>
         <936ea886-e7ae-c3c5-1bab-911754050fff@molgen.mpg.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-01-21 at 10:07 +0100, Donald Buczek wrote:
> On 20.01.21 19:45, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > Donald: please give this patch a try.
> > 
> > Commit 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter
> > for scsi_mq")
> > [...]
> 
> 
> Unfortunately, this patch (on top of 6eb045e092ef) did not fix the
> problem. Same error (""controller is offline: status code 0x6100c"")
> after about 20 minutes of the test load.

Too bad. Well, I believe it was worth a try. Thanks for testing it.

Martin





