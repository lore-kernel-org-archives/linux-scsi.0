Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85269C47098
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 05:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F52861413
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 05:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhFDFX4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 01:23:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43099 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhFDFXv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 01:23:51 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210604052204epoutp024ae008fa3d02138ffd0aac408db63195~FSZApv5aE1395713957epoutp02M
        for <linux-scsi@vger.kernel.org>; Fri,  4 Jun 2021 05:22:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210604052204epoutp024ae008fa3d02138ffd0aac408db63195~FSZApv5aE1395713957epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622784124;
        bh=dBTkcRF1EwwTLRDQEUEpnUBw+DAWxtwHogmD1mCaBqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6hh90nRdNTBC149eFv15RdRs8LJmgzpBKmuVJdkDoRft+hT4g9LteGxcAtHT63Rp
         lwl+gR7pxA6aKJWGQJEGNiFUuy6IuXqh8Om1Q6Vq4c2qP5oGIjJDKE4gJ4P08Yzal8
         l92I7J//bKlnYIZm6mrUY7IZNK68qMYxjoGyTw5k=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210604052202epcas1p140e2c4bc04907484ff1fcc613e96d017~FSY-dJOMI0225902259epcas1p1g;
        Fri,  4 Jun 2021 05:22:02 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.164]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4FxB2x4dcfz4x9Pr; Fri,  4 Jun
        2021 05:22:01 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        54.7F.09736.978B9B06; Fri,  4 Jun 2021 14:22:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210604052200epcas1p10754a3187476a0fcbfcc89c103a6d436~FSY9ISwf10225902259epcas1p1T;
        Fri,  4 Jun 2021 05:22:00 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210604052200epsmtrp18ee4ce07b450a1cdebb70976cc044751~FSY9GhmKz0501405014epsmtrp1N;
        Fri,  4 Jun 2021 05:22:00 +0000 (GMT)
