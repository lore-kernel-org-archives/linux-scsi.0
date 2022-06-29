Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5D7C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 05:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiF2F6a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 01:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiF2F63 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 01:58:29 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB9A140FE
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 22:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656482306; x=1688018306;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=S274m18N48qoB/3JOPWD2zir1wX7NK811KrJ3AY/WxM=;
  b=BTXXQSWyDe6HvkXj5H+CWe6mw5b6X3XoqYP04XWL6+hgUWkcCIAIuiOo
   dxzuPvw8srKtU3jgFgjdafBmRrHli2VH+/EKoW+TDhHVU9wPlKRC5jwZl
   QYci6P8GjpB/p2DVYdcmXTItFoBHaHiUtSsEPKGyvjEVJRZOBI9Xsxi46
   KjiylMq9C4suoMa4CiS6shSbWAbfDlFSTrBpvmlZUjlVdr2M2mF1xsW0Z
   Fgek63YdZtuFL2eyhc7qgaIfe2B1H/1NZnIb1Hb98LnxydRk6Os3sy39W
   htMVcQjwaKKnKn9MsunMvAkg5goRe46pZ4wsx8bvAU0/Jf23Pa3++rl/e
   w==;
X-IronPort-AV: E=Sophos;i="5.92,230,1650902400"; 
   d="scan'208";a="209228640"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jun 2022 13:58:25 +0800
IronPort-SDR: +VGiNWanCsLKzgszneC1tRlffh9K0hFAeOzQE2VW2sSFl+rERi+dMKowit92CHcZfexPB+XSZd
 5DdeqzOi4U9mm7bOkUolxjCO88a6WeTJ88Bze1cKi4wq2JsF+7MWLknpBpakPO2vxCyCA58Mnz
 NJSUBf4vluzSCT0n+DUmiO3UNqGqfds7EgkUuChThBl/K+fAYgFn3TA+p2oQuqo3QlEPAsQnAd
 giyco6ececFtZ0N8vaRq8jy8nsL38BMl2imApJbMkcCp0mc65jPgCz0C7Nzng5U4SOj1K3lpOA
 mprzQ6OvPXtcyJkM9LXT5gzf
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jun 2022 22:16:04 -0700
IronPort-SDR: 6QB7N4hQ/jje3tiQGUG+WoIdkLqZs0mHUEJbyuY+t19F4B4MsZfeDFTrlVzLIq4gijKeVL6nTU
 WqzqhHDDbS78+S8wP2anIc9SzQD3d7oMAMZHEOTBheXtO6v5bw++ae4giBvRpmVoBwXsV/DmOi
 kkNczv6vh4Yfp1rLW03VsiK4752EF/+Suvc7E9izuBXS9uJ37VA8GujHk/EGroGejStFMmBCzC
 xlnffxWk0nNmAw0qzp9+nYH4njQvsvQthu7SukPzGLqiiW1Uu64HS0BKYlri9KXsgq2/s5107m
 0/I=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jun 2022 22:58:26 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LXrNx116Kz1Rwqy
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 22:58:25 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1656482304; x=1659074305; bh=S274m18N48qoB/3JOPWD2zir1wX7NK811Kr
        J3AY/WxM=; b=rZSIxcVazCAwPnit7YiDg5OgUpZgn7oq63L8f4Mx5qqJilG9g8G
        wV5uGQC6JZ3YwlD5RcmYm+uC8m3errnlZAgp6o7+Qhr7ybMyItuZdVnuPUQq8QEd
        alfGKsPbawfDl8vhSXqv7ElY5MHblK270Sv+iK4DJTeh1yOW4yY6pE1FPc0SsVS3
        eEbW6uvondPnaorxx3Tv8sUCSOfC7y2rkIguFVW4kiJALFQpstNM3YhM+lm0p4Sk
        NjgP4mO0z1H7lo92riFs/zobGTmMpBKf5xdH7qdMRzGY7ovcG58VHmy0idD2F4km
        cXLdBqiqjM+YDQfvAyxED73TZ7AcaTKdhxg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id abtMqJnJcp3j for <linux-scsi@vger.kernel.org>;
        Tue, 28 Jun 2022 22:58:24 -0700 (PDT)
Received: from [10.225.163.99] (unknown [10.225.163.99])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LXrNt01D4z1RtVk;
        Tue, 28 Jun 2022 22:58:21 -0700 (PDT)
Message-ID: <da7027d9-bd81-cfb0-f70e-2405f40023fa@opensource.wdc.com>
Date:   Wed, 29 Jun 2022 14:58:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 5/5] libata-scsi: Cap ata_device->max_sectors according
 to shost->max_sectors
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, John Garry <john.garry@huawei.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, iommu@lists.linux-foundation.org,
        iommu@lists.linux.dev, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com, joro@8bytes.org, will@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        m.szyprowski@samsung.com, robin.murphy@arm.com
References: <1656343521-62897-1-git-send-email-john.garry@huawei.com>
 <1656343521-62897-6-git-send-email-john.garry@huawei.com>
 <b69c6112-98b7-3890-9d11-bb321a7c877a@opensource.wdc.com>
 <6619638c-52e8-cb67-c56c-9c9d38c18161@huawei.com>
 <ba59a0da-a982-e3eb-1cb7-6e60f80fd319@opensource.wdc.com>
 <38ae1cc8-1411-bb54-e082-0f7b91cb9e63@huawei.com>
 <20220629054027.GB16297@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220629054027.GB16297@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/29/22 14:40, Christoph Hellwig wrote:
> On Tue, Jun 28, 2022 at 12:33:58PM +0100, John Garry wrote:
>> Well Christoph originally offered to take this series via the dma-mapping 
>> tree.
>>
>> @Christoph, is that still ok with you? If so, would you rather I send this 
>> libata patch separately?
> 
> The offer still stands, and I don't really care where the libata
> patch is routed.  Just tell me what you prefer.

If it is 100% independent from the other patches, I can take it.
Otherwise, feel free to take it !

-- 
Damien Le Moal
Western Digital Research
