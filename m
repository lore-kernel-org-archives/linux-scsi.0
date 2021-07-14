Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B8FC07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 935C96138C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238129AbhGNHO6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:14:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21068 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238222AbhGNHO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:14:58 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210714071203epoutp03e48f031f69f5ea583bf1c9bb13508e91~RlsdFXA5Y1977019770epoutp039
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210714071203epoutp03e48f031f69f5ea583bf1c9bb13508e91~RlsdFXA5Y1977019770epoutp039
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246723;
        bh=Usn14cwoAH2iGNudSDG44vuke1ctfhBYfcmgTwhyEoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEni/bzWY6sa/y5uacWQmTB+ex0tNj4jWcyHxZrSj8/GBGkvxfXYcdkGTje2hf/W0
         5UPiMY06ZUdPfxUGwWR8LWbcZ8YGY5p7hxwey0UWqEtiT9VTdkuCaIPwXtIyq3o3tU
         Grihzv5NZ1uv51fsicA3sFTuDdSLmO3+uROyvBds=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210714071202epcas2p338f6e55cf3802ef5bafa2f0171940f3d~Rlsch0ry52304323043epcas2p3f;
        Wed, 14 Jul 2021 07:12:02 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.188]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GPpbM681yz4x9QR; Wed, 14 Jul
        2021 07:11:59 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E0.BF.09541.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071158epcas2p261e6c9157056fafca0f55aaf05cd68ef~RlsZHkV0m0402804028epcas2p2A;
        Wed, 14 Jul 2021 07:11:58 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210714071158epsmtrp1853274cc6ac7b287aac5f4311e561dea~RlsZGsLeJ1252112521epsmtrp1E;
        Wed, 14 Jul 2021 07:11:58 +0000 (GMT)
X-AuditID: b6c32a46-0abff70000002545-f0-60ee8e3f346f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C0.17.08289.E3E8EE06; Wed, 14 Jul 2021 16:11:58 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071158epsmtip259fe1822ef242cfdbbc48fc8d9453007~RlsY5xAno2465824658epsmtip2n;
        Wed, 14 Jul 2021 07:11:58 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v2 01/15] scsi: ufs: add quirk to handle broken UIC command
