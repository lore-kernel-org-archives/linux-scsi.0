Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6253CC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37703207E8
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:19:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sCT8e3+a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgGBCTp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 22:19:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14485 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgGBCTo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 22:19:44 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200702021940epoutp025fead3c1eaf190e81c452e21f481950a~dzgjnWEAa2964329643epoutp02J
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 02:19:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200702021940epoutp025fead3c1eaf190e81c452e21f481950a~dzgjnWEAa2964329643epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593656380;
        bh=r7kUX4UcXe7HMc73nzVqAyFro9BjYsB6qngfu6nQ/Ks=;
        h=From:To:Cc:Subject:Date:References:From;
        b=sCT8e3+advbjjag2Kmi2QdkILFeSgju+R6e4aAJR5iBAZc+b1AthZfF9an+nUIbVZ
         6zFabGfHoHxyoe1XIGjn57qoJCov6Hx2Llo/yz32wc4m7e+7Z1yYwH0UHSe72jk5Cu
         nBFrRznnVmArZGaGnM5FM5BLIJgW1Pn5f9DM+J6s=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200702021940epcas2p25c2c4b280ccc49c75e3c9ceb4ff4b95b~dzgjE3nhU0929409294epcas2p2S;
        Thu,  2 Jul 2020 02:19:40 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.188]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49y1y226wfzMqYkm; Thu,  2 Jul
        2020 02:19:38 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        29.11.19322.8344DFE5; Thu,  2 Jul 2020 11:19:36 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200702021936epcas2p47d80e5454fda632c7ebf31fcfa48a0a2~dzgfpUxYV2807328073epcas2p4r;
        Thu,  2 Jul 2020 02:19:36 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200702021936epsmtrp2ced220055981b2d9ce615456d7575a00~dzgfoj0c81404614046epsmtrp2u;
        Thu,  2 Jul 2020 02:19:36 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-39-5efd4438e054
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        5B.80.08303.8344DFE5; Thu,  2 Jul 2020 11:19:36 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200702021936epsmtip1daea65dca760f66e33b97ba79f8fd4bf~dzgfeAFrC2260322603epsmtip1B;
        Thu,  2 Jul 2020 02:19:36 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1 0/2] ufs: support various values per device
Date:   Thu,  2 Jul 2020 11:11:47 +0900
Message-Id: <cover.1593655834.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsWy7bCmha6Fy984g3ULTCwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLRbd2MZkcXPLURaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARlWOTkZqYklqkkJqXnJ+SmZduq+Qd
        HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SjkkJZYk4pUCggsbhYSd/Opii/tCRVISO/
        uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIhJ+Nf0xymgqMsFf/n7mFvYLzI3MXI
        ySEhYCLx6fBBti5GLg4hgR2MEnfOn4ZyPjFKXD/TyAZSJSTwmVHixh1PmI4n3esZIYp2MUps
        PLYGqugHo8TBfXEgNpuApsTTm1OZQIpEBG4wSsxpPswKkmAWUJfYNeEEE4gtLGAnMe3RJbA4
        i4CqxLbNP8EG8QpYSKzd0sIKsU1O4ua5TmaQQRICt9glth59DZTgAHJcJJbPjYOoEZZ4dXwL
        O4QtJfH53V42CLteYt/UBlaI3h5Giaf7/jFCJIwlZj1rZwSZwwx06fpd+hAjlSWO3GKBOJNP
        ouPwX3aIMK9ER5sQRKOyxK9Jk6GGSErMvHkHaquHxIKzv5hAyoUEYiWaP+ZNYJSdhTB+ASPj
        Kkax1ILi3PTUYqMCQ+Qo2sQITnVarjsYJ7/9oHeIkYmD8RCjBAezkgjvaYNfcUK8KYmVValF
        +fFFpTmpxYcYTYGhNZFZSjQ5H5hs80riDU2NzMwMLE0tTM2MLJTEeXMVL8QJCaQnlqRmp6YW
        pBbB9DFxcEo1MPlqJrWnPlzRethNyrhyx4RbZtLRu2p0zgee7mq8amv3bt/2Zcta7xzcp/72
        ouzKC7pM3GU9/476GfhIzahTuzurQrbhfvghy4S0EDmednP9y8Y/ctKyv6ou3KvwjF+2SPtD
        PZ/GESWdy87W2+S3HjlnsCVLeH7N4fNnrpuzlJQ4Z8vwRlyu0y9T3Os80/jM6ZqI12+ObHOQ
        lav+pfQq/8u5BrPbP2dlOx3XbA86/+PkJa318p+lfu8MOiSnxjHHr+ej6W+Wux9n9ueaXuZT
        mcPhG9TAm1cyYcdC7yWfDd/fmrGG33LvGZczdcv0mzOPBCZu2SGrmMzziYPzzOTc5qm8kdF2
        5R9XJXx7YC/1TYmlOCPRUIu5qDgRAMlGye3+AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsWy7bCSnK6Fy984g7mLZS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLRbd2MZkcXPLURaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARxWWTkpqTWZZapG+XwJXxr2kOU8FR
        lor/c/ewNzBeZO5i5OSQEDCReNK9nhHEFhLYwShxZTITRFxS4sTO54wQtrDE/ZYjrF2MXEA1
        3xglvs6fBtbMJqAp8fTmVCaQhIjAI0aJ3zM72UESzALqErsmnACbJCxgJzHt0SVWEJtFQFVi
        2+afbCA2r4CFxNotLawQG+Qkbp7rZJ7AyLOAkWEVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpe
        cn7uJkZwAGpp7WDcs+qD3iFGJg7GQ4wSHMxKIrynDX7FCfGmJFZWpRblxxeV5qQWH2KU5mBR
        Euf9OmthnJBAemJJanZqakFqEUyWiYNTqoFJ+ca0vmuhb5SLlqf5/bu2qjk79KVF67Sb9Utu
        FV51ms50YoUu68XlJ05ViliWzJN9fbP1LWvQD6cJz3/cX1q8cvbMgy36ppLzFA1ynuyIPaph
        XfI+OdVHVpOljOlnBscnxdI4/ap7Sz/tcjXVl5Jfvq3hk9yzf3HWuR4XPab9KapdbtqzK5fz
        Qf5ZVisb/eOKr7cx7naxntgpLrjGjCF85WrzNKOEBO6Mc9sSE7wnzRdScYrLT5QRW1R/O62x
        5p39ww19ek/t4wpYm0oTppxT9I5ZJSb7lP1yqVHB8moOnqhTuYfZwr4ErT/P9XJXZfSPDXtX
        Cpz+1bTOlFE/Q/DS9RWXpi5k4FZ2cN0yIUqJpTgj0VCLuag4EQBI2JOqrwIAAA==
X-CMS-MailID: 20200702021936epcas2p47d80e5454fda632c7ebf31fcfa48a0a2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200702021936epcas2p47d80e5454fda632c7ebf31fcfa48a0a2
References: <CGME20200702021936epcas2p47d80e5454fda632c7ebf31fcfa48a0a2@epcas2p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Respective UFS devices have their own characteristics and
many of them could be a form of numbers, such as timeout
and a number of retires. This introduces the way to set
those things per specific device vendor or specific device.

Kiwoong Kim (2):
  ufs: support various values per device
  ufs: change the way to complete fDeviceInit

 drivers/scsi/ufs/ufs_quirks.h | 13 ++++++++
 drivers/scsi/ufs/ufshcd.c     | 75 ++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.h     |  1 +
 3 files changed, 77 insertions(+), 12 deletions(-)

-- 
2.7.4

