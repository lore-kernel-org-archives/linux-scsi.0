Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 715FDC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B4422073A
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:53:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fIQAccwU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgGUDxm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 23:53:42 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60536 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgGUDxl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 23:53:41 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L3qA24112249;
        Tue, 21 Jul 2020 03:53:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Hae8qZiU6oxGkWbIdmeIVzwih5cB0PyxfAehCZi0GKk=;
 b=fIQAccwUl2oSiF+OzhKCU8k129xAJ4VBoqwDhelw0R4nWaOr1bSJxtLuhp37rdCPG1+s
 Gs4JQHp2QiUufWDvYicmRMKoFxBHFAGGthbIvHMKYUZITIiMAmnPkHDrAHPPA87O5WT3
 TEjuRwxhjsC0JY8vvyEcFzpAEsC+0G/3tW7CiRBvkdziXbcR812gAxmX8s9abpFpWhXc
 aeBZT6ovQF1/9sTTU4/sKrlrv6KfRFuP5okn9Avg5Y56L/iUBzK8Xd84rF8+j2yRVGwH
 cvzElihnbxL5v+DDADsdvzwHdDJo/GDzxE/aU9ogCXbTxfQ3UXdq6F6PCeBLekg1VqJd qA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 32bpkb2p91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Jul 2020 03:53:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L3gxYE027396;
        Tue, 21 Jul 2020 03:51:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32dnmqfhyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 03:51:18 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06L3pFpg029749;
        Tue, 21 Jul 2020 03:51:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 20:51:15 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     scott.teel@microchip.com, gerry.morong@microchip.com,
        POSWALD@suse.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, bader.alisaleh@microchip.com,
        Kevin.Barnett@microchip.com, jejb@linux.vnet.ibm.com,
        joseph.szczypek@hpe.com, Don Brace <don.brace@microsemi.com>,
        hch@infradead.org, mahesh.rajashekhara@microchip.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/4] hpsa updates
Date:   Mon, 20 Jul 2020 23:51:14 -0400
Message-Id: <159530346022.8195.14374929657475608298.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <159528193513.24772.2142294136346611232.stgit@brunhilda>
References: <159528193513.24772.2142294136346611232.stgit@brunhilda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 20 Jul 2020 16:52:46 -0500, Don Brace wrote:

> These patches are based on Linus's tree
> 
> The changes are:
> hpsa-correct-rare-oob-condition
>  - Rare condition where a spare is first in
>    PHYS LUN list.
> hpsa-increase-qd-for-external-luns
>  - Improve performance for PTRAID devices
>    - Such as MSA devices.
> hpsa-increase-ctlr-eh-timeout
>  - Increase timeout for commands issued to
>    controller device.
>  - Improve multipath failover handling.
> hpsa-bump-version

Applied to 5.9/scsi-queue, thanks!

[1/4] scsi: hpsa: Correct rare oob condition
      https://git.kernel.org/mkp/scsi/c/a1cc279c246a
[2/4] scsi: hpsa: Increase queue depth for external LUNs
      https://git.kernel.org/mkp/scsi/c/3fcb972bc1d7
[3/4] scsi: hpsa: Increase controller error handling timeout
      https://git.kernel.org/mkp/scsi/c/c73deaf3b001
[4/4] scsi: hpsa: Bump version
      https://git.kernel.org/mkp/scsi/c/afea24189508

-- 
Martin K. Petersen	Oracle Linux Engineering
