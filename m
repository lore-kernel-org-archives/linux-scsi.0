Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2774BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 20:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0811E60C51
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 20:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242937AbhJOUOM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 16:14:12 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:35046 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231983AbhJOUOL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 16:14:11 -0400
X-UUID: 2d9840d1db584ae7ac416bc77cb6dd95-20211016
X-UUID: 2d9840d1db584ae7ac416bc77cb6dd95-20211016
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 936355359; Sat, 16 Oct 2021 04:11:58 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Sat, 16 Oct 2021 04:11:56 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 16 Oct 2021 04:11:56 +0800
From:   <miles.chen@mediatek.com>
To:     <bvanassche@acm.org>
CC:     <jejb@linux.ibm.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <martink@posteo.de>,
        <matthias.bgg@gmail.com>, <miles.chen@mediatek.com>,
        <stanley.chu@mediatek.com>, <wsd_upstream@mediatek.com>
Subject: Re: [PATCH] scsi: sd: fix crashes in sd_resume_runtime
Date:   Sat, 16 Oct 2021 04:11:55 +0800
Message-ID: <20211015201155.12212-1-miles.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <fe7bacf4-aa9a-6742-8382-a7c9b31236a7@acm.org>
References: <fe7bacf4-aa9a-6742-8382-a7c9b31236a7@acm.org>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Miles Chen <miles.chen@mediatek.com>

> Fixing this crash by adding a check inside sd_resume_runtime() seems wrong to me. sd_probe() namely calls dev_set_drvdata(dev, sdkp) before
> sd_probe() has finished so even with the above patch applied sd_resume() can be called before sd_probe() has finished.
> 
> With which kernel version has this crash been encountered? The
> scsi_autopm_get_device() / scsi_autopm_put_device() pair added by commit
> 6fe8c1dbefd6 ("scsi: balance out autopm get/put calls in scsi_sysfs_add_sdev()"; kernel v3.18) should be sufficient to prevent the reported crash.
> 
> Thanks,

Thanks for your comment.

I hit this in v5.15-rc1 merge, I can still reproduce this with v5.15-rc5.
I found two ways to avoid the crash:
1) revert commit ed4246d37f3b ("scsi: sd: REQUEST SENSE for
BLIST_IGN_MEDIA_CHANGE devices in runtime_resume()") works for me.
2) adding the NULL point check in this patch.

From the backtrace, dev_set_drvdata() is called after sd_resume_runtime()
is called. 

sd_probe()
{
 scsi_autopm_get_device()
   pm_runtime_get_sync()
     __pm_runtime_resume()
       rpm_resume()
        ...
	 sd_resume_runtime() // crash here

  dev_set_drvdata(dev, sdkp); // sdkp is set later
}

[    4.861395][  T151]  sd_resume_runtime+0x20/0x14c
[    4.862025][  T151]  scsi_runtime_resume+0x84/0xe4
[    4.862667][  T151]  __rpm_callback+0x1f4/0x8cc
[    4.863275][  T151]  rpm_resume+0x7e8/0xaa4
[    4.863836][  T151]  __pm_runtime_resume+0xa0/0x110
[    4.864489][  T151]  sd_probe+0x30/0x428
[    4.865016][  T151]  really_probe+0x14c/0x500

