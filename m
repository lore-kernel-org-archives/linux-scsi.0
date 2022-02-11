Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8499CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 06:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240975AbiBKGL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 01:11:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiBKGLZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 01:11:25 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17271103
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 22:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hNcWh2de4oopPCDpybe22GeIlwer0r+aY7PXtr/AZfs=; b=u6A73H/+2R595ES1rJlZfUhtRY
        ieqqq7T45YJhtZPHzz3R5QCjoQdboHRHVRiEyddOxeTOclZ4jfGA70/9d1eVfSWcB9QXQCm7y244i
        F7Eby7dnJuNM5iy8f4Dbq15/DF2rLc8Qk7NRhGGIiWeiVZRG0gOd3e14/tLwtQQZKbVllcurvB7ST
        lg2e0dkgJny9x9Cr2lR1W0niB9vuDFw1sYEjRNPe7G4zVwi+BxRxRVGEK2kMbHVV39+23v5ZGUqeh
        VP6V3a5PB74JRvkRDh7HM8FOqwwgGmvGrMg5rOQZHM05F/+jO8L65LYXOq49mpBFvLu7fAIrq/faC
        u9jeiORg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nIP9N-005x99-Sk; Fri, 11 Feb 2022 06:11:21 +0000
Date:   Thu, 10 Feb 2022 22:11:21 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: Re: [PATCH 04/20] scsi: pm8001: fix __iomem pointer use in
 pm8001_phy_control()
Message-ID: <YgX+Cdjeok1ClSVo@infradead.org>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <20220210114218.632725-5-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210114218.632725-5-damien.lemoal@opensource.wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 10, 2022 at 08:42:02PM +0900, Damien Le Moal wrote:
>  			struct sas_phy *phy = sas_phy->phy;
> -			uint32_t *qp = (uint32_t *)(((char *)
> -				pm8001_ha->io_mem[2].memvirtaddr)
> -				+ 0x1034 + (0x4000 * (phy_id & 3)));
> +			unsigned long vaddr = (unsigned long)
> +				pm8001_ha->io_mem[2].memvirtaddr;
> +			uint32_t *qp = (uint32_t *)
> +				(vaddr + 0x1034 + (0x4000 * (phy_id & 3)));

This just removes the warning, but does not actually fix the issue.
Both long_vaddr and qp need to be __iomem pointers...

>  
>  			phy->invalid_dword_count = qp[0];
>  			phy->running_disparity_error_count = qp[1];

... and reads from qp need to use readl.
