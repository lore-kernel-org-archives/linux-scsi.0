Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000E5C64ED8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Feb 2023 17:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjB0Rp0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Feb 2023 12:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjB0RpZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2023 12:45:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A7A241E6;
        Mon, 27 Feb 2023 09:45:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A232C60EE2;
        Mon, 27 Feb 2023 17:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27632C433EF;
        Mon, 27 Feb 2023 17:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677519895;
        bh=/SOVKtkDSxDxmC89ievuT6HH6QX3NhvtmNmaObVIk6w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jl/ZvmRNcuW9+rhUypdYi2dd6xgmzzP8r0oObXLU2Q1eoo7mwD99uKgALcAAA4Tun
         Fk/PDUeywnsaN8TPspId/XjmpLG/58C0sJDU+dK7+BkkmMiyZ+i44ADEyb0jECmntA
         3OoHn3Fq2GFb8E+Mn0e+rPx+MDJF/6k7RRLtUyY+K6h4IcVeHQubyAgubUUZ8of773
         fd796yjYxhBxia1AV4TL0MAYDaqg0eF8A2Kxbv6f8MPpagrTAXCKiGZOqCAtJgEkFR
         UUFAg+ElDgXuSxAcV+n9azzcUCItmLn8lPlzcJ3iT68A68AQlcqYpg4RMxYAhihhxi
         bIB6CF9CB0Z+Q==
Date:   Mon, 27 Feb 2023 10:44:51 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>
Subject: Re: [LSF/MM/BPF BOF] Userspace command abouts
Message-ID: <Y/zsE9i7012Ivwe1@kbusch-mbp.dhcp.thefacebook.com>
References: <ad837a26-948a-c690-cd9e-4dfffb5f990d@grimberg.me>
 <57d8dff9-2fdb-8198-6cdc-7265797a704a@interlog.com>
 <23526cf9-d912-59a7-4742-6003d6ccfd45@grimberg.me>
 <Y/Yscr82hqdKl1Hw@kbusch-mbp.dhcp.thefacebook.com>
 <561afa67-04d0-c675-6bbb-048313da152b@grimberg.me>
 <73b4dd39-9ce8-9b55-8a1d-06865f3bde32@nvidia.com>
 <Y/lpmrwuehnsWmmR@kbusch-mbp.dhcp.thefacebook.com>
 <0fe59301-65e6-d8a9-033e-0243ad59c56b@opensource.wdc.com>
 <316431ed-1727-7e80-2090-84ac5b334f74@grimberg.me>
 <3ea301b1-c808-ce08-8ec8-3a631b385fb9@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ea301b1-c808-ce08-8ec8-3a631b385fb9@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 27, 2023 at 06:28:41PM +0100, Hannes Reinecke wrote:
> On 2/27/23 17:33, Sagi Grimberg wrote:
> > 
> > I'm not up to speed on how CDL is defined, but I'm unclear how CDL at
> > the queue level would cause the host to open more queues?

Because each CDL class would need its own submission queue in that scheme. They
can all share a single completion queue, so this scheme doesn't necassarily
increase the number of interrupt vectors.

> > Another question, does CDL have any relationship with NVMe "Time Limited
> > Error Recovery"? where the host can set a feature for timeout and
> > indicate if the controller should respect it per command?
> > 
> > While this is not a full-blown every queue/command has its own timeout,
> > it could address the original use-case given by Hannes. And it's already
> > there.
> I guess that is the NVMe version of CDLs; can you give me a reference for
> it?

They're not the same. TLER starts timing after a command experiences a
recoverable error, where CDL is an end-to-end timing for all commands.
