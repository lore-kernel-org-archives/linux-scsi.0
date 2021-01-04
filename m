Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC68C43381
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 10:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7577E224F9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 10:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbhADKsl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 05:48:41 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55488 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbhADKsk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 05:48:40 -0500
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210104104757epoutp03d4996269d2841b4c5f515935b841b908~XAbcE02DF0087500875epoutp03B
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:47:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210104104757epoutp03d4996269d2841b4c5f515935b841b908~XAbcE02DF0087500875epoutp03B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1609757277;
        bh=se1iOPEZbpJwXQhd0pgbmujHr0vCQMYue/1sZVmCAt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0Yw5KzH19Zu3gXh+13AhhgSH6DKdnZnQxLlovu2paw8APiR94L+Rp4Msec0wFOFZ
         IBXlqYK1FQORfnJDAGYbOLLI1+apqzdBS6dx9c9lCF7mx8nZL3RKV6429GsPlKNevf
         GEgl38tRErGCxpJXcVaK8WyLW2wmTyyhhk5E4GUs=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20210104104756epcas5p2463d7073352e6e05c863a2e0fa5e6c3e~XAbbZzIUP1369413694epcas5p2K;
        Mon,  4 Jan 2021 10:47:56 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        54.EB.15682.C52F2FF5; Mon,  4 Jan 2021 19:47:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20210104104245epcas5p26ed395efbf74e78a4e44048a6d7d6ba7~XAW5TGqSH1410114101epcas5p2B;
        Mon,  4 Jan 2021 10:42:45 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210104104245epsmtrp26734063a694e2facc96f3b410277c463~XAW5L3Al02765227652epsmtrp2a;
        Mon,  4 Jan 2021 10:42:45 +0000 (GMT)
X-AuditID: b6c32a49-8bfff70000013d42-ee-5ff2f25c2282
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E8.49.13470.421F2FF5; Mon,  4 Jan 2021 19:42:44 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210104104241epsmtip117c7fe2b1a2f9988eaeba82911994104~XAW2Q7Njl1453914539epsmtip1b;
        Mon,  4 Jan 2021 10:42:41 +0000 (GMT)
From:   SelvaKumar S <selvakuma.s1@samsung.com>
To:     linux-nvme@lists.infradead.org
Cc:     kbusch@kernel.org, axboe@kernel.dk, damien.lemoal@wdc.com,
        Johannes.Thumshirn@wdc.com, hch@lst.de, sagi@grimberg.me,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        bvanassche@acm.org, mpatocka@redhat.com, hare@suse.de,
        dm-devel@redhat.com, snitzer@redhat.com, selvajove@gmail.com,
        nj.shetty@samsung.com, joshi.k@samsung.com,
        javier.gonz@samsung.com, SelvaKumar S <selvakuma.s1@samsung.com>
