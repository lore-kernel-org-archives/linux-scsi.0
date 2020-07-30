Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6303C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 02:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 864FC20FC3
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 02:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hK3v0Z+O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgG3CY2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 22:24:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35238 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgG3CY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 22:24:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06U2Mwfl076425;
        Thu, 30 Jul 2020 02:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=5nt+OQOgz9c1Jq5csx1e1cWddsT+55Nv1ODVtbhfM0g=;
 b=hK3v0Z+OKX9UG3MsvIeECKyoATY6qUZIPJCZQIdHmtHsAdUJw5T0WRa4T8rK2PX/XptV
 E1RbQRF4FK/leboMwWJjXU/PLexsnFqPwpCdUjVOHbjd171dB6WhAL6n0GPWbu6wWLRl
 lYkl8Idj9dAu8p13xHFVOMEnBXFcUwzfyNu1Av68aWYnZpfMzKQJch75Jta8HDn4oZ13
 CdSSfIkiKohS9i+QZZxG7uT26zEPcIi+7/HPMRIscX4Gb1B8dLECV9DJJ3VHLxd570HO
 5+TVAskoL/YLC1ujbvyEX5ilrHdUiVcmIB1nH4UmReE4+nLvACFN7nk7zTpWg7I+wsdO mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32hu1jh3hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Jul 2020 02:24:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06U2NPif162325;
        Thu, 30 Jul 2020 02:24:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32hu5vvh46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jul 2020 02:24:09 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06U2O4Tk018408;
        Thu, 30 Jul 2020 02:24:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Jul 2020 19:24:04 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, beanhuo@micron.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, avri.altman@wdc.com,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        matthias.bgg@gmail.com, cang@codeaurora.org, bvanassche@acm.org,
        asutoshd@codeaurora.org, cc.chou@mediatek.com,
        chaotian.jing@mediatek.com, peter.wang@mediatek.com,
        linux-kernel@vger.kernel.org, kuohong.wang@mediatek.com,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, andy.teng@mediatek.com,
        chun-hung.wu@mediatek.com
Subject: Re: [PATCH v1 0/2] scsi: ufs: Introduce and apply DELAY_AFTER_LPM device quirk
Date:   Wed, 29 Jul 2020 22:24:02 -0400
Message-Id: <159607582923.27464.16053842449051029984.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729051840.31318-1-stanley.chu@mediatek.com>
References: <20200729051840.31318-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9697 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=853 mlxscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9697 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=864 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300015
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Jul 2020 13:18:38 +0800, Stanley Chu wrote:

> This patchset introduces and applies DELAY_AFTER_LPM device quirk in MediaTek platforms.
> 
> Stanley Chu (2):
>   scsi: ufs: Introduce device quirk "DELAY_AFTER_LPM"
>   scsi: ufs-mediatek: Apply DELAY_AFTER_LPM quirk to Micron devices
> 
>  drivers/scsi/ufs/ufs-mediatek.c |  2 ++
>  drivers/scsi/ufs/ufs_quirks.h   |  7 +++++++
>  drivers/scsi/ufs/ufshcd.c       | 11 +++++++++++
>  3 files changed, 20 insertions(+)

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: ufs: Introduce device quirk "DELAY_AFTER_LPM"
      https://git.kernel.org/mkp/scsi/c/33166bebcd6d
[2/2] scsi: ufs-mediatek: Apply DELAY_AFTER_LPM quirk to Micron devices
      https://git.kernel.org/mkp/scsi/c/4d4673745fe2

-- 
Martin K. Petersen	Oracle Linux Engineering
