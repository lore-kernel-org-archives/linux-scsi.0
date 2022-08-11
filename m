Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81AE2C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 18:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbiHKSy4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 14:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236123AbiHKSyy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 14:54:54 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F4E9F0D8
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 11:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1660244093; x=1691780093;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JAaAJR7wc67hy6jnXKsnD5CiFky15y0MQprEMGqEB0E=;
  b=T1IHhYMHNOXGRllcyUxMr9qk9iluT+Szp9etJfexBRLX3+CQfLpTly2H
   oMTeviQXLdZ1wkFhNtjUlLeEHX7nqyDHznv7qEExOeg1cnWr5sSdUl9V4
   sxFx9Lec/1tCFN8EDfDxvK5P9oymOGi5m9tV2hvgznXIRplC1dQe53UoD
   duIT5YHAPuo3FABpgN5Rbov9nfFtiwFl1UiCMhXTdvQdFOYb7URIjpo4R
   JAiBQeYGXwaRweAmNPCT0bGx9Tvy8rMput1/2+VhyBz7p58lVvKk6QFDC
   RRWOcLkB2zS93QXX0DAJUt7Hrd3qy2dK4i0EO/Hr6JOrlkg0rZr6dDabD
   w==;
X-IronPort-AV: E=Sophos;i="5.93,230,1654531200"; 
   d="scan'208";a="206969517"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Aug 2022 02:54:52 +0800
IronPort-SDR: PaE4AdsbPPnw1SD6ZZzI4s8dORY206IAAYrYczcryUJpYYQyTRy5G2o8flN0zPvhsfY1k6A0r9
 Vt7/XtvQP3p2lEUBCjVDkdjQqS8OFAGMTwVsPWeLK7zx5J+n8Cwktj48KVMhpVvjlgpI9SrWjd
 hyHOHybZYv9Vr6SkgPrl5i2kWP0DFcBums0iRBx2RnCIAzUhuyhr2zyhy0BOk1vn79uKbRWErb
 gfAp3vn28vowwHafQeTk4hP93w30EEkEbjCSJL4k9tjsnmc2SRzsfmmZyJkpf6SURqfiS7B3hk
 +HWWwsFAGrvzV9KpxTaWRc0R
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Aug 2022 11:10:26 -0700
IronPort-SDR: NZYFyKZkuLW6b5W490B6QHnA86OkmJVibMJ2sCElMrkAUAaqomoefIms24R5N2j6rArIQ5kc6e
 zG7tEggjPIEY5w+CclNY7P8Kk1orWvt7uBtWHnptyGdALjVBHRo1LXR2t0yTjA267ItsDNWnSo
 OG3s0xKg0iOXrllRCwp6zyA15BKasmRst1QPKtOVNbOuVI1FXZ18/ppFxackTY5YwyPm1GtQzZ
 XAmRcmqoK9UiDr8BBD2bsgdXH25am8uRP7nAQfAIDnWj0s96h3SvyRg/UJ0FeG8lobGaH38ICx
 V1w=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Aug 2022 11:54:53 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4M3bZz661hz1Rwry
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 11:54:51 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1660244091; x=1662836092; bh=JAaAJR7wc67hy6jnXKsnD5CiFky15y0MQpr
        EMGqEB0E=; b=GLOohb2nCQUpcM2LGrY1E9hzZsSYZyzMaQH+mqnC1ZrTbrH8gfp
        M+pGt7DvexoYtiVDkN2oa8TXukc92f87cx8r8fqHqt1FXGm8tj96u4SOrlAMSAAf
        ebkFq49d5l1LP5SlEUcI3M72yHfGT0LihnOFGtFuMHFIFKlMV65v+hyc6qO6Gwpc
        Zkjoq/NqhEDXWVAcc0zxcdmQ003tdOzL4HXvmIFTa8ac6DPEo0O4rK2P9ZmoDNax
        gLUP7Oouqjdd2tbKdWYlhwdvKGi/zacwelKlQbXnKrp2FdghIDzKlhGOltU6QboE
        w1FK1zAek63UZEWFURcLgME2iV58GryDfpw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id P3lwTQs0N16y for <linux-scsi@vger.kernel.org>;
        Thu, 11 Aug 2022 11:54:51 -0700 (PDT)
