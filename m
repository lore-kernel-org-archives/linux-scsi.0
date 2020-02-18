Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BF7C34033
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 05:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D125D207FD
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 05:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FWiDFcCP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgBRFYG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 00:24:06 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44994 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgBRFYG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 00:24:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01I5MnrX029163;
        Tue, 18 Feb 2020 05:24:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=TddR7qB30mPYR7p5Yi3+qWtRT79PIQvMIX0zxYZaw2A=;
 b=FWiDFcCP0uC+10I/42eOgBotrrpg/F7VfQhY/euSSjGK2hqh8l3k+977zT9PdqEVXgKC
 NmeeS3zlb7s7+lf0DTnkx+I2XHr1HlhT09r66EKUetomnFpWNEEDF50qGS52zaoL3Akq
 6tM43TdrRyqVJLIRwSt6RCt0kZB4KLhITjsj0h+uhLF/ovayMLzhmgbO0vXNdwV6OdMJ
 UIfZeg8MphqJXQZhCWaUqB36Ro3cVBenOB8iSpS5yaWBp4gdWzBghUOjDiT7AD00EfAj
 Bi/7P04JD9PYj/sqHHZjAKidSfIOfOZrONKCMd8XZqQAXtj5qNGWr6xHaw8YZbFn9iXn 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2y7aq5pb67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 05:24:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01I5MoWk013801;
        Tue, 18 Feb 2020 05:23:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2y82c0rf38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 05:23:59 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01I5NlU0002615;
        Tue, 18 Feb 2020 05:23:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Feb 2020 21:23:47 -0800
To:     Merlijn Wajer <merlijn@wizzup.org>
Cc:     linux-scsi@vger.kernel.org, Merlijn Wajer <merlijn@archive.org>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sr: get rid of sr global mutex
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200214135433.29448-1-merlijn@wizzup.org>
Date:   Tue, 18 Feb 2020 00:23:44 -0500
In-Reply-To: <20200214135433.29448-1-merlijn@wizzup.org> (Merlijn Wajer's
        message of "Fri, 14 Feb 2020 14:54:32 +0100")
Message-ID: <yq1a75gmpsv.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9534 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=890
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002180043
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9534 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1011 bulkscore=0
 phishscore=0 mlxlogscore=960 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002180043
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Merlijn,

> When replacing the Big Kernel Lock in commit
> 2a48fc0ab24241755dc93bfd4f01d68efab47f5a ("block: autoconvert trivial
> BKL users to private mutex"), the lock was replaced with a sr-wide
> lock.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
