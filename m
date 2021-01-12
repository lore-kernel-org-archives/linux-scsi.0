Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168DFC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 02:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC10122D37
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 02:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733164AbhALC57 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 21:57:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34017 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731730AbhALC56 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 21:57:58 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210112025715epoutp01b47e741c6437e5853ea0235fb0cb7543~ZXKv5R7oj2805528055epoutp01Z
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 02:57:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210112025715epoutp01b47e741c6437e5853ea0235fb0cb7543~ZXKv5R7oj2805528055epoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610420235;
        bh=lSD8CDrtsaZKKAn6dDZy3/nhCk/tMa3eJPuirqvDXqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=X5rgY3/2C69uTHuzq2NxzCeGcexxgQds+ZrfQ7SqLFf4DTLHQPD1rjHBI0qd4xzTA
         dm8WedvkfDjXHfLXV4LonMJOKjwFd5DF6zR28yW9AZU8Pn0yZMjsAXs6ciS/YK3ru3
         ihDRvaewlPBmCIKM2L8h+yOi0M6wRXS936KixE+Q=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210112025714epcas2p3441957199dac2225ec850449228a933d~ZXKvAznwq1840518405epcas2p3j;
        Tue, 12 Jan 2021 02:57:14 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DFFbr3mljz4x9Q8; Tue, 12 Jan
        2021 02:57:12 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        D8.D9.05262.8001DFF5; Tue, 12 Jan 2021 11:57:12 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210112025711epcas2p2cead60e95ad9ac77e917d0bdc9c4d672~ZXKslMF6q2847228472epcas2p2C;
        Tue, 12 Jan 2021 02:57:11 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210112025711epsmtrp2058eaa7904272447dd03d44fd23c9329~ZXKskWfSl2322723227epsmtrp28;
        Tue, 12 Jan 2021 02:57:11 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-fe-5ffd1008be4d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        83.DC.13470.7001DFF5; Tue, 12 Jan 2021 11:57:11 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210112025711epsmtip10618dfe299a169b60944904b13cea200~ZXKsW-loo0827708277epsmtip1E;
        Tue, 12 Jan 2021 02:57:11 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v5 1/2] ufs: add a vops to configure block parameter
