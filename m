Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A923C4709B
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 05:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DE8A61413
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 05:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhFDFXy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 01:23:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35997 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbhFDFXw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 01:23:52 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210604052205epoutp019144c5607d54354220e2d327a7c30a92~FSZBhsqQ91500815008epoutp01X
        for <linux-scsi@vger.kernel.org>; Fri,  4 Jun 2021 05:22:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210604052205epoutp019144c5607d54354220e2d327a7c30a92~FSZBhsqQ91500815008epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622784125;
        bh=rZO51Mk7B139Snj8jqy48Ck58v6JJKw1P5EeJY4VRY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAXD7v849JlqSLw6mzh7OoooSDq6f8cp3Bt9DjyhkMBqq0MN4v2YTdFwzQBCOTnh8
         opw90PkSw4oo1n+dtL+vQq9CtZuloCh7stXaJDFSDja+5bOmJj4j8pHkFDCED8e4SK
         Mzhv+Ne63I/iMcHnSP3oVkXIdcTh9zIl5ZDxegnY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210604052203epcas1p19d5a2bc9e6ada62c39b0bd0b6adb1a66~FSZAU8PGO0722107221epcas1p1C;
        Fri,  4 Jun 2021 05:22:03 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.164]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4FxB2y3yqgz4x9Pt; Fri,  4 Jun
        2021 05:22:02 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        08.7F.09736.A78B9B06; Fri,  4 Jun 2021 14:22:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210604052201epcas1p41a27660b20d70b7fc4295c8f131d33ce~FSY_aI2jr2460424604epcas1p4N;
        Fri,  4 Jun 2021 05:22:01 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210604052201epsmtrp22d5dc7dfcb41d74b8215bf29e9e73783~FSY_Yo09v3149731497epsmtrp2w;
        Fri,  4 Jun 2021 05:22:01 +0000 (GMT)