Date:   Wed, 14 Jul 2021 16:11:17 +0900
Message-Id: <20210714071131.101204-2-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIJsWRmVeSWpSXmKPExsWy7bCmha5937sEg97XGhYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4vz5DewWN7cc
        ZbGYcX4fk0X39R1sFsuP/2NyEPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxROTYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
        ibmptkouPgG6bpk5QH8oKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgoMDQv0ihNz
        i0vz0vWS83OtDA0MjEyBKhNyMl5OnMdScIS3onnhTaYGxhncXYycHBICJhKtt9YxdTFycQgJ
        7GCUeHrsAxuE84lR4vnxi+wQzmdGiYnXL7PDtFyYtYMVIrGLUeL15gaoqo+MEjd6/jKCVLEJ
        6Epsef6KESQhAjJ41eK7LCAOs8BJZonTCw6CzRIW8JbYtvoBC4jNIqAqsbbzFxuIzStgLzGp
        aTXUPnmJU8sOMoHYnAIOEgc3fGCEqBGUODnzCVgvM1BN89bZzCALJAQucEicW7WOFaLZReLs
        u1tsELawxKvjW6CGSkm87G9jh2joZpRoffQfKrGaUaKz0QfCtpf4NX0L0CAOoA2aEut36YOY
        EgLKEkduQe3lk+g4/JcdIswr0dEmBNGoLnFg+3QWCFtWonvOZ6hrPCS2/d7ICAmtyYwS6zbd
        ZprAqDALyTuzkLwzC2HxAkbmVYxiqQXFuempxUYFRsiRvIkRnLa13HYwTnn7Qe8QIxMH4yFG
        CQ5mJRHepUZvE4R4UxIrq1KL8uOLSnNSiw8xmgIDeyKzlGhyPjBz5JXEG5oamZkZWJpamJoZ
        WSiJ83KwH0oQEkhPLEnNTk0tSC2C6WPi4JRqYOKN2Jro/3dBu/JV2awO1fprlTNkcwINwgw/
        L/UVfi5VZW6q+N5yygv/9JfyS1ymn5h7Sna3CNOtIMVPP/f5M1oX6u3+8qw/TXAjk7xqwqsd
        XFtkWbYGafS43D35eyfXzidXjdmYJFkq1I4YB9lG/FXuU9xny77+rSeXTvvdt7d4jCJnpbWw
        G6e5M1wK/fAnwfnm/JmLdvJIy6z7LBZw5oVw381c69NPbi0Xjp5mf4JlViG7fQHDpe355xU7
        L1oKOCy9GdzrUjo9LLpw819vkz91TwT+//p1I4Pz/uOnt64/l3367PrumIkNmy872vxepsO8
        TEtuXX6ObE7KlE8JK0N4X30KFQ+W/+Hrl3IzTImlOCPRUIu5qDgRAI24i3VkBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42LZdlhJXteu712CwZHZ2hYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4vz5DewWN7cc
        ZbGYcX4fk0X39R1sFsuP/2NyEPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxRXDYpqTmZZalF+nYJXBkvJ85jKTjCW9G88CZTA+MM7i5GTg4J
        AROJC7N2sHYxcnEICexglJhzbSo7REJW4tm7HVC2sMT9liOsILaQwHtGiVn3OUFsNgFdiS3P
        XzGCNIsI7GKUOHzmMDuIwyxwmVni27QrzCBVwgLeEttWP2ABsVkEVCXWdv5iA7F5BewlJjWt
        htogL3Fq2UEmEJtTwEHi4IYPjBDb7CX+bVsNVS8ocXLmE7A5zED1zVtnM09gFJiFJDULSWoB
        I9MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzg2NLS2sG4Z9UHvUOMTByMhxglOJiV
        RHiXGr1NEOJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoFp
        vsLFgE8v4x90Suw8Y9vobT67+8Ph9ROZJtaHmxfumiQV/Xy/5APZlQfKXnffjzm3zaDh/c55
        bnGh5wI2dTyIUW9s45+9eFlds8DmqgkfVxxkKH3QWnhvprpJYVqBwLNlxhyen5aefFjbnyiW
        eUS26A+X5SLL2Zs2CfiuTvXa/nV2n/ixzqs8v/Q4hHY8ENx39hL33jOyJ+x+yrP/1V94TJJp
        oWSR97/lZ48veP785d13B3hezeozM9c00Ft/psf/edjhVutXDVHvXq20OPB1WsDatN2b2M4F
        fe1b4Pmdt2vHjvfBUtUXfi/8YWr6TO+nBbeHQfP17fuuLddyEz6sHRmzztms/c29M2uchNY+
        /a/EUpyRaKjFXFScCABon6BlHAMAAA==
X-CMS-MailID: 20210714071158epcas2p261e6c9157056fafca0f55aaf05cd68ef
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071158epcas2p261e6c9157056fafca0f55aaf05cd68ef
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071158epcas2p261e6c9157056fafca0f55aaf05cd68ef@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jongmin jeong <jjmin.jeong@samsung.com>

samsung ExynosAuto9 SoC has two types of host controller interface to
support the virtualization of UFS Device.
One is the physical host(PH) that the same as conventaional UFSHCI,
and the other is the virtual host(VH) that support data transfer function
only.

In this structure, the virtual host does not support UIC command.
To support this, we add the quirk and return 0 when the UIC command
send function is called.

Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b87ff68aa9aa..9702086e9860 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2350,6 +2350,9 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	int ret;
 	unsigned long flags;
 
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
+		return 0;
+
 	ufshcd_hold(hba, false);
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c98d540ac044..e67b1fcfe1a2 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -567,6 +567,12 @@ enum ufshcd_quirks {
 	 * This quirk allows only sg entries aligned with page size.
 	 */
 	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 14,
+
+	/*
+	 * This quirk needs to be enabled if the host controller does not
+	 * support UIC command
+	 */
+	UFSHCD_QUIRK_BROKEN_UIC_CMD			= 1 << 15,
 };
 
 enum ufshcd_caps {
-- 
2.32.0

