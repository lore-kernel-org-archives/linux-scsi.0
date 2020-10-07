Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4793DC4363D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 02:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFAF2207EA
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 02:37:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tnoV3NjL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgJGChR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 22:37:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53676 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGChR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 22:37:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0972Z28A057228;
        Wed, 7 Oct 2020 02:37:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=BgyxMnkhAAvlEV7+8JwdG++McO42j0WB2Ul6Mt+sNEQ=;
 b=tnoV3NjLr4XyDV3/VOtSyxzrHKUVeHGicvK9bUT/99Fzsoj4HLvOrfAiTCfaO9cIbvnz
 R6n9q05mTLH8TtwaSRHy3fg49zP6J9bOa8uC30Xa9DsLFmh4lXNGZo1JuIvu1i5/Q0G4
 DB7v591SiQh33RLR0Hv1WiZy+rmg7ttW6Y2674vsr+E7YwQWhavNGBxzyfOswcHG3/+D
 PnyN2jm78I+gE/7y33acKlLMDQsqzDr6NbKWqZf+zWT+dNh5GspJ6lFNJaw8nyotURqr
 M7/7MN8sF7c02A0KUBxCMPSSQ8RMNHasWH/HrQlXdXLDdp7un7DnBhHdepp6bdH4/gbK Ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33xhxmy8vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 02:37:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0972VAOd094030;
        Wed, 7 Oct 2020 02:37:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33yyjgjc2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 02:37:13 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0972bCds025616;
        Wed, 7 Oct 2020 02:37:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 19:37:12 -0700
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: misc I/O submission cleanups
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wo0269tt.fsf@ca-mkp.ca.oracle.com>
References: <20201005084130.143273-1-hch@lst.de>
Date:   Tue, 06 Oct 2020 22:37:10 -0400
In-Reply-To: <20201005084130.143273-1-hch@lst.de> (Christoph Hellwig's message
        of "Mon, 5 Oct 2020 10:41:20 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=738 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=754 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> this series tidies up various loose ends in the SCSI I/O submission
> path.

Looks good! Applied to 5.10/scsi-staging except for the varlen patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
