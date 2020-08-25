Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC3AC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 02:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85B1820706
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 02:16:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c/WQchzc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgHYCQA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 22:16:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60772 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgHYCP5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 22:15:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07P2FrwG096437;
        Tue, 25 Aug 2020 02:15:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=QGQM7sefIO+ydy+LQAEF/yz36N37BfZ09NB3x5Ctn84=;
 b=c/WQchzcBgt9HPHdsY9ej9Ju7mskQRXiR/x1XsQ9hcxe0nmtfbdRfNMZiuwVTt8AODDf
 HmDCpyXpyfdB4tkgirk+OVHCDINA0v5J0gsS6GUsoNpCH49+gipMveZZFUQ1qkhpkl7K
 LV/fUWqAKf724xrkP8IMDWD30V+PuG0iI9r0PC1UysL5rU6pVNX7kCppvQG4PirQDw6/
 jyw1m2jj8I3aLInfQxbK5BjzqGoTVTWF20HV5qtqF1Lbm7A4Bp2HQn2/ZEf5FsV3f8xZ
 7vEZoItCVz1FewJjnNp64a+/A2SQyGwrnuDqQwOpEOwxgQdEFjxRsDcUBua2NQqMu0kA RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 333w6tpah5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Aug 2020 02:15:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07P2BFaa190012;
        Tue, 25 Aug 2020 02:15:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 333r9hydqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 02:15:53 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07P2Fq9A025411;
        Tue, 25 Aug 2020 02:15:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Aug 2020 19:15:51 -0700
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v1] mpt3sas: Add support for Non-secure Aero and Sea PCI
 IDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1rvqxqe.fsf@ca-mkp.ca.oracle.com>
References: <20200814130426.2741171-1-sreekanth.reddy@broadcom.com>
        <yq1a6yoviti.fsf@ca-mkp.ca.oracle.com>
        <CAK=zhgq-5CNQObiwDutLPGG3CbmpAbj+RbDGX-xGu6mVP_WZYw@mail.gmail.com>
Date:   Mon, 24 Aug 2020 22:15:49 -0400
In-Reply-To: <CAK=zhgq-5CNQObiwDutLPGG3CbmpAbj+RbDGX-xGu6mVP_WZYw@mail.gmail.com>
        (Sreekanth Reddy's message of "Mon, 24 Aug 2020 15:53:10 +0530")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=1 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008250016
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> As explained in description the purpose of disabling support for these
> devices in the driver is to avoid interacting with any firmware which
> is not secured/signed by Broadcom.

I understand, but that should be a user decision.

What are these devices you want to disable support for? Why is their
firmware not signed?

-- 
Martin K. Petersen	Oracle Linux Engineering