Subject: [RFC PATCH v4 1/3] block: export bio_map_kern()
Date:   Mon,  4 Jan 2021 16:11:57 +0530
Message-Id: <20210104104159.74236-2-selvakuma.s1@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104104159.74236-1-selvakuma.s1@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTVxjGc+69vb0tKbsWMo7dB9Aom5DyETc9Wza3xLndxX/MMrO5oKzC
        DcWVj7QwUDZlgiJVCzYOpaJgZYpFC9auVrTLUgQFQxBaKOLAGgvJrNgKzAkIDHpr5n/P+z7P
        e37nPTkULi4jJVRWTj6rypErpaSQsLateleWOjGRlrzvVDRqGq4kUXVgGkf7yp9hyP7kBA9d
        N+gwdL6pHUMP/5rkoznNCIbaF8ZJpHMMAGQfSkDO1loS1Z0d5aODbhuJzt2cx9CRA/0Yss7W
        4ch11IAjk89PII/fzUe+550k2n/pH/Dp64zTtZG5qh/mMz0jlwjG2V3AmI0VJHO5YQ9z7W4J
        yTwdHSIY/x/9JKO1GAFz+XYxM2l+myn/8yC2SfSd8KMMVpn1I6tKWve9UOE/PsDPqwovap9q
        wUpAV5gGCChIvwc7DvmABggpMX0NwIaxoVAxAeBJU3WoeAbgea2F93KkaspJcIYdwKML0yRX
        TAKor19yBBRJy+BAgzmoI2kpnGveG5zA6bs47JuZ4C8ZETSC023a4LEEvRLWLpTiS1pEfwxv
        /XIM53DRsKbv32BeQK+Dut4RHpdZBjtrvEEAvpgp/f0EvgSAdKUAuuc1obt+Bp2BbsDpCPjo
        poXPaQmcfGInOV0IxyqqMU6XAKj1F3L6E9h7fW6xTy0CVsHm1iSu/Rb8tcuEcdxweHjWGxoV
        QdspbzAO6TjYdWUN134TBtpaQyQGGi6OhR7rCIBlY2aiCsToX1lH/8o6+v/J9QA3guVsnjo7
        k1W/n5eSwxYmquXZ6oKczMT03GwzCH7U+C9tYNgTSHQAjAIOAClcGikquhNIE4sy5Dt3sarc
        NFWBklU7wBsUIY0S2ZI9aWI6U57P/sCyeazqpYtRAkkJFrE5Zvy1M8Tgtx483bet+N5WWYbV
        FnflflR0pCRMMZVrsmlelO7t9/y02rsz8/nf2kaXtskY/dvatalK4eeuD6KKzxXFpLu6hsYt
        j4+fnEp8VEd2bGml989b6kt1CYbtFO0ji3vmktjRGzyJ9fYunTN2ueVxVqxq5mf4UNe4w9zL
        +3Bw02ysOHmwOX91U0vGA3G57FDkmZGvuosku+35nTVr/CJlXP0txwWrJ15m2DaTsv2GwtRR
        G9GyQ+7s2ZNt++a0uW5LWGPhF4qY9cr1XrbiqnTD7gP37pStVPRprA+OJbj7X6Su6D1bHc5W
        VjVI4y5u2NgpdT995/DXCfeNulwpoVbIU+JxlVr+H94mhXkXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWy7bCSnK7Kx0/xBj1XTCxW3+1ns5j24Sez
        RWv7NyaLve9ms1rsWTSJyWLl6qNMFo/vfGa3+Nt1j8ni6P+3bBaTDl1jtNh7S9vi8q45bBbz
        lz1lt+i+voPNYvnxf0wWEzuuMlls+z2f2eLKlEXMFutev2exePD+OrvF6x8n2SzaNn5ldBDz
        uHzF22PnrLvsHufvbWTxuHy21GPTqk42j81L6j1232xg8/j49BaLx/t9V9k8+rasYvTYfLra
        4/MmOY/2A91MAbxRXDYpqTmZZalF+nYJXBnvZ1xjL5jAV3H0ywamBsZT3F2MnBwSAiYSE75c
        Zuli5OIQEtjNKDH19zMmiISMxNq7nWwQtrDEyn/P2SGKPjJK3Fx8GizBJqArcW3JJhYQW0RA
        SeLv+iawScwCn5kl5u9qA0sIC1hI/DzcxwpiswioSsz538wMYvMK2EqcaJzODLFBXmLmpe/s
        IDangJ3EpIv3gOo5gLbZSixqFYYoF5Q4OfMJ2EhmoPLmrbOZJzAKzEKSmoUktYCRaRWjZGpB
        cW56brFhgWFearlecWJucWleul5yfu4mRnDMamnuYNy+6oPeIUYmDsZDjBIczEoivBUXPsQL
        8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwHT5W7mz2e6T
        ky+knWLJuV+ldKnq7tzyTrsFaS+E89Tyly+M1mUW2DIj5EtfoULmiZA3B7/WOgU5sXUZ3e/v
        /3vDjHFqpn9a+t6eZ1MqwxTjSycwrhGLOLmf9Rszm5HmrlhrQct7i39+PsVx8+k075Kcn7w7
        PwoZyjvUT7vtffRwq8GBpxJHnb5+4Ln01vq9I7PubNWNbgu2/FixmWHHyr/22Sd396W+3JB+
        3WLJinfntlUE+nH7zrRw5Gd46Xj9+ERuN8tf7Qsj9nxMnzfr5irZL+dmpUe6iMpMDCrKyHxl
        v8TyzZ6U1uKoCZ1aujXrlN99cDyi7tQ6LSNpdyPX1j/fRfVMDCoOSV87tG7t5HAlluKMREMt
        5qLiRADXL7wrSAMAAA==
X-CMS-MailID: 20210104104245epcas5p26ed395efbf74e78a4e44048a6d7d6ba7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20210104104245epcas5p26ed395efbf74e78a4e44048a6d7d6ba7
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
        <CGME20210104104245epcas5p26ed395efbf74e78a4e44048a6d7d6ba7@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Export bio_map_kern() so that copy offload emulation can use
it to add vmalloced memory to bio.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
---
 block/blk-map.c        | 3 ++-
 include/linux/blkdev.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 21630dccac62..50d61475bb68 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -378,7 +378,7 @@ static void bio_map_kern_endio(struct bio *bio)
  *	Map the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-static struct bio *bio_map_kern(struct request_queue *q, void *data,
+struct bio *bio_map_kern(struct request_queue *q, void *data,
 		unsigned int len, gfp_t gfp_mask)
 {
 	unsigned long kaddr = (unsigned long)data;
@@ -428,6 +428,7 @@ static struct bio *bio_map_kern(struct request_queue *q, void *data,
 	bio->bi_end_io = bio_map_kern_endio;
 	return bio;
 }
+EXPORT_SYMBOL(bio_map_kern);
 
 static void bio_copy_kern_endio(struct bio *bio)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 070de09425ad..81f9e7bec16c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -936,6 +936,8 @@ extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
 			   gfp_t);
 extern int blk_rq_unmap_user(struct bio *);
+extern struct bio *bio_map_kern(struct request_queue *q, void *data,
+				unsigned int len, gfp_t gfp_mask);
 extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
 extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
 			       struct rq_map_data *, const struct iov_iter *,
-- 
2.25.1

