Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B33C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4947421D7A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:45:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ol+hqX1/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgJMWpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:45:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43154 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbgJMWpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:45:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMaERM072220;
        Tue, 13 Oct 2020 22:45:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1RCh+hhKb9ypmUH8n/TjAXADjg7MQhjscPkjCXo2C3w=;
 b=ol+hqX1/qRb76vaIn8iYvXGZcMvuC1Z4X3nxMzUrJQWtTelgVwUUmNPThkBim/owPy/Z
 Mx4hKeEXkWt07v5c4rAGfZ7ypPnNcRLcwSDR+8eRWxlu7jbyL4xqTh3m1IEeOWtys8r1
 iT1a7HwC4f/wqb7Qbd/2svTknfZFXB1V62mrA/5YXxxs5I1x0aOgmZPvKwiwgzNs8/aU
 /2ZcsVGEHMixFczwk5SnGSG4E0PDcV+Iz3PMCnG/wJAKqvCukEGtr8DyaTo0i3MX7C0l
 M9hWa5UZLs3U2Ay2szFO2sTt19NrrNYG+rTwCT3GHjdBJQJPlzpWCVcTdv3lY1U/wjW/ Wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 343vaeb2j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:45:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMaWDS049105;
        Tue, 13 Oct 2020 22:43:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 343pvx1sqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:21 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09DMhKEe009979;
        Tue, 13 Oct 2020 22:43:20 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:19 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Liu Shixin <liushixin2@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: initio: use module_pci_driver to simplify the code
Date:   Tue, 13 Oct 2020 18:42:55 -0400
Message-Id: <160262862431.3018.8124522780060006681.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200917071045.1909320-1-liushixin2@huawei.com>
References: <20200917071045.1909320-1-liushixin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 17 Sep 2020 15:10:45 +0800, Liu Shixin wrote:

> Use the module_pci_driver() macro to make the code simpler
> by eliminating module_init and module_exit calls.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: initio: Use module_pci_driver() to simplify the code
      https://git.kernel.org/mkp/scsi/c/ca57b069954a

-- 
Martin K. Petersen	Oracle Linux Engineering
