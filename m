Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13012C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 04:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8FDF610D2
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 04:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhJ1Efd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 00:35:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61177 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhJ1Efd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 00:35:33 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211028043304epoutp021509f5068274813f4ea3b820e83ac096~yF56ausws1528515285epoutp02I
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2021 04:33:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211028043304epoutp021509f5068274813f4ea3b820e83ac096~yF56ausws1528515285epoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1635395584;
        bh=LUsNTxz9c63HVoQbCKFLs7VnHQilNGubPFcpenAhU+0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=B4xkjgE0r4eFkh7N7KUeKFjgSfMLFMWDwdZoJXfjzEyjnWRxBiCbtlTmwLmtHboIv
         +682AdV9oYK9CvfVGL8GmIYOsQGR2S1Ro7/hqkX9ZnKC0uwHsIEPLtZwKDdvuC5L3a
         SfcwdI8Cxjz/vwmsBSTAUUqgy2MXNoFKR4FNAJbc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211028043304epcas2p1190916ef94ebf6f6c2fc9c66d350252e~yF557Mi4m2283222832epcas2p1c;
        Thu, 28 Oct 2021 04:33:04 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.100]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Hft2y54ytz4x9QJ; Thu, 28 Oct
        2021 04:32:58 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        60.5E.09868.8F72A716; Thu, 28 Oct 2021 13:32:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20211028043256epcas2p28d4e3eb514d0ee2450d9a8e8dc13d520~yF5yX_Sbi1279112791epcas2p2q;
        Thu, 28 Oct 2021 04:32:56 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211028043255epsmtrp26205572d5ff5dc88c20f2738c798c97e~yF5yTR36h2657826578epsmtrp26;
        Thu, 28 Oct 2021 04:32:55 +0000 (GMT)
