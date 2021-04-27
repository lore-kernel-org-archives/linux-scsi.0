Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261DEC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 09:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEFC4613B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 09:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbhD0JwR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 05:52:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:56534 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235048AbhD0JwQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 05:52:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 73FC6B13E;
        Tue, 27 Apr 2021 09:51:31 +0000 (UTC)
Date:   Tue, 27 Apr 2021 11:51:31 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Arun Easi <aeasi@marvell.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        James Smart <james.smart@broadcom.com>
Subject: Re: [EXT] Re: [RFC] qla2xxx: Add dev_loss_tmo kernel module options
Message-ID: <20210427095131.zf6c4siewnrhv7qd@beryllium.lan>
References: <20210419100014.47144-1-dwagner@suse.de>
 <YH8QzgWiec8vka20@SPB-NB-133.local>
 <20210420182830.fbipix3l7hwlyfx3@beryllium.lan>
 <alpine.LRH.2.21.9999.2104201642290.24132@irv1user01.caveonetworks.com>
 <20210421075659.dwaz7gt6hyqlzpo4@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421075659.dwaz7gt6hyqlzpo4@beryllium.lan>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 21, 2021 at 09:56:59AM +0200, Daniel Wagner wrote:
> Ah, didn't know about nvmediscovery until very recentetly. I try to get
> it working with this approach (as this patch is not really a proper
> solution).

Finally found some time to play with this. FTR, the nvmediscovery
carries following information:

  UDEV  [65238.364677] change   /devices/virtual/fc/fc_udev_device (fc)
  ACTION=change
  DEVPATH=/devices/virtual/fc/fc_udev_device
  FC_EVENT=nvmediscovery
  NVMEFC_HOST_TRADDR=nn-0x20000024ff7fa448:pn-0x21000024ff7fa448
  NVMEFC_TRADDR=nn-0x200200a09890f5bf:pn-0x203800a09890f5bf
  SEQNUM=12357
  SUBSYSTEM=fc
  USEC_INITIALIZED=65238333374

The udev rule I came up is:

  ACTION=="change", SUBSYSTEM=="fc", ENV{FC_EVENT}=="nvmediscovery", \
      ENV{NVMEFC_TRADDR}=="*", \
      RUN+="/usr/local/sbin/qla2xxx_dev_loss_tmo.sh $env{NVMEFC_TRADDR} 4294967295"

and the script is:

  #!/bin/sh

  TRADDR=$1
  TMO=$2

  id=$(echo $TRADDR | sed -n "s/.*pn-0x\([0-9a-f]\+\)/\1/p")
  find /sys/kernel/debug/qla2xxx -name pn-$id -exec /bin/sh -c "echo $TMO > {}/dev_loss_tmo" \;

I am sure this can be done in a more elegant way. Anyway, I am testing
this right now, the first 30 minutes look good...
