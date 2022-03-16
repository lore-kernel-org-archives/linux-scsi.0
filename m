Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC11C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Mar 2022 03:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352131AbiCPD0s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 23:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348399AbiCPD0p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 23:26:45 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EABD5EBED
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 20:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1647401131; x=1678937131;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=L+GnZzY8M0I/XRz/k9rzvsh5D6u1YS3DpH4vtLZOaiI=;
  b=Y8z65EOBjtJKrB+Oi1Dp3+fSuxdOTKsSi0MxywuTq4bqoATHfBoq+Qyy
   3wYuvFAtUa/L2R6rJRnkTmwbYlAqON7lCJ5tXVQUs2J1GmDV0pT2GgKL0
   /n4MOoMgSWqPF6/BHAPOudXBz9M3/AMaiYU4hMNZsrXsyOYTM/BnTgypD
   GSH/4LBF9wT65YbEhXKCibZbucS/YXTELIcYkTV6iF4w6UDxt2Mf3fRk6
   9abmY66MebZvKpdu81MAArAh8WvwtetQECbzAVMt4qUdVq+dJZp8ypg/O
   qRD6XxSUNe/VK91uE3W+3zL3ana6MDcMnGY+z79xXalm6LRUO2/pEWUWb
   g==;
X-IronPort-AV: E=Sophos;i="5.90,185,1643644800"; 
   d="scan'208";a="200308293"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2022 11:25:29 +0800
IronPort-SDR: ElxRHFvxesdPdQws4MB6UCHZRNcI9VeblY+jzkwHZ4LGMFUF8jSk7VjhAwoEq4IyU9qynCe4MH
 MrF33rJk+nm6yhTz+GQqFggJvVS+uCQ3kqftLsf442wP9tCByhdWqCOo80F+Byifj/WR/ea2+E
 KdyO6WYCZ8kriDji/l7f9ZNnZTBEBkLvHhwsACK2OoPKnFXhx6o0mpcJVlLymjg2sD0J4FWD/e
 PxEqN7xmRcoeKbF+q9Oib4o1lgvzKhDKlUaTLcndsj4xvzP+zrbHc1HisLIL0FAeOgK9YNW/1p
 IrmpN6JWZWT/QoYnZ6Kjoenc
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 19:57:35 -0700
IronPort-SDR: 2qg+Gx1eAgmd70uWHTAV7ZFNgTKZxuv3tzL57oxLqe7bB9e7ulGpmNjin9YQlkSP6OH8YPLVF9
 r11KKhpYsX+epDk0nEuqrqz0AxdWVRaJVEFz7AMsnmR2FwTcDWC29lJo9uPR+aJfzx1y5GN1j5
 pVRPjaod/8yicN+8wpgqPLDGlSxCl4HTlosDmmuURc/s5dO7Jq/kiM0dMIQcVkm3K/VFFQGEt2
 1vD3DRj7LYjLftqkjWR4IuInZBTe7UhkQbVxB/50Y+HkO4NAqvioEToWOEZzMDbnjl5p9V7EU8
 pI4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 20:25:31 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KJFyy1TGxz1SVp5
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 20:25:30 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1647401129; x=1649993130; bh=L+GnZzY8M0I/XRz/k9rzvsh5D6u1YS3DpH4
        vtLZOaiI=; b=a6NP6rfIbYKzzCdD1KCkb1ko1cxXGtEsXBSKDXag/ihDMR6kKkB
        9KrODKR34lwODKPtD+QyqndXHqPKD2pVjATqX5Hk7gMdrbX6kkZPoPeQv8QrUFFe
        m7a/w5hqhz4l84CWpO8qMdSbpJy6wiK/P0PHVGeeot3T+vnW0bcr6QJdHxkUY3kY
        Q4Zcs8i4CryFHIPwSTENzlOwk9pveuWkfEkii3EUJ3uVQGihT2/PZne7JWQZOodj
        7hIamjK/t6e9WdUJ5KG5cmdUS1a5ySU0eTSxH6CnGf9eGBTHvGHEWFXMnDegDVhD
        MVb/yMSTiX7uJAMCexghRZa85mDAS37rCBA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vvrIbrN1MFtR for <linux-scsi@vger.kernel.org>;
        Tue, 15 Mar 2022 20:25:29 -0700 (PDT)
Received: from [10.225.163.101] (unknown [10.225.163.101])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KJFyv5Vlhz1Rvlx;
        Tue, 15 Mar 2022 20:25:27 -0700 (PDT)
Message-ID: <b77e681d-d180-7434-1675-1fcb10ef4abf@opensource.wdc.com>
Date:   Wed, 16 Mar 2022 12:25:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 0/2] scsi/libata: A potential tagging fix and improvement
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, bvanassche@acm.org,
        ming.lei@redhat.com, hch@lst.de, hare@suse.de
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.wilck@suse.com
References: <1647340746-17600-1-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1647340746-17600-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/15/22 19:39, John Garry wrote:
> Two loosely related patches are included:
> 
> - Fix for scsi_realloc_sdev_budget_map(). I noticed that the budget token
>   for scsi commands was way in excess of the device queue depth, so I
>   think we need to fix the sbitmap depth. I need to test this more.
> 
> - libata change to use scsi command budget token for qc tag for SAS host.
>   I marked this as RFC as for SAS hosts I don't see anything which
>   guarantees that the budget size is <= 32 always.
>   For libsas hosts we resize the device depth to 32 in the slave configure
>   callback, but this seems an unreliable approach since not all hosts may
>   call this.
>   In addition, I am worried that even if we resize the device depth
>   properly in the slave config callback, we may still try to alloc qc tag
>   prior to this - in lun scan, for example.
>   So we need a way to guarantee that the device queue depth is <= 32
>   always, which I would be open to suggestions for.
> 
> John Garry (2):
>   scsi: core: Fix sbitmap depth in scsi_realloc_sdev_budget_map()
>   libata: Use scsi cmnd budget token for qc tag for SAS host
> 
>  drivers/ata/libata-core.c |  5 +++--
>  drivers/ata/libata-sata.c | 21 ++++-----------------
>  drivers/ata/libata-scsi.c |  2 +-
>  drivers/ata/libata.h      |  4 ++--
>  drivers/scsi/scsi_scan.c  |  5 +++++
>  include/linux/libata.h    |  1 -
>  6 files changed, 15 insertions(+), 23 deletions(-)
> 

I tested this and it is working fine for me. This actually solves the QD
not changing problem I had detected with the pm80xx driver.
Now, doing this:

# cat /sys/block/sde/device/queue_depth
32
# echo 16 > /sys/block/sde/device/queue_depth
# cat /sys/block/sde/device/queue_depth
16

is working as expected.

See my comments on patch 2 for getting final ack and tested tags :)

-- 
Damien Le Moal
Western Digital Research
