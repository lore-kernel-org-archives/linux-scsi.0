Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B50C54E4B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C11E22071A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:31:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G4jxhVjR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgELDbU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 23:31:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35386 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgELDbU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 23:31:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3N2vI072886;
        Tue, 12 May 2020 03:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=MUBSiWVQtghSeYGKdUfODIsM/8mICmZoZz5eTdHLjdY=;
 b=G4jxhVjRE8F3SYvnsq5Z66JVXSD2YZ80qMzCvufL/wZ/IrGa06NcMCZ4RIRh0WBJGF/F
 ihPe3rHKgljBGso8c1SHumqPoQ+glcm9vjUh608fisY7FK5+dHq+XSMuNjfa4XnEYFoN
 pYvFzuJAQbavg/xPCqqAg6S/miQfiWGwGZQaPXJdjSdsFys5hEkxHB/uyT/bB9+xTqvV
 tM6kAXQ1MyZGDYjvNT1Krp9rrvaK5HkEhDJZ+LScv16Xs4+wG0zYZbvHCdrk26JMjQcf
 6gMXL0LBq9dX4317rUhkZKdblbGGDylQVy6Br6J6G21//4mBMVGfCKZXLq2zHh6cFN1w Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30x3mbrgj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 03:30:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3MU8Q016039;
        Tue, 12 May 2020 03:28:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30xbggtm6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 03:28:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04C3Skk4004003;
        Tue, 12 May 2020 03:28:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 20:28:46 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        jejb@linux.ibm.com, alim.akhtar@samsung.com,
        asutoshd@codeaurora.org, avri.altman@wdc.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        andy.teng@mediatek.com, linux-mediatek@lists.infradead.org,
        bvanassche@acm.org, linux-arm-kernel@lists.infradead.org,
        chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com,
        cang@codeaurora.org, linux-kernel@vger.kernel.org,
        matthias.bgg@gmail.com, beanhuo@micron.com, peter.wang@mediatek.com
Subject: Re: [PATCH v8 0/8] scsi: ufs: support LU Dedicated buffer mode for WriteBooster
Date:   Mon, 11 May 2020 23:28:32 -0400
Message-Id: <158925392374.17325.4875533206353375605.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508080115.24233-1-stanley.chu@mediatek.com>
References: <20200508080115.24233-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=889
 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 mlxlogscore=918 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120029
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 8 May 2020 16:01:07 +0800, Stanley Chu wrote:

> This patchset adds LU dedicated buffer mode support for WriteBooster.
> In the meanwhile, enable WriteBooster capability on MediaTek UFS platforms.
> 
> v7 -> v8:
>   - In exported funtion ufshcd_fixup_dev_quirks(), add null checking for parameter "fixups" (Avri Altman)
> 
> v6 -> v7:
>   - Add device descriptor length check in ufshcd_wb_probe() back to prevent out-of-boundary access in ufshcd_wb_probe()
>   - Fix the check of device descriptor length (Avri Altman)
>   - Provide a new ufs_fixup_device_setup() function to pack both device fixup methods by general quirk table and vendor-specific way (Avri Altman)
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/8] scsi: ufs: Enable WriteBooster on some pre-3.1 UFS devices
      https://git.kernel.org/mkp/scsi/c/817d7e140283
[2/8] scsi: ufs: Introduce fixup_dev_quirks vops
      https://git.kernel.org/mkp/scsi/c/c28c00ba4f06
[3/8] scsi: ufs: Export ufs_fixup_device_setup() function
      https://git.kernel.org/mkp/scsi/c/8db269a5102e
[4/8] scsi: ufs-mediatek: Add fixup_dev_quirks vops
      https://git.kernel.org/mkp/scsi/c/62c2f503b54c
[5/8] scsi: ufs: Add "index" in parameter list of ufshcd_query_flag()
      https://git.kernel.org/mkp/scsi/c/1f34eedf9bc1
[6/8] scsi: ufs: Add LU Dedicated buffer mode support for WriteBooster
      https://git.kernel.org/mkp/scsi/c/6f8d5a6a78cf
[7/8] scsi: ufs-mediatek: Enable WriteBooster capability
      https://git.kernel.org/mkp/scsi/c/29060a629135
[8/8] scsi: ufs: Cleanup WriteBooster feature
      https://git.kernel.org/mkp/scsi/c/79e3520f82cb

-- 
Martin K. Petersen	Oracle Linux Engineering
