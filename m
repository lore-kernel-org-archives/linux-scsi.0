Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3585EC46466
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3DAC20853
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O4yR+xv3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgJGDHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:07:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39110 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgJGDHg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:07:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09733tf2176285;
        Wed, 7 Oct 2020 03:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=SpqvUTc1JSIevtlxGlR/OvymXNJlO9t3p+BYhnP/fQs=;
 b=O4yR+xv3Hdfo5xVhtKWlfAz2F++lKDjJA2shPgffl8O7mxA3UhjwwabF8aPMLtcuafwt
 lyIOVeGgxQd8mTRWiO3PSfb8Wxk4WVEw1c9iP+rzMPO1iwl4LXNMd7tCpVyM+2PuJpwc
 LyYHEsJvdwOpZVC/b2XftCA8obeAU55bNlS1zAFvWd1LnvD4RefnHUYz0b2fFDdUbXEX
 ToLLI3MXNeV2ldZ+mOPmqhc87kKQyA0j6VIZljDReXr0PfyRNKfZx+tF5m4fzg7cwdaV
 wwXgcyzey/LIiI6PvoKhwDL6qsptUJC4JMuvb0gOwDT1HfBKe/sLvsBeRJyHAsy8KCo8 Bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33ym34mgc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:07:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09735H1u174326;
        Wed, 7 Oct 2020 03:05:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33y2vnwvq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:05:18 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09735AQA027537;
        Wed, 7 Oct 2020 03:05:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:05:10 -0700
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
        "Jamie Lenehan" <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <dc395x@twibble.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: dc395x: use module_pci_driver to simplify
 the code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lfgi68ir.fsf@ca-mkp.ca.oracle.com>
References: <20200917071044.1909268-1-liushixin2@huawei.com>
Date:   Tue, 06 Oct 2020 23:05:06 -0400
In-Reply-To: <20200917071044.1909268-1-liushixin2@huawei.com> (Liu Shixin's
        message of "Thu, 17 Sep 2020 15:10:44 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1011 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Liu,

> Use the module_pci_driver() macro to make the code simpler by
> eliminating module_init and module_exit calls.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
