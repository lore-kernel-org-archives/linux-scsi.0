Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743E3C6FA82
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Sep 2022 04:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiIUEFF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Sep 2022 00:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiIUEFD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Sep 2022 00:05:03 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D21161116
        for <linux-scsi@vger.kernel.org>; Tue, 20 Sep 2022 21:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1663733102; x=1695269102;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=svKOck3oyqxOGmX/wIBYWDNycIDz93EQP6gWTNu82pc=;
  b=dZWootTqBDdnH5m15fYmp0FOq5z+yFodSQNlf7P4K2FATPYNQBu7Sxve
   iB7Xbj8tXKRXWmvaUCYGzjKjk0wokTbVQlprshLknZwIgnFwaW1v6DqRi
   t/kLPV6PN7DDOEbfVL0FPeUPQl9u3PZitvKYWFl0alPgPVTjk8AtP0LHB
   tZm2eqYZwpI63ukNJ9G3aDXFrYJgr6/4IkAXwl11nRjAE5l1vxpkzduMh
   QRz9nt9jmDCKaPQih9rLpq5D6ZP8cgXVu9Sr/+TUySCUYXvMzxeQILC4O
   F7AwctZ8AR3ZbjpirKuqopFc1E3AZEqp+nU30Zaqup7zOCepR8xIGs+A3
   A==;
X-IronPort-AV: E=Sophos;i="5.93,332,1654531200"; 
   d="scan'208";a="316158379"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Sep 2022 12:04:59 +0800
IronPort-SDR: aIve2q054YKycEFKnSzpRkDJhSu7tCHx2FWE6xxOR98Y8RQYGyHIF+kZ90k5xYy/wKttvcUb0P
 9q2x1h5v1XCYIaFMj4HEtVUCDShjrnkhhg7YAkItsYEmNzqudbIZEqIicuKN2UTA+d+XZW7waH
 XMcg0CHpFymzfNs0B/zYltkYM4rnRC0SirKsqIBRsLVOoz2u8BFw0Jw6YuOwfhDoWn+AlpSnDS
 RRTiwAZ6m/SWkTbu8jKOPHw2HOx9JZCSajwp2OqONQxMblRF+J2uGU5yGyP2CFpVTFyt1vGYLF
 n8NvcJZX90us4teznfwYAZvm
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Sep 2022 20:25:04 -0700
IronPort-SDR: c2YjSbI0jqxO0H8z4NtpHTZL75R0z17oHC5G3Nuc2mGigYlncsubnp17HxASKIoWFItrHRrJH7
 NbkHfQ4skzZclTbVhPmEIsYoNN3U25wDlP5Irr96Lw7hACHtxH01VbZf8LURWYznyrOaouVpRd
 Ii0U8F+MTkO7lZ5UOICo8I6uUggd9J7aUnmxiMzBJgHvSNtJRq7AFouW2fmG54MyJPLDYXkMCU
 8BkchQpy6dgE6DEgyRJ77Tgzm9Tq99EkxaERQ8GudTVGNEN0OoGNjN97rIt6an/tCfEomWjq46
 N24=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Sep 2022 21:05:00 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MXPvG70y9z1Rwtm
        for <linux-scsi@vger.kernel.org>; Tue, 20 Sep 2022 21:04:58 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1663733098; x=1666325099; bh=svKOck3oyqxOGmX/wIBYWDNycIDz93EQP6g
        WTNu82pc=; b=cNiO4y5MwHm7QceJhqfX1yJLF6V/01fLp34oiAA1oBv5pq4qqUz
        qQKs8z+1hVWuQAsVXCI3GUyO5jJMRVQkG7UGznWRtdBFIvIPklqXM/js4yjqS0cQ
        UIAXdJqf2D08e7qX3l3nl2/aJSl0/mp6jK1IcmQ/8BxBFMwc8njxWAwMWmYtkNbB
        dnxFyP2W8n6n/PE1JgbuPuj4KTYhEHc2+64cbSsLt/+Ez1eeM5wso8/w2Ekc2jMe
        ocEYCBvs1zd335osegG2+E/yZ6RQn2vB07MOcXFUMaa3IDpxIgqsJgHFNmhzdOX6
        WcQaDYPZZTdjxE6d3mDU2UqDbHtSSYFpjFA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Q68cNWHJ-TVg for <linux-scsi@vger.kernel.org>;
        Tue, 20 Sep 2022 21:04:58 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MXPvB5DRZz1RvLy;
        Tue, 20 Sep 2022 21:04:54 -0700 (PDT)
