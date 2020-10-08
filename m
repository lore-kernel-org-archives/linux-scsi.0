Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C31C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 06:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5119F2076B
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 06:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgJHGWz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Oct 2020 02:22:55 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:47886 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgJHGWz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2020 02:22:55 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 47B522A040;
        Thu,  8 Oct 2020 02:22:51 -0400 (EDT)
Date:   Thu, 8 Oct 2020 17:22:50 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Tony Asleson <tasleson@redhat.com>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        pmladek@suse.com, David Lehman <dlehman@redhat.com>,
        sergey.senozhatsky@gmail.com, jbaron@akamai.com,
        James.Bottomley@HansenPartnership.com,
        linux-kernel@vger.kernel.org, rafael@kernel.org,
        martin.petersen@oracle.com, kbusch@kernel.org, axboe@fb.com,
        sagi@grimberg.me, akpm@linux-foundation.org, orson.zhai@unisoc.com,
        viro@zeniv.linux.org.uk
Subject: Re: [v5 01/12] struct device: Add function callback durable_name
In-Reply-To: <72be0597-a3e2-bf7b-90b2-799d10fdf56c@redhat.com>
Message-ID: <alpine.LNX.2.23.453.2010081721270.6@nippy.intranet>
References: <20200925161929.1136806-1-tasleson@redhat.com> <20200925161929.1136806-2-tasleson@redhat.com> <20200929175102.GA1613@infradead.org> <20200929180415.GA1400445@kroah.com> <20e220a6-4bde-2331-6e5e-24de39f9aa3b@redhat.com> <20200930073859.GA1509708@kroah.com>
 <c6b031b8-f617-0580-52a5-26532da4ee03@redhat.com> <20201001114832.GC2368232@kroah.com> <72be0597-a3e2-bf7b-90b2-799d10fdf56c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 7 Oct 2020, Tony Asleson wrote:

> The log information is not helpful without the information to correlate 
> to the actual device.

Log messages that associate one entity with another can be generated 
whenever such an association comes into existence, which is probably when 
devices get probed.

E.g. a host:channel:target:lun identifier gets associated with a block 
device name by the dev_printk() calls in sd_probe():

[    3.600000] sd 0:0:0:0: [sda] Attached SCSI disk

BTW, if you think of {"0:0:0:0","sda"} as a row in some normalized table 
and squint a bit, this problem is not unlike the replication of database 
tables over a message queue.
