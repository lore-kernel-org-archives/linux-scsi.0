Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CAEC3A5A3
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 01:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14EDE2173E
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 01:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfH1Bpk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 21:45:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59596 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbfH1Bpk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Aug 2019 21:45:40 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D13C281D1;
        Wed, 28 Aug 2019 01:45:40 +0000 (UTC)
Received: from ming.t460p (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26924600D1;
        Wed, 28 Aug 2019 01:45:29 +0000 (UTC)
Date:   Wed, 28 Aug 2019 09:45:25 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@fb.com>,
        Hannes Reinecke <hare@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        Keith Busch <keith.busch@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] nvme: pci: pass IRQF_RESCURE_THREAD to
 request_threaded_irq
Message-ID: <20190828014524.GA8090@ming.t460p>
References: <20190827085344.30799-1-ming.lei@redhat.com>
 <20190827085344.30799-4-ming.lei@redhat.com>
 <7cdb9dbb-46e5-b66a-ddf1-c7ecceb28d7a@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cdb9dbb-46e5-b66a-ddf1-c7ecceb28d7a@acm.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Wed, 28 Aug 2019 01:45:40 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 27, 2019 at 08:10:42AM -0700, Bart Van Assche wrote:
> On 8/27/19 1:53 AM, Ming Lei wrote:
> > If one vector is spread on several CPUs, usually the interrupt is only
> > handled on one of these CPUs.
> 
> Is that perhaps a limitation of x86 interrupt handling hardware? See also
> the description of physical and logical destination mode of the local APIC
> in the Intel documentation.
> 
> Does that limitation also apply to other platforms than x86?

Please see the following excellent explanation from Thomas.

	https://lkml.org/lkml/2018/4/4/734

Especially the following words:

	So at some point we ripped out the multi target support on X86 and moved
	everything to single target delivery mode.
	
	Other architectures never supported multi target delivery either due to
	hardware restrictions or for similar reasons why X86 dropped it. There
	might be a few architectures which support it, but I have no overview at
	the moment.


thanks,
Ming