X-AuditID: b6c32a39-8d9ff70000002608-c1-60b9b879ca12
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        44.6E.08163.878B9B06; Fri,  4 Jun 2021 14:22:00 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.105]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210604052200epsmtip13ec7151c706c93536dbc88b8f538c07e~FSY81ghg13167931679epsmtip1h;
        Fri,  4 Jun 2021 05:22:00 +0000 (GMT)
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
Subject: [PATCH v12 2/3] blk-sysfs: add max_bio_bytes
Date:   Fri,  4 Jun 2021 14:03:23 +0900
Message-Id: <20210604050324.28670-3-nanich.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210604050324.28670-1-nanich.lee@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTZxTfd2+5LWzYO5T5QTJkzaYDgVKx8Ol4GXS5iy4hLibDF3RwU8j6
        Sm9ZZG6TUVYtzyIOYuWxAIMF0SaFYelkkIIxCGO68lDCQwKzg4THeDhAIWu5uPHf75zzO+d3
        zu/Lx8O9LFxfXppCQ6sVEpmA8OA0dwQIgzMsLUmh5TN+6PZwAxc9rWgmUFl9M0BTq/0EujlS
        SCDro0qASuZXcbRgqnVD311+jiFttYlA3YYqDE2ajDiqetyMobzJLDe0njOKoeVxBrUO7Ud2
        axmBcgctBKq7v4EhW7EWQ6WNZTgaGOvhoo7Rfg4arynCUW/XghuqmIhFa3X3AJpbGeSiB5Zi
        HA32lhDI1LpKxPpT9r7jlL0gH6OKtLNcqsU4wqUafwqk7L+lU+Z6PUEZqtoB1VbewKX+/nOI
        Q8392k9QBU31gFo0+1GX23MxymarxeP5p2WRqbQkhVb704pkZUqaQholOP5JYlyiODxUFCw6
        hCIE/gqJnI4SHD0RH/xhmszpl8D/C4ks3ZmKlzCMQBgdqVama2j/VCWjiRLQqhSZShSqCmEk
        ciZdIQ1JVsoPi0JDD4idzCRZ6t1H5UDV4XOhqGIQywQD3jmAx4PkQfhklskBHjwv0gLg2vQk
        lw0WAKwtdWBssAjgs+7nzor7Zkd+dzfhwl6kFcChIc1/JJ09Z7NAkEGwYGaIcBV2kWYOtOuv
        AFeAkxMA9nXpNlk7STGcbJzguBbhkO/BjmqJK+1JfgDbhx1banvgy7E83IXdyUg40JmLsZw3
        Ydf1SY4L406O9ucbuGs+JJ+5w/rRNoJtPgoH83s5LN4Jp+83bQ31hVOFOi7bkAugVlcJ2MAA
        YI2jFmNZYXBhcRG4tsPJAGiyCtn0O7DlRTlglXfA2eU8N9ZJT3hF58VS3oU92WP4Ky3HrZat
        iRSctq5wWLsKAdRf1QMD8DduO8i47SDj/8o/ALwevEWrGLmUZkQq8fY3NoPNLxR4yAJKZ+ZD
        bADjARuAPFywy/PuXkuSl2eKJONLWq1MVKfLaMYGxE63i3Bf72Sl8w8qNIki8YGwsDB0MDwi
        XBwm2O0pjbuY5EVKJRr6c5pW0epXfRjP3TcTy3h7XW27FBnzqft44cTt1yLrS4+Ahz4J+wOC
        5l4+TlhqkPOvL8UhXdaZbzXdQr+giQe7+X80G1rOuMVEDx+r69TG/XKt4NJnPlk955oywR1q
        yqSNsHNsyPsccuQTRzK/4p8dsXyzHn+4bM1Yx5+NMXz/8The0oaLgpNJ0Z2le+37SvqP3SqR
        mmKFXP0Los5zsPiaMJi8OFPDxJ/2nnIjN9ZOqpr0583LSrNZXjBsOynnV7xfPX1jj87+z/x5
        vvrs2IlTCQ/Xsvftnf1LD1+P/r3yo6d95q8j9QaqMyhn6oIjLGh6Ze4U1nhTvCNW1h7xpNWc
        7WHd+DG+beKNYUAIBBwmVSIKxNWM5F8Y3XxFywQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsWy7bCSnG7Fjp0JBs+miFqsu7OG3eLBvG1s
        FnNWbWO0ePnzKpvF6rv9bBa7Ls5ntJj24Sezxaf1y1gtWtu/MVk0L17PZnF6wiImiyfrZzFb
        LLqxjcmi50kTq8XfrntMFl8fFlvsvaVtcXnXHDaL7us72CyWH//HZHFocjOTxfTNc5gtrt0/
        w25x+N5VFouHSyYyW5w7+YnVYt5jB4tfy48yWrz/cZ3d4tSOycwW189NY7NYv/cnm4OCx+Ur
        3h6X+3qZPCY2v2P32DnrLrvH5hVaHpfPlnpsWtXJ5jFh0QFGj/1z17B7fHx6i8Xj/b6rbB59
        W1YxenzeJOfRfqCbyePQoWXMAfxRXDYpqTmZZalF+nYJXBl7Ls5lLDgsWTFx3nWmBsZrol2M
        nBwSAiYSvadPs3UxcnEICexglPi7tpsFIiElcfzEW9YuRg4gW1ji8OFiiJqPjBIr5v8Dq2ET
        0JHoe3sLrFlE4AKLxIa2N8wgDrPAa0aJrseLwKqEBUwlnmx+zAIyiUVAVeLw4kSQMK+AtcSB
        O8/ZIZbJS/y538MMYnMK2EhcO9LNBGILAdXMPHCRHaJeUOLkzCdgI5mB6pu3zmaewCgwC0lq
        FpLUAkamVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwYlCS2sH455VH/QOMTJxMB5i
        lOBgVhLh3aO2I0GINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYO
        TqkGpkPLGBtuFRrU+JUofI08xfLgs6Xlwn0XWe+9eTd5Mnu1lYBecMJVSdfVuQuZfIWmZkW6
        Vmjc/bbsYvLHpU8i/eInRwYeDl/o+0M/xr13nff05yd3B02afnf/7MNx80XMXi09/P+KavGU
        yX+/CE+uuSAmZWD3+PtlW6W7R376ZTiK/4+QzNvIKOazYtnVv4qzuDyP1Jw7fz9YetHMiX5y
        AkGitSlPd7Vdn25bXR8b4/H59l21sBnV+kxzTZ6Z8D+wOjjX61ieqEWuuvrHt169lX1rrBlq
        9xwwUv7mLnw8oaxx2t+VwtqM/nfN1CRfdGjlbdd1zfTu4vLqmHL3kl0p4+3/6+V+a3CvaQpu
        W/VuhRJLcUaioRZzUXEiAIhwMjmDAwAA
