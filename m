Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDE8C00140
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 15:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238445AbiHLPj2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Aug 2022 11:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbiHLPj0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2022 11:39:26 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC4C6F56A
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2022 08:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1660318765; x=1691854765;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HfDbVX+TcieMwjzkmdCZn/xUf+68QrOPMw9xNsKbV7M=;
  b=SZ7B1bOhXYBpMqfcuCyqSivgsGLvRYz2Fh9g1vyABuRr+Ouf7dWL7xXY
   YUlWwffHHhMt65fMAxzYhGz2lo5iYUq+KhrN1l8d8yp+4pz7+alB+icmM
   T8OVH1NvD5vH0LDZ5seRsNjEFQbctwekbpseWRiYbgOyI4ZmPvjM8vAPi
   mhHjGR59NkM/v8izz9NMDMrlWsKv4a9CtFdLYiLpIdNJAnEU1lLe0lidA
   9dbMMXoGwm0JnZ8jGqIO/d8lecYERFpzv/XfmGgYiY71bpvN9zQeQzt+R
   jd9JZtsJeqQznwsg0RkAokSnMnqRrS3Kx8oOTDTyz7zf60SUFHFOvXDgI
   w==;
X-IronPort-AV: E=Sophos;i="5.93,233,1654531200"; 
   d="scan'208";a="312838376"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Aug 2022 23:39:24 +0800
IronPort-SDR: mvf9kDHP8rrCElYMNKXuVVAOakAaz7WcSYL7TWIw8r61vyGKW9JObHefgy361JAPGV1OtoEe8D
 spXPdrxd1gwGJyjC7j261tUF7GFNsoHw2gJrM1NrxVE9MXKuAld1fVzJHx4Lcp7HulWc6HjZJ9
 ZNNXIIVbCO+RVdipm+tU2VN3YLyY2FFkHiO1JcueN4DCdhHVaEyQtG4TtH/48oa7H2nZoQw1Mx
 M7XW0ENtVH4P+J6L/JvdPjauon4L2FmkXsNCLWyI0aqRhT8ySlTcZkrEoGUewykmWj31BkYkTz
 v8Lncsj88kaburNpnpVK6Wep
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Aug 2022 08:00:17 -0700
IronPort-SDR: clUVOKd3035Y81fmxu0jfPBDPQru+KgfNS+jrh5xIAihUPRmPE+tUcih3LuUJFKT4qgYZEwlws
 Hs0TgB5J6UQPbocYIwP7APPRR8Sok31GYoSay6v5xUAvCbLJY3Y99yHmkyDe3+Oco9rMQULfLY
 xbkwbjA8l2H9KXtHws5K2e/Bwxo1V46npgiJ5SKl2cSPLRTnXWLtmsPnBglePB5L7z2p90rTCt
 22K+rvnI/IfpJg2hlJ7834EULhlLea4Y+HuxQ/JX7e39Rwni3ZOT845VBbm4lQsv3hVJsHxJn+
 Ppk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Aug 2022 08:39:25 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4M47C02h6Mz1Rwqy
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2022 08:39:24 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1660318763; x=1662910764; bh=HfDbVX+TcieMwjzkmdCZn/xUf+68QrOPMw9
        xNsKbV7M=; b=bUNaCb8ns/LeI9ZnNb91U/33lR2uIZLntiVfng8/CPDadLvLpzN
        NMoB52W27xTwQqvDp1arZ670K3uFHc+eGhcFCfx7axi8ng7Y9Bbs5elKh+l8+oiu
        1DGSuOUPWf36fLgo/DcIP4Rxjj4PnTKUnv7NmQRAnoCvfBVNDxjepBelWM4Mr8tL
        X5tZIBalscz+ykOy25C2xr2KtWW0z8zqmij0ddn3p0Spjfy9U1DditqXJsrV5r2l
        s1TcgJAypmBzVK26meHVPxRj7lbHt5WT7cTLoQ6KKjdW5TdJZawPY73t3bLscswF
        StpAo8r9KKlkoLZUyK4JaiTvhnglnqDAaZw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id DQPTkTVsBSob for <linux-scsi@vger.kernel.org>;
        Fri, 12 Aug 2022 08:39:23 -0700 (PDT)
Received: from [10.225.89.57] (cnd1221sqt.ad.shared [10.225.89.57])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4M47By2tW7z1RtVk;
        Fri, 12 Aug 2022 08:39:22 -0700 (PDT)
Message-ID: <15bfd5e0-7fcd-fdee-a546-7720b55eb108@opensource.wdc.com>
Date:   Fri, 12 Aug 2022 08:39:21 -0700
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
 <d2e27cb7-d90a-2f0a-1848-e1ec8faf7899@opensource.wdc.com>
 <437abe43-7ddd-6f49-9386-d8ed04c659bf@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <437abe43-7ddd-6f49-9386-d8ed04c659bf@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/08/12 1:06, John Garry wrote:
