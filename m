Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B020C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 07:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 623D16103C
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 07:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbhJKHG1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 03:06:27 -0400
Received: from mx24.baidu.com ([111.206.215.185]:36484 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234736AbhJKHGI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Oct 2021 03:06:08 -0400
Received: from BJHW-Mail-Ex10.internal.baidu.com (unknown [10.127.64.33])
        by Forcepoint Email with ESMTPS id 8B1C7A047B63647B8EA3;
        Mon, 11 Oct 2021 15:04:06 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex10.internal.baidu.com (10.127.64.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Mon, 11 Oct 2021 15:04:06 +0800
Received: from localhost (172.31.63.8) by BJHW-MAIL-EX27.internal.baidu.com
 (10.127.64.42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 11
 Oct 2021 15:04:06 +0800
Date:   Mon, 11 Oct 2021 15:04:05 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Michael Cyr <mikecyr@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ibmvscsi_tgt: Use dma_alloc_coherent() instead of
 get_zeroed_page/dma_map_single()
Message-ID: <20211011070405.GA173@LAPTOP-UKSR4ENP.internal.baidu.com>
References: <20211010160055.488-1-caihuoqing@baidu.com>
 <YWPc1GxFiOloHveI@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YWPc1GxFiOloHveI@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex17.internal.baidu.com (172.31.51.11) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex10_2021-10-11 15:04:06:519
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11 10月 21 07:42:28, Christoph Hellwig wrote:
> On Mon, Oct 11, 2021 at 12:00:53AM +0800, Cai Huoqing wrote:
> > Replacing get_zeroed_page/free_page/dma_map_single/dma_unmap_single()
> > with dma_alloc_coherent/dma_free_coherent() helps to reduce
> > code size, and simplify the code, and coherent DMA will not
> > clear the cache every time.
> 
> This explanation does not make any sense whatsoever.  Please explain
> why it would an show numbers.
Hi Christoph,
thanks for your feedback.

In this case, just simplify the code.
10 insertions(+), 31 deletions(-)

dma_sync_ API is not called, I think the hardware may keep cache coherent
directly or is a no cache system. No need to make perfermance compare.

thanks
Cai
