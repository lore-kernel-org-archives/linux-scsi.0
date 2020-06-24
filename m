Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0955C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 04:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C58352085B
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 04:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e3AtLp0V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgFXE3x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 00:29:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56630 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgFXE3w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 00:29:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4Lxk3030612;
        Wed, 24 Jun 2020 04:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ZiGEq8tgxFCP/EG5YJqGwbTBdHbsJ/jMej+HyBgyl34=;
 b=e3AtLp0VLdFtJMOPr1f0xoEwAD8czsXoHF8bUInpBn9n1hqEseQD1O5zyg+6N+iB8P04
 hDfYrAXovj059vc0TRZrqg2kyyTNx9Fltrnsgn3A7bqFhyrkwHJfHjZobMFYaYP+vD3T
 dvlNF5jkqiZ/SwvPkkCOpofPtJ0LsYXCEUDgG6ionobEqBKyAjxFJIwyiG8ONP0LKhpv
 WRYAh/znMQ+PfKgiAWo8GXyEkqKZw1S14DWkCRbRjWhymJh/7X/q3ndbTrQa990y3qhL
 bHA4g8ztnAB7y1fgii4en+7Y8euo8olp/bcojLTT5NUUT98xj5GjFLZ0LPrk5v1TPf/y 2g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31uustrkss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 24 Jun 2020 04:29:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4NGrt113298;
        Wed, 24 Jun 2020 04:29:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31uurq6ukr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jun 2020 04:29:47 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05O4TkUQ011156;
        Wed, 24 Jun 2020 04:29:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jun 2020 04:29:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH] qla2xxx: Set NVME status code for failed NVME FCP request
Date:   Wed, 24 Jun 2020 00:29:38 -0400
Message-Id: <159297296072.9797.7645368338109888920.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200604100745.89250-1-dwagner@suse.de>
References: <20200604100745.89250-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006240031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006240031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 4 Jun 2020 12:07:45 +0200, Daniel Wagner wrote:

> The qla2xxx driver knows when request was processed successfully or
> not. But it always sets the NVME status code to 0/NVME_SC_SUCCESS. The
> upper layer needs to figure out from the rcv_rsplen and
> transferred_length variables if the request was successfully. This is
> not always possible, e.g. when the request data length is 0, the
> transferred_length is also set 0 which is interpreted as success in
> nvme_fc_fcpio_done(). Let's inform the upper
> layer (nvme_fc_fcpio_done()) when something went wrong.
> 
> [...]

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: Set NVMe status code for failed NVMe FCP request
      https://git.kernel.org/mkp/scsi/c/ef2e3ec520a8

-- 
Martin K. Petersen	Oracle Linux Engineering