X-AuditID: b6c32a45-9a3ff7000000268c-ea-617a27f832dc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        37.B2.08738.7F72A716; Thu, 28 Oct 2021 13:32:55 +0900 (KST)
Received: from KORCO082417 (unknown [10.229.8.121]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20211028043255epsmtip24a0a7489ab5eefb94165927941f6d7a0~yF5yGJoJd1746417464epsmtip2v;
        Thu, 28 Oct 2021 04:32:55 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Rob Herring'" <robh+dt@kernel.org>
Cc:     "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        "'Sowon Na'" <sowon.na@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "'jongmin jeong'" <jjmin.jeong@samsung.com>
In-Reply-To: <yq14k91zvn2.fsf@ca-mkp.ca.oracle.com>
Subject: RE: [PATCH v5 01/15] scsi: ufs: add quirk to handle broken UIC
 command
Date:   Thu, 28 Oct 2021 13:32:55 +0900
Message-ID: <011001d7cbb4$e0e3db60$a2ab9220$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHtQ30VsD4iD6ytBuMtEalyLJ14wwCqcHsGAYiV6lsBgh9UNKufNSTQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDJsWRmVeSWpSXmKPExsWy7bCmme4P9apEg/37pCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvTsdLY4PWERk8WT9bOYLRbd2MZkceNXG6vFymsWFhvf
        /mCymHF+H5NF9/UdbBbLj/9jsmjde4Td4vfPQ0wOQh6Xr3h7zGroZfO43NfL5LF5hZbH4j0v
        mTw2repk85iw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8Udk2GamJKalFCql5yfkp
        mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDPKSmUJeaUAoUCEouLlfTtbIry
        S0tSFTLyi0tslVILUnIKzAv0ihNzi0vz0vXyUkusDA0MjEyBChOyM5Yf1y7YxlpxYOZ+pgbG
        5yxdjJwcEgImEmvOrWTvYuTiEBLYwSjx6MlWZgjnE6PE4U1zwKqEBD4zSmz8VwPTcf/NfRaI
        ol2MEgd//mOEcF4wSvT9u8YGUsUmoC/xsmMbK4gtIhAvseP3NFaQImaBzawS7z8sBurg4OAU
        MJY41F0KUiMsECjxeu8qsHoWAVWJzS8nsYPYvAKWEg0z5kDZghInZz4Bu4hZQF5i+9s5zBAX
        KUj8fLoMapebxOUN7UwQNSISszvbwN6REJjOKbHl4XNWiAYXic0zVkLZwhKvjm9hh7ClJD6/
        28sG0dDNKNH66D9UYjWjRGejD4RtL/Fr+hZWkAeYBTQl1u/SBzElBJQljtyCuo1PouPwX3aI
        MK9ER5sQRKO6xIHt06HBLivRPecz6wRGpVlIPpuF5LNZSD6YhbBrASPLKkax1ILi3PTUYqMC
        Q3hcJ+fnbmIEJ3st1x2Mk99+0DvEyMTBeIhRgoNZSYT38rzyRCHelMTKqtSi/Pii0pzU4kOM
        psCwnsgsJZqcD8w3eSXxhiaWBiZmZobmRqYG5krivJai2YlCAumJJanZqakFqUUwfUwcnFIN
        TK1TdNQP8CXYZ8m3bbx84+ECmR/BN7639l8MaHgmqrs744tDQgavs2qYzSJHywceczJd/0w/
        cHAz61d2hpQnTj3m0t0mGm2yD0USBQR5PrWevfyk+sFdTr3DwSWWUo/2Fbc5Tm2SEn/zy26l
        wKGj4bu1nh0L1bl7u+ZGwt+fYt58X7zUAmV8XZ02+fmtST+xKSgi5veP/klnTG//eaElaB0Z
        vfd+aeZjCSnNaU8m3rmtusd20pWqjL8vJ15X+WaxxqewQ5d7mtafh8kXZJe+uKD6ydkioa78
        xpfmCDXVwKtOe9R9PldI16Us+zPlOodR3i3Fu7c+nlCfe+AT519Wr5iiyZ6ZRyMS0uvf+Cid
        VWIpzkg01GIuKk4EAEWz0k1/BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsWy7bCSvO539apEgysbLCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvTsdLY4PWERk8WT9bOYLRbd2MZkceNXG6vFymsWFhvf
        /mCymHF+H5NF9/UdbBbLj/9jsmjde4Td4vfPQ0wOQh6Xr3h7zGroZfO43NfL5LF5hZbH4j0v
        mTw2repk85iw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8UVw2Kak5mWWpRfp2CVwZ
        y49rF2xjrTgwcz9TA+Nzli5GTg4JAROJ+2/uA9lcHEICOxgl2g5uYoRIyEo8e7eDHcIWlrjf
        coQVougZo8TsA/vAitgE9CVedmwDSnBwiAjES1w6wARSwyywn1Vi1ofHrCA1QgJvGCW+78wE
        qeEUMJY41F0KEhYW8Je4umkqWAmLgKrE5peTwHbxClhKNMyYA2ULSpyc+YQFpJVZQE+ibSPY
        VmYBeYntb+cwQ5ymIPHz6TKwMSICbhKXN7QzQdSISMzubGOewCg8C8mkWQiTZiGZNAtJxwJG
        llWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMExr6W1g3HPqg96hxiZOBgPMUpwMCuJ
        8F6eV54oxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA9Op
        fZdXc6z7ILGZwXzTW26eRKFso7ulVxbrMp+r51ye//1cjLWm1CMGzz239Q5N1uBcZfzHYvfU
        yIU9STW/5z95FmTFcXxdWPSF15/j49IS3ooZ8lsbyJ85+JwrXCUrxVnqucK7C+oaz689ORty
        e1/hCteTa6fJsKieYC90OD5p37418V9/7/4YK3/e4EOwfuZP72OaN+vvJjUuSz/Ly3t60pmr
        Wwq3xe4Xn8hkp8E84eapO36X8j+8P66WMPluVua5pWHLty97Py1OM2LRgfvnluWwH2v5HjHt
        lq7e8ssLot+vyk03jVV1X/hrdkzg9hK/KXJ1Uk935jj9WOXHp+PM/GbWIvEv+jODbD0XHOMM
        UmIpzkg01GIuKk4EAC+Z061oAwAA
X-CMS-MailID: 20211028043256epcas2p28d4e3eb514d0ee2450d9a8e8dc13d520
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124505epcas2p2d149a4f26d3475830a36c47049591bb2
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124505epcas2p2d149a4f26d3475830a36c47049591bb2@epcas2p2.samsung.com>
        <20211018124216.153072-2-chanho61.park@samsung.com>
        <yq14k91zvn2.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Applied to 5.16/scsi-staging, thanks! I skipped the dt-bindings patches
> since the relevant yaml file is not yet upstream.

Thanks. It has a dependency with the exynos,ufs dt-binding patch of Rob's
tree.

https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git/commit/?h=dt/
linus&id=e22e509c1cd90b48ae31099905418de74515e56f

Dear Rob,
Could you pick them up on your tree?

https://lore.kernel.org/linux-scsi/20211018124216.153072-1-chanho61.park@sam
sung.com/T/#m16a3920d16ae8843a78fdbefbb402bd321e5ab31
https://lore.kernel.org/linux-scsi/20211018124216.153072-1-chanho61.park@sam
sung.com/T/#mc9380270b1cdab2be6660444fd2f318b29caf182

Best Regards,
Chanho Park

