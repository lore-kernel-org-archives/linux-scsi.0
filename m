Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41CEFC3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 13:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E09F22CEC
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 13:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393396AbfHWN1B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 09:27:01 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4774 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389211AbfHWN1B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 09:27:01 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 086BA3A92BF4100401B8;
        Fri, 23 Aug 2019 21:26:33 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.238) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Fri, 23 Aug 2019
 21:26:31 +0800
Subject: Re: [PATCH RFC 00/24] scsi: enable reserved commands for LLDDs
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20190529132901.27645-1-hare@suse.de>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, "Ming Lei" <ming.lei@redhat.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <e5c2b01a-71d9-ef94-3bf6-0830d866e4cf@huawei.com>
Date:   Fri, 23 Aug 2019 14:26:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <20190529132901.27645-1-hare@suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.238]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/05/2019 14:28, Hannes Reinecke wrote:
> Hi all,
>
> quite some drivers use internal commands for various purposes, most
> commonly sending TMFs or querying the HBA status.
> While these commands use the same submission mechanism than normal
> I/O commands, they will not be counted as outstanding commands,
> requiring those drivers to implement their own mechanism to figure
> out outstanding commands.
> This patchset enables the use of reserved tags for the SCSI midlayer,
> enabling LLDDs to rely on the block layer for tracking outstanding
> commands.
> More importantly, it allows LLDD to request a valid tag from the block
> layer without having to implement some tracking mechanism within the
> driver. This removes quite some hacks which were required for some
> drivers (eg. fnic or snic).
>
> As usual, comments and reviews are welcome.
>

Hi Hannes,

I was wondering if you have any plans to progress this series?

I don't mind helping out...

Cheers,
John

> Hannes Reinecke (24):
>   block: disable elevator for reserved tags
>   scsi: add scsi_{get,put}_reserved_cmd()
>   scsi: add 'nr_reserved_cmds' field to the SCSI host template
>   csiostor: use reserved command for LUN reset
>   scsi: add scsi_cmd_from_priv()
>   virtio_scsi: use reserved commands for TMF
>   scsi: add host tagset busy iterator
>   fnic: use reserved commands
>   fnic: use scsi_host_tagset_busy_iter() to traverse commands
>   scsi: allocate separate queue for reserved commands
>   scsi: add scsi_host_get_reserved_cmd()
>   hpsa: move hpsa_hba_inquiry after scsi_add_host()
>   hpsa: use reserved commands
>   hpsa: use blk_mq_tagset_busy_iter() to traverse outstanding commands
>   hpsa: drop refcount field from CommandList
>   snic: use reserved commands
>   snic: use tagset iter for traversing commands
>   scsi: Implement scsi_is_reserved_cmd()
>   aacraid: move scsi_add_host()
>   aacraid: use private commands
>   aacraid: replace cmd_list with scsi_host_tagset_busy_iter()
>   aacraid: use scsi_host_tagset_busy_iter() to traverse outstanding
>     commands
>   dpt_i2o: drop cmd_list usage
>   scsi: drop scsi command list
>
>  block/blk-mq.c                    |  22 +-
>  drivers/scsi/aacraid/aachba.c     | 125 +++---
>  drivers/scsi/aacraid/aacraid.h    |   6 +-
>  drivers/scsi/aacraid/comminit.c   |  28 +-
>  drivers/scsi/aacraid/commsup.c    | 134 +++---
>  drivers/scsi/aacraid/linit.c      | 302 +++++++------
>  drivers/scsi/csiostor/csio_init.c |   3 +-
>  drivers/scsi/csiostor/csio_scsi.c |  48 +-
>  drivers/scsi/dpt_i2o.c            |  23 +-
>  drivers/scsi/fnic/fnic_scsi.c     | 916 ++++++++++++++++----------------------
>  drivers/scsi/hosts.c              |  27 ++
>  drivers/scsi/hpsa.c               | 310 ++++++-------
>  drivers/scsi/hpsa.h               |   1 -
>  drivers/scsi/hpsa_cmd.h           |   1 -
>  drivers/scsi/scsi.c               |   1 -
>  drivers/scsi/scsi_lib.c           |  69 +--
>  drivers/scsi/scsi_scan.c          |   1 -
>  drivers/scsi/snic/snic.h          |   2 +-
>  drivers/scsi/snic/snic_main.c     |   3 +
>  drivers/scsi/snic/snic_scsi.c     | 502 ++++++++++-----------
>  drivers/scsi/virtio_scsi.c        | 100 ++---
>  include/linux/blk-mq.h            |   2 +
>  include/scsi/scsi_cmnd.h          |  12 +-
>  include/scsi/scsi_device.h        |   1 -
>  include/scsi/scsi_host.h          |  17 +-
>  include/scsi/scsi_tcq.h           |  30 ++
>  26 files changed, 1311 insertions(+), 1375 deletions(-)
>


