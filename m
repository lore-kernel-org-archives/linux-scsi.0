Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B131CC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 03:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84D862244A
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 03:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfKTDqi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 22:46:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:56295 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727362AbfKTDqi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 22:46:38 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id xAK3jiTj021443;
        Tue, 19 Nov 2019 21:45:45 -0600
Message-ID: <e8330a8f408f6f4c6edbc783c3aebd1cd595ad64.camel@kernel.crashing.org>
Subject: Re: [PATCH] lpfc: fixup out-of-bounds access during CPU hotplug
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        linux-scsi@vger.kernel.org
Date:   Wed, 20 Nov 2019 14:45:44 +1100
In-Reply-To: <1dca4247-5d02-5232-cd73-a5519f1bbb94@broadcom.com>
References: <20191118123012.99664-1-hare@suse.de>
         <5c61c1ce-d4fc-23b8-621a-897febb89b67@broadcom.com>
         <1713444f-2788-ca07-3452-efc9457215d9@suse.de>
         <1dca4247-5d02-5232-cd73-a5519f1bbb94@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2019-11-19 at 09:17 -0800, James Smart wrote:
> 
> > Actually, the behaviour of num_possible_cpus() under cpu hotplug seems 
> > to be implementation-specific.
> > One might want to set it to the max value at all times, which has the 
> > drawback that you'd need to scale per-cpu values with that number, 
> > leading to a massive memory overhead as only very few installation 
> > will ever reach that number.
> > Others might want to set to the max value at the current 
> > configuration, implying that it might change under CPU hotplug.
> > Which seems to be the case for PowerPC, which was the case which 
> > triggered the issue at hand.
> > But maybe it was a plain bug in the CPU hotplug implementation; one 
> > should be asking BenH for details here.
> > 
> > Cheers,
> > 
> > Hannes
> 
> That sure seems to be at odds with this comment from 
> include/linux/cpumask.h:
> 
>   *  The cpu_possible_mask is fixed at boot time, as the set of CPU id's
>   *  that it is possible might ever be plugged in at anytime during the
>   *  life of that system boot.  The cpu_present_mask is dynamic(*),
>   *  representing which CPUs are currently plugged in.  And
>   *  cpu_online_mask is the dynamic subset of cpu_present_mask,
>   *  indicating those CPUs available for scheduling.
> 
> and
> #define num_possible_cpus()     cpumask_weight(cpu_possible_mask)

Right, it should be fixed at boot. Where do you see powerpc change it ?

Cheers,
Ben.

