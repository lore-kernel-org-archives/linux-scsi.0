Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4DBC47098
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 05:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2244F61359
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 05:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhFDFXw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 01:23:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35855 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhFDFXu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 01:23:50 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210604052202epoutp01646a9be338d6e60c4a0c367f863e4ea0~FSY_w4IyR1500815008epoutp01R
        for <linux-scsi@vger.kernel.org>; Fri,  4 Jun 2021 05:22:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210604052202epoutp01646a9be338d6e60c4a0c367f863e4ea0~FSY_w4IyR1500815008epoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622784122;
        bh=xIm3aFjGQprvNSpIKhJskjSxpv48qOcDAw+UzFJ00I4=;
        h=From:To:Cc:Subject:Date:References:From;
        b=LB+Ma9pUY4CvhuFhWaNMwe8A+Bj608hGuW9fyyP3Lzq2Egf4x84+csCC/o12BZP4N
         z/YJjYHL6JX65Rrpc68Ftwh5hrb1v7uVNPF+NK5f/mkrTKtZ+QuabN8ZVu3Ow+xaKM
         dI8i3B9RBtNeZX+C/3h1NNIDy5JNlmgSstQBtMa4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210604052159epcas1p266b65ec2e99b2280a3e5bbb9806a81fd~FSY8nK1aT1203712037epcas1p21;
        Fri,  4 Jun 2021 05:21:59 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.159]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4FxB2t3QWvz4x9QH; Fri,  4 Jun
        2021 05:21:58 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.65.09578.678B9B06; Fri,  4 Jun 2021 14:21:58 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210604052157epcas1p2e5eebb52d08b06174696290e11fdd5a4~FSY6ZysVc1437414374epcas1p2M;
        Fri,  4 Jun 2021 05:21:57 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210604052157epsmtrp1de035d3a8191cb7cbb13b9945aa3eb62~FSY6YMqBN0498504985epsmtrp1c;
        Fri,  4 Jun 2021 05:21:57 +0000 (GMT)
X-AuditID: b6c32a35-fb9ff7000000256a-07-60b9b87663b3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2E.5E.08163.578B9B06; Fri,  4 Jun 2021 14:21:57 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.105]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210604052157epsmtip11bf4527e3425d5fcd9695093b7d6884a~FSY6Aopb50192801928epsmtip1-;
        Fri,  4 Jun 2021 05:21:57 +0000 (GMT)
From:   Changheun Lee <nanich.lee@samsung.com>
To:     Johannes.Thumshirn@wdc.com, alex_y_xu@yahoo.ca,
        asml.silence@gmail.com, axboe@kernel.dk, bgoncalv@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        cang@codeaurora.org, avri.altman@wdc.com, alim.akhtar@samsung.com,
        bvanassche@acm.org, damien.lemoal@wdc.com,
        gregkh@linuxfoundation.org, hch@infradead.org, jaegeuk@kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ming.lei@redhat.com, osandov@fb.com,
        patchwork-bot@kernel.org, tj@kernel.org, tom.leiming@gmail.com,
        yi.zhang@redhat.com
Cc:     jisoo2146.oh@samsung.com, junho89.kim@samsung.com,
        mj0123.lee@samsung.com, seunghwan.hyun@samsung.com,
        sookwan7.kim@samsung.com, woosung2.lee@samsung.com,
        yt0928.kim@samsung.com, Changheun Lee <nanich.lee@samsung.com>
