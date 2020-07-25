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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624D7C433F4
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 382E32070E
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Se0gK69d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGYCv3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:51:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56766 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgGYCv3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 22:51:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2m65o043218;
        Sat, 25 Jul 2020 02:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=zyi2crWVmddrO9tCCfKTgU0S1x2jitpuQTf3y+lrDhM=;
 b=Se0gK69dTaTJ4L/ulr42CCpkiDMnzTyhDyVcdZMQaIyu38672jALqDELm+ozMLmLWLK7
 lrGYhojQHhqb9HF1PTShrMUCAfz0oH7olggThXn1jSoPpSN4bCRbmFO7ztAMI6zCryW0
 bEn6I7SFx5G2vOpw5QflOUx3+a2cgmb2SGwFxZqoj1sbSglmUg9oDRrxJ7xtpY+ugBfm
 Siq3WNOjvu0xhJ27BENroDVq8lzWlpySSKiDFYBmb0WPmF8LioCBZ86zGHfYWWp5ZXBR
 k3s36qvuhQDUemzOI56NY+1ZrBs45AXLw6PO+lgBsnhtEsffsuskrPlcg6paLnzduzdi Qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32bs1n1ush-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:51:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2pGcM125600;
        Sat, 25 Jul 2020 02:51:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32gc2h0k2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:51:20 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06P2osVj014819;
        Sat, 25 Jul 2020 02:50:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 02:50:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linmiaohe <linmiaohe@huawei.com>, jejb@linux.ibm.com, hare@suse.de
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: fcoe: use eth_zero_addr() to clear mac address
Date:   Fri, 24 Jul 2020 22:50:37 -0400
Message-Id: <159564519423.31464.8204663264674414964.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1595234344-13955-1-git-send-email-linmiaohe@huawei.com>
References: <1595234344-13955-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=797
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=821 malwarescore=0 clxscore=1011
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 20 Jul 2020 16:39:04 +0800, linmiaohe wrote:

> Use eth_zero_addr() to clear mac address insetad of memset().

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: fcoe: Use eth_zero_addr() to clear mac address
      https://git.kernel.org/mkp/scsi/c/e2289db1ccc6

-- 
Martin K. Petersen	Oracle Linux Engineering