X-CMS-MailID: 20210604052200epcas1p10754a3187476a0fcbfcc89c103a6d436
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210604052200epcas1p10754a3187476a0fcbfcc89c103a6d436
References: <20210604050324.28670-1-nanich.lee@samsung.com>
        <CGME20210604052200epcas1p10754a3187476a0fcbfcc89c103a6d436@epcas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add max_bio_bytes block sysfs node to show current maximum bio size.

Signed-off-by: Changheun Lee <nanich.lee@samsung.com>
---
 Documentation/ABI/testing/sysfs-block | 10 ++++++++++
 Documentation/block/queue-sysfs.rst   |  7 +++++++
 block/blk-sysfs.c                     |  7 +++++++
 3 files changed, 24 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index e34cdeeeb9d4..8c8a793c04b4 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -316,3 +316,13 @@ Description:
 		does not complete in this time then the block driver timeout
 		handler is invoked. That timeout handler can decide to retry
 		the request, to fail it or to start a device recovery strategy.
+
+What:		/sys/block/<disk>/queue/max_bio_bytes
+Date:		June 2021
+Contact:	Changheun Lee <nanich.lee@samsung.com>
+Description:
+		max_bio_bytes is the maximum bio size to be submitted in bytes.
+		It shows current maximum bio size, and bio size to be submitted
+		will be limited with this. Default value is UINT_MAX, and
+		the minimum value is 1MB. 1MB(=BIO_MAX_VECS * PAGE_SIZE) is
+		legacy maximum bio size.
diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index 4dc7f0d499a8..90af56899aa9 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -286,4 +286,11 @@ sequential zones of zoned block devices (devices with a zoned attributed
 that reports "host-managed" or "host-aware"). This value is always 0 for
 regular block devices.
 
+max_bio_bytes (RO)
+---------------------------
+This is the maximum number of bytes that bio size to be submitted will be
+limited. A value of 4,294,967,295(UINT_MAX) means no limit of bio size,
+and it's a default value. The minimum value is 1MB. It's legacy maximum
+bio size. (=BIO_MAX_VECS * PAGE_SIZE)
+
 Jens Axboe <jens.axboe@oracle.com>, February 2009
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e03bedf180ab..c4cae6bbcb3b 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -108,6 +108,11 @@ queue_ra_store(struct request_queue *q, const char *page, size_t count)
 	return ret;
 }
 
+static ssize_t queue_max_bio_bytes_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->limits.max_bio_bytes, (page));
+}
+
 static ssize_t queue_max_sectors_show(struct request_queue *q, char *page)
 {
 	int max_sectors_kb = queue_max_sectors(q) >> 1;
@@ -577,6 +582,7 @@ static struct queue_sysfs_entry _prefix##_entry = {	\
 
 QUEUE_RW_ENTRY(queue_requests, "nr_requests");
 QUEUE_RW_ENTRY(queue_ra, "read_ahead_kb");
+QUEUE_RO_ENTRY(queue_max_bio_bytes, "max_bio_bytes");
 QUEUE_RW_ENTRY(queue_max_sectors, "max_sectors_kb");
 QUEUE_RO_ENTRY(queue_max_hw_sectors, "max_hw_sectors_kb");
 QUEUE_RO_ENTRY(queue_max_segments, "max_segments");
@@ -635,6 +641,7 @@ QUEUE_RW_ENTRY(queue_stable_writes, "stable_writes");
 static struct attribute *queue_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
+	&queue_max_bio_bytes_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
 	&queue_max_segments_entry.attr,
-- 
2.29.0

