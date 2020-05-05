Return-Path: <SRS0=dRcH=6T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453D6C47256
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 04:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2279E20658
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 04:43:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YyP116E5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgEEEnk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 May 2020 00:43:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37356 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgEEEnk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2020 00:43:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0454hcCE072119;
        Tue, 5 May 2020 04:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=K8IWI9DzBxrPMdckeIHVlixGFbex0KxJKk05q7cRdYE=;
 b=YyP116E55mCuEqlXdmVUwLANZbO/1fN+e2usOLhqsYTxW0zGg4iMZf/NgXHc4Oad3vHe
 FzJTpYgQOXtANgr+/BFAlk/NbLZXMLmMoBPTAqx3N1ggBh911ovLR0A/GRYhFO7GzxYQ
 cJKs6aJ2AQLScKl05KYGfYISnrn5ZUes+JCfDPyIRBB2BwnYp6RdxVe2vmAvLP4MeJ1+
 x/SGjJXoPqOCncAnWXLKpTCzBF9Wy9PCd7rIK5Ux+jX530CqC+ZjfSjCs9P3VL45g/qF
 5mJ7qwJFr41W9fDcAhBPyN8PnJHYX4ePYBrmyJN1hBywF9x+TbaTwdno+8l6ehZV6QCv Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30s09r2g9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 04:43:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0454asWE002355;
        Tue, 5 May 2020 04:41:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30sjds3xby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 04:41:37 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0454fZHr024520;
        Tue, 5 May 2020 04:41:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 21:41:35 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/7] scsi_debug: Add ZBC support
Date:   Tue,  5 May 2020 00:41:33 -0400
Message-Id: <158865357909.7634.13208088165240666827.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422104221.378203-1-damien.lemoal@wdc.com>
References: <20200422104221.378203-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050038
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 22 Apr 2020 19:42:14 +0900, Damien Le Moal wrote:

> This is the second part of the scsi_debug updates implementing ZBC
> support on top of Doug "per_host_store+random parameters, compare" patch
> series.
> 
> The ZBC emulation implemented allows to emulate both host-managed and
> host-aware disks with configurable zone size, number of conventional
> zones znd maximum number of open zones. One feature missing is the
> emulation of ZBC RC_BASIS which changes the behavior of the READ
> CAPACITY command. This is however not a critical point for testing as,
> to my knowledge, there are no disks using RC_BASIS on the market today.
> RC_BASIS emulation can thus be added as a later patch.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/7] scsi: scsi_debug: Add ZBC mode and VPD pages
      https://git.kernel.org/mkp/scsi/c/d36da3058ced
[2/7] scsi: scsi_debug: Add ZBC zone commands
      https://git.kernel.org/mkp/scsi/c/f0d1cf9378bd
[3/7] scsi: scsi_debug: Add ZBC module parameter
      https://git.kernel.org/mkp/scsi/c/9267e0eb41fe
[4/7] scsi: scsi_debug: Add zone_max_open module parameter
      https://git.kernel.org/mkp/scsi/c/380603a5bb83
[5/7] scsi: scsi_debug: Add zone_nr_conv module parameter
      https://git.kernel.org/mkp/scsi/c/aa8fecf96b70
[6/7] scsi: scsi_debug: Add zone_size_mb module parameter
      https://git.kernel.org/mkp/scsi/c/98e0a689868c
[7/7] scsi: scsi_debug: Implement ZBC host-aware emulation
      https://git.kernel.org/mkp/scsi/c/64e14ece0700

-- 
Martin K. Petersen	Oracle Linux Engineering
