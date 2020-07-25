Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9068C433F8
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A673B2070E
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NJnvo8J/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgGYCvg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:51:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40222 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgGYCvg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 22:51:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2lIV0077092;
        Sat, 25 Jul 2020 02:51:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=R8J1xbbr46OaTOQv6KgDIgvNvYTBQJQal3iKCZsoVfo=;
 b=NJnvo8J/a2ANzdY6y+lYkdFAulxCs/Tje3tGYfOvXpP1WMO6OPIgpxZvTP9CKj+7xuql
 yiOOjRZqAy0yT36QIet4J/qhrOu6NrEhhMfcFRT0PvL5l9uzJTuimkyE7rs7tFupml67
 mXFuYBZXbzjxxVtOTkQJI1xSfxZSoHCmT4OCLnucBPQN3AiFwY9dvRot8Mpd1fARXMnm
 5aREHCsVZWof622Cof0VcDbjjoiVu8CowaI9YkZ2a0EkYmLq57CzYew9uY5MBg2hLcB8
 BDgFZkEIEsbt6MfEAd2oTu3Dhd/ViWdTfEVEg35fGXDz1aFzwXr3JaDbaoxGhcTaA6Ar Wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32gc5qr0ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:51:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2pKfU126288;
        Sat, 25 Jul 2020 02:51:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32gc2h0k37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:51:24 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06P2ouvJ010152;
        Sat, 25 Jul 2020 02:50:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 19:50:55 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linmiaohe <linmiaohe@huawei.com>, kartilak@cisco.com,
        satishkh@cisco.com, sebaddel@cisco.com, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: use eth_broadcast_addr() to assign broadcast address
Date:   Fri, 24 Jul 2020 22:50:38 -0400
Message-Id: <159564519423.31464.8869830384041983017.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1595233498-13628-1-git-send-email-linmiaohe@huawei.com>
References: <1595233498-13628-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=942
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1011 impostorscore=0 suspectscore=0
 phishscore=0 mlxlogscore=966 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 20 Jul 2020 16:24:58 +0800, linmiaohe wrote:

> Use eth_broadcast_addr() to assign broadcast address insetad of memset().

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: fnic: Use eth_broadcast_addr() to assign broadcast address
      https://git.kernel.org/mkp/scsi/c/51d263cbdd76

-- 
Martin K. Petersen	Oracle Linux Engineering
