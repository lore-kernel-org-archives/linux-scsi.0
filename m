Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BABC433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 02:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98590206C1
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 02:20:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DuNPXtqn";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w8l0pFHl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfHMCUg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 22:20:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43472 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfHMCUg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 22:20:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D2K1n4042110;
        Tue, 13 Aug 2019 02:20:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=hba2gepEKo0bZeRA3aJMVCV+uWaISD4FDvxbHhM7nWM=;
 b=DuNPXtqnMaH/y7hwcgT/JAMLtzY1GJgcG7MPztWImp2ZnU494Av5AO0LIfbLY9K4J8GT
 gJF5dsxLmOxFS/uYqg+jIh/9eJWyyAeWVS8llJqJZbm3ifxod2r6j+zZ8ShEWWI5TemA
 LUbaCU+nx6lmkSi0p8cbIj+NP/sPLoPjUnWkj2RFWEmhWI/gwBZsrKZhKfFwEZm49A44
 xe4goCJeM415/FQFB3xhBRvmecv9otrSoSbZqu4LT0rZwHj7OMHTRbvYBVhBN2G0P7a7
 vZvm4gPLGppRSnivO0NnssoiTPhHEJX8sDOesA0ct323ik9lhOjK9+vRWbIVWZNupcvD LA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=hba2gepEKo0bZeRA3aJMVCV+uWaISD4FDvxbHhM7nWM=;
 b=w8l0pFHlPmQPLmzyVIDgeOYdW49/usDaZM6Se8Rnn4Q4rSgXdbhZ+Hx9PsaTPA7uSHj9
 2SEJbcPxS9RIFiWRC7BlBEE0J0S21IH8eiIQAMbAYFaEhK081ZkSLf7rYTOIc9GEztLV
 xhHAuzGL+SoPZjCY/TFcirrPF66rKxcxKiaB/0oA8SXRQFNaCzECwJyX97ovIsllNKN0
 Yu1rx/O0boZ+f93k9bqqGwJvcvM2Ox+5KWLB1sFHQrAmOSGNAWddLEtHKdDh4/rUexU6
 b03mRDhuYa21bTK/JFVXeaDvNJGnFZzZnogPzDYSVx63QK9eDutGzouOzI/ggVDjOJyM yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u9pjqb1yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 02:20:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D2Ib9j150740;
        Tue, 13 Aug 2019 02:20:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2u9n9hk95f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 02:20:23 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7D2KHWv008378;
        Tue, 13 Aug 2019 02:20:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 19:20:16 -0700
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: use __u{8,16,32,64} instead of uint{8,16,32,64}_t in uapi headers
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190721142502.30599-1-yamada.masahiro@socionext.com>
Date:   Mon, 12 Aug 2019 22:20:14 -0400
In-Reply-To: <20190721142502.30599-1-yamada.masahiro@socionext.com> (Masahiro
        Yamada's message of "Sun, 21 Jul 2019 23:25:02 +0900")
Message-ID: <yq1mugd7qn5.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=937
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Masahiro,

> When CONFIG_UAPI_HEADER_TEST=y, exported headers are compile-tested to
> make sure they can be included from user-space.

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
