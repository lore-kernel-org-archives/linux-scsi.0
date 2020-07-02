Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DB1C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A63292083E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HEKkJlqN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgGBCqH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 22:46:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38704 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgGBCqG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 22:46:06 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200702024603epoutp033744d739d8f1fd4ccd14d1f96d21d010~dz3lRQklp2994729947epoutp03j
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 02:46:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200702024603epoutp033744d739d8f1fd4ccd14d1f96d21d010~dz3lRQklp2994729947epoutp03j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593657963;
        bh=+tq3SuOGhDKXfQOEpgwPONYcP/Ni2nmTSCz5czEoFo8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=HEKkJlqNOuk/zw1LHsCi9bDWC8fNDOJqaKzixHQg5lrkh7+PXbK9bL+kbCEFstkaD
         tQAc6U3IS3Mt3VAFYeEEmQv5Bu40FZR2c2GrIxLthGY5urrRXZxFE9d5ZRQvHfCM1u
         B0jhtaev+/F9HmnhYDEJsFExLr9ljw2LaMGnlh2E=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200702024601epcas2p45633daecabf4838d67154148c838f6bd~dz3kIQyQO0711007110epcas2p4Y;
        Thu,  2 Jul 2020 02:46:01 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.185]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 49y2XR0Z7szMqYkk; Thu,  2 Jul
        2020 02:45:59 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        E0.9F.19322.56A4DFE5; Thu,  2 Jul 2020 11:45:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200702024556epcas2p41b15bb9fb91884435a2cb8711273d29f~dz3falo3U0479704797epcas2p4X;
        Thu,  2 Jul 2020 02:45:56 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200702024556epsmtrp1d99e33922a06b14f03cce89512ef2126~dz3fZqxEN2619526195epsmtrp1Z;
        Thu,  2 Jul 2020 02:45:56 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-04-5efd4a6518b2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        59.B2.08303.46A4DFE5; Thu,  2 Jul 2020 11:45:56 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200702024556epsmtip2d1a96aac4680ecf4cfa8f39ced1c055e~dz3fN_-Fd0462704627epsmtip2F;
        Thu,  2 Jul 2020 02:45:56 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v2 0/2] ufs: introduce callbacks to get command
 information 
