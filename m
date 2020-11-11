Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19A5C388F7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 03:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C8AE206E3
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 03:01:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mt4mIAcx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgKKDBR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 22:01:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36798 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgKKDBQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 22:01:16 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2trtD060552;
        Wed, 11 Nov 2020 03:01:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sGQ+WOB8jJ9MH0N2kN5MhuEyrwBwJ7mZoyHRNsbPmyw=;
 b=Mt4mIAcx1PUWaV6YSGggp+eYqgDYlW6J2s2XGjFfs/3bDow2ofs425VHCffFccAOVaVp
 H9HgBEDcjCnErdQ6VlAP+Ir4svh9ovNEkCgwQe3S5fa/anlnuxC+/sYzck8JdB4WPQ0p
 rhbVIAc1ZrLhGSBDoGVu3cdgwHeuvywxrwWV3SMEN+u/QAf67qHWoyr8cji39TE6f+S8
 lXX33mxceMXTub01BpfLV+fJEnOXv4D7Tim4pd2iWaItUY2sUFmCx3sjy54fIMiJVLpC
 sJAYxVTkqj1YXdw9O2S7dy8n23O5mddRp76nk++RQ8eFpYliV5B7XE3KfXmzntLdA5gN OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72en4g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 03:01:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2t5fN184371;
        Wed, 11 Nov 2020 02:59:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34qgp7pq79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 02:59:12 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB2xBTc008398;
        Wed, 11 Nov 2020 02:59:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 18:59:11 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: tcmu: scatter_/gather_data_area rework
Date:   Tue, 10 Nov 2020 21:59:06 -0500
Message-Id: <160506354082.14637.11461453377174362789.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019115118.11949-1-bostroesser@gmail.com>
References: <20201019115118.11949-1-bostroesser@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=810
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=841 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 19 Oct 2020 13:51:18 +0200, Bodo Stroesser wrote:

> This is made on top of the scsi-staging tree plus my previous
> patch:
> "scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel"

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: target: tcmu: scatter_/gather_data_area() rework
      https://git.kernel.org/mkp/scsi/c/c8ed1ff88c02

-- 
Martin K. Petersen	Oracle Linux Engineering
