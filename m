Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F65C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 13:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 732C8611C8
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 13:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbhJONfS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 09:35:18 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:54288 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234697AbhJONfS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 09:35:18 -0400
X-UUID: 733481741c3b4448b60da58bc95f8d4a-20211015
X-UUID: 733481741c3b4448b60da58bc95f8d4a-20211015
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 25211326; Fri, 15 Oct 2021 21:33:09 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 15 Oct 2021 21:33:08 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 15 Oct 2021 21:33:08 +0800
Message-ID: <d656179616d61623e1c2b45c1df219c0693749a1.camel@mediatek.com>
Subject: Re: [PATCH] scsi: sd: fix crashes in sd_resume_runtime
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Miles Chen <miles.chen@mediatek.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Martin Kepplinger <martink@posteo.de>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>
Date:   Fri, 15 Oct 2021 21:33:08 +0800
In-Reply-To: <20211015074654.19615-1-miles.chen@mediatek.com>
References: <20211015074654.19615-1-miles.chen@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Miles,

On Fri, 2021-10-15 at 15:46 +0800, Miles Chen wrote:
> After merging commit ed4246d37f3b ("scsi: sd: REQUEST SENSE for
> BLIST_IGN_MEDIA_CHANGE devices in runtime_resume()"), I hit the
> following crash on my device.
> 
> static int sd_resume_runtime(struct device *dev)
> {
>         struct scsi_disk *sdkp = dev_get_drvdata(dev);
>         struct scsi_device *sdp = sdkp->device; // sdkp == NULL and
> crash
> 
>         if (sdp->ignore_media_change) {
> 	...
> }
> 
> I checked sd_resume() and found that sdkp is possbile to be NULL, and
> there is a null pointer test in sd_resume() for this case.
> To fix this crash, follow sd_resume() to test if sdkp is NULL
> before dereferencing it.


LGTM.

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>

