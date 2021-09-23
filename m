Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D657FC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 03:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB1EE6103D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 03:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239317AbhIWDut (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 23:50:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28746 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239485AbhIWDui (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 23:50:38 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210923034905epoutp025e443d920d06dcba747ce7d49d74c96d~nVuhFBAVe0831508315epoutp02k
        for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2021 03:49:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210923034905epoutp025e443d920d06dcba747ce7d49d74c96d~nVuhFBAVe0831508315epoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632368945;
        bh=w/S7TtBdz8srpqEadBEQZ613d8GexlHxQ0Y3hRegXMY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=pcnWT14bTk6f/Ne5JaysloKj2ZPl5nPKds+aXqqs/lowmumy7K19i+5R787XASiKi
         rM/qkwpG0PG/gLB7hEk7TQju4OCSkDxMW0KzBWzB5EkoQZTCfQkNVXYeF6YHqhzLJp
         5Vwdxbe30OXjTBlaScv5c4HIqTRmg+Sh26uiC8GQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210923034904epcas5p3469c1517079abba3ea606774a529310b~nVugVQLjV0223602236epcas5p3f;
        Thu, 23 Sep 2021 03:49:04 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HFLkS4vpPz4x9QP; Thu, 23 Sep
        2021 03:49:04 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F4.B2.59762.E29FB416; Thu, 23 Sep 2021 12:49:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210923034852epcas5p42a783fe54ca331817ea1c6ef2e0d5666~nVuUgjV6O1670016700epcas5p4B;
        Thu, 23 Sep 2021 03:48:52 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210923034852epsmtrp2027d6de5d67282b076ec26d1001b6bb6~nVuUgnNPf2023220232epsmtrp2L;
        Thu, 23 Sep 2021 03:48:52 +0000 (GMT)
X-AuditID: b6c32a49-125ff7000000e972-c0-614bf92e1173
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7E.9F.08750.329FB416; Thu, 23 Sep 2021 12:48:51 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210923034836epsmtip1c7ed7360ee540068c311ca99338d1289~nVuF0duhk1339813398epsmtip1P;
        Thu, 23 Sep 2021 03:48:35 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Chanho Park'" <chanho61.park@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>
Cc:     "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "'jongmin jeong'" <jjmin.jeong@samsung.com>
In-Reply-To: <20210917065436.145629-3-chanho61.park@samsung.com>
Subject: RE: [PATCH v3 02/17] scsi: ufs: add quirk to enable host controller
 without ph configuration
Date:   Thu, 23 Sep 2021 09:18:28 +0530
Message-ID: <000701d7b02d$ec4cec00$c4e6c400$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQFXHrrjAcX6R3Cp783F8A==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmpq7eT+9Egyu/tC1OPlnDZvHy51U2
        i4MPO1kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3CYuPbH0wWM87v
        Y7Lovr6DzWL58X9MDvwel694e8xq6GXzuNzXy+SxeYWWx+I9L5k8Nq3qZPOYsOgAo8f39R1s
        Hh+f3mLx6NuyitHj8yY5j/YD3UwBPFHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
        FuZKCnmJuam2Si4+AbpumTlAzygplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCkwK
        9IoTc4tL89L18lJLrAwNDIxMgQoTsjMertjFWnBEvGLavBMsDYydIl2MHBwSAiYST454dTFy
        cQgJ7GaUeLLgHCOE84lRYsmfVVDOZ0aJNT9esXQxcoJ1nFrwGSqxi1HieetWNgjnJaPEr6u7
        mUCq2AR0JXYsbgNLiAg0MkmcfryZGSTBLDCTWWL1K0MQm1PAQeL441NgDcIC6RI7+zawg9gs
        AqoS25ZPZQWxeQUsJY40/maGsAUlTs58wgIxR1ti2cLXzBAnKUj8fLqMFeQhEQEniQMzLCFK
        xCVeHj3CDlHSzClx52Q6hO0iseX3VahWYYlXx7dA1UhJfH63lw0SLtkSPbuMIcI1EkvnHYN6
        3l7iwJU5LCAlzAKaEut36UOEZSWmnlrHBLGVT6L39xMmiDivxI55MLaqRPO7q1BjpCUmdnez
        TmBUmoXkr1lI/pqF5IFZCNsWMLKsYpRMLSjOTU8tNi0wzEsth0d3cn7uJkZwStfy3MF498EH
        vUOMTByMhxglOJiVRHg/3/BKFOJNSaysSi3Kjy8qzUktPsRoCgzsicxSosn5wKySVxJvaGJp
        YGJmZmZiaWxmqCTO+/G1ZaKQQHpiSWp2ampBahFMHxMHp1QDk+aF01MY4le/7NWSUHr6zrn2
        /rag7giOL233v0ydKu/+4JD1tlaW8vSXAXlqOUtPsv5a//b/je2Kr3xP77dzd/a75+4f9XY6
        y+vE+9Nn2SqGRgr7+8pMeX/L18Nsx5HfPhsyXi+99VH/xoPNPxutnr2rFWm7HLM0/0K4++Pd
        Si/3x7+8cu5TWcgfCxvXEDfDvV8ctrb+ETh3K1Rc5MKS3ozaKH3pBYIuDLPnvPmslp31+wTz
        3cl67UwpARttTokxPrs24eCxlqU72DjO571yOv9O4Ya5tZpSe5WB/K/nJtVXwyXmZGc9eOLV
        5O5Q3XGxrdBs169Hez4ubC8uCDsn4MN2+XzCozUvHgm8cXi4pFOJpTgj0VCLuag4EQAGNaXZ
        cgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWy7bCSnK7yT+9Egy/X1C1OPlnDZvHy51U2
        i4MPO1kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3CYuPbH0wWM87v
        Y7Lovr6DzWL58X9MDvwel694e8xq6GXzuNzXy+SxeYWWx+I9L5k8Nq3qZPOYsOgAo8f39R1s
        Hh+f3mLx6NuyitHj8yY5j/YD3UwBPFFcNimpOZllqUX6dglcGR2rzrMWfBarWDNpKXMD4zbh
        LkZODgkBE4lTCz4zdjFycQgJ7GCU6PtwlhUiIS1xfeMEdghbWGLlv+dgtpDAc0aJOZ/VQGw2
        AV2JHYvb2ECaRQSamSRmNpwBm8QssJBZ4tG/fhaIsUcZJX5c+ccE0sIp4CBx/PEpMFtYIFVi
        //9rbCA2i4CqxLblU8FW8wpYShxp/M0MYQtKnJz5hAXEZhbQlnh68ymcvWzha2aI8xQkfj5d
        BtTLAXSGk8SBGZYQJeISL48eYZ/AKDwLyaRZSCbNQjJpFpKWBYwsqxglUwuKc9Nziw0LjPJS
        y/WKE3OLS/PS9ZLzczcxgqNbS2sH455VH/QOMTJxMB5ilOBgVhLh/XzDK1GINyWxsiq1KD++
        qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGphKtsDULjgoeO/1yu1eIkHyI
        5ZGT+THb/NarR/SYpsp8und4c0rDj70Gd1ji9CYHnGO8fTTt4JL+M9ts5530rGTZvJ5r6s11
        /4Jr77GkSWVUl/1zuVMvIv1u29oupferL691DdKcvvP+0TnGyU/fP3lj5VXwVf1VsFSe2A9d
        tgXT5i1xuXVlmfOsvLb3rxmzJje/m9ZyT/Hr3AlN5qI8d5uDbvZb7VmS4XPgrsmNad9mbz5c
        c3FFU9WehOJf8YJvBQ1zZ4WGT1mesoBJ93tiMu98yT1xEVtW5the8OXYYmHyMF9ydvur/FUP
        Xqz0bry+2mbGl8q2LbMcGTNPzj4TJWzoO8XdcvUlke0S7OUa0bOUWIozEg21mIuKEwEUa3R+
        XQMAAA==
X-CMS-MailID: 20210923034852epcas5p42a783fe54ca331817ea1c6ef2e0d5666
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065522epcas2p4ed13768faa6aa6d33116606e2601321e
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065522epcas2p4ed13768faa6aa6d33116606e2601321e@epcas2p4.samsung.com>
        <20210917065436.145629-3-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



>-----Original Message-----
>From: Chanho Park =5Bmailto:chanho61.park=40samsung.com=5D
>Sent: Friday, September 17, 2021 12:24 PM
>To: Alim Akhtar <alim.akhtar=40samsung.com>; Avri Altman
><avri.altman=40wdc.com>; James E . J . Bottomley <jejb=40linux.ibm.com>; M=
artin
>K . Petersen <martin.petersen=40oracle.com>; Krzysztof Kozlowski
><krzysztof.kozlowski=40canonical.com>
>Cc: Bean Huo <beanhuo=40micron.com>; Bart Van Assche
><bvanassche=40acm.org>; Adrian Hunter <adrian.hunter=40intel.com>; Christo=
ph
>Hellwig <hch=40infradead.org>; Can Guo <cang=40codeaurora.org>; Jaegeuk Ki=
m
><jaegeuk=40kernel.org>; Gyunghoon Kwon <goodjob.kwon=40samsung.com>;
>linux-samsung-soc=40vger.kernel.org; linux-scsi=40vger.kernel.org; jongmin=
 jeong
><jjmin.jeong=40samsung.com>; Chanho Park <chanho61.park=40samsung.com>
>Subject: =5BPATCH v3 02/17=5D scsi: ufs: add quirk to enable host controll=
er without ph
>configuration
>
>From: jongmin jeong <jjmin.jeong=40samsung.com>
>
>samsung ExynosAuto SoC has two types of host controller interface to suppo=
rt
>the virtualization of UFS Device.
>One is the physical host(PH) that the same as conventaional UFSHCI, and th=
e
>other is the virtual host(VH) that support data transfer function only.
>
>In this structure, the virtual host does not support like device managemen=
t.
>This patch skips the physical host interface configuration part that canno=
t be
>performed in the virtual host.
>
>Suggested-by: Alim Akhtar <alim.akhtar=40samsung.com>
>Cc: James E.J. Bottomley <jejb=40linux.ibm.com>
>Cc: Martin K. Petersen <martin.petersen=40oracle.com>
>Cc: Bart Van Assche <bvanassche=40acm.org>
>Signed-off-by: jongmin jeong <jjmin.jeong=40samsung.com>
>Signed-off-by: Chanho Park <chanho61.park=40samsung.com>
>---

Reviewed-by: Alim Akhtar <alim.akhtar=40samsung.com>

> drivers/scsi/ufs/ufshcd.c =7C 3 +++
> drivers/scsi/ufs/ufshcd.h =7C 6 ++++++
> 2 files changed, 9 insertions(+)
>
>diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
>8a45e8c05965..628ef8e17531 100644
>--- a/drivers/scsi/ufs/ufshcd.c
>+++ b/drivers/scsi/ufs/ufshcd.c
>=40=40 -8066,6 +8066,9 =40=40 static int ufshcd_probe_hba(struct ufs_hba *=
hba, bool
>init_dev_params)
> 	if (ret)
> 		goto out;
>
>+	if (hba->quirks & UFSHCD_QUIRK_SKIP_PH_CONFIGURATION)
>+		goto out;
>+
> 	/* Debug counters initialization */
> 	ufshcd_clear_dbg_ufs_stats(hba);
>
>diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
>e1d8fd432614..e547fbd19d49 100644
>--- a/drivers/scsi/ufs/ufshcd.h
>+++ b/drivers/scsi/ufs/ufshcd.h
>=40=40 -594,6 +594,12 =40=40 enum ufshcd_quirks =7B
> 	 * support UIC command
> 	 */
> 	UFSHCD_QUIRK_BROKEN_UIC_CMD			=3D 1 << 15,
>+
>+	/*
>+	 * This quirk needs to be enabled if the host controller cannot
>+	 * support physical host configuration.
>+	 */
>+	UFSHCD_QUIRK_SKIP_PH_CONFIGURATION		=3D 1 << 16,
> =7D;
>
> enum ufshcd_caps =7B
>--
>2.33.0