Date:   Tue, 12 Jan 2021 11:45:55 +0900
Message-Id: <c64020d92ed78ebccf2877c35a2bad341e34aa71.1610419491.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1610419491.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1610419491.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmhS6HwN94gzkfZSwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBE5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIyXjy2b7gGk/FyiVsDYzHuboYOTkkBEwktu38zNTFyMUhJLCDUeLTq99sEM4nRonn
        E98wQzjfGCX+Tl/NDNNy/8kJRojEXkaJxe/OskA4PxglHh96ywJSxSagKfH05lSwwSICZ5gk
        rrWeZQVJMAuoS+yacIIJxBYWcJHYvbCNEcRmEVCVaG6Zww5i8wpES1y/sABqnZzEzXOdYDan
        gKXE0YlNrKhsLqCamRwS0449Z4FocJF4sf0lE4QtLPHq+BZ2CFtK4vO7vWwQdr3EvqkNUM09
        jBJP9/1jhEgYS8x61g5kcwBdqimxfpc+iCkhoCxx5BYLxP18Eh2H/7JDhHklOtqEIBqVJX5N
        mgw1RFJi5s07UFs9JA4unMkOCSCgTZe3fmGZwCg/C2HBAkbGVYxiqQXFuempxUYFxsixt4kR
        nFK13Hcwznj7Qe8QIxMH4yFGCQ5mJRFerw1/4oV4UxIrq1KL8uOLSnNSiw8xmgIDciKzlGhy
        PjCp55XEG5oamZkZWJpamJoZWSiJ8xYbPIgXEkhPLEnNTk0tSC2C6WPi4JRqYGJ8uGmh7tq2
        uWGtP2M6zNWyO7T9ry/xSknzOxd7sVi1UE7l1cYZFlZZJbeOfo5gbQrboj2X75X4O6Hghcmz
        ZKbbuQd1RwWs1VrlcD1v4XfFx57r2OVaP24I2nv9xWwh9ZoC0z6V9MVx1aUhUlm/mt6YXONg
        XXjlpbXwTMF3pZHVnZLT7V6XLn3qkdxrdX+Fz45GwQvnNHdFGlnqznrJ6xcXke6vvGLWySn7
        Hovv7fg+U2xu29/UlmjpVYbHpvbLeyanfD28/pVDjE1rh5qjfuv5VvWPrTeeydu6Pd75+1Cw
        xOGW+KLcNyJHrrfuKgnp9j23KU5EesuvlNX5zlst73Z83bJry4Hl0Q4VU2dyK7EUZyQaajEX
        FScCAAeQrMwyBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWy7bCSnC67wN94g29fDCwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGU8+WxfcI2nYuUStgbG41xdjJwcEgImEvefnGDsYuTiEBLY
        zSjx+dZHdoiEpMSJnc8ZIWxhifstR1ghir4xStxZ95UJJMEmoCnx9OZUJpCEiMA9JolLE+Yy
        gySYBdQldk04AVYkLOAisXthG9gkFgFVieaWOWAbeAWiJa5fWMAMsUFO4ua5TjCbU8BS4ujE
        JqBtHEDbLCQO79TEITyBUWABI8MqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgaNDS
        3MG4fdUHvUOMTByMhxglOJiVRHi9NvyJF+JNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBA
        emJJanZqakFqEUyWiYNTqoHJ9t3B0MfhrkqXJWyzsxYnis85U6Rj8PUtf93q9XzHfmyxvcs6
        JXLJgvRn21pV7CQ5lS+2Scvdy1+W+uLuMaNf5wJrtmyydVl+Rv/vY5H1EROkciv4Q72S3203
        d2e9mPM65LZF1tygT24HD4jP0X0aumTh02DfrDiHmYKvA0177s9PibcRFf60xFnXxJolZ7Zi
        uNaFy7/+TAiWFEqQK4vS+m+/rbMh59YZ4Zi/1iztU+w8L9+zXfctIPWT48ONkTGlxw9+qWHr
        kp33YOnnjT9zz7v3218OiM/zUhE49so/xjXMfPuaZxU7Zi69Ok+AS33O501vc4L3XVx242/J
        1rsmK1wTZc4/MtpkXlezQGK2EktxRqKhFnNRcSIAY6SFmvUCAAA=
X-CMS-MailID: 20210112025711epcas2p2cead60e95ad9ac77e917d0bdc9c4d672
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210112025711epcas2p2cead60e95ad9ac77e917d0bdc9c4d672
References: <cover.1610419491.git.kwmad.kim@samsung.com>
        <CGME20210112025711epcas2p2cead60e95ad9ac77e917d0bdc9c4d672@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There could be some cases to set block parameters
per host, because of its own dma structure or whatever.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 drivers/scsi/ufs/ufshcd.h | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 92d433d..5f89b0e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4758,6 +4758,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 
 	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
 
+	ufshcd_vops_slave_configure(hba, sdev);
+
 	return 0;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 61344c4..4bf4fed 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -329,6 +329,7 @@ struct ufs_hba_variant_ops {
 					void *data);
 	int	(*program_key)(struct ufs_hba *hba,
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
+	void	(*slave_configure)(struct scsi_device *sdev);
 };
 
 /* clock gating state  */
@@ -1228,6 +1229,13 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
 		hba->vops->config_scaling_param(hba, profile, data);
 }
 
+static inline void ufshcd_vops_slave_configure(struct ufs_hba *hba,
+						    struct scsi_device *sdev)
+{
+	if (hba->vops && hba->vops->slave_configure)
+		hba->vops->slave_configure(sdev);
+}
+
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /*
-- 
2.7.4

