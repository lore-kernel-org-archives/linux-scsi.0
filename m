Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8963CC25B08
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Aug 2022 15:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237220AbiHQPxF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Aug 2022 11:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbiHQPxC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2022 11:53:02 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB499C1FA
        for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2022 08:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1660751580; x=1692287580;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1GWE7vy/GU+GxOihGG1AQ+L7I/enLfcn/0bM+JDtR7s=;
  b=NiQIvRGUz+91jl/tTcEvP7MZgrtTGy95h8MXkWTuWzf2b05BVtjGTZS2
   K9kjize5AuKk6Ua5j7ysPaicNzP+UsXN7h/CVE4jNEj7FS4RxmiqXqtdZ
   OnRAG6dfKoPSZO8zYcCvRJCh7RDm2mTJdEE0D3/pH0IyHkX20eEWNa/Br
   7PRZutw6SZeJMXQmR7SyPDNf7rLdv/zP6vnbnlWPYldJnJQjsUtfOe2Mt
   NlwWq0PKEgcxznQvCuJnThS3R9tZqBnOYZzWzEcX4QanYeu/Jx/BY+kJA
   5cyGqcyt3owiUpHfFWbGAtCKicdBm/NlRo6q7X6OGNETQVFG3wBcVM0Qo
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,243,1654531200"; 
   d="scan'208";a="214053651"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Aug 2022 23:52:59 +0800
IronPort-SDR: UZZ5w1NpeG+HTTyjrqGa8P/2azP3/vqQ5izZIgOlhOdHaU2VxMzx4pCDx75wx6Sp/XLEjUmpc2
 qdfiC1wtA6Eo9d24Jn3oMe9mwewUR8cHeAyGQVBMHryV22Ioq9OwqfmG/lg0WqG/eleGwuhQQu
 ibBUaMybygMHsEOo5WA5wXmSx6Ore+Qr83G39epO3AneFod/3JO9U/GF61QhgdhQ9p3tdWIjuP
 D9tduV5XXHZIJ7kqVia6tjQXRlUhM3yDTrDHeW/aXSfcwcDsKT3ghh9r19Qu/ehQYRTvQWY3sG
 IgUEhCzL+Uav70s3r7zrLf/5
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Aug 2022 08:13:46 -0700
IronPort-SDR: nS9cZJ+pOyu2MVLMyU/P0toHIu3IGffZ/bJZWC+ynU8qTHRi1uHJZhFhRm2ZAhSAbKi78HNHK3
 O3OUfBFoEjgcs+VQFhnU80TeZu5XjEZ/LyqQPp4+pfojQoUwdRUJp9bnk/P33teaxwwwqvTO2l
 WGThedjDNGz64oMk36gLpLZOLp7/N7T3QbFnxuNr2Fu4N9E6MJ4avFhv2t+NZzX5Ta8uq3JvnO
 k07eOAwMLH1UMsC7nRWVCnZSHCJQEHodLuIQq9fOWrMMjvAbbfdI0PiEk3/gDF9k5Jn0GLcguP
 ZWA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Aug 2022 08:53:00 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4M7CGM2K7bz1Rwnx
        for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2022 08:52:59 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1660751578; x=1663343579; bh=1GWE7vy/GU+GxOihGG1AQ+L7I/enLfcn/0b
        M+JDtR7s=; b=c48fjmOxUozA1ugSnw7GiZja0C/YyyKdjM/5pPIw/39aS+fCzwE
        osgor6d5oGTx6gcshxg3MYNgHbnt7/G7dOulP1oBqq5duqFxXXDWsChQT8BfCEOR
        Rd9ZWBKpJYpMOp9WY7v2QDhSOW2nxi9ohC8Yx6hJJtkat/2EKqlzyVPqRwmGCeQc
        c1ZsTFfIqWwYIYpOrKAsYTONMGSf+APdIXU47+i8WjVi0i8y4/8hqA5S/7zULd2u
        2i2tBlHLjLchzCfFzKBkHOqTR/piSX4/kFtgdCz7U8b79B0Gw5LyRR8wElWHm9NU
        2veW5sSVxLsY/LJBCpYNxBtaU81wk6LJxZA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8ZVzr88RcLQh for <linux-scsi@vger.kernel.org>;
        Wed, 17 Aug 2022 08:52:58 -0700 (PDT)
Received: from [10.11.46.122] (unknown [10.11.46.122])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4M7CGL05CWz1RtVk;
        Wed, 17 Aug 2022 08:52:57 -0700 (PDT)
Message-ID: <e1efeb1b-a876-a5c4-a8af-b30883c8457d@opensource.wdc.com>
Date:   Wed, 17 Aug 2022 08:52:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH v2 0/6] libsas and drivers: NCQ error handling
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, jinpu.wang@cloud.ionos.com,
        yangxingui@huawei.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, hare@suse.de
References: <1660747934-60059-1-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1660747934-60059-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/08/17 7:52, John Garry wrote:
> As reported in [0], the pm8001 driver NCQ error handling more or less
> duplicates what libata does in link error handling, as follows:
> - abort all commands
> - do autopsy with read log ext 10 command
> - reset the target to recover
> 
> Indeed for the hisi_sas driver we want to add similar handling for NCQ
> errors.
> 
> This series add a new libsas API - sas_ata_device_link_abort() - to handle
> host NCQ errors, and fixes up pm8001 and hisi_sas drivers to use it. As
> mentioned in the pm8001 changeover patch, I would prefer a better place to
> locate the SATA ABORT command (rather that nexus reset callback).
> 
> Damien kindly tested the v1 series for pm8001, but any further pm8001
> testing would be appreciated as I have since tweaked
> sas_ata_device_link_abort(). This is because the pm8001 driver hangs on my
> arm64 machine read log ext10 command.

I will run more tests with this series.

> 
> Finally with these changes we can make the libsas task alloc/free APIs
> private, which they should always have been.
> 
> Based on v6.0-rc1
> 
> [0] https://lore.kernel.org/linux-scsi/8fb3b093-55f0-1fab-81f4-e8519810a978@huawei.com/
> 
> Changes since v1:
> - Rename sas_ata_link_abort() -> sas_ata_device_link_abort()
> - Set EH RESET flag in sas_ata_device_link_abort()
> - Add Jack's Ack tags
> - Rebase
> 
> John Garry (5):
>   scsi: pm8001: Modify task abort handling for SATA task
>   scsi: libsas: Add sas_ata_device_link_abort()
>   scsi: pm8001: Use sas_ata_device_link_abort() to handle NCQ errors
>   scsi: hisi_sas: Don't issue ATA softreset in hisi_sas_abort_task()
>   scsi: libsas: Make sas_{alloc, alloc_slow, free}_task() private
> 
> Xingui Yang (1):
>   scsi: hisi_sas: Add SATA_DISK_ERR bit handling for v3 hw
> 
>  drivers/scsi/hisi_sas/hisi_sas_main.c  |   5 +-
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  22 ++-
>  drivers/scsi/libsas/sas_ata.c          |  11 ++
>  drivers/scsi/libsas/sas_init.c         |   3 -
>  drivers/scsi/libsas/sas_internal.h     |   4 +
>  drivers/scsi/pm8001/pm8001_hwi.c       | 194 +++++++------------------
>  drivers/scsi/pm8001/pm8001_sas.c       |  13 ++
>  drivers/scsi/pm8001/pm8001_sas.h       |   8 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c       | 177 ++--------------------
>  include/scsi/libsas.h                  |   4 -
>  include/scsi/sas_ata.h                 |   5 +
>  11 files changed, 133 insertions(+), 313 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research
