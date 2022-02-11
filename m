Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12920C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 06:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiBKGOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 01:14:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347545AbiBKGOq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 01:14:46 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6EA60CC
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 22:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eqE9FFUnQQOkzLddUL+DUHQ26HBKwl259GGD1s6OVTY=; b=DkKElvRLn+9/WfdeV4eSFZveuh
        dbFzQHYguX2KAQWFgy3xPrecYSIpB5JU9PsllFPLWw/o0BKrucc58lzIhGjM7nUI8dtbGuxQAA5qV
        HKMgj5dIqN1IdFVTlj6rtjVRdjfAAJaSAQT7EeC5mvjK+I9c7WZgoAGyDRPHmuGjZGkD0vsC3hxgV
        4qmM0L5X12kueriZEuRJlFU4Ds42FoibnLNy9g9fgTOuZ1jKrDfq3Wp+wNGU/ETdSCj0KSVhiiwuy
        HBPlrmC5WdLrRG3ym2C+DYnGDowKyUIbGYZcivCjis/Nr2t8/vwbs86Usj+znJOOSWCjuGRCscycQ
        B1Hivp8w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nIPCJ-005xtS-Lb; Fri, 11 Feb 2022 06:14:23 +0000
Date:   Thu, 10 Feb 2022 22:14:23 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: Re: [PATCH 08/20] scsi: pm8001: Fix local variable declaration in
 pm80xx_pci_mem_copy()
Message-ID: <YgX+v17KB3VZWPjn@infradead.org>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <20220210114218.632725-9-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210114218.632725-9-damien.lemoal@opensource.wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 10, 2022 at 08:42:06PM +0900, Damien Le Moal wrote:
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -71,14 +71,13 @@ static void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 soffset,
>  				u32 dw_count, u32 bus_base_number)
>  {
>  	u32 index, value, offset;
> -	u32 *destination1;
> -	destination1 = (u32 *)destination;
> +	__le32 *destination1 = (__le32 *)destination;

I think the right fix here is to declare the destination argument as a
le32 pointer without the incorrect const attribute.
