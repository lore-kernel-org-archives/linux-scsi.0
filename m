Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5FEC2BC11
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDAB620936
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:09:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IDc4AJjd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgIICJ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:09:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56006 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgIICJx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:09:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08929kId130948;
        Wed, 9 Sep 2020 02:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=61lXLzKnH+Di6gjmrgky7lh/Z/64jeuG4qmv9ASsX08=;
 b=IDc4AJjdyuB2knGen9Vkhb4r2NEHi3EtUarqUZbzOOLKTC2XmDzXNHqdQUIGi0rOW68h
 Pe4fCZ8F3VE8nQluD0WeqsJdazqR9reM05UdLgC50FOa49ycR1pWzzN9F0oB/XA4vhVF
 7AoqVkSeb2x20KcNos29qtyQNbkzHH8UHVRvhQ9LhETF9BuQ0ZS0i229CSqxLyEpTNpl
 /9B6uvlBsAsjIL1N8wTen8NHNYfnZEf2wZ8xR708XjvTTeOvFjLJFeJMMimsfc7dH2dv
 V4kt5PYjEF+7vwCksFsIMFjLxTEvRm/XOmiosAV8/SyIp/lE9mtvRsUDMQe1eDvvzCup lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33c23qy0ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:09:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089252WV095272;
        Wed, 9 Sep 2020 02:09:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33cmk53f2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:09:45 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08929eUf022857;
        Wed, 9 Sep 2020 02:09:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:09:40 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     QLogic-Storage-Upstream@cavium.com, jejb@linux.ibm.com,
        Xu Wang <vulab@iscas.ac.cn>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qedi: Remove redundant null check
Date:   Tue,  8 Sep 2020 22:09:19 -0400
Message-Id: <159961731706.5787.5843134400258546668.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200827092606.32148-1-vulab@iscas.ac.cn>
References: <20200827092606.32148-1-vulab@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=1 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 27 Aug 2020 09:26:06 +0000, Xu Wang wrote:

> Because kfree_skb already checked NULL skb parameter,
> so the additional check is unnecessary, just remove it.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: qedi: Remove redundant NULL check
      https://git.kernel.org/mkp/scsi/c/9535f2152ace

-- 
Martin K. Petersen	Oracle Linux Engineering
