Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDAAFC433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 16:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84FBD61242
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 16:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236855AbhDCQ6d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 12:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbhDCQ6c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 12:58:32 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4BB2C0613E6;
        Sat,  3 Apr 2021 09:58:29 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id A2F3692009C; Sat,  3 Apr 2021 18:58:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 9644A92009B;
        Sat,  3 Apr 2021 18:58:24 +0200 (CEST)
Date:   Sat, 3 Apr 2021 18:58:24 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Christoph Hellwig <hch@lst.de>
cc:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/8] Buslogic: remove ISA support
In-Reply-To: <20210331073001.46776-3-hch@lst.de>
Message-ID: <alpine.DEB.2.21.2104031805520.18977@angie.orcam.me.uk>
References: <20210331073001.46776-1-hch@lst.de> <20210331073001.46776-3-hch@lst.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 31 Mar 2021, Christoph Hellwig wrote:

> The ISA support in Buslogic has been broken for a long time, as all
> the I/O path expects a struct device for DMA mapping that is derived from
> the PCI device, which would simply crash for ISA adapters.

 With my new server in place I can experiment more with the old one, so I 
have decided to upgrade it from venerable 2.6.18 and give your change a 
try with the BT-958 to verify it does not cause a regression, but there is 
something wrong even without it:

pci 0000:00:13.0: PCI->APIC IRQ transform: INT A -> IRQ 17
scsi: ***** BusLogic SCSI Driver Version 2.1.17 of 12 September 2013 *****
scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
scsi0: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
scsi0:   Firmware Version: 5.07B, I/O Address: 0x7000, IRQ Channel: 17/Level
scsi0:   PCI Bus: 0, Device: 19, Address:
0xE0012000,
Host Adapter SCSI ID: 7
scsi0:   Parity Checking: Enabled, Extended Translation: Enabled
scsi0:   Synchronous Negotiation: Ultra, Wide Negotiation: Enabled
scsi0:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
scsi0:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
scsi0:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
scsi0:   Tagged Queue Depth:
Automatic
, Untagged Queue Depth: 3
scsi0:   SCSI Bus Termination: Both Enabled
, SCAM: Disabled

scsi0: *** BusLogic BT-958 Initialized Successfully ***
scsi host0: BusLogic BT-958
scsi 0:0:0:0: Direct-Access     IBM      DDYS-T18350M     SA5A PQ: 0 ANSI: 3
scsi 0:0:1:0: Direct-Access     SEAGATE  ST336607LW       0006 PQ: 0 ANSI: 3
scsi 0:0:5:0: Direct-Access     IOMEGA   ZIP 100          E.08 PQ: 0 ANSI: 2
st: Version 20160209, fixed bufsize 32768, s/g segs 256
sd 0:0:0:0: [sda] 35843670 512-byte logical blocks: (18.4 GB/17.1 GiB)
sd 0:0:1:0: [sdb] 71687372 512-byte logical blocks: (36.7 GB/34.2 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:5:0: [sdc] Attached SCSI removable disk
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
scsi0: *** BusLogic BT-958 Initialized Successfully ***
scsi0: *** BusLogic BT-958 Initialized Successfully ***
scsi0: *** BusLogic BT-958 Initialized Successfully ***
scsi0: *** BusLogic BT-958 Initialized Successfully ***
sd 0:0:0:0: Device offlined - not ready after error recovery
sd 0:0:1:0: Device offlined - not ready after error recovery
sd 0:0:1:0: [sdb] Attached SCSI disk
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:1:0: Attached scsi generic sg1 type 0
sd 0:0:5:0: Attached scsi generic sg2 type 0

and obviously the system does not complete booting (root is on /dev/sda2).  
I'll see if I can bisect the problem and report back.  I don't have a 
FlashPoint adapter to verify that part of the driver, but I guess for your 
change alone a MultiMaster one such as mine will suffice.

 Also `pr_cont' has not been applied here when `printk' handling was 
reworked causing messy output, so I'll fix it too on this occasion.

 Last but not least I do hope you do not plan to retire ISA DMA bounce 
buffering support for drivers/block/floppy.c, as there is hardly an 
alternative available (I do have a single SCSI<->FDD interface built 
around an Intel 8080 CPU, in the half-height 5.25" drive form factor, but 
such devices are exceedingly rare, and then you need a suitable parallel 
SCSI host too).

 Would it be feasible to convert it and any other drivers for ISA DMA 
devices (like those support for which you propose to remove here) still 
have users who could verify operation to the IOMMU framework?

  Maciej
