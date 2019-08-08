Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD71C433FF
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 509D6217F4
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:52:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="3cUIkOy1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389714AbfHHBwx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Aug 2019 21:52:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389653AbfHHBww (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2019 21:52:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781o0aF138954;
        Thu, 8 Aug 2019 01:52:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=0HweoGIP9twY0ZpxIdqNNY4AvjCEOqsAyhf92D3CWUc=;
 b=3cUIkOy1j12h4biMXA6zIo+l0vPGGaDpiXGXaR/JRU5ncFkwWqZCSz2keGrjlfnEv4wj
 jgMtXWxZwTqVgLOF+4zIBVyvbdArXoumKYnQqey1XiNzL5QhAJJ2hS6bGFnsfPEVQt0P
 Ow4XocjyPHsGV5WzQRAI5YY53hJ5KhFNzNO2SIGmF8qDe5iRJnEEVDBHjVjeHvqC1aRn
 DTK3kzJOXbadSBIFZEZ4DRVPdbRfZoaCdf8HbtfGJCiwRGtGJ93ul3wGbyzXtCTQaNvy
 /5MnMCmUoSq1IN8BDYkaudk/0dorRVABr6cs1m4vZYXJvuEuFLMiGAErATcO8zHGIgNj lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u527pyh32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:52:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781lwYd143059;
        Thu, 8 Aug 2019 01:52:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2u7668a24y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:52:40 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x781qdiK015022;
        Thu, 8 Aug 2019 01:52:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Aug 2019 18:52:38 -0700
To:     Li Zhong <lizhongfs@gmail.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        martin.petersen@oracle.com, mchristi@redhat.com
Subject: Re: [RFC PATCH v2] target: tcmu: clean the nl_cmd of the udev when nl send fails
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <5D446BC2.9000303@redhat.com>
        <20190805004336.16181-1-lizhongfs@gmail.com>
Date:   Wed, 07 Aug 2019 21:52:36 -0400
In-Reply-To: <20190805004336.16181-1-lizhongfs@gmail.com> (Li Zhong's message
        of "Mon, 5 Aug 2019 08:43:36 +0800")
Message-ID: <yq1sgqcctjv.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=900
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=968 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080016
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Li,

> If the userspace process crashes while we send the nl msg, it is
> possible that the cmd in curr_nl_cmd of tcmu_dev never gets reset to
> 0, and and returns busy for other commands after the userspace process
> is restartd.

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
