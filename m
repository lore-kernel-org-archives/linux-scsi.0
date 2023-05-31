Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEFD8C77B7C
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 08:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbjEaIBK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 04:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235427AbjEaIAm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 04:00:42 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BE6E4A
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 01:00:03 -0700 (PDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230531080001epoutp02a468037956b5738b92bcef2b7523037b~kK4LBI8uf0821208212epoutp02p
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 08:00:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230531080001epoutp02a468037956b5738b92bcef2b7523037b~kK4LBI8uf0821208212epoutp02p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1685520001;
        bh=amUekb6xw6hkQeHH7+yorCO3d376hzzOFz64LI8keZA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Vy9FTU7nCcZg8FBc+5GPSqFiO4pY/Gb8pTJIx+lXW4B8tCYvr49Zxlf6CQSxm6XvD
         iV8zi295xEeRWQgCGJ7BP4YiKD4vq3DBKtf+HnmM73smm0z59pQHNm+A3ivWEC5GwD
         Z9kw3Z2vjIakt8R9wzQJQzq295Zs+dizs9wYX/f8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20230531080000epcas2p363c36835d9f17e1fa3c6e1955fe0d4d0~kK4KXLnw10433704337epcas2p3l;
        Wed, 31 May 2023 08:00:00 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.89]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4QWMB74VvGz4x9QC; Wed, 31 May
        2023 07:59:59 +0000 (GMT)
X-AuditID: b6c32a46-b23fd7000001438d-29-6476fe7f0d4b
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        87.D3.17293.F7EF6746; Wed, 31 May 2023 16:59:59 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH v4 4/5] scsi: ufs: Declare ufshcd_{hold,release}() once
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Avri Altman <avri.altman@wdc.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20230529202640.11883-5-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20230531075959epcms2p7500a96da07c41914d11f18564ac1109e@epcms2p7>
Date:   Wed, 31 May 2023 16:59:59 +0900
X-CMS-MailID: 20230531075959epcms2p7500a96da07c41914d11f18564ac1109e
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJsWRmVeSWpSXmKPExsWy7bCmuW79v7IUg//LlS1OPlnDZtE5cRmr
        xcufV9ksDj7sZLGY9uEns8XLQ5oWj24/Y7To7d/KZvFk/Sxmi0U3tjFZ7H29ld2i+/oONosD
        H1YxWiw//o/JYmHHXBaLSdc2sDkIeFy+4u2xeM9LJo9NqzrZPO5c28PmMWHRAUaP7+s72Dw+
        Pr3F4jFxT51H35ZVjB6fN8l5tB/oZgrgjsq2yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDU
        NbS0MFdSyEvMTbVVcvEJ0HXLzAF6R0mhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJT
        YF6gV5yYW1yal66Xl1piZWhgYGQKVJiQnXHjTxdTwWWOihOXr7M0MO5k72Lk5JAQMJE4s/0R
        UxcjF4eQwA5Gie4NC4ESHBy8AoISf3cIg9QIC3hLfF2xkwnEFhJQkuhauJUZIm4gsW76HjCb
        TUBPYsrvO4wgtohAnETrrFeMIDOZBZpZJLb9PMgCsYxXYkb7UyhbWmL78q2MILs4BSwknp52
        gAhrSPxY1ssMYYtK3Fz9lh3Gfn9sPiOELSLReu8sVI2gxIOfu6HikhKtZ7ayQdj1Eq3vT7GD
        3CAhMIFRovHYH6hB+hLXOjaC3cAr4CvR8/oW2GMsAqoSR048hapxkWhr2g4WZxaQl9j+dg4z
        yJ3MApoS63fpg5gSAsoSR26xQFTwSXQc/ssO82HDxt9Y2TvmPWGCsNUkHi3YwjqBUXkWIqBn
        Idk1C2HXAkbmVYxiqQXFuempxUYFRvC4Tc7P3cQITthabjsYp7z9oHeIkYmD8RCjBAezkgiv
        bWJxihBvSmJlVWpRfnxRaU5q8SFGU6AvJzJLiSbnA3NGXkm8oYmlgYmZmaG5kamBuZI4r7Tt
        yWQhgfTEktTs1NSC1CKYPiYOTqkGphVZl/0nftJrMJZ9G1lx16huwbr/Wx3MXZp7uFaZiOU1
        bZ+znSu5a6Mvo/zKw9lbdkQYbukSKZQTtGHJij/G8rjkS2zj08AHaxZKbRBemva25H5kQM4F
        WVmuaGmvNN9zJXZRafylVp7MhQcmnVlwON1mx/+Twiz7H+U0VzYJVnfO02JNlnu0c0rmEXch
        q5PF4tVH5FayHt6ua3L2tO3MnhvyIQoKi7aurhXNPiRow/XxkN/LFy57i0rmXWE6fngf28kr
        ibW/ZnntDZ3Ssm5pSNrGf0sdJB8dMZsfG/z53ZWEM1EN6VIXqtx6FFaoyi99tdpw6f/ZVUml
        smdPWvmV509KvMrN9drjv6SMnlKvEktxRqKhFnNRcSIALRrYG2EEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230529202702epcas2p2ab96250338c67cef61f4bbd479c2c73b
References: <20230529202640.11883-5-bvanassche@acm.org>
        <20230529202640.11883-1-bvanassche@acm.org>
        <CGME20230529202702epcas2p2ab96250338c67cef61f4bbd479c2c73b@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>ufshcd_hold() and ufshcd_release are declared twice: once in
>drivers/ufs/core/ufshcd-priv.h and a second time in include/ufs/ufshcd.h.
>Remove the declarations from ufshcd-priv.h.
>
>Fixes: dd11376b9f1b ("scsi: ufs: Split the drivers/scsi/ufs directory")
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Keoseong Park <keosung.park@samsung.com>

Best Regards,
Keoseong

>---
> drivers/ufs/core/ufshcd-priv.h | 3 ---
> 1 file changed, 3 deletions(-)
>
>diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
>index d53b93c21a0c..8f58c2169398 100644
>--- a/drivers/ufs/core/ufshcd-priv.h
>+++ b/drivers/ufs/core/ufshcd-priv.h
>@@ -84,9 +84,6 @@ unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
> int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
> 			    u8 **buf, bool ascii);
> 
>-int ufshcd_hold(struct ufs_hba *hba, bool async);
>-void ufshcd_release(struct ufs_hba *hba);
>-
> int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
> 
> int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
