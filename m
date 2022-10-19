Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D75FC43217
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 05:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiJSFEG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 01:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiJSFEE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 01:04:04 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B725FAE5
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 22:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666155843; x=1697691843;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IXFGa6cKv7zc3KOCLo6p+PYc9vtKbDc98W1hcgLuLj8=;
  b=HZYOW/6Fo1XZ4b6OTTVTUUx1slcuWCW3OIqpZdxUdaJx4hAR5J8e5cmu
   PfVtl2EQt2kOdBk+gGndM1MqGZfCrwlHyHqEZmaWS6ko6A1kjAdht37Pt
   hykOW2ffgq58KxgXU8MW/lead++5FZkJOKo2roeKt6TnvwjmmimCcEbdt
   5cjsj4sM1r20H19705Uufs2hlWs4ezgg5r755k49Wt7zsxinKYkAG45IS
   blRmW7Nw7zbGhE4Z9gzp8kEYGTD0zs+QVWqziEhCr6a6YWE+C5qb6RvzM
   5OtJdthw3O/U+usaI5WjYkSPMcDcWfDTEaWAFvNXn0r1IeVKwrT0uqPCt
   g==;
X-IronPort-AV: E=Sophos;i="5.95,195,1661788800"; 
   d="scan'208";a="212511972"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Oct 2022 13:04:00 +0800
IronPort-SDR: ZnOJkTIaU0bBnSjD3S/HaLO7legMP7uzYRzSwTF/bH4A3gFDKk/tJurBZBzUBBiOoaEtQONT2H
 4Nr23Ly0RjmH1uTJm8AAUImcNC16IKwQ3VD+CAyn+9Bl6nkigLFcRSy0//4aSIDNJVcssU4JA5
 KWORVB0h+7/LQBom8CaUxjX/lRPIO5+hoNhgn5BpcjxG5hDOsrjt+uUQREaS8YOMTG/SEKKdtW
 KfPe8Un3JCJUsY9TB4rKSXxUWW+fdFPapSTeHm7OXCa9BWUX6w3lpQrJO8v2InBUzmzq4bHSor
 Q8/CnmGW5DYSRSua76de0f4G
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Oct 2022 21:17:52 -0700
IronPort-SDR: 9IABfn2N4C9PesPDObllRXN9Fx4csK2lcHXzYUFn6+Gh3HpIfoskj+cTNxI3SM2sm/FW4EyuRZ
 Q8YdNeo1hdP+MsBRz5DhUr6pgH3hCXYO7SSPhZ9Sj4m9rAz2xxPILEwLeLycKJOyLo6L9/zWkl
 6uaELS5b+Ftq288FRtb5vhxc/9lMZO1uqile1o3vsVI21hnntICvI858oD+E9fPxVodScD2b/I
 0b8LMgBOjB/xDp5fXSflwJMSBwqE6zSbhup4M3+j5+51+5G0vIHzUZEzvBCXrrSUtEH4jifWOh
 wC8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Oct 2022 22:04:01 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MsdtS17zwz1Rwt8
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 22:04:00 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1666155839; x=1668747840; bh=IXFGa6cKv7zc3KOCLo6p+PYc9vtKbDc98W1
        hcgLuLj8=; b=GhlzFq0DzAEq5npbsmPo5adTGs+8ETlLNTu39hKeX0tlpMLBDUT
        vILgqS82CQWnxIQIZz2vWmCrUy+De2PUiz2mYsB5cLIOBYWOkgRbfAK+xgKcDTJD
        +eDjO1dUkG279i75g7ymLSQukcYZmVwAxdt51gFcoMAS4m93I/vDpYql+QcJjA8I
        UKbVrwYYRXmA/227ECTyI9+qWPXtgtZV+0K2RKUNQ55y9KtHBLPZcvSpRl8jniSH
        881Xgw9ILYhgmHZwrq9aAbz+xiDIvurE9PEXsaNNt1eeSv9yWzB8bEoGG97HFdmd
        AV0XGTm4hUitFBuw05qYRB2PPPUSCMcdJOQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HFNZrAkqXPT2 for <linux-scsi@vger.kernel.org>;
        Tue, 18 Oct 2022 22:03:59 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MsdtQ3dS9z1RvLy;
        Tue, 18 Oct 2022 22:03:58 -0700 (PDT)
Message-ID: <7e8ef4b4-928f-895f-05ef-df111a052e8e@opensource.wdc.com>
Date:   Wed, 19 Oct 2022 14:03:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: libata and software reset
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
References: <046e86d2-17e1-e85d-08a1-744ef975171c@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <046e86d2-17e1-e85d-08a1-744ef975171c@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/18/22 22:24, John Garry wrote:
> Hi guys,
> 
> In the hisi_sas driver there are times in which we need to issue an ATA
> software reset. For this we use hisi_sas_softreset_ata_disk() ->
> sas_execute_ata_cmd() -> sas_execute_tmf(), which uses libsas "slow
> task" mechanism to issue the command.

Something is wrong here... The reset command sent by that function is
for ATAPI (DEVICE RESET command). There is no device reset command for
SATA disks following the ACS standard.

So hisi_sas_softreset_ata_disk() seems totally bogus to me, unless you
have a CD/DVD drive connected to the HBA :)

This is why the softreset function is a port operation defined by LLDs.
How you reset the device depends on the adapter. E.g., for AHCI, you
need to send a host2device FIS with the software reset bit set.

> 
> I would like if libata provided such a function to issue a software
> reset, such that we can send the command as an ATA queued command.
> 
> The problem is that often when we would want to issue this software
> reset the associated ata port is frozen, like in ATA EH, and so we
> cannot issue ATA queued commands - internal or normal - at that time.
> 
> Is there any way to solve this? Or I am just misunderstanding how and
> when ATA queued commands can and should be used?
> 
> I assume that ata_port_operations.softreset callback requires a method
> to be able to issue the softreset directly from the driver, like
> ahci_softreset() -> ahci_do_softreset() -> ahci_exec_polled_cmd().
> 
> Thanks,
> John

-- 
Damien Le Moal
Western Digital Research

