Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B465C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Mar 2022 23:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbiCUXTp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Mar 2022 19:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbiCUXSG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2022 19:18:06 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285317460A
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 16:07:07 -0700 (PDT)
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220321225302epoutp0323be3c66529971c397631b4c00d331bb~ehzaWtfyz0881408814epoutp03x
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 22:53:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220321225302epoutp0323be3c66529971c397631b4c00d331bb~ehzaWtfyz0881408814epoutp03x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1647903182;
        bh=gZ85nLCWNmsAfvqI0fRnfzDwcZzX7wY6ZjjumUxiO1c=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=hQh2xvqxioLvEpER8Wz4p0rsb2itJcbWLL2m0SUuFT+8BERFbgpitCqLq49NjOgPy
         1jU8+tX0KTao2K3cydkoMye7BwDxXIGVIEJRjG3jOto7JVx6YA3HTUoeV71DM3caeA
         5faaNKFJYgtOchA1/KgaTqXmQcRj30jBhQ/1pnnA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20220321225301epcas3p3f8bd9168c5b66209b475531c5b365d88~ehzZw3aKD0753007530epcas3p3P;
        Mon, 21 Mar 2022 22:53:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4KMqdn3gH8z4x9Pv; Mon, 21 Mar 2022 22:53:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v2] ufs: fix an NULL check on list iterator
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Keoseong Park <keosung.park@samsung.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jakobkoschel@gmail.com" <jakobkoschel@gmail.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20220320150733.21824-1-xiam0nd.tong@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01647903181504.JavaMail.epsvc@epcpadp4>
Date:   Mon, 21 Mar 2022 22:17:08 +0900
X-CMS-MailID: 20220321131708epcms2p666061b9d088cbc5319af243a9aed44a0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20220320150754epcas2p3ffdbcd31ff5f4432e8d0a1106c91d729
References: <20220320150733.21824-1-xiam0nd.tong@gmail.com>
        <CGME20220320150754epcas2p3ffdbcd31ff5f4432e8d0a1106c91d729@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Xiaomeng Tong,

>The list iterator is always non-NULL so the check 'if (!rgn)'
>is always false and the dev_err() is never called. Move the
>check outside the loop and determine if 'victim_rgn' is NULL,
>to fix this bug.
> 
>Fixes: 4b5f49079c52a ("scsi: ufs: ufshpb: L2P map management for HPB read")
>Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
>---

Good catch. Free to add my reviewed-by tag.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
