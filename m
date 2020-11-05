Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142D6C4741F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 04:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD00820936
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 04:24:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uNhv1C+a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbgKEEYE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 23:24:04 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48470 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgKEEYE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 23:24:04 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A54NsDq137512;
        Thu, 5 Nov 2020 04:23:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cLU+aPQrXxMBN/Q0Z/TiVWZEFD/5yd4UUpsD/rKMLGc=;
 b=uNhv1C+a57AlUoSfv9FcyS76/YEqaXDFSCWN6KY1OAC9HgcJxEcBTIREB4DUaGaT1d2m
 iKG9MMpBnyHPJL8VLWq3mcQoghICIs6Vroh3xkgTRSTnQIWlsWzHMHDp+IrVLAtA6tYd
 3oF89QUUm9UqAuevtFRvEChkYnDwVBRlwKyEsu264PiNiniEraqccLr6yAtg5DeGCER1
 Cy2kP/LFr4VlA+kp64BHrMK1/DH+bt4nzoGGBUpFwrinJLYvCS23CSkyJdVkHLyaUkBz
 aRqG1OS5yNni8oFJWC3ViX32059LY0WUd9skCsPhgiYX2X2R/+Fab7Ozo4AcpXW36Y/S Bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34hhb29xxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 05 Nov 2020 04:23:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A54L8c3141005;
        Thu, 5 Nov 2020 04:21:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34jf4bfh8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Nov 2020 04:21:54 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A54Lm3t005041;
        Thu, 5 Nov 2020 04:21:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 20:21:47 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        target-devel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Javed Hasan <jhasan@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>
Subject: Re: [PATCH 1/2] libfc: move scsi/fc_encode.h to libfc
Date:   Wed,  4 Nov 2020 23:21:43 -0500
Message-Id: <160455005255.26277.5936613179662668851.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026160705.3706396-1-arnd@kernel.org>
References: <20201026160705.3706396-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050031
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 26 Oct 2020 17:06:12 +0100, Arnd Bergmann wrote:

> Most of this file is only used inside of libfc, so move
> it to where it is actually used, with only fc_fill_fc_hdr()
> left inside of the header.

Applied to 5.11/scsi-queue, thanks!

[1/2] scsi: libfc: Move scsi/fc_encode.h to libfc
      https://git.kernel.org/mkp/scsi/c/e31ac898ac29
[2/2] scsi: libfc: Work around -Warray-bounds warning
      https://git.kernel.org/mkp/scsi/c/8fd9efca86d0

-- 
Martin K. Petersen	Oracle Linux Engineering
