Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A48C6FA8E
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Feb 2023 01:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjBYBvb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 20:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBYBv3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 20:51:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92DF67E06;
        Fri, 24 Feb 2023 17:51:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59272B81D79;
        Sat, 25 Feb 2023 01:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394C7C433D2;
        Sat, 25 Feb 2023 01:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677289886;
        bh=r8FQTgVg957SHeiJxvxIeR8IzBx6zDIJDsv9pYv0umE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZECbBE6NJHRYzKMdMRT8ENRE64p/7PiRwkocof87FTlj3ouvrxUxsEpUD6PnQ2ujl
         sbPilKHUSGWAU0vYvzBc8NufmdFra44qwA5xBGIh+kXbNA9rnEHrvP+/PaoQOpOXB6
         zg0yJloVKHlDcjcAhl4/EneDHitKOs8Pt3+l0/WGQmA0JzYtcJOteduCbhhL8wOAg5
         wfThyH4t+AEVcK9pU3e2nCtAJiOUQEaHP8Z3ZoGDELMWBzyNcIa6MpQyqHXy+PdfWy
         oBTret3S8wE79g8EVbI9unZ+E07rzhMq64Eanr5ao+E/SVpzP0Y7o7ixG8aFodSNTH
         vclDtbjSijX9g==
Date:   Fri, 24 Feb 2023 18:51:22 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>
Subject: Re: [LSF/MM/BPF BOF] Userspace command abouts
Message-ID: <Y/lpmrwuehnsWmmR@kbusch-mbp.dhcp.thefacebook.com>
References: <3d3369f1-7ebe-b3b8-804c-ff2b97ec679d@suse.de>
 <Y+5cjPBE6h/IW9VH@kbusch-mbp>
 <ad837a26-948a-c690-cd9e-4dfffb5f990d@grimberg.me>
 <57d8dff9-2fdb-8198-6cdc-7265797a704a@interlog.com>
 <23526cf9-d912-59a7-4742-6003d6ccfd45@grimberg.me>
 <Y/Yscr82hqdKl1Hw@kbusch-mbp.dhcp.thefacebook.com>
 <561afa67-04d0-c675-6bbb-048313da152b@grimberg.me>
 <73b4dd39-9ce8-9b55-8a1d-06865f3bde32@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73b4dd39-9ce8-9b55-8a1d-06865f3bde32@nvidia.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 24, 2023 at 11:54:39PM +0000, Chaitanya Kulkarni wrote:
> I do think that we should work on CDL for NVMe as it will solve some of
> the timeout related problems effectively than using aborts or any other
> mechanism.

That proposal exists in NVMe TWG, but doesn't appear to have recent activity.
The last I heard, one point of contention was where the duration limit property
exists: within the command, or the queue. From my perspective, if it's not at
the queue level, the limit becomes meaningless, but hey, it's not up to me.
