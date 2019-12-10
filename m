Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686FFC2BD09
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 00:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40AD82071E
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 00:06:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="po7ej6FQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfLJAGq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 19:06:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52032 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfLJAGq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 19:06:46 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA04GhW031683;
        Tue, 10 Dec 2019 00:06:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=3s1yOhxXzIZ2EdKGgerVgQWxqiH1u5YZX4OXhPSEQz4=;
 b=po7ej6FQbAjQODWDACjuUl0jMaMtw9QSVUDT/VQ9cx/FXrKdoQJwApx3gNc0SeBNB5Yq
 kkO7VsiLsPtjIvhnfswH1hO5ZR+Bf5DGyTaPQBHYMLLLIfg0z0tgd08B+rDGv/1wgJf4
 P9GtYwtkw3UqVVjzu+O4W2JOL8tvOhaxzph3Doqai/XYAeRlsM06zHJFY86SsT/puNjN
 SIUapaSsiD0mcR1XOYraQzcOPsKOfAtUBFyREXHYJ3uWjpxxLaDMJnQ8/5mQR9YQ2aJu
 TvSuKFFsGSkTxQUFVbj9gR9ltbiT/9b8inmns5wZ35Oy6IPDaJ4bgk59dtCKA5xh3aBC qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wr41q2wq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 00:06:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA04D5D157892;
        Tue, 10 Dec 2019 00:06:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wsv8atg4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 00:06:38 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBA06bIx003934;
        Tue, 10 Dec 2019 00:06:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 16:06:36 -0800
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Don Brace <don.brace@microsemi.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] scsi: smartpqi: add missed free_irq in suspend
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191203111337.13054-1-hslester96@gmail.com>
Date:   Mon, 09 Dec 2019 19:06:34 -0500
In-Reply-To: <20191203111337.13054-1-hslester96@gmail.com> (Chuhong Yuan's
        message of "Tue, 3 Dec 2019 19:13:37 +0800")
Message-ID: <yq1fthtoxh1.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=836
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912090190
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=917 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912090191
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> The driver calls request_irq in resume but does not call free_irq in
> suspend.
> Add the missed call to fix it.

Microsemi: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
