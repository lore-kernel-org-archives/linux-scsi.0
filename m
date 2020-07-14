Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A06C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 05:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF6482193E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 05:01:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TcIoBP3z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgGNFBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 01:01:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44852 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgGNFBS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 01:01:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4uq2x135704;
        Tue, 14 Jul 2020 05:00:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=O8xtYPr2MyZwEpa7OXc/mSt1WCwqsGvNmvxpAJukmcU=;
 b=TcIoBP3zqPaberk8U+8lM5gD+UTHr1WMnxhtnaBXEFPvTD1AzJ5SYjuHaC6g+kSBU/BS
 e21FUJ0UTyywpD4KMSCcs58kafNX0As8Rs7oQKCzc9xwklGNM6kHnA96O3kdmgr25CvX
 g7CnkVt9jct+T7VMj6TT6wL1pD6pFfF0qsu5aU2cwbzl99k8l+TOzXnnI3XiWjCz+Buc
 DDLU6Bg3kpzdG1syNREvrlVK4p5DMWpiteGFkwg5vZh2vzfzwQBsa9eiOE3avsloMPaN
 01StOKyPWxgvSQmyq3w+M0bvLB39PZjrNUt4X2dBVSX+6Ilxdeag2cItjBYrzeUEU1ll DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32762natqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 05:00:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4vXMB173993;
        Tue, 14 Jul 2020 04:58:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 327qb2nug7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 04:58:52 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06E4woQm023621;
        Tue, 14 Jul 2020 04:58:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 21:58:50 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Varun Prakash <varun@chelsio.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org,
        Austin Kim <austindh.kim@gmail.com>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: cxgb4i: clean up a debug printk
Date:   Tue, 14 Jul 2020 00:58:40 -0400
Message-Id: <159470266468.11195.15363487048120250219.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200713105100.GA251988@mwanda>
References: <20200713105100.GA251988@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=875 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1011 priorityscore=1501 mlxlogscore=890 lowpriorityscore=0
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 13 Jul 2020 10:51:00 +0000 (UTC), Dan Carpenter wrote:

> The pr_fmt() at the top of the file already includes the __func__ so we
> can remove the duplicative "cxgbi_conn_init_pdu:" from the string here.
> Now it all fits on one  line as well.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: cxgb4i: Clean up a debug printk
      https://git.kernel.org/mkp/scsi/c/30f259b4886a

-- 
Martin K. Petersen	Oracle Linux Engineering
