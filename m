Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6238BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 07:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49E21611CA
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 07:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbhI1HNU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 03:13:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38188 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239174AbhI1HNT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 03:13:19 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210928071136epoutp04d05d555e2c515232bf24ad4944859081~o6txS5ra_3069430694epoutp04P
        for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2021 07:11:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210928071136epoutp04d05d555e2c515232bf24ad4944859081~o6txS5ra_3069430694epoutp04P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632813096;
        bh=NIZMiz+ifOMDVuW0GFVQEI9kb8J0WTIS362xeoydOrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGoGpMyU8zYHmTI+igPTo+21SJu1YsMVR7d9eNO5JTSmYgFygWhMQvoRkf/qVbz+/
         GC1h7bK32plQAv2qfzI3ivuOgNFXdTfrDDSS13NFnqQ2GfmFY8rwG9gql3PcRaXBmm
         1hIJRWBa1PW9v9GBYR8BXtfttXTLg3HcBGJcBZU0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210928071136epcas2p4482861573e22dbe446a6941465725bd5~o6twqQleN1376113761epcas2p4r;
        Tue, 28 Sep 2021 07:11:36 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.185]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HJVzp23jVz4x9QX; Tue, 28 Sep
        2021 07:11:34 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.9C.09472.620C2516; Tue, 28 Sep 2021 16:11:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210928071133epcas2p28e00e20bbebbb5c1920933204f91743b~o6tuE-zil0329103291epcas2p2v;
        Tue, 28 Sep 2021 07:11:33 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210928071133epsmtrp1e60bcbd20dfbd8f08c43f96d7efc21c2~o6tuEKvB32464624646epsmtrp1h;
        Tue, 28 Sep 2021 07:11:33 +0000 (GMT)
X-AuditID: b6c32a48-d5fff70000002500-b4-6152c026fd48
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EC.F7.09091.520C2516; Tue, 28 Sep 2021 16:11:33 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210928071133epsmtip1a81cb5231118e44974c1502f5e5cdd91~o6ttyQhwz3220232202epsmtip1u;
        Tue, 28 Sep 2021 07:11:33 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     adrian.hunter@intel.com
Cc:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        avri.altman@wdc.com, bvanassche@acm.org, cang@codeaurora.org,
        huobean@gmail.com, jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        liwei213@huawei.com, manivannan.sadhasivam@linaro.org,
        martin.petersen@oracle.com, Kiwoong Kim <kwmad.kim@samsung.com>