Message-ID: <40b9e090-5ba3-1191-4fe9-80467284ae72@opensource.wdc.com>
Date:   Wed, 21 Sep 2022 13:04:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH RFC 0/6] libata/scsi/libsas: Allocate SCSI device earlier
 for ata port probe
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hare@suse.de, hch@lst.de
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, brking@us.ibm.com
References: <1663669630-21333-1-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1663669630-21333-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/20/22 19:27, John Garry wrote:
> Currently for libata the SCSI device (sdev) associated with an ata_device
> is allocated when the port probe has completed.
> 
> It's useful to have the SCSI device and its associated request queue
> available earlier for the port probe. Specifically if we have the
> request queue available, then we can:
> - Easily put ATA qc in SCSI cmnd priv data
> - Send ATA internal commands on SCSI device request queue for [0]. The
>    current solution there is to use the shost sdev request queue, which
>    isn't great.
>    
> This series changes the ata port probe to alloc the sdev in the
> ata_device revalidation, and then just do a SCSI starget scan afterwards.
> 
> Why an RFC?
> 1. IPR  driver needs to be fixed up - it does not use ATA EH port probe
>     Mail [1] needs following up

Yes. If IPR could be converted to ata error_handler, a lot of code can 
be simplified in libata too.

> 2. SATA PMP support needs verification, but I don't have a setup

Port multiplier behind a sas HBA will be challenging to setup :)
I can try, but I will need to open up one of my servers and hook a small 
PMP box to one of the pm8001 plugs. I may have the cables for that... 
Let me check.

> 3. This series needs to be merged into or go after [0]
> 
> Patch 1/6 could be merged now.
> 
> [0] https://lore.kernel.org/linux-ide/1654770559-101375-1-git-send-email-john.garry@huawei.com/
> [1] https://lore.kernel.org/linux-ide/369448ed-f89a-c2db-1850-91450d8b5998@opensource.wdc.com/
> 
> Any comments welcome - please have a look.
> 
> Based on v6.0-rc4 and tested for QEMU AHCI and libsas.
> 
> John Garry (6):
>    scsi: core: Use SCSI_SCAN_RESCAN in  __scsi_add_device()
>    scsi: scsi_transport_sas: Allocate end device target id in the rphy
>      alloc
>    scsi: core: Add scsi_get_dev()
>    ata: libata-scsi: Add ata_scsi_setup_sdev()
>    scsi: libsas: Add sas_ata_setup_device()
>    ata: libata-scsi: Allocate sdev early in port probe
> 
>   drivers/ata/libata-eh.c           |  4 +++
>   drivers/ata/libata-scsi.c         | 45 +++++++++++++++++++++----------
>   drivers/ata/libata.h              |  1 +
>   drivers/scsi/libsas/sas_ata.c     | 20 ++++++++++++++
>   drivers/scsi/scsi_scan.c          | 28 ++++++++++++++++++-
>   drivers/scsi/scsi_transport_sas.c | 25 +++++++++++------
>   include/linux/libata.h            |  2 ++
>   include/scsi/scsi_host.h          |  3 +++
>   8 files changed, 105 insertions(+), 23 deletions(-)
> 

-- 
Damien Le Moal
Western Digital Research