Subject: [PATCH v12 0/3] bio: control bio max size
Date:   Fri,  4 Jun 2021 14:03:21 +0900
Message-Id: <20210604050324.28670-1-nanich.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTVxjeuff2thCBrjB3wpywBhVwVAoWjw6MC8Tdzf0gmC3Zkq00cIHG
        0ta2OMe+nB0gFIEKlozPDRBZRQsFSoExSBkQEHGufGxEQAJIZOOrBAZTl5UWNv69z/M+z/vk
        fU8OC+fcYXqzxFIVrZCKJFzSlTB1BfCCLphbYoPXfvVCdx7WMtGjMhOJSvQmgJ5sDpPo1ngu
        iVoflAOkW97Ekc1QzUBpGesYUlcaSHQ3rwJDM4YiHFX8ZsJQ9sxlBnqeNYGhtSklah87jKyt
        JSTSjJpJdLP3HwxZ8tUYKmwowdHI5AATdU0ME2iqSoujwT4bA5VNn0J/3+wGaGljlIn6zfk4
        Gh3UkcjQvkme8qWsQ2coa85VjNKqF5lUS9E4k2qoCaSs91Iooz6TpPIqOgHVUVrLpFZmxwhq
        6adhkspp1ANq1bifyujUYJTFUo1He3woCU+iRfG0wpeWxsnixdLECO6Zs8JIoSAsmB/EP46O
        cX2lomQ6ghv1bnTQabHEfi+u7wWRJMVORYuUSu6Rk+EKWYqK9k2SKVURXFoeL5Hzg+U8pShZ
        mSJN5MXJkk/wg4NDBHZlrCRpfnwak5tYFwfUbcQlUEBmARcWZB+FhXV/2WtXFodtBvCPfh3T
        CWwA1mfoMSdYBbBtwYjvWHpGWglnoxXAyq4axn+qsW6NQ0WyX4c5C2OOwV5sIwGtmVfAFsDZ
        0wAO9aU74j3ZIbB0YhZs1QT7AGzK23C43dhvwOLlesKZ5wOfTWZv8y/Cvm9nHDxu59VNxfjW
        UMjucoHdPzRv7xQFTSuabbMnnO9tZDprb/gkN53pNGgAVKeXAyfIA7BqrhpzqkKhbXXV3mDZ
        IwKgofWIk34NtjwtBc5kd7i4ls3YkkC2G7ySznFK/ODAN5P4Ttbc7ZbtiRQcbtAxtmoO+yPY
        MZoB8oBP0a59inbtU/R/8HcA14O9tFyZnEgr+XL+7pc1AsfHCRSYgXZhmWcBGAtYAGThXC+3
        Hw+aYzlu8aJPU2mFTKhIkdBKCxDYL6zFvV+Kk9l/nlQl5AtCQkND0dGwY2GCUO7LbomRn8Vy
        2IkiFX2OpuW0YseHsVy8L2Ht3td+9rv2aiH//F5NDKf34Vl5uqJCXHBow/D1iOvz/UXvhATz
        5oLq/KfaPlZ2HIzRF36ha6us4gQJTqj0Tcd7iVTNfJ/IAwija1f8AoxfHdYSYp9n79Erdefu
        E9+/Tc74a3//M1t8Y1LNCmvITWA8LempjelrH3xrOaI9PPrWCC8tdfmXwWbz54+NCZdZuYcO
        LFoCr6ZpO+viu/u/FOy5G19qW9/HeaH5+mxkc+lm2fWZ9emskja/qT02r3pxW0NPVrl7X8JS
        6cn822/eP0+ZanLTPyD2BZFD9VHWByqe/ycX75le6TY0PkrSeUiKe8szC264+ycKl8uGH9vc
        Fyffb/LkEsokET8QVyhF/wJasF+UwQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02RWUwTYRSF+Wem07FaGIroiIliFYmoZZHEP65EY5xEY3yQuESxFUZEaK0z
        VAWXKGXRithGUYEqWhWwbEKlls2lqCwiamqpEKkL8CCL4BrAvaKJb98530nuwyVQURvmQ8Qo
        4hlWIYsT4wLMXCeeMldlqZQGdV2bAEteFPHhqwtmHOqNZgDfDttxWNhxEodVT3MBPDM4jMIP
        pXk8mJL2BYHqy6U4fKg1ILCrNBuFhudmBKZ3JfHgd40TgZ9fc7C2fTa0VelxeNxhwWF+/Q8E
        Wk+pEXjWpEdh68tmPqxz2jH4+ooOhS2NH3jwQmcYHMm/D+DAkIMPmyynUOhoOYPD0tphPMyX
        tj1bRdsyTiC0Tv2OT1dmd/BpU0EAbXukosuNx3Baa7gD6Nvni/j0++52jB64ZcfpjBtGQH8s
        n0Kn3TmO0FZrHrrWY5NgURQTF7OHYQOXSAU7ejo6EaWZ2NesrsYOg9O4BowhKDKUetBahWmA
        gBCRFkBZ0hv4o8KHqm/o52kA8Zu9qLo6bnTzHlBvtOd4rg1OzqEy+ttxlxhPPsGo66l9qCug
        ZC+gNJ0GzLXyIkOo885u4GKM9KMqtEOoi4XkQipnsAwbvTaV+vYy/W/vSTVmdf3p0d+9uiIH
        1QL37P9U9n/qIkCMYBKj5OTRci5YGaJg9ko4mZxTKaIlkbvk5eDP9wMCLKDGOCixAoQAVkAR
        qHi8sGamRSoSRskSEhl211ZWFcdwVjCZwMQThU80jVtFZLQsnollGCXD/rMIMcbnMGJ+9mm/
        YGTFUpV0wJsNz1296ZLfz0L3zb1NBcFuyeDL3ZTw4plbHoeHZl2J9Z6PpK3cZgRuWYFtS5IP
        Lp8W6tXtu7S/zV9uT2h8qBtpiZDXfxyXmbOo2MPrc2Lu0Kx1L0ILgtxLjvJvJwwkdvTWe/5s
        Wuk7o/ZomKmheGNssp/pZnBFlMlZdCDeoG+TL0ytVDgD3YIWH6peTsTsG9vds8ywRtRT4O0Z
        tfNp2PQRoeRVvjMyU5+mcvRFLKD1Zaw06ZvHkRJGkokptaK8rzZ2dyyu1bW/9cfX2cI36Ndv
        356aUn7oahm5od9e7ThxQK4TeewOuTcvqbVZ5Rhy9BWu1ieIMW6HLDgAZTnZL52be1BsAwAA
X-CMS-MailID: 20210604052157epcas1p2e5eebb52d08b06174696290e11fdd5a4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210604052157epcas1p2e5eebb52d08b06174696290e11fdd5a4
References: <CGME20210604052157epcas1p2e5eebb52d08b06174696290e11fdd5a4@epcas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

bio size can grow up to 4GB after muli-page bvec has been enabled.
But sometimes large size of bio would lead to inefficient behaviors.
Control of bio max size will be helpful to improve inefficiency.

blk_queue_max_bio_bytes() is added to enable be set the max_bio_bytes in
each driver layer. And max_bio_bytes sysfs is added to show current
max_bio_bytes for each request queue.
bio size can be controlled via max_bio_bytes.

Changheun Lee (3):
  bio: control bio max size
  blk-sysfs: add max_bio_bytes
  ufs: set max_bio_bytes with queue max sectors

 Documentation/ABI/testing/sysfs-block | 10 ++++++++++
 Documentation/block/queue-sysfs.rst   |  7 +++++++
 block/bio.c                           | 17 ++++++++++++++---
 block/blk-settings.c                  | 19 +++++++++++++++++++
 block/blk-sysfs.c                     |  7 +++++++
 drivers/scsi/ufs/ufshcd.c             |  5 +++++
 include/linux/bio.h                   |  4 +++-
 include/linux/blkdev.h                |  3 +++
 8 files changed, 68 insertions(+), 4 deletions(-)

-- 
2.29.0

