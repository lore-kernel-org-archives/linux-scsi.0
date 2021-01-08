Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F15BC43333
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21EA72075A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbhAHEUy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:20:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49392 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbhAHEUw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:20:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10849fcd106185;
        Fri, 8 Jan 2021 04:19:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yZzYiFILMo+MCkdifb5EGY33AydWCm2X4YPlhcEGEgM=;
 b=EO0fpG0qFkDLFfRKU8FoaKNDAIjDTAAtwinun2P2mXnP3aIGvgPQ8eDxJ7BRU/sRRqrX
 vFvcXeofnBruXz1RMkZcwmJ6jHeOTD/jHWKQ7xNE3107tbE6k+vTIV9jfTa3ZlAt5Wyk
 HixsnR+Aav01bjW+uaElW77Ceu4XhWbqSIE2PHqX039sm3IjKDoDIbbNWzK1f7BkXvjD
 Rndw6wuzsHGOkJVdeb/BGKiRAHfLVGtTlrxJPVK/wiFqGuFzwqlNQpUSOFv09PAFQG5n
 IzWazj7tF1Phi8iZyqD5BWD1ecYJRQYnr71F/iC8Y2jpZQ+ZTbhgjrn4tXOymhXFjc4K 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35wftxeyt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 04:19:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1084ATkY040361;
        Fri, 8 Jan 2021 04:19:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35w3qut0gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 04:19:57 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1084JuOi012527;
        Fri, 8 Jan 2021 04:19:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 04:19:55 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        jejb@linux.ibm.com, avri.altman@wdc.com, alim.akhtar@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, bvanassche@acm.org,
        chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
        peter.wang@mediatek.com, matthias.bgg@gmail.com,
        andy.teng@mediatek.com, cang@codeaurora.org,
        chun-hung.wu@mediatek.com, cc.chou@mediatek.com,
        linux-arm-kernel@lists.infradead.org, beanhuo@micron.com,
        asutoshd@codeaurora.org, alice.chao@mediatek.com
Subject: Re: [PATCH v2 0/2] scsi: ufs: Fix power drain and hci quirk for WriteBooster
Date:   Thu,  7 Jan 2021 23:19:40 -0500
Message-Id: <161007949337.9892.11394622290093764791.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201222072905.32221-1-stanley.chu@mediatek.com>
References: <20201222072905.32221-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=944 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=960 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Dec 2020 15:29:03 +0800, Stanley Chu wrote:

> This series fixes two WriteBooster issues,
> 1. Fix a corner case that device flush capability is not disabled during system suspend
> 2. Fix the checking of UFSHCI quirk UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
> 
> Stanley Chu (2):
>   scsi: ufs: Fix possible power drain during system suspend
>   scsi: ufs: Relax the condition of
>     UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
> 
> [...]

Applied to 5.11/scsi-fixes, thanks!

[1/2] scsi: ufs: Fix possible power drain during system suspend
      https://git.kernel.org/mkp/scsi/c/1d53864c3617
[2/2] scsi: ufs: Relax the condition of UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
      https://git.kernel.org/mkp/scsi/c/21acf4601cc6

-- 
Martin K. Petersen	Oracle Linux Engineering
