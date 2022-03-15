Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541F8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 05:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbiCOFTE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 01:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbiCOFTE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 01:19:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A4263E5
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 22:17:51 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F3O8im008016;
        Tue, 15 Mar 2022 05:02:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=F+cbAGYnny0iSeDsc7twzJUA2Syx+pyIyz+9xYL+xBE=;
 b=nLE45LPef2Fzx4rwPHxO9zpKsqEtIiWTbgmRqQ1qVHlzXCQZCeRMa1v2iwMrs8kePxKm
 gVUKGAdAHvtD1zOTRy9LY1+u2pU8VgIF4l+P0YzhfQ3uL6rG6TExROKOc81sBEhsDd2B
 VJu1GUeogkty7qGjOl/d9vIciwL2kcr0/hsDhAtv4D5XCBy+dskdbsnEC/W63oGf/CHN
 99/QtLKCJ8vc2ShmZ+w8yH1KgM8Bx5WiYr6uNk22GOJe15nP8yE9COJqZgvSeoS+qTE5
 ZVdj04WClTGuNTQbJ/WidmWT/7WC93vboeKNQDgum6VlXcH1GEUVofmnXUd8TclPk03i bQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5s6j20g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 05:02:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22F51JJk004866;
        Tue, 15 Mar 2022 05:02:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3erhy25wv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 05:02:42 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22F52cq7007094;
        Tue, 15 Mar 2022 05:02:41 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3erhy25wts-3;
        Tue, 15 Mar 2022 05:02:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        peter.wang@mediatek.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, stanley.chu@mediatek.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-mediatek@lists.infradead.org, chun-hung.wu@mediatek.com,
        chaotian.jing@mediatek.com, beanhuo@micron.com,
        wsd_upstream@mediatek.com, alice.chao@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        cc.chou@mediatek.com, mikebi@micron.com, qilin.tan@mediatek.com,
        lin.gui@mediatek.com
Subject: Re: [PATCH v1] scsi: ufs: scsi_get_lba error fix by check cmd opcode
Date:   Tue, 15 Mar 2022 01:02:33 -0400
Message-Id: <164732052814.23186.8418060830463850785.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220307111752.10465-1-peter.wang@mediatek.com>
References: <20220307111752.10465-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: CGHBTJI2hPrbY2UpGNc2X2W0cgtXK5GY
X-Proofpoint-ORIG-GUID: CGHBTJI2hPrbY2UpGNc2X2W0cgtXK5GY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 7 Mar 2022 19:17:52 +0800, peter.wang@mediatek.com wrote:

> From: Peter Wang <peter.wang@mediatek.com>
> 
> When ufs init without scmd->device->sector_size set,
> scsi_get_lba will get a wrong shift number and ubsan error.
> shift exponent 4294967286 is too large for 64-bit type
> 'sector_t' (aka 'unsigned long long')
> Call scsi_get_lba only when opcode is READ_10/WRITE_10/UNMAP.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/1] scsi: ufs: scsi_get_lba error fix by check cmd opcode
      https://git.kernel.org/mkp/scsi/c/2bd3b6b75946

-- 
Martin K. Petersen	Oracle Linux Engineering
