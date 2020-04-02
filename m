Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0740AC43331
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 02:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1C652072E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 02:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gGvsCV8Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733230AbgDBCD4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Apr 2020 22:03:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58060 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgDBCD4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2020 22:03:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0322365m119902;
        Thu, 2 Apr 2020 02:03:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=GR+WbokzW0tww6Q13QQgKMfPKF/nHGacd9hlh7r4g+0=;
 b=gGvsCV8ZQEpcIAQZTUBwGxWZ/FYdQI02K3gSZD68LCUYzM3AaO7b+xzFF1L44Rr2Asyz
 d8wfHyLAqBah7EtNm7PORQbfwqQdF+JxE09fmXilzIhfJB1Fvap5cwXkeDQooSvDZCNT
 cpxuIgRRKCWrvd1Mnd+/RevHtsU4R6Nw5KZlHDFsaAIgFVVYgsQ/wqVgqndfISgbHCnL
 OFUKPAMXUXSQNYm9KgkGXuuQbUTWmVbqQMPky+oaxGfrp2sGyFrizfH4EFNmIXKGLYH1
 Uilc2PFJbquve3iduqdshwFbbfK4rXCTEI2zR0K5ZM13btoz/rBl73C5nV81LNzs+V9v Xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 303aqhs5f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 02:03:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032236qW075393;
        Thu, 2 Apr 2020 02:03:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 304sjn0jm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 02:03:25 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03223Lom032013;
        Thu, 2 Apr 2020 02:03:24 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Apr 2020 19:03:20 -0700
To:     Nikhil Kshirsagar <nkshirsa@redhat.com>
Cc:     martin.petersen@oracle.com, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: core: Add DID_ALLOC_FAILURE and DID_MEDIUM_ERROR to hostbyte_table
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <CAMNNMLFtQOHsjWUMs+q_+z9XqQYZmR34ewoB-5LrCpzGp1Ppkw@mail.gmail.com>
Date:   Wed, 01 Apr 2020 22:03:18 -0400
In-Reply-To: <CAMNNMLFtQOHsjWUMs+q_+z9XqQYZmR34ewoB-5LrCpzGp1Ppkw@mail.gmail.com>
        (Nikhil Kshirsagar's message of "Wed, 1 Apr 2020 09:25:00 +0530")
Message-ID: <yq14ku263vd.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9578 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9578 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020016
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nikhil,

> Since DID_ALLOC_FAILURE and DID_MEDIUM_ERROR are missing from the
> hostbyte_table, scsi debug logging prints their numeric values only.
> Adding them to the hostbyte_table to allow the scsi debug log to print
> those as strings.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