> On 11/08/2022 19:54, Damien Le Moal wrote:
>> On 2022/07/22 4:24, John Garry wrote:
>>> As reported in [0], the pm8001 driver NCQ error handling more or less
>>> duplicates what libata does in link error handling, as follows:
>>> - abort all commands
>>> - do autopsy with read log ext 10 command
>>> - reset the target to recover
>>>
>>> Indeed for the hisi_sas driver we want to add similar handling for NCQ
>>> errors.
>>>
>>> This series add a new libsas API - sas_ata_link_abort() - to handle host
>>> NCQ errors, and fixes up pm8001 and hisi_sas drivers to use it. As
>>> mentioned in the pm8001 changeover patch, I would prefer a better place to
>>> locate the SATA ABORT command (rather that nexus reset callback).
>>>
>>> I would appreciate some testing of the pm8001 change as the read log ext10
>>> command mostly hangs on my arm64 machine - these arm64 hangs are a known
>>> issue.
>>
> 
> Thanks for this!
> 
>> I applied this series on top of the current Linus tree and ran some tests: a
>> bunch of fio runs and also ran libzbc test suites on a SATA SMR drive as that
>> generates many command failures. No problems detected, the tests all pass.
>> FYI, messages for failed commands look like this:
>>
>> pm80xx0:: mpi_sata_event 2685: SATA EVENT 0x23
>> sas: Enter sas_scsi_recover_host busy: 1 failed: 1
>> sas: sas_scsi_find_task: aborting task 0x00000000ba62a907
>> pm80xx0:: mpi_sata_completion 2292: task null, freeing CCB tag 2
>> sas: sas_scsi_find_task: task 0x00000000ba62a907 is aborted
>> sas: sas_eh_handle_sas_errors: task 0x00000000ba62a907 is aborted
>> ata21.00: exception Emask 0x0 SAct 0x20000000 SErr 0x0 action 0x0
>> ata21.00: failed command: WRITE FPDMA QUEUED
>> ata21.00: cmd 61/02:00:ff:ff:ea/00:00:02:00:00/40 tag 29 ncq dma 8192 out
>> res 43/04:02:ff:ff:ea/00:00:02:00:00/00 Emask 0x400 (NCQ error) <F>
>> ata21.00: status: { DRDY SENSE ERR }
>> ata21.00: error: { ABRT }
>> ata21.00: configured for UDMA/133
>> ata21: EH complete
>> sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 1 tries: 1
>>
> 
> For this specific test we don't seem to run a hardreset after the 
> autopsy, but we do seem to be getting an NCQ error. That's interesting.
> 
> We have noticed this scenario for hisi_sas NCQ error, whereby the 
> autopsy decided a reset is not required or useful, such as a medium 
> error. Anyway the pm8001 driver relies on the reset being run always for 
> the NCQ error. So I am thinking of tweaking sas_ata_link_abort() as follows:
> 
> void sas_ata_link_abort(struct domain_device *device)
> {
> 	struct ata_port *ap = device->sata_dev.ap;
> 	struct ata_link *link = &ap->link;
> 
> 	link->eh_info.err_mask |= AC_ERR_DEV;
> +	link->eh_info.action |= ATA_EH_RESET;
> 	ata_link_abort(link);
> }
> 
> This should force a reset.

This is an unaligned write to a sequential write required zone on SMR. So
definitely not worth a reset. Forcing hard resetting the link for such error is
an overkill. I think it is better to let ata_link_abort() -> ... -> scsi & ata
EH decide on the disposition.

Note that patch 3 did not apply cleanly to the current Linus tree. So a rebase
for the series is needed.

> 
> Thanks,
> John
> 
>> Seems all good to me.
>>
>>>
>>> Finally with these changes we can make the libsas task alloc/free APIs
>>> private, which they should always have been.
>>>
>>> Based on v5.19-rc6
>>>
>>> [0] https://lore.kernel.org/linux-scsi/8fb3b093-55f0-1fab-81f4-e8519810a978@huawei.com/
>>>
>>> John Garry (5):
>>>    scsi: pm8001: Modify task abort handling for SATA task
>>>    scsi: libsas: Add sas_ata_link_abort()
>>>    scsi: pm8001: Use sas_ata_link_abort() to handle NCQ errors
>>>    scsi: hisi_sas: Don't issue ATA softreset in hisi_sas_abort_task()
>>>    scsi: libsas: Make sas_{alloc, alloc_slow, free}_task() private
>>>
>>> Xingui Yang (1):
>>>    scsi: hisi_sas: Add SATA_DISK_ERR bit handling for v3 hw
>>>
>>>   drivers/scsi/hisi_sas/hisi_sas_main.c  |   5 +-
>>>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  22 ++-
>>>   drivers/scsi/libsas/sas_ata.c          |  10 ++
>>>   drivers/scsi/libsas/sas_init.c         |   3 -
>>>   drivers/scsi/libsas/sas_internal.h     |   4 +
>>>   drivers/scsi/pm8001/pm8001_hwi.c       | 194 +++++++------------------
>>>   drivers/scsi/pm8001/pm8001_sas.c       |  13 ++
>>>   drivers/scsi/pm8001/pm8001_sas.h       |   8 +-
>>>   drivers/scsi/pm8001/pm80xx_hwi.c       | 177 ++--------------------
>>>   include/scsi/libsas.h                  |   4 -
>>>   include/scsi/sas_ata.h                 |   5 +
>>>   11 files changed, 132 insertions(+), 313 deletions(-)
>>>
>>
>>
> 


-- 
Damien Le Moal
Western Digital Research
