Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3922BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 09:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343897AbiF1JOc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 05:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344080AbiF1JOb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 05:14:31 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1095E101E6
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 02:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656407670; x=1687943670;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m7ZvDnvdd5GvaUmk2CDtIh9qIt0xOE1YKhnPo7clhXk=;
  b=JdtiMJxH2i+YBxQ7LFELvkY6Zqis4RI80+QeG31R0TtKyF+zI83CPvD6
   QsxzysAxuTL/mPKbqghqmR1YveXK9WMajMiHYPqQqQcp144Iy4FReGFas
   ijbb0X/lySvZ6xZ0x5liZhzkRxlMvLeWe/qHI+5T49byVazFX7qhVQ7vM
   tRIUUNS7Xtbz1f4qaAdk9o1oDlZU4XIkTq9gDvRW++YPeyHerfbwGr+in
   toixMvjTJdxsEZGpW5LJGLbuf8dr6yg0g+oXzhAJRfXVtsL6oFxsCFVL6
   MVb69iboGoja+76Y3ndXRspz/PuL8LyzPEMz2y8c+njXGCbQWChXOaCcU
   A==;
X-IronPort-AV: E=Sophos;i="5.92,227,1650902400"; 
   d="scan'208";a="202954158"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jun 2022 17:14:30 +0800
IronPort-SDR: 68HwiV+AoqZfbTN89jMUWuCEComBi6SndpkevJQe73bjRGsCq0juVQgXeoLWfONfnDmtqvxaRD
 AhVi50FwwzTaAubZ7Iiz0pKJfzDKjH9VJkKRm1W/50/ISGdrR3RtlofwCNR2CdDQ+bXRm3kaT/
 Sy5I1+JEjIQoBj/CDMN/3xWUy+SL3rLEtl0rx//KKBNQCLtErq+9YHxODla0vRxCEIg2IsIEZm
 PCxiq1+fNQHsfZiIddmSNfjeJszji+PqDax32EXbu12KwIlbaUKptdVsoYxUwfC5ww26bBFRoX
 YeRctAhN2vqTzFo6FoO+DTMU
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jun 2022 01:32:10 -0700
IronPort-SDR: 2IuUkCaO4JainA8W9RM3nEAwbUcD8vIOiIhXCf3KuQjue8Z3je3hkxqsheKX9uUdpKd5bjuR9V
 ATysXjthE1CYyymyuGi6uhX+dVPeS2a9BUxlH8sWq3f32X73og1TEbWHeewhHWi2yzP6qKpTyy
 /e0IkrqK4hhMOoQ0Ib+TRqMef+GA/JC5eBn4UZLOj7mZFyqsTnTVTcRJQ+7wpWxc9Vv4H/5vr/
 UMkc0qPh99iUd4/jkBmA/3tuXuq88yNUXbYArEI6B6yqUdAlFicUg/NyuZgAXBjt5ZMPn0gtYV
 iCU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jun 2022 02:14:30 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LXJnd53dVz1Rwry
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 02:14:29 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1656407669; x=1658999670; bh=m7ZvDnvdd5GvaUmk2CDtIh9qIt0xOE1YKhn
        Po7clhXk=; b=n1Hpc6gcPs/kxiOVTQwyRGR+uFdty2ur8mMpVtR58Kwy2fqXmbI
        HTEscATaBiYXrvQoDsewN6VCSm9M5MIlpqKcq/8hTcw3cjPO33agP8Xd57Tj6DFz
        4R0ljR0v+eB5w4pbvmsQ5m12TQNrFyNz/lIFaUH0ktaZyNqS0r6+dYb80iSY2vIS
        eAjGfzucNGjkx5UDxGIgv1ZF4t8Y8uxziilTeI0bERjb3d5G2iyT+xB/TWonmtz9
        zODt5GChELx+M4SuiD3Cm4Kcm8I7M51ZXMYbgEjMRtCnihX/D9URy755F6CYUCq9
        +ysvrOnAro+PSPbYDdtqx2RasqndSuvPycw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qm913GYF01ki for <linux-scsi@vger.kernel.org>;
        Tue, 28 Jun 2022 02:14:29 -0700 (PDT)
Received: from [10.225.163.99] (unknown [10.225.163.99])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LXJnZ4JQfz1RtVk;
        Tue, 28 Jun 2022 02:14:26 -0700 (PDT)
Message-ID: <ba59a0da-a982-e3eb-1cb7-6e60f80fd319@opensource.wdc.com>
Date:   Tue, 28 Jun 2022 18:14:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 5/5] libata-scsi: Cap ata_device->max_sectors according
 to shost->max_sectors
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, joro@8bytes.org,
        will@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, iommu@lists.linux-foundation.org,
        iommu@lists.linux.dev, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com
References: <1656343521-62897-1-git-send-email-john.garry@huawei.com>
 <1656343521-62897-6-git-send-email-john.garry@huawei.com>
 <b69c6112-98b7-3890-9d11-bb321a7c877a@opensource.wdc.com>
 <6619638c-52e8-cb67-c56c-9c9d38c18161@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <6619638c-52e8-cb67-c56c-9c9d38c18161@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/28/22 16:54, John Garry wrote:
> On 28/06/2022 00:24, Damien Le Moal wrote:
>> On 6/28/22 00:25, John Garry wrote:
>>> ATA devices (struct ata_device) have a max_sectors field which is
>>> configured internally in libata. This is then used to (re)configure the
>>> associated sdev request queue max_sectors value from how it is earlier set
>>> in __scsi_init_queue(). In __scsi_init_queue() the max_sectors value is set
>>> according to shost limits, which includes host DMA mapping limits.
>>>
>>> Cap the ata_device max_sectors according to shost->max_sectors to respect
>>> this shost limit.
>>>
>>> Signed-off-by: John Garry<john.garry@huawei.com>
>>> Acked-by: Damien Le Moal<damien.lemoal@opensource.wdc.com>
>> Nit: please change the patch title to "ata: libata-scsi: Cap ..."
>>
> 
> ok, but it's going to be an even longer title :)
> 
> BTW, this patch has no real dependency on the rest of the series, so 
> could be taken separately if you prefer.

Sure, you can send it separately. Adding it through the scsi tree is fine too.

> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
