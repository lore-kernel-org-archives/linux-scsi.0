Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1214C83013
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82A0F20705
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:05:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jarbfAFR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgLAFFU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 00:05:20 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55654 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgLAFFT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 00:05:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14n95T008471;
        Tue, 1 Dec 2020 05:04:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sLfwWs5h+2eujvJJ6wOymHGWVwLZdB+JsrjBF6W5CtM=;
 b=jarbfAFRf6ej/PvTSoPNbSnyhnWtR+45TdmYQWAh3FeseM1BPGMzMPc2Cx/Vg73QN4r6
 Qo13+nSfzb4Y5g83hVzC0lodglU7ecpfNbqfmxRILZojFtV5CXuwd0gowzn5ZCi1L6cu
 tZ/49qXd5nGFBniWQgKltBZ6gMEvE1XuCoWXTWQTQ6n/5GD6GiTQ06+kmvbaUFZvkVcO
 rW75VgaIYlucXZbQoibkWjErhntosprxwn/SQwjMaFEPlICp7apPFyenCU11m7ESFuR7
 mlN6QUCiHxq3vuPIA0Us9nrKuB+By18tokFAKw6miJyDMzxNMG2f40ugCFJLull+MrcV 3w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2arqdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 05:04:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14o4bX114870;
        Tue, 1 Dec 2020 05:04:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3540exfcuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 05:04:35 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B154YRU022159;
        Tue, 1 Dec 2020 05:04:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 21:04:33 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     satishkh@cisco.com, Karan Tilak Kumar <kartilak@cisco.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, arulponn@cisco.com,
        linux-kernel@vger.kernel.org, sebaddel@cisco.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Validate io_req before others
Date:   Tue,  1 Dec 2020 00:04:23 -0500
Message-Id: <160636449895.25598.3014532298470447241.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201121023337.19295-1-kartilak@cisco.com>
References: <20201121023337.19295-1-kartilak@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=879
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=909 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 20 Nov 2020 18:33:37 -0800, Karan Tilak Kumar wrote:

> We need to check for a valid io_req before
> we check other data. Also, removing
> redundant checks.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: fnic: Validate io_req before others
      https://git.kernel.org/mkp/scsi/c/3256b4682386

-- 
Martin K. Petersen	Oracle Linux Engineering
