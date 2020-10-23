Return-Path: <SRS0=1+Eg=D6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FADC388F9
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 06:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 295282192A
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 06:40:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DWzNA3Rn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375352AbgJWGkG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Oct 2020 02:40:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42672 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S375349AbgJWGkG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2020 02:40:06 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201023064002epoutp049f9dea0282df9271d3fb1d4a253c5432~Ai9JJ3U4o1815418154epoutp04c
        for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2020 06:40:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201023064002epoutp049f9dea0282df9271d3fb1d4a253c5432~Ai9JJ3U4o1815418154epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603435202;
        bh=Oy9omAIecAKdgFVEVvzDVyMqznHnVZS3dnaOuPZUWXw=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=DWzNA3RnCdc4OkSHSqycpmvpt1GJeM4oMs79PYFU6WlJfWZD2ag+7bhI6qnLGzNYJ
         GuPtIz2sU/dpV2JhaHHZKpwSTZtMczxiFwkI/KfDxmyFk++6r9mywUVg/YnmR4h8AS
         jJHvUMOYi3xLoHMx1ML5DLaVKoTi2217xjAPgXjw=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p2.samsung.com
        (KnoxPortal) with ESMTP id
        20201023064002epcas1p29c622cb5a9788ea3e361bcc39950c083~Ai9IwWNI52161321613epcas1p2T;
        Fri, 23 Oct 2020 06:40:02 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v2 1/1] scsi: ufs: Fix unexpected values get from
 ufshcd_read_desc_param()
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "cang@codeaurora.org" <cang@codeaurora.org>
CC:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "salyzyn@google.com" <salyzyn@google.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <963815509.21603435202191.JavaMail.epsvc@epcpadp1>
Date:   Fri, 23 Oct 2020 15:35:28 +0900
X-CMS-MailID: 20201023063528epcms2p11b57d929a926d582539ce4e1a57caf80
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20201023063528epcms2p11b57d929a926d582539ce4e1a57caf80
References: <CGME20201023063528epcms2p11b57d929a926d582539ce4e1a57caf80@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Can Guo

>Since WB feature has been added, WB related sysfs entries can be accessed
>even when an UFS device does not support WB feature. In that case, the
>descriptors which are not supported by the UFS device may be wrongly
>reported when they are accessed from their corrsponding sysfs entries.
>Fix it by adding a sanity check of parameter offset against the actual
>decriptor length.
>
>Signed-off-by: Can Guo <cang@codeaurora.org>
>---
> drivers/scsi/ufs/ufshcd.c | 24 +++++++++++++++---------
> 1 file changed, 15 insertions(+), 9 deletions(-)
>
>diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>index a2ebcc8..aeec10d 100644
>--- a/drivers/scsi/ufs/ufshcd.c
>+++ b/drivers/scsi/ufs/ufshcd.c
>@@ -3184,13 +3184,19 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
> 	/* Get the length of descriptor */
> 	ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
> 	if (!buff_len) {
>-		dev_err(hba->dev, "%s: Failed to get desc length", __func__);
>+		dev_err(hba->dev, "%s: Failed to get desc length\n", __func__);
>+		return -EINVAL;
>+	}
>+
>+	if (param_offset >= buff_len) {
>+		dev_err(hba->dev, "%s: Invalid offset 0x%x in descriptor IDN 0x%x, length 0x%x\n",
>+			__func__, param_offset, desc_id, buff_len);

In my understanding, this code seems to check incorrect access to not
supportted features (e.g. WB) via buff_len value from
ufshcd_map_desc_id_to_length().
However, since buff_len is initialized as QUERY_DESC_MAX_SIZE and is
updated later by ufshcd_update_desc_length(), So it is impossible to find
incorrect access by checking buff_len at first time.

Thanks,
Daejun
