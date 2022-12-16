Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247AAC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Dec 2022 07:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiLPHOH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Dec 2022 02:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiLPHNY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2022 02:13:24 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006AB19002;
        Thu, 15 Dec 2022 23:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vqRMSpD1eVYXTGaFFnMc2dvCJYloydrqlHDvsUDDbr0=; b=b7yHcHD4T9me5R9OFJ2iJjtZr+
        mVKbrMop8uy2T3Qy2LUeiDHQSyWbAxNBLRHN1r2vxuWF3lgKf5T9/vuSqXAmnigQxfW+M10JGCnqi
        SbCcTBqebh6gbSocryrcZEK18rhNfIYgnE0VQX+l3fqeK+/Sq+kLaYNW7GEAaACXQvVVTEVT7Z7bn
        Tgw8h1U46sFnFjmY/RdrDZydrhJH5HI8izJgOVns8PxsmiET63z8Ic74YNSl6+VPJelsY/7pQIOz7
        T1JNurmE16AyMkkPPlushDL+VscpM4mKjRH3HBVVK9zXVEAEJKTFT//7g/ibVtc7q9J4OWtJg78HM
        +IWF6Q2A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p64tu-00DL2R-5w; Fri, 16 Dec 2022 07:12:58 +0000
Date:   Thu, 15 Dec 2022 23:12:58 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Wenchao Hao <haowenchao@huawei.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, liuzhiqiang26@huawei.com,
        linfeilong@huawei.com
Subject: Re: [PATCH 0/2] scsi:donot skip lun if inquiry returns PQ=1 for all
 hosts
Message-ID: <Y5waet8RoXKQHDR7@infradead.org>
References: <20221214070846.1808300-1-haowenchao@huawei.com>
 <Y5rHX95Vvl1aLhbp@infradead.org>
 <57c12317-c229-8cbe-b3d2-d799ea5f554c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57c12317-c229-8cbe-b3d2-d799ea5f554c@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 15, 2022 at 05:09:31PM +0800, Wenchao Hao wrote:
> In my opinion, if the addressed lun still response the
> inquiry and other commands, we should not skip it,
> maybe let the scsi drivers like sd/st/sg to determine
> how to handle this lun accordint to the PQ value.
> 
> As discussed in following mail, another drivers would
> be broken too.

So why do you force a specific behavior for iSCSI?