Received: from [10.11.46.122] (c02drav6md6t.sdcorp.global.sandisk.com [10.11.46.122])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4M3bZy3NGDz1RtVk;
        Thu, 11 Aug 2022 11:54:50 -0700 (PDT)
Message-ID: <d2e27cb7-d90a-2f0a-1848-e1ec8faf7899@opensource.wdc.com>
Date:   Thu, 11 Aug 2022 11:54:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH 0/6] libsas and drivers: NCQ error handling
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, jinpu.wang@cloud.ionos.com,
        yangxingui@huawei.com, chenxiang66@hisilicon.com, hare@suse.de
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1658489049-232850-1-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1658489049-232850-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/07/22 4:24, John Garry wrote:
> As reported in [0], the pm8001 driver NCQ error handling more or less
> duplicates what libata does in link error handling, as follows:
> - abort all commands
> - do autopsy with read log ext 10 command
> - reset the target to recover
> 
> Indeed for the hisi_sas driver we want to add similar handling for NCQ
> errors.
> 
> This series add a new libsas API - sas_ata_link_abort() - to handle host
> NCQ errors, and fixes up pm8001 and hisi_sas drivers to use it. As
> mentioned in the pm8001 changeover patch, I would prefer a better place to
> locate the SATA ABORT command (rather that nexus reset callback).
> 
> I would appreciate some testing of the pm8001 change as the read log ext10
> command mostly hangs on my arm64 machine - these arm64 hangs are a known
> issue.

I applied this series on top of the current Linus tree and ran some tests: a
bunch of fio runs and also ran libzbc test suites on a SATA SMR drive as that
generates many command failures. No problems detected, the tests all pass.
FYI, messages for failed commands look like this:

pm80xx0:: mpi_sata_event 2685: SATA EVENT 0x23
sas: Enter sas_scsi_recover_host busy: 1 failed: 1
sas: sas_scsi_find_task: aborting task 0x00000000ba62a907
pm80xx0:: mpi_sata_completion 2292: task null, freeing CCB tag 2
sas: sas_scsi_find_task: task 0x00000000ba62a907 is aborted
sas: sas_eh_handle_sas_errors: task 0x00000000ba62a907 is aborted
ata21.00: exception Emask 0x0 SAct 0x20000000 SErr 0x0 action 0x0
ata21.00: failed command: WRITE FPDMA QUEUED
ata21.00: cmd 61/02:00:ff:ff:ea/00:00:02:00:00/40 tag 29 ncq dma 8192 out
res 43/04:02:ff:ff:ea/00:00:02:00:00/00 Emask 0x400 (NCQ error) <F>
ata21.00: status: { DRDY SENSE ERR }
ata21.00: error: { ABRT }
ata21.00: configured for UDMA/133
ata21: EH complete
sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 1 tries: 1

Seems all good to me.

> 
> Finally with these changes we can make the libsas task alloc/free APIs
> private, which they should always have been.
> 
> Based on v5.19-rc6
> 
> [0] https://lore.kernel.org/linux-scsi/8fb3b093-55f0-1fab-81f4-e8519810a978@huawei.com/
> 
> John Garry (5):
>   scsi: pm8001: Modify task abort handling for SATA task
>   scsi: libsas: Add sas_ata_link_abort()
>   scsi: pm8001: Use sas_ata_link_abort() to handle NCQ errors
>   scsi: hisi_sas: Don't issue ATA softreset in hisi_sas_abort_task()
>   scsi: libsas: Make sas_{alloc, alloc_slow, free}_task() private
> 
> Xingui Yang (1):
>   scsi: hisi_sas: Add SATA_DISK_ERR bit handling for v3 hw
> 
>  drivers/scsi/hisi_sas/hisi_sas_main.c  |   5 +-
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  22 ++-
>  drivers/scsi/libsas/sas_ata.c          |  10 ++
>  drivers/scsi/libsas/sas_init.c         |   3 -
>  drivers/scsi/libsas/sas_internal.h     |   4 +
>  drivers/scsi/pm8001/pm8001_hwi.c       | 194 +++++++------------------
>  drivers/scsi/pm8001/pm8001_sas.c       |  13 ++
>  drivers/scsi/pm8001/pm8001_sas.h       |   8 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c       | 177 ++--------------------
>  include/scsi/libsas.h                  |   4 -
>  include/scsi/sas_ata.h                 |   5 +
>  11 files changed, 132 insertions(+), 313 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research
