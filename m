Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E45C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7658C2075D
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:17:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aRFG6T85"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgHEBRu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:17:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51838 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbgHEBRt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 21:17:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0751C2C0003681;
        Wed, 5 Aug 2020 01:17:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=BzfVaJvERmWwSeTX5iMr/YN/eA2gfUfBGx5ggQoeP9w=;
 b=aRFG6T85HDSpkvvwmq4iSTnkKUYJHhaFTeh39sAoawNlUs+zi4/mFCfKS0E078sRarI0
 ARNTSzFFYm7t81UcIrfXc4ydeUr1gdAZCs4w4MLPImmjQI9CJuOwoRMlDYYcqmHZ3zSe
 YEYWk/KhlKr0i652CW5DsvkfuPsSbiBJSUtOdjcfjlBXCckYjYW0FjgR3Jx2fsk0LzOf
 5tUJAmP06AeMnkQGMiwcPKdbBiAl4iL+wAR6AHCx9WK2WzjQcbr6W+/oqKCdQ4XYYZUv
 4xIN8oJrsdSuiBgfUAxN2xVYBEJ+4ShGuFxPiKDggB/vOx2tmgLuQ/QzASB0Rm2+1V5a AA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32nc9ynynu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 05 Aug 2020 01:17:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0751Hjvu175974;
        Wed, 5 Aug 2020 01:17:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32njaxnb36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Aug 2020 01:17:45 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0751Habo002207;
        Wed, 5 Aug 2020 01:17:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Aug 2020 18:17:35 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        james.smart@broadcom.com
Subject: Re: [PATCH] scsi: lpfc: nvmet: avoid hang / use-after-free again when destroying targetport
Date:   Tue,  4 Aug 2020 21:17:29 -0400
Message-Id: <159659019688.15726.9464654289442257315.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200729231011.13240-1-emilne@redhat.com>
References: <20200729231011.13240-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008050009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 adultscore=0 clxscore=1011 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Jul 2020 19:10:11 -0400, Ewan D. Milne wrote:

> We cannot wait on a completion object in the lpfc_nvme_targetport structure
> in the _destroy_targetport() code path because the NVMe/fc transport will
> free that structure immediately after the .targetport_delete() callback.
> This results in a use-after-free, and a crash if slub_debug=FZPU is enabled.
> 
> An earlier fix put put the completion on the stack, but commit 2a0fb340fcc8
> ("scsi: lpfc: Correct localport timeout duration error") subsequently changed
> the code to reference the completion through a pointer in the object rather
> than the local stack variable.  Fix this by using the stack variable directly.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: lpfc: nvmet: Avoid hang / use-after-free again when destroying targetport
      https://git.kernel.org/mkp/scsi/c/af6de8c60fe9

-- 
Martin K. Petersen	Oracle Linux Engineering
