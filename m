Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87BBC2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58AB82468E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:59:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w2FKmWJM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgKQD7G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 22:59:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47664 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgKQD7G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 22:59:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3fKxB138097;
        Tue, 17 Nov 2020 03:58:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=4uRHwmfKuuxRJtZVOun8/wC6aST5HhqMfBfPWZdhLFI=;
 b=w2FKmWJMDn7W2zOWNSHTLZAFPC8RinY2JluDg/+65GV+u5UHr9ST5NR/XM/UE9PQzvKS
 txSPzIsgrLn9fd+Iuy8CYS0UL1qUWTx7Yt0Fl5wnE3WIJUtddOWeyhQoC2eUl9vGaswM
 hXAXvThVomCjjvOIot5gUOFvAwBwA35wMAOV+LKZHPgPGMf/DkR3AWcGxqLFYa4eyFUb
 YCVGSNr2TEzjuIDqdjV7RKPyQs5B9qBQdfBfFHeZ6zdujXjB27BbhIqpjTPCDNSHALjs
 THxI83OX9//2Tp8vUDORdm3PBFxxeQYhbOJfnAjHoDuxxySzPfzT9NEetgptQrR2O6JZ /A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34t76kre6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 03:58:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3fIIv005297;
        Tue, 17 Nov 2020 03:58:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34umcxms51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 03:58:49 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AH3wmXN010018;
        Tue, 17 Nov 2020 03:58:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 19:58:47 -0800
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tom Rix <trix@redhat.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: remove obsolete variable in sd_remove()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14klo63ee.fsf@ca-mkp.ca.oracle.com>
References: <20201116070035.11870-1-lukas.bulwahn@gmail.com>
        <yq1ft5863ku.fsf@ca-mkp.ca.oracle.com>
Date:   Mon, 16 Nov 2020 22:58:45 -0500
In-Reply-To: <yq1ft5863ku.fsf@ca-mkp.ca.oracle.com> (Martin K. Petersen's
        message of "Mon, 16 Nov 2020 22:54:16 -0500")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> Commit 140ea3bbf39a ("sd: use __register_blkdev to avoid a modprobe
>> for an unregistered dev_t") removed blk_register_region(devt, ...) in
>> sd_remove() and since then, devt is unused in sd_remove().
>
> Applied to 5.11/scsi-staging, thanks!

Actually, this should go through block given the dependency on the
commit above.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
