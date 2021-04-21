Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D90C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 07:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C59D61434
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 07:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237515AbhDUH5d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 03:57:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:47578 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237514AbhDUH5d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 03:57:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 88C5CAFE6;
        Wed, 21 Apr 2021 07:56:59 +0000 (UTC)
Date:   Wed, 21 Apr 2021 09:56:59 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Arun Easi <aeasi@marvell.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        James Smart <james.smart@broadcom.com>
Subject: Re: [EXT] Re: [RFC] qla2xxx: Add dev_loss_tmo kernel module options
Message-ID: <20210421075659.dwaz7gt6hyqlzpo4@beryllium.lan>
References: <20210419100014.47144-1-dwagner@suse.de>
 <YH8QzgWiec8vka20@SPB-NB-133.local>
 <20210420182830.fbipix3l7hwlyfx3@beryllium.lan>
 <alpine.LRH.2.21.9999.2104201642290.24132@irv1user01.caveonetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.9999.2104201642290.24132@irv1user01.caveonetworks.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arun,

On Tue, Apr 20, 2021 at 05:25:52PM -0700, Arun Easi wrote:
> On Tue, 20 Apr 2021, 11:28am, Daniel Wagner wrote:
> > As explained the debugfs interface is not working (okay, that's
> > something which could be fixed) and it has the big problem that it is
> > not under control by udevd. Not sure if we with some new udev rules the
> > debugfs could automatically discovered or not.
>
> Curious, which udev script does this today for FC SCSI?

I am currently figuring out the 'correct' settings for passing the
various tests our partner does in their labs. That is no upstream udev
rules for this (yet).

Anyway, the settings are

  ACTION!="add|change", GOTO="tmo_end"
  # SCSI fc_remote_ports
  KERNELS=="rport-?*", SUBSYSTEM=="fc_remote_ports", ATTR{fast_io_fail_tmo}="5", ATTR{dev_loss_tmo}="4294967295"
  # nvme fabrics
  KERNELS=="ctl", SUBSYSTEMS=="nvme-fabrics", ATTR{transport}=="fc", ATTR{fast_io_fail_tmo}="-1", ATTR{ctrl_loss_tmo}="-1"
  LABEL="tmo_end"

and this works for lpfc but only half for qla2xxx.

> In theory, the exsting fc nvmediscovery udev event has enough information
> to find out the right qla2xxx debugfs node and set dev_loss_tmo.

Ah, didn't know about nvmediscovery until very recentetly. I try to get
it working with this approach (as this patch is not really a proper
solution).

> > > What exists for FCP/SCSI is quite clear and reasonable. I don't know why
> > > FC-NVMe rports should be way too different.
> >
> > The lpfc driver does expose the FCP/SCSI and the FC-NVMe rports nicely
> > via the fc_remote_ports and this is what I would like to have from the
> > qla2xxx driver as well. qla2xxx exposes the FCP/SCSI rports but not the
> > FC-NVMe rports.
> >
>
> Given that FC NVME does not have sysfs hierarchy like FC SCSI, I see
> utility in making FC-NVME ports available via fc_remote_ports. If, though,
> a FC target port is dual protocol aware this would leave with only one
> knob to control both.

So far I haven't had the need to distinguish between the two protocols
for the dev_loss_tmo setting. I think this is what Hannes was also
trying to tell, it might make sense to introduce sysfs APIs per
protocol.

> I think, going with fc_remote_ports is better than introducing one more
> way (like this patch) to set this.

As I said this patch was really a RFC. I will experiment with
nvmediscovery. Though, I think this is just a stopgap solution. Having
two completely different ways to configure the same thing is sub optimal
and it is asking for a lot of troubles with end customers. I am really
hoping we could streamline the current APIs, so we have only one
recommended way to configure the system independent of the driver
involved.

Thanks,
Daniel
