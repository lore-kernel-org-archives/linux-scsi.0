Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A24C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 03:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96F46206D7
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 03:48:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fgX5CDFm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgFPDst (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 23:48:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44902 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgFPDss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 23:48:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3gl3P032215;
        Tue, 16 Jun 2020 03:48:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=vwvODkJiXkDu0RHV9yaz5FJiw7OuISFMIh90VNODvY0=;
 b=fgX5CDFmjkY77paSSh/ONDXDb07g7b5XLjJRvsaqe3Y/TivbxFstz22YgEfBm41XV8/0
 FHnAVNi5yxBi6XiFncNqj+SksR+g1t2ADNp7/3GeN4jAHEcPgIeNTg0hxNCoyhJv/OOe
 35feY2mpYLQb6JGKXvHridSh825eeRBjUJhrPobF8y0E/xDmR+448xIEJKScRI87MgaZ
 LQSLovJXg6sVrblmfUaHT5vaBBOp7Hgq4zkwzVlmJ8yqxEgX8/2951cdN8JQ8MkJermw
 7m9JpqZn1X5fgJr1XLptpjG2a7oEyte2e/bdIgU4RhclRsLm4TruXp/Q8m1GfDxQdmm7 bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31p6e7vcu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 03:48:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3dOQa089607;
        Tue, 16 Jun 2020 03:46:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31p6dc9se2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 03:46:33 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05G3kLJO017318;
        Tue, 16 Jun 2020 03:46:21 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 20:46:20 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH] scsi: ufs-bsg: Fix runtime PM imbalance on error
Date:   Mon, 15 Jun 2020 23:46:18 -0400
Message-Id: <159227896596.21874.15523624572708116010.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522045932.31795-1-dinghao.liu@zju.edu.cn>
References: <20200522045932.31795-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=1
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=1
 mlxscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 cotscore=-2147483648 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 22 May 2020 12:59:29 +0800, Dinghao Liu wrote:

> When ufs_bsg_alloc_desc_buffer() returns an error code,
> a pairing runtime PM usage counter decrement is needed
> to keep the counter balanced.

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: ufs-bsg: Fix runtime PM imbalance on error
      https://git.kernel.org/mkp/scsi/c/a1e17eb03e69

-- 
Martin K. Petersen	Oracle Linux Engineering
