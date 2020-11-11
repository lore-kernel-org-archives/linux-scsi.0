Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF7EC5517A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 03:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFDA4221F1
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 03:00:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0AE6yk3w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgKKDAJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 22:00:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50884 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgKKDAJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 22:00:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2s58B158282;
        Wed, 11 Nov 2020 02:59:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=IZUOAKfYNbToYkNCjADQ6CIkzB8RfiuZx0eGXLLfpqE=;
 b=0AE6yk3wm+6LsZsHyqg1kar8TgrENQ3tC8azLvvju5k7xpARm2iR+19ZglJN4ovXOsG2
 wTktPH4dXVwcrRYKfB5CgswuGlgUBkSUSOhnpS4XbjnQemTPphDlXQmnS5lrE2z/g+cW
 gJCtushgYm9ANF72rMWRU29w2hEPPN1eZUuC+qokPqcwIr7HyfFhZJS0HBUHDdc9ottp
 9NqdKISl3jdzau3iM+jxXflPKOKU+r/RaIspm+QFUUyD9WvJQ7WszuN3WjAy9m7m5qr2
 hIpjsLqnKuO75NRxEaPXS9niCyMfXzsva9G7OVhq7QJcX3y9Ny001ZDVdc6ErW2G9K0h Zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34nkhkxwrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 02:59:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2u8r0079025;
        Wed, 11 Nov 2020 02:59:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34p5gxt62c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 02:59:22 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB2xGRS024098;
        Wed, 11 Nov 2020 02:59:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 18:59:16 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "trix@redhat.com" <trix@redhat.com>, ketan.mukadam@broadcom.com,
        intel-linux-scu@intel.com, njavali@marvell.com,
        yokota@netlab.is.tsukuba.ac.jp, willy@infradead.org,
        skashyap@marvell.com, jejb@linux.ibm.com, jhasan@marvell.com,
        brking@us.ibm.com, dick.kennedy@broadcom.com,
        don.brace@microchip.com, linux@highpoint-tech.com,
        subbu.seetharaman@broadcom.com, jitendra.bhivare@broadcom.com,
        hare@suse.de, Kai.Makisara@kolumbus.fi,
        artur.paszkiewicz@intel.com, james.smart@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, storagedev@microchip.com
Subject: Re: [PATCH] scsi: remove unneeded break
Date:   Tue, 10 Nov 2020 21:59:10 -0500
Message-Id: <160506354081.14637.17780811340617222979.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019142333.16584-1-trix@redhat.com>
References: <20201019142333.16584-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 19 Oct 2020 07:23:33 -0700, trix@redhat.com wrote:

> A break is not needed if it is preceded by a return or goto

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: Remove unneeded break statements
      https://git.kernel.org/mkp/scsi/c/170b7d2de29e

-- 
Martin K. Petersen	Oracle Linux Engineering
