Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F07BC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 03:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06D8220674
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 03:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LEuK/Z6w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgF0DJj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 23:09:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46206 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgF0DJj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 23:09:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R39KuR181061;
        Sat, 27 Jun 2020 03:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=+BZ3yLcmmwAWjP9rHtuiGmew7pt3F8gDT9e4Bie8AmE=;
 b=LEuK/Z6wuUmkd7IjfhFfVSnfhJhE/aylK1fit6bn0Lcbc9jROOS2oFI1zzuTGg5px88M
 Ybvl6gpu2a64dY+9/0NhhemxkTiCXSqHUIF1cj/LpRfPr6MfIec2l2ojIYp6TRl8xqws
 F2G2nwAuGTjYP52ZH5btrs0NzE8t/gOwVK4Pv+c+FOqvKHEDKIJbfRxN3ICcSnkFbKjD
 B2RGyxhovYAGzqvPMhuwHZ9jlegljTnuTiyrItPu7drJKdagbqpKCwidvv4bbRT4hyn1
 Rf4/ImUA5ScSNFeiwBZ9jMgmrs/y+bjfgzvJj+SZcVhhcbHQIej5lX5tGVuRHPEWb60q dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31wwhr810r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 03:09:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R38AmR099349;
        Sat, 27 Jun 2020 03:09:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31wv58tekh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 03:09:19 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05R39D5H010795;
        Sat, 27 Jun 2020 03:09:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 03:09:13 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH, 5.8 regression] mptfusion: don't use GFP_ATOMIC for larger DMA allocations
Date:   Fri, 26 Jun 2020 23:09:10 -0400
Message-Id: <159322725421.11274.11382883750179863624.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624165724.1818496-1-hch@lst.de>
References: <20200624165724.1818496-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1011 cotscore=-2147483648
 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 24 Jun 2020 18:57:24 +0200, Christoph Hellwig wrote:

> The mpt fusion driver still uses the legacy PCI DMA API, which hardcodes
> atomic allocations.  This caused the driver to fail to load on some
> powerpc VMs with incoherent DMA and small memory sizes.  Switch to use
> the modern DMA API and sleeping allocations for large allocations
> instead.  This is not a full cleanup of the PCI DMA API usage yet, but
> just enough to fix the regression caused by reducing the default atomic
> pool size.

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: mptfusion: Don't use GFP_ATOMIC for larger DMA allocations
      https://git.kernel.org/mkp/scsi/c/311950f8b8d8

-- 
Martin K. Petersen	Oracle Linux Engineering