Date:   Thu,  2 Jul 2020 11:38:08 +0900
Message-Id: <cover.1593657314.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsWy7bCmmW6q1984g2udHBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFotubGOyuLnlKItF9/UdbBbLj/9jcuDyuHzF2+NyXy+T
        x4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpRSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
        XGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhgYGQKVJmQk7Hm91PWgt/sFdd/RzQwLmXrYuTg
        kBAwkbjUKtXFyMUhJLCDUeLSpKPMXYycQM4nRol3FxghEp8ZJaa+6GAHSYA0/Gw9zwKR2MUo
        8fDgL2YI5wejxOETy1hBqtgENCWe3pzKBJIQEbjBKDGn+TBYgllAXWLXhBNMILawQJDEujPr
        wcayCKhKnD89DWw3r4CFxNpl7cwQ6+Qkbp7rBNsgIXCLXeJIwzsWiISLRH/fAlYIW1ji1fEt
        UPdJSbzsb4Oy6yX2TW1ghWjuYZR4uu8fI0TCWGLWs3ZGUAgwA526fpc+JDCUJY7cYoG4k0+i
        4/Bfdogwr0RHmxBEo7LEr0mToYZISsy8eQdqk4fE1g9PoUEXK3HrwzHWCYyysxDmL2BkXMUo
        llpQnJueWmxUYIgcR5sYwclOy3UH4+S3H/QOMTJxMB5ilOBgVhLhPW3wK06INyWxsiq1KD++
        qDQntfgQoykwvCYyS4km5wPTbV5JvKGpkZmZgaWphamZkYWSOG+u4oU4IYH0xJLU7NTUgtQi
        mD4mDk6pBqY5fzy5y0syPiW+fam9purn/i9KK4+eWz8vatckbcYPCTq8bTpd/y/G+7dWvn0z
        /5jD3ZdptqZefDJ3He22fvsYs7iH2fvgqpaPDYzGXPoTz5h+yzETmrDtsKDHreS5O8qEOFzX
        Jswukdljf2QRT+3LVXxWimdvcmvY33rK4JXF7eGhrpRvO/nMV5Uij1znzg1/5/7ft3jtvRdr
        V8pJrNq695ng1753/1fIfuMLUC5cFSdWKlyj5sdrf8JjhfhJWwmvtYIGJkEZZYk3u85rmW2r
        brz99vecmVI1H6esVjMqZ2n5vvzO36QEvdB9fjmHT3oXL1WM83r2dlv6I9k7d2bcNr6VP9vK
        hO/iDeGJscpKLMUZiYZazEXFiQBGy/2b/wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsWy7bCSvG6K1984g1VP9CwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLRbd2MZkcXPLURaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARxWWTkpqTWZZapG+XwJWx5vdT1oLf
        7BXXf0c0MC5l62Lk5JAQMJH42XqepYuRi0NIYAejxO67KxghEpISJ3Y+h7KFJe63HGGFKPrG
        KDFz7WSwbjYBTYmnN6cygSREBB4xSvye2ckOkmAWUJfYNeEEUIKDQ1ggQOJ/pwdImEVAVeL8
        6WnMIDavgIXE2mXtzBAL5CRunutknsDIs4CRYRWjZGpBcW56brFhgVFearlecWJucWleul5y
        fu4mRnD4aWntYNyz6oPeIUYmDsZDjBIczEoivKcNfsUJ8aYkVlalFuXHF5XmpBYfYpTmYFES
        5/06a2GckEB6YklqdmpqQWoRTJaJg1Oqgalwvv5VJnfGO7PrFWff6W96EMb9l0m+ZF35GplA
        Vp67zMaP1xvmfRe6ttu3umq2L+PrWTud3W+6vgmbIcD1VbZrp4bsxedpx897PPoXp832Yc6C
        zaU1lydsib3j8E5Il9XkZeyF2WIiv3P7NLyS/Qy5rV2mT8pw3rQ7eYb9vMOlpcs+8cRNWXnv
        Y3PqB4tlbxwvLlDbmDGr6om/go3DoejTNwvDPncZOC3zEFM3WeM+VfG29GHHnvsTYnqffv6q
        0bBWsmLeDtm16lX7Zn7UfKcjc7vDd5pv+6/LAjd42xK7nrlr3Ty6TODh5ZrkuK3ZogfFde3C
        RdJe8E/4/1FbvDBxzvMXh78pB2sf2c0mZKfEUpyRaKjFXFScCAC59kRdrgIAAA==
X-CMS-MailID: 20200702024556epcas2p41b15bb9fb91884435a2cb8711273d29f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200702024556epcas2p41b15bb9fb91884435a2cb8711273d29f
References: <CGME20200702024556epcas2p41b15bb9fb91884435a2cb8711273d29f@epcas2p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some SoC specific might need command history for
various reasons, such as stacking command contexts
in system memory to check for debugging in the future
or scaling some DVFS knobs to boost IO throughput.

What you would do with the information could be
variant per SoC vendor.

Kiwoong Kim (2):
  ufs: introduce a callback to get info of command completion
  exynos-ufs: implement dbg_register_dump and compl_xfer_req

 drivers/scsi/ufs/Kconfig          |  14 +++
 drivers/scsi/ufs/Makefile         |   2 +-
 drivers/scsi/ufs/ufs-exynos-dbg.c | 202 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-if.h  |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  63 +++++++++++-
 drivers/scsi/ufs/ufs-exynos.h     |  13 +++
 drivers/scsi/ufs/ufshcd.c         |   2 +
 drivers/scsi/ufs/ufshcd.h         |   8 ++
 8 files changed, 318 insertions(+), 3 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-if.h

-- 
2.7.4