X-AuditID: b6c32a39-8d9ff70000002608-c7-60b9b87a1549
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        69.31.08637.978B9B06; Fri,  4 Jun 2021 14:22:01 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.105]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210604052201epsmtip197db2faddef4d760ee11fb730a5f385b~FSY_EnKSQ0192801928epsmtip1W;
        Fri,  4 Jun 2021 05:22:01 +0000 (GMT)
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
Subject: [PATCH v12 3/3] ufs: set max_bio_bytes with queue max sectors
Date:   Fri,  4 Jun 2021 14:03:24 +0900
Message-Id: <20210604050324.28670-4-nanich.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210604050324.28670-1-nanich.lee@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xbZRTPd2+5LWjZpZvsCy6IFRfHa3RQ+JiwLMLwLsOEZMYsM5Fe4Voa
        S9v1MQVNBMsb1vJQ3gxTkWmHkBTGCsokBaU45LGOx2AUlqHbXGAbDWQwh7YUIv+dc36/c37f
        73w5HJzXw/bjSGRqRimjpXzCi9XVfyg0NMvcLQqv/u5l1Ha7lY0WLnYRqMHYBdCD9QkCXZ7T
        E6hnvAmgqsfrOFppb/FAeQVrGNJ+206g62UGDC221+HIMN2FodLFLz3Q82I7hlbvqFDvTDCy
        9TQQqGTKTKBLg5sYslRqMVTd0YCjyflhNuq3T7DQneZyHI0MrXigi3ePo41LvwL06OkUG/1u
        rsTR1EgVgdp714njAZTt5inKpruAUeXaZTbVXTfHpjq+D6Jsf2gok7GIoMoMfYD6pbGVTT35
        c4ZFPbo2QVC6TiOgHCZ/qqCvBKMslhY8ec9ZaWw6Q6cxygBGlipPk8jEcfxTp1PiU4RR4YJQ
        QQyK5gfI6Awmjp+QlByaKJE698UPOE9LNc5SMq1S8Q8fi1XKNWomIF2uUsfxGUWaVCEIV4Sp
        6AyVRiYOS5VnHBWEhx8ROpkiafrAFTtQaD0/XajJYWeDIXYx8ORAMhKa71vxYuDF4ZFmAPX/
        bm4BPHIFQHvuaTewBuCkoZDY6XjQ+dzDDfQCeF97me1OHABWPNMCF4sgQ6BuaYZwAftIEwva
        igqBK8HJuwDeHMrfmrWXTIRT1pktQRb5OnxYqMdcMZd8E3Z0Gjzceq/Af+ZLcVfsScbCyYGS
        bY4PHKpdZLli3MnRXqnfcgHJvzxhY0PF9mMToLXYwXLHe+Hfg53btv2gY7mXcDeUAKjNbwLu
        pAzA5nstmJsVAVccDifAcUocgu09h93lV2H3s0bgVvaGy6ulHi4KJLmwMJ/npgTC4dx5fEfr
        3o/d2xMpWGpsxtz70gM40niDVQYC6nYZqttlqO5/5W8AbgS+jEKVIWZUAoVw9y+bwNYRBcWY
        QfXS4zALwDjAAiAH5+/j/nzQLOJx0+jMLEYpT1FqpIzKAoTOdZfjfi+lyp1XKFOnCIRHIiIi
        UGRUdJQwgr+fK47/TMQjxbSa+ZhhFIxypw/jePplY82itSxsXD0013/MpEukR/PfW7AYjXZ7
        jP9oVZL/UeLds5oLB078RPxWG2Ktbl3aLK8YSxwoTlqxMu3Kyh+mT3oXq0Zp33MHPve+0Ro+
        IJ/1vK2Z0URk1wJxrYQu8lketOe91RlYF++TOKLJXNNvzmM1bX0PO/o/FOpe+yLzTJlkY4pX
        MNhmu5rzdmvri/M1uiC2ucnbcatA73V+9o1S7WYtTx8cqJPveRjnWDAsTg8H13Dr59K/smp6
        fYNNc/uvbVRUvrPuGzv2NCGuPteAf7J00itn9sx1wRM/0RovIS/kav9SlK35/Ujf2P7QW1bR
        By+s4gejyeBzH31dMjaeJuGzVOm0IAhXquj/AAeXn2fNBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWy7bCSnG7ljp0JBidXaVusu7OG3eLBvG1s
        FnNWbWO0ePnzKpvF6rv9bBa7Ls5ntJj24Sezxaf1y1gtWtu/MVk0L17PZnF6wiImiyfrZzFb
        LLqxjcmi50kTq8XfrntMFl8fFlvsvaVtcXnXHDaL7us72CyWH//HZHFocjOTxfTNc5gtrt0/
        w25x+N5VFouHSyYyW5w7+YnVYt5jB4tfy48yWrz/cZ3d4tSOycwW189NY7NYv/cnm4OCx+Ur
        3h6X+3qZPCY2v2P32DnrLrvH5hVaHpfPlnpsWtXJ5jFh0QFGj/1z17B7fHx6i8Xj/b6rbB59
        W1YxenzeJOfRfqCbyePQoWXMAfxRXDYpqTmZZalF+nYJXBlHtt5jLGjmrHgwo5G9gfEkexcj
        J4eEgInEyy1/WbsYuTiEBHYzShzonckCkZCSOH7iLVCCA8gWljh8uBii5iOjRPunBawgNWwC
        OhJ9b2+xgSREBC6wSGxoe8MM4jALvGaU6Hq8CGySsICbxPUTt8DWsQioSrzu6GcCsXkFrCU2
        b1nECrFNXuLP/R5mEJtTwEbi2pFusBohoJqZBy6yQ9QLSpyc+QRsJjNQffPW2cwTGAVmIUnN
        QpJawMi0ilEytaA4Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMjOFVoae5g3L7qg94hRiYOxkOM
        EhzMSiK8e9R2JAjxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TB
        KdXAtPenPdd2Wd8nXMXMhR7hz16tPDt/3W0PyW2nvI9E8e3fJhN8pFbocaC97KbT6kZJYedP
        le/qznn15cLy7frVoexv7tuL3Ncul2dZODXSkdnvm727v5r9nq9WL1bmP3wsYirPsFTEdNvz
        +ESZnT7n3WRnWUs8exrc4ut0LEluovnGcLvO3iWpRb5WgXVOyVLHHu2/sObp3r3LnL+dYjtX
        HrunX0nfZ/uKH1H/r7dwGcjw2Xiv54vndz4XqF17beobltxPrROKA90fuKy/1GuYyWxRcWmH
        VIcwY75Lasqk+6KPTziWCMdOfJvUXr8uW/nsVovF/N0KmjW/sye5HblwJ//rwV1XmnWqGJu+
        zjNVYinOSDTUYi4qTgQA9SDou4QDAAA=
X-CMS-MailID: 20210604052201epcas1p41a27660b20d70b7fc4295c8f131d33ce
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210604052201epcas1p41a27660b20d70b7fc4295c8f131d33ce
References: <20210604050324.28670-1-nanich.lee@samsung.com>
        <CGME20210604052201epcas1p41a27660b20d70b7fc4295c8f131d33ce@epcas1p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set max_bio_bytes same with queue max sectors. It will lead to fast bio
submit when bio size is over than queue max sectors. And it might be helpful
to align submit bio size in some case.

Signed-off-by: Changheun Lee <nanich.lee@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3eb54937f1d8..37365a726517 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4858,6 +4858,7 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 {
 	struct ufs_hba *hba = shost_priv(sdev->host);
 	struct request_queue *q = sdev->request_queue;
+	unsigned int max_bio_bytes;
 
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
 	if (hba->quirks & UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE)
@@ -4868,6 +4869,10 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 
 	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
 
+	if (!check_shl_overflow(queue_max_sectors(q),
+				SECTOR_SHIFT, &max_bio_bytes))
+		blk_queue_max_bio_bytes(q, max_bio_bytes);
+
 	return 0;
 }
 
-- 
2.29.0