Subject: Re: [PATCH V5 1/3] scsi: ufs: Fix error handler clear ua deadlock
Date:   Tue, 28 Sep 2021 15:55:20 +0900
Message-Id: <1632812120-27857-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20210922093842.18025-2-adrian.hunter@intel.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmqa7agaBEgw/r+CxOPlnDZvFg3jY2
        i71tJ9gtXv68ymYx7cNPZotP65exWsw528BksejGNiaLm1uOslh0X9/BZvF3zhFGi7stnawW
        y4//Y3Lg9bh8xdvjcl8vk8fOWXfZPVqOvGX1WLznJZPHnWt72DwmLDrA6PHx6S0Wj74tqxg9
        Pm+S82g/0M0UwB2VY5ORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
        E6DrlpkD9IGSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8DQsECvODG3uDQvXS85
        P9fK0MDAyBSoMiEn48Kyi0wFS5kq+hqXsTcwfmbsYuTkkBAwkdjwZj1rFyMXh5DADkaJni37
        2SGcT4wSX15ug3K+MUrcfjiZHabl27KbzBCJvYwSDYuWsYIkhAR+MEqcms0HYrMJaEo8vTmV
        CcQWEZCWaLv9EKyZWWArk8TxG5VdjBwcwgJeEod3c4KEWQRUJbo/rWABsXkFXCW2dW5hgdgl
        J3HzXCcziM0pYCtx++8NNpC9EgILOSSWzTrFClHkIrHwYjuULSzx6vgWqEOlJF72t0HZ9RL7
        pjawQjT3MEo83fcPGgDGErOetTOCHMQMdPT6XfogpoSAssSRWywQJ/NJdBz+yw4R5pXoaBOC
        aFSW+DVpMtQQSYmZN+9AbfKQ2LX6HBskeCYwSuy6PZtpAqPcLIQFCxgZVzGKpRYU56anFhsV
        mCBH2CZGcArV8tjBOPvtB71DjEwcjIcYJTiYlUR4g1n8E4V4UxIrq1KL8uOLSnNSiw8xmgID
        byKzlGhyPjCJ55XEG5oamZkZWJpamJoZWSiJ887955QoJJCeWJKanZpakFoE08fEwSnVwLSt
        LjXhelSJ7LcbE7aUSopY/mae07q9d+WHW5tNH23/cf3m4db5sQX12x/5Ln/wIKPuRIzMtf19
        8cps00rPLrWsUBP6fiPtWnLwx/7dVQ2y6/wXPtjfklfpmy7opFxVfaLiy9vaC/xve5/pJy6+
        YuRyj1GzzTNpocDr2Ys2abAITA3js02pz94m19L2VGTWnbiM5c5/TvEkmpxzbPo612q27b7l
        LcvfcnsvXjbR5fW+gFe9oifT9A0VW3/MEdwmGzJ9/vGYzBfVdevMOhVE00M3M7xaULo14WTY
        qaSlBmedOIt67t3Pz7y8QXsyw6J/k0W9lhQdvPbHvneXxJPliuv7e6Y7dc9O7CnwaXwqslyJ
        pTgj0VCLuag4EQAnxpDfKgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSnK7qgaBEg9mbxC1OPlnDZvFg3jY2
        i71tJ9gtXv68ymYx7cNPZotP65exWsw528BksejGNiaLm1uOslh0X9/BZvF3zhFGi7stnawW
        y4//Y3Lg9bh8xdvjcl8vk8fOWXfZPVqOvGX1WLznJZPHnWt72DwmLDrA6PHx6S0Wj74tqxg9
        Pm+S82g/0M0UwB3FZZOSmpNZllqkb5fAlXFh2UWmgqVMFX2Ny9gbGD8zdjFyckgImEh8W3aT
        GcQWEtjNKHG5RxIiLilxYudzqBphifstR1i7GLmAar4xSiz+/5cJJMEmoCnx9OZUMFtEQFqi
        7fZDdpAiZoHDTBKvVjwDmsrBISzgJXF4NydIDYuAqkT3pxUsIDavgKvEts4tLBAL5CRunusE
        O4JTwFbi9t8bbBAH2Uhcv/KCeQIj3wJGhlWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmb
        GMGhrqW5g3H7qg96hxiZOBgPMUpwMCuJ8Aaz+CcK8aYkVlalFuXHF5XmpBYfYpTmYFES573Q
        dTJeSCA9sSQ1OzW1ILUIJsvEwSnVwJQW+lDtJHPTWZczBy8t4V/TflOj4ON9p/QdPlF7dtWX
        /nqQZPiS2016Vrn3/+u50vPfmP/MW/J1vkP5tD+30169qeepq315luumoRvf43P37Lkl3Dcl
        nf9abP/tlumKzwve+9m97Wiar9N4curckoe3Xi/scri7S12Sb9LvpomczuYtx5SyYxYuvflG
        T7Z0v/FPz7M/M8/cM5y0stxz0t9/IT9MO6wl7qXYcDySnOdWcMHVQe1/z+EXN+07z+2Scpa5
        5Hh/90suv7sqAmfaiy40bl3wmledzW/t9Na9Du5qqtMSEg9/+p63638sk7KdqsP0k8yHAqb5
        TXbKuuWdvUXRzjtBc2b/tqWbUl802cxSYinOSDTUYi4qTgQAJJUGGuQCAAA=
X-CMS-MailID: 20210928071133epcas2p28e00e20bbebbb5c1920933204f91743b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210928071133epcas2p28e00e20bbebbb5c1920933204f91743b
References: <20210922093842.18025-2-adrian.hunter@intel.com>
        <CGME20210928071133epcas2p28e00e20bbebbb5c1920933204f91743b@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +static int ufshcd_request_sense_direct(struct ufs_hba *hba, u8 wlun)
..

How about using ufshcd_compose_dev_cmd w/ modifying the function,
ufshcd_prepare_utp_scsi_cmd_upiu and something ? I think it can be made
w/ small changes. And for prdt, it seems to be good because it's tiny.

