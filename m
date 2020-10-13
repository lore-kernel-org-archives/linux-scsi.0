Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE10FC43457
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B90FA21D7F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:44:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0T787zYm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgJMWnx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:43:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42024 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbgJMWnm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:43:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMaCZq072213;
        Tue, 13 Oct 2020 22:43:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=MQErgiMFuUjel2il/rZVWHU+R7usaboAZpoaVAyYZ1k=;
 b=0T787zYmg8u1GLTLDhSxcQVSAjMI1yZK90lqzTlYzFcE7uXF6znxbTit4IfeQOHaPYoD
 3DQ7mgbUQLQ+2cewozYI3q56F6rDMf0sMRZ4fl0bMxeFyCQR/J93VU7s3ZCstUDJnKJL
 Si7wQXDgpcvYTLj8Rg/US0J4zVwJmJCulUJi4ZQKrjmoK1G9kWkBiM7PTJaLBfXUuWjO
 7VKJE7PGxKys/6qiZT/gfhyQljqX+saUmuXFkTUhnOwxr4khuP88e5RhevFGa64vB5dW
 FitRNm4Y48CYo/eY8BYp4b0qEaHqyMgt8y+5ZSG613v36DBKJzrH+clILb0PXBZx8laD LQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 343vaeb2d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:43:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMaXnu049179;
        Tue, 13 Oct 2020 22:43:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 343pvx1st3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:26 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09DMhI9X005796;
        Tue, 13 Oct 2020 22:43:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:17 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Ali Akcaagac <aliakc@web.de>, Liu Shixin <liushixin2@huawei.com>,
        Jamie Lenehan <lenehan@twibble.org>,
        Oliver Neukum <oliver@neukum.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        dc395x@twibble.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: dc395x: use module_pci_driver to simplify the code
Date:   Tue, 13 Oct 2020 18:42:53 -0400
Message-Id: <160262862430.3018.715081407309755647.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200917071044.1909268-1-liushixin2@huawei.com>
References: <20200917071044.1909268-1-liushixin2@huawei.com>
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

On Thu, 17 Sep 2020 15:10:44 +0800, Liu Shixin wrote:

> Use the module_pci_driver() macro to make the code simpler
> by eliminating module_init and module_exit calls.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: dc395x: Use module_pci_driver() to simplify the code
      https://git.kernel.org/mkp/scsi/c/75c31c80a77d

-- 
Martin K. Petersen	Oracle Linux Engineering
